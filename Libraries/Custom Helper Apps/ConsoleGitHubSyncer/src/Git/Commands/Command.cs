namespace ConsoleGitHubSyncer.Git.Commands
{
    using System.Linq;

    internal class Command : BaseGitCommand
    {
        private readonly string _command;

        public Command(string command)
        {
            _command = command;
        }

        public Command(string format, params object[] args) : this(string.Format(format, args))
        {
        }

        public override string GitCommand
        {
            get { return _command; }
        }

        public static implicit operator Command(string command)
        {
            return new Command(command);
        }

        public static implicit operator Command(object[] stringFormat)
        {
            return new Command((string) stringFormat[0], stringFormat.Skip(1).ToArray());
        }
    }
}