$Services = Get-Service | where {($_.Name -like 'RJS*') -and ($_.StartType -eq 'Automatic')}
$UPN = ""
$Pwd = Get-Content ".\Cred.txt" | ConvertTo-SecureString
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UPN,$Pwd
$From = ""
$To = ""
$SMTPServer = "smtp.office365.com"
$SMTPPort="587"
$Services = foreach ($Service in $Services){
   
    While ($Service.Status -ne 'Running') {
        Start-Service $Service
        $Service.Refresh()

        if ($Service.Status -eq 'Running') {
            $Subject = "$Service failure on $env:computername"
            $Body = "$Service service successfully restarted."
            Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SMTPServer $SMTPServer -Port $SMTPPort -Credential $Credential -UseSSL
        }
        else {
            Start-Service $Service
            $Service.Refresh()
            $Subject = "$Service failure on $end:computername"
            $Body = "$Service service restart failed. Tryign again - please confirm on server."
            Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SMTPServer $SMTPServer -Port $SMTPPort -Credential $Credential -UseSSL
        }
    }
}
