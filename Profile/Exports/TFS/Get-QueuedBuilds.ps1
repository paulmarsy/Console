function Get-QueuedBuilds {
	$buildServer = Get-BuildServer
	
	$buildsRunningOnAgents = 0
	$buildServer.QueryBuildAgents($buildServer.CreateBuildAgentSpec()).Agents | % {
		$buildOnAgent = $null
		if ($_.ReservedForBuild) {
			$buildOnAgent = $buildServer.GetBuild($_.ReservedForBuild)
			$buildsRunningOnAgents++
		}
		New-Object PSObject -Property @{
			BuildController = $buildServer.GetBuildController($_.ControllerUri, $false).Name
			Name = $_.Name
			RunningBuild = $buildOnAgent.BuildNumber
		}
	} | sort BuildController, Name | Format-Table BuildController, Name, RunningBuild -AutoSize
	
	$queuedBuilds = $buildServer.QueryQueuedBuilds($buildServer.CreateBuildQueueSpec("*")).QueuedBuilds
	
	"Queued builds waiting for agent: {0}" -f (($queuedBuilds | measure).Count - $buildsRunningOnAgents)
}
@{Function = "Get-QueuedBuilds"}