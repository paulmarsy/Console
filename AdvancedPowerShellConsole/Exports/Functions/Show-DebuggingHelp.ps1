function Show-DebuggingHelp
{
     Write-Host -Object `
@'
Set-PSDebug
	-Trace
		0 - Turn script tracing off
		1 - Trace script lines as they are executed
		2 - Trace script lines, variable assignments, function calls, and scripts

Trace-Command -PSHost
	-Name
		Get-TraceSource
		Don't use '*' or an infinite loop will occur
	-ListenerOption None (Default), LogicalOperationStack, DateTime, Timestamp, ProcessId, ThreadId, Callstack
		Optional data to prefix each trace message with
			
	-Option All (Default), None, Constructor, Dispose, Finalizer, Method, Property, Delegates, Events, Exception, Lock, Error, Errors, Warning, Verbose, WriteLine, Data, Scope, ExecutionFlow, Assert
		Type of events to trace


	-Command 
	-ArgumentList

	-Expression

Others:
	Enable-PSTrace 
	Enable-PSWSManCombinedTrace 
	Enable-WSManTrace 
	Start-Trace 
	Stop-Trace 
	Get-TraceSource 
	Set-TraceSource
'@
}