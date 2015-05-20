namespace ConsoleGitHubSyncer.Git
{
    public class GitOptions
    {
        public GitOptions()
        {
            GitRepository = Git.GitRepository;
            DisplayStandardOutput = false;
            ErrorStreamHasStandardOutput = false;
            ThrowOnErrorExitCode = true;
        }

        public string GitRepository { get; set; }
        public bool DisplayStandardOutput { get; set; }
        public bool ErrorStreamHasStandardOutput { get; set; }
        public bool ThrowOnErrorExitCode { get; set; }
    }
}