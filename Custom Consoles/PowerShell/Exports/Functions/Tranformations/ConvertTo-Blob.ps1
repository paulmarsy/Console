function ConvertTo-Blob
{
	param(
		$InputObject
	)

	return [System.Convert]::FromBase64String($InputObject)
}