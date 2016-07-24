/**
 * <p>Title: Simulator.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;

class Simulator
{
    private static BufferedWriter stdin;
    private static BufferedReader stdout;
    private static BufferedReader stderr;
    private static Process process;
    private static boolean isActive;
    private static boolean isBusy;

    private static long wallStartTime;
    private static long simulatorStartTime;
    private static long simulatorElapsedTime;

    private static boolean timersReset = true;
	
	static boolean isBusy()
	{
		return isBusy;
	}

	static boolean isActive()
	{
		return isActive;
	}

    static BufferedReader getStderr()
    {
        return stderr;
    }

    static boolean start()
    {
        try 
		{
            cleanup();

			String[] args = new String[1];
			args[0] = SimulatorOptions.simulatorPath;
		    process = Runtime.getRuntime().exec(args);
			
            isActive = true;

            System.out.println("Simulator started");

            stdin = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()));
            stdout = new BufferedReader(new InputStreamReader(process.getInputStream()));
            stderr = new BufferedReader(new InputStreamReader(process.getErrorStream()));

            setupFiles();
            resetTimers();
			
            simulatorStartTime = System.currentTimeMillis();
			
			if(SimulatorOptions.useOldConversion)
			{
				execute("SET CPU OLDCONVERSIONS");
			}

			return true;
        }
        catch(IOException ex) 
		{
            ex.printStackTrace();
			
			return false;
        }
    }

    private static void setupFiles()
    {
        // Clear printout file.
        try 
		{
            new BufferedWriter(new FileWriter(DataOptions.outputPath));
        }
        catch(IOException ex) 
		{
            ex.printStackTrace();
        }

        synchronized(Simulator.class) 
		{
            execute("at cdr " + DataOptions.inputPath);
            execute("at lpt " + DataOptions.outputPath);

            if (DataOptions.unitCommands != null) 
			{
                for (int i = 0; i < DataOptions.unitCommands.size(); ++i) 
				{
					System.out.println(DataOptions.unitCommands.get(i));
                    execute((String)DataOptions.unitCommands.get(i));
                }
            }
        }
    }

    static void stop()
    {
        execute("q");
        isActive = false;
    }

    static void execute(String command)
    {
        if (isActive) 
		{
            try 
			{
                if (timersReset) 
				{
                    wallStartTime = System.currentTimeMillis();
                    timersReset = false;
                }

                simulatorStartTime = System.currentTimeMillis();

                stdin.write(command + "\n");
                stdin.flush();
				
                Thread.yield();

                System.out.println("sim> " + command);

            }
            catch (IOException ex) 
			{
                ex.printStackTrace();
                kill();
            }
        }
    }

    static boolean hasOutput()
    {
        try 
		{
            return stdout.ready();
        }
        catch (IOException ex) 
		{
            ex.printStackTrace();
			
            return false;
        }
    }

    static boolean hasOutput(int waitTime)
    {
        try 
		{
            Thread.sleep(waitTime);
			
            return stdout.ready();
        }
        catch (IOException ex) 
		{
            ex.printStackTrace();
            return false;
        }
		catch (InterruptedException ex) 
		{
            ex.printStackTrace();
            return false;
        }
    }

    static String output()
    {
        try 
		{
			String output = "";
			if(stdout.ready())
			{
				output = stdout.readLine();
				
				isBusy = false;
			}
			else
			{
				System.out.println("Not ready");
				
				isBusy = true;
			}
			
            simulatorElapsedTime += System.currentTimeMillis() - simulatorStartTime;
            simulatorStartTime = System.currentTimeMillis();

            System.out.println(output);

            return output;
        }
        catch (IOException ex) 
		{
            ex.printStackTrace();
			
            return null;
        }
    }

    static void resetTimers()
    {
        wallStartTime = System.currentTimeMillis();
        simulatorStartTime = 0;
        simulatorElapsedTime = 0;

        timersReset = true;
    }

    static long elapsedWallTime()
    {
        return System.currentTimeMillis() - wallStartTime;
    }

    static long elapsedSimulatorTime()
    {
        return simulatorElapsedTime;
    }

    static void kill()
    {
        if (process != null)
		{
            process.destroy();            
            System.out.println("Simulator killed");
			
			isActive = false;
			isBusy = false;
        }
    }

    public static void cleanup()
    {
        try 
		{
            if (isActive) 
			{
                stop();
                kill();
            }

			if(stdin != null)
			{
				stdin.close();
			}
			
 			if(stdout != null)
			{
				stdout.close();
			}
			
  			if(stderr != null)
			{
				stderr.close();
			}
        }
        catch (IOException ignore) {}
    }

	@Override
    protected void finalize()
    {
		cleanup();
		
		try 
		{
			super.finalize();
		} 
		catch (Throwable ex) {}
    }
}
