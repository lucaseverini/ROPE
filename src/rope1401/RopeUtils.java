/**
 * <p>Title: RopeUtils.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

// RopeUtils -----------------------------------------------------
public class RopeUtils 
{
	public static String separator = System.getProperty("file.separator");

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
	
	public static String pathComponent(String filename) 
	{
		int idx = filename.lastIndexOf(separator);	  
		return (idx > -1) ? filename.substring(0, idx) : filename;
	}
}
