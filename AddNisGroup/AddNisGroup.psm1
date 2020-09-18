#Requires -Modules ActiveDirectory

Import-Module ActiveDirectory

function Add-NisGroup {
	param (
		[Parameter(Mandatory=$true)][string]$sAMAccountName,
		[Parameter(Mandatory=$false)][string]$NISDomain
	)

	# Check our permissions - we need Admin
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	if (! $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		Write-Host "ERROR: I need Administrator privilege to run. Run your PowerShell as Administrator."
		Exit 1
	}

	# Fallback for NISDomain
	if (! $NISDomain) {
		$NISDomain = "int"
	}

	# Get user properties
	try {
		$GroupGIDNumber = (Get-ADGroup -Identity $sAMAccountName -Properties gidNumber).gidNumber
	}
	catch {
		Write-Host "ERROR: Unable to find user $sAMAccountName"
		Exit 1
	}

	# Check if we already have a GID
	if ($GroupGIDNumber ) {
		Write-Host "ERROR: Group $sAMAccountName already has GID $GroupGIDNumber"
		Exit 1
	}

	# Figure out all GIDs that were already assigned
	$AllGroupsProperties = Get-ADGroup -Filter 'gidNumber -like "*"' -Properties gidNumber
	$MaxGIDNumber = 0
	Foreach ($UserGIDNumber in $AllGroupsProperties.gidNumber) {
		if ($MaxGIDNumber -lt $UserGIDNumber) {
			$MaxGIDNumber = $UserGIDNumber
		}
	}

	# Choose new GID as max GID plus 1
	$GIDNumber = $MaxGIDNumber + 1

	# Update the user wuth Unix attributes
	try {
		Set-ADGroup -Identity $sAMAccountName -Add @{msSFU30Name="$sAMAccountName"; msSFU30NisDomain="$NISDomain"; gidNumber="$GIDNumber"} 
	}
	catch {
		Write-Host "ERROR: Unable to set attributes to user $sAMAccountName"
		Exit 1
	}

	Write-Host "User with sAMAccountName $sAMAccountName updated (GID set to $GIDNumber)"
}

Export-ModuleMember -Function Add-NisGroup

