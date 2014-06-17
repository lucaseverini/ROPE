/**
 * @title ChildFrame.java
 * @author Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentListener;
import javax.swing.JInternalFrame;
import javax.swing.JMenuItem;
import javax.swing.event.InternalFrameEvent;
import javax.swing.event.InternalFrameListener;

public class ChildFrame extends JInternalFrame implements InternalFrameListener, ComponentListener
{
	private static final long serialVersionUID = 1L;

	protected RopeFrame mainFrame;
	
	ChildFrame(RopeFrame ropeFrame)
	{
		mainFrame = ropeFrame;
		
		addInternalFrameListener(this);
	    addComponentListener(this);		
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
		
		// Reneable the items that are always active
		mainFrame.newItem.setEnabled(canNew());
		mainFrame.openItem.setEnabled(canOpen());
		mainFrame.pageSetupItem.setEnabled(canPageSetup());
		
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
		mainFrame.newItem.setEnabled(canNew());
		mainFrame.openItem.setEnabled(canOpen());
		mainFrame.saveItem.setEnabled(canSave());
		mainFrame.saveAsItem.setEnabled(canSaveAs());
		mainFrame.revertItem.setEnabled(canRevert());
		mainFrame.closeItem.setEnabled(canClose());
		mainFrame.pageSetupItem.setEnabled(canPageSetup());
		mainFrame.printItem.setEnabled(canPrint());
			
		mainFrame.undoItem.setEnabled(canUndo());
		mainFrame.redoItem.setEnabled(canRedo());
		mainFrame.cutItem.setEnabled(canCut());
		mainFrame.copyItem.setEnabled(canCopy());
		mainFrame.pasteItem.setEnabled(canPaste());
		mainFrame.deleteItem.setEnabled(canDelete());
		mainFrame.selectAllItem.setEnabled(canSelectAll());
		mainFrame.selectLineItem.setEnabled(canSelectLine());
		
		if(RopeHelper.isMac)
		{
			// On Mac OS those three menus arer managed in a different way...
		}
		else
		{
			mainFrame.prefsItem.setEnabled(canPrefs());
			mainFrame.quitItem.setEnabled(canQuit());
			mainFrame.aboutItem.setEnabled(canAbout());
		}
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
	
	public boolean canNew()
	{
		return true;
	}

	public boolean canOpen()
	{
		return true;
	}

	public boolean canPrefs()
	{
		return true;
	}

	public boolean canQuit()
	{
		return true;
	}

	public boolean canAbout()
	{
		return true;
	}

	public boolean canSave()
	{
		return false;
	}

	public boolean canSaveAs()
	{
		return false;
	}

	public boolean canRevert()
	{
		return false;
	}

	public boolean canClose()
	{
		return false;
	}
	
	public boolean canPageSetup()
	{
		return true;
	}

	public boolean canPrint()
	{
		return false;
	}

	@Override
	public void componentResized(ComponentEvent e)
	{
		Point p = getLocation();
		Dimension s = getSize();
		
		if(p.y < -5)
		{
			p.y = -5;
			setLocation(p);
		}
		
		if(p.x + s.width < 40)
		{
			p.x = -(s.width - 40);
			setLocation(p);
		}
		else if(p.x > mainFrame.getWidth() - 40)
		{
			p.x = mainFrame.getWidth() - 40;
			setLocation(p);
		}
	}

	@Override
	public void componentMoved(ComponentEvent e)
	{
		Point p = getLocation();
		Dimension s = getSize();

		if(p.y < -5)
		{
			p.y = -5;
			setLocation(p);
		}

		if(p.x + s.width < 40)
		{
			p.x = -(s.width - 40);
			setLocation(p);
		}
		else if(p.x > mainFrame.getWidth() - 40)
		{
			p.x = mainFrame.getWidth() - 40;
			setLocation(p);
		}
	}

	@Override
	public void componentShown(ComponentEvent e)
	{
	}

	@Override
	public void componentHidden(ComponentEvent e)
	{
	}
}


