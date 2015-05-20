namespace ConsoleGitHubSyncer.Git.Commands
{
    using System.Collections.Generic;
    using System.Text;

    internal class BatchedSubmoduleCommand : BaseGitCommand
    {
        private readonly SortedList<int, SubmoduleCommand> _submoduleCommands = new SortedList<int, SubmoduleCommand>();

        public BatchedSubmoduleCommand(bool isRecursive)
        {
            IsRecursive = isRecursive;
        }

        public bool IsRecursive { get; private set; }

        public override string GitCommand
        {
            get
            {
                var commands = new StringBuilder();
                foreach (var submoduleCommand in _submoduleCommands)
                    commands.AppendFormat("{0}; ", submoduleCommand.Value.SubCommand);

                return string.Format(SubmoduleCommand.GetSubmoduleCommandFormat(IsRecursive), commands);
            }
        }

        public void AddSubmoduleCommand(SubmoduleCommand submoduleCommand)
        {
            if (IsRecursive != submoduleCommand.IsRecursive)
                throw new GitException(Program.ExitCode.ERROR_BAD_COMMAND, "When batching submodule commands all must be recursive or non-recursive");

            _submoduleCommands.Add(_submoduleCommands.Count, submoduleCommand);
        }
    }
}