namespace ConsoleGitHubSyncer
{
    using System;
    using System.Diagnostics;

    public static class Write
    {
        static Write()
        {
            Success = new Success();
            Error = new Error();
            Status = new Status();
            Progress = new Progress();
            Info = new Info();
            Debug = new Debug();
            Trace = new Trace();
        }

        public static IWriter Success { get; private set; }
        public static IWriter Error { get; private set; }
        public static IWriter Status { get; private set; }
        public static IWriter Progress { get; private set; }
        public static IWriter Info { get; private set; }
        public static IWriter Debug { get; private set; }
        public static IWriter Trace { get; private set; }
    }

    public interface IWriter
    {
        void Line();
        void Line(string format, params object[] arg);
        void Line(string message);
        void Character(char chr);
        void PressAnyKeyToContinue();
    }

    public abstract class BaseWriter : IWriter
    {
        protected abstract ConsoleColor Color { get; }

        public void Line()
        {
            Write(null);
        }

        public void Line(string format, params object[] arg)
        {
            Line(string.Format(format, arg));
        }

        public void Line(string message)
        {
            Write(message + Environment.NewLine);
        }

        public void Character(char chr)
        {
            Write(chr.ToString());
        }

        public virtual void PressAnyKeyToContinue()
        {
            Write("Press any key to continue. . . ");
            Console.ReadKey(true);
            Line(Environment.NewLine);
        }

        protected virtual void Write(string message)
        {
            Console.ForegroundColor = Color;
            Console.Write(message);
        }

        ~BaseWriter()
        {
            Console.ResetColor();
        }
    }

    internal abstract class BaseDebugWriter : BaseWriter
    {
#if DEBUG
        protected BaseDebugWriter()
        {
            System.Diagnostics.Debug.Listeners.Clear();
            System.Diagnostics.Debug.Listeners.Add(new TextWriterTraceListener(Console.Out));
            System.Diagnostics.Debug.AutoFlush = true;
        }

        protected override void Write(string message)
        {
            Console.ForegroundColor = Color;
            System.Diagnostics.Debug.Write(message);
        }        
#else
        protected override void Write(string message) { }
        
        public override void PressAnyKeyToContinue() { }
#endif
    }


    internal class Success : BaseWriter
    {
        protected override ConsoleColor Color
        {
            get { return ConsoleColor.Green; }
        }
    }

    internal class Error : BaseWriter
    {
        protected override ConsoleColor Color
        {
            get { return ConsoleColor.Red; }
        }
    }

    internal class Status : BaseWriter
    {
        protected override ConsoleColor Color
        {
            get { return ConsoleColor.White; }
        }
    }

    internal class Progress : BaseWriter
    {
        protected override ConsoleColor Color
        {
            get { return ConsoleColor.Yellow; }
        }
    }

    internal class Info : BaseWriter
    {
        protected override ConsoleColor Color
        {
            get { return ConsoleColor.DarkYellow; }
        }
    }

    internal class Trace : BaseDebugWriter
    {
        protected override ConsoleColor Color
        {
            get { return ConsoleColor.Gray; }
        }
    }

    internal class Debug : BaseDebugWriter
    {
        protected override ConsoleColor Color
        {
            get { return ConsoleColor.DarkGray; }
        }
    }
}