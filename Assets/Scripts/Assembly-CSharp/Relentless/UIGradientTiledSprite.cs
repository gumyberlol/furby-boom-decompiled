using UnityEngine;

namespace Relentless
{
	[ExecuteInEditMode]
	[AddComponentMenu("NGUI/UI/Tiled Sprite (Gradient)")]
	public class UIGradientTiledSprite : UITiledSprite
	{
		[SerializeField]
		[HideInInspector]
		public UIGradientAddin mGradient;

		// WIDESCREEN PATCH (disabled) -- re-enable to stretch background to fill widescreen
		//private void Start()
		//{
		//	UIRoot root = NGUITools.FindInParents<UIRoot>(base.gameObject);
		//	if (root != null)
		//	{
		//		float aspect = (float)Screen.width / (float)Screen.height;
		//		Vector3 s = cachedTransform.localScale;
		//		s.x = root.activeHeight * aspect;
		//		cachedTransform.localScale = s;
		//	}
		//}

		public override void OnFill(BetterList<Vector3> verts, BetterList<Vector2> uvs, BetterList<Color32> cols)
		{
			base.OnFill(verts, uvs, cols);
			mGradient.ApplyGradient(verts, uvs, cols, base.color, base.transform);
		}
	}
}
