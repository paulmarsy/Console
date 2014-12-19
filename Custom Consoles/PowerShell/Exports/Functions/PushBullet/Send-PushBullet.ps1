function Send-PushBullet
{
	param(
		$Title = "Sent from PowerShell",
		[Parameter(Mandatory=$true, Position = 0, ValueFromRemainingArguments=$true)][string]$Message
	)

	DynamicParam
    {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]

        $defaultParameter = New-Object System.Management.Automation.ParameterAttribute
        $defaultParameter.ParameterSetName = "__AllParameterSets"                
        $attributeCollection.Add($defaultParameter)

        $deviceListAttribute = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList (Get-PushBulletDevices)
		$attributeCollection.Add($deviceListAttribute)

        $deviceParameter = New-Object System.Management.Automation.RuntimeDefinedParameter('Device', [string], $attributeCollection)
        $paramDictionary.Add('Device', $deviceParameter)

        return $paramDictionary
    }

	PROCESS {
		$body = @{type = "note"; title = $Title;  body = $Message }
		if ($PSBoundParameters.ContainsKey("Device")) {
			$body.device_iden = _Get-PushBulletDevices | ? Name -eq $PSBoundParameters.Device | % Id
		}
		$bodyJson = ConvertTo-Json -InputObject $body -Compress

		Write-Host -ForegroundColor Gray "Sending PushBullet: $Title - $Message"

		$result = _Send-PushBulletApiRequest -Method Post -Uri "https://api.pushbullet.com/v2/pushes" -Body $bodyJson
		if ($null -eq $result) { return }

		if ($result.Active -eq "True") {
			Write-Host -ForegroundColor Green "PushBullet successfully sent"
		} else {
			Write-Error "Unknown state of PushBullet API call"
			Format-List -InputObject $result | Out-Host
		}
	}
}