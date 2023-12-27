' List files from sub directory (testfiles) to terminal.
'
' Created by Thomas Sharratt Copyright (C) 2023
' from: https://devblogs.microsoft.com/scripting/how-can-i-get-a-list-of-all-the-files-in-a-folder-and-its-subfolders/
' from: fhdriv.vbs in fasthenry2 (windows) / automation, file by Enrico Di Lorenzo, 2004/05/07 


' Extract script path from ScriptFullName Property
pathPos = InstrRev(Wscript.ScriptFullName, Wscript.ScriptName)
path = left(Wscript.ScriptFullName, pathPos-1)


Set objFSO = CreateObject("Scripting.FileSystemObject")

testFilesFolder = path + "\testfiles"

Set objFolder = objFSO.GetFolder(testFilesFolder)

Set colFiles = objFolder.Files
For Each objFile in colFiles
    Wscript.Echo objFile.Name
Next
