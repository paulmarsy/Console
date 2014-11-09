function Confirm-InstallSetting {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true, Position=1)]$SettingDescription
	)

	$choices = [System.Management.Automation.Host.ChoiceDescription[]](
		(New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Approve this installation setting."),
		(New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Decline this installation setting.")
	)

	$result = $Host.UI.PromptForChoice("Console installation setting requires confirmation...", $SettingDescription, $choices, 0) 

	switch ($result)
    {
        0 { return $true }
        1 { return $false }
    }
}