namespace ConsoleGitHubSyncer.Syncer
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Actions;

    public class Command
    {
        public static readonly IList<Command> AllCommands = new List<Command>
        {
            new Command("InitializeRepositories", synchronizer => synchronizer.InitializeRepositories()),
            new Command("Check", synchronizer => synchronizer.CheckForUpdate()),
            new Command("UpdateLocal", synchronizer => synchronizer.UpdateLocal()),
            new Command("UpdateRemote", synchronizer => synchronizer.UpdateRemote())
        };

        private readonly Func<Synchronizer, Program.ExitCode> _action;
        private readonly string _name;

        private Command(string name, Func<Synchronizer, Program.ExitCode> action)
        {
            _name = name;
            _action = action;
        }

        public Program.ExitCode Invoke(Synchronizer synchronizer)
        {
            return _action.Invoke(synchronizer);
        }

        public override string ToString()
        {
            return _name;
        }

        public override int GetHashCode()
        {
            return (_name != null ? _name.GetHashCode() : 0);
        }

        public bool Equals(string obj)
        {
            return String.Equals(_name, obj, StringComparison.CurrentCultureIgnoreCase);
        }

        private static Command GetCommand(string commandName)
        {
            return AllCommands.SingleOrDefault(x => x.Equals(commandName));
        }

        public static Command GetCommand(string[] args)
        {
            return GetCommand(args.Take(1).SingleOrValue(String.Empty).TrimStart('-'));
        }

        public static string GetCommandLineArgsList()
        {
            return string.Join("/", AllCommands.Select(command => String.Format("-{0}", command.ToString())));
        }
    }
}