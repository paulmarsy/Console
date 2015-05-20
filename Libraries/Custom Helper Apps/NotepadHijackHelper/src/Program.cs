namespace NotepadHijackHelper
{
    using System;
    using System.Diagnostics;
    using System.Linq;

    public static class Program
    {
        public static int Main()
        {
            // First parameter will this executables name
            var args = Environment.GetCommandLineArgs().Skip(1); 

            // Second parameter will be the hijacker program to use to replace notepad
            var hijackerProgramPath = args.Take(1).Single();  
            // Third and unneeded is the program being hijacked, in this case always 'notepad.exe'
            // Fourth and onwards are the original command line arguments which need to be redirected to the hijack program
            var fileToOpen = string.Format("\"{0}\"", string.Join(" ", args.Skip(2).Select(x => x.Trim('\\'))));

#if DEBUG
            System.Windows.Forms.MessageBox.Show(string.Format(
                        "NotepadHijackHelper Args: {1}{0}Hijacker: {2}{0}Hijacker Args:{3}",
                            Environment.NewLine,
                            string.Join(" ", args),
                            hijackerProgramPath,
                            fileToOpen
                        ));
#endif

            var process = Process.Start(new ProcessStartInfo
            {
                FileName = hijackerProgramPath,
                Arguments = fileToOpen
            });
            
            process.WaitForExit();
            
            return process.ExitCode;
        }
    }
}