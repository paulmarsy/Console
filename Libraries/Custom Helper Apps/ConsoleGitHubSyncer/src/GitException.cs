namespace ConsoleGitHubSyncer
{
    using System;

    public class GitException : Exception
    {
        public GitException(Program.ExitCode exitCode) : this(exitCode, string.Empty)
        {
        }

        public GitException(Program.ExitCode exitCode, string message) : base(message)
        {
            ExitCode = exitCode;
        }

        public Program.ExitCode ExitCode { get; private set; }
    }
}