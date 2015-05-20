namespace ConsoleGitHubSyncer.Git
{
    using System.Collections.Generic;
    using System.Diagnostics;

    public class GitOutputs
    {
        private readonly Process _process;
        private readonly GitOutput _standardError;
        private readonly GitOutput _standardOutput;

        public GitOutputs(Process process, bool returnOutput, bool displayStandardOutput, bool errorStreamHasStandardOutput)
        {
            _process = process;

            var standardOutputWriter = Write.Debug;
            var standardErrorWriter = Write.Error;
            if (displayStandardOutput)
            {
                standardOutputWriter = Write.Progress;
                if (errorStreamHasStandardOutput)
                    standardErrorWriter = Write.Info;
            }

            if (returnOutput || displayStandardOutput)
                _standardOutput = new GitOutput(_process, _process.StandardOutput, standardOutputWriter);

            _standardError = new GitOutput(_process, _process.StandardError, standardErrorWriter);
        }

        public IEnumerable<string> StandardOutput
        {
            get { return _standardOutput != null ? _standardOutput.GetOutput() : new[] {string.Empty}; }
        }

        public string StandardOutputAsString
        {
            get { return _standardOutput != null ? _standardOutput.GetOuputAsString() : string.Empty; }
        }

        public IEnumerable<string> StandardError
        {
            get { return _standardError.GetOutput(); }
        }

        public string StandardErrorAsString
        {
            get { return _standardError.GetOuputAsString(); }
        }

        public void Rejoin()
        {
            _process.WaitForExit();

            if (_standardOutput != null)
                _standardOutput.Join();
            _standardError.Join();
        }
    }
}