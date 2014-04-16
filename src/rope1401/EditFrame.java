/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import static java.lang.Math.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.*;
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
    JPanel positionPanel = new JPanel();
    JLabel lineLabel = new JLabel();
    JTextField lineText = new JTextField();
    JLabel columnLabel = new JLabel();
    JTextField columnText = new JTextField();
    JScrollPane messageScrollPane = new JScrollPane();
    JList messageList = new JList();
	
	public CompoundUndoManager undoMgr;
    private AssemblerDialog dialog = null;
    private String baseName;
	private boolean assembleFailed;
    private boolean haveAssemblyErrors;
    private Vector messages;
	public boolean sourceChanged;
	public String sourcePath;
	private Document document;
	private Action undoAction;
	private Action redoAction;

    EditFrame(RopeFrame parent)
    {
		super(parent);
		
        setSize(640, 700);
		
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
/*
		doc.addUndoableEditListener(new UndoableEditListener() 
		{
			@Override
			public void undoableEditHappened(UndoableEditEvent e) 
			{
				if(undoMgr.addEdit(e.getEdit()))
				{
					setEditMenuItems();
				}
			}
		});
*/
		// Remove automatic key bindings because we want them controlled by menu items
		InputMap im = sourceArea.getInputMap(JComponent.WHEN_FOCUSED);
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, RopeHelper.modifierMaks + InputEvent.SHIFT_MASK), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_X, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_C, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_V, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_A, RopeHelper.modifierMaks), "none");
		im.put(KeyStroke.getKeyStroke(KeyEvent.VK_L, RopeHelper.modifierMaks), "none");
		
		document.addDocumentListener(new DocumentListener()
		{
			@Override
			public void insertUpdate(DocumentEvent e)
			{
			  sourceChanged = true;
			}
			
			@Override
			public void removeUpdate(DocumentEvent e)
			{
			  sourceChanged = true;
			}
			
			@Override
			public void changedUpdate(DocumentEvent e)
			{
			  sourceChanged = true;
			}
		});
	}
	
    void jbInit() throws Exception
    {
        titledBorder1 = new TitledBorder(BorderFactory.createLineBorder( new Color(153, 153, 153), 2), "Assembly messages");
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
        assembleButton.setText("Assemble file");
        saveButton.setEnabled(false);
        saveButton.setText("Save file");
        lineLabel.setText("Line:");
        lineText.setMinimumSize(new Dimension(50, 20));
        lineText.setPreferredSize(new Dimension(50, 20));
        lineText.setEditable(false);
        columnLabel.setText("Column:");
        columnText.setMinimumSize(new Dimension(32, 20));
        columnText.setPreferredSize(new Dimension(32, 20));
        columnText.setEditable(false);
        columnText.setText("");
        messageScrollPane.setBorder(titledBorder1);
        messageScrollPane.setMinimumSize(new Dimension(33, 90));
        messageScrollPane.setPreferredSize(new Dimension(60, 90));
        optionsButton.setEnabled(false);
        optionsButton.setText("Assembler options ...");
        messageScrollPane.getViewport().add(messageList, null);
        messageList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        this.getContentPane().add(splitPane, BorderLayout.CENTER);
        splitPane.add(textScrollPane, JSplitPane.TOP);
        splitPane.add(controlPanel, JSplitPane.BOTTOM);
        textScrollPane.getViewport().add(sourceArea, null);
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
        controlPanel.add(optionsButton,
                         new GridBagConstraints(2, 1, 1, 1, 1.0, 0.0,
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
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 5), 0, 0));
        controlPanel.add(positionPanel,
                         new GridBagConstraints(0, 1, 2, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));
		positionPanel.add(lineLabel,
                          new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 0, 0, 0), 0, 0));
		positionPanel.add(lineText,
                          new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 5, 0, 0), 0, 0));
        positionPanel.add(columnLabel,
                          new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 10, 0, 0), 0, 0));
        positionPanel.add(columnText,
                          new GridBagConstraints(3, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 5, 0, 0), 0, 0));
        controlPanel.add(messageScrollPane,
                         new GridBagConstraints(0, 2, 5, 1, 1.0, 1.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.BOTH,
                                                new Insets(5, 5, 5, 5), 0, 0));
	}

    boolean haveAssemblyErrors()
    {
        return haveAssemblyErrors;
    }

    private class AssemblyFileFilter extends FileFilter
    {
        private String extensions[];
        private String description;

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
		Vector<RopeFileFilter> filters = new Vector<RopeFileFilter>();
		filters.add(new RopeFileFilter(new String[] {".a", ".asm", ".aut", ".s"}, "Assembly files (*.a *.asm *.aut *.s)"));
		filters.add(new RopeFileFilter(new String[] {".m", ".mac"}, "Macro files (*.m *.mac)"));
        RopeFileChooser chooser = new RopeFileChooser(DataOptions.directoryPath, null, filters);
		chooser.setDialogTitle("Source document selection");
		chooser.setFileFilter(filters.firstElement());
		chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
		
        File file = chooser.choose(fileText, this);
        if (file != null) 
		{
            BufferedReader sourceFile = null;

            String directoryPath = file.getParent();
            String sourceName = file.getName();

            int i = sourceName.lastIndexOf(".");
            baseName = i == -1 ? sourceName.substring(0) : sourceName.substring(0, i);
            String basePath = directoryPath + File.separator + baseName;

            DataOptions.directoryPath = directoryPath;

			sourcePath = file.getPath();
			
            AssemblerOptions.sourcePath = sourcePath;
            AssemblerOptions.listingPath = basePath + ".lst";
            AssemblerOptions.objectPath = basePath + ".cd";
			AssemblerOptions.macroPath = directoryPath;
			
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
				
				sourceChanged = false;
				undoMgr.discardAllEdits();
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
        }
    }

    public void saveAction()
    {
		BufferedWriter sourceFile = null;

        try 
		{
            sourceFile = new BufferedWriter(new FileWriter(sourcePath, false));
            sourceFile.write(sourceArea.getText());
			
			sourceChanged = false;
        }
        catch (IOException ex) 
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

    private void optionsAction()
    {
   		dialog.initialize();
		
 	    dialog.buildCommand();
		
        dialog.setVisible(true);
	}

    private void assembleAction()
    {
        String line;
        messages = new Vector();

        mainFrame.resetExecWindow();

        saveAction();
		assembleFailed = false;
        haveAssemblyErrors = false;

        if(Assembler.version())
		{
			while ((line = Assembler.output()) != null) 
			{
				messages.addElement(line);
			}

			Assembler.setPaths(baseName, sourcePath);

			if(Assembler.assemble())
			{
				while ((line = Assembler.output()) != null) 
				{
					System.out.println(line);
					
					messages.addElement(line);
					
					if(line.startsWith("[ERROR:"))
					{
						haveAssemblyErrors = true;
					}
				}

				messageList.setListData(messages);
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
			
			JOptionPane.showMessageDialog(this, message);
		}
    }

    private void highlightError(int index)
    {
        String message = (String) messages.elementAt(index);
        int i = message.indexOf(":");

        if ((i != -1) && (i < 10)) 
		{
            int lineNumber = Integer.parseInt(message.substring(0, i).trim()) - 1;

            try 
			{
                int start = sourceArea.getLineStartOffset(lineNumber);
                int end = sourceArea.getLineEndOffset(lineNumber);

                sourceArea.requestFocus();
                sourceArea.setSelectionStart(start);
                sourceArea.setSelectionEnd(end - 1);
            }
            catch (BadLocationException ex) 
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
		if(length == 0 || abs(mark - dot) == length)
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
}
