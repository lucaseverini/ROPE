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
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;
import javax.swing.*;
import javax.swing.event.*;

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

    private Color barColor = new Color(15, 15, 15);

    public MemoryFrame(RopeFrame parent)
    {
		super(parent);
		
		setSize(450, 500);
		
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
				System.out.println("Hidden");
			}
			
			@Override
			public void componentShown(ComponentEvent e) 
			{
				System.out.println("Shown");
			}
		});
		
        showButton.addActionListener(this);
        barsCheckBox.addChangeListener(this);
		
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
                    FontMetrics fm = g.getFontMetrics();
                    int charWidth = fm.charWidth('w');
                    int w = 10*charWidth;
                    int x1 = 8*charWidth;
                    int x2 = x1 + 2*w;
                    int x3 = x1 + 4*w;

                    g.setColor(barColor);
                    g.setXORMode(Color.BLACK);
                    g.fillRect(x1, 0, w, size.height);
                    g.fillRect(x2, 0, w, size.height);
                    g.fillRect(x3, 0, w, size.height);
                    g.setPaintMode();
                }
            }
        };
        memoryArea.setFont(new java.awt.Font("Courier", 0, 12));
        memoryArea.setDoubleBuffered(true);
        memoryArea.setEditable(false);		
        scrollPane.getViewport().add(memoryArea, null);
		
        controlPanel.setLayout(gridBagLayout1);
        controlPanel.setBorder(BorderFactory.createLoweredBevelBorder());
        fromLabel.setText("From");
        fromText.setMinimumSize(new Dimension(45, 20));
        fromText.setPreferredSize(new Dimension(45, 20));
        fromText.setText("0");
        toLabel.setText("to");
        toText.setMinimumSize(new Dimension(45, 20));
        toText.setPreferredSize(new Dimension(45, 20));
        toText.setText("512");
        showButton.setText("Show");
        autoCheckBox.setSelected(true);
        autoCheckBox.setText("Auto update");
        barsCheckBox.setText("Bars");
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
                                                new Insets(5, 10, 5, 0), 0, 0));
        controlPanel.add(barsCheckBox,
                          new GridBagConstraints(7, 0, 1, 1, 1.0, 0.0
            ,GridBagConstraints.EAST, GridBagConstraints.NONE, new Insets(5, 0, 5, 5), 0, 0));
        controlPanel.add(autoCheckBox,
                         new GridBagConstraints(5, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
    }

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

    public void lock()
    {
        showButton.setEnabled(false);
    }

    public void unlock()
    {
        showButton.setEnabled(true);
    }

    public void stateChanged(ChangeEvent event)
    {
        if (event.getSource() == barsCheckBox) 
		{
            memoryArea.repaint();
        }
    }

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
        int from = 0;
        int to = 0;

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
        int last = offset - offset%50 + from;
        StringBuffer buffer = new StringBuffer(1024);

		if(Simulator.isActive())
		{
			synchronized(Simulator.class) 
			{
				Simulator.execute("e -d " + from + "-" + to);
				for (; ; ) {
					String text = Simulator.output();

					if ((text != null) && (text.length() > 0)) {
						buffer.append(text).append('\n');
					}

					int i = text.indexOf(":");
					if ((i != -1) && (i <= 5)) {
						try {
							int address = Integer.parseInt(text.substring(0, i));
							if (address == last) {
								break;
							}
						}
						catch (Exception ex) {
							ex.printStackTrace();
						}
					}
				}

				do {
					String text = Simulator.output();

					if ((text != null) && (text.length() > 0)) {
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

}
