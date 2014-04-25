/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import javax.swing.UIManager;
import com.apple.eawt.QuitStrategy;

public class Rope extends com.apple.eawt.Application
{
	public static RopeFrame mainFrame;
	
    public Rope()
    {	
		if(RopeHelper.isMac)
		{
			System.setProperty("apple.awt.graphics.EnableQ2DX", "true");
			System.setProperty("apple.laf.useScreenMenuBar", "true");
			System.setProperty("com.apple.mrj.application.apple.menu.about.name", "Rope");
			
			setQuitStrategy(QuitStrategy.SYSTEM_EXIT_0);
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
        Rope rope = new Rope();
    }
}
