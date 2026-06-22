using System.Collections.Generic;
using Prime31;
using UnityEngine;

public class LocalyticsAndroid
{
	private static AndroidJavaObject _plugin;

	static LocalyticsAndroid()
	{
		if (Application.platform != RuntimePlatform.Android)
		{
			return;
		}
		using (AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.prime31.LocalyticsPlugin"))
		{
			_plugin = androidJavaClass.CallStatic<AndroidJavaObject>("instance", new object[0]);
		}
	}

	public static void startSession(string apiKey)
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			_plugin.Call("startSession", apiKey);
		}
	}

	public static void startSession(string apiKey, string[] customDimensions)
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			_plugin.Call("startSessionWithCustomDimensions", apiKey, customDimensions);
		}
	}

	public static void endSession()
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			_plugin.Call("endSession");
		}
	}

	public static void setCustomerData(string key, string value)
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			_plugin.Call("setCustomerData", key, value);
		}
	}

	public static void tagEvent(string eventName)
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			_plugin.Call("tagEvent", eventName);
		}
	}

	public static void tagEventWithAttributes(string eventName, Dictionary<string, string> attributes)
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			if (attributes == null)
			{
				tagEvent(eventName);
				return;
			}
			_plugin.Call("tagEventWithAttributes", eventName, attributes.toJson());
		}
	}

	public static void tagScreen(string screenName)
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			_plugin.Call("tagScreen", screenName);
		}
	}
}
