' Test Regex usage in VBScript
'
' Created by Thomas Sharratt Copyright (C) 2023

' from: https://admhelp.microfocus.com/uft/en/all/VBScript/Content/html/d898bc7a-2169-4171-9d1b-941c72dac8eb.htm

Function RegExpTest(patrn, strng)
  Dim regEx, retVal            ' Create variable.
  Set regEx = New RegExp         ' Create regular expression.
  regEx.Pattern = patrn         ' Set pattern.
  regEx.IgnoreCase = False      ' Set case sensitivity.
  retVal = regEx.Test(strng)      ' Execute the search test.
  If retVal Then
    RegExpTest = "One or more matches were found."
  Else
    RegExpTest = "No match was found."
  End If
End Function
MsgBox(RegExpTest("is.", "IS1 is2 IS3 is4"))