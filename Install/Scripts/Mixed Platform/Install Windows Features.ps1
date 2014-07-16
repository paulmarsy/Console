Write-InstallMessage -EnterNewScope "Installing Windows Features...."

function Dism-Wrapper {
	param($FeatureName)
	Invoke-InstallStep "Installing $FeatureName...." {
		$output = & dism /Online /Enable-Feature /All /FeatureName:$FeatureName
		if ($LASTEXITCODE -ne 0) {
			 Write-InstallMessage "DISM Error: $output"
		}	
	}
}

# Telnet Client
Dism-Wrapper TelnetClient

# Hyper-V Module for Windows PowerShell
Dism-Wrapper Microsoft-Hyper-V-Management-PowerShell

# .NET Framework 3.5 (includes .NET 2.0 and 3.0)
Dism-Wrapper NetFx3
Dism-Wrapper WCF-HTTP-Activation
Dism-Wrapper WCF-NonHTTP-Activation

# .NET Framework 4.5 Advanced Services
Dism-Wrapper NetFx4-AdvSrvs
Dism-Wrapper NetFx4Extended-ASPNET45

# WCF Services
Dism-Wrapper WCF-Services45
Dism-Wrapper WCF-HTTP-Activation45
Dism-Wrapper WCF-MSMQ-Activation45
Dism-Wrapper WCF-Pipe-Activation45
Dism-Wrapper WCF-TCP-Activation45
Dism-Wrapper WCF-TCP-PortSharing45

# FTP Server
Dism-Wrapper IIS-FTPServer
Dism-Wrapper IIS-FTPSvc

# Web Management Tools
Dism-Wrapper IIS-ManagementConsole
Dism-Wrapper IIS-ManagementScriptingTools
Dism-Wrapper IIS-ManagementService

# World Wide Web Services
Dism-Wrapper IIS-WebServer
Dism-Wrapper IIS-WebServerManagementTools
Dism-Wrapper IIS-WebServerRole

# Application Development Features
Dism-Wrapper IIS-ApplicationDevelopment
Dism-Wrapper IIS-NetFxExtensibility
Dism-Wrapper IIS-NetFxExtensibility45
Dism-Wrapper IIS-ApplicationInit
Dism-Wrapper IIS-ASPNET
Dism-Wrapper IIS-ASPNET45
Dism-Wrapper IIS-ISAPIExtensions
Dism-Wrapper IIS-ISAPIFilter
Dism-Wrapper IIS-WebSockets

# Common HTTP Features
Dism-Wrapper IIS-CommonHttpFeatures
Dism-Wrapper IIS-DefaultDocument
Dism-Wrapper IIS-DirectoryBrowsing
Dism-Wrapper IIS-HttpErrors
Dism-Wrapper IIS-HttpRedirect
Dism-Wrapper IIS-StaticContent

# Health and Diagnostics
Dism-Wrapper IIS-HealthAndDiagnostics
Dism-Wrapper IIS-HttpLogging
Dism-Wrapper IIS-RequestMonitor
Dism-Wrapper IIS-HttpTracing

# Performance Features
Dism-Wrapper IIS-Performance
Dism-Wrapper IIS-HttpCompressionDynamic
Dism-Wrapper IIS-HttpCompressionStatic

# Security
Dism-Wrapper IIS-Security
Dism-Wrapper IIS-BasicAuthentication
Dism-Wrapper IIS-DigestAuthentication
Dism-Wrapper IIS-IPSecurity
Dism-Wrapper IIS-RequestFiltering
Dism-Wrapper IIS-URLAuthorization
Dism-Wrapper IIS-WindowsAuthentication



Exit-Scope