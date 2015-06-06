namespace ConsoleGitHubSyncer.Syncer.Actions
{
    using System;
    using System.Reflection;
    using Git;
    using Git.Commands;

    public partial class Synchronizer
    {
        public Program.ExitCode UpdateRemote()
        {
            if (!IsRepositoryIsInCleanState())
                return Program.ExitCode.ERROR_BAD_ENVIRONMENT;
                
            var updateCheck = CheckForUpdate();
            if (updateCheck == Program.ExitCode.ERROR_REVISION_MISMATCH)
            {
                Write.Status.Line("Local Git repository needs to be updated with remote changes before continuing...");
                _postCommandArguments = String.Format("-UpdateRemote \"{0}\" \"{1}\" \"{2}\"", Git.GitRepository, _postCommandFilePath, _postCommandArguments);
                _postCommandFilePath = Assembly.GetExecutingAssembly().Location;

                var updateLocalResult = UpdateLocal();
                if (updateLocalResult != Program.ExitCode.ERROR_SUCCESS)
                {
                    Write.Error.Line("Local update failed - cannot continue");
                    return updateLocalResult;
                }
            }
            else if (updateCheck != Program.ExitCode.ERROR_SUCCESS)
            {
                Write.Error.Line("Git update failed - cannot continue");
                return updateCheck;
            }

            Write.Status.Line("Pushing local main repository to remote...");
            Git.Invoke((Command) "push --progress --verbose", new GitOptions {DisplayStandardOutput = true, ErrorStreamHasStandardOutput = true});

            Write.Success.Line("Remote Git repository update successful");

            InvokePostCommand("Git repository remote update successful");

            return Program.ExitCode.ERROR_SUCCESS;
        }
    }
}