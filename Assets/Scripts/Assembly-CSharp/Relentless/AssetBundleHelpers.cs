using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Relentless
{
    public static class AssetBundleHelpers
    {
        public class AssetBundleLoad
        {
            public bool isLoaded;
            public UnityEngine.Object m_object;
        }

        private static Dictionary<string, object> m_concurrentlyLoadedAssetBundles = new Dictionary<string, object>();
        private static Dictionary<string, AssetBundle> m_loadedBundles = new Dictionary<string, AssetBundle>();

        public static string GetStreamingAssetsPath()
        {
            return Application.streamingAssetsPath + "/Generated/Android/";
        }

        public static bool IsLoading()
        {
            return m_concurrentlyLoadedAssetBundles.Count != 0;
        }

        public static string LowerCaseAfterFinalSlash(string inputString)
        {
            int num = inputString.LastIndexOf("/");
            if (num >= 0)
            {
                return inputString.Substring(0, num) + inputString.Substring(num).ToLower();
            }
            return inputString.ToLower();
        }

        public static IEnumerator Load(string path, bool compressed, AssetBundleLoad prefabResult, GameObject activeObject, Type expectedType, bool forceLowerCase)
        {
            if (path.Contains(" "))
            {
                Logging.LogError("Path has space - may cause issues: " + path);
            }

            string bundlePath = forceLowerCase ? LowerCaseAfterFinalSlash(path) : path;
            string fullPath = GetStreamingAssetsPath() + bundlePath + ".unity3d";

            Logging.Log("Loading asset bundle from: " + fullPath);

            m_concurrentlyLoadedAssetBundles[path] = new object();

            AssetBundle bundle;
            if (!m_loadedBundles.TryGetValue(fullPath, out bundle))
            {
                WWW www = new WWW("file://" + fullPath);
                yield return www;

                if (!string.IsNullOrEmpty(www.error))
                {
                    Logging.LogError("Failed to load bundle: " + fullPath + " | " + www.error);
                    prefabResult.isLoaded = true;
                    m_concurrentlyLoadedAssetBundles.Remove(path);
                    yield break;
                }

                bundle = www.assetBundle;
                m_loadedBundles[fullPath] = bundle;
            }

            UnityEngine.Object obj = bundle.mainAsset;

            if (obj == null)
            {
                Logging.LogError("mainAsset is null in bundle: " + fullPath);
            }

            prefabResult.m_object = obj;
            prefabResult.isLoaded = true;

            m_concurrentlyLoadedAssetBundles.Remove(path);
        }
    }
}