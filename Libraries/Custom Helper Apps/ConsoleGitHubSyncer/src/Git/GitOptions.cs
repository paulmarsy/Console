namespace ConsoleGitHubSyncer.Git
{
    public class GitOptions
    {
        public string GitRepository { get; set; } = Git.GitRepository;
        public bool DisplayStandardOutput { get; set; } = false;
        public bool ErrorStreamHasStandardOutput { get; set; } = false;
        public bool ThrowOnErrorExitCode { get; set; } = true;
    }
}