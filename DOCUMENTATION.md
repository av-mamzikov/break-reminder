# Break Reminder Documentation

## Overview

The Break Reminder script is designed to help users maintain healthy computer usage habits by providing timely reminders to take breaks. Regular breaks help prevent eye strain, repetitive strain injuries, and other health issues associated with prolonged computer use.

## Technical Details

### Script Components

The script uses Windows Forms to create a simple GUI notification with:
- A main form window that appears on top of other applications
- A message label with the break reminder text
- A close button to dismiss the notification
- TableLayoutPanel for proper element arrangement

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

### Running with Parameters

You can modify the script to accept parameters for customization:

```powershell
param(
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

## Troubleshooting

### Common Issues

1. **Script won't run due to execution policy**
   - Solution: Use `-ExecutionPolicy Bypass` when running from Task Scheduler

2. **Window doesn't appear**
   - Check if the script is running with proper permissions
   - Verify the script isn't being blocked by security software

3. **Text displays incorrectly**
   - Ensure the script file is saved with UTF-8 encoding

## Future Enhancements

Potential improvements for future versions:
- Configuration file for easy customization
- Sound notifications
- Customizable reminder intervals
- Statistics tracking for breaks taken/skipped
