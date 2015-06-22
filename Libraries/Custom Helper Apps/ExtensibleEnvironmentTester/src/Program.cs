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

        private static readonly IList<string> ValidParentProcessNames = new[] {"powershell", "cmd", "ConEmuC", "ConEmuC64"};
        private static readonly IList<string> ValidGrandParentProcessNames = new[] {"ConEmuC", "ConEmuC64"};
        private static readonly IList<string> PotentialGrandParentProcessNames = new[] {"explorer"};

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
            var process = Process.GetCurrentProcess();

            var parentProcess = process.Parent();
            if (parentProcess == null)
                return ExitCode.ERROR_INVALID_HANDLE;

            if (!ValidParentProcessNames.Contains(parentProcess.ProcessName))
                return ExitCode.ERROR_NOT_SUPPORTED;

            var grandParentProcess = parentProcess.Parent();
            if (grandParentProcess == null)
                return ExitCode.ERROR_INVALID_HANDLE;

            if (ValidGrandParentProcessNames.Contains(grandParentProcess.ProcessName))
                return ExitCode.ERROR_SUCCESS;

            if (PotentialGrandParentProcessNames.Contains(grandParentProcess.ProcessName))
                return ExitCode.ERROR_BAD_ENVIRONMENT;

            return ExitCode.ERROR_NOT_SUPPORTED;
        }
    }
}
