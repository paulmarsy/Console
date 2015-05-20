namespace ConsoleGitHubSyncer.Syncer
{
    public interface ISynchronizer
    {
        Program.ExitCode UpdateRemote();
        Program.ExitCode CheckForUpdate();
        Program.ExitCode UpdateLocal();
        Program.ExitCode InitializeRepositories();
    }
}