function ConvertFrom-Blob
{
	param(
		[byte[]]$InputObject
	)

	return [System.Convert]::ToBase64String($InputObject)
}