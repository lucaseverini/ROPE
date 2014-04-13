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
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;
import javax.swing.*;

public class RopeFrame extends JFrame implements WindowListener, FocusListener
{
 	private static final long serialVersionUID = 1L;
	private static final String TITLE = "ROPE/1401 by Ronald Mak, Stan Paddock and Luca Severini (Version 2.0 April 12 2014)";
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
		
        this.setTitle(TITLE);
    
        JPanel contentPanel = (JPanel)this.getContentPane();
        contentPanel.add(desktop);
        desktop.setBackground(new Color(215, 215, 255));
					
		setupMenus();
				
		Dimension ropeFrameSize = this.getContentPane().getSize();

		editFrame = new EditFrame(this);
	    Point frameLocation = new Point(0, 0);
		frameSize = editFrame.getSize();
		
		frameLocation = RopeHelper.parsePoint(userPrefs.get("editFrameLocation", editFrame.getLocation().toString()));	
		frameSize = RopeHelper.parseDimension(userPrefs.get("editFrameSize", editFrame.getSize().toString()));

        editFrame.setLocation(frameLocation);
		editFrame.setSize(frameSize);
		editFrame.setVisible(true);
        desktop.add(editFrame);
        
        execFrame = new ExecFrame(this);
	    frameLocation.setLocation((ropeFrameSize.width / 2), 0);
		frameSize = execFrame.getSize();
	 	
		frameLocation = RopeHelper.parsePoint(userPrefs.get("execFrameLocation", execFrame.getLocation().toString()));	
		frameSize = RopeHelper.parseDimension(userPrefs.get("execFrameSize", execFrame.getSize().toString()));

        execFrame.setLocation(frameLocation);
		execFrame.setSize(frameSize);
		execFrame.setVisible(false);
		desktop.add(execFrame);
		
        printoutFrame = new PrintoutFrame(this);
	 	frameSize.setSize(printoutFrame.getWidth(), ropeFrameSize.height - editFrame.getHeight());
        frameLocation.setLocation(0, ropeFrameSize.height - frameSize.height);
		
		frameLocation = RopeHelper.parsePoint(userPrefs.get("printoutFrameLocation", frameLocation.toString()));	
		frameSize = RopeHelper.parseDimension(userPrefs.get("printoutFrameSize", frameSize.toString()));	
		
        printoutFrame.setLocation(frameLocation);
		printoutFrame.setSize(frameSize);
	    printoutFrame.setVisible(false);
        desktop.add(printoutFrame);
		
		currentChildFrame = editFrame;
		
		setVisible(true);

		clipboardListener = new ClipboardListener(this);
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

        if (haveAssemblyErrors()) 
		{
            try {
                editFrame.setSelected(true);
            }
            catch(PropertyVetoException ignore) {}
        }
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
        printoutFrame.toBack();

        commandWindows.addElement(printoutFrame);

        try 
		{
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
			Dimension ropeFrameSize = this.getContentPane().getSize();

			memoryFrame = new MemoryFrame(this);
			Dimension frameSize = memoryFrame.getSize();
			Point frameLocation = new Point((int)(ropeFrameSize.getWidth() - frameSize.getWidth()) / 2, 
											(int)(ropeFrameSize.getHeight() - frameSize.getHeight()) / 2);

			frameLocation = RopeHelper.parsePoint(userPrefs.get("memoryFrameLocation", frameLocation.toString()));	
			frameSize = RopeHelper.parseDimension(userPrefs.get("memoryFrameSize", frameSize.toString()));	

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
            desktop.getDesktopManager().activateFrame(memoryFrame);
 		}
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
            Dimension ropeSize = this.getContentPane().getSize();
            Dimension consoleSize = consoleFrame.getSize();

            consoleFrame.setLocation(((int)(ropeSize.getWidth() - consoleSize.getWidth())),
                                     ((int)(ropeSize.getHeight() - consoleSize.getHeight())));
            desktop.add(consoleFrame);
            consoleFrame.setVisible(true);

            commandWindows.addElement(consoleFrame);
        }
        else 
		{
            desktop.getDesktopManager().deiconifyFrame(consoleFrame);
            desktop.getDesktopManager().activateFrame(consoleFrame);
        }
    }

    void consoleFrameClosed()
    {
        consoleFrame = null;
    }

    void createTimerFrame()
    {
        if (timerFrame == null) 
		{
            timerFrame = new TimerFrame(this);
            Dimension ropeSize = this.getContentPane().getSize();
            Dimension frameSize = timerFrame.getSize();

            timerFrame.setLocation(((int) (ropeSize.getWidth() - frameSize.getWidth() - 100)),
                                     ((int) (ropeSize.getHeight() - frameSize.getHeight())) - 100);
            desktop.add(timerFrame);
            timerFrame.setVisible(true);

            commandWindows.addElement(timerFrame);
        }
        else 
		{
            desktop.getDesktopManager().deiconifyFrame(timerFrame);
            desktop.getDesktopManager().activateFrame(timerFrame);
        }
    }

    void timerFrameClosed()
    {
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
/*
	@Override
    protected void processWindowEvent(WindowEvent event)
    {
        super.processWindowEvent(event);

        if (event.getID() == WindowEvent.WINDOW_CLOSED) 
		{
            Simulator.kill();
			
            System.exit(0);
        }
    }
*/	
	@Override
	public void windowClosing(WindowEvent e) 
	{	
		quitRope();
   	}

	@Override
	public void windowOpened(WindowEvent e)
	{
		checkPreferences();
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
	
	void checkPreferences()
	{
		File execFile = new File(AssemblerOptions.assemblerPath);
		if(!execFile.exists() || execFile.isDirectory()) 
		{
			String message = String.format("Invalid path to Assembler: %s", AssemblerOptions.assemblerPath);
			System.out.println(message);
			
			JOptionPane.showMessageDialog(this, message);
		}

		execFile = new File(SimulatorOptions.simulatorPath);
		if(!execFile.exists() || execFile.isDirectory()) 
		{
			String message = String.format("Invalid path to Simulator: %s", SimulatorOptions.simulatorPath);
			System.out.println(message);

			JOptionPane.showMessageDialog(this, message);
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
        JOptionPane.showConfirmDialog(this, "About", "About", JOptionPane.OK_OPTION);
        return true;
    }
	
	public boolean quitRope()
	{
		if(editFrame.sourcePath != null && editFrame.sourceChanged)
		{
			int result = JOptionPane.showConfirmDialog(null, "Do you want to save the changes to the edited file?", "Exit Rope",
																								JOptionPane.YES_NO_CANCEL_OPTION);
			if (result == JOptionPane.CANCEL_OPTION)
			{
				return false;
			}
			else if (result == JOptionPane.YES_OPTION)
			{
				editFrame.saveAction();
			}
		}
		
		int result = JOptionPane.showConfirmDialog(null, "Do you want to quit Rope?", "Exit Rope", JOptionPane.YES_NO_OPTION);
		if (result == JOptionPane.YES_OPTION)
		{
			savePreferences();

			this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

			closed = true;
		}
		
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
