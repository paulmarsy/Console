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

            if (!CheckGitHubConnectivity()) throw new GitException(Program.ExitCode.ERROR_BAD_ENVIRONMENT, "Unable to contact github.com - is there internet connectivity?");
        }

        private bool CheckGitHubConnectivity()
        {
            var githubUrl = Git.InvokeWithOutput((Command) "config --get remote.origin.url").StandardOutput.Single();

            return Network.CheckInternetConnection(githubUrl);
        }

        private bool IsRepositoryIsInCleanState()
        {
            string assertFailMessage = null;
            // Only do something if we are using the primary branch
            if (_currentBranch != MasterBranch)
                assertFailMessage = string.Format("Local branch is {0} - ignoring synchronisation", _currentBranch);

            // Make sure the working tree is clean
            if (GetNumberOfUnCommitedChanges() > 0)
                assertFailMessage = "Repository has uncommitted changes in its working tree";

            if (assertFailMessage != null)
            {
                assertFailMessage = String.Format("Git repository is not in a clean state: {0}", assertFailMessage);
                
                Write.Error.Line(assertFailMessage);
                InvokePostCommand(assertFailMessage);
                
                return false;
            }
            
            return true;
        }

        private void CheckoutBranch()
        {
            Write.Status.Line("Checking out branch...");

            Git.Invoke((Command) new[] {"checkout {0}", _currentBranch});
            Git.Invoke((SubmoduleCommand) new[] {"checkout {0}", _currentBranch});
        }

        private int GetNumberOfUnCommitedChanges()
        {
            return Git.InvokeWithOutput((Command) "status --porcelain").StandardOutput.Count();
        }

        private void InvokePostCommand(string message = null)
        {
            if (String.IsNullOrWhiteSpace(_postCommandFilePath))
                return;

            Write.Status.Line("Starting: {0} {1}", Path.GetFileName(_postCommandFilePath), _postCommandArguments);

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