' List files from sub directory (testfiles) to terminal.
'
' Created by Thomas Sharratt Copyright (C) 2023
' from: https://devblogs.microsoft.com/scripting/how-can-i-get-a-list-of-all-the-files-in-a-folder-and-its-subfolders/
' from: fhdriv.vbs in fasthenry2 (windows) / automation, file by Enrico Di Lorenzo, 2004/05/07 
' from: https://stackoverflow.com/questions/14950475/recursively-access-subfolder-files-inside-a-folder

' Extract script path from ScriptFullName Property
pathPos = InstrRev(Wscript.ScriptFullName, Wscript.ScriptName)
path = left(Wscript.ScriptFullName, pathPos-1)




Set objFSO = CreateObject("Scripting.FileSystemObject")

testFilesFolder = path + "\testfiles"

Set objFolder = objFSO.GetFolder(testFilesFolder)

TraverseFolders objFolder ' run function with root folder

Function TraverseFolders(fldr) 
    ' looks through all subfolders of root folder and prints all filenames 
    Set colFiles = fldr.Files
    For Each objFile in colFiles
        ' print full path for each file
        Wscript.Echo fldr & "\" & objFile.Name
    Next

  For Each sf In fldr.SubFolders
    TraverseFolders sf ' recursive call of subfolders
  Next

End Function