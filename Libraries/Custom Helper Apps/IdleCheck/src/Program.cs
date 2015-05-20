namespace IdleCheck
{
    using System;
    using System.Runtime.InteropServices;

    public static class Program
    {
        public enum ExitCode : int 
        {
            // Using the following as a guide http://msdn.microsoft.com/en-us/library/ms681381.aspx
            ERROR_SUCCESS           = 0, // The operation completed successfully. Idle check was successful.
            ERROR_BAD_ENVIRONMENT   = 10 // The environment is incorrect. Something went wrong when checking for the idle status.
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct LASTINPUTINFO
        {
            public static uint MarshalSize = (uint)Marshal.SizeOf<LASTINPUTINFO>();
            public uint cbSize;    
            public uint dwTime;
        }

        [DllImport("User32.dll")]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);            

        public static int Main()
        {
#if DEBUG
            Console.WriteLine("_Idle Check running in DEBUG mode_");
#endif

            var exitCode = Invoke();

#if DEBUG
            Console.WriteLine();
            Console.WriteLine("Exit Code: {0} ({1})", Enum.GetName(typeof(ExitCode), exitCode), (int)exitCode);
            Console.Write("Press any key to continue. . . ");
            Console.ReadKey(true);
            Console.WriteLine();
#endif

            return (int)exitCode;
        }

        private static ExitCode Invoke()
        {
            try
            {
                var lastInputInfo = new LASTINPUTINFO
                {
                    cbSize = LASTINPUTINFO.MarshalSize
                };
                if (!GetLastInputInfo(ref lastInputInfo))
                    throw new Exception("WinApi call GetLastInputInfo was not successful");

                var idleTime = (uint)Environment.TickCount - lastInputInfo.dwTime;

                Console.Out.WriteLine(idleTime);

                return ExitCode.ERROR_SUCCESS;
            }
            catch (Exception e)
            {
                Console.Error.WriteLine("IdleCheck encountered an error: {0}", e.Message);
                return ExitCode.ERROR_BAD_ENVIRONMENT;
            }
        }
    }
}
