# Break Reminder

A PowerShell script that displays reminder notifications prompting users to take regular breaks from their computer screen. It creates a popup window that reminds users to stand up, stretch, and rest their eyes from screen time, helping to prevent eye strain and physical discomfort associated with prolonged computer use.

✨ **Now with multi-language support!** The script automatically detects your system language and displays messages accordingly.

## Screenshots

![Russian Break Reminder](screenshots/image.png)

### Other Languages
The application supports 8 languages in total! See the Features section for the complete list.

## Features

- Simple, non-intrusive reminder popup
- Configurable message and appearance
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

## Requirements

- Windows operating system
- PowerShell 5.1 or higher
- Windows Forms (included in Windows by default)

## Installation

### Easy Installation (Recommended)

1. Download the latest release from the [Releases page](https://github.com/av-mamzikov/break-reminder/releases)
2. Extract the ZIP file to any location
3. Double-click the `Install-BreakReminder.bat` file
4. Follow the on-screen instructions to:
   - Install the application to your user profile
   - Create an optional desktop shortcut
   - Set up automatic reminders at your preferred interval

### Manual Installation

1. Clone this repository or download the script file:
   ```
   git clone https://github.com/av-mamzikov/break-reminder.git
   ```
2. Ensure you have PowerShell 5.1 or higher installed

### PowerShell Execution Policy

By default, Windows restricts the execution of PowerShell scripts. You have several options to run the script:

#### Option 1: Temporary bypass for a single execution

```powershell
powershell -ExecutionPolicy Bypass -File "path\to\break-reminder.ps1"
```

#### Option 2: Change execution policy for your user account

Open PowerShell as Administrator and run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

This allows you to run local scripts without signing, but requires downloaded scripts to be signed by a trusted publisher.

#### Option 3: Unblock the script file

Right-click the script file → Properties → Check the "Unblock" box → Apply

3. No additional installation is required.

## Usage

### Running manually

1. Open PowerShell
2. Navigate to the directory containing the script
3. Run the script:
   ```powershell
   .\break-reminder.ps1
   ```

### Language Options

```powershell
# Run with system language (default)
.\break-reminder.ps1

# Run with a specific language
.\break-reminder.ps1 -Language fr-FR

# List all available languages
.\break-reminder.ps1 -ListLanguages
```

### Setting up scheduled reminders

To run the script automatically at regular intervals:

1. Open Task Scheduler (taskschd.msc)
2. Click "Create Basic Task"
3. Enter a name (e.g., "Screen Break Reminder") and description, then click Next
4. Set your desired trigger (e.g., Daily, or every X hours), then click Next
5. Select "Start a program" and click Next
6. In Program/script field enter: `powershell.exe`
7. In Add arguments field enter: `-ExecutionPolicy Bypass -File "C:\path\to\break-reminder.ps1"`
   (Replace with the actual path to the script)
8. Click Next, review the settings, and click Finish

## Customization

You can modify the script to change:
- The reminder message
- Window appearance and size
- Display duration
- Other visual elements

### Adding a New Language

1. Create a new file in the `localization` folder with the culture code as filename (e.g., `fr-FR.psd1`)
2. Use this template:
   ```powershell
   @{
       WindowTitle = "Break Reminder"
       ReminderMessage = "Take a break! Stand up, stretch, and rest your eyes from the screen."
       CloseButtonText = "Close"
   }
   ```
3. Translate the values to your target language

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
