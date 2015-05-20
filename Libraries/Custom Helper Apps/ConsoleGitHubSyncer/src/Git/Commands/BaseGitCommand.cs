namespace ConsoleGitHubSyncer.Git.Commands
{
    public abstract class BaseGitCommand : IGitCommand
    {
        public abstract string GitCommand { get; }

        public override string ToString()
        {
            return GitCommand;
        }

        public override int GetHashCode()
        {
            return GitCommand.GetHashCode();
        }
    }
}