/**
 * <p>Title: ROPE.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import javax.swing.ImageIcon;
import javax.swing.UIManager;
import java.lang.reflect.Method;
import java.awt.Image;

public class ROPE
{
	public static RopeFrame mainFrame;
	public static ImageIcon appIcon128;
	public static ImageIcon appIcon64;
	public static ImageIcon appIcon32;
	
    public ROPE()
    {	
		appIcon128 = new ImageIcon(getClass().getResource("Images/appIcon128.gif"));
		appIcon64 = new ImageIcon(getClass().getResource("Images/appIcon64.gif"));
		appIcon32 = new ImageIcon(getClass().getResource("Images/appIcon32.gif"));
		
		if(RopeHelper.isMac)
		{
			// Uses reflection to load eand execute methods of Mac-specific class com.apple.eawt.Application
			try 
			{
				Class application = Class.forName("com.apple.eawt.Application");
				Method getApplication = application.getMethod("getApplication");
				Object applicationInstance = getApplication.invoke(null);
				Method setDockIconImage = applicationInstance.getClass().getMethod("setDockIconImage", java.awt.Image.class);
				
				Image icon = new ImageIcon(getClass().getResource("Images/appIcon330.gif")).getImage();
				setDockIconImage.invoke(applicationInstance, icon);

				System.setProperty("apple.awt.graphics.EnableQ2DX", "true");
				System.setProperty("apple.laf.useScreenMenuBar", "true");
				System.setProperty("com.apple.mrj.application.apple.menu.about.name", "ROPE");
			}
			catch (Exception ex) 
			{
				ex.printStackTrace();
			}
		}

		try
		{
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		}
		catch (Exception ex) 
		{
			ex.printStackTrace();
		}
	   
		Runtime.getRuntime().addShutdownHook(new Thread()
		{
			@Override
			public void run()
			{
				// If the main frame is still open save the preferences
				if(mainFrame != null && !mainFrame.closed())
				{
					mainFrame.savePreferences();

					mainFrame.setIconImage(new ImageIcon(getClass().getResource("Images/appIcon330.gif")).getImage());
				}

				// Kill Assembler and Simulator if still open
				Assembler.kill();
				Simulator.kill();
			}
		});
		
	    mainFrame = new RopeFrame();
    }

    public static void main(String[] args)
    {
        ROPE rope = new ROPE();
    }
}

