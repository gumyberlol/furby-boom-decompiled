using UnityEngine;

namespace Furby
{
    public class SetDrinkingAnimLayers : MonoBehaviour
    {
        private void Update()
        {
            Animation anim = GetComponent<Animation>();
            if (anim == null) return;
            foreach (AnimationState state in anim)
            {
                if (state.enabled && (state.name.Contains("rinking") || state.name.Contains("Idle") || state.name.Contains("idle")))
                    UnityEngine.Debug.Log("[Monitor] playing=" + state.name + " layer=" + state.layer + " weight=" + state.weight + " time=" + state.time);
            }
            foreach (Renderer r in GetComponentsInChildren<Renderer>(true))
            {
                if (!r.enabled)
                    UnityEngine.Debug.Log("[Monitor] DISABLED renderer: " + r.name);
            }
        }

        private void Start()
        {
            Animation anim = GetComponent<Animation>();
            if (anim == null) { Debug.Log("[DrinkLayers] No Animation component found!"); return; }
            string[] drinkClips = { "drinkingSmoothie", "drinkingSmoothie02", "drinkingSmoothie03", "drinkingSmoothie_0", "drinkingSmoothie02_0", "drinkingSmoothie03_0", "bottleDrink" };
            foreach (string clip in drinkClips)
            {
                AnimationState state = anim[clip];
                if (state != null)
                {
                    state.layer = 1;
                    Debug.Log("[DrinkLayers] Set layer 1 for: " + clip);
                }
                else
                {
                    Debug.Log("[DrinkLayers] Clip not found: " + clip);
                }
            }
        }
    }
}
