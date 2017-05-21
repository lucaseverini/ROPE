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

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class RopeUtils 
{
	public static String separator = System.getProperty("file.separator");
	public static String tmpDir = System.getProperty("java.io.tmpdir");

	public static String removeExtension(String path) 
	{
		int extensionIndex = path.lastIndexOf(".");
		if (extensionIndex == -1)
		{
			return path;
		}
		
		return path.substring(0, extensionIndex);
	}

	public static String getExtension(String path) 
	{
		int extensionIndex = path.lastIndexOf(".");
		if (extensionIndex == -1)
		{
			return "";
		}
		
		return path.substring(extensionIndex + 1);
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
	
	public static String addPathSeparator(String path)
	{
		if(path.lastIndexOf(separator) == path.length() - 1)
		{
			return path;
		}
		else
		{
			return path + separator;
		}
	}
	
	public static void copyFileUsingStream(File source, File dest) throws IOException 
	{
		InputStream is = null;
		OutputStream os = null;
		try {
			is = new FileInputStream(source);
			os = new FileOutputStream(dest);
			byte[] buffer = new byte[10240];
			int length;
			while ((length = is.read(buffer)) > 0)
			{
				os.write(buffer, 0, length);
			}
		} 
		finally
		{
			if(is != null)
			{
				is.close();
			}
			
			if(os != null)
			{
				os.close();
			}
		}
	}
	
	public static String copyFile(String source, boolean copyInTmpDir) throws IOException
	{
		String filePath = addPathSeparator(copyInTmpDir ? tmpDir : pathComponent(source));
		String fileName = getFileName(source);
		String fileExt = getExtension(fileName);
		String timeStr = "" + System.currentTimeMillis();
				
		String dest = filePath + removeExtension(fileName) + "_" + timeStr + "." + getExtension(fileName);
		
		File fileSource = new File(source);
		File fileDest = new File(dest);
		copyFileUsingStream(fileSource, fileDest);
		
		return dest;
	}
}
