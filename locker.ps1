Function Generate-Form {

    Add-Type -AssemblyName System.Windows.Forms    

    # Build Form
    $objForm = New-Object System.Windows.Forms.Form
    $objForm.Text = "Crypt0|ocker"
    $objForm.Size = New-Object System.Drawing.Size(660,440)

    # Add Label
    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(200,50) 
    $objLabel.Size = New-Object System.Drawing.Size(400,150)
    $objLabel.Text = "
        Thanks for supporting the cause.  
            
        You have 2 choices to get your company's files out of our hands.  
                
        Either call (xxx) xxx-xxxx for more details 
                    
            or 
                
        pay up$$."
    $objForm.Controls.Add($objLabel)

    # Show the form
    $objForm.Show()| Out-Null

    # wait 5 seconds
    Start-Sleep -Seconds 15

    # destroy form
    $objForm.Close() | Out-Null

}

generate-form
