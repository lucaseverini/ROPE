/**
 * <p>Title: ROPE.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import com.apple.eawt.Application;
import javax.swing.ImageIcon;
import javax.swing.UIManager;
// import com.apple.eawt.QuitStrategy;

public class ROPE /* extends com.apple.eawt.Application */
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
			// Use reflection here...
			Application.getApplication().setDockIconImage(new ImageIcon(getClass().getResource("Images/appIcon330.gif")).getImage());
			
			System.setProperty("apple.awt.graphics.EnableQ2DX", "true");
			System.setProperty("apple.laf.useScreenMenuBar", "true");
			System.setProperty("com.apple.mrj.application.apple.menu.about.name", "ROPE");
			
			// setQuitStrategy(QuitStrategy.SYSTEM_EXIT_0);
		}

		try
		{
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		}
		catch (Exception ex) {}
	   
		Runtime.getRuntime().addShutdownHook(new Thread()
		{
			@Override
			public void run()
			{
				// If the main frame is still open save the preferences
				if(mainFrame != null && !mainFrame.closed())
				{
					mainFrame.savePreferences();
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

