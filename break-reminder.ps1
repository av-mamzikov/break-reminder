# This PowerShell script displays a reminder notification prompting users to take regular breaks 
# from their computer screen. It creates a popup window that reminds users to stand up, stretch, 
# and rest their eyes from screen time, helping to prevent eye strain and physical discomfort 
# associated with prolonged computer use.

#Requires -Version 5.1

param (
    [string]$Language = "",
    [switch]$ListLanguages
)

# Set encoding for the current session
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms

# Function to get the script directory regardless of where it's run from
function Get-ScriptDirectory {
    $scriptPath = $MyInvocation.MyCommand.Path
    if (!$scriptPath) { $scriptPath = $script:MyInvocation.MyCommand.Path }
    if (!$scriptPath) { $scriptPath = $PSCommandPath }
    if ($scriptPath) {
        return Split-Path -Parent $scriptPath
    } else {
        Write-Warning "Could not determine script directory"
        return $pwd.Path
    }
}

# Get the script directory
$scriptDir = Get-ScriptDirectory
$localizationDir = Join-Path -Path $scriptDir -ChildPath "localization"

# If ListLanguages switch is used, display available languages and exit
if ($ListLanguages) {
    Write-Host "Available languages:"
    Get-ChildItem -Path $localizationDir -Filter "*.xml" | ForEach-Object {
        $langCode = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        Write-Host "  $langCode"
    }
    exit
}

# Determine which language to use
if ([string]::IsNullOrEmpty($Language)) {
    # Use system language if no language specified
    $Language = (Get-Culture).Name
}

# Default strings (English)
$strings = @{
    WindowTitle = "Break Reminder"
    ReminderMessage = "Take a break! Stand up, stretch, and rest your eyes from the screen."
    CloseButtonText = "Close"
}

# Check if the language file exists, otherwise fall back to en-US
$languageFile = Join-Path -Path $localizationDir -ChildPath "$Language.xml"
if (-not (Test-Path $languageFile)) {
    Write-Host "Language '$Language' not found. Falling back to en-US."
    $Language = "en-US"
    $languageFile = Join-Path -Path $localizationDir -ChildPath "$Language.xml"
}

# Load the language strings from XML if the file exists
if (Test-Path $languageFile) {
    try {
        [xml]$xmlDoc = Get-Content -Path $languageFile -Encoding UTF8
        $strings.WindowTitle = $xmlDoc.SelectSingleNode("//string[@name='WindowTitle']").InnerText
        $strings.ReminderMessage = $xmlDoc.SelectSingleNode("//string[@name='ReminderMessage']").InnerText
        $strings.CloseButtonText = $xmlDoc.SelectSingleNode("//string[@name='CloseButtonText']").InnerText
    }
    catch {
        Write-Warning "Error loading language file: $_"
    }
}

# Create the form
$Form = New-Object Windows.Forms.Form
$Form.Text = $strings.WindowTitle
$Form.TopMost = $true
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$Form.MinimumSize = New-Object System.Drawing.Size(400, 80)
$Form.MaximumSize = New-Object System.Drawing.Size(500, 250)

# Create a TableLayoutPanel for better content arrangement
$TableLayout = New-Object System.Windows.Forms.TableLayoutPanel
$TableLayout.Dock = [System.Windows.Forms.DockStyle]::Fill
$TableLayout.AutoSize = $true
$TableLayout.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
$TableLayout.Padding = New-Object System.Windows.Forms.Padding(20, 10, 20, 10)
$TableLayout.RowCount = 2
$TableLayout.ColumnCount = 1
[void]$TableLayout.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
[void]$TableLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 70)))
[void]$TableLayout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 30)))

# Create the label
$Label = New-Object Windows.Forms.Label
$Label.Text = $strings.ReminderMessage
$Label.AutoSize = $true
$Label.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$Label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$Label.Dock = [System.Windows.Forms.DockStyle]::Fill
$Label.Anchor = [System.Windows.Forms.AnchorStyles]::None

# Create a close button
$CloseButton = New-Object Windows.Forms.Button
$CloseButton.Text = $strings.CloseButtonText
$CloseButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$CloseButton.Dock = [System.Windows.Forms.DockStyle]::Fill
$CloseButton.AutoSize = $false
$CloseButton.Height = 40
$CloseButton.Padding = New-Object System.Windows.Forms.Padding(5)
$CloseButton.Margin = New-Object System.Windows.Forms.Padding(20, 5, 20, 5)
$CloseButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$CloseButton.BackColor = [System.Drawing.Color]::LightSkyBlue
$CloseButton.ForeColor = [System.Drawing.Color]::Black
$CloseButton.Add_Click({ $Form.Close() })

# Add the label to the table layout
$TableLayout.Controls.Add($Label, 0, 0)

# Add the button to the table layout
$TableLayout.Controls.Add($CloseButton, 0, 1)

# Add the table layout to the form
$Form.Controls.Add($TableLayout)

# Set form auto-size after adding all controls
$Form.AutoSize = $true
$Form.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink

# Show the form
$Form.ShowDialog()
