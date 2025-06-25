# This PowerShell script displays a reminder notification prompting users to take regular breaks 
# from their computer screen. It creates a popup window that reminds users to stand up, stretch, 
# and rest their eyes from screen time, helping to prevent eye strain and physical discomfort 
# associated with prolonged computer use.
# To run from Windows Task Scheduler:
# 1. Open Task Scheduler (taskschd.msc)
# 2. Click "Create Basic Task"
# 3. Enter a name and description, then click Next
# 4. Set your desired trigger (e.g., Daily, At login), then click Next
# 5. Select "Start a program" and click Next
# 6. In Program/script field enter: powershell.exe
# 7. In Add arguments field enter: -ExecutionPolicy Bypass -File "C:\Users\amamzikov\Scripts\break-reminder.ps1"
# 8. Click Next, review the settings, and click Finish

#Requires -Version 5.1

# Set encoding for the current session
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms

# Create the form
$Form = New-Object Windows.Forms.Form
$Form.Text = "Напоминание"
$Form.TopMost = $true
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$Form.MinimumSize = New-Object System.Drawing.Size(300, 100)

# Create a TableLayoutPanel for better content arrangement
$TableLayout = New-Object System.Windows.Forms.TableLayoutPanel
$TableLayout.Dock = [System.Windows.Forms.DockStyle]::Fill
$TableLayout.AutoSize = $true
$TableLayout.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
$TableLayout.Padding = New-Object System.Windows.Forms.Padding(20)
$TableLayout.RowCount = 2
$TableLayout.ColumnCount = 1
[void]$TableLayout.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
[void]$TableLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 80)))
[void]$TableLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 20)))

# Create the label
$Label = New-Object Windows.Forms.Label
$Label.Text = "Сделай перерыв! Встань, разомнись, отдохни от экрана."
$Label.AutoSize = $true
$Label.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$Label.Anchor = [System.Windows.Forms.AnchorStyles]::None

# Add the label to the table layout
$TableLayout.Controls.Add($Label, 0, 0)

# Create a close button
$CloseButton = New-Object System.Windows.Forms.Button
$CloseButton.Text = "Пойду разомнусь!"
$CloseButton.AutoSize = $true
$CloseButton.Anchor = [System.Windows.Forms.AnchorStyles]::None
$CloseButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$CloseButton.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$CloseButton.Add_Click({ $Form.Close() })

# Add the button to the table layout
$TableLayout.Controls.Add($CloseButton, 0, 1)

# Add the table layout to the form
$Form.Controls.Add($TableLayout)

# Set form auto-size after adding all controls
$Form.AutoSize = $true
$Form.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink

$Form.ShowDialog()
