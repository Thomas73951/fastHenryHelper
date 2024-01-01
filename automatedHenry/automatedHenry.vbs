' SUPERSEDED BY automatedHenry_withsaving.vbs
' 
' Created by Thomas Sharratt Copyright (C) 2023
' from: listFilesInFolder.vbs by Thomas Sharratt Copyright (C) 2023
'       from: https://devblogs.microsoft.com/scripting/how-can-i-get-a-list-of-all-the-files-in-a-folder-and-its-subfolders/
' from: fhdriv.vbs in fasthenry2 (windows) / automation, file by Enrico Di Lorenzo, 2004/05/07 
' from: https://stackoverflow.com/questions/1172207/vbscript-type-mismatch

Dim FastHenry2
' Create FastHenry2 object
Set FastHenry2 = CreateObject("FastHenry2.Document")

' Extract script path from ScriptFullName Property
pathPos = InstrRev(Wscript.ScriptFullName, Wscript.ScriptName)
path = left(Wscript.ScriptFullName, pathPos-1)


' setup folder of test files
Set objFSO = CreateObject("Scripting.FileSystemObject")
testFilesFolder = path + "testfiles\"
Set objFolder = objFSO.GetFolder(testFilesFolder)
Set colFiles = objFolder.Files

For Each objFile in colFiles
    ' Wscript.Echo objFile.Name ' prints filename to console
    filename = """" + testFilesFolder + objFile.name + """"
    WScript.Echo "Running filename: " & filename
    couldRun = FastHenry2.Run(filename)

    ' wait until finished
    Do While FastHenry2.IsRunning = True
        Wscript.Sleep 500
    Loop

    ' collect results
    inductance = FastHenry2.GetInductance()
    ' echotext = "Coils" + objFile + " mutual inductance is " + inductance(0, 0, 1)
'    WScript.Echo inductance

    If Not IsNull(inductance) Then
         WScript.Echo CStr(inductance(0,0,1))
    End If
Next

' Quit FastHenry2 & destroy object
FastHenry2.Quit
Set FastHenry2 = Nothing

Wscript.Echo "Finished"
