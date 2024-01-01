' Test Regex usage in VBScript
'
' Created by Thomas Sharratt Copyright (C) 2023




' REGEX - INP FILES ONLY
Dim regexINP
Set regexINP = New RegExp
regexINP.Pattern = "*.inp"
regexINP.IgnoreCase = True
regexINP.Global = False


test1 = "Zc.mat"
test2 = "inductances.csv"
test3 = "coils.inp"

WScript.Echo test1 & regexINP.Test(test1)
WScript.Echo test2 & regexINP.Test(test2)
WScript.Echo test3 & regexINP.Test(test3)

Set regexINP = Nothing

Wscript.Echo "Finished"