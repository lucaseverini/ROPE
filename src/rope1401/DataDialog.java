/**
 * <p>Title: DataDialog.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.ArrayList;
import javax.swing.*;
import javax.swing.border.*;

public class DataDialog extends JDialog implements ActionListener
{
	private static final long serialVersionUID = 1L;
    Border border1 = new TitledBorder(BorderFactory.createLineBorder(Color.white, 2), "Card read/punch");
    Border border2 = BorderFactory.createLineBorder(Color.gray, 2);
    Border border3 = BorderFactory.createLineBorder(Color.white, 2);
    Border border4 = new TitledBorder(BorderFactory.createLineBorder(Color.white, 2), "Magnetic tape units");
    BorderLayout borderLayout1 = new BorderLayout();
    GridBagLayout gridBagLayout1 = new GridBagLayout();
    GridBagLayout gridBagLayout2 = new GridBagLayout();
    GridBagLayout gridBagLayout3 = new GridBagLayout();
    GridBagLayout gridBagLayout4 = new GridBagLayout();
    JPanel optionsPanel = new JPanel();
    JPanel messagePanel = new JPanel();
    JPanel cardPanel = new JPanel();
    JPanel tapePanel = new JPanel();
    JPanel buttonPanel = new JPanel();
    JTextArea messageText = new JTextArea();
    JCheckBox readerCheckBox = new JCheckBox();
    JTextField readerTextField = new JTextField();
    JButton readerBrowseButton = new JButton();
    JCheckBox punchCheckBox = new JCheckBox();
    JTextField punchTextField = new JTextField();
    JButton punchBrowseButton = new JButton();
    JCheckBox tape1CheckBox = new JCheckBox();
    JTextField tape1TextField = new JTextField();
    JButton tape1BrowseButton = new JButton();
    JCheckBox tape2CheckBox = new JCheckBox();
    JTextField tape2TextField = new JTextField();
    JButton tape2BrowseButton = new JButton();
    JCheckBox tape3CheckBox = new JCheckBox();
    JTextField tape3TextField = new JTextField();
    JButton tape3BrowseButton = new JButton();
    JCheckBox tape4CheckBox = new JCheckBox();
    JTextField tape4TextField = new JTextField();
    JButton tape4BrowseButton = new JButton();
    JCheckBox tape5CheckBox = new JCheckBox();
    JTextField tape5TextField = new JTextField();
    JButton tape5BrowseButton = new JButton();
    JCheckBox tape6CheckBox = new JCheckBox();
    JTextField tape6TextField = new JTextField();
    JButton tape6BrowseButton = new JButton();
    JButton okButton = new JButton();
    JButton cancelButton = new JButton();

    private RopeFrame parent;
    private File cardDeckFile;

    public DataDialog(RopeFrame parent, String title, boolean modal)
    {
        super(parent, title, modal);
        this.parent = parent;

        try {
            setDefaultCloseOperation(DISPOSE_ON_CLOSE);
            jbInit();
            pack();
        }
        catch (Exception exception) 
		{
            exception.printStackTrace();
        }
    }

    public DataDialog(RopeFrame parent, String title)
    {
        this(parent, title, true);

        readerBrowseButton.addActionListener(this);
        punchBrowseButton.addActionListener(this);
        tape1BrowseButton.addActionListener(this);
        tape2BrowseButton.addActionListener(this);
        tape3BrowseButton.addActionListener(this);
        tape4BrowseButton.addActionListener(this);
        tape5BrowseButton.addActionListener(this);
        tape6BrowseButton.addActionListener(this);
        okButton.addActionListener(this);
        cancelButton.addActionListener(this);
    }

    public DataDialog()
    {
        this(null, "DataDialog", false);
    }

    void initialize()
    {
        readerTextField.setText(DataOptions.readerPath);
        punchTextField.setText(DataOptions.punchPath);
        tape1TextField.setText(DataOptions.tape1Path);
        tape2TextField.setText(DataOptions.tape2Path);
        tape3TextField.setText(DataOptions.tape3Path);
        tape4TextField.setText(DataOptions.tape4Path);
        tape5TextField.setText(DataOptions.tape5Path);
        tape6TextField.setText(DataOptions.tape6Path);
    }

    private static final String DEFAULT_MESSAGE =
        "Enable an I/O unit by checking its checkbox.\n" +
        "The card input data deck will be loaded into the card reader after the object deck.";

    private void jbInit() throws Exception
    {
        messageText.setBackground(UIManager.getColor("MenuBar.background"));
        messageText.setFont(new java.awt.Font("Tahoma", Font.BOLD, 14));
        messageText.setMinimumSize(new Dimension(640, 40));
        messageText.setPreferredSize(new Dimension(640, 40));
        messageText.setEditable(false);
        messageText.setForeground(Color.blue);
        messageText.setText(DEFAULT_MESSAGE);
        messageText.setLineWrap(true);
        messageText.setWrapStyleWord(true);
        readerTextField.setBorder(border2);
        readerTextField.setEditable(false);
        readerCheckBox.setText("Reader file:");
        readerBrowseButton.setText("Browse ...");
        punchCheckBox.setText("Punch file:");
        punchBrowseButton.setText("Browse ...");
        tape1CheckBox.setText("Unit 1 file:");
        tape1BrowseButton.setText("Browse ...");
        tape2CheckBox.setText("Unit 2 file:");
        tape2BrowseButton.setText("Browse ...");
        tape3CheckBox.setText("Unit 3 file:");
        tape3BrowseButton.setText("Browse ...");
        tape4CheckBox.setText("Unit 4 file:");
        tape4BrowseButton.setText("Browse ...");
        tape5CheckBox.setText("Unit 5 file:");
        tape5BrowseButton.setText("Browse ...");
        tape6CheckBox.setText("Unit 6 file:");
        tape6BrowseButton.setText("Browse ...");
        okButton.setText("OK");
        cancelButton.setText("Cancel");

        getContentPane().add(optionsPanel);

        optionsPanel.setLayout(gridBagLayout1);
        optionsPanel.setPreferredSize(new Dimension(650, 450));
        optionsPanel.add(messagePanel,
                         new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.BOTH,
                                                new Insets(15, 15, 0, 15), 0, 0));
        optionsPanel.add(cardPanel,
                         new GridBagConstraints(0, 1, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 15, 0, 15),
                                                0, 0));
        optionsPanel.add(tapePanel,
                         new GridBagConstraints(0, 2, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 15, 0, 15), 0, 0));
        optionsPanel.add(buttonPanel,
                         new GridBagConstraints(0, 3, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 0, 15, 0), 0, 0));

        messagePanel.setLayout(borderLayout1);
        messagePanel.add(messageText, java.awt.BorderLayout.CENTER);

        cardPanel.setBorder(border1);
        cardPanel.setLayout(gridBagLayout2);
        cardPanel.add(readerCheckBox,
                      new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        cardPanel.add(readerTextField,
                      new GridBagConstraints(1, 0, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 0), 0, 0));
        cardPanel.add(readerBrowseButton,
                      new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.EAST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 5), 0, 0));
        cardPanel.add(punchCheckBox,
                      new GridBagConstraints(0, 1, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        cardPanel.add(punchTextField,
                      new GridBagConstraints(1, 1, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 0), 0, 0));
        cardPanel.add(punchBrowseButton,
                      new GridBagConstraints(2, 1, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));

        tapePanel.setBorder(border4);
        tapePanel.setLayout(gridBagLayout4);
        tapePanel.add(tape1CheckBox,
                      new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape1TextField,
                      new GridBagConstraints(1, 0, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape1BrowseButton,
                      new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));
        tapePanel.add(tape2CheckBox,
                      new GridBagConstraints(0, 1, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape2TextField,
                      new GridBagConstraints(1, 1, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape2BrowseButton,
                      new GridBagConstraints(2, 1, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));
        tapePanel.add(tape3CheckBox,
                      new GridBagConstraints(0, 2, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape3TextField,
                      new GridBagConstraints(1, 2, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape3BrowseButton,
                      new GridBagConstraints(2, 2, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));
        tapePanel.add(tape4CheckBox,
                      new GridBagConstraints(0, 3, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape4TextField,
                      new GridBagConstraints(1, 3, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape4BrowseButton,
                      new GridBagConstraints(2, 3, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));
        tapePanel.add(tape5CheckBox,
                      new GridBagConstraints(0, 4, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape5TextField,
                      new GridBagConstraints(1, 4, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 0), 0, 0));
        tapePanel.add(tape5BrowseButton,
                      new GridBagConstraints(2, 4, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));
        buttonPanel.setLayout(gridBagLayout3);
        buttonPanel.add(okButton,
                        new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.EAST,
                                               GridBagConstraints.NONE,
                                               new Insets(0, 0, 10, 50), 0, 0));
        buttonPanel.add(cancelButton,
                        new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(0, 0, 10, 0), 0, 0));
        tapePanel.add(tape6CheckBox,
                      new GridBagConstraints(0, 5, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 5, 0), 0, 0));
        tapePanel.add(tape6TextField,
                      new GridBagConstraints(1, 5, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 5, 0), 0, 0));
        tapePanel.add(tape6BrowseButton,
                      new GridBagConstraints(2, 5, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 5, 5), 0, 0));
    }

	@Override
    public void actionPerformed(ActionEvent event)
    {
        Object source = event.getSource();

        if (source == readerBrowseButton)
		{
            DataOptions.readerPath = browseAction(DataOptions.readerPath, readerTextField, null);
        }
        else if (source == punchBrowseButton) 
		{
            DataOptions.punchPath = browseAction(DataOptions.punchPath, punchTextField, null);
        }
        else if (source == tape1BrowseButton) 
		{
            DataOptions.tape1Path = browseAction(DataOptions.tape1Path, tape1TextField, null);
        }
        else if (source == tape2BrowseButton) 
		{
            DataOptions.tape2Path = browseAction(DataOptions.tape2Path, tape2TextField, null);
        }
        else if (source == tape3BrowseButton) 
		{
            DataOptions.tape3Path = browseAction(DataOptions.tape3Path, tape3TextField, null);
        }
        else if (source == tape4BrowseButton) 
		{
            DataOptions.tape4Path = browseAction(DataOptions.tape4Path, tape4TextField, null);
        }
        else if (source == tape5BrowseButton) 
		{
            DataOptions.tape5Path = browseAction(DataOptions.tape5Path, tape5TextField, null);
        }
        else if (source == tape6BrowseButton)
		{
            DataOptions.tape6Path = browseAction(DataOptions.tape6Path, tape6TextField, null);
        }
        else if (source == okButton)
		{
            if (OkAction()) 
			{
                this.setVisible(false);
                messageText.setForeground(Color.blue);
                messageText.setText(DEFAULT_MESSAGE);
            }
        }
        else if (source == cancelButton) 
		{
            this.setVisible(false);
        }
    }

    private String browseAction(String filePath, JTextField textField, ArrayList<RopeFileFilter> filters)
    {
        RopeFileChooser chooser = new RopeFileChooser(DataOptions.directoryPath, filePath, filters);
        File choice = chooser.open(this, textField);

        if (textField == readerTextField) 
		{
            cardDeckFile = choice;

            if (cardDeckFile != null) 
			{
                DataOptions.directoryPath = cardDeckFile.getParent();
            }
        }

        return textField.getText();
    }

    private boolean OkAction()
    {
		if(readerCheckBox.isSelected() && DataOptions.readerPath == null)
		{
            messageText.setForeground(ExecFrame.DARK_RED);
            messageText.setText("*** Unit cd is invalid : Uncheck the checkbox or enter a file path.");
			return false;
		}
			
        DataOptions.inputPath = readerCheckBox.isSelected() ? loadCardData() : AssemblerOptions.objectPath;
        DataOptions.unitCommands = new ArrayList();

        return (handleUnit("cdp", punchCheckBox, punchTextField) &&
				handleUnit("mt1", tape1CheckBox, tape1TextField) &&
				handleUnit("mt2", tape2CheckBox, tape2TextField) &&
				handleUnit("mt3", tape3CheckBox, tape3TextField) &&
				handleUnit("mt4", tape4CheckBox, tape4TextField) &&
				handleUnit("mt5", tape5CheckBox, tape5TextField) &&
				handleUnit("mt6", tape6CheckBox, tape6TextField));
    }

    private String loadCardData()
    {
        if (cardDeckFile == null) 
		{
            if (DataOptions.readerPath.trim().length() > 0) 
			{
                cardDeckFile = new File(DataOptions.readerPath);
            }
            else
			{
                return AssemblerOptions.objectPath;
            }
        }

        File objectFile = new File(AssemblerOptions.objectPath);
        String objectName = objectFile.getName();
        String cardDeckName = cardDeckFile.getName();
        String name1 = objectName;
        String name2 = cardDeckName;

        int index = name1.lastIndexOf(".");
        if (index != -1)
		{
            name1 = name1.substring(0, index);
        }

        String inputName = name1 + "_PROG+DATA" + ".cd";
        File inputFile = new File(DataOptions.directoryPath, inputName);
        String inputPath = inputFile.getPath();

        try 
		{
            BufferedReader objectReader = new BufferedReader(new FileReader(objectFile));
            BufferedReader cardDeckReader = new BufferedReader(new FileReader(cardDeckFile));
            PrintWriter inputWriter = new PrintWriter(new FileWriter(inputFile));
			
            String line;
            while ((line = objectReader.readLine()) != null) 
			{
                inputWriter.println(line);
            }
			
            while ((line = cardDeckReader.readLine()) != null)
			{
                inputWriter.println(line);
            }

            objectReader.close();
            cardDeckReader.close();
            inputWriter.close();
        }
        catch (IOException ex) 
		{
            parent.writeMessage(ExecFrame.DARK_RED, "*** " + ex.getMessage());
        }

        return inputPath;
    }

	@SuppressWarnings("unchecked")
    private boolean handleUnit(String unitName, JCheckBox checkBox, JTextField filePath)
    {
        if (checkBox.isSelected()) 
		{
            String path = filePath.getText().trim();
            if (path.length() > 0) 
			{
                DataOptions.unitCommands.add("at " + unitName + " " + path);
                
				return true;
            }
            else 
			{
                messageText.setForeground(ExecFrame.DARK_RED);
                messageText.setText("*** Unit " + unitName + " is invalid : Uncheck the checkbox or enter a file path.");
                
				return false;
            }
        }
        else 
		{
			// There is no needs to detach any unit because the Simulator is restarted after any change to the input data.
            // DataOptions.unitCommands.add("det " + unitName);
            
			return true;
        }
    }
}
