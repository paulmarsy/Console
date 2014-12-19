using System.Runtime.InteropServices;
using System.Text;

namespace BinaryCustomPowerShellConsoleCmdlets
{
    static class NativeMethods
    {
        public enum ASSOCF
        {
            ASSOCF_NONE = 0x00000000
        }

        public enum ASSOCSTR
        {
            ASSOCSTR_COMMAND = 1
        }

        [DllImport("Shell32.dll", CharSet = CharSet.Unicode)]
        public static extern int SHEvaluateSystemCommandTemplate(string pszCmdTemplate, out string ppszApplication, out string ppszCommandLine, out string ppszParameters);

        [DllImport("Shlwapi.dll", CharSet = CharSet.Unicode)]
        public static extern int AssocQueryString(ASSOCF flags, ASSOCSTR str, string pszAssoc, string pszExtra, StringBuilder pszOut, ref uint pcchOut);
    }
}
