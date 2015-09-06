namespace ConsoleGitHubSyncer.Syncer.Actions
{
    using Git;
    using Git.Commands;

    public partial class Synchronizer
    {
        public Program.ExitCode InitializeRepositories()
        {
            Write.Status.Line("Initializing Git repositories...");

            Git.Invoke((Command) "submodule init");
            Git.Invoke((SubmoduleCommand) "submodule init");

            Write.Status.Line($"Checking out {_currentBranch} branch");
            CheckoutBranch();

            Write.Success.Line($"Git repository initialized and {_currentBranch} branch checked out");

            return Program.ExitCode.ERROR_SUCCESS;
        }
        
        private void CheckoutBranch()
        {
            Write.Status.Line("Checking out branch...");

            Git.Invoke((Command) $"checkout {_currentBranch}");
            Git.Invoke((SubmoduleCommand) $"checkout $('{Git.GitExe}' rev-parse --symbolic-full-name --abbrev-ref HEAD)");
        }
    }
}