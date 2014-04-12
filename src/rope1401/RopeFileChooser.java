/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import java.awt.*;
import java.io.*;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.*;
import javax.swing.filechooser.FileFilter;

class RopeFileChooser extends JFileChooser
{
	private static final long serialVersionUID = 1L;
	
    RopeFileChooser(String directoryPath, String filePath, Vector<RopeFileFilter> filters, boolean directories, boolean multiple)
    {
        super();
		
        this.setMultiSelectionEnabled(multiple);
        this.setFileSelectionMode(directories ? DIRECTORIES_ONLY : FILES_ONLY);
		this.setAcceptAllFileFilterUsed(true);

        if (filePath != null) 
		{
            this.setSelectedFile(new File(filePath));
        }
        else 
		{
            if (directoryPath == null) 
			{
                directoryPath = System.getProperties().
							getProperty("file.separator").equals("/") ? System.getProperties().getProperty("user.home") : "c:\\";
            }

            this.setCurrentDirectory(new File(directoryPath));
        }

        if (filters != null && !filters.isEmpty()) 
		{
			for(RopeFileFilter filter : filters)
			{
				this.addChoosableFileFilter(filter);
			}
        }
    }

    RopeFileChooser(String directoryPath, String filePath, Vector<RopeFileFilter> filter)
    {
        this(directoryPath, filePath, filter, false, false);
    }

    File choose(JTextField textField, Component parent)
    {
        int option = this.showOpenDialog(parent);

        if (option == JFileChooser.APPROVE_OPTION) 
		{
            File file = this.getSelectedFile();
            textField.setText(file.getPath());

            return file;
        }
        else 
		{
            return null;
        }
    }

    File choose(JTextField textField, Component parent, boolean multiple)
    {
        if (!multiple) 
		{
            return choose(textField, parent);
        }

        int option = this.showOpenDialog(parent);

        if (option == JFileChooser.APPROVE_OPTION) 
		{
            File files[] = this.getSelectedFiles();
            StringBuffer buffer = new StringBuffer();

            for (int i = 0; i < files.length; ++i) 
			{
                if (i > 0) 
				{
                    buffer.append(";");
                }
                buffer.append(files[i].getPath());
            }

            textField.setText(buffer.toString());
            return files[0];
        }
        else 
		{
            return null;
        }
    }
}

class RopeFileFilter extends FileFilter
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
