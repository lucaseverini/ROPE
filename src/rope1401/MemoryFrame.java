/**
 * <p>Title: MemoryFrame.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.awt.*;
import java.awt.event.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.text.DefaultCaret;

public class MemoryFrame extends ChildFrame implements ActionListener, ChangeListener, CommandWindow
{
 	private static final long serialVersionUID = 1L;

	BorderLayout borderLayout1 = new BorderLayout();
    GridBagLayout gridBagLayout1 = new GridBagLayout();
    JPanel controlPanel = new JPanel();
    JScrollPane scrollPane = new JScrollPane();
    JTextArea memoryArea = new JTextArea();
    JLabel fromLabel = new JLabel();
    JTextField fromText = new JTextField();
    JLabel toLabel = new JLabel();
    JTextField toText = new JTextField();
    JButton showButton = new JButton();
    JCheckBox autoCheckBox = new JCheckBox();
    JCheckBox barsCheckBox = new JCheckBox();
	Font font = new Font("Monospaced", Font.PLAIN, 14);
	boolean stripesInitialized = false;
	int stripe1X, stripe2X, stripe3X;
	int stripeWidth;

    private Color barColor = new Color(15, 15, 15);

    public MemoryFrame(RopeFrame parent)
    {
		super(parent);
		
		// TODO: Implement a smarter way to set the initial frame position and size
		setLocation(932, 300);
		setSize(RopeHelper.isWindows ? 496 : 508, 610);	
		setMaximumSize(new Dimension((int)getSize().getWidth(), parent.getHeight()));
		
        try 
		{
            jbInit();
        }
        catch (Exception ex) 
		{
            ex.printStackTrace();
        }

	    this.addInternalFrameListener(new InternalFrameAdapter()
        {
			@Override
            public void internalFrameClosed(InternalFrameEvent event)
            {		
				savePreferences();
				
				mainFrame.removeMemoryFrame();
            }
        });

		this.addComponentListener(new ComponentAdapter() 
		{
			@Override
			public void componentHidden(ComponentEvent e) 
			{
				// System.out.println("Hidden");
			}
			
			@Override
			public void componentShown(ComponentEvent e) 
			{
				// System.out.println("Shown");
			}
		});
		
        showButton.addActionListener(this);
        barsCheckBox.addChangeListener(this);
		
		DefaultCaret caret = (DefaultCaret)memoryArea.getCaret();
		caret.setUpdatePolicy(DefaultCaret.NEVER_UPDATE);
		
		showMemory();
	}

    void jbInit() throws Exception
    {
        this.setClosable(true);
        this.setIconifiable(true);
        this.setResizable(true);
        this.setTitle("MEMORY");
		
        this.getContentPane().setLayout(borderLayout1);
        this.getContentPane().add(controlPanel, BorderLayout.NORTH);
        this.getContentPane().add(scrollPane, BorderLayout.CENTER);
		
 		memoryArea = new JTextArea() 
		{
			private static final long serialVersionUID = 1L;

			@Override
            public void paint(Graphics g)
            {
                super.paint(g);

                if (barsCheckBox.isSelected()) 
				{
                    Dimension size = this.getSize();
					g.setFont(font);
					
					if(!stripesInitialized)
					{
						stripesInitialized = true;
						
						FontMetrics fm = g.getFontMetrics();				
						int charWidth = (int)Math.ceil(fm.getStringBounds("0", g).getWidth());
 					
						stripeWidth = 10 * charWidth;
						// Small adjustement to make things looks nicer on ugly Windows...
						stripe1X = (8 * charWidth) + (RopeHelper.isWindows ? 1 : 0);
					    stripe2X = stripe1X + (stripeWidth * 2);
						stripe3X = stripe1X + (stripeWidth * 4);					
					}
					
                    g.setColor(barColor);
                    g.setXORMode(Color.BLACK);
                    g.fillRect(stripe1X, 0, stripeWidth, size.height);
                    g.fillRect(stripe2X, 0, stripeWidth, size.height);
                    g.fillRect(stripe3X, 0, stripeWidth, size.height);
                    g.setPaintMode();
                }
            }
        };
		
 		memoryArea.setFont(font);
        memoryArea.setDoubleBuffered(true);
        memoryArea.setEditable(false);		
        scrollPane.getViewport().add(memoryArea, null);
		
        controlPanel.setLayout(gridBagLayout1);
        controlPanel.setBorder(BorderFactory.createLoweredBevelBorder());
        fromLabel.setText("From");
        fromText.setMinimumSize(new Dimension(56, 20));
        fromText.setPreferredSize(new Dimension(56, 20));
        fromText.setText("0");
        toLabel.setText("to");
        toText.setMinimumSize(new Dimension(56, 20));
        toText.setPreferredSize(new Dimension(56, 20));
        toText.setText("1512");
        showButton.setText("Update");
        autoCheckBox.setText("Auto update");
        barsCheckBox.setText("Bars");
		
        autoCheckBox.setSelected(true);		
        barsCheckBox.setSelected(true);
		
        controlPanel.add(fromLabel,
                         new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.EAST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(fromText,
                         new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(toLabel,
                         new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.EAST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(toText,
                         new GridBagConstraints(3, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(showButton,
                         new GridBagConstraints(4, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 5, 0), 0, 0));
        controlPanel.add(barsCheckBox,
                          new GridBagConstraints(7, 0, 1, 1, 1.0, 0.0,
												GridBagConstraints.EAST, 
												GridBagConstraints.NONE, 
												new Insets(5, 15, 5, 5), 0, 0));
        controlPanel.add(autoCheckBox,
                         new GridBagConstraints(5, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 10, 5, 0), 0, 0));
    }

	@Override
    public void execute()
    {
        if (autoCheckBox.isSelected()) 
		{
            showMemory();
        }
        else 
		{
            memoryArea.setEnabled(false);
        }
    }

	@Override
    public void lock()
    {
        showButton.setEnabled(false);
    }

	@Override
    public void unlock()
    {
        showButton.setEnabled(true);
    }

	@Override
    public void stateChanged(ChangeEvent event)
    {
        if (event.getSource() == barsCheckBox) 
		{
            memoryArea.repaint();
        }
    }

	@Override
    public void actionPerformed(ActionEvent event)
    {
        Object button = event.getSource();

        if (button == showButton) 
		{
            showMemory();
        }
    }
	
	public void showMemory()
    {
        int from, to;

        try {
            String toString = toText.getText().trim();

            from = Integer.parseInt(fromText.getText().trim());
            to = (toString.length() == 0) ? from : Integer.parseInt(toString);

            if ((from < 0) || (from > 15999) || (to < 0) || (to > 15999) || (from > to)) 
			{
                throw new Exception("Invalid memory bounds.");
            }
        }
        catch (Exception ex) 
		{
            memoryArea.setText("\n\n***** ERROR: " + ex.getMessage());
            return;
        }

        setTitle("MEMORY: " + from + " - " + to);

        int offset = to - from;
        int last = offset - (offset % 50) + from;
        StringBuilder buffer = new StringBuilder(1024);

		if(Simulator.isActive())
		{
			synchronized(Simulator.class) 
			{
				Simulator.output();		// Clean previous output
				
				Simulator.execute("e -d " + from + "-" + to);
				
				Boolean nothingYet = true;
				while(true) 
				{
					String text = Simulator.output();

					if(!nothingYet && text.length() == 0)
					{
						break;
					}
					else if(nothingYet && text.length() > 0)
					{
						nothingYet = false;
					}
					
					if (TextIsValidForMemoryDump(text)) 
					{
						int idx = text.indexOf(":");
						if(idx > 0 && idx <= 6)
						{
							StringBuilder strBuild = new StringBuilder(text);
							strBuild.setCharAt(idx, ':');
							text = strBuild.toString();
						}
						
						buffer.append(text).append('\n');
					}
				}

				do 
				{
					String text = Simulator.output();

					if ((text != null) && (text.length() > 0)) 
					{
						buffer.append(text).append('\n');
					}
				}
				while (Simulator.hasOutput());
			}
		}

        memoryArea.setText(buffer.toString());
        memoryArea.setEnabled(true);
    }
 
	void savePreferences()
	{
		try
		{
			Preferences userPrefs = Preferences.userRoot();

			userPrefs.put("memoryFrameLocation", this.getLocation().toString());
			userPrefs.put("memoryFrameSize", this.getSize().toString());

			userPrefs.sync();
			userPrefs.flush();
		}
		catch(BackingStoreException ex) 
		{
			Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
		}
	}
	
	boolean TextIsValidForMemoryDump (String text)
	{
		if(text == null || text.length() < 7)
		{
			return false;
		}
		
		for(int idx = 0; idx < 7; idx++)
		{
			char ch = text.charAt(idx);
			if(!Character.isDigit(ch) && !Character.isWhitespace(ch))
			{
				if(ch == ':')
				{
					break;
				}
				else
				{
					return false;
				}
			}
		}
		
		return true;
	}
}


