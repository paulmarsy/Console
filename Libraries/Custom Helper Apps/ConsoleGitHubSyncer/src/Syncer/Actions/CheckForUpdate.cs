﻿namespace ConsoleGitHubSyncer.Syncer.Actions
{
    using System;
    using System.Linq;
    using Git;
    using Git.Commands;

    public partial class Synchronizer
    {
        public Program.ExitCode CheckForUpdate()
        {
            if (!IsRepositoryIsInCleanState())
                return Program.ExitCode.ERROR_BAD_ENVIRONMENT;

            FetchLatest();

            if (CheckForUpstreamChanges())
                return Program.ExitCode.ERROR_REVISION_MISMATCH;

            if (CheckForLastUpstreamCheckout())
                return Program.ExitCode.ERROR_REVISION_MISMATCH;

            Write.Success.Line("Git branch up to date with latest upstream changes");

            return Program.ExitCode.ERROR_SUCCESS;
        }

        private bool CheckForLastUpstreamCheckout()
        {
            var latestBranchCommit = Git.InvokeWithOutput((Command) new[] {"rev-parse {0}", _currentBranch}).StandardOutput.Single();
            var checkedOutBranchCommit = Git.InvokeWithOutput((Command) "rev-parse HEAD").StandardOutput.Single();

            return latestBranchCommit != checkedOutBranchCommit;
        }

        private bool CheckForUpstreamChanges()
        {
            if (Git.InvokeWithOutput((Command)$"rev-list HEAD..{_currentBranch}@{{upstream}} --count").StandardOutput.Select(int.Parse).Single() > 0)
                return true;

            if (Git.InvokeWithOutput((SubmoduleCommand)$"rev-list HEAD..$('{Git.GitExe}' rev-parse --symbolic-full-name --abbrev-ref HEAD)@{{upstream}} --count").StandardOutput.Select(int.Parse).Any(x => x > 0))
                return true;

            return false;
        }

        private static void FetchLatest()
        {
            Write.Status.Line("Fetching latest changes from upstream Git repositories...");
            Git.Invoke((Command) "fetch --recurse-submodules=yes --prune --progress", new GitOptions {DisplayStandardOutput = true, ErrorStreamHasStandardOutput = true});
        }
    }
}