/**
 * @title RopeResources.java
 * @author Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.util.ResourceBundle;

// RopeResources -----------------------------------------------------
public class RopeResources 
{	
	static ResourceBundle strings;
	static ResourceBundle buildTimeStrings;
	
	static 
	{
        init();
    }
	
	public static void init()
	{
		try
		{
			strings = ResourceBundle.getBundle("rope1401.Resources.Strings");
			
			buildTimeStrings = ResourceBundle.getBundle("rope1401.Resources.BuildTimeStrings");
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	public static String getString(String key)
	{
		String str = "";
		
		try
		{
			str = RopeResources.strings.getString(key);
		}
		catch (Exception ex) {}
		
		return str;
	}
	
	public static String getBuildString(String key)
	{
		if(buildTimeStrings == null)
		{
			return "";
		}
		
		String str = "";
		
		try
		{
			str = RopeResources.buildTimeStrings.getString(key);
		}
		catch (Exception ex) {}
		
		return str;
	}
}
