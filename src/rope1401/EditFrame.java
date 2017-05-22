/**
 * <p>Title: EditFrame.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.Toolkit;
import java.awt.event.*;
import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.prefs.Preferences;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.event.*;
import javax.swing.filechooser.FileFilter;
import javax.swing.text.BadLocationException;
import javax.swing.text.Caret;
import javax.swing.text.DefaultEditorKit;
import javax.swing.text.Document;
import javax.swing.undo.CannotUndoException;

public class EditFrame extends ChildFrame implements ActionListener, CaretListener
{
	private static final long serialVersionUID = 1L;
	
    TitledBorder titledBorder1;
    BorderLayout borderLayout1 = new BorderLayout();
    GridBagLayout gridBagLayout1 = new GridBagLayout();
    GridBagLayout gridBagLayout2 = new GridBagLayout();
    JSplitPane splitPane = new JSplitPane();
    JScrollPane textScrollPane = new JScrollPane();
    JTextArea sourceArea = new JTextArea();
    JPanel controlPanel = new JPanel();
    JLabel fileLabel = new JLabel();
    JTextField fileText = new JTextField();
    JButton browseButton = new JButton();
    JButton optionsButton = new JButton();
    JButton assembleButton = new JButton();
    JButton saveButton = new JButton();
	JButton saveMessagesButton = new JButton();
    JPanel positionPanel = new JPanel();
    JLabel lineLabel = new JLabel();
    JTextField lineText = new JTextField();
    JLabel columnLabel = new JLabel();
    JTextField columnText = new JTextField();
    JScrollPane messageScrollPane = new JScrollPane();
    JList messageList = new JList();
	Preferences userPrefs = Preferences.userRoot();

	public CompoundUndoManager undoMgr;
    private AssemblerDialog dialog = null;
    private String baseName;
	private String fileExt;
	private boolean assembleFailed;
    private boolean haveAssemblyErrors;
    private ArrayList messages;
	private boolean sourceChanged;
	public String sourcePath;
	public String sourceName;
	private Document document;
	private Action undoAction;
	private Action redoAction;
	private String selectedPath;

	public class BoolRef 
	{ 
		BoolRef(boolean initval)
		{
			value = initval;
		}
		
		public boolean value; 
	}
	
    EditFrame(RopeFrame parent)
    {
		super(parent);
		
		// TODO: Implement a smarter way to set the initial frame position and size
        setLocation(0, 0);
        setSize(670, 668);
		
        try 
		{
            jbInit();
        }
        catch (Exception ex) 
		{
            ex.printStackTrace();
        }
		
        sourceArea.addCaretListener(this);
        browseButton.addActionListener(this);
        optionsButton.addActionListener(this);
        assembleButton.addActionListener(this);
        saveButton.addActionListener(this);
        saveMessagesButton.addActionListener(this);

        messageList.addMouseListener(new MouseAdapter()
        {
			@Override
            public void mouseClicked(MouseEvent event)
            {
                highlightError(messageList.locationToIndex(event.getPoint()));
            }
        });
 		
		undoMgr = new CompoundUndoManager(sourceArea);
		
		undoAction = undoMgr.getUndoAction();
		redoAction = undoMgr.getRedoAction();
		
		undoMgr.updateUndoAction = new UpdateUndoAction();
		undoMgr.updateRedoAction = new UpdateRedoAction();
	
		document = sourceArea.getDocument();

		ActionMap am = sourceArea.getActionMap();
		InputMap im = sourceArea.getInputMap(JComponent.WHEN_FOCUSED);
		
		// Remove automatic key bindings because we want them controlled by menu items
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks + InputEvent.SHIFT_MASK), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_X, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_C, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_V, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_A, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_L, RopeHelper.modifierMaks), "none");

		// Set custom binding action for tab key
		String action = "tabKeyAction";
		im.put(KeyStroke.getKeyStroke("TAB"), action);
		am.put(action, new AbstractAction() 
		{
			private static final long serialVersionUID = 1L;
			
			@Override
			public void actionPerformed(ActionEvent e) 
			{
 				try 
				{
					int caretPos = sourceArea.getCaretPosition();
					int lineNum = sourceArea.getLineOfOffset(caretPos);
					int startLine = sourceArea.getLineStartOffset(lineNum);
					int endLine = sourceArea.getLineEndOffset(lineNum);
					int linePos = caretPos - startLine;
							
					if(linePos >= 39 && linePos < 79)
					{
						caretPos = startLine + linePos + 10 - ((linePos + 1) % 10);
					}					
					else if(linePos >= 20 && linePos <= 39)
					{
						caretPos = startLine + 39;
					}
					else if(linePos >= 15 && linePos <= 19)
					{
						caretPos = startLine + 20;
					}
					else if(linePos >= 5 && linePos <= 14)
					{
						caretPos = startLine + 15;
					}
					else
					{
						caretPos = startLine + 5;
					}
					
					// If the line is shorter than the new position fo the caret add enough spaces...
					if(caretPos > endLine)
					{
						StringBuilder str = new StringBuilder();
						int size = caretPos - endLine;
						while(size-- >= 0) 
						{
							str.append(' ');
						}
						document.insertString(endLine - 1, str.toString(), null);
					}
					
					sourceArea.setCaretPosition(caretPos);
				}
				catch(BadLocationException ex) 
				{
					ex.printStackTrace();
				}
			}
		});
		
		// Set custom binding action for return/enter key
		String actionKey = "backspaceKeyAction";
		im.put(KeyStroke.getKeyStroke("BACK_SPACE"), actionKey);
		am.put(actionKey, new AbstractAction() 
		// How can I get the original action?
		{
			private static final long serialVersionUID = 1L;
			
			@Override
			public void actionPerformed(ActionEvent e) 
			{
 				try 
				{
					int caretPos = sourceArea.getCaretPosition();
					int lineNum = sourceArea.getLineOfOffset(caretPos);
					int startLine = sourceArea.getLineStartOffset(lineNum);
					int endLine = sourceArea.getLineEndOffset(lineNum);
					int linePos = caretPos - startLine;
					
					if(linePos == 15)
					{
						int endPos = 5;						
						int charPos = linePos;
						for(; charPos > endPos; charPos--)
						{
							char ch = sourceArea.getText().charAt((startLine + charPos) - 1);
							if(!Character.isWhitespace(ch))
							{
								break;
							}
						}
						
						sourceArea.setCaretPosition(startLine + charPos);
					}
					else
					{
						int startSel = sourceArea.getSelectionStart();
						int endSel = sourceArea.getSelectionEnd();
						if(startSel == endSel)
						{
							startSel = caretPos - 1;
							endSel = caretPos;
						}
						
						StringBuilder sb = new StringBuilder(sourceArea.getText());
						sb.replace(startSel, endSel, "");
						sourceArea.setText(sb.toString());
						sourceArea.setCaretPosition(startSel);
					}
				}
				catch(BadLocationException ex) 
				{
					ex.printStackTrace();
				}
			}
		});
		
		// Set custom binding action for return/enter key
		action = "enterKeyAction";
		im.put(KeyStroke.getKeyStroke("ENTER"), action);
		am.put(action, new AbstractAction() 
		{
			private static final long serialVersionUID = 1L;
			
			@Override
			public void actionPerformed(ActionEvent e) 
			{		
				try 
				{
					int caretPos = sourceArea.getCaretPosition();
					int lineNum = sourceArea.getLineOfOffset(caretPos);
					int startLine = sourceArea.getLineStartOffset(lineNum);
					int linePos = caretPos - startLine;
					
					if(linePos >= 5)
					{
						document.insertString(caretPos, "\n     ", null);
					}
					else
					{
						document.insertString(caretPos, "\n", null);
					}
				}
				catch(BadLocationException ex) 
				{
					ex.printStackTrace();
				}
			}
		});
	
		document.addDocumentListener(new DocumentListener()
		{
			@Override
			public void insertUpdate(DocumentEvent e)
			{
				setSourceChanged(true);
			}
			
			@Override
			public void removeUpdate(DocumentEvent e)
			{
				setSourceChanged(true);
			}
			
			@Override
			public void changedUpdate(DocumentEvent e)
			{
				setSourceChanged(true);
			}
		});
		
		this.addComponentListener(new ComponentAdapter() 
		{
			@Override
            public void componentResized(ComponentEvent e) 
			{
                fileText.setText(sourcePath);
            }
        });
	}
	
    void jbInit() throws Exception
    {
        titledBorder1 = new TitledBorder(BorderFactory.createLineBorder(new Color(153, 153, 153), 2), "Assembler messages");
        this.getContentPane().setLayout(borderLayout1);
		
        this.setIconifiable(true);
        this.setMaximizable(true);
        this.setResizable(true);
		
        this.setTitle("EDIT");

        splitPane.setOrientation(JSplitPane.VERTICAL_SPLIT);
        splitPane.setDividerLocation(470);
        sourceArea.setFont(new java.awt.Font("Monospaced", 0, 12));
        controlPanel.setLayout(gridBagLayout1);
        controlPanel.setBorder(BorderFactory.createLoweredBevelBorder());
        positionPanel.setLayout(gridBagLayout2);
        fileLabel.setText("Source file:");
        fileText.setEditable(false);
        browseButton.setSelected(false);
        browseButton.setText("Browse ...");
        assembleButton.setEnabled(false);
        assembleButton.setText("Assemble");
        saveButton.setEnabled(false);
        saveButton.setText("Save");
        saveMessagesButton.setEnabled(true);
        saveMessagesButton.setText("Save messages ...");
        lineLabel.setText("Line:");
        lineText.setMinimumSize(new Dimension(50, 20));
        lineText.setPreferredSize(new Dimension(50, 20));
        lineText.setEditable(false);
        columnLabel.setText("Column:");
        columnText.setMinimumSize(new Dimension(41, 20));
        columnText.setPreferredSize(new Dimension(41, 20));
        columnText.setEditable(false);
        columnText.setText("");
        messageScrollPane.setBorder(titledBorder1);
        messageScrollPane.setMinimumSize(new Dimension(33, 61));
        messageScrollPane.setPreferredSize(new Dimension(60, 90));
        optionsButton.setEnabled(false);
        optionsButton.setText("Options ...");
        messageScrollPane.getViewport().add(messageList, null);
        messageList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        this.getContentPane().add(splitPane, BorderLayout.CENTER);
        splitPane.add(textScrollPane, JSplitPane.TOP);
        splitPane.add(controlPanel, JSplitPane.BOTTOM);
        textScrollPane.getViewport().add(sourceArea, null);
		
		saveMessagesButton.setVisible(false); // Not implemented yet...
		
        controlPanel.add(fileLabel,
                         new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));
        controlPanel.add(fileText,
                         new GridBagConstraints(1, 0, 3, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 0), 0, 0));
        controlPanel.add(browseButton,
                         new GridBagConstraints(4, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 5), 0, 0));
        controlPanel.add(positionPanel,
                         new GridBagConstraints(0, 1, 4, 1, 0.8, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));
		positionPanel.add(lineLabel,
                          new GridBagConstraints(0, 0, 1, 1, 0.6, 0.0,
                                                 GridBagConstraints.WEST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 0, 0, 0), 0, 0));
		positionPanel.add(lineText,
                          new GridBagConstraints(1, 0, 1, 1, 0.6, 0.0,
                                                 GridBagConstraints.WEST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 5, 0, 0), 0, 0));
        positionPanel.add(columnLabel,
                          new GridBagConstraints(2, 0, 1, 1, 0.7, 0.0,
                                                 GridBagConstraints.WEST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 10, 0, 0), 0, 0));
        positionPanel.add(columnText,
                          new GridBagConstraints(3, 0, 1, 1, 0.7, 0.0,
                                                 GridBagConstraints.WEST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 5, 0, 0), 0, 0));
        controlPanel.add(messageScrollPane,
                         new GridBagConstraints(0, 2, 5, 1, 1.0, 1.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.BOTH,
                                                new Insets(5, 5, 5, 5), 0, 0));
		controlPanel.add(saveMessagesButton,
                         new GridBagConstraints(1, 1, 1, 1, 0.1, 0.0,
                                                GridBagConstraints.EAST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));

		controlPanel.add(optionsButton,
                         new GridBagConstraints(2, 1, 1, 1, 0.2, 0.0,
                                                GridBagConstraints.EAST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));
        controlPanel.add(assembleButton,
                         new GridBagConstraints(3, 1, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.EAST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));
        controlPanel.add(saveButton,
                         new GridBagConstraints(4, 1, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.EAST,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 5), 0, 0));
 	}

    boolean haveAssemblyErrors()
    {
        return haveAssemblyErrors;
    }

    private class AssemblyFileFilter extends FileFilter
    {
        private final String extensions[];
        private final String description;

        public AssemblyFileFilter(String extensions[], String description)
        {
            this.extensions = new String[extensions.length];
            this.description = description;

            for (int i = 0; i < extensions.length; ++i) 
			{
                this.extensions[i] = extensions[i].toLowerCase();
            }
        }

		@Override
        public boolean accept(File file)
        {
            if (file.isDirectory()) 
			{
                return true;
            }

            String name = file.getName().toLowerCase();
            for (int i = 0; i < extensions.length; ++i) 
			{
                if (name.endsWith(extensions[i])) 
				{
                    return true;
                }
            }

            return false;
        }

		@Override
        public String getDescription()
        {
            return description;
        }
    }

	@Override
    public void actionPerformed(ActionEvent event)
    {
        Object button = event.getSource();

        if (button == browseButton) 
		{
            browseAction();
        }
        else if (button == saveButton) 
		{
            saveAction();
        }
        else if (button == saveMessagesButton) 
		{
            saveMessagesAction();
        }
        else if (button == optionsButton) 
		{
            optionsAction();
        }
        else if (button == assembleButton) 
		{
            assembleAction();
        }
    }

    private void browseAction()
    {
		if(selectedPath == null)
		{
			// env var has the precedence
			selectedPath = System.getenv("ROPE_SOURCES_DIR");			
			if(selectedPath != null)
			{
				File dir = new File(selectedPath);
				if(!dir.exists() || !dir.isDirectory())
				{
					String message = String.format("The sources path set in environment variable ROPE_SOURCES_DIR is not avaliable.\n%s", 
																														selectedPath);
					JOptionPane.showMessageDialog(null, message , "ROPE", JOptionPane.WARNING_MESSAGE);
					selectedPath = null;
				}
				else
				{
					System.out.println("Source folder path set from ROPE_SOURCES_DIR: " + selectedPath);
				}
			}
			if(selectedPath == null)
			{
				selectedPath = userPrefs.get("sourcePath", "");
				if(selectedPath != null)
				{
					File dir = new File(selectedPath);
					if(!dir.exists() || !dir.isDirectory())
					{
						String message = String.format("The sources path set in preferences is not avaliable.\n%s", selectedPath);
						JOptionPane.showMessageDialog(null, message , "ROPE", JOptionPane.WARNING_MESSAGE);
						selectedPath = null;
					}
					else
					{
						System.out.println("Source folder path set from preferences: " + selectedPath);
					}
				}
			}
			if(selectedPath == null)
			{
				selectedPath = System.getProperty("user.dir");

				System.out.println("Source folder path set to current directory: " + selectedPath);
			}
		}

		ArrayList<RopeFileFilter> filters = new ArrayList<RopeFileFilter>();
		filters.add(new RopeFileFilter(new String[] {".a", ".asm", ".aut", ".s"}, "Assembly files (*.a *.asm *.aut *.s)"));
		filters.add(new RopeFileFilter(new String[] {".m", ".mac"}, "Macro files (*.m *.mac)"));
		filters.add(new RopeFileFilter(new String[] {".lst"}, "List files (*.lst)"));
		filters.add(new RopeFileFilter(new String[] {".txt"}, "Text files (*.txt)"));

		RopeFileChooser chooser = new RopeFileChooser(selectedPath, null, filters);
		chooser.setDialogTitle("Source document selection");
		chooser.setFileFilter(filters.get(0));
		chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
		
        File file = chooser.open(this, fileText);
        if (file != null) 
		{
			if(loadSourceFile(file))
			{
				mainFrame.showExecWindow(baseName);
				
				mainFrame.bringEditWindowInFront();
			}
	    }
    }
	
	public boolean loadSourceFile(File file)
	{
		boolean result =false;
		
		selectedPath = file.getParent();

		BufferedReader sourceFile = null;

		String directoryPath = file.getParent();
		sourceName = file.getName();

		int idx = sourceName.lastIndexOf(".");
		fileExt = idx == -1 ? "" : sourceName.substring(idx + 1);
		baseName = idx == -1 ? sourceName.substring(0) : sourceName.substring(0, idx);
		String basePath = directoryPath + File.separator + baseName;

		DataOptions.directoryPath = directoryPath;

		sourcePath = file.getPath();

		AssemblerOptions.sourcePath = sourcePath;
		AssemblerOptions.listingPath = basePath + ".lst";
		AssemblerOptions.objectPath = basePath + ".cd";
		AssemblerOptions.tapePath = basePath + ".tobj";
		AssemblerOptions.diagnosticPath = basePath + ".diag";

		// Sys env ROPE_MACROS_DIR has precedence on user pref macroPath
		AssemblerOptions.macroPath = null;
		String var = System.getenv("ROPE_MACROS_DIR");
		if(var != null && !var.isEmpty())
		{
			File dir = new File(var);
			if(dir.exists() && dir.isDirectory()) 
			{
				AssemblerOptions.macroPath = var;
			}
		}		
		if(AssemblerOptions.macroPath == null)
		{
			String pref = userPrefs.get("macroPath", "");
			File dir = new File(pref);
			if(dir.exists() && dir.isDirectory()) 
			{
				AssemblerOptions.macroPath = pref;
			}
		}		
		if(AssemblerOptions.macroPath == null)
		{
			AssemblerOptions.macroPath = directoryPath;
		}

		DataOptions.inputPath = AssemblerOptions.objectPath;
		DataOptions.outputPath = basePath + ".out";
		DataOptions.readerPath = null;
		DataOptions.punchPath = basePath + ".pch";
		DataOptions.tape1Path = basePath + ".mt1";
		DataOptions.tape2Path = basePath + ".mt2";
		DataOptions.tape3Path = basePath + ".mt3";
		DataOptions.tape4Path = basePath + ".mt4";
		DataOptions.tape5Path = basePath + ".mt5";
		DataOptions.tape6Path = basePath + ".mt6";

		this.setTitle("EDIT: " + sourceName);
		fileText.setText(sourcePath);

		if (dialog == null) 
		{
			dialog = new AssemblerDialog(mainFrame, "Assembler options");

			Dimension screenSize = Toolkit.getDefaultToolkit(). getScreenSize();
			Dimension dialogSize = dialog.getSize();
			dialog.setLocation((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2);
		}

		dialog.initialize();

		AssemblerOptions.command = dialog.buildCommand();

		sourceArea.setText(null);

		try 
		{
			sourceFile = new BufferedReader(new FileReader(file));
			String line;

			while ((line = sourceFile.readLine()) != null) 
			{
				sourceArea.append(line + "\n");
			}

			sourceArea.setCaretPosition(0);
			optionsButton.setEnabled(true);
			assembleButton.setEnabled(true);
			saveButton.setEnabled(true);

			setSourceChanged(false);
			undoMgr.discardAllEdits();
			
			result = true;
		}
		catch (IOException ex) 
		{
			ex.printStackTrace();
		}
		finally 
		{
			try 
			{
				if(sourceFile != null)
				{
					sourceFile.close();
				}
			}	
			catch (IOException ignore) {}
		}
		
		return result;
	}	

	public void saveMessagesAction()
    {
		System.out.println("Not implemented yet.");
	}
		
    public void saveAction()
    {
		BufferedWriter sourceFile = null;

        try 
		{
			BoolRef removedInvalidChars = new BoolRef(false);
			String cleanText = cleanupSource(sourceArea.getText(), removedInvalidChars);
			
			int caretPos = sourceArea.getCaretPosition();
			sourceArea.setText(cleanText);
			sourceArea.setCaretPosition(caretPos > cleanText.length() ? cleanText.length() : caretPos);
			
			if(removedInvalidChars.value)
			{
				String message = String.format("One or more invalid characters at the end of the source file have been removed.");
				JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.INFORMATION_MESSAGE);
			}
		
            sourceFile = new BufferedWriter(new FileWriter(sourcePath, false));
            sourceFile.write(cleanText);
			
			setSourceChanged(false);
			
			setupMenus();
        }
        catch (Exception ex) 
		{
            ex.printStackTrace();
        }
        finally 
		{
            if (sourceFile != null) 
			{
                try 
				{
                    sourceFile.close();
                }
                catch (IOException ignore) {}
            }
        }
    }
	
	public boolean getSourceChanged()
	{
		return sourceChanged;
	}
	
	public void setSourceChanged(boolean changed)
	{
		if(sourceChanged != changed)
		{
			sourceChanged = changed;
			setupMenus();
		}
	}
	
	public void saveAs()
	{
		ArrayList<RopeFileFilter> filters = new ArrayList<RopeFileFilter>();
		
		if(fileExt.equals("m") || fileExt.equals("mac"))
		{
			filters.add(new RopeFileFilter(new String[] {".m", ".mac"}, "Macro files (*.m *.mac)"));
			filters.add(new RopeFileFilter(new String[] {".a", ".asm", ".aut", ".s"}, "Assembly files (*.a *.asm *.aut *.s)"));
		}
		else
		{
			filters.add(new RopeFileFilter(new String[] {".a", ".asm", ".aut", ".s"}, "Assembly files (*.a *.asm *.aut *.s)"));
			filters.add(new RopeFileFilter(new String[] {".m", ".mac"}, "Macro files (*.m *.mac)"));
		}
		filters.add(new RopeFileFilter(new String[] {".txt"}, "Text files (*.txt)"));

		RopeFileChooser chooser = new RopeFileChooser(selectedPath, null, filters);
		chooser.setDialogTitle("Save Source File");
		String fileName = String.format("%s.%s", baseName, fileExt);
		chooser.setSelectedFile(new File(selectedPath, fileName));
		JTextField field = chooser.getTextField();
		field.setSelectionStart(0);
		field.setSelectionEnd(baseName.length());
		File file = chooser.save(ROPE.mainFrame);
		if(file != null)
		{
			selectedPath = file.getParent();
			
			BufferedWriter writer = null;
			try
			{
				writer = new BufferedWriter(new FileWriter(file));
				writer.write(sourceArea.getText());
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

    private void optionsAction()
    {
   		dialog.initialize();
		
 	    dialog.buildCommand();
		
        dialog.setVisible(true);
	}

    private void assembleAction()
    {
        String line;
        messages = new ArrayList();

		// Removes the .lst, .cd and .out files
		removeAssemblerFiles(sourcePath);

        mainFrame.resetExecWindow();

        saveAction();
		
		assembleFailed = false;
        haveAssemblyErrors = false;

        if(Assembler.version())
		{
			while ((line = Assembler.output()) != null) 
			{
				messages.add(line);
			}

			Assembler.setPaths(baseName, sourcePath);

			if(Assembler.assemble())
			{
				while ((line = Assembler.output()) != null) 
				{
					System.out.println(line);
					
					messages.add(line);
					
					if(line.startsWith(" [ERROR:"))
					{
						haveAssemblyErrors = true;
					}
				}

				messageList.setListData(messages.toArray());
				messageList.ensureIndexIsVisible(0);

				mainFrame.showExecWindow(baseName);
			}
			else
			{
				assembleFailed = true;
			}
		}
		else
		{
			assembleFailed = true;
		}
		
		if(assembleFailed)
		{
			String message = String.format("Autocoder failed!\nVerify the correctness of autocoder path\n%s", 
																						AssemblerOptions.assemblerPath);
			System.out.println(message);	
			
			JOptionPane.showMessageDialog(this, message, "ROPE", JOptionPane.ERROR_MESSAGE);
		}
    }

	public void saveMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			saveAction();
		}
	}

	public void saveAsMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			saveAs();
		}
	}

	private void highlightError(int index)
    {
        String message = (String) messages.get(index);
        int i = message.indexOf(":");

        if ((i != -1) && (i < 10) && Character.isDigit(message.charAt(i - 1))) 
		{
			try 
			{
				int lineNumber = Integer.parseInt(message.substring(0, i).trim()) - 1;
				if(lineNumber < sourceArea.getLineCount())
				{
					int start = sourceArea.getLineStartOffset(lineNumber);
					int end = sourceArea.getLineEndOffset(lineNumber);

					sourceArea.requestFocus();
					sourceArea.setSelectionStart(start);
					sourceArea.setSelectionEnd(end - 1);
				}
			}
			catch (Exception ex) 
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
	
	public void undoAction()
	{
		try 
		{				
			if (undoMgr.canUndo()) 
			{
				undoAction.actionPerformed(new ActionEvent(this, ActionEvent.ACTION_PERFORMED, "Undo" ));

				setUndoItem();
			}
			else
			{
				java.awt.Toolkit.getDefaultToolkit().beep();
			}
		} 
		catch (CannotUndoException ex) 
		{
			ex.printStackTrace();
		}
	}
	
	public void redoAction()
	{
		try 
		{
			if (undoMgr.canRedo()) 
			{
				redoAction.actionPerformed(new ActionEvent(this, ActionEvent.ACTION_PERFORMED, "Redo" ));

				setRedoItem();
			}
			else
			{
				java.awt.Toolkit.getDefaultToolkit().beep();
			}
		} 
		catch (CannotUndoException ex) 
		{
			ex.printStackTrace();
		}
	}
	
	public void setUndoItem()
	{
		String itemName = undoMgr.getUndoPresentationName();
		if(itemName != null && undoMgr.canUndo())
		{
			mainFrame.undoItem.setEnabled(true);
			mainFrame.undoItem.setName(itemName);
		}
		else
		{
			mainFrame.undoItem.setEnabled(false);
			mainFrame.undoItem.setName("Undo");
		}
	}

	public void setRedoItem()
	{
		String itemName = undoMgr.getUndoPresentationName();
		if(itemName != null && undoMgr.canRedo())
		{
			mainFrame.redoItem.setEnabled(true);
			mainFrame.redoItem.setName(itemName);
		}
		else
		{
			mainFrame.redoItem.setEnabled(false);
			mainFrame.redoItem.setName("Redo");
		}
	}

	class UpdateUndoAction extends AbstractAction
	{
		private static final long serialVersionUID = 1L;
		
		public UpdateUndoAction()
		{
			putValue(Action.NAME, "UpdateUndoAction");
			putValue(Action.SHORT_DESCRIPTION, getValue(Action.NAME));
		}

		@Override
		public void actionPerformed(ActionEvent e)
		{
			setUndoItem();
		}
	}
	
	class UpdateRedoAction extends AbstractAction
	{
		private static final long serialVersionUID = 1L;
		
		public UpdateRedoAction()
		{
			putValue(Action.NAME, "UpdateRedoAction");
			putValue(Action.SHORT_DESCRIPTION, getValue(Action.NAME));
		}

		@Override
		public void actionPerformed(ActionEvent e)
		{
			setRedoItem();
		}
	}

	public void selectLine()
	{
		Action selectLine = getAction(DefaultEditorKit.selectLineAction);
		if(selectLine != null)
		{
			selectLine.actionPerformed(null);
		}
	}
	
	private Action getAction(String name)
    {
		for(Action action : sourceArea.getActions()) 
		{
			if(name.equals(action.getValue(Action.NAME).toString())) 
			{
				return action;
			}
		}
  
        return null;
    }
	
	@Override
	public boolean canPaste()
	{
		return mainFrame.clipboardListener != null && mainFrame.clipboardListener.hasValidContent;
	}

	@Override
	public boolean canSave()
	{
		return sourceChanged;
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

	@Override
	public void internalFrameActivated(InternalFrameEvent e)
	{
		super.internalFrameActivated(e);
		
		mainFrame.pasteItem.setEnabled(canPaste());
		
		Caret caret = sourceArea.getCaret();
		doCaretUpdate(caret.getDot(), caret.getMark());
		
		setUndoItem();
		setRedoItem();
	}
	
	public void undoMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			undoAction();
		}
	}

	public void redoMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			redoAction();
		}
	}

	public void copyMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			sourceArea.copy();
		}
	}

	public void pasteMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			sourceArea.paste();
		}
	}
	
	public void cutMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			sourceArea.cut();
		}
	}
	
	public void deleteMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			sourceArea.replaceSelection("");
		}
	}

	public void selectAllMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			sourceArea.selectAll();
		}
	}

	public void selectLineMenuAction(ActionEvent event)
	{
		if(sourceArea != null)
		{
			selectLine();
		}
	}

	void doCaretUpdate(int dot, int mark)
	{	
        if (dot == mark) 
		{
            mainFrame.cutItem.setEnabled(false);  
            mainFrame.copyItem.setEnabled(false);
            mainFrame.deleteItem.setEnabled(false);
		}   
		else
		{
            mainFrame.cutItem.setEnabled(true);
            mainFrame.copyItem.setEnabled(true);
            mainFrame.deleteItem.setEnabled(true);
        }
		
		int length = sourceArea.getText().length();
		if(length == 0 || Math.abs(mark - dot) == length)
		{
			mainFrame.selectAllItem.setEnabled(false);
		}
		else
		{
			mainFrame.selectAllItem.setEnabled(true);
		}

		try 
		{
			if(length == 0)
			{
				mainFrame.selectLineItem.setEnabled(false);
			}
			else
			{
				int lineNum = sourceArea.getLineOfOffset(dot);
				int startLine = sourceArea.getLineStartOffset(lineNum);
				int endLine = sourceArea.getLineEndOffset(lineNum);
				if(endLine - startLine <= 1)
				{
					mainFrame.selectLineItem.setEnabled(false);
				}
				else
				{
					mainFrame.selectLineItem.setEnabled(true);
				}
			}
		}
		catch (BadLocationException ex) 
		{
			ex.printStackTrace();
		}
		
        try 
		{
            int line = sourceArea.getLineOfOffset(dot);
            lineText.setText(Integer.toString(line + 1));
            int column = dot - sourceArea.getLineStartOffset(line);
            columnText.setText(Integer.toString(column + 1));
        }
        catch(BadLocationException ex) 
		{
            ex.printStackTrace();
        }
	}
	
	String cleanupSource(String source, BoolRef removedInvalidChars) throws Exception
	{
		removedInvalidChars.value = false;
		
		if(source.isEmpty())
		{
			return source.concat("\n");
		}
		
		String timeID = getTimeID();
		String timeStr = getTimeString();
		
		int lastChIdx = source.length() - 1;
		if(source.charAt(lastChIdx) != '\n')
		{
			// Append a newline at the end
			source = source.concat("\n");
		}
		else
		{
			// Remove all newlines at the end but one
			int removedNewlines = 0;
			while(lastChIdx >= 1)
			{
				Character ch1 = source.charAt(lastChIdx);
				if(ch1 == '\n' || Character.isWhitespace(ch1))
				{
					source = source.substring(0, lastChIdx--);
					
					removedNewlines++;
				}
				else
				{
					break;
				}
			}
			
			removedInvalidChars.value = (removedNewlines > 1);
			
			source = source.concat("\n");
		}
		
		// Add the filename, the date/time and the 4-digit timeID to the JOB cards
		boolean jobCardModified = false;
		List<String> lines = new ArrayList<String>();		
		BufferedReader reader = new BufferedReader(new StringReader(source));
		try {
			// Remove all JOB rows
			String line;
			while ((line = reader.readLine()) != null) 
			{
				if(line.length() < 18 || line.substring(15, 18).compareTo("JOB") != 0)
				{		
					lines.add(line);
				}
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		
		// Add a new JOB row at the beginning
		String fileName = baseName.toUpperCase() + "." + fileExt.toUpperCase();
		String jobLine = "               JOB  " + fileName + " " + timeStr; 
		jobLine = String.format("%-75s", jobLine);
		jobLine = jobLine.concat(timeID);		
		lines.add(0, jobLine);
		
		// Write all rows
		StringWriter writer = new StringWriter();
		for(String line : lines)
		{
			writer.write(line + "\n");
		}

		source = writer.toString();
		
		return source;
	}
	
	void removeAssemblerFiles(String sourcePath)
	{
		if (sourcePath == null || sourcePath.length() == 0)
		{
			return;
		}
		
		String basePath = "";
		int endIndex = sourcePath.lastIndexOf(".");
		if (endIndex != -1)  
		{
			basePath = sourcePath.substring(0, endIndex);
		}

		System.out.println(basePath);
		
		try{  		
    		File file = new File(basePath + ".cd");   
			if(file.exists())
			{
				file.delete();
			}
			
    		file = new File(basePath + ".lst");  
			if(file.exists())
			{
				file.delete();
			}
			
			file = new File(basePath + ".out");       
			if(file.exists())
			{
				file.delete();
			}

   		    file = new File(basePath + ".tobj");   
			if(file.exists())
			{
				file.delete();
			}

			file = new File(basePath + ".diag");   
			if(file.exists())
			{
				file.delete();
			}
		}
		catch(Exception ex) 
		{
			ex.printStackTrace();
		}
	}
	
	String getTimeID() throws Exception
	{
		long secs = Calendar.getInstance(TimeZone.getDefault()).getTime().getTime() / 1000;
		String timeStr = Long.toString(secs);
		return "-" + timeStr.substring(timeStr.length() - 4);
	}
	
	String getTimeString() throws Exception
	{
		Date currentDate = Calendar.getInstance(TimeZone.getDefault()).getTime();
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yy HH:mm:ss");
        return dateFormat.format(currentDate);
	}
}
