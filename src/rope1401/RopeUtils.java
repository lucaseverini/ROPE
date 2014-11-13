/**
 * @title RopeUtils.java
 * @author Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

// RopeUtils -----------------------------------------------------
public class RopeUtils 
{
	public static String removeExtension(String path) 
	{
		int extensionIndex = path.lastIndexOf(".");
		if (extensionIndex == -1)
		{
			return path;
		}
		
		return path.substring(0, extensionIndex);
	}

	public static String getFileName(String path) 
	{
		String separator = System.getProperty("file.separator");

		int lastSeparatorIndex = path.lastIndexOf(separator);
		if (lastSeparatorIndex == -1) 
		{
			return path;
		} 
		else 
		{
			return path.substring(lastSeparatorIndex + 1);
		}
	}
}
