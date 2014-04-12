/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import java.io.*;

class Assembler
{
	// private static String sourceName;
	// private static String sourcePath;
    private static BufferedReader stdout;
    private static Process process;

    static void setPaths(String sourceName, String sourcePath)
    {
		// Assembler.sourceName = sourceName;
		// Assembler.sourcePath = sourcePath;
    }

    static boolean version()
    {
        String command = AssemblerOptions.assemblerPath + " -V";

        try 
		{
            process = Runtime.getRuntime().exec(command);
            stdout = new BufferedReader(new InputStreamReader(process.getInputStream()));
 
			process = null;
			
			return true;
		}
        catch(IOException ex) 
		{
            ex.printStackTrace();
			
			return false;
        }
    }

    static boolean assemble()
    {
        try 
		{
			Simulator.kill();
			
            process = Runtime.getRuntime().exec(AssemblerOptions.command);
            stdout = new BufferedReader(new InputStreamReader(process.getInputStream()));
			
			process = null;

			return true;
        }
        catch(IOException ex) 
		{
            ex.printStackTrace();
			
			return false;
        }
    }

    static String output()
    {
        try 
		{
            String line = stdout.readLine();
            if (line == null) 
			{
                stdout.close();
            }

            return line;
        }
        catch (IOException ex) 
		{
            ex.printStackTrace();
			
            return null;
        }
    }

	static void kill()
    {
        if (process != null)
		{
            process.destroy();            
            System.out.println("Assembler killed");
        }
    }
}
