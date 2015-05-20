namespace ExtensibleEnvironmentTester
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using System.Runtime.InteropServices;

    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public static class ProcessExtensions
    {
        private static Process[] _AllProcesses;

        private static IEnumerable<Process> AllProcesses
        {
            get { return _AllProcesses ?? (_AllProcesses = Process.GetProcesses(".")); }
        }

        public static Process Parent(this Process process)
        {
            if (process == null)
                return null;

            var pbi = new PROCESS_BASIC_INFORMATION();
            var ntstatus = NtQueryInformationProcess(process.Handle, PROCESSINFOCLASS.ProcessBasicInformation, ref pbi, PROCESS_BASIC_INFORMATION.MarshalSize, IntPtr.Zero);
            if (ntstatus != 0)
                throw new Win32Exception(ntstatus);

            var parentPid = pbi.Reserved3.ToInt32();

            return AllProcesses.SingleOrDefault(x => x.Id == parentPid);
        }

        [DllImport("Ntdll.dll", CharSet = CharSet.Auto)]
        private static extern int NtQueryInformationProcess(IntPtr ProcessHandle, PROCESSINFOCLASS ProcessInformationClass, ref PROCESS_BASIC_INFORMATION ProcessInformation, ulong ProcessInformationLength, IntPtr ReturnLength);

        private enum PROCESSINFOCLASS
        {
            ProcessBasicInformation = 0,
            ProcessDebugPort = 7,
            ProcessWow64Information = 26,
            ProcessImageFileName = 27,
            ProcessBreakOnTermination = 29
        }

        [StructLayout(LayoutKind.Sequential)]
        [SuppressMessage("ReSharper", "FieldCanBeMadeReadOnly.Local")]
        [SuppressMessage("ReSharper", "MemberCanBePrivate.Local")]
        private struct PROCESS_BASIC_INFORMATION
        {
            public static ulong MarshalSize = (ulong)Marshal.SizeOf<PROCESS_BASIC_INFORMATION>();
 
            public IntPtr Reserved1; // ExitStatus
            public IntPtr PebBaseAddress;
            public IntPtr Reserved2_0; // AffinityMask
            public IntPtr Reserved2_1; // BasePriority
            public UIntPtr UniqueProcessId;
            public IntPtr Reserved3; // InheritedFromUniqueProcessId
        }
    }
}