' List files from sub directory (testfiles) to terminal.
'
' Created by Thomas Sharratt Copyright (C) 2023
' from: listFilesInFolder.vbs by Thomas Sharratt Copyright (C) 2023
'       from: https://devblogs.microsoft.com/scripting/how-can-i-get-a-list-of-all-the-files-in-a-folder-and-its-subfolders/
' from: fhdriv.vbs in fasthenry2 (windows) / automation, file by Enrico Di Lorenzo, 2004/05/07 
' from: writeCSV.vbs by Thomas Sharratt Copyright (C) 2023 
'       from: https://www.tech-spy.co.uk/2021/01/list-files-in-a-folder-using-vbscript/


' FAST HENRY SETUP
Dim FastHenry2
' Create FastHenry2 object
Set FastHenry2 = CreateObject("FastHenry2.Document")

' TEST FILE SETUP
' Extract script path from ScriptFullName Property
pathPos = InstrRev(Wscript.ScriptFullName, Wscript.ScriptName)
path = left(Wscript.ScriptFullName, pathPos-1)
' setup folder of test files
Set objFSO = CreateObject("Scripting.FileSystemObject")
testFilesFolder = path + "testfiles\"
Set objFolder = objFSO.GetFolder(testFilesFolder)
Set colFiles = objFolder.Files

' OUTPUT FILE SETUP
Dim fso, OutputFile
' Create a FileSystemObject  
Set fso = CreateObject("Scripting.FileSystemObject")
' Create text file to output test data
Set OutputFile = fso.CreateTextFile("mutualinductances.csv", True)

WScript.Echo "Setup complete, running..."

' RUN FASTHENRY FOR EACH .inp FILE
TraverseFolders objFolder ' run function with root folder

Function TraverseFolders(fldr) 
    ' looks through all subfolders of root folder and prints all filenames 
    Set colFiles = fldr.Files
    For Each objFile in colFiles
        'WScript.Echo objFile.Name ' prints filename to console
        If Not objFile.name = "Zc.mat" Then ' checks file isn't Zc.mat
            filename = """" + fldr + "\" + objFile.name + """"
            ' WScript.Echo "Running filename: " & filename
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
            L1 = CStr(inductance(0, 0, 0))
            L2 = CStr(inductance(0, 1, 1))
            M = CStr(inductance(0, 1, 0)) ' for 2 coils is the same as (0, (0, 1))
            lineText = objFile.name & "," & L1 & "," & L2 & "," & M & "," & L4
            OutputFile.WriteLine(lineText)
        End If
    Next

  For Each sf In fldr.SubFolders
    TraverseFolders sf ' recursive call of subfolders
  Next

End Function

' Quit FastHenry2 & destroy object
FastHenry2.Quit
Set FastHenry2 = Nothing

' Close text file
OutputFile.Close

Wscript.Echo "Finished"'
