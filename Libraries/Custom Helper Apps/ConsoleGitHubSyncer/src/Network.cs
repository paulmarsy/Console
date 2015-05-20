namespace ConsoleGitHubSyncer
{
    using System.Runtime.InteropServices;

    public static class Network
    {
        private const int FLAG_ICC_FORCE_CONNECTION = 1;

        [DllImport("wininet.dll")]
        private static extern bool InternetCheckConnection(string lpszUrl, int dwFlags, int dwReserved);

        public static bool CheckInternetConnection(string url = null)
        {
            return InternetCheckConnection(url, FLAG_ICC_FORCE_CONNECTION, 0);
        }
    }
}