namespace ConsoleGitHubSyncer
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Syncer;
    using Syncer.Actions;

    public static class Program
    {
        public enum ExitCode
        {
            // Using the following as a guide http://msdn.microsoft.com/en-us/library/ms681381.aspx
            ERROR_SUCCESS = 0, // The operation completed successfully. Synchronize was successful
            ERROR_FILE_NOT_FOUND = 2, // The system cannot find the file specified. Git.exe couldn't be found
            ERROR_BAD_ENVIRONMENT = 10, // The environment is incorrect. Git repository is in an incompatible state to continue
            ERROR_BAD_COMMAND = 22, // The device does not recognize the command. The Git command failed
            ERROR_BAD_ARGUMENTS = 160, // One or more arguments are not correct. Argument list was not in the correct format
            ERROR_BAD_PATHNAME = 161, // The specified path is invalid. Invalid Git repository
            ERROR_ENVVAR_NOT_FOUND = 203, // The system could not find the environment option that was entered.
            ERROR_REVISION_MISMATCH = 1306 // Indicates two revision levels are incompatible. Remote updates need to be integrated
        }

        public static int Main()
        {
            Write.Trace.Line("_Console GitHub Synchronizer running in DEBUG mode_");

            ShadowMode.AquireMutex();

            var exitCode = Invoke();

            Write.Trace.Line();
            Write.Trace.Line($"Exit Code: {Enum.GetName(typeof (ExitCode), exitCode)} ({exitCode})");
            Write.Trace.PressAnyKeyToContinue();

            return (int) exitCode;
        }

        private static ExitCode Invoke()
        {
            try
            {
                var args = Environment.GetCommandLineArgs().Skip(1).ToArray();
                Write.Trace.Line($"Argument List: {string.Join(",", args)}");

                Git.Git.Initialize(args);
                var synchronizer = new Synchronizer();
                synchronizer.Initialize(args);
                var command = Command.GetCommand(args);
                if (command == null)
                {
                    Write.Error.Line($"Invalid usage: {Path.GetFileName(Assembly.GetExecutingAssembly().Location)} {Command.GetCommandLineArgsList()} <\"Git Repository Path\"> [\"Post Command File Path\"] [\"Post Command Arguments\"]");                    
                    return ExitCode.ERROR_BAD_ARGUMENTS;
                }
                
                return command.Invoke(synchronizer);
            }
            catch (System.Net.WebException e) when (e.Status == System.Net.WebExceptionStatus.ConnectFailure)
            {
                Write.Error.Line($"GitHub synchronizer cannot continue, unable connect to '{e.Message}'");
                return ExitCode.ERROR_BAD_COMMAND;
            }
            catch (Exception e)
            {
                Write.Error.Line($"ERROR: {e.Message}");
                Write.Error.Line(e.StackTrace);
                Write.Error.PressAnyKeyToContinue();
                
                if (e is GitException)
                    return ((GitException)e).ExitCode;
                else
                    return ExitCode.ERROR_BAD_ENVIRONMENT;
            }
        }
    }
}