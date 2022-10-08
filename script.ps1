# -WindowStyle hidden
PowerShell.exe {

Start-Transcript -Path ".\log.txt"

Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form

$main_form.Text ='Save App'

$main_form.Width = 600

$main_form.Height = 400

$main_form.AutoSize = $false

#begin to draw list box
$ListBox = New-Object System.Windows.Forms.ListBox
$ListBox.Location = New-Object System.Drawing.Size(400,80)
$ListBox.Size = New-Object System.Drawing.Size(160,20)
$ListBox.Height = 80
$ListBox.Name = 'ListBox_UserName'
$main_form.Controls.Add($ListBox)

$AddButton = New-Object System.Windows.Forms.Button
$CheckButton = New-Object System.Windows.Forms.Button

function createButton($text, $locX, $locY, $Button) {

  $Button.Location = New-Object System.Drawing.Size($locX, $locY)

  $Button.Size = New-Object System.Drawing.Size(120,23)

  $Button.Text = $text

  $main_form.Controls.Add($Button)
}

createButton "Add File/Folder" 400 10 $AddButton
createButton "Check File/Folder" 400 50 $CheckButton

$AddButton.Add_Click({

  $shell = New-Object -ComObject Shell.Application

  $selectedfolder = $shell.BrowseForFolder( 0, 'Select a folder to proceed', 16, $shell.NameSpace( 17 ).Self.Path ).Self.Path

  Write-Host "filesizecounter: $selectedfolder"
  $ListBox.Items.Add($selectedfolder)
})

$CheckButton.Add_Click({
    'one','two','three','four' | Out-GridView -OutputMode Single
})

$main_form.ShowDialog()

}
