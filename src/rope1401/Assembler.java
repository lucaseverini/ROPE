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
import java.util.Vector;

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
		String[] args = new String[2];
		args[0] = AssemblerOptions.assemblerPath;
		args[1] = "-V";

        try 
		{
            process = Runtime.getRuntime().exec(args);
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
			
			String[] args = AssemblerOptions.command.toArray(new String[0]);
			
			// The path to the assembler executable may be changed so we re-set it be safe
			args[0] = AssemblerOptions.assemblerPath;
			
            process = Runtime.getRuntime().exec(args);
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
