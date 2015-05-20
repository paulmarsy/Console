namespace ConsoleGitHubSyncer
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using System.Threading;

    public static class ShadowMode
    {
        private const uint MOVEFILE_DELAY_UNTIL_REBOOT = 0x4;
        private const string MutexGuid = "edb1fbff-b83d-4d5b-9a03-cc535ee29155";

        [DllImport("kernel32.dll")]
        private static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, uint dwFlags);

        public static void AquireMutex()
        {
            try
            {
                var mutex = new Mutex(false, MutexGuid);
                while (!mutex.WaitOne((int) TimeSpan.FromSeconds(1).TotalMilliseconds, false))
                    Write.Status.Line("Waiting for mutex...");
            }
            catch (AbandonedMutexException)
            {
            }
        }

        public static bool EnterShadowMode()
        {
            var source = Assembly.GetExecutingAssembly().Location;
            var destFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), System.Reflection.Assembly.GetExecutingAssembly().GetName().Name).TrimEnd('\\');
            
            if (Path.GetDirectoryName(source) == destFolder)
                return true;
            
            if (!System.IO.Directory.Exists(destFolder))
                System.IO.Directory.CreateDirectory(destFolder);

            var destination = Path.Combine(destFolder, Path.GetFileName(source));

            File.Copy(source, destination, true);
            MoveFileEx(destination, null, MOVEFILE_DELAY_UNTIL_REBOOT);

            var startInfo = Process.GetCurrentProcess().StartInfo;
            startInfo.FileName = destination;

            Process.Start(destination, string.Format("\"{0}\"", string.Join("\" \"", Environment.GetCommandLineArgs().Skip(1))));
            Environment.Exit(0);

            return false;
        }
    }
}