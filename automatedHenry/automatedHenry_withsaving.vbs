' List files from sub directory (testfiles) to terminal.
'
' Created by Thomas Sharratt Copyright (C) 2023
' from: listFilesInFolder.vbs by Thomas Sharratt Copyright (C) 2023
'       from: https://devblogs.microsoft.com/scripting/how-can-i-get-a-list-of-all-the-files-in-a-folder-and-its-subfolders/
' from: fhdriv.vbs in fasthenry2 (windows) / automation, file by Enrico Di Lorenzo, 2004/05/07 
' from: writeCSV.vbs by Thomas Sharratt Copyright (C) 2023 
'       from: https://www.tech-spy.co.uk/2021/01/list-files-in-a-folder-using-vbscript/

' TODO: fix - it runs Zc.mat at the end cause it appears in the folder.

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

' RUN FASTHENRY FOR EACH .inp FILE
For Each objFile in colFiles
    'WScript.Echo objFile.Name ' prints filename to console
    filename = """" + testFilesFolder + objFile.name + """"
    WScript.Echo "Running filename: " & filename
    couldRun = FastHenry2.Run(filename)

    ' wait until finished
    Do While FastHenry2.IsRunning = True
        WScript.Sleep 500
    Loop

    ' collect results
    inductance = FastHenry2.GetInductance()
    If Not IsNull(inductance) Then
        ' WScript.Echo CStr(inductance(0,0,1)) ' optional print
	End If

    ' writes to csv.
    lineText = objFile + "," + CStr(inductance(0, 0, 1))
    OutputFile.WriteLine(lineText)
Next

' Quit FastHenry2 & destroy object
FastHenry2.Quit
Set FastHenry2 = Nothing

' Close text file
OutputFile.Close

Wscript.Echo "Finished"'
