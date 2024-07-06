' FOR STANDARD SWEEPS (expects 5 sweeps)

' TODO: support any number of sweeps
' Front matter from automatedHenry_multi.vbs:
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
' from: automatedHenry_multi.vbs by Thomas Sharratt Copyright (C) 2024
' from: https://stackoverflow.com/questions/5729903/vb-script-error-path-path-not-found800a004c


' Set folder to simulate (USER DEFINED)
coil1Folder = "C1_T16_ID20_S1_W0.4\"
coil2Folder = "C2_T20_ID0.2_S0.1_W0.03\"
' folder put in fastHenryHelper\results\

' FAST HENRY SETUP
Dim FastHenry2
' Create FastHenry2 object
Set FastHenry2 = CreateObject("FastHenry2.Document")


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
path = left(Wscript.ScriptFullName, pathPos-2)
path = left(path, InStrRev(path, "\")) ' PATH points to root git folder "....fastHenryHelper/"
testFilesFolder = path + "testfiles\offsetcoilsbiglittle\"
' setup folder of test files
Set sweepObjFSO = CreateObject("Scripting.FileSystemObject")
Set sweepObjFolder = sweepObjFSO.GetFolder(testFilesFolder + coil1Folder + coil2Folder)
Wscript.echo "Reading Sweep folders from " & sweepObjFolder
Set sweepColFiles = sweepObjFolder.Files

' SETUP OUTPUT FOLDER
resultsFolder = "results\" + coil1Folder + coil2Folder ' no path
outputFolder = path + resultsFolder
resultsFolderName = left(resultsFolder, len(resultsFolder) - 1) ' removes last "\"

' create output folder path if it doesn't exist
Dim outputFolderfso, pathBuild
Set outputFolderfso = CreateObject("Scripting.FileSystemObject")
folders = Split(resultsFolderName, "\")
pathbuild = path
' WScript.echo pathbuild
For i = 0 To UBound(folders)
    pathBuild = outputFolderfso.BuildPath(pathBuild, folders(i))
    ' WScript.echo "pathbuild: " & pathBuild
    If NOT outputFolderfso.FolderExists(pathBuild) Then
        ' WScript.echo "Didn't exist, creating"
        outputFolderfso.CreateFolder(pathBuild)
        If Err Then
            Err.Clear
            strErr = SPOFOLDERFAIL
            rCode = 4
        End If
    End If
Next


WScript.Echo "Setup complete, running..."

For i = 1 to 5 ' Run each of the five sweeps saving results to individual CSV files
    ' WScript.echo "Sweep i=" & i

    ' Create new file system object with "root" folder of each sweep directory in turn
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    indivSweepPath = sweepObjFolder + "\Sweep" + Cstr(i) + "\"
    ' WScript.echo "Trying to run " & indivSweepPath
    Set objFolder = objFSO.GetFolder(indivSweepPath)
    ' Wscript.echo "Running folder: " & objFolder
    Set colFiles = objFolder.Files

    ' OUTPUT CSV FILE SETUP
    Dim fso, OutputFile
    Set fso = CreateObject("Scripting.FileSystemObject")

    outputFileName = outputFolder + "Sweep" + CStr(i) + "_inductances.csv"
    ' Wscript.echo outputFileName
    Set OutputFile = fso.CreateTextFile(outputFileName, True)

    ' RUN FASTHENRY FOR All .inp FILES IN SWEEP FOLDER
    RecursiveHenry objFolder ' run function with root folder

Next

' Function to do the recursive folder searching and running of fasthenry
' Gets run once for each sweep
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
