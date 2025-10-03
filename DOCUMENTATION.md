# Break Reminder Documentation

## Overview

Break Reminder is a lightweight application designed to help users maintain healthy computer usage habits by providing timely reminders to take breaks. Regular breaks help prevent eye strain, repetitive strain injuries, and other health issues associated with prolonged computer use.

The application is built with VBScript and supports multiple languages through a flexible XML-based localization system that automatically detects the user's system language.

## Technical Details

### Application Version

#### VBScript Implementation
The application uses a simple message box dialog with:
- No visible console window
- Standard Windows message box (MsgBox function)
- System modal dialog that stays on top of other windows
- OK/Cancel buttons for user interaction:
  - **OK button**: User acknowledges the break reminder
  - **Cancel button**: Opens Windows Task Scheduler to modify the reminder schedule
- Language-independent Task Scheduler activation using process name (mmc.exe)

### Localization System

The application implements a robust localization system:
- Language files stored in the `localization` directory as XML files (`.xml`)
- Automatic detection of the user's system language
- Manual language selection via parameters
- Fallback to English if the requested language isn't available
- Easy extensibility for adding new languages
- Full Unicode support for all languages

### System Requirements

- Windows operating system
- Windows Script Host (included in all Windows versions)
- No additional dependencies required

### Encoding

The script uses UTF-8 encoding to properly display non-ASCII characters in the reminder message.

## Configuration Options

### Installer

The installer (`install.ps1`) provides several configuration options:
- Create desktop shortcuts
- Set up scheduled tasks with customizable intervals
- Select preferred language

### Customizing the VBScript Version

You can modify the following aspects by editing the VBScript:

#### Reminder Message

To change the reminder message, modify the XML localization files in the `localization` directory.

#### Button Behavior

The Cancel button opens Task Scheduler. You can modify the command in the script:
```vbscript
WshShell.Run "taskschd.msc /s", 1, False
```

## Advanced Usage

### Language Parameters

The VBScript accepts a language code as a command-line argument:

```
wscript.exe "path\to\break-reminder.vbs" fr-FR
```

### Examples

```
# Run with system language (default)
wscript.exe "path\to\break-reminder.vbs"

# Run with a specific language
wscript.exe "path\to\break-reminder.vbs" fr-FR
```


## Localization Guide

### Available Languages

The application currently includes the following languages:
- English (en-US)
- Russian (ru-RU)
- German (de-DE)
- Spanish (es-ES)
- French (fr-FR)
- Japanese (ja-JP)
- Portuguese (Brazil) (pt-BR)
- Chinese (Simplified) (zh-CN)

### Adding a New Language

1. Create a new `.xml` file in the `localization` directory
2. Name the file with the appropriate culture code (e.g., `de-DE.xml` for German)
3. Use this template structure:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<resources>
  <string name="WindowTitle">Break Reminder</string>
  <string name="ReminderMessage">Take a break!

Stand up, stretch, and rest your eyes from the screen.</string>
  <string name="CloseButtonText">Taking a break!</string>
</resources>
```

4. Translate all values to the target language
5. Make sure to save the file with UTF-8 encoding to ensure proper display of special characters

### Language File Structure

Each language file is an XML file (`.xml`) containing string resources. The element names must match exactly what the application expects:

| Element | Description |
|-----|-------------|
| `<string name="WindowTitle">` | The text displayed in the window title bar |
| `<string name="ReminderMessage">` | The main reminder message displayed to the user |
| `<string name="CloseButtonText">` | The text on the button that closes the reminder |

## Troubleshooting

### Common Issues

1. **Window doesn't appear**
   - Check if the application is running with proper permissions
   - Verify the script isn't being blocked by security software
2. **Text displays incorrectly**
   - Ensure the XML localization files are saved with UTF-8 encoding
   - Make sure you're using MSXML2.DOMDocument.6.0 which supports Unicode
   
3. **Language not working**
   - Verify the language file exists in the `localization` directory
   - Check that the language code is correct (e.g., "en-US", not "en")
   - Ensure the language file contains all required string elements
   
4. **Task Scheduler doesn't come to foreground**
   - The script uses `AppActivate "mmc.exe"` to bring Task Scheduler to front
   - This is language-independent and works across all Windows versions

## Future Enhancements

Potential improvements for future versions:
- Configuration file for easy customization
- Customizable reminder intervals
- Statistics tracking for breaks taken/skipped
- Additional language translations
- Right-to-left (RTL) language support
- Custom fonts for different scripts (e.g., Cyrillic, Arabic, CJK)
- Language-specific formatting options
- Cross-platform support (macOS, Linux)
- Mobile version
- Integration with productivity tools
- Customizable break activities and suggestions
