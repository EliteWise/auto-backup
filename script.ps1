PowerShell.exe -WindowStyle hidden {

#Start-Transcript -Path ".\log.txt"

Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form

$main_form.Text ='Auto Backup'

$main_form.Width = 500

$main_form.Height = 320

$main_form.AutoSize = $false

#Set the MaximizeBox to false to remove the maximize box.
$main_form.MaximizeBox = $false;

#Set the MinimizeBox to false to remove the minimize box.
$main_form.MinimizeBox = $false;

$main_form.FormBorderStyle = 'Fixed3D'

# Draw list box
$ListBox = New-Object System.Windows.Forms.ListBox
$ListBox.Location = New-Object System.Drawing.Size(80,70)
$ListBox.Size = New-Object System.Drawing.Size(250,100)
$ListBox.Height = 120
$ListBox.Name = 'ListBox'
$main_form.Controls.Add($ListBox)

# Input to time scheduled task
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(200,200)
$textBox.Size = New-Object System.Drawing.Size(40,20)
$main_form.Controls.Add($textBox)

$PathLabel = New-Object System.Windows.Forms.label
$TimeLabel = New-Object System.Windows.Forms.label
$HoursLabel = New-Object System.Windows.Forms.label

function createLabel($text, $locX, $locY, $Label, $fontSize) {

  $Label.Location = New-Object System.Drawing.Size($locX, $locY)
  $Label.Size = New-Object System.Drawing.Size(100,30)
  $Label.ForeColor = "Black"
  $Label.Text = $text
  $Label.Font = New-Object System.Drawing.Font("Arial Black",$fontSize,[System.Drawing.FontStyle]::Regular)

  $main_form.Controls.Add($Label)
}

$AddButton = New-Object System.Windows.Forms.Button
$RemoveButton = New-Object System.Windows.Forms.Button
$SaveTimeButton = New-Object System.Windows.Forms.Button

function createButton($text, $locX, $locY, $Button) {

  $Button.Location = New-Object System.Drawing.Size($locX, $locY)

  $Button.Size = New-Object System.Drawing.Size(120,23)

  $Button.Text = $text

  $main_form.Controls.Add($Button)
}

createLabel "Paths List" 150 30 $PathLabel 12
createLabel "Backup every " 100 200 $TimeLabel 9
createLabel "Hours" 245 200 $HoursLabel 9

createButton "Add File/Folder" 340 85 $AddButton
createButton "Remove Path" 340 145 $RemoveButton
createButton "Save" 150 235 $SaveTimeButton

$AddButton.Add_Click({

  $shell = New-Object -ComObject Shell.Application

  $selectedPath = $shell.BrowseForFolder( 0, 'Select a file/folder to save', 16, $shell.NameSpace( 17 ).Self.Path ).Self.Path
  $selectedPathDest = $shell.BrowseForFolder( 0, 'Select a destination', 16, $shell.NameSpace( 17 ).Self.Path ).Self.Path

  # Log in Console
  Write-Host "filesizecounter: $selectedPath"

  # Disk Name (C / D)..
  $PathDisk = $selectedPath[0]
  $PathDestDisk = $selectedPathDest[0]

  # Extract the name of the file/folder
  $splitSelectedPath = $selectedPath.Split("\\")[-1]
  $splitSelectedPathDest = $selectedPathDest.Split("\\")[-1]

  # Display "Path -> PathDest"
  $ListBox.Items.Add("(" + $PathDisk + ") " + $splitSelectedPath + " -> (" + $PathDestDisk + ") " + $splitSelectedPathDest)
})

$RemoveButton.Add_Click({
    $ListBox.Items.RemoveAt($ListBox.SelectedIndex)
})

$SaveTimeButton.Add_Click({
    $BackupTime = @{Time = $textBox.Text}
    $BackupTime | ConvertTo-Json | out-file -FilePath .\data.json
})

$main_form.ShowDialog()

}
