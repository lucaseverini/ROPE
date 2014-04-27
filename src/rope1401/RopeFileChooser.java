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
import javax.swing.*;

// TO BE DONE:
// More OS-like dialogs

class RopeFileChooser extends JFileChooser
{
	private static final long serialVersionUID = 1L;
	
	private Component parent;
	
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
        else if(directoryPath != null)
		{
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
/*
	RopeFileChooser(Component parent)
    {     
		this.parent = parent;
    }

	File chooseFile(String startDirPath, JTextField textField, Vector<RopeFileFilter> filter, boolean multiple)
	{		
		FileDialog fd = new FileDialog((Frame)parent, "Choose a source file", FileDialog.LOAD);
		fd.setDirectory(startDirPath);
		
		MyFileFilter fileFilter = new MyFileFilter(filter);
		fd.setFilenameFilter(fileFilter);
		fd.setVisible(true);
		
		String filename = fd.getFile();
		if (filename == null)
		{
			System.out.println("You cancelled the choice");
		}
		else
		{
			System.out.println("You chose " + filename);
		}
		
		return null;
	}
	
	File chooseDirectory(String startDirPath, JTextField textField, boolean multiple)
	{
		return null;
	}
	
	class MyFileFilter implements FilenameFilter
	{
		Vector<RopeFileFilter> filters;
	
		public MyFileFilter(Vector<RopeFileFilter> filters)
		{
			this.filters = filters;
		}
		
		@Override
		public boolean accept(File dir, String name)
		{
			if(filters == null || filters.isEmpty())
			{
				return true;
			}
			
			int idx = name.lastIndexOf('.');
			if (idx >= 0) 
			{
				String fileExt = name.substring(idx);
				
				for(RopeFileFilter filter : filters)
				{
					for(String filterExt : filter.getExtensions())
					{
						if(fileExt.equals(filterExt))
						{
							return true;
						}
					}
				}
			}	
			
			return false;
		}
	}
*/
}

