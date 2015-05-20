namespace ConsoleGitHubSyncer
{
    using System.Collections.Generic;
    using System.Linq;

    public static class ExtensionMethods
    {
        public static TSource SingleOrValue<TSource>(this IEnumerable<TSource> source, TSource value) where TSource : class
        {
            return source.SingleOrDefault() ?? value;
        }
    }
}