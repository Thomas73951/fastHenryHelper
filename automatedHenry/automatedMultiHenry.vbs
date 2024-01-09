' MODIFIED VERSION OF automatedHenry_withsaving.vbs - Expects root folder to contain 5 sweeps
' TODO: read amount of sweeps
'
' Recursively searches through root folder for .inp files which are then run with FastHenry2
' (FastHenry2 writes Zc.mat in the same folder as each .inp file upon completion)
' ^ Therefore recommended file structure is one .inp file per folder.
' Recommended folder name as ".../Offset,x,y/" - see fasthenryhelper/filegen/ & /plottingHenry/
' CSV write contains: folder name, filename, L1, L2, M
' CSV saves first frequency simulated.
'
' Notes:
' supports two coil files only (untested with others)
'
' Created by Thomas Sharratt Copyright (C) 2024
' from: listFilesInFolder.vbs by Thomas Sharratt Copyright (C) 2023
'       from: https://devblogs.microsoft.com/scripting/how-can-i-get-a-list-of-all-the-files-in-a-folder-and-its-subfolders/
' from: fhdriv.vbs in fasthenry2 (windows) / automation, file by Enrico Di Lorenzo, 2004/05/07 
' from: writeCSV.vbs by Thomas Sharratt Copyright (C) 2023 
'       from: https://www.tech-spy.co.uk/2021/01/list-files-in-a-folder-using-vbscript/


' FAST HENRY SETUP
Dim FastHenry2
' Create FastHenry2 object
Set FastHenry2 = CreateObject("FastHenry2.Document")

' Set folder to simulate
sweepFolder = "offset-test4" ' no "\"

' REGEX - INP FILES ONLY
Set regexINP = New RegExp
With regexINP
    .Pattern = ".*inp" ' may not be perfect, non "standard" regex implementation, so "*.inp" errors
    .IgnoreCase = True
    .Global = True
End With

' TEST FILE SETUP
' Extract script path from ScriptFullName Property
pathPos = InstrRev(Wscript.ScriptFullName, Wscript.ScriptName)
path = left(Wscript.ScriptFullName, pathPos-1)
testFilesFolder = path + "testfiles\offsetcoils\"
' setup folder of test files
Set sweepObjFSO = CreateObject("Scripting.FileSystemObject")
Set sweepObjFolder = sweepObjFSO.GetFolder(testFilesFolder + sweepFolder + "\")
Wscript.echo "Sweep folder" & sweepObjFolder
Set sweepColFiles = sweepObjFolder.Files

WScript.Echo "Setup complete, running..."

For i = 1 to 5
    ' WScript.echo "Sweep i=" & i

    Set objFSO = CreateObject("Scripting.FileSystemObject")
    indivSweepPath = sweepObjFolder + "\Sweep" + Cstr(i) + "\"
    ' WScript.echo "Trying to run " & indivSweepPath
    Set objFolder = objFSO.GetFolder(indivSweepPath)
    ' Wscript.echo "Running folder: " & objFolder
    Set colFiles = objFolder.Files


    ' OUTPUT FILE SETUP
    Dim fso, OutputFile
    ' Create a FileSystemObject  
    Set fso = CreateObject("Scripting.FileSystemObject")
    ' Create text file to output test data
    outputFolder = path + "testfiles\"
    outputFileName = outputFolder + sweepFolder + "_Sweep" + CStr(i) + "_inductances.csv"
    ' Wscript.echo outputFileName
    Set OutputFile = fso.CreateTextFile(outputFileName, True)
    ' RUN FASTHENRY FOR EACH .inp FILE
    RecursiveHenry objFolder ' run function with root folder

Next

' Runs FastHenry on all .inp files in root folder (inc. subfolders), saves results to CSV 
' Uses global: OutputFile, regexINP, FastHenry2.
Function RecursiveHenry(fldr) 
    Set colFiles = fldr.Files
    For Each objFile in colFiles
        'WScript.Echo objFile.Name ' prints filename

        If regexINP.Test(objFile.name) Then ' checks file is .inp
            filename = """" + fldr + "\" + objFile.name + """"
            ' WScript.Echo "Running filename: " & filename ' prints full path
            couldRun = FastHenry2.Run(filename)

            ' wait until finished
            Do While FastHenry2.IsRunning = True
                WScript.Sleep 500
            Loop

            ' collect results
            inductance = FastHenry2.GetInductance()
            If IsNull(inductance) Then
                Wscript.Echo "Error, FastHenry not run correctly, inductance is NULL"
            End If

            ' writes to csv. See fasthenry help on windows for details
            ' inductance(a, b, c) 
            ' a is frequency number from file
            ' b,c are Zc row/col
            L1 = CStr(inductance(0, 0, 0)) ' saves first frequency simulated (a = 0)
            L2 = CStr(inductance(0, 1, 1))
            M = CStr(inductance(0, 1, 0)) ' for 2 coils is the same as (0, (0, 1))
            ' saves: folder name, filename, L1, L2, M
            lineText = fldr & "," & objFile.name & "," & L1 & "," & L2 & "," & M
            OutputFile.WriteLine(lineText)
        End If
    Next

    For Each sf In fldr.SubFolders
        RecursiveHenry sf ' recursive call of subfolders
    Next

End Function

' Quit FastHenry2 & destroy object
FastHenry2.Quit
Set FastHenry2 = Nothing

' Close text file
OutputFile.Close

Wscript.Echo "Finished"
