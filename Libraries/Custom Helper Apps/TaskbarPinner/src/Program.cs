using System;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;

namespace TaskbarPinner
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            if (args.Length == 0 ||
                args[0] == "help" ||
                (args[0] != "add" && args[0] != "remove") ||
                (args[1] != "taskbar"))
            {
                Console.Write("Command syntax: TaskbarPinner.exe add/remove taskbar <Path to item to pin>");
                Environment.Exit(1);
            }
            var action = args[0];
            var target = args[1];

            var path = string.Join(" ", args.Skip(2)).TrimStart('\\').TrimEnd('\\');
            if (!File.Exists(path))
            {
                Console.WriteLine("Cannot find file to pin: {0}", path);
                Environment.Exit(2);
            }

            if (target == "taskbar")
            {
                // From https://stackoverflow.com/questions/6872103/pin-lnk-file-to-windows-7-taskbar-using-c-sharp/6874417#6874417
                dynamic shellApplication = Activator.CreateInstance(Type.GetTypeFromProgID("Shell.Application"));

                dynamic directory = shellApplication.NameSpace(Path.GetDirectoryName(path));
                dynamic link = directory.ParseName(Path.GetFileName(path));

                foreach (var verb in link.Verbs())
                {
                    var verbName = verb.Name;
                    if (action == "add" && verbName == "Pin to Tas&kbar")
                    {
                        verb.DoIt();
                        break;
                    }
                    if (action == "remove" && verbName == "Unpin from Tas&kbar")
                    {
                        verb.DoIt();
                        break;
                    }
                }
                Marshal.FinalReleaseComObject(shellApplication);
            }
            Environment.Exit(0);
        }
    }
}

