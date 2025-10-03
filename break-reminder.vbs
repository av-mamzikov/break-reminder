Option Explicit

' Break Reminder - VBScript version
' This script displays a reminder notification prompting users to take regular breaks
' from their computer screen, helping to prevent eye strain and physical discomfort
' associated with prolonged computer use.

' Get script directory and set up file system object
Dim fso, scriptDir, WshShell
Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = CreateObject("WScript.Shell")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)

' Default strings (English)
Dim windowTitle, reminderMessage, closeButtonText
windowTitle = "Break Reminder"
reminderMessage = "Take a break! Stand up, stretch, and rest your eyes from the screen."
closeButtonText = "Close"

' Get system language or command line parameter
Dim language
language = GetLanguage()

' Load localized strings
LoadLocalizedStrings language

' Create and display the message box
CreateReminderPopup

' Function to get language from system or command line
Function GetLanguage()
    Dim defaultLang, args
    
    ' Try to get language from command line arguments
    Set args = WScript.Arguments
    If args.Count > 0 Then
        GetLanguage = args(0)
        Exit Function
    End If
    
    ' Try to get language from system locale
    On Error Resume Next
    defaultLang = WshShell.RegRead("HKEY_CURRENT_USER\Control Panel\International\LocaleName")
    If Err.Number <> 0 Then
        defaultLang = "en-US" ' Default to English
    End If
    On Error GoTo 0
    
    GetLanguage = defaultLang
End Function

' Function to load localized strings from XML files
Sub LoadLocalizedStrings(lang)
    Dim localizationDir, langFile
    localizationDir = scriptDir & "\localization"
    langFile = localizationDir & "\" & lang & ".xml"
    
    ' Check if language file exists
    If Not fso.FileExists(langFile) Then
        ' Fall back to en-US
        langFile = localizationDir & "\en-US.xml"
        If Not fso.FileExists(langFile) Then
            ' Use default strings if even en-US doesn't exist
            Exit Sub
        End If
    End If
    
    ' Create XML DOM object
    Dim xmlDoc
    Set xmlDoc = CreateObject("MSXML2.DOMDocument.6.0")
    xmlDoc.async = False
    xmlDoc.setProperty "SelectionLanguage", "XPath"
    
    ' Load and parse the XML file
    If xmlDoc.load(langFile) Then
        ' Get string values by name
        Dim titleNode, messageNode, buttonNode
        
        Set titleNode = xmlDoc.selectSingleNode("//string[@name='WindowTitle']")
        If Not titleNode Is Nothing Then
            windowTitle = titleNode.text
        End If
        
        Set messageNode = xmlDoc.selectSingleNode("//string[@name='ReminderMessage']")
        If Not messageNode Is Nothing Then
            reminderMessage = messageNode.text
        End If
        
        Set buttonNode = xmlDoc.selectSingleNode("//string[@name='CloseButtonText']")
        If Not buttonNode Is Nothing Then
            closeButtonText = buttonNode.text
        End If
    End If
End Sub

Sub CreateReminderPopup()
    Dim result
    result = MsgBox(reminderMessage, vbYesNo + vbQuestion + vbSystemModal, windowTitle)
    
    If result = vbNo Then
        WshShell.Run "taskschd.msc /s", 1, False        
        WScript.Sleep 1000
        On Error Resume Next
        WshShell.AppActivate "mmc.exe"
        On Error GoTo 0
    End If
End Sub
