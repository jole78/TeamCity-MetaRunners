function Build-Arguments {
  $parameters = @()

  $parameters += "install"
  $parameters += "%NuGetInstaller.Package%"

  if([String]::IsNullOrWhiteSpace("%NuGetInstaller.Version%") -eq $false) {
    $parameters += "-Version"
    $parameters += "%NuGetInstaller.Version%"
  }
  
  if([String]::IsNullOrWhiteSpace("%NuGetInstaller.OutputDirectory%") -eq $false) {
    $parameters += "-OutputDirectory"
    $parameters += "%NuGetInstaller.OutputDirectory%"
  }
  
  if([String]::IsNullOrWhiteSpace("%NuGetInstaller.Options%") -eq $false) {
	$("%NuGetInstaller.Options%" -split ' ') | Foreach-Object {
		$parameters += $_
	}
  }

  return $parameters
}

$nuget = Join-Path -Path '%teamcity.tool.NuGet.CommandLine.DEFAULT.nupkg%' -ChildPath 'tools\NuGet.exe'
$arguments = Build-Arguments

if(%NuGetInstaller.Log%) {
	Write-Host "Executing nuget.exe"
	Write-Host "source: $nuget"
	Write-Host "using arguments: " -NoNewline

	$arguments | Foreach-Object {
		Write-Host "$_ " -NoNewline
	} -End {Write-Host ""}
}

& $nuget $arguments | Out-String