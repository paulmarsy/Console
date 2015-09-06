// ReSharper disable CheckNamespace

namespace ConsoleGitHubSyncer.Syncer.Actions
// ReSharper restore CheckNamespace
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using Git;
    using Git.Commands;

    public partial class Synchronizer : ISynchronizer
    {
        public const string MasterBranch = "master";
        private string _currentBranch;
        private string _postCommandArguments;
        private string _postCommandFilePath;

        public void Initialize(string[] args)
        {
            _postCommandFilePath = args.Skip(2).Take(1).SingleOrDefault();
            _postCommandArguments = args.Skip(3).Take(1).SingleOrDefault();

            _currentBranch = Git.InvokeWithOutput((Command) "rev-parse --symbolic-full-name --abbrev-ref HEAD").StandardOutput.Single();

            CheckGitHubConnectivity();
        }

        private void CheckGitHubConnectivity()
        {
            var githubUrl = Git.InvokeWithOutput((Command) "config --get remote.origin.url").StandardOutput.Single();

            if (!Network.CheckInternetConnection(githubUrl))
                throw new System.Net.WebException(githubUrl, System.Net.WebExceptionStatus.ConnectFailure);
        }

        private bool IsRepositoryIsInCleanState()
        {
            string assertFailMessage = null;
            // Only do something if we are using the primary branch
            if (_currentBranch != MasterBranch)
                assertFailMessage = $"Local branch is {_currentBranch} - ignoring synchronisation";

            // Make sure the working tree is clean
            if (GetNumberOfUnCommitedChanges() > 0)
                assertFailMessage = "Repository has uncommitted changes in its working tree";

            if (assertFailMessage != null)
            {
                assertFailMessage = $"Git repository is not in a clean state: {assertFailMessage}";
                
                Write.Error.Line(assertFailMessage);
                InvokePostCommand(assertFailMessage);
                
                return false;
            }
            
            return true;
        }

        private int GetNumberOfUnCommitedChanges()
        {
            return Git.InvokeWithOutput((Command) "status --porcelain").StandardOutput.Count();
        }

        private void InvokePostCommand(string message = null)
        {
            if (String.IsNullOrWhiteSpace(_postCommandFilePath))
                return;

            Write.Status.Line($"Starting: {Path.GetFileName(_postCommandFilePath)} {_postCommandArguments}");

            if (message != null)
                Environment.SetEnvironmentVariable("PowerShellConsoleStartUpMessage", message, EnvironmentVariableTarget.Process);

            Process.Start(new ProcessStartInfo
            {
                FileName = _postCommandFilePath,
                Arguments = _postCommandArguments,
                CreateNoWindow = false
            });
        }
    }
}