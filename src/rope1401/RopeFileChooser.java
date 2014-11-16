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
import java.util.ArrayList;
import javax.swing.*;

// TO BE DONE:
// More OS-like dialogs

class RopeFileChooser extends JFileChooser
{
	private static final long serialVersionUID = 1L;
	
	private Component parent;
	
    RopeFileChooser(String directoryPath, String filePath, ArrayList<RopeFileFilter> filters, boolean directories, boolean multiple)
    {
        super();
		
        this.setMultiSelectionEnabled(multiple);
        this.setFileSelectionMode(directories ? DIRECTORIES_ONLY : FILES_ONLY);

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

    RopeFileChooser(String directoryPath, String filePath, ArrayList<RopeFileFilter> filter)
    {
        this(directoryPath, filePath, filter, false, false);
    }

    File open(Component parent, JTextField textField)
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

    File open(Component parent, JTextField textField, boolean multiple)
    {
 		this.setAcceptAllFileFilterUsed(true);

        if (!multiple) 
		{
            return open(parent, textField);
        }

        int option = this.showOpenDialog(parent);

        if (option == JFileChooser.APPROVE_OPTION) 
		{
            File files[] = this.getSelectedFiles();
            StringBuilder buffer = new StringBuilder();

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
	
	File save(Component parent)
	{		
		this.setAcceptAllFileFilterUsed(false);
		
		int option = this.showSaveDialog(parent);
        if (option == JFileChooser.APPROVE_OPTION) 
		{
			return this.getSelectedFile();
		}
		else
		{
			return null;
		}
	}

	@Override 
	public void approveSelection() 
	{
		if (getDialogType() == SAVE_DIALOG) 
		{
			File selFile = getSelectedFile();
			if ((selFile != null) && selFile.exists()) 
			{
				String msg = String.format("The file %s already exists.\nDo you want to replace the existing file?", selFile.getName());
				int response = JOptionPane.showConfirmDialog(this, msg, "Ovewrite file", JOptionPane.YES_NO_OPTION, 
																							JOptionPane.WARNING_MESSAGE);				
				if (response != JOptionPane.YES_OPTION)
				{
					return;
				}
			}
		}
				
		super.approveSelection();
    }
	
	public JTextField getTextField() 
	{
		Container container = this;
		for (int idx = 0; idx < container.getComponentCount(); idx++) 
		{
			Component child = container.getComponent(idx);
			if (child instanceof JTextField) 
			{
				return (JTextField) child;
			} 
			else if (child instanceof Container) 
			{
				JTextField field = getTextFieldIter((Container) child);
				if (field != null) 
				{
					return field;
				}
			}
		}
        
		return null;
    }

		private JTextField getTextFieldIter(Container container) 
	{
		for (int idx = 0; idx < container.getComponentCount(); idx++) 
		{
			Component child = container.getComponent(idx);
			if (child instanceof JTextField) 
			{
				return (JTextField) child;
			} 
			else if (child instanceof Container) 
			{
				JTextField field = getTextFieldIter((Container) child);
				if (field != null) 
				{
					return field;
				}
			}
		}
        
		return null;
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

