using System.Collections.Generic;
using UnityEngine;

namespace Relentless
{
    public static class BundleShaderRemap
    {
        private static Dictionary<string, Shader> s_cache = new Dictionary<string, Shader>();

        private static Dictionary<string, string> s_nameRemap = new Dictionary<string, string>
        {
            { "Unlit/Transparent", "Unlit/Transparent Colored" },
            { "Particles/Additive", "Mobile/Particles/Additive" },
            { "Particles/Alpha Blended", "Mobile/Particles/Alpha Blended" },
            { "Particles/Multiply", "Mobile/Particles/Multiply" },
            { "Particles/Additive (Soft)", "Mobile/Particles/Additive" },
            { "Particles/VertexLit Blended", "Mobile/Particles/VertexLit Blended" },
        };

        public static void Remap(GameObject go)
        {
            foreach (Renderer r in go.GetComponentsInChildren<Renderer>(true))
            {
                Material[] mats = r.sharedMaterials;
                bool changed = false;
                for (int i = 0; i < mats.Length; i++)
                {
                    if (mats[i] == null) continue;
                    Shader remapped = Find(mats[i].shader.name);
                    if (remapped != null && remapped != mats[i].shader)
                    {
                        mats[i].shader = remapped;
                        changed = true;
                    }
                }
                if (changed) r.sharedMaterials = mats;
            }
        }

        private static Shader Find(string name)
        {
            Shader s;
            if (s_cache.TryGetValue(name, out s) && s != null) return s;
            string remappedName;
            if (s_nameRemap.TryGetValue(name, out remappedName)) name = remappedName;
            s = Shader.Find(name);
            if (s != null) s_cache[name] = s;
            return s;
        }
    }
}
