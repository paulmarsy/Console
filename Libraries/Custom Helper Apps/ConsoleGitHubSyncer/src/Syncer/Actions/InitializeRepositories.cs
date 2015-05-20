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

            Write.Status.Line("Checking out {0} branch", _currentBranch);
            CheckoutBranch();

            Write.Success.Line("Git repository initialized and {0} branch checked out", _currentBranch);

            return Program.ExitCode.ERROR_SUCCESS;
        }
    }
}