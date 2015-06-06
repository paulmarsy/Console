namespace ConsoleGitHubSyncer.Git
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using System.Text;
    using System.Threading;

    public class GitOutput
    {
        private static readonly object OutputSyncLock = new object();
        private StringBuilder _tempStringBuilder = new StringBuilder();
        private readonly ConcurrentQueue<string> _outputQueue = new ConcurrentQueue<string>();
        private readonly Process _process;
        private readonly StreamReader _streamReader;
        private readonly Thread _streamReaderThread;
        private readonly IWriter _writer;

        public GitOutput(Process process, StreamReader streamReader, IWriter writer)
        {
            _process = process;
            _streamReader = streamReader;
            _writer = writer;
            _streamReaderThread = new Thread(ReadStreamOutput) {IsBackground = true};
            _streamReaderThread.Start();
        }

        public bool HasFinished
        {
            get { return _streamReader.EndOfStream && _process.HasExited; }
        }

        public void Join()
        {
            _streamReaderThread.Interrupt();
            _streamReaderThread.Join();
        }

        public string GetOuputAsString()
        {
            return string.Join(Environment.NewLine, GetOutput());
        }

        public IEnumerable<string> GetOutput()
        {
            while (!HasFinished || !_outputQueue.IsEmpty)
            {
                string line;
                if (_outputQueue.TryDequeue(out line) && !string.IsNullOrWhiteSpace(line))
                    yield return line;
            }
        }

        private void ReadStreamOutput()
        {
            while (!HasFinished)
            {
                try
                {
                    var chr = _streamReader.Read();
                    lock (OutputSyncLock)
                    {
                        AppendChar(chr);
                        while (_streamReader.Peek() > -1)
                            AppendChar(_streamReader.Read());

                        UpdateOutputQueue();
                    }
                }
                catch (ThreadInterruptedException)
                {
                }
            }
        }

        private void AppendChar(int chr)
        {
            lock (OutputSyncLock)
            {
                if (chr <= 0)
                    return;

                _tempStringBuilder.Append((char) chr);
                _writer.Character((char) chr);
            }
        }

        private void UpdateOutputQueue()
        {
            lock (OutputSyncLock)
            {
                foreach (var line in _tempStringBuilder
                    .ToString()
                    .Trim()
                    .Split(new[] {'\r', '\n'}, StringSplitOptions.RemoveEmptyEntries))
                    _outputQueue.Enqueue(line);

                _tempStringBuilder = new StringBuilder();
            }
        }
    }
}