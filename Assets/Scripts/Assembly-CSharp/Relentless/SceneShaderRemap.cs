using UnityEngine;

namespace Relentless
{
    public class SceneShaderRemap : MonoBehaviour
    {
        private void Awake()
        {
            foreach (Renderer r in FindObjectsOfType(typeof(Renderer)) as Renderer[])
            {
                BundleShaderRemap.Remap(r.gameObject);
            }
        }

        private void OnLevelWasLoaded(int level)
        {
            AdjustPanels();
        }

        private void Start()
        {
            AdjustPanels();
        }

        private void AdjustPanels()
        {
            float aspect = (float)Screen.width / (float)Screen.height;
            foreach (UIPanel panel in FindObjectsOfType(typeof(UIPanel)) as UIPanel[])
            {
                if (panel.clipping == UIDrawCall.Clipping.None) continue;
                Vector4 cr = panel.clipRange;
                int newWidth = (int)(cr.w * aspect);
                if ((float)newWidth != cr.z)
                    panel.clipRange = new Vector4(cr.x, cr.y, newWidth, cr.w);
            }
        }
    }
}
