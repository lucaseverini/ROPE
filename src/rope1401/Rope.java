/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;
import javax.swing.JOptionPane;

public class Rope
{
	public static RopeFrame mainFrame;
	
    public Rope()
    {
		if(RopeHelper.isMac)
		{
			System.setProperty("apple.laf.useScreenMenuBar", "true");
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
