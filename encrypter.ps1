Add-Type -assembly System.Windows.Forms

function RotateString {
    param (
        [string]$text,
        [string]$shift
    )

    $shifted = $shift -replace 'rot', ''
    $numshift = [int]$shifted

    if (-not $text) {
        return ""
    }

    if ($numshift -lt 1 -or $numshift -gt 25) {
        throw "Shift must be from 1 to 25"
    }

    $lowercase = 'abcdefghijklmnopqrstuvwxyz'.ToCharArray()
    $uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.ToCharArray()
    $output = ""

    foreach ($char in $text.ToCharArray()) {
        if ($lowercase.Contains($char)) {
            $index = [array]::IndexOf($lowercase, $char)
            $newIndex = ($index + $numshift) % 26
            $newChar = $lowercase[$newIndex]
        } elseif ($uppercase.Contains($char)) {
            $index = [array]::IndexOf($uppercase, $char)
            $newIndex = ($index + $numshift) % 26
            $newChar = $uppercase[$newIndex]
        } else {
            $newChar = $char  # keep non-alpha chars
        }

        $output += $newChar
    }

    Write-Host $output
    return $output
}

$MainForm = New-Object System.Windows.Forms.Form
$MainForm.Text = "Encrypter"
$MainForm.Width = 100
$MainForm.Height = 100
$MainForm.AutoSize = $true
$MainForm.Icon = New-Object System.Drawing.Icon(".\Encrypt.ico")

# encryption algorithm selection box
$ComboBox = New-Object System.Windows.Forms.ComboBox

$rotVariations = New-Object System.Collections.ArrayList
for ($i = 1; $i -le 25; $i++)
{
    [void]$rotVariations.Add("rot" + $i);
}

$ToConvertBox = New-Object System.Windows.Forms.TextBox
$ToConvertBox.Location = New-Object System.Drawing.Point(0, 20)
$ToConvertBox.Size = New-Object System.Drawing.Size(300, 50)
$ToConvertBox.Multiline = $true
$MainForm.Controls.Add($ToConvertBox)

$ComboBox.DataSource = $rotVariations
$ComboBox.Location = New-Object System.Drawing.Point(0, 80)
$MainForm.Controls.Add($ComboBox)

$ConvertedBox = New-Object System.Windows.Forms.TextBox
$ConvertedBox.Location = New-Object System.Drawing.Point(0, 110)
$ConvertedBox.Size = New-Object System.Drawing.Size(300, 50)
$ConvertedBox.Multiline = $true
$MainForm.Controls.Add($ConvertedBox)

$ConvertButton = New-Object System.Windows.Forms.Button
$ConvertButton.Text = "Convert"
$ConvertButton.Location = New-Object System.Drawing.Point(130, 80)
$ConvertButton.Add_Click({
    $ConvertedBox.Text = RotateString -text $ToConvertBox.Text -shift $ComboBox.SelectedItem
})
$MainForm.Controls.Add($ConvertButton)

$ClipboardButton = New-Object System.Windows.Forms.Button
$ClipboardButton.Text = "Copy"
$ClipboardButton.Location = New-Object System.Drawing.Point(0, 170)
$ClipboardButton.Add_Click({
    if ($ConvertedBox.Text) {
        Set-Clipboard -Value $ConvertedBox.Text
    }
})
$MainForm.Controls.Add($ClipboardButton)

$MainForm.ShowDialog()
