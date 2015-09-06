namespace ConsoleGitHubSyncer.Git
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using Commands;

    public class Git
    {
        private GitOutputs _gitOutputs;
        private Process _gitProcess;
        private readonly BaseGitCommand _command;
        private readonly GitOptions _gitOptions;

        private Git(BaseGitCommand command, GitOptions gitOptions)
        {
            if (gitOptions == null)
                gitOptions = new GitOptions();

            _gitOptions = gitOptions;

#if DEBUG
            _gitOptions.DisplayStandardOutput = true;
#endif

            _command = command;
        }

        public static string GitExe { get; set; }
        
        public static string GitRepository { get; set; }

        public static void Invoke(BaseGitCommand command, GitOptions gitOptions = null)
        {
            var git = new Git(command, gitOptions);
            git.Start(false);
            git.WaitForExit();
        }

        public static GitOutputs InvokeWithOutput(BaseGitCommand command, GitOptions gitOptions = null)
        {
            var git = new Git(command, gitOptions);
            git.Start(true);
            git.WaitForExit();

            return git._gitOutputs;
        }

        private void Start(bool returnOutput)
        {
            Write.Trace.Line($"[{_gitOptions.GitRepository}]: git.exe {_command}");
            _gitProcess = Process.Start(new ProcessStartInfo
            {
                FileName = GitExe,
                Arguments = _command.GitCommand,
                WorkingDirectory = _gitOptions.GitRepository,
                CreateNoWindow = false,
                WindowStyle = ProcessWindowStyle.Hidden,
                UseShellExecute = false,
                RedirectStandardError = true,
                RedirectStandardOutput = _gitOptions.DisplayStandardOutput || returnOutput
            });
            _gitOutputs = new GitOutputs(_gitProcess, returnOutput, _gitOptions.DisplayStandardOutput, _gitOptions.ErrorStreamHasStandardOutput);
        }

        private void WaitForExit()
        {
            _gitOutputs.Rejoin();

            if (_gitProcess.ExitCode != 0 && _gitOptions.ThrowOnErrorExitCode)
                throw new GitException(Program.ExitCode.ERROR_BAD_COMMAND,
                $"Error executing Git command:{Environment.NewLine}{_command}{Environment.NewLine}Standard Output:{Environment.NewLine}{_gitOutputs.StandardOutputAsString}{Environment.NewLine}Standard Error:{Environment.NewLine}{_gitOutputs.StandardErrorAsString}");
        }

        public static void Initialize(string[] args)
        {
            GitExe = GetGitPath();
            if (GitExe == null)
                throw new GitException(Program.ExitCode.ERROR_FILE_NOT_FOUND, "Unable to find Git.exe");

            GitRepository = args.Skip(1).Take(1).SingleOrValue(string.Empty).Trim('"');

            if (string.IsNullOrWhiteSpace(GitRepository))
                throw new GitException(Program.ExitCode.ERROR_BAD_ARGUMENTS);

            if (!Directory.Exists(Path.Combine(GitRepository, ".git")))
                throw new GitException(Program.ExitCode.ERROR_BAD_PATHNAME, $"'{GitRepository}' is not a valid git repository");
        }

        private static string GetGitPath()
        {
            var programFiles = Environment.GetEnvironmentVariable("ProgramFiles");
            if (string.IsNullOrWhiteSpace(programFiles))
                throw new GitException(Program.ExitCode.ERROR_ENVVAR_NOT_FOUND, "Unable to get Program Files path");

            var gitInstallPath = Path.Combine(programFiles, "Git");

            var gitPath = new[]
            {
                Path.Combine(gitInstallPath, "cmd")
            }
                .Select(folder => Path.Combine(folder, "git.exe"))
                .Where(File.Exists).FirstOrDefault();

            if (gitPath == null)
                throw new GitException(Program.ExitCode.ERROR_ENVVAR_NOT_FOUND, "Unable to locate git.exe");

            Write.Trace.Line($"Using git.exe from: {gitPath}");

            return gitPath;
        }
    }
}