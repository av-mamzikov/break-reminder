# Break Reminder

A lightweight application that displays reminder notifications prompting users to take regular breaks from their computer screen. It creates a popup window that reminds users to stand up, stretch, and rest their eyes from screen time, helping to prevent eye strain and physical discomfort associated with prolonged computer use.

✨ **Now with multi-language support!** The application automatically detects your system language and displays messages accordingly.

## Screenshot

![Break Reminder](screenshots/vb.png)

### Languages
The application supports 8 languages in total! See the Features section for the complete list.

## Features

- Simple, non-intrusive reminder popup with Yes/No buttons
- **Yes button** - Acknowledge the break and close
- **No button** - Opens Task Scheduler to change reminder schedule
- **X button** - Just closes without opening scheduler
- Language-independent Task Scheduler activation
- Configurable reminder intervals (1 hour, 2 hours, or custom)
- **Minute offset selection** - Choose specific minute within the hour (e.g., :00, :15, :30, :45)
- Easy to schedule with Windows Task Scheduler
- **Extensive language support** (8 languages):
  - English (en-US)
  - Russian (ru-RU)
  - French (fr-FR)
  - Spanish (es-ES)
  - German (de-DE)
  - Chinese (Simplified) (zh-CN)
  - Japanese (ja-JP)
  - Portuguese (Brazil) (pt-BR)
- Easily extensible with additional language translations
- Full Unicode support for all languages

## Requirements

- Windows operating system
- Windows Script Host (included in all Windows versions)
- No additional dependencies required

## Installation

### Easy Installation (Recommended)

1. Download the latest release from the [Releases page](https://github.com/av-mamzikov/break-reminder/releases) (Source code zip)
2. Extract the ZIP file to any location
3. Double-click the `Install-BreakReminder.bat` file
4. Follow the on-screen instructions to:
   - Install the application to your user profile (`%LOCALAPPDATA%\BreakReminder`)
   - Create an optional desktop shortcut
   - Set up automatic reminders at your preferred interval (1 hour, 2 hours, or custom)
   - Choose specific minute within the hour for reminders (e.g., :45 for quarter to the hour)
   - Select your preferred language
   - Uninstaller is automatically copied to installation directory

### Manual Installation

1. Clone this repository or download the script file:
   ```
   git clone https://github.com/av-mamzikov/break-reminder.git
   ```
2. No additional installation is required.

## Usage

### Running manually

1. Double-click the `break-reminder.vbs` file
   or
2. Run from command line:
   ```cmd
   wscript.exe "path\to\break-reminder.vbs"
   ```

### Language Options

```cmd
# Run with system language (default)
wscript.exe "path\to\break-reminder.vbs"

# Run with a specific language
wscript.exe "path\to\break-reminder.vbs" fr-FR
```

### Setting up scheduled reminders

#### Using the installer (recommended)
The installer can set up scheduled tasks for you automatically with your preferred interval.

#### Manual setup
To set up reminders manually:

1. Open Task Scheduler (taskschd.msc)
2. Click "Create Basic Task"
3. Enter a name (e.g., "Screen Break Reminder") and description, then click Next
4. Set your desired trigger (e.g., Daily, or every X hours), then click Next
5. Select "Start a program" and click Next
6. In Program/script field enter: `wscript.exe`
7. In Add arguments field enter: `"C:\path\to\break-reminder.vbs"`
8. Click Next, review the settings, and click Finish

## Uninstallation

To remove Break Reminder from your system:

1. Navigate to `%LOCALAPPDATA%\BreakReminder` or use the path shown during installation
2. Double-click the `Uninstall-BreakReminder.bat` file
3. Confirm the uninstallation
4. The uninstaller will safely:
   - Remove all scheduled tasks (BreakReminder_*)
   - Delete the desktop shortcut
   - Remove the installation directory
   
**Safety Features:**
- Multiple validation checks prevent accidental deletion of wrong directories
- Verifies the directory contains Break Reminder files before deletion
- Protects system directories from accidental removal

## Customization

You can modify the script to change:
- The reminder message (edit localization XML files)
- Button behavior
- Other visual elements

### Adding a New Language

1. Create a new XML file in the `localization` folder with the culture code as filename (e.g., `it-IT.xml`)
2. Use this template:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <resources>
     <string name="WindowTitle">Break Reminder</string>
     <string name="ReminderMessage">Take a break!

Stand up, stretch, and rest your eyes from the screen.

Yes - I'm taking a break
No - Change schedule</string>
     <string name="CloseButtonText">Taking a break!</string>
   </resources>
   ```
3. Translate the values to your target language (including button descriptions)
4. Make sure to save the file with UTF-8 encoding to ensure proper display of special characters

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
