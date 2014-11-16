/**
 * @title ClipboardListener.java
 * @author Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.awt.*;  
import java.awt.datatransfer.*;  

public class ClipboardListener extends Thread implements ClipboardOwner 
{  
	private final Clipboard sysClip;  
	RopeFrame mainFrame;
	public boolean hasValidContent;
	
	ClipboardListener (RopeFrame parent)
	{
		mainFrame = parent;
		
		// This is ugly but necessary because mainFrame.clipboardListener is used in canPaste() below
		mainFrame.clipboardListener = this;
		
		sysClip = Toolkit.getDefaultToolkit().getSystemClipboard();
		
		hasValidContent = checkContent(sysClip.getContents(this));
		
		if(mainFrame.currentChildFrame != null && mainFrame.currentChildFrame.canPaste())
		{
			mainFrame.pasteItem.setEnabled(hasValidContent);
		}
	
		start();
	}

	@Override
	public void run() 
	{  
		try 
		{
			regainOwnership(sysClip.getContents(this));  
		}
		catch(Exception ex) {}
	
		while(true) 
		{
			try 
			{
				Thread.sleep(100);
			}
			catch(InterruptedException ex) {}
		}  
	}  

	@Override
	public void lostOwnership(Clipboard c, Transferable t) 
	{  
		// Sleeps a little bit to let the clipboard be ready and avoid exceptions...
		try 
		{  
			sleep(100);  
		} 
		catch(InterruptedException ex) 
		{  
			System.out.println("Exception: " + ex);  
		}  
		
		Transferable contents = sysClip.getContents(this);
		
		hasValidContent = checkContent(contents);
		
		if(mainFrame.currentChildFrame != null && mainFrame.currentChildFrame.canPaste())
		{
			mainFrame.pasteItem.setEnabled(hasValidContent);
		}
		
		regainOwnership(contents);  
	}   

	void regainOwnership(Transferable t) 
	{  
		sysClip.setContents(t, this);  
	}  
	
	boolean checkContent(Transferable content)
	{	
		return ((content != null) && content.isDataFlavorSupported(DataFlavor.stringFlavor));
	}
}  

