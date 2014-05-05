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
import java.awt.print.Book;
import java.awt.print.PageFormat;
import java.awt.print.Paper;
import java.awt.print.Printable;
import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;
import java.io.*;
import static java.lang.Math.abs;
import java.util.logging.Level;
import java.util.logging.Logger;
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
    JButton printButton = new JButton();
    JCheckBox autoCheckBox = new JCheckBox();
    JCheckBox stripesCheckBox = new JCheckBox();
    JCheckBox barsCheckBox = new JCheckBox();
    JScrollPane scrollPane = new JScrollPane();
    JTextArea printoutArea = new JTextArea();

    private BufferedReader printout;
    private Color barColor = new Color(100, 0, 100);
    private Color stripeColor = new Color(25, 0, 25);
	private Font printFont;
	private FontMetrics printMetrics;

    public PrintoutFrame(RopeFrame parent)
    {
		super(parent);
		
		// Implement a smarter way to set the initial frame position and size
        setLocation(0, 690);
        setSize(940, 395);
   
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
	    printButton.addActionListener(this);
        stripesCheckBox.addChangeListener(this);
        barsCheckBox.addChangeListener(this);

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
        printButton.setText("Print");
        autoCheckBox.setText("Auto update");
        autoCheckBox.setSelected(true);
        stripesCheckBox.setText("Stripes");
        stripesCheckBox.setSelected(true);
        barsCheckBox.setText("Bars");
        barsCheckBox.setSelected(false);
 
		controlPanel.add(updateButton,
                         new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(autoCheckBox,
                         new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(printButton,
                         new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 5, 0), 0, 0));
        controlPanel.add(stripesCheckBox,
                         new GridBagConstraints(4, 0, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.EAST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 0, 5, 0), 0, 0));
        controlPanel.add(barsCheckBox,
                         new GridBagConstraints(5, 0, 1, 1, 0.0, 0.0,
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
    public void execute()
    {
        if (autoCheckBox.isSelected()) 
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

        if ((source == stripesCheckBox) || (source == barsCheckBox)) 
		{
            printoutArea.repaint();
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
				
				yPos += lineHeight;
				graphics.drawString(printoutArea.getText(lineStart, lineLen), pageLeft, yPos);
			}
			catch(BadLocationException ex) 
			{
				ex.printStackTrace();
			}
        }
		
		return PAGE_EXISTS;
	}
}
