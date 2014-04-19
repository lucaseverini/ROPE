/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import java.awt.*;
import java.awt.event.*;
import java.beans.PropertyVetoException;
import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.MessageFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;
import javax.swing.*;

public class RopeFrame extends JFrame implements WindowListener, FocusListener
{
	private final boolean askConfirmationToQuit = false;	// This should go in general preferences

 	private static final long serialVersionUID = 1L;
    private JDesktopPane desktop = new JDesktopPane();
    private ExecFrame execFrame;
    private PrintoutFrame printoutFrame;
    private ConsoleFrame consoleFrame;
    private TimerFrame timerFrame;
	private MemoryFrame memoryFrame;
    private Vector commandWindows = new Vector();
    private boolean packFrame = false;
	private Preferences userPrefs = Preferences.userRoot();
	private boolean closed;
	private EditFrame editFrame;	
	
	public ClipboardListener clipboardListener;
	public ChildFrame currentChildFrame;
	public JMenuBar menuBar;
	public JMenu fileMenu;
 	public JMenu editMenu;
 	public JMenu helpMenu;
 	public JMenuItem undoItem;
	public JMenuItem redoItem;
	public JMenuItem cutItem;
	public JMenuItem copyItem;
	public JMenuItem pasteItem;
	public JMenuItem deleteItem;
	public JMenuItem selectAllItem;
	public JMenuItem selectLineItem;	
	public JMenuItem newItem;	
	public JMenuItem openItem;	
	public JMenuItem saveItem;	
	public JMenuItem saveAsItem;	
	public JMenuItem revertItem;	
	public JMenuItem closeItem;	
	public JMenuItem printItem;	
	public JMenuItem prefsItem;	
	public JMenuItem quitItem;	
	public JMenuItem aboutItem;	

    public RopeFrame()
    {			
		this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
			
		addWindowListener(this);
		addFocusListener(this);

        // Validate frames that have preset sizes
        // Pack frames that have useful preferred size info, e.g. from their layout
        if (packFrame) 
		{
            this.pack();
        }
        else 
		{
            this.validate();
        }

		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        Dimension frameSize = new Dimension(screenSize.width - 10, screenSize.height - (RopeHelper.isMac ? 80 : 50));
        this.setSize(frameSize);
        this.setLocation((screenSize.width - frameSize.width) / 2, 10);
		
        this.setTitle(MessageFormat.format(RopeResources.getString("RopeFrameTitle"), RopeResources.getString("RopeVersion")));
    
        JPanel contentPanel = (JPanel)this.getContentPane();
        contentPanel.add(desktop);
        desktop.setBackground(new Color(215, 215, 255));
					
		setupMenus();
				
		Dimension ropeFrameSize = getSize();

		editFrame = new EditFrame(this);
	    Point editLocation = new Point(0, 0);
		Dimension editSize = new Dimension(editFrame.getSize());
		
		editLocation = RopeHelper.parsePoint(userPrefs.get("editFrameLocation", editLocation.toString()));	
		editSize = RopeHelper.parseDimension(userPrefs.get("editFrameSize", editSize.toString()));

		verifyFrameLocation(editLocation);
		verifyFrameSize(editSize);

        editFrame.setLocation(editLocation);
		editFrame.setSize(editSize);
		editFrame.setVisible(true);
        desktop.add(editFrame);
        
        execFrame = new ExecFrame(this);
	    Point execLocation = new Point(ropeFrameSize.width / 2, 0);
		Dimension execSize = new Dimension(execFrame.getSize());
	 	
		execLocation = RopeHelper.parsePoint(userPrefs.get("execFrameLocation", execLocation.toString()));	
		execSize = RopeHelper.parseDimension(userPrefs.get("execFrameSize", execSize.toString()));
		
		verifyFrameLocation(execLocation);
		verifyFrameSize(execSize);
	
        execFrame.setLocation(execLocation);
		execFrame.setSize(execSize);
		execFrame.setVisible(false);
		desktop.add(execFrame);
		
        printoutFrame = new PrintoutFrame(this);
        Point printoutLocation = new Point(printoutFrame.getLocation());
	 	Dimension printoutSize = new Dimension(printoutFrame.getSize());
		
		printoutLocation = RopeHelper.parsePoint(userPrefs.get("printoutFrameLocation", printoutLocation.toString()));	
		printoutSize = RopeHelper.parseDimension(userPrefs.get("printoutFrameSize", printoutSize.toString()));	
		
		verifyFrameLocation(printoutLocation);		
		verifyFrameSize(printoutSize);
		
        printoutFrame.setLocation(printoutLocation);
		printoutFrame.setSize(printoutSize);
	    printoutFrame.setVisible(false);
        desktop.add(printoutFrame);
		
		currentChildFrame = editFrame;
		
		setVisible(true);

		clipboardListener = new ClipboardListener(this);
	}
	
	void verifyFrameLocation(Point frameLocation)
	{
		Dimension ropeFrameSize = getSize();
		
		if(frameLocation.getX() < 0 || frameLocation.getY() < 0)
		{
			frameLocation.setLocation(0, 0);
		}
		else if(frameLocation.getX() > ropeFrameSize.getWidth()- 20 || frameLocation.getY() > ropeFrameSize.getHeight()- 20)
		{
			frameLocation.setLocation(ropeFrameSize.getWidth() - 20, ropeFrameSize.getHeight() - 20);
		}
	}
	
	void verifyFrameSize(Dimension frameSize)
	{
		Dimension ropeFrameSize = getSize();

		if(frameSize.getWidth() < 20 || frameSize.getHeight() < 20)
		{
			frameSize.setSize(20, 20);
		}
		else if(frameSize.getWidth() > ropeFrameSize.getWidth() || frameSize.getHeight() > ropeFrameSize.getHeight())
		{
			frameSize.setSize(ropeFrameSize.getWidth(), ropeFrameSize.getHeight());
		}
	}
	
	boolean closed()
	{
		return closed;
	}

    void showExecWindow(String baseName)
    {
        desktop.getDesktopManager().deiconifyFrame(execFrame);
        execFrame.setTitle("EXEC: " + baseName);
        execFrame.setVisible(true);
        execFrame.initialize(baseName, DataOptions.outputPath);
		execFrame.toFront();
    }

    void resetExecWindow()
    {
        execFrame.reset();
    }

    void showPrintoutWindow(String baseName)
    {
		desktop.getDesktopManager().deiconifyFrame(printoutFrame);
		printoutFrame.setTitle("PRINTOUT: " + baseName);
		printoutFrame.setVisible(true);
		printoutFrame.initialize();
		printoutFrame.toFront();

		commandWindows.addElement(printoutFrame);

		try 
		{
			execFrame.toFront();
			execFrame.setSelected(true);
		}
		catch(PropertyVetoException ignore) {}
	}
	
	void resetMemoryFrame()
	{
		if (memoryFrame != null) 
		{
			memoryFrame.showMemory();
		}
	}

    void createMemoryFrame()
    {
		if (memoryFrame == null) 
		{
			memoryFrame = new MemoryFrame(this);

			Dimension frameSize = memoryFrame.getSize();
			Point frameLocation = memoryFrame.getLocation();

			frameLocation = RopeHelper.parsePoint(userPrefs.get("memoryFrameLocation", frameLocation.toString()));	
			frameSize = RopeHelper.parseDimension(userPrefs.get("memoryFrameSize", frameSize.toString()));	

			verifyFrameLocation(frameLocation);
			verifyFrameSize(frameSize);
		
			memoryFrame.setLocation(frameLocation);
			memoryFrame.setSize(frameSize);
			memoryFrame.setVisible(true);
			
			desktop.add(memoryFrame);

			commandWindows.addElement(memoryFrame);
			
			try 
			{
				memoryFrame.setSelected(true);
			}
			catch(PropertyVetoException ignore) {}
		}
		else
		{
			desktop.getDesktopManager().deiconifyFrame(memoryFrame);
  		}
		
		desktop.getDesktopManager().activateFrame(memoryFrame);
	}
	
	void removeMemoryFrame()
	{
		commandWindows.remove(memoryFrame);
		
		memoryFrame = null;
	}

    void createConsoleFrame()
    {
        if (consoleFrame == null) 
		{
            consoleFrame = new ConsoleFrame(this);
			
			Dimension frameSize = consoleFrame.getSize();
			Point frameLocation = consoleFrame.getLocation();

			frameLocation = RopeHelper.parsePoint(userPrefs.get("consoleFrameLocation", frameLocation.toString()));	
			frameSize = RopeHelper.parseDimension(userPrefs.get("consoleFrameSize", frameSize.toString()));	

			verifyFrameLocation(frameLocation);
			verifyFrameSize(frameSize);
		
			consoleFrame.setLocation(frameLocation);
			consoleFrame.setSize(frameSize);
			consoleFrame.setVisible(true);
					
			desktop.add(consoleFrame);

            commandWindows.addElement(consoleFrame);
        }
        else 
		{
            desktop.getDesktopManager().deiconifyFrame(consoleFrame);
        }
		
		desktop.getDesktopManager().activateFrame(consoleFrame);
    }

 	void removeConsoleFrame()
	{
		commandWindows.remove(consoleFrame);
		
		consoleFrame = null;
	}

    void createTimerFrame()
    {
        if (timerFrame == null) 
		{
            timerFrame = new TimerFrame(this);
 
			Dimension frameSize = timerFrame.getSize();
			Point frameLocation = timerFrame.getLocation();

			frameLocation = RopeHelper.parsePoint(userPrefs.get("timerFrameLocation", frameLocation.toString()));	
			frameSize = RopeHelper.parseDimension(userPrefs.get("timerFrameSize", frameSize.toString()));	

			verifyFrameLocation(frameLocation);
			verifyFrameSize(frameSize);
		
			timerFrame.setLocation(frameLocation);
			timerFrame.setSize(frameSize);
			timerFrame.setVisible(true);
			
			desktop.add(timerFrame);

            commandWindows.addElement(timerFrame);
		}
        else 
		{
            desktop.getDesktopManager().deiconifyFrame(timerFrame);
        }
		
		desktop.getDesktopManager().activateFrame(timerFrame);
    }

 	void removeTimerFrame()
	{
		commandWindows.remove(timerFrame);
		
		timerFrame = null;
	}

    void resetTimers()
    {
        Simulator.resetTimers();
    }

    void removeCommandWindow(CommandWindow window)
    {
        commandWindows.remove(window);
    }

    void updateCommandWindows()
    {
        Enumeration elements = commandWindows.elements();
        while (elements.hasMoreElements()) 
		{
            CommandWindow window = (CommandWindow) elements.nextElement();
            window.execute();
        }
    }

    void lockCommandWindows()
    {
        Enumeration elements = commandWindows.elements();
        while (elements.hasMoreElements()) 
		{
            CommandWindow window = (CommandWindow) elements.nextElement();
            window.lock();
        }
    }

    void unlockCommandWindows()
    {
        Enumeration elements = commandWindows.elements();
        while (elements.hasMoreElements()) 
		{
            CommandWindow window = (CommandWindow) elements.nextElement();
            window.unlock();
        }
    }

    void writeMessage(Color color, String message)
    {
		// execFrame.writeMessage(color, message);
    }

    private boolean senseSwitchesEnabled = false;

    void enableSenseSwitches()
    {
        if (consoleFrame != null) 
		{
            consoleFrame.enableSenseSwitches();
        }

        senseSwitchesEnabled = true;
    }

    void disableSenseSwitches()
    {
        if (consoleFrame != null) 
		{
            consoleFrame.disableSenseSwitches();
        }

        senseSwitchesEnabled = false;
    }

    boolean senseSwitchesEnabled()
    {
        return senseSwitchesEnabled;
    }

    boolean haveAssemblyErrors()
    {
        return editFrame.haveAssemblyErrors();
    }

	@Override
	public void windowClosing(WindowEvent e) 
	{	
		quitRope();
   	}

	@Override
	public void windowOpened(WindowEvent e)
	{
		loadPreferences();
	}

	@Override
	public void windowClosed(WindowEvent e)
	{
	}

	@Override
	public void windowIconified(WindowEvent e)
	{
	}

	@Override
	public void windowDeiconified(WindowEvent e)
	{
	}

	@Override
	public void windowActivated(WindowEvent e)
	{
	}

	@Override
	public void windowDeactivated(WindowEvent e)
	{
	}
	
	void loadPreferences()
	{
		String simulatorPref = "", assemblerPref = "";
		
		System.out.println("Current directory: " + System.getProperty("user.dir"));
		
		if(RopeHelper.isWindows)
		{
			assemblerPref = userPrefs.get("assemblerPath", "tools/windows/autocoder.exe");
			simulatorPref = userPrefs.get("simulatorPath", "tools/windows/i1401.exe");
		}
		else if(RopeHelper.isMac)
		{
			assemblerPref = userPrefs.get("assemblerPath", "tools/mac/autocoder");
			simulatorPref = userPrefs.get("simulatorPath", "tools/mac/i1401");			
		}
		else if(RopeHelper.isUnix)
		{
			assemblerPref = userPrefs.get("assemblerPath", "tools/linux/autocoder");
			simulatorPref = userPrefs.get("simulatorPath", "tools/linux/i1401");			
		}
		
		AssemblerOptions.saveBeforeAssembly = userPrefs.getBoolean("saveBeforeAssembly", false);
		SimulatorOptions.useOldConversion = userPrefs.getBoolean("useOldConversion", true);
		
		if(!assemblerPref.isEmpty())
		{
			File file = new File(assemblerPref);
			if(!file.exists() || file.isDirectory()) 
			{
				String message = String.format("The path to Assembler program set in preferences is not available.\n%s", assemblerPref);
				System.out.println(message);

				JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
			}
			else
			{
				AssemblerOptions.assemblerPath = assemblerPref;
			}
		}

		if(!simulatorPref.isEmpty())
		{
			File file = new File(simulatorPref);
			if(!file.exists() || file.isDirectory()) 
			{
				String message = String.format("The path to Simulator program set in preferences is not available.\n%s", simulatorPref);
				System.out.println(message);

				JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
			}
			else
			{
				SimulatorOptions.simulatorPath = simulatorPref;
			}
		}

		assemblerPref = System.getenv("ROPE_ASSEMBLER");
		if(assemblerPref != null && !assemblerPref.isEmpty())
		{
			File file = new File(assemblerPref);
			if(!file.exists() || file.isDirectory()) 
			{
				String message = String.format("The path to Assembler program set in environment variable ROPE_ASSEMBLER is not available.\n%s",  
																																	assemblerPref);
				System.out.println(message);

				JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
			}
			else
			{
				AssemblerOptions.assemblerPath = assemblerPref;

				System.out.println("Simulator path set from ROPE_ASSEMBLER: " + assemblerPref);
			}
		}
		
		simulatorPref = System.getenv("ROPE_SIMULATOR");
		if(simulatorPref != null && !simulatorPref.isEmpty())
		{
			File file = new File(simulatorPref);
			if(!file.exists() || file.isDirectory()) 
			{
				String message = String.format("The path to Simulator program set in environment variable ROPE_SIMULATOR is not available.\n%s", 
																																	simulatorPref);
				System.out.println(message);

				JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
			}
			else
			{
				SimulatorOptions.simulatorPath = simulatorPref;
				
				System.out.println("Simulator path set from ROPE_SIMULATOR: " + simulatorPref);
			}
		}

		String var = System.getenv("ROPE_SOURCES_DIR");
		if(var != null && !var.isEmpty())
		{
			File dir = new File(var);
			if(!dir.exists() || !dir.isDirectory()) 
			{
				String message = String.format("The path to sources folder set in environment variable ROPE_SOURCES_DIR is not available.\n%s",  
																																			var);
				System.out.println(message);

				JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
			}
		}
		
		if(AssemblerOptions.assemblerPath == null || AssemblerOptions.assemblerPath.isEmpty())
		{
			String message = "The path to Assembler program is not set."; 
			
			System.out.println(message);

			JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
		}

		if(SimulatorOptions.simulatorPath == null || SimulatorOptions.simulatorPath.isEmpty())
		{
			String message = "The path to Simulator program is not set."; 
			
			System.out.println(message);

			JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
		}
	}
	
	void savePreferences()
	{
		try 
		{
			if(editFrame != null && editFrame.isVisible())
			{
				userPrefs.put("editFrameLocation", editFrame.getLocation().toString());
				userPrefs.put("editFrameSize", editFrame.getSize().toString());
			}
			
			if(execFrame != null && execFrame.isVisible())
			{
				userPrefs.put("execFrameLocation", execFrame.getLocation().toString());
				userPrefs.put("execFrameSize", execFrame.getSize().toString());
			}
			
			if(printoutFrame != null && printoutFrame.isVisible())
			{
				userPrefs.put("printoutFrameLocation", printoutFrame.getLocation().toString());
				userPrefs.put("printoutFrameSize", printoutFrame.getSize().toString());
			}
			
			if(memoryFrame != null && memoryFrame.isVisible())
			{
				userPrefs.put("memoryFrameLocation", memoryFrame.getLocation().toString());
				userPrefs.put("memoryFrameSize", memoryFrame.getSize().toString());
			}

			if(consoleFrame != null && consoleFrame.isVisible())
			{
				userPrefs.put("consoleFrameLocation", consoleFrame.getLocation().toString());
				userPrefs.put("consoleFrameSize", consoleFrame.getSize().toString());
			}

			if(timerFrame != null && timerFrame.isVisible())
			{
				userPrefs.put("timerFrameLocation", timerFrame.getLocation().toString());
				userPrefs.put("timerFrameSize", timerFrame.getSize().toString());
			}

			userPrefs.sync();
			userPrefs.flush();
		}
		catch(BackingStoreException ex) 
		{
			Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
		}	
	}
	
	public void registerForMacOSXEvents() 
	{
		try 
		{
			// Generate and register the OSXAdapter, passing it a hash of all the methods we wish to
			// use as delegates for various com.apple.eawt.ApplicationListener methods
			OSXAdapter.setQuitHandler(this, getClass().getDeclaredMethod("quitRope", (Class[])null));
			OSXAdapter.setAboutHandler(this, getClass().getDeclaredMethod("aboutRope", (Class[])null));
			OSXAdapter.setPreferencesHandler(this, getClass().getDeclaredMethod("doPreferences", (Class[])null));
		} 
		catch (NoSuchMethodException ex) 
		{
			System.err.println("Error while loading the OSXAdapter:");
			ex.printStackTrace();
		}
    }
	
	public boolean aboutRope() 
	{	
		String ropeVersion = RopeResources.getString("RopeVersion");
		String s1 = MessageFormat.format(RopeResources.getString("AboutText1"), ropeVersion);

		String s2 = RopeResources.getString("AboutText2");

		String s3 = "";
		String compilerJDK = RopeResources.getBuildString("CompilerJDK");
		String compilerTime = RopeResources.getBuildString("CompilerTime");
		if(!compilerJDK.isEmpty() && !compilerTime.isEmpty()) // Dont' use this part if there are no real informations to provide
		{
			s3 = MessageFormat.format(RopeResources.getString("AboutText3"), compilerJDK, compilerTime);
		}

		String s4 = MessageFormat.format(RopeResources.getString("AboutText4"), System.getProperty("java.version"),
														System.getProperty("os.name") + " " + System.getProperty("os.version"));

		String message = "";
		if(!s1.isEmpty())
			message = message.concat(s1);
		if(!s2.isEmpty())
			message = message.concat("\n" + s2);
		if(!s3.isEmpty())
			message = message.concat("\n" + s3);
		if(!s4.isEmpty())
			message = message.concat("\n" + s4);
	
		JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.INFORMATION_MESSAGE);
		
		return true;	
    }
	
	public boolean quitRope()
	{
		if(editFrame.sourcePath != null && editFrame.sourceChanged)
		{
			int result = JOptionPane.showConfirmDialog(null, "Do you want to save the changes to the edited file?", "ROPE",
															JOptionPane.QUESTION_MESSAGE, JOptionPane.YES_NO_CANCEL_OPTION);
			if (result == JOptionPane.CANCEL_OPTION)
			{
				return false;
			}
			else if (result == JOptionPane.YES_OPTION)
			{
				editFrame.saveAction();
			}
		}
	
		if(askConfirmationToQuit)
		{
			int result = JOptionPane.showConfirmDialog(null, "Do you want to quit Rope?", "ROPE", 
															JOptionPane.QUESTION_MESSAGE, JOptionPane.YES_NO_OPTION);
			if (result == JOptionPane.NO_OPTION)
			{
				return false;
			}
		}
		
		savePreferences();

		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		closed = true;
		
		return closed;
	}
	
	private void setupMenus()
	{
		menuBar = new JMenuBar();
		
        fileMenu = new JMenu("File");
 
		newItem = new JMenuItem("New...");
        newItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				System.out.println("New...");
            }
        });
		fileMenu.add(newItem);

		openItem = new JMenuItem("Open...");
        openItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				System.out.println("Open...");
            }
        });
		fileMenu.add(openItem);

		fileMenu.addSeparator();

		revertItem = new JMenuItem("Revert...");
        revertItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				System.out.println("Revert...");
            }
        });
		fileMenu.add(revertItem);

		fileMenu.addSeparator();

		saveItem = new JMenuItem("Save");
        saveItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				System.out.println("Save");
            }
        });
		fileMenu.add(saveItem);

		saveAsItem = new JMenuItem("Save as...");
        saveAsItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				System.out.println("Save as...");
            }
        });
		fileMenu.add(saveAsItem);

		fileMenu.addSeparator();

		closeItem = new JMenuItem("Close");
        closeItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				System.out.println("Close");
            }
        });
		fileMenu.add(closeItem);
		
		fileMenu.addSeparator();

		printItem = new JMenuItem("Print");
        printItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				System.out.println("Print");
            }
        });
		fileMenu.add(printItem);
	
		if(RopeHelper.isMac)
		{
			registerForMacOSXEvents();
		}
		else
		{
			fileMenu.addSeparator();

			prefsItem = new JMenuItem("Preferences...");
			prefsItem.addActionListener(new ActionListener()
			{
				@Override
				public void actionPerformed(ActionEvent e) 
				{
					doPreferences();
				}
			});
			fileMenu.add(prefsItem);

			fileMenu.addSeparator();

			quitItem = new JMenuItem("Quit");
			quitItem.addActionListener(new ActionListener()
			{
				@Override
				public void actionPerformed(ActionEvent e) 
				{
					WindowEvent event = new WindowEvent(RopeFrame.this, WindowEvent.WINDOW_CLOSING);
					Toolkit.getDefaultToolkit().getSystemEventQueue().postEvent(event);
				}
			});		
			fileMenu.add(quitItem);
			
			helpMenu = new JMenu("Help");

			aboutItem = new JMenuItem("about ROPE...");
			aboutItem.addActionListener(new ActionListener()
			{
				@Override
				public void actionPerformed(ActionEvent e) 
				{
					aboutRope();
				}
			});		
			helpMenu.add(aboutItem);
		}
				
        editMenu = new JMenu("Edit");
		
		undoItem = new JMenuItem("Undo");
		undoItem.setEnabled(false);
		undoItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks));
        undoItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				callChildFrameMethod("undoMenuAction", e);
            }
        });
		editMenu.add(undoItem);

		redoItem = new JMenuItem("Redo");
		redoItem.setEnabled(false);
		redoItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks + Event.SHIFT_MASK));
		redoItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				callChildFrameMethod("redoMenuAction", e);
            }
        });
		editMenu.add(redoItem);

		editMenu.addSeparator();

		cutItem = new JMenuItem("Cut");
		cutItem.setEnabled(false);
		cutItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_X, RopeHelper.modifierMaks));
        cutItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				callChildFrameMethod("cutMenuAction", e);
            }
        });
		editMenu.add(cutItem);

		copyItem = new JMenuItem("Copy");
 		copyItem.setEnabled(false);
		copyItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_C, RopeHelper.modifierMaks));
        copyItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				callChildFrameMethod("copyMenuAction", e);
			}
        });
		editMenu.add(copyItem);

		pasteItem = new JMenuItem("Paste");
 		pasteItem.setEnabled(false);
		pasteItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_V, RopeHelper.modifierMaks));
        pasteItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				callChildFrameMethod("pasteMenuAction", e);
            }
        });
		editMenu.add(pasteItem);

		editMenu.addSeparator();

		deleteItem = new JMenuItem("Delete");
 		deleteItem.setEnabled(false);
        deleteItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				callChildFrameMethod("deleteMenuAction", e);
            }
        });
		editMenu.add(deleteItem);

		editMenu.addSeparator();

		selectAllItem = new JMenuItem("Select All");
		selectAllItem.setEnabled(false);
		selectAllItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_A, RopeHelper.modifierMaks));
        selectAllItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				callChildFrameMethod("selectAllMenuAction", e);
            }
        });
		editMenu.add(selectAllItem);

		selectLineItem = new JMenuItem("Select Line");
		selectLineItem.setEnabled(false);
		selectLineItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_L, RopeHelper.modifierMaks));
        selectLineItem.addActionListener(new ActionListener()
		{
            @Override
            public void actionPerformed(ActionEvent e) 
			{
				callChildFrameMethod("selectLineMenuAction", e);
            }
        });
		editMenu.add(selectLineItem);

		menuBar.add(fileMenu);
		menuBar.add(editMenu);
		
		if(helpMenu != null)
		{
			menuBar.add(helpMenu);
		}
		
        this.setJMenuBar(menuBar);
	}

	@Override
	public void focusGained(FocusEvent e)
	{
	}

	@Override
	public void focusLost(FocusEvent e)
	{
	}
		
	public void callChildFrameMethod(String methodname, ActionEvent event)
	{		
		if(currentChildFrame == null)
		{
			java.awt.Toolkit.getDefaultToolkit().beep();
			return;
		}
		
		try 
		{
			Method actionMethod = null;

			Class[] arguments = new Class[] { ActionEvent.class };
			actionMethod = currentChildFrame.getClass().getMethod(methodname, arguments);
			if(actionMethod != null)
			{
				try 
				{
					actionMethod.invoke(currentChildFrame, event);
				}
				catch (IllegalAccessException ex) 
				{
					System.out.println("Error invoking method " + methodname);
					
					ex.printStackTrace();
				}
				catch (IllegalArgumentException ex)
				{
					System.out.println("Error invoking method " + methodname);
					
					ex.printStackTrace();
				}
			}
		} 
		catch(NoSuchMethodException ex)
		{
			System.out.println("Method " + methodname + " missing in " + currentChildFrame.getClass());
			
			java.awt.Toolkit.getDefaultToolkit().beep();
		}
		catch (SecurityException ex) 
		{
			ex.printStackTrace();
		}
		catch (InvocationTargetException ex) 
		{
			ex.printStackTrace();
		}
	}
	
	public void doPreferences()
	{
		PreferencesDialog dialog = new PreferencesDialog(this, "Preferences");
        Dimension screenSize = Toolkit.getDefaultToolkit(). getScreenSize();
        Dimension dialogSize = dialog.getSize();
        dialog.setLocation((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2);
		dialog.setVisible(true);
	}
}
