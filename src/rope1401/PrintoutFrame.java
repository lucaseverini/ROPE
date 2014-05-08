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
import java.awt.print.PageFormat;
import java.awt.print.Printable;
import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;
import java.io.*;
import static java.lang.Math.abs;
import java.util.Vector;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.text.BadLocationException;

public class PrintoutFrame extends ChildFrame implements Printable, ActionListener, ChangeListener, CaretListener, CommandWindow
{
	private static final long serialVersionUID = 1L;
	
    BorderLayout borderLayout1 = new BorderLayout();
    GridBagLayout gridBagLayout1 = new GridBagLayout();
    JPanel controlPanel = new JPanel();
    JButton updateButton = new JButton();
    JButton saveAsButton = new JButton();
    JButton printButton = new JButton();
    JCheckBox autoUpdateCheckBox = new JCheckBox();
    JCheckBox stripesCheckBox = new JCheckBox();
    JCheckBox barsCheckBox = new JCheckBox();
    JScrollPane scrollPane = new JScrollPane();
    JTextArea printoutArea = new JTextArea();

    private BufferedReader printout;
    private Color barColor = new Color(100, 0, 100);
    private Color stripeColor = new Color(25, 0, 25);
	private Font printFont;
	private FontMetrics printMetrics;
	private String baseName = "";
	private String selectedPath;

    public PrintoutFrame(RopeFrame parent)
    {
		super(parent);
		
		// Implement a smarter way to set the initial frame position and size
        setLocation(0, 690);
        setSize(930, 395);
   
		try 
		{
            jbInit();
        }
        catch (Exception ex) 
		{
            ex.printStackTrace();
        }

		printoutArea.addCaretListener(this);
	    updateButton.addActionListener(this);
		saveAsButton.addActionListener(this);
	    printButton.addActionListener(this);
        stripesCheckBox.addChangeListener(this);
        barsCheckBox.addChangeListener(this);
        autoUpdateCheckBox.addChangeListener(this);

		// Remove automatic key bindings because we want them controlled by menu items
		InputMap im = printoutArea.getInputMap(JComponent.WHEN_FOCUSED);
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks + InputEvent.SHIFT_MASK), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_X, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_C, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_V, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_A, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_L, RopeHelper.modifierMaks), "none");
	}

	@Override
    protected void finalize() throws Throwable
    {
		try 
		{
			if (printout != null) 
			{
				try
				{
					printout.close();
				}
				catch(IOException ignore) {}
			}
		}
		finally 
		{
			super.finalize();
		}
    }

    void jbInit() throws Exception
    {
        this.setIconifiable(true);
        this.setMaximizable(true);
        this.setResizable(true);
        this.setTitle("PRINTOUT");
        this.getContentPane().setLayout(borderLayout1);
        this.getContentPane().add(controlPanel, BorderLayout.NORTH);
        this.getContentPane().add(scrollPane, BorderLayout.CENTER);
				
		printoutArea = new JTextArea() 
		{
			private static final long serialVersionUID = 1L;
			
			@Override
            public void paint(Graphics g)
            {
                super.paint(g);

                boolean doBars = barsCheckBox.isSelected();
                boolean doStripes = stripesCheckBox.isSelected();

                if (doBars || doStripes) 
				{
                    Dimension size = this.getSize();
                    FontMetrics fm = g.getFontMetrics();
                    int charWidth = fm.charWidth('w');
                    int lineHeight = fm.getHeight();
                    int barWidth = 10*charWidth;
                    int barHeight = 3*lineHeight;
                    int skipHeight = 2*barHeight;

                    g.setXORMode(Color.BLACK);

                    if (doBars) 
					{
                        g.setColor(barColor);
						
                        for (int x = barWidth; x < size.width; x += barWidth) 
						{
                            g.drawLine(x, 0, x, size.height);
                        }
                    }

                    if (doStripes) 
					{
                        g.setColor(stripeColor);
						
                        for (int y = barHeight; y < size.height; y += skipHeight) 
						{
                            g.fillRect(0, y, size.width, barHeight);
                        }
                    }

                    g.setPaintMode();
                }
            }
        };
		
        printoutArea.setFont(new java.awt.Font("Monospaced", Font.PLAIN, 12));
        printoutArea.setDoubleBuffered(true);
        printoutArea.setEditable(false);
        scrollPane.getViewport().add(printoutArea, null);
		
        controlPanel.setLayout(gridBagLayout1);
        updateButton.setText("Update");
        saveAsButton.setText("Save As...");
        printButton.setText("Print");
        autoUpdateCheckBox.setText("Auto update");
        stripesCheckBox.setText("Stripes");
        barsCheckBox.setText("Bars");
 
		Preferences userPrefs = Preferences.userRoot();
		autoUpdateCheckBox.setSelected(userPrefs.getBoolean("printAutoUpdate", true));
		stripesCheckBox.setSelected(userPrefs.getBoolean("printStripes", true));
		barsCheckBox.setSelected(userPrefs.getBoolean("printBars", false));

		controlPanel.add(updateButton,
                         new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(autoUpdateCheckBox,
                         new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(saveAsButton,
                         new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 20, 5, 0), 0, 0));
        controlPanel.add(printButton,
                         new GridBagConstraints(3, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 20, 5, 0), 0, 0));
        controlPanel.add(stripesCheckBox,
                         new GridBagConstraints(5, 0, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.EAST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 0, 5, 0), 0, 0));
        controlPanel.add(barsCheckBox,
                         new GridBagConstraints(6, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(0, 5, 0, 5), 0, 0));
    }

    void initialize()
    {
        try 
		{
            if (printout != null) 
			{
                printout.close();
            }

            printout = new BufferedReader(new FileReader(DataOptions.outputPath));
            printoutArea.setText(null);
        }
        catch(IOException ex) 
		{
            printout = null;
            ex.printStackTrace();
        }
    }
	
	@Override
	public void setTitle(String name)
	{
		baseName = name;
		super.setTitle("PRINTOUT: " + baseName);
	}

	@Override
    public void execute()
    {
        if (autoUpdateCheckBox.isSelected()) 
		{
            update();
        }
        else 
		{
            printoutArea.setEnabled(false);
        }
    }

	@Override
    public void lock()
    {
        updateButton.setEnabled(false);
    }

	@Override
    public void unlock()
    {
        updateButton.setEnabled(true);
    }

	@Override
    public void stateChanged(ChangeEvent event)
    {
        Object source = event.getSource();

        if (source == stripesCheckBox || source == barsCheckBox)
		{
            printoutArea.repaint();
 
			try 
			{
				Preferences userPrefs = Preferences.userRoot();
				userPrefs.putBoolean("printStripes", stripesCheckBox.isSelected());
				userPrefs.putBoolean("printBars", barsCheckBox.isSelected());
				userPrefs.sync();
			}
			catch(BackingStoreException ex) {}
		}
		else if(source == autoUpdateCheckBox)
		{
			if (autoUpdateCheckBox.isSelected()) 
			{
				update();
			}
			
			try 
			{
				Preferences userPrefs = Preferences.userRoot();
				userPrefs.putBoolean("printAutoUpdate", autoUpdateCheckBox.isSelected());
				userPrefs.sync();
			}
			catch(BackingStoreException ex) {}
		}
	}

	@Override
    public void actionPerformed(ActionEvent event)
    {
		Object button = event.getSource();
		
		if(button == updateButton)
		{
			update();	
			
			printoutArea.repaint();
		}
		else if(button == saveAsButton)
		{
			saveAs();
		}
		else if(button == printButton)
		{
			print();
		}
    }

    private void update()
    {
        if (printout != null) 
		{
            String line;

            try 
			{
                while ((line = printout.readLine()) != null) 
				{
                    printoutArea.append(line + "\n");
                }
            }
            catch (IOException ex)
			{
                ex.printStackTrace();
            }

            printoutArea.setEnabled(true);
            printoutArea.setCaretPosition(printoutArea.getText().length());
        }
    }
	
	private void saveAs()
    {
		Vector<RopeFileFilter> filters = new Vector<RopeFileFilter>();
		filters.add(new RopeFileFilter(new String[] {".out"}, "Output files (*.out)"));
		filters.add(new RopeFileFilter(new String[] {".txt"}, "Text files (*.txt)"));

		RopeFileChooser chooser = new RopeFileChooser(selectedPath, null, filters);
		chooser.setDialogTitle("Save Printout File");
		String fileName = String.format("%s.out", baseName);
		chooser.setSelectedFile(new File(selectedPath, fileName));
		JTextField field = chooser.getTextField();
		field.setSelectionStart(0);
		field.setSelectionEnd(baseName.length());
		File file = chooser.save(Rope.mainFrame);
		if(file != null)
		{
			selectedPath = file.getParent();
			
			BufferedWriter writer = null;
			try
			{
				writer = new BufferedWriter(new FileWriter(file));
				writer.write(printoutArea.getText());
			}
			catch (IOException ex)
			{
				ex.printStackTrace();
			}
			finally
			{
				try
				{
					if( writer != null)
					{
						writer.close();
					}
				}
				catch (IOException ex)
				{
					ex.printStackTrace();
				}
			}		
		}
	}
	
	private void print()
    {
		PrinterJob printJob = PrinterJob.getPrinterJob();		
		PageFormat printFormat = printJob.defaultPage();
		
		Preferences userPrefs = Preferences.userRoot();
		printFormat.setOrientation(userPrefs.getInt("printFormatOrientation", printFormat.getOrientation()));
		double width = userPrefs.getDouble("printFormatWidth", printFormat.getWidth());
		double height = userPrefs.getDouble("printFormatHeight", printFormat.getHeight());
		double imgX = userPrefs.getDouble("printFormatImageableX", printFormat.getImageableX());
		double imgY = userPrefs.getDouble("printFormatImageableY", printFormat.getImageableY());
		double imgWidth = userPrefs.getDouble("printFormatImageableWidth", printFormat.getImageableWidth());
		double imgHeight = userPrefs.getDouble("printFormatImageableHeight", printFormat.getImageableHeight());
		printFormat.getPaper().setSize(width, height);
		printFormat.getPaper().setImageableArea(imgX, imgY, imgWidth, imgHeight);
			
		printFormat = printJob.validatePage(printFormat);
		
		if (printJob.printDialog()) 
		{
			try
			{
				printJob.setPrintable(this, printFormat);			
				printJob.print();
			}
			catch (PrinterException ex)
			{
				ex.printStackTrace();
			}
		}
	}
	   
	@Override
    public void caretUpdate(CaretEvent event)
    {
  		doCaretUpdate(event.getDot(), event.getMark());
    }

	void doCaretUpdate(int dot, int mark)
	{	
        if (dot == mark) 
		{
            mainFrame.copyItem.setEnabled(false);
 		}   
		else
		{
            mainFrame.copyItem.setEnabled(true);
        }
		
		int length = printoutArea.getText().length();
		if(length == 0 || abs(mark - dot) == length)
		{
			mainFrame.selectAllItem.setEnabled(false);
		}
		else
		{
			mainFrame.selectAllItem.setEnabled(true);
		}
	}

	@Override
	public boolean canCopy()
	{
		return (printoutArea.getText().length() > 0);
	}
	
	@Override
	public boolean canSaveAs()
	{
		return true;
	}

	@Override
	public boolean canPrint()
	{
		return true;
	}

	public void copyMenuAction(ActionEvent event)
	{
		if(printoutArea != null)
		{
			printoutArea.copy();
		}
	}

	public void selectAllMenuAction(ActionEvent event)
	{
		if(printoutArea != null)
		{
			printoutArea.selectAll();
		}
	}

	public void saveAsMenuAction(ActionEvent event)
	{
		if(printoutArea != null)
		{
			saveAs();
		}
	}

	public void printMenuAction(ActionEvent event)
	{
		if(printoutArea != null)
		{
			print();
		}
	}

	@Override
	public int print(Graphics graphics, PageFormat pageFormat, int pageIndex) throws PrinterException
	{
		if(printFont == null)
		{
			printFont = new Font(Font.MONOSPACED, Font.PLAIN, 10);
			graphics.setFont(printFont);
			printMetrics = graphics.getFontMetrics(printFont);
		}

		graphics.setFont(printFont);

		int lineHeight = printMetrics.getHeight();
		double pageHeight = pageFormat.getImageableHeight();
		int linesPerPage = (int)(pageHeight / lineHeight);	
		int totLines = printoutArea.getLineCount();
		
		int firstLineIdx = pageIndex > 0 ? linesPerPage * pageIndex : 0;
		if(firstLineIdx >= totLines)
		{
			return NO_SUCH_PAGE;
		}
				
		int pageTop = (int)pageFormat.getImageableY();
		int pageLeft = (int)pageFormat.getImageableX();
		
		int LastLineIdx = firstLineIdx + linesPerPage > totLines ? totLines - 1 : (firstLineIdx + linesPerPage) - 1;
		
		int yPos = pageTop;
		for (int lineIdx = firstLineIdx; lineIdx <= LastLineIdx; lineIdx++) 
		{
			try 
			{
				int lineStart = printoutArea.getLineStartOffset(lineIdx);
				int lineLen = printoutArea.getLineEndOffset(lineIdx) - lineStart;
				
				String text = printoutArea.getText(lineStart, lineLen);
				
				//TextMeasurer t =
					
				yPos += lineHeight;
				int xPos = pageLeft;
				for(char ch : text.toCharArray())
				{
					String chStr = String.valueOf(ch);
					graphics.drawString(chStr, xPos + 1, yPos);
					xPos += printMetrics.stringWidth(chStr) + 2;
				}
			}
			catch(BadLocationException ex) 
			{
				ex.printStackTrace();
			}
        }
		
		return PAGE_EXISTS;
	}
}
