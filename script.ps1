# -WindowStyle hidden
PowerShell.exe {

#Start-Transcript -Path ".\log.txt"

Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form

$main_form.Text ='Save App'

$main_form.Width = 600

$main_form.Height = 400

$main_form.AutoSize = $false

#Set the MaximizeBox to false to remove the maximize box.
$main_form.MaximizeBox = $false;

#Set the MinimizeBox to false to remove the minimize box.
$main_form.MinimizeBox = $false;

$main_form.FormBorderStyle = 'Fixed3D'

# label
$objLabel = New-Object System.Windows.Forms.label
$objLabel.Location = New-Object System.Drawing.Size(7,10)
$objLabel.Size = New-Object System.Drawing.Size(130,15)
$objLabel.BackColor = "Transparent"
$objLabel.ForeColor = "yellow"
$objLabel.Text = "Enter Computer Name"
$main_form.Controls.Add($objLabel)

#begin to draw list box
$ListBox = New-Object System.Windows.Forms.ListBox
$ListBox.Location = New-Object System.Drawing.Size(200,100)
$ListBox.Size = New-Object System.Drawing.Size(250,100)
$ListBox.Height = 120
$ListBox.Name = 'ListBox_UserName'
$main_form.Controls.Add($ListBox)

$AddButton = New-Object System.Windows.Forms.Button
$CheckButton = New-Object System.Windows.Forms.Button
$RemoveButton = New-Object System.Windows.Forms.Button

function createButton($text, $locX, $locY, $Button) {

  $Button.Location = New-Object System.Drawing.Size($locX, $locY)

  $Button.Size = New-Object System.Drawing.Size(120,23)

  $Button.Text = $text

  $main_form.Controls.Add($Button)
}

createButton "Add File/Folder" 400 10 $AddButton
createButton "Check File/Folder" 400 50 $CheckButton
createButton "Remove Path" 400 30 $RemoveButton

$AddButton.Add_Click({

  $shell = New-Object -ComObject Shell.Application

  $selectedPath = $shell.BrowseForFolder( 0, 'Select a file/folder to save', 16, $shell.NameSpace( 17 ).Self.Path ).Self.Path
  $selectedPathDest = $shell.BrowseForFolder( 0, 'Select a destination', 16, $shell.NameSpace( 17 ).Self.Path ).Self.Path

  Write-Host "filesizecounter: $selectedPath"

  $PathDisk = $selectedPath[0]
  $PathDestDisk = $selectedPathDest[0]

  $splitSelectedPath = $selectedPath.Split("\\")[-1]
  $splitSelectedPathDest = $selectedPathDest.Split("\\")[-1]

  $ListBox.Items.Add("(" + $PathDisk + ") " + $splitSelectedPath + " -> (" + $PathDestDisk + ") " + $splitSelectedPathDest)
})

$CheckButton.Add_Click({
    'one','two','three','four' | Out-GridView -OutputMode Single
})

$RemoveButton.Add_Click({
    $ListBox.Items.RemoveAt($ListBox.SelectedIndex)
})

$main_form.ShowDialog()

}
