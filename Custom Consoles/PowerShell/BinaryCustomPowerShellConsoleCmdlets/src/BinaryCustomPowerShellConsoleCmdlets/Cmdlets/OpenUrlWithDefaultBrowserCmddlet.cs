using System;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Management.Automation;
using System.Runtime.InteropServices;
using System.Text;
using ShellObjects;

namespace BinaryCustomPowerShellConsoleCmdlets.Cmdlets
{
    [Cmdlet(VerbsCommon.Open, "UrlWithDefaultBrowser")]
    public class OpenUrlWithDefaultBrowserCmddlet : Cmdlet
    {
        [Parameter(Mandatory = true)]
        public string Url { get; set; }

        protected override void ProcessRecord()
        {
            string browserProgId;
            GetDefaultBrowserProgId(out browserProgId);
            WriteDebug(string.Format("Browser Prog Id: {0}", browserProgId));

            string browserCommandTemplate;
            GetCommandTemplate(browserProgId, out browserCommandTemplate);
            WriteDebug(string.Format("Browser Command Template: {0}", browserCommandTemplate));

            string browserExecutable;
            string parameters;
            EvaluateCommandTemplate(browserCommandTemplate, out browserExecutable, out parameters);
            WriteDebug(string.Format("Browser Executable: {0}", browserExecutable));
            WriteDebug(string.Format("Original Parameters: {0}", parameters));

            parameters = ReplaceSubstitutionParameters(parameters, Url);
            WriteDebug(string.Format("Substituted Parameters: {0}", parameters));

            try
            {
                WriteDebug(string.Format("Starting process: '{0}' {1}", browserExecutable, parameters));
                Process.Start(browserExecutable, parameters);
            }
            catch (InvalidOperationException e) { ThrowTerminatingError(new ErrorRecord(e, e.Message, ErrorCategory.InvalidOperation, Url)); }
            catch (Win32Exception e) { ThrowTerminatingError(new ErrorRecord(e, e.Message, ErrorCategory.NotSpecified, Url)); }
            catch (FileNotFoundException e) { ThrowTerminatingError(new ErrorRecord(e, e.Message, ErrorCategory.ObjectNotFound, Url)); }
        }

        private void GetDefaultBrowserProgId(out string defaultBrowserProgId)
        {
            try
            {
                // midl "C:\Program Files (x86)\Windows Kits\8.1\Include\um\ShObjIdl.idl"
                // tlbimp ShObjIdl.tlb
                var applicationAssociationRegistration = new ApplicationAssociationRegistration();
                applicationAssociationRegistration.QueryCurrentDefault("http", ASSOCIATIONTYPE.AT_URLPROTOCOL, ASSOCIATIONLEVEL.AL_EFFECTIVE, out defaultBrowserProgId);
            }
            catch (COMException e)
            {
                defaultBrowserProgId = null;
                ThrowTerminatingError(new ErrorRecord(e, e.Message, ErrorCategory.NotSpecified, "http"));
            }

            if (string.IsNullOrEmpty(defaultBrowserProgId))
                ThrowTerminatingError(new ErrorRecord(new Exception("GetDefaultBrowserProgId"), "Unknown ProgID", ErrorCategory.NotSpecified, "http"));
        }

        private void GetCommandTemplate(string defaultBrowserProgId, out string commandTemplate)
        {
            var commandTemplateBufferSize = 0U;
            NativeMethods.AssocQueryString(NativeMethods.ASSOCF.ASSOCF_NONE, NativeMethods.ASSOCSTR.ASSOCSTR_COMMAND, defaultBrowserProgId, "open", null, ref commandTemplateBufferSize);
            var commandTemplateStringBuilder = new StringBuilder((int)commandTemplateBufferSize);
            var hresult = NativeMethods.AssocQueryString(NativeMethods.ASSOCF.ASSOCF_NONE, NativeMethods.ASSOCSTR.ASSOCSTR_COMMAND, defaultBrowserProgId, "open", commandTemplateStringBuilder, ref commandTemplateBufferSize);
            commandTemplate = commandTemplateStringBuilder.ToString();

            if (hresult != 0 || string.IsNullOrEmpty(commandTemplate))
                ThrowTerminatingError(new ErrorRecord(new Exception("GetCommandTemplate"), hresult.ToString(), ErrorCategory.NotSpecified, defaultBrowserProgId));
        }

        private void EvaluateCommandTemplate(string commandTemplate, out string application, out string parameters)
        {
            string commandLine;
            var hresult = NativeMethods.SHEvaluateSystemCommandTemplate(commandTemplate, out application, out commandLine, out parameters);

            if (hresult != 0 || string.IsNullOrEmpty(application) || string.IsNullOrEmpty(parameters))
                ThrowTerminatingError(new ErrorRecord(new Exception("EvaluateCommandTemplate"), hresult.ToString(), ErrorCategory.NotSpecified, commandTemplate));
        }

        private string ReplaceSubstitutionParameters(string parameters, string replacement)
        {
            // Not perfect but good enough for this purpose
            return parameters.Replace("%L", replacement)
                             .Replace("%l", replacement)
                             .Replace("%1", replacement);
        }
    }
}
