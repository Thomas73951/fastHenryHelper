' List files from sub directory (testfiles) to terminal.
'
' Created by Thomas Sharratt Copyright (C) 2023
' from: listFilesInFolder.vbs by Thomas Sharratt Copyright (C) 2023
'       from: https://devblogs.microsoft.com/scripting/how-can-i-get-a-list-of-all-the-files-in-a-folder-and-its-subfolders/
' from: fhdriv.vbs in fasthenry2 (windows) / automation, file by Enrico Di Lorenzo, 2004/05/07 

Dim FastHenry2
' Create FastHenry2 object
Set FastHenry2 = CreateObject("FastHenry2.Document")

' Extract script path from ScriptFullName Property
pathPos = InstrRev(Wscript.ScriptFullName, Wscript.ScriptName)
path = left(Wscript.ScriptFullName, pathPos-1)


' setup folder of test files
Set objFSO = CreateObject("Scripting.FileSystemObject")
testFilesFolder = path + "\testfiles"
Set objFolder = objFSO.GetFolder(testFilesFolder)
Set colFiles = objFolder.Files

For Each objFile in colFiles
    ' Wscript.Echo objFile.Name ' prints filename to console

    couldRun = FastHenry2.Run("""" + testFilesFolder + objFile.name + ".inp""")

    ' wait until finished
    Do While FastHenry2.IsRunning = True
        script.Sleep 500
    Loop

    ' collect results
    inductance = FastHenry2.GetInductance()
    WScript.Echo "Coils" + objFile + " mutual inductance is " + CStr(inductance(0, 0, 1))
Next

' Quit FastHenry2 & destroy object
FastHenry2.Quit
Set FastHenry2 = Nothing