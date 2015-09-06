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

        public SubmoduleCommand(string format, params object[] args) : this(string.Format(format, args))
        {
        }

        public bool IsGitCommand { get; set; }
        
        public bool IsRecursive { get; set; }

        public string SubCommand
        {
            get { return IsGitCommand ? string.Format("'{0}' {1}", Git.GitExe, _subCommand) : _subCommand; }
        }

        public override string GitCommand
        {
            get { return string.Format(GetSubmoduleCommandFormat(IsRecursive), SubCommand); }
        }

        public static implicit operator SubmoduleCommand(string command)
        {
            return new SubmoduleCommand(command);
        }

        public static implicit operator SubmoduleCommand(object[] stringFormat)
        {
            return new SubmoduleCommand((string) stringFormat[0], stringFormat.Skip(1).ToArray());
        }

        public static string GetSubmoduleCommandFormat(bool isRecursive)
        {
            return string.Format("submodule foreach --quiet {0} \"{{0}}\"", isRecursive ? "--recursive" : null);
        }
    }
}