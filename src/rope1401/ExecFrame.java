/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.*;
import java.io.*;
import java.util.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.event.*;

public class ExecFrame extends ChildFrame implements ActionListener, ChangeListener
{
	private static final long serialVersionUID = 1L;
	
    BorderLayout borderLayout1 = new BorderLayout();
    BorderLayout borderLayout2 = new BorderLayout();
    TitledBorder titledBorder1;
    GridBagLayout gridBagLayout1 = new GridBagLayout();
    GridBagLayout gridBagLayout2 = new GridBagLayout();
    JScrollPane listingScrollPane = new JScrollPane();
    MyJList listing = new MyJList();
    JPanel controlPanel = new JPanel();
    JPanel messagePanel = new JPanel();
    JTextArea messageArea = new JTextArea();
    JPanel buttonPanel = new JPanel();
    JPanel filler1Panel = new JPanel();
    JPanel filler2Panel = new JPanel();
    JCheckBox showAllCheckBox = new JCheckBox();
    JButton simulatorButton = new JButton();
    JButton optionsButton = new JButton();
    JButton dataButton = new JButton();
    JButton startButton = new JButton();
    JButton quitButton = new JButton();
    JButton singleStepButton = new JButton();
    JButton autoStepButton = new JButton();
    JButton fasterButton = new JButton();
    JButton slowerButton = new JButton();
    JButton showMemoryButton = new JButton();
    JButton showConsoleButton = new JButton();
    JButton showTimerButton = new JButton();

    private DataDialog dialog = null;
    private Hashtable lineTable;

    private static int INIT_AUTO_STEP_WAIT_TIME = 200;

    private Thread autoStepper;
    private int autoStepWaitTime;

    private boolean simulatorRunning = false;
    private boolean programRunning = false;
    private boolean settingBreakpoint = false;
    private boolean autoStepping = false;

    private String baseName;
    private String currentMessage = null;

    private Font listingFont = null;
    private ImageIcon nobreakIcon = null;
    private ImageIcon breakableIcon = null;
    private ImageIcon breakPointIcon = null;

    public ExecFrame(RopeFrame parent)
    {
		super(parent);
	
		// Implement a smarter way to set the initial frame position and size
		setLocation(960, 0);
		setSize(960, 710);

        try 
		{
            jbInit();
        }
        catch (Exception ex) 
		{
            ex.printStackTrace();
        }

        simulatorButton.addActionListener(this);
        optionsButton.addActionListener(this);
        dataButton.addActionListener(this);
        showAllCheckBox.addChangeListener(this);
        startButton.addActionListener(this);
        quitButton.addActionListener(this);
        singleStepButton.addActionListener(this);
        autoStepButton.addActionListener(this);
        slowerButton.addActionListener(this);
        fasterButton.addActionListener(this);
        showMemoryButton.addActionListener(this);
        showConsoleButton.addActionListener(this);
        showTimerButton.addActionListener(this);

		listingFont = new Font("Monospaced", Font.PLAIN, 12);
		
		java.net.URL imgUrl = getClass().getResource("Images/nobreak.gif");
		nobreakIcon = new ImageIcon(imgUrl);
		
		imgUrl = getClass().getResource("Images/breakable.gif");
		breakableIcon = new ImageIcon(imgUrl);
		
		imgUrl = getClass().getResource("Images/breakpoint.gif");
		breakPointIcon = new ImageIcon(imgUrl);

        listing.setCellRenderer(new ListingLineRenderer());

        listing.addMouseListener(new MouseAdapter()
        {
			@Override
            public void mousePressed(MouseEvent event)
            {
                if (simulatorRunning && event.getX() <= 16) 
				{
					settingBreakpoint = true;
				}
			}
	
			@Override
            public void mouseReleased(MouseEvent event)
            {				
				if (settingBreakpoint && event.getX() <= 16) 
				{
                    flipBreakpoint(listing.locationToIndex(event.getPoint()));
                }
				else
				{
					Point mouseLoc = event.getPoint();
					int idx = listing.locationToIndex(mouseLoc);
					if(idx >= 0)
					{
						Rectangle bounds = listing.getCellBounds(idx, idx);
						if(bounds.contains(mouseLoc))
						{
							if(listing.getSelectedIndex() != idx)
							{
								ListingLine line = (ListingLine)listing.getModel().getElementAt(idx);
								if(line.breakable)
								{
									listing.setSelectedIndex(idx);
								}
							}
						}
					}
				}

				repaint();
				
				settingBreakpoint = false;
			}
			
			@Override
            public void mouseClicked(MouseEvent event)
            {
            }
        });

        listing.addMouseMotionListener(new MouseMotionAdapter()
        {
			@Override
            public void mouseDragged(MouseEvent event)
            {
            }
        });

		// Remove automatic key bindings because we want them controlled by menu items
		InputMap im = listing.getInputMap(JComponent.WHEN_FOCUSED);
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks + InputEvent.SHIFT_MASK), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_X, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_C, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_V, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_A, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_L, RopeHelper.modifierMaks), "none");
	}

    void jbInit() throws Exception
    {
        titledBorder1 = new TitledBorder(BorderFactory.createLineBorder(new Color(153, 153, 153), 2), "Simulator messages");
        this.getContentPane().setLayout(borderLayout1);
        this.setIconifiable(true);
        this.setMaximizable(true);
        this.setResizable(true);
        this.setTitle("EXEC");
		
        listing.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        controlPanel.setLayout(gridBagLayout1);
        messagePanel.setLayout(borderLayout2);
        messagePanel.setBorder(titledBorder1);
        messagePanel.setMinimumSize(new Dimension(12, 50));
        messagePanel.setPreferredSize(new Dimension(12, 50));
        messageArea.setBackground(new Color(205, 205, 205));
        messageArea.setFont(new java.awt.Font("Dialog", 1, 12));
        messageArea.setForeground(Color.blue);
        messageArea.setText("");
        buttonPanel.setLayout(gridBagLayout2);
        buttonPanel.setBorder(BorderFactory.createLoweredBevelBorder());
        filler1Panel.setLayout(null);
        filler2Panel.setLayout(null);
        simulatorButton.setEnabled(true);
        simulatorButton.setText("Kill simulator");
        optionsButton.setEnabled(false);
        optionsButton.setText("Simulator options ...");
        dataButton.setEnabled(true);
        dataButton.setText("Runtime data ...");
        showAllCheckBox.setEnabled(true);
        showAllCheckBox.setText("Show all");
        startButton.setEnabled(false);
        startButton.setText("Start program");
        quitButton.setEnabled(false);
        quitButton.setText("Quit program");
        singleStepButton.setEnabled(false);
        singleStepButton.setText("Single step");
        autoStepButton.setEnabled(false);
        autoStepButton.setText("Auto step");
        fasterButton.setEnabled(false);
        fasterButton.setText("Faster");
        slowerButton.setEnabled(false);
        slowerButton.setText("Slower");
        showMemoryButton.setEnabled(false);
        showMemoryButton.setText("Memory ...");
        showConsoleButton.setEnabled(false);
        showConsoleButton.setText("Console ...");
        showTimerButton.setText("Timers ...");
        listingScrollPane.getViewport().add(listing, null);
        controlPanel.add(messagePanel,
                         new GridBagConstraints(0, 0, 4, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 5), 0, 0));
        messagePanel.add(messageArea, BorderLayout.CENTER);
        controlPanel.add(buttonPanel,
                         new GridBagConstraints(0, 1, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 5, 5), 0, 0));
        buttonPanel.add(simulatorButton,
                        new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 0, 0), 0, 0));
        buttonPanel.add(optionsButton,
                        new GridBagConstraints(0, 1, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 5, 0), 0, 0));
        buttonPanel.add(dataButton,
                        new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 20, 0, 15), 0, 0));
        buttonPanel.add(showAllCheckBox,
                        new GridBagConstraints(1, 1, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 5, 0), 0, 0));
        buttonPanel.add(startButton,
                        new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 0, 0), 0, 0));
        buttonPanel.add(quitButton,
                        new GridBagConstraints(2, 1, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 5, 0), 0, 0));
        buttonPanel.add(singleStepButton,
                        new GridBagConstraints(3, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 0, 0), 0, 0));
        buttonPanel.add(autoStepButton,
                        new GridBagConstraints(3, 1, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 5, 0), 0, 0));
        buttonPanel.add(fasterButton,
                        new GridBagConstraints(4, 1, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 5, 0), 0, 0));
        buttonPanel.add(slowerButton,
                        new GridBagConstraints(4, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 0, 0), 0, 0));
        buttonPanel.add(showTimerButton,
                        new GridBagConstraints(5, 1, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 5, 5), 0, 0));
        buttonPanel.add(showMemoryButton,
                        new GridBagConstraints(6, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.SOUTH,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 0, 0, 5), 0, 0));
        buttonPanel.add(showConsoleButton,
                        new GridBagConstraints(6, 1, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 0, 5, 5), 0, 0));

        this.getContentPane().add(listingScrollPane, BorderLayout.CENTER);
        this.getContentPane().add(controlPanel, BorderLayout.SOUTH);
        buttonPanel.add(filler2Panel,
                        new GridBagConstraints(5, 0, 1, 1, 0.0, 0.0
                                               , GridBagConstraints.CENTER,
                                               GridBagConstraints.BOTH,
                                               new Insets(0, 0, 0, 0), 0, 0));
    }

    public static final Color DARK_RED = new Color(150, 0, 0);

    void initialize(String baseName, String outPath)
    {
        this.baseName = baseName;

        programRunning = false;
        startButton.setText("Start program");

        simulatorButton.setEnabled(false);
        optionsButton.setEnabled(false);
        dataButton.setEnabled(true);
        startButton.setEnabled(false);
        quitButton.setEnabled(false);
        singleStepButton.setEnabled(false);
        autoStepButton.setEnabled(false);
        slowerButton.setEnabled(false);
        fasterButton.setEnabled(false);
        showMemoryButton.setEnabled(false);
        showConsoleButton.setEnabled(false);
        showTimerButton.setEnabled(false);

        autoStepWaitTime = INIT_AUTO_STEP_WAIT_TIME;
        currentMessage = null;

        loadListing();

        if (mainFrame.haveAssemblyErrors()) 
		{
            writeMessage(DARK_RED, "*** Correct assembly errors before continuing.");
            mainFrame.lockCommandWindows();
        }
        else if ((AssemblerOptions.listingPath == null) || (outPath == null)) 
		{
            writeMessage(DARK_RED, "*** Missing or empty listing or object deck files.");
            mainFrame.lockCommandWindows();
        }
        else 
		{
            clearMessage();

            if (simulatorRunning) 
			{
                killSimulator();
            }

            if(startSimulator())
			{
				mainFrame.resetMemoryFrame();
			}
 			else
			{
				String message = String.format("SimH failed!\nVerify the correctness of SimH path\n%s", 
																			SimulatorOptions.simulatorPath);
				System.out.println(message);
				JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
			}
       }
    }

    void reset()
    {
        if (simulatorRunning) 
		{
            killSimulator();
        }
		
		mainFrame.resetMemoryFrame();
    }

    void writeMessage(Color color, String message)
    {
        messageArea.setForeground(color);
        messageArea.setText(message);
    }

    void clearMessage()
    {
        messageArea.setText(null);
    }

    private void loadListing()
    {
        Vector v = filterListing();

        if (v != null) 
		{
            listing.clearSelection();
            listing.setListData(v);

            if (currentMessage == null) 
			{
                listing.ensureIndexIsVisible(0);
            }
            else 
			{
                selectCurrentLine(currentMessage);
            }

			checkListContent();
		}
    }

    private Vector filterListing()
    {
        boolean noErrors = !mainFrame.haveAssemblyErrors();
        boolean filtering = !showAllCheckBox.isSelected();
        Vector v = new Vector();
        String line;
        int index = 0;
        BufferedReader listFile = null;

        lineTable = new Hashtable();

        try 
		{
            listFile = new BufferedReader(new FileReader(AssemblerOptions.listingPath));

            while ((line = listFile.readLine()) != null) 
			{
                if (!filtering || ((line.length() > 5) && (line.startsWith("  101")))) 
				{
                    break;
                }
            }

            if (line == null) 
			{
                return v;
            }

            do 
			{
                if (line.length() > 1) 
				{
                    char firstChar = line.charAt(0);

                    if (!filtering || (firstChar == ' ')) 
					{
                        boolean breakable = noErrors && canHaveBreakpoint(line);

                        ListingLine listingLine = new ListingLine(line, breakable);
                        v.addElement(listingLine);

                        if (breakable) 
						{
                            lineTable.put(listingLine.getAddress(), new Integer(index));
                        }

                        ++index;
                    }
                }
            } 
			while ((line = listFile.readLine()) != null);

            return v;
        }
        catch (IOException ex) 
		{
            ex.printStackTrace();
            return null;
        }
        finally 
		{
            try 
			{
                if (listFile != null) 
				{
                    listFile.close();
                }
            }
            catch (IOException ignore) {}
        }
    }
	
	boolean canHaveBreakpoint(String line)
	{
		if((line.length() >= 91 && line.charAt(14) != '*') &&
                                    Character.isDigit(line.charAt(2)) &&
                                    Character.isDigit(line.charAt(3)) &&
                                    Character.isDigit(line.charAt(4)) &&
                                    Character.isDigit(line.charAt(87)) &&
                                    Character.isDigit(line.charAt(88)) &&
                                    Character.isDigit(line.charAt(89)) &&
                                    Character.isDigit(line.charAt(90)))	
		{
			String mnemonic = line.substring(21, 24).trim();
			return !(mnemonic.equals("DS") || mnemonic.equals("DSA") || mnemonic.equals("DC") || mnemonic.equals("DCW"));
		}
		
		return false;
	}

    private void flipBreakpoint(int index)
    {
        ListingLine line = (ListingLine) listing.getModel().getElementAt(index);
        if (line.isBreakable()) 
		{
            line.flipBreakpoint();

            synchronized(Simulator.class) 
			{
                if (line.isBreakpoint()) 
				{
                    Simulator.execute("br " + line.getAddress());
                }
                else 
				{
                    Simulator.execute("nobr " + line.getAddress());
                }
            }
        }
    }

    private void clearBreakpoints()
    {
        ListModel model = listing.getModel();
        int size = model.getSize();

        for (int idx = 0; idx < size; ++idx) 
		{
            ListingLine line = (ListingLine) model.getElementAt(idx);
            line.breakpoint = false;
        }

        listing.repaint();

		listing.removeAll(); // Cleanup the listing in Exec window (LS 8-12-2013)
    }

    private class ListingLine
    {
        private String text;
        private boolean breakable = true;
        private boolean breakpoint = false;
        private Integer address = null;

        ListingLine(String text, boolean breakable)
        {
            this.breakable = breakable;
            this.text = text;

            if (breakable) 
			{
                int i = (text.charAt(86) == ' ') ? 87 : 86;
                address = new Integer(text.substring(i, 91));
            }
        }

 		@Override
		public String toString()
		{
			return text;
		}

		String getText()
        {
            return text;
        }
		
        Integer getAddress()
        {
            return address;
        }

        boolean isBreakable()
        {
            return breakable;
        }

        boolean isBreakpoint()
        {
            return breakpoint;
        }

        void flipBreakpoint()
        {
            this.breakpoint = !this.breakpoint;
        }
    }

    private class ListingLineRenderer extends JLabel implements ListCellRenderer
    {
		private static final long serialVersionUID = 1L;
		
        ListingLineRenderer()
        {
            setOpaque(true);
        }

		@Override
        public Component getListCellRendererComponent(JList list, Object value, int index, boolean isSelected, boolean cellHasFocus)
        {
            ListingLine line = (ListingLine)value;

            setIcon(!line.isBreakable() || !simulatorRunning ? nobreakIcon : line.isBreakpoint() ? breakPointIcon : breakableIcon);

            setFont(listingFont);
            setText(line.getText());

            setForeground(line.isBreakpoint() ? Color.RED : Color.BLACK);
			
            setBackground(isSelected && !settingBreakpoint ? Color.LIGHT_GRAY : Color.WHITE);

            return this;
        }
    }

    private String processOutput()
    {
        String message = null;
        clearMessage();

        do 
		{
            message = Simulator.output();

            if ((message != null) && (message.length() > 0)) 
			{
                writeMessage(Color.BLUE, message);
            }

			// System.out.println(message);
        }
        while (Simulator.hasOutput());

        if (message != null) 
		{
            selectCurrentLine(message);
        }

        return message;
    }

    private void selectCurrentLine(String message)
    {
        int start = message.indexOf("IS: ");

        if (start != -1) 
		{
            start += 4;

            int end = message.indexOf(' ', start);
            Integer address = new Integer(message.substring(start, end));
            Integer lineNumber = (Integer) lineTable.get(address);

            if (lineNumber != null) 
			{
                listing.setSelectedIndex(lineNumber);
                listing.ensureIndexIsVisible(lineNumber);
            }

            currentMessage = message;
        }
    }

    private void restartAction()
    {
        if (simulatorRunning) 
		{
            killSimulator();
			
            dataButton.setEnabled(true);
       }
        else 
		{			
            if(startSimulator())
			{
				mainFrame.resetMemoryFrame();
			}
			else
			{
				String message = String.format("SimH failed!\nVerify the correctness of SimH path\n%s", 
																			SimulatorOptions.simulatorPath);
				System.out.println(message);
				JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
			}
		}
    }

    private boolean startSimulator()
    {
        synchronized (Simulator.class) 
		{
            if(!Simulator.start())
			{
				return false;
			}
			
            processOutput();
        }

        Thread monitor = new StandardErrorMonitor(Simulator.getStderr());
        monitor.start();

        programRunning = false;
        currentMessage = null;

        simulatorButton.setEnabled(true);
        startButton.setText("Start program");
        startButton.setEnabled(true);
        showMemoryButton.setEnabled(true);
        showConsoleButton.setEnabled(true);
        showTimerButton.setEnabled(true);

        clearBreakpoints();
		
        mainFrame.unlockCommandWindows();
        mainFrame.showPrintoutWindow(baseName);
 
        simulatorRunning = true;
        simulatorButton.setText("Kill simulator");
		
		return true;
    }

    private void killSimulator()
    {
        if (autoStepping) 
		{
            autoStepping = false;

            try {
                autoStepper.join(100);
            }
            catch(InterruptedException ignore) {}
        }

        Simulator.kill();

        startButton.setEnabled(false);
        quitButton.setEnabled(false);
        singleStepButton.setEnabled(false);
        autoStepButton.setEnabled(false);
        showMemoryButton.setEnabled(false);
        showConsoleButton.setEnabled(false);
		
		listing.clearSelection();

		clearBreakpoints();
		
        mainFrame.lockCommandWindows();
        mainFrame.disableSenseSwitches();

        simulatorRunning = false;
        programRunning = false;
        simulatorButton.setText("Restart simulator");
    }

    private void optionsAction()
    {
    }

    private void dataAction()
    {
        if (dialog == null) 
		{
            dialog = new DataDialog(mainFrame, "Runtime Data");

            Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
            Dimension dialogSize = dialog.getSize();
            dialog.setLocation((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2);
        }

        dialog.initialize();
        dialog.setVisible(true);
		
        killSimulator();
		
		mainFrame.resetMemoryFrame();
    }

    private void startAction()
    {
        if (programRunning) 
		{
            synchronized(Simulator.class) 
			{
                Simulator.execute("c");
                processOutput();
            }
        }
        else 
		{
            synchronized(Simulator.class) 
			{
                Simulator.execute("b cdr");
                processOutput();
            }

            startButton.setText("Continue program");
            dataButton.setEnabled(false);
            quitButton.setEnabled(true);
            singleStepButton.setEnabled(true);
            autoStepButton.setEnabled(true);

            programRunning = true;
        }

        mainFrame.updateCommandWindows();
        mainFrame.enableSenseSwitches();
    }

    private void quitAction()
    {
        synchronized(Simulator.class) 
		{
            Simulator.stop();
            processOutput();
        }

        startButton.setText("Start program");
        simulatorButton.setText("Restart simulator");

        optionsButton.setEnabled(false);
        dataButton.setEnabled(true);
        startButton.setEnabled(false);
        quitButton.setEnabled(false);
        singleStepButton.setEnabled(false);
        autoStepButton.setEnabled(false);
        showMemoryButton.setEnabled(false);
        showConsoleButton.setEnabled(false);

        clearBreakpoints();
        mainFrame.lockCommandWindows();
        mainFrame.disableSenseSwitches();

        simulatorRunning = false;
        programRunning = false;
    }

    private String singleStepAction()
    {
        String message;

        synchronized(Simulator.class) 
		{
            Simulator.execute("s");
            message = processOutput();
        }

        mainFrame.updateCommandWindows();
        mainFrame.enableSenseSwitches();

        return message;
    }

    private void autoStepAction()
    {
        if (autoStepping) 
		{
            autoStepping = false;
        }
        else 
		{
            autoStepper = new AutoStepper();

            startButton.setEnabled(false);
            quitButton.setEnabled(false);
            singleStepButton.setEnabled(false);
            autoStepButton.setText("Stop stepping");
            slowerButton.setEnabled(true);
            fasterButton.setEnabled(autoStepWaitTime > 0);

            autoStepping = true;
            autoStepper.start();
        }
    }

    private void slowerAction()
    {
        autoStepWaitTime += 50;
        fasterButton.setEnabled(true);
    }

    private void fasterAction()
    {
        if ((autoStepWaitTime -= 50) <= 0) 
		{
            autoStepWaitTime = 0;
        }

        fasterButton.setEnabled(autoStepWaitTime > 0);
    }

    private void showMemoryAction()
    {
        mainFrame.createMemoryFrame();
    }

    private void showConsoleAction()
    {
        mainFrame.createConsoleFrame();
    }

    private void showTimerAction()
    {
        mainFrame.createTimerFrame();
    }

    private class AutoStepper
        extends Thread
    {
		@Override
        public void run()
        {
            String message = null;

            do 
			{
                message = singleStepAction();

                try 
				{
                    Thread.sleep(autoStepWaitTime);
                }
                catch (InterruptedException ignore) {}

            }
            while (autoStepping && (message != null) && message.startsWith("Step"));

            autoStepping = false;
            startButton.setEnabled(true);
            quitButton.setEnabled(true);
            singleStepButton.setEnabled(true);
            autoStepButton.setText("Auto step");
            slowerButton.setEnabled(false);
            fasterButton.setEnabled(false);
        }
    }

    private class StandardErrorMonitor
        extends Thread
    {
        private BufferedReader stderr;

        StandardErrorMonitor(BufferedReader stderr)
        {
            this.stderr = stderr;
        }

		@Override
        public void run()
        {
            int ch;

            try {
                if (stderr != null) {
                    while ((ch = stderr.read()) != -1) {
                        System.out.print((char) ch);
                    }
                }
            }
            catch(IOException ex) 
			{
                ex.printStackTrace();
            }
        }
    }

	@Override
    public void actionPerformed(ActionEvent event)
    {
        Object button = event.getSource();

        if (button == simulatorButton) {
            restartAction();
        }
        else if (button == optionsButton) {
            optionsAction();
        }
        else if (button == dataButton) {
            dataAction();
        }
        else if (button == startButton) {
            startAction();
        }
        else if (button == quitButton) {
            quitAction();
        }
        else if (button == singleStepButton) {
            singleStepAction();
        }
        else if (button == autoStepButton) {
            autoStepAction();
        }
        else if (button == slowerButton) {
            slowerAction();
        }
        else if (button == fasterButton) {
            fasterAction();
        }
        else if (button == showMemoryButton) {
            showMemoryAction();
        }
        else if (button == showConsoleButton) {
            showConsoleAction();
        }
        else if (button == showTimerButton) {
            showTimerAction();
        }
    }

	@Override
    public void stateChanged(ChangeEvent event)
    {
        Object source = event.getSource();

        if (source == showAllCheckBox) 
		{
            clearBreakpoints();
			
            loadListing();
        }
    }
	
	@Override
	public void internalFrameActivated(InternalFrameEvent e)
	{
		super.internalFrameActivated(e);

		// checkListContent();
	}
	
	@Override
	public boolean canCopy()
	{
		return (listing.getModel().getSize() > 0);
	}
	
	public void checkListContent()
	{
		mainFrame.copyItem.setEnabled(canCopy());
	}	
	
	private class MyJList extends JList
	{
		private static final long serialVersionUID = 1L;
		
		MyJList()
		{
			super();
		}
		
		@Override
		public void setSelectionModel(ListSelectionModel selectionModel)
		{
			super.setSelectionModel(selectionModel);
		}
		
		@Override
		public void setSelectedValue(Object anObject, boolean shouldScroll)
		{
			super.setSelectedValue(anObject, shouldScroll);
		}
		
		@Override
		public void setSelectedIndex(int index)
		{
			super.setSelectedIndex(index);
		}
			
		@Override
		public void clearSelection()
		{
			super.clearSelection();
		}
			
		@Override
		public void setSelectionInterval(int anchor, int lead)
		{			
			// super.setSelectionInterval(anchor, lead);
		}
	}
	
	public void copyMenuAction(ActionEvent event)
	{
		if(listing != null)
		{
			String text = "";
			String separator = System.getProperty("line.separator");
			
			ListModel model = listing.getModel();
			for (int idx = 0; idx < model.getSize(); idx++) 
			{
				text = text.concat(model.getElementAt(idx).toString() + separator);
			}
				
			if(text.length() > 0)
			{
				StringSelection selection = new StringSelection(text);
				Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
				clipboard.setContents(selection, null);			
			}
		}
	}
}

