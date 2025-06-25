# Break Reminder Documentation

## Overview

The Break Reminder script is designed to help users maintain healthy computer usage habits by providing timely reminders to take breaks. Regular breaks help prevent eye strain, repetitive strain injuries, and other health issues associated with prolonged computer use.

The script supports multiple languages through a flexible localization system that automatically detects the user's system language.

## Technical Details

### Script Components

The script uses Windows Forms to create a simple GUI notification with:
- A main form window that appears on top of other applications
- A message label with the break reminder text
- A close button to dismiss the notification
- TableLayoutPanel for proper element arrangement

### Localization System

The script implements a robust localization system:
- Language files stored in the `localization` directory as PowerShell Data Files (`.psd1`)
- Automatic detection of the user's system language
- Manual language selection via parameters
- Fallback to English if the requested language isn't available
- Easy extensibility for adding new languages

### System Requirements

- Windows operating system
- PowerShell 5.1 or higher
- .NET Framework (included in Windows)

### Encoding

The script uses UTF-8 encoding to properly display non-ASCII characters in the reminder message.

## Configuration Options

You can modify the following aspects of the script by editing the corresponding sections:

### Reminder Message

To change the reminder message, modify the `$Label.Text` property:

```powershell
$Label.Text = "Your custom reminder message here"
```

### Window Appearance

You can customize the window appearance by modifying these properties:
- `$Form.Text` - The window title
- `$Form.MinimumSize` - The minimum window size
- `$Form.FormBorderStyle` - The border style of the window
- `$Form.TopMost` - Whether the window stays on top of other windows

### Font and Styling

To change the font or styling of the message:
- Modify the font properties in the script where fonts are defined
- Adjust padding and margins in the TableLayoutPanel settings

## Advanced Usage

### Language Parameters

The script accepts the following parameters for language customization:

```powershell
param (
    [string]$Language = "",  # Specify a language code (e.g., "en-US", "fr-FR")
    [switch]$ListLanguages    # List all available languages
)
```

### Examples

```powershell
# Run with system language (default)
.\break-reminder.ps1

# Run with a specific language
.\break-reminder.ps1 -Language fr-FR

# List all available languages
.\break-reminder.ps1 -ListLanguages
```

### Additional Parameters

You can extend the script to accept more parameters for customization:

```powershell
param(
    [string]$Language = "",
    [switch]$ListLanguages,
    [string]$Message = "Default message",
    [int]$DisplayTime = 60
)
```

### Adding Auto-Close Functionality

To make the reminder automatically close after a certain time:

```powershell
# Add this after form creation
$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 60000  # 60 seconds
$Timer.Add_Tick({ $Form.Close(); $Timer.Stop() })
$Timer.Start()
```

## Localization Guide

### Available Languages

The script currently includes the following languages:
- English (en-US)
- Russian (ru-RU)

### Adding a New Language

1. Create a new `.psd1` file in the `localization` directory
2. Name the file with the appropriate culture code (e.g., `de-DE.psd1` for German)
3. Use this template structure:

```powershell
@{
    WindowTitle = "Break Reminder"        # Window title
    ReminderMessage = "Take a break!..." # Main message text
    CloseButtonText = "Close"            # Text on the close button
}
```

4. Translate all values to the target language

### Language File Structure

Each language file is a PowerShell Data File (`.psd1`) containing a hashtable with string keys. The keys must match exactly what the script expects:

| Key | Description |
|-----|-------------|
| `WindowTitle` | The text displayed in the window title bar |
| `ReminderMessage` | The main reminder message displayed to the user |
| `CloseButtonText` | The text on the button that closes the reminder |

## Troubleshooting

### Common Issues

1. **Script won't run due to execution policy**
   - Solution: Use `-ExecutionPolicy Bypass` when running from Task Scheduler

2. **Window doesn't appear**
   - Check if the script is running with proper permissions
   - Verify the script isn't being blocked by security software

3. **Text displays incorrectly**
   - Ensure the script file is saved with UTF-8 encoding
   
4. **Language not working**
   - Verify the language file exists in the `localization` directory
   - Check that the language code is correct (e.g., "en-US", not "en")
   - Ensure the language file contains all required keys

## Future Enhancements

Potential improvements for future versions:
- Configuration file for easy customization
- Sound notifications
- Customizable reminder intervals
- Statistics tracking for breaks taken/skipped
- Additional language translations
- Right-to-left (RTL) language support
- Custom fonts for different scripts (e.g., Cyrillic, Arabic, CJK)
- Language-specific formatting options
