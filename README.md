# Break Reminder

A PowerShell script that displays reminder notifications prompting users to take regular breaks from their computer screen. It creates a popup window that reminds users to stand up, stretch, and rest their eyes from screen time, helping to prevent eye strain and physical discomfort associated with prolonged computer use.

## Features

- Creates a popup notification that stays on top of other windows
- Displays a friendly reminder message to take a break
- Simple interface with a close button
- Can be scheduled to run at regular intervals

## Requirements

- Windows operating system
- PowerShell 5.1 or higher
- Windows Forms (included in Windows by default)

## Installation

1. Clone this repository or download the script file:
   ```
   git clone https://github.com/yourusername/break-reminder.git
   ```
2. No additional installation is required.

## Usage

### Running manually

1. Open PowerShell
2. Navigate to the directory containing the script
3. Run the script:
   ```powershell
   .\break-reminder.ps1
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

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
