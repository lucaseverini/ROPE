/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import javax.swing.JInternalFrame;
import javax.swing.JMenuItem;
import javax.swing.event.InternalFrameEvent;
import javax.swing.event.InternalFrameListener;

public class ChildFrame extends JInternalFrame implements InternalFrameListener
{
	private static final long serialVersionUID = 1L;

	protected RopeFrame mainFrame;
	
	ChildFrame(RopeFrame ropeFrame)
	{
		mainFrame = ropeFrame;
		
		addInternalFrameListener(this);
	}

	@Override
	public void internalFrameOpened(InternalFrameEvent e)
	{
	}

	@Override
	public void internalFrameClosing(InternalFrameEvent e)
	{
	}

	@Override
	public void internalFrameClosed(InternalFrameEvent e)
	{
	}

	@Override
	public void internalFrameIconified(InternalFrameEvent e)
	{
	}

	@Override
	public void internalFrameDeiconified(InternalFrameEvent e)
	{
	}

	@Override
	public void internalFrameActivated(InternalFrameEvent e)
	{
		mainFrame.currentChildFrame = this;

		setupMenus();	// setup menus accordingly

		// System.out.println("Activated " + title);
	}

	@Override
	public void internalFrameDeactivated(InternalFrameEvent e)
	{
		mainFrame.currentChildFrame = this;
		
		// Disable all File menu items except exit and preferences...
		int count = mainFrame.fileMenu.getItemCount();
		// On other systems than Mac the quit and preferences are in the file menu
		if(!RopeHelper.isMac)
		{
			count -= 4; 
		}
		for(int idx = 0; idx < count; idx++)
		{
			JMenuItem item = mainFrame.fileMenu.getItem(idx);
			if(item != null)
			{
				item.setEnabled(false);
			}
		}
		
		// Disable all Edit menu items...
		count = mainFrame.editMenu.getItemCount();
		for(int idx = 0; idx < count; idx++)
		{
			JMenuItem item = mainFrame.editMenu.getItem(idx);
			if(item != null)
			{
				item.setEnabled(false);
			}
		}
		
		// System.out.println("Deactivated " + title);
	}
	
	public void setupMenus()
	{
		mainFrame.undoItem.setEnabled(canUndo());
		mainFrame.redoItem.setEnabled(canRedo());
		mainFrame.cutItem.setEnabled(canCut());
		mainFrame.copyItem.setEnabled(canCopy());
		mainFrame.pasteItem.setEnabled(canPaste());
		mainFrame.deleteItem.setEnabled(canDelete());
		mainFrame.selectAllItem.setEnabled(canSelectAll());
		mainFrame.selectLineItem.setEnabled(canSelectLine());
	}

	public boolean canUndo()
	{
		return false;
	}

	public boolean canRedo()
	{
		return false;
	}

	public boolean canCut()
	{
		return false;
	}

	public boolean canCopy()
	{
		return false;
	}

	public boolean canPaste()
	{
		return false;
	}

	public boolean canDelete()
	{
		return false;
	}

	public boolean canSelectAll()
	{
		return false;
	}

	public boolean canSelectLine()
	{
		return false;
	}
}
