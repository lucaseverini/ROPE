/**
 * @title RopeResources.java
 * @author Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.filechooser.FileFilter;

// RopeFileFilter -----------------------------------------------------
public class RopeFileFilter extends FileFilter
{
    private final String extensions[];
    private final String description;

    public RopeFileFilter(String extensions[], String description)
    {
        this.extensions = new String[extensions.length];
        this.description = description;

        for (int i = 0; i < extensions.length; ++i) 
		{
            this.extensions[i] = extensions[i].toLowerCase();
        }
    }

	@Override
    public boolean accept(File file)
    {
        if (file.isDirectory()) 
		{
            return true;
        }
		else if (isLink(file)) 
		{
            return true;
        }

        String name = file.getName().toLowerCase();
        for (int i = 0; i < extensions.length; ++i) 
		{
            if (name.endsWith(extensions[i])) 
			{
                return true;
            }
        }

        return false;
    }

	@Override
    public String getDescription()
    {
        return description;
    }

	public String[] getExtensions()
    {
        return extensions;
    }

	private boolean isLink(File file) 
	{		
        try {
			if (file.getAbsolutePath().equals(file.getCanonicalPath())) 
			{
                return false;
            }
        } catch (IOException ex) 
		{
            Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }
}
