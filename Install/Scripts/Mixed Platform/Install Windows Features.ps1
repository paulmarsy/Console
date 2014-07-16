function Dism-Wrapper {
	param($FeatureNames)
		Invoke-InstallStep "Installing Windows Features...." {
		$featureList = "/FeatureName:$([String]::Join(' /FeatureName:', $FeatureNames))"
		$output = Invoke-Expression "dism.exe /Online /Enable-Feature /All $featureList"
		if ($LASTEXITCODE -ne 0) {
			 Write-InstallMessage "DISM Error: $output"
		}
	}
}

Dism-Wrapper @(
# Telnet Client
'TelnetClient'

# Hyper-V Module for Windows PowerShell
'Microsoft-Hyper-V-Management-PowerShell'

# .NET Framework 3.5 (includes .NET 2.0 and 3.0)
'NetFx3'
'WCF-HTTP-Activation'
'WCF-NonHTTP-Activation'

# .NET Framewor'k 4.5 Advanced Services
'NetFx4-AdvSrvs'
'NetFx4Extended-ASPNET45'

# WCF Services
'WCF-Services45'
'WCF-HTTP-Activation45'
'WCF-MSMQ-Activation45'
'WCF-Pipe-Activation45'
'WCF-TCP-Activation45'
'WCF-TCP-PortSharing45'

# FTP Server
'IIS-FTPServer'
'IIS-FTPSvc'

# Web Management Tools
'IIS-ManagementConsole'
'IIS-ManagementScriptingTools'
'IIS-ManagementService'

# World Wide Web Services
'IIS-WebServer'
'IIS-WebServerManagementTools'
'IIS-WebServerRole'

# Application Development Features
'IIS-ApplicationDevelopment'
'IIS-NetFxExtensibility'
'IIS-NetFxExtensibility45'
'IIS-ApplicationInit'
'IIS-ASPNET'
'IIS-ASPNET45'
'IIS-ISAPIExtensions'
'IIS-ISAPIFilter'
'IIS-WebSockets'

# Common HTTP Features
'IIS-CommonHttpFeatures'
'IIS-DefaultDocument'
'IIS-DirectoryBrowsing'
'IIS-HttpErrors'
'IIS-HttpRedirect'
'IIS-StaticContent'

# Health and Diagnostics
'IIS-HealthAndDiagnostics'
'IIS-HttpLogging'
'IIS-RequestMonitor'
'IIS-HttpTracing'

# Performance Features
'IIS-Performance'
'IIS-HttpCompressionDynamic'
'IIS-HttpCompressionStatic'

# Security
'IIS-Security'
'IIS-BasicAuthentication'
'IIS-DigestAuthentication'
'IIS-IPSecurity'
'IIS-RequestFiltering'
'IIS-URLAuthorization'
'IIS-WindowsAuthentication'
)