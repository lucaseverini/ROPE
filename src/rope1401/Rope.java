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

public class Rope
{
	private RopeFrame mainFrame;
	
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
	
		loadPreferences();
		
	    mainFrame = new RopeFrame();
    }

    public static void main(String[] args)
    {
        Rope rope = new Rope();
    }
	
	public static void savePreferences()
	{
		try
		{
			// Retrieve the user preference node
			Preferences userPrefs = Preferences.userRoot();

			userPrefs.put("assemblerPath", AssemblerOptions.assemblerPath);
			userPrefs.put("simulatorPath", SimulatorOptions.simulatorPath);
			userPrefs.putBoolean("saveBeforeAssembly", AssemblerOptions.saveBeforeAssembly);
			userPrefs.putBoolean("useOldConversion", SimulatorOptions.useOldConversion);

			userPrefs.sync();
			userPrefs.flush();
		}
		catch(BackingStoreException ex)
		{
			Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
		}
	}
	
	public static void loadPreferences()
	{
		// Retrieve the user preference node
		Preferences userPrefs = Preferences.userRoot();

		//userPrefs.remove("assemblerPath");
		//userPrefs.remove("simulatorPath");

		// Get the value of the preference;
		// default value is returned if the preference does not exist
		if(RopeHelper.isWindows)
		{
			AssemblerOptions.assemblerPath = userPrefs.get("assemblerPath", "tools/windows/autocoder.exe");
			SimulatorOptions.simulatorPath = userPrefs.get("simulatorPath", "tools/windows/i1401.exe");
		}
		else if(RopeHelper.isMac)
		{
			AssemblerOptions.assemblerPath = userPrefs.get("assemblerPath", "tools/mac/autocoder");
			SimulatorOptions.simulatorPath = userPrefs.get("simulatorPath", "tools/mac/i1401");			
		}
		else
		{
			AssemblerOptions.assemblerPath = userPrefs.get("assemblerPath", "tools/linux/autocoder");
			SimulatorOptions.simulatorPath = userPrefs.get("simulatorPath", "tools/linux/i1401");			
		}
		
		AssemblerOptions.saveBeforeAssembly = userPrefs.getBoolean("saveBeforeAssembly", false);
		SimulatorOptions.useOldConversion = userPrefs.getBoolean("useOldConversion", true);
	}
}
