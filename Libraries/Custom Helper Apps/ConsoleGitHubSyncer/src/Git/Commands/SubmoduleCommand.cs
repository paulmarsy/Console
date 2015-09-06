namespace ConsoleGitHubSyncer.Git.Commands
{
    using System.Linq;

    internal class SubmoduleCommand : BaseGitCommand
    {
        private readonly string _subCommand;

        public SubmoduleCommand(string command)
        {
            _subCommand = command;
            IsGitCommand = true;
            IsRecursive = true;
        }
        
        public bool IsGitCommand { get; set; }
        
        public bool IsRecursive { get; set; }

        public string SubCommand
        {
            get { return IsGitCommand ? $"'{Git.GitExe}' {_subCommand}" : _subCommand; }
        }

        public override string GitCommand
        {
            get { return string.Format(GetSubmoduleCommandFormat(IsRecursive), SubCommand); }
        }

        public static implicit operator SubmoduleCommand(string command)
        {
            return new SubmoduleCommand(command);
        }

        public static string GetSubmoduleCommandFormat(bool isRecursive)
        {
            return $"submodule foreach --quiet {(isRecursive ? "--recursive" : null)} \"{{0}}\"";
        }
    }
}