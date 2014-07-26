function Send-Note {
	[CmdletBinding()]
    param(
    	[Parameter(Mandatory=$true)][ValidateSet("Work", "Home")]$To,
        [Parameter(Mandatory=$true,ValueFromRemainingArguments=$true)][string]$Body
    )

    $password = ConvertTo-SecureString $ProfileConfig.EMail.Password
    $credential = New-Object System.Management.Automation.PSCredential ($ProfileConfig.EMail.Username, $password)

    $emailTo = switch ($To) {
    	"Work" { "paulm@asos.com" }
    	"Home" { "paul@marston.me" }
    }

	Send-MailMessage -To $emailTo -Subject "Note" -Body $Body -UseSsl -Port 587 -From $ProfileConfig.EMail.From -Credential $credential
}