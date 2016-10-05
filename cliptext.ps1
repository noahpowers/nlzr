function Invoke-ClipText()
{
    Add-Type -AssemblyName System.Windows.Forms
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Multiline = $true
    $textbox.Paste()
    $textbox.Text
}
