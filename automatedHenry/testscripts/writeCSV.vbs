' Writes some data to a CSV and saves in current directory
'
' Created by Thomas Sharratt Copyright (C) 2023 
' from: https://www.tech-spy.co.uk/2021/01/list-files-in-a-folder-using-vbscript/


Dim fso, OutputFile

' Create a FileSystemObject  
Set fso = CreateObject("Scripting.FileSystemObject")

' Create text file to output test data
Set OutputFile = fso.CreateTextFile("ScriptOutput.csv", True)

' Loop through each file  
For i = 1 to 5
    lineText = "file " + i + ", somedata"
    OutputFile.WriteLine(lineText)
Next

' Close text file
OutputFile.Close
