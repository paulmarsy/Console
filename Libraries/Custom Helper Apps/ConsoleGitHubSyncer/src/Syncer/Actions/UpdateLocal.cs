namespace ConsoleGitHubSyncer.Syncer.Actions
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Git;
    using Git.Commands;

    public partial class Synchronizer
    {
        public Program.ExitCode UpdateLocal()
        {
            if (!IsRepositoryIsInCleanState())
                return Program.ExitCode.ERROR_BAD_ENVIRONMENT;
                
            if (!ShadowMode.EnterShadowMode())
                return Program.ExitCode.ERROR_SUCCESS;

            InitializeRepositories();

            Write.Status.Line("Rebasing branch with upstream changes...");
            Git.Invoke((Command) "rebase", new GitOptions {DisplayStandardOutput = true});

            UpdateGitSubmodules();

            Write.Success.Line("Local Git repository update successful");

            InvokePostCommand("Git repository local update successful");

            return Program.ExitCode.ERROR_SUCCESS;
        }

        private void UpdateGitSubmodules()
        {
            Write.Status.Line("Rebasing submodules with upstream changes...");
            Git.Invoke((SubmoduleCommand) "rebase", new GitOptions {DisplayStandardOutput = true});

            foreach (var superproject in GetSuperProjectsAndSubmodulePaths().GroupBy(x => x.Item1).OrderByDescending(x => x.Key))
            {
                foreach (var submodule in superproject)
                    Git.Invoke((Command) new[] {"add \"{0}\"", submodule.Item2}, new GitOptions {GitRepository = superproject.Key, ThrowOnErrorExitCode = false});

                if (GetNumberOfStagedFiles(superproject.Key) > 0)
                {
                    var superprojectName = Path.GetFileName(superproject.Key);
                    Write.Status.Line("Integrating updated submodules in repository {0}", superprojectName);
                    Git.Invoke((Command) new[] {"commit -m \"Updating submodule references in {0} to point to latest commits\"", superprojectName}, new GitOptions {GitRepository = superproject.Key});
                }
            }

            if (GetNumberOfUnCommitedChanges() == 0)
                return;

            Write.Status.Line("Cleaning up submodules from the working tree...");
            Git.Invoke((Command) "clean -f -f -d");
        }

        private static IEnumerable<Tuple<string, string>> GetSuperProjectsAndSubmodulePaths()
        {
            return Git.InvokeWithOutput(new SubmoduleCommand("echo $toplevel!$path") {IsGitCommand = false, IsRecursive = true})
                .StandardOutput
                .Select(x => {
                    Console.Write("Test: {0}", x);
                     return x.Replace('/', '\\').Split('!');
                     })
                .Select(submodule => new Tuple<string, string>(submodule[0], submodule[1]));
        }

        private int GetNumberOfStagedFiles(string gitRepository)
        {
            return Git.InvokeWithOutput((Command) "diff --cached --numstat", new GitOptions {GitRepository = gitRepository}).StandardOutput.Count();
        }
    }
}
