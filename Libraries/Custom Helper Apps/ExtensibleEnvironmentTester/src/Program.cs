namespace ExtensibleEnvironmentTester
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;

    public class Program
    {
        public enum ExitCode // Using the following as a guide http://msdn.microsoft.com/en-us/library/ms681381.aspx
        {
            ERROR_SUCCESS = 0, // The operation completed successfully. We are running in an extensible environment
            ERROR_INVALID_HANDLE = 6, // The handle is invalid. We were unable to detect if we are in an extensible environment
            ERROR_BAD_ENVIRONMENT = 10, // The environment is incorrect. We are running in an environment by default, but it could be enabled.
            ERROR_BAD_COMMAND = 22, // The device does not recognize the command. An error occured,
            ERROR_NOT_SUPPORTED = 50 // The request is not supported. We are not running in an extensible environment which shouldn't be altered in any way.
        }
        
        private const string ConEmuCRelativePath = @"Libraries\ConEmu\ConEmu\ConEmuC64.exe";

        private static readonly IList<string> ValidProcessNames = new[] {"powershell", "cmd"};
        private static readonly IList<string> ValidParentProcessNames = new[] {"ConEmuC", "ConEmuC64"};
        private static readonly IList<string> PotentialParentProcessNames = new[] {"explorer"};

        public static int Main()
        {
            try
            {
                return (int) Invoke();
            }
            catch (Exception e)
            {
                Console.Error.WriteLine("ExtensibleEnvironmentTester encountered an error: {0}", e.Message);
                return (int) ExitCode.ERROR_BAD_COMMAND;
            }
        }

        private static ExitCode Invoke()
        {
            var extensibleEnvironmentTesterProcess = Process.GetCurrentProcess();
            var currentProcess = extensibleEnvironmentTesterProcess.Parent();
            var currentProcessCheck = CheckProcess(currentProcess, false);
            if (currentProcessCheck != ExitCode.ERROR_SUCCESS)
                return currentProcessCheck;

            var parentProcess = currentProcess.Parent();
            if (parentProcess.ProcessName == currentProcess.ProcessName)
                return ExitCode.ERROR_NOT_SUPPORTED;

            var conemuC = Process.Start(new ProcessStartInfo
                {
                    FileName = System.IO.Path.Combine(Environment.GetEnvironmentVariable("CustomConsolesInstallPath"), ConEmuCRelativePath),
                    Arguments = "/IsConEmu",
                    CreateNoWindow = true,
                    UseShellExecute = false
                });
            conemuC.WaitForExit(250);
            if (conemuC.ExitCode == 1)
                return ExitCode.ERROR_SUCCESS;

            var parentProcessCheck = CheckProcess(parentProcess);
            if (parentProcessCheck == ExitCode.ERROR_NOT_SUPPORTED)
            {
                var grandParentProcess = parentProcess.Parent();
                var grandParentProcessCheck = CheckProcess(grandParentProcess);
                if (grandParentProcessCheck == ExitCode.ERROR_NOT_SUPPORTED)
                    return grandParentProcessCheck;
            }
            
            return parentProcessCheck;
        }
        
        private static ExitCode CheckProcess(Process processToCheck, bool parentCheck = true)
        {
#if DEBUG
            Console.WriteLine("Process to check: {0}", processToCheck.ProcessName);
#endif

            if (processToCheck == null)
                return ExitCode.ERROR_INVALID_HANDLE;
            
            if (parentCheck == false)
            {
                if (ValidProcessNames.Contains(processToCheck.ProcessName))
                    return ExitCode.ERROR_SUCCESS;
                else
                    return ExitCode.ERROR_NOT_SUPPORTED;
            }
            else
            {    
                if (ValidParentProcessNames.Contains(processToCheck.ProcessName))
                    return ExitCode.ERROR_SUCCESS;
                else if (PotentialParentProcessNames.Contains(processToCheck.ProcessName))
                    return ExitCode.ERROR_BAD_ENVIRONMENT;
                else
                    return ExitCode.ERROR_NOT_SUPPORTED;
            }
        }
    }
}

