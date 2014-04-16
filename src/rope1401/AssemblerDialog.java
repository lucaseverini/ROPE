/**
 * <p>Title: AssemblerDialog.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import java.awt.*;
import java.awt.Dimension;
import java.awt.event.*;
import java.io.*;
import java.util.Vector;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.event.*;

public class AssemblerDialog extends JDialog implements ActionListener, ChangeListener, CaretListener
{
	private static final long serialVersionUID = 1L;
	
    Border border1;
    Border border2;
    TitledBorder titledBorder1;
    TitledBorder titledBorder2;

    GridBagLayout gridBagLayout1 = new GridBagLayout();
    GridBagLayout gridBagLayout2 = new GridBagLayout();
    GridBagLayout gridBagLayout3 = new GridBagLayout();
    GridBagLayout gridBagLayout4 = new GridBagLayout();
    GridBagLayout gridBagLayout5 = new GridBagLayout();
    GridBagLayout gridBagLayout6 = new GridBagLayout();
    GridBagLayout gridBagLayout7 = new GridBagLayout();
    GridBagLayout gridBagLayout8 = new GridBagLayout();
	GridBagLayout gridBagLayout9 = new GridBagLayout();
 
    JPanel optionsPanel = new JPanel();
    JPanel assemblerPanel = new JPanel();
    JPanel bootPanel = new JPanel();
    JPanel encodingPanel = new JPanel();
    JPanel tracePanel = new JPanel();
    JPanel extrasPanel = new JPanel();
    JPanel buttonPanel = new JPanel();
    JScrollPane commandScrollPane = new JScrollPane();
	JPanel commandScrollPanel = new JPanel();
 
    JTextField assemblerText = new JTextField();
    JTextField listingText = new JTextField();
    JTextField objectText = new JTextField();
    JTextField macroText = new JTextField();
    JTextField tapeText = new JTextField();
    JTextField pageText = new JTextField();
    JTextArea commandArea = new JTextArea();

    JLabel coreLabel = new JLabel();

    JCheckBox bootCheckBox = new JCheckBox();
    JCheckBox encodingCheckBox = new JCheckBox();
    JCheckBox listingCheckBox = new JCheckBox();
    JCheckBox objectCheckBox = new JCheckBox();
    JCheckBox macroCheckBox = new JCheckBox();
    JCheckBox tapeCheckBox = new JCheckBox();
    JCheckBox diagnosticCheckBox = new JCheckBox();
    JTextField diagnosticText = new JTextField();
    JCheckBox codeOkCheckBox = new JCheckBox();
    JCheckBox interleaveCheckBox = new JCheckBox();
    JCheckBox storeCheckBox = new JCheckBox();
    JCheckBox dumpCheckBox = new JCheckBox();
    JCheckBox pageCheckBox = new JCheckBox();
    JCheckBox traceCheckBox = new JCheckBox();
    JCheckBox traceLexerCheckBox = new JCheckBox();
    JCheckBox traceParserCheckBox = new JCheckBox();
    JCheckBox traceProcessCheckBox = new JCheckBox();
    JCheckBox extrasCheckBox = new JCheckBox();
    JCheckBox extrasExCheckBox = new JCheckBox();
    JCheckBox extrasEndCheckBox = new JCheckBox();
    JCheckBox extrasQueueCheckBox = new JCheckBox();
    JCheckBox extrasReloaderCheckBox = new JCheckBox();

    ButtonGroup bootButtonGroup = new ButtonGroup();
    ButtonGroup sizeButtonGroup = new ButtonGroup();
    ButtonGroup encodingButtonGroup = new ButtonGroup();

    JRadioButton bootNoneRadioButton = new JRadioButton();
    JRadioButton bootIBMRadioButton = new JRadioButton();
    JRadioButton bootVan1RadioButton = new JRadioButton();
    JRadioButton bootVan2RadioButton = new JRadioButton();
    JRadioButton size1400RadioButton = new JRadioButton();
    JRadioButton size2000RadioButton = new JRadioButton();
    JRadioButton size4000RadioButton = new JRadioButton();
    JRadioButton size8000RadioButton = new JRadioButton();
    JRadioButton size12000RadioButton = new JRadioButton();
    JRadioButton size16000RadioButton = new JRadioButton();
    JRadioButton encodingSimhRadioButton = new JRadioButton();
    JRadioButton encodingARadioButton = new JRadioButton();
    JRadioButton encodingHRadioButton = new JRadioButton();
    JRadioButton encodingPrintRadioButton = new JRadioButton();

    JButton assemblerBrowseButton = new JButton();
    JButton listingBrowseButton = new JButton();
    JButton objectBrowseButton = new JButton();
    JButton macroBrowseButton = new JButton();
    JButton tapeBrowseButton = new JButton();
    JButton diagnosticBrowseButton = new JButton();
    JButton okButton = new JButton();
    JButton cancelButton = new JButton();

    public AssemblerDialog(Frame frame, String title, boolean modal)
    {
        super(frame, title, modal);

        try 
		{
            jbInit();
            pack();
        }
        catch (Exception ex) 
		{
            ex.printStackTrace();
        }
    }

    AssemblerDialog(Frame frame, String title)
    {
        this(frame, title, true);

        assemblerBrowseButton.addActionListener(this);
        listingBrowseButton.addActionListener(this);
        objectBrowseButton.addActionListener(this);
        macroBrowseButton.addActionListener(this);
        tapeBrowseButton.addActionListener(this);
        diagnosticBrowseButton.addActionListener(this);
        okButton.addActionListener(this);
        cancelButton.addActionListener(this);

        pageText.addActionListener(this);
        pageText.addCaretListener(this);

        bootCheckBox.addChangeListener(this);
        bootNoneRadioButton.addChangeListener(this);
        bootIBMRadioButton.addChangeListener(this);
        bootVan1RadioButton.addChangeListener(this);
        bootVan2RadioButton.addChangeListener(this);
        encodingCheckBox.addChangeListener(this);
        encodingSimhRadioButton.addChangeListener(this);
        encodingARadioButton.addChangeListener(this);
        encodingHRadioButton.addChangeListener(this);
        encodingPrintRadioButton.addChangeListener(this);
        size1400RadioButton.addChangeListener(this);
        size2000RadioButton.addChangeListener(this);
        size4000RadioButton.addChangeListener(this);
        size8000RadioButton.addChangeListener(this);
        size12000RadioButton.addChangeListener(this);
        size16000RadioButton.addChangeListener(this);
        listingCheckBox.addChangeListener(this);
        objectCheckBox.addChangeListener(this);
        macroCheckBox.addChangeListener(this);
        tapeCheckBox.addChangeListener(this);
        diagnosticCheckBox.addChangeListener(this);
        codeOkCheckBox.addChangeListener(this);
        interleaveCheckBox.addChangeListener(this);
        storeCheckBox.addChangeListener(this);
        dumpCheckBox.addChangeListener(this);
        pageCheckBox.addChangeListener(this);
        traceCheckBox.addChangeListener(this);
        traceLexerCheckBox.addChangeListener(this);
        traceParserCheckBox.addChangeListener(this);
        traceProcessCheckBox.addChangeListener(this);
        extrasCheckBox.addChangeListener(this);
        extrasExCheckBox.addChangeListener(this);
        extrasEndCheckBox.addChangeListener(this);
        extrasQueueCheckBox.addChangeListener(this);
        extrasReloaderCheckBox.addChangeListener(this);
    }

    public AssemblerDialog()
    {
        this(null, "", false);
    }

    private void jbInit() throws Exception
    {
        border1 = BorderFactory.createLineBorder(Color.white, 1);
        border2 = BorderFactory.createLineBorder(SystemColor.controlText, 1);
        titledBorder1 = new TitledBorder(BorderFactory.createLineBorder(Color.white, 1), "Assembler command");
        titledBorder2 = new TitledBorder(BorderFactory.createLineBorder(Color.white, 1), "Assembler path");
        this.setTitle("Assembler options");

        assemblerText.setText("");
        assemblerBrowseButton.setText("Browse ...");

        assemblerPanel.setBorder(titledBorder2);
        assemblerPanel.setLayout(gridBagLayout7);
        assemblerPanel.add(assemblerText,
                           new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                                  GridBagConstraints.CENTER,
                                                  GridBagConstraints.HORIZONTAL,
                                                  new Insets(0, 5, 5, 0), 0, 0));
        assemblerPanel.add(assemblerBrowseButton,
                           new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                  GridBagConstraints.CENTER,
                                                  GridBagConstraints.NONE,
                                                  new Insets(0, 5, 5, 5), 0, 0));

        bootCheckBox.setText("Select boot loader:");
        bootNoneRadioButton.setText("None");
        bootIBMRadioButton.setText("IBM");
        coreLabel.setText("Core size:");
        size1400RadioButton.setText("1400");
        size2000RadioButton.setText("2000");
        size4000RadioButton.setText("4000");
        size8000RadioButton.setText("8000");
        size12000RadioButton.setText("12000");
        size16000RadioButton.setText("16000");
        bootVan1RadioButton.setText("Van\'s favorite 1-card loader / no clear");
        bootVan2RadioButton.setText("Van\'s favorite 2-card loader / clear");
        bootButtonGroup.add(bootNoneRadioButton);
        bootButtonGroup.add(bootIBMRadioButton);
        bootButtonGroup.add(bootVan1RadioButton);
        bootButtonGroup.add(bootVan2RadioButton);
        sizeButtonGroup.add(size1400RadioButton);
        sizeButtonGroup.add(size2000RadioButton);
        sizeButtonGroup.add(size4000RadioButton);
        sizeButtonGroup.add(size8000RadioButton);
        sizeButtonGroup.add(size12000RadioButton);
        sizeButtonGroup.add(size16000RadioButton);

        bootPanel.setLayout(gridBagLayout2);
        bootPanel.add(bootCheckBox,
                      new GridBagConstraints(0, 1, 2, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 15, 0,0), 0, 0));
        bootPanel.add(bootNoneRadioButton,
                      new GridBagConstraints(2, 0, 2, 2, 0.0, 0.0,
                                             GridBagConstraints.SOUTHWEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 15, 0, 0), 0, 0));
        bootPanel.add(bootIBMRadioButton,
                      new GridBagConstraints(2, 2, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 15, 0, 0), 0, 0));
        bootPanel.add(coreLabel,
                      new GridBagConstraints(3, 3, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 5, 0, 0), 0, 0));
        bootPanel.add(size1400RadioButton,
                      new GridBagConstraints(3, 4, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 15, 0, 0), 0, 0));
        bootPanel.add(size2000RadioButton,
                      new GridBagConstraints(4, 4, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 5, 0, 0), 0, 0));
        bootPanel.add(size4000RadioButton,
                      new GridBagConstraints(5, 4, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 5, 0, 0), 0, 0));
        bootPanel.add(size8000RadioButton,
                      new GridBagConstraints(3, 5, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 15, 0, 0), 0, 0));
        bootPanel.add(size12000RadioButton,
                      new GridBagConstraints(4, 5, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 5, 0, 0), 0, 0));
        bootPanel.add(bootVan1RadioButton,
                      new GridBagConstraints(2, 6, 4, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 15, 0, 0), 0, 0));
        bootPanel.add(bootVan2RadioButton,
                      new GridBagConstraints(2, 7, 4, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 15, 0, 0), 0, 0));
        bootPanel.add(size16000RadioButton,
                      new GridBagConstraints(5, 5, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(0, 5, 0, 0), 0, 0));

        encodingCheckBox.setText("Encoding:");
        encodingSimhRadioButton.setText("Traditional SIMH");
        encodingARadioButton.setText("Pierce IBM A");
        encodingHRadioButton.setText("Pierce IBM H");
        encodingPrintRadioButton.setText("Print only");
        encodingButtonGroup.add(encodingSimhRadioButton);
        encodingButtonGroup.add(encodingARadioButton);
        encodingButtonGroup.add(encodingHRadioButton);
        encodingButtonGroup.add(encodingPrintRadioButton);

        encodingPanel.setLayout(gridBagLayout8);
        encodingPanel.add(encodingARadioButton,
                          new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.CENTER,
                                                 GridBagConstraints.NONE,
                                                 new Insets(5, 5, 0, 0), 0, 0));
        encodingPanel.add(encodingHRadioButton,
                          new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.CENTER,
                                                 GridBagConstraints.NONE,
                                                 new Insets(5, 5, 0, 0), 0, 0));
        encodingPanel.add(encodingPrintRadioButton,
                          new GridBagConstraints(3, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.CENTER,
                                                 GridBagConstraints.NONE,
                                                 new Insets(5, 5, 0, 5), 0, 0));
        encodingPanel.add(encodingSimhRadioButton,
                          new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.CENTER,
                                                 GridBagConstraints.NONE,
                                                 new Insets(5, 0, 0, 0), 0, 0));

        listingCheckBox.setText("Listing:");
        listingText.setText("");
        listingBrowseButton.setText("Browse ...");

        objectCheckBox.setText("Object deck:");
        objectText.setText("");
        objectBrowseButton.setText("Browse ...");

        macroCheckBox.setText("Macro library:");
        macroText.setText("");
        macroBrowseButton.setText("Browse ...");

        tapeCheckBox.setText("Tape file:");
        tapeBrowseButton.setText("Browse ...");
        tapeText.setText("");

        diagnosticCheckBox.setText("Diagnostic file:");
        diagnosticBrowseButton.setText("Browse ...");

        codeOkCheckBox.setText("Code in 1..80 is OK");
        interleaveCheckBox.setText("Interleave object deck into listing");
        storeCheckBox.setText("Store long literals once");
        dumpCheckBox.setText(" Dump the symbol and literal tables");

        pageCheckBox.setText("Page length:");
        pageText.setText("60");
        pageText.setMinimumSize(new Dimension(40, 20));
        pageText.setPreferredSize(new Dimension(40, 20));

        traceCheckBox.setText("Trace:");
        traceLexerCheckBox.setText("Lexer");
        traceParserCheckBox.setText("Parser");
        traceProcessCheckBox.setText("PROCESS_LTORG");

        tracePanel.setLayout(gridBagLayout3);
        tracePanel.add(traceLexerCheckBox,
                       new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.WEST,
                                              GridBagConstraints.NONE,
                                              new Insets(5, 5, 0, 0), 0, 0));
        tracePanel.add(traceParserCheckBox,
                       new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.WEST,
                                              GridBagConstraints.NONE,
                                              new Insets(5, 5, 0, 0), 0, 0));
        tracePanel.add(traceProcessCheckBox,
                       new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.WEST,
                                              GridBagConstraints.NONE,
                                              new Insets(5, 5, 0, 15), 0, 0));

        extrasCheckBox.setText("Extras:");
        extrasExCheckBox.setText("Quick EX/XFR");
        extrasEndCheckBox.setText("Quick END");
        extrasQueueCheckBox.setText("Queue SW");
        extrasReloaderCheckBox.setText("No reloader");

        extrasPanel.setLayout(gridBagLayout4);
        extrasPanel.add(extrasExCheckBox,
                        new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.WEST,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 0, 0), 0, 0));
        extrasPanel.add(extrasEndCheckBox,
                        new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.WEST,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 0, 0), 0, 0));
        extrasPanel.add(extrasQueueCheckBox,
                        new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.WEST,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 0, 0), 0, 0));
        extrasPanel.add(extrasReloaderCheckBox,
                        new GridBagConstraints(3, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 0, 0), 0, 0));

 		commandScrollPane.setMinimumSize(new Dimension(600, 100));
		commandScrollPane.setPreferredSize(new Dimension(600, 100));
        commandScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        // commandScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_NEVER);
        commandScrollPane.getViewport().add(commandArea, null);
        commandArea.setLineWrap(true);
        commandArea.setWrapStyleWord(true);
        commandArea.setText("");
		commandArea.setEditable(false);

        commandScrollPanel.setBorder(titledBorder1);
        commandScrollPanel.setLayout(gridBagLayout9);
        commandScrollPanel.add(commandScrollPane,
                          new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                                  GridBagConstraints.WEST,
                                                  GridBagConstraints.BOTH,
                                                  new Insets(0, 5, 5, 0), 0, 0));

		okButton.setText("OK");
        cancelButton.setText("Cancel");

        buttonPanel.setLayout(gridBagLayout6);
        buttonPanel.add(okButton,
                        new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(0, 0, 15, 10), 0, 0));
        buttonPanel.add(cancelButton,
                        new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(0, 10, 15, 0), 0, 0));

        optionsPanel.setLayout(gridBagLayout5);
        optionsPanel.add(assemblerPanel,
                         new GridBagConstraints(0, 0, 4, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 15, 15, 15), 0, 0));
        optionsPanel.add(bootPanel,
                         new GridBagConstraints(0, 1, 4, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(0, 0, 0,0), 0, 0));
        optionsPanel.add(encodingCheckBox,
                         new GridBagConstraints(0, 2, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(encodingPanel,
                         new GridBagConstraints(2, 2, 3, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(0, 0, 0, 5), 0, 0));
        optionsPanel.add(listingCheckBox,
                         new GridBagConstraints(0, 3, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(listingText,
                         new GridBagConstraints(1, 3, 2, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 0), 0, 0));
        optionsPanel.add(listingBrowseButton,
                         new GridBagConstraints(3, 3, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 15), 0, 0));
        optionsPanel.add(objectCheckBox,
                         new GridBagConstraints(0, 4, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(objectText,
                         new GridBagConstraints(1, 4, 2, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 0), 0, 0));
        optionsPanel.add(objectBrowseButton,
                         new GridBagConstraints(3, 4, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 15), 0, 0));
        optionsPanel.add(macroCheckBox,
                         new GridBagConstraints(0, 5, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(macroText,
                         new GridBagConstraints(1, 5, 2, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 0), 0, 0));
        optionsPanel.add(macroBrowseButton,
                         new GridBagConstraints(3, 5, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 15), 0, 0));
        optionsPanel.add(tapeCheckBox,
                         new GridBagConstraints(0, 6, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(tapeText,
                         new GridBagConstraints(1, 6, 2, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 0), 0, 0));
        optionsPanel.add(tapeBrowseButton,
                         new GridBagConstraints(3, 6, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 15), 0, 0));
        optionsPanel.add(diagnosticCheckBox,
                         new GridBagConstraints(0, 7, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(diagnosticText,
                         new GridBagConstraints(2, 7, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 0, 0), 0, 0));
        optionsPanel.add(diagnosticBrowseButton,
                         new GridBagConstraints(3, 7, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 15), 0, 0));
        optionsPanel.add(codeOkCheckBox,
                         new GridBagConstraints(0, 8, 3, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 15), 0, 0));
        optionsPanel.add(interleaveCheckBox,
                         new GridBagConstraints(0, 9, 4, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 15), 0, 0));
        optionsPanel.add(storeCheckBox,
                         new GridBagConstraints(0, 10, 4, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 15), 0, 0));
        optionsPanel.add(dumpCheckBox,
                         new GridBagConstraints(0, 11, 4, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(pageCheckBox,
                         new GridBagConstraints(0, 12, 2, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(pageText,
                         new GridBagConstraints(2, 12, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));
        optionsPanel.add(traceCheckBox,
                         new GridBagConstraints(0, 13, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(tracePanel,
                         new GridBagConstraints(1, 13, 3, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(0, 0, 0, 0), 0, 0));
        optionsPanel.add(extrasCheckBox,
                         new GridBagConstraints(0, 14, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 15, 0, 0), 0, 0));
        optionsPanel.add(extrasPanel,
                         new GridBagConstraints(1, 14, 3, 1, 0.0, 0.0,
                                                GridBagConstraints.NORTHWEST,
                                                GridBagConstraints.NONE,
                                                new Insets(0, 0, 0, 0), 0, 0));
        optionsPanel.add(commandScrollPanel,
                         new GridBagConstraints(0, 15, 4, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 15, 15, 15), 0, 0));
        optionsPanel.add(buttonPanel,
                         new GridBagConstraints(0, 16, 4, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(0, 0, 0, 0), 0, 0));
        getContentPane().add(optionsPanel);
    }

    void initialize()
    {
        assemblerText.setText(AssemblerOptions.assemblerPath);
        listingText.setText(AssemblerOptions.listingPath);
        objectText.setText(AssemblerOptions.objectPath);
        macroText.setText(AssemblerOptions.macroPath);
        tapeText.setText(AssemblerOptions.tapePath);
        pageText.setText(AssemblerOptions.pageLength);

        bootCheckBox.setSelected(AssemblerOptions.boot);
        encodingCheckBox.setSelected(AssemblerOptions.encoding);
        listingCheckBox.setSelected(AssemblerOptions.listing);
        objectCheckBox.setSelected(AssemblerOptions.object);
        macroCheckBox.setSelected(AssemblerOptions.macro);
        tapeCheckBox.setSelected(AssemblerOptions.tape);
        diagnosticCheckBox.setSelected(AssemblerOptions.diagnostic);
        codeOkCheckBox.setSelected(AssemblerOptions.codeOk);
        interleaveCheckBox.setSelected(AssemblerOptions.interleave);
        storeCheckBox.setSelected(AssemblerOptions.store);
        dumpCheckBox.setSelected(AssemblerOptions.dump);
        pageCheckBox.setSelected(AssemblerOptions.page);
        traceCheckBox.setSelected(AssemblerOptions.trace);
        traceLexerCheckBox.setSelected(AssemblerOptions.traceLexer);
        traceParserCheckBox.setSelected(AssemblerOptions.traceParser);
        traceProcessCheckBox.setSelected(AssemblerOptions.traceProcess);
        extrasCheckBox.setSelected(AssemblerOptions.extras);
        extrasExCheckBox.setSelected(AssemblerOptions.extrasEx);
        extrasEndCheckBox.setSelected(AssemblerOptions.extrasEnd);
        extrasQueueCheckBox.setSelected(AssemblerOptions.extrasQueue);
        extrasReloaderCheckBox.setSelected(AssemblerOptions.extrasReloader);

        bootNoneRadioButton.setSelected(false);
        bootIBMRadioButton.setSelected(false);
        bootVan1RadioButton.setSelected(false);
        bootVan2RadioButton.setSelected(false);

        switch (AssemblerOptions.bootLoader) {
            case AssemblerOptions.BOOT_NONE: {
                bootNoneRadioButton.setSelected(true);
                break;
            }
            case AssemblerOptions.BOOT_IBM: {
                bootIBMRadioButton.setSelected(true);
                break;
            }
            case AssemblerOptions.BOOT_VAN_1: {
                bootVan1RadioButton.setSelected(true);
                break;
            }
            case AssemblerOptions.BOOT_VAN_2: {
                bootVan2RadioButton.setSelected(true);
                break;
            }
        }

        size1400RadioButton.setSelected(
            AssemblerOptions.coreSize == AssemblerOptions.SIZE_1400);
        size2000RadioButton.setSelected(
            AssemblerOptions.coreSize == AssemblerOptions.SIZE_2000);
        size4000RadioButton.setSelected(
            AssemblerOptions.coreSize == AssemblerOptions.SIZE_4000);
        size8000RadioButton.setSelected(
            AssemblerOptions.coreSize == AssemblerOptions.SIZE_8000);
        size12000RadioButton.setSelected(
            AssemblerOptions.coreSize == AssemblerOptions.SIZE_12000);
        size16000RadioButton.setSelected(
            AssemblerOptions.coreSize == AssemblerOptions.SIZE_16000);

        encodingSimhRadioButton.setSelected(
            AssemblerOptions.encodingChoice.equals(
                AssemblerOptions.ENCODING_SIMH));
        encodingARadioButton.setSelected(
            AssemblerOptions.encodingChoice.equals(
                AssemblerOptions.ENCODING_SIMH));
        encodingHRadioButton.setSelected(
            AssemblerOptions.encodingChoice.equals(
                AssemblerOptions.ENCODING_SIMH));
        encodingPrintRadioButton.setSelected(
            AssemblerOptions.encodingChoice.equals(
                AssemblerOptions.ENCODING_SIMH));

        enableBoot();
        enableEncoding();
        enablePage();
        enableTrace();
        enableExtras();
    	enableListing();
		enableObject();
		enableMacro();
		enableTape();
		enableDiagnostic();
	}

    private void enableBoot()
    {
        boolean enabled = bootCheckBox.isSelected();

        bootNoneRadioButton.setEnabled(enabled);
        bootIBMRadioButton.setEnabled(enabled);
        bootVan1RadioButton.setEnabled(enabled);
        bootVan2RadioButton.setEnabled(enabled);

        enabled = enabled && bootIBMRadioButton.isSelected();
        coreLabel.setEnabled(enabled);
        size1400RadioButton.setEnabled(enabled);
        size2000RadioButton.setEnabled(enabled);
        size4000RadioButton.setEnabled(enabled);
        size8000RadioButton.setEnabled(enabled);
        size12000RadioButton.setEnabled(enabled);
        size16000RadioButton.setEnabled(enabled);
    }

    private void enableEncoding()
    {
        boolean enabled = encodingCheckBox.isSelected();

        encodingSimhRadioButton.setEnabled(enabled);
        encodingARadioButton.setEnabled(enabled);
        encodingHRadioButton.setEnabled(enabled);
        encodingPrintRadioButton.setEnabled(enabled);

        encodingSimhRadioButton.setSelected(AssemblerOptions.encodingChoice.equals(AssemblerOptions.ENCODING_SIMH));
    }

    private void enableInterleave()
    {
        boolean enabled = listingCheckBox.isSelected() && objectCheckBox.isSelected();

        interleaveCheckBox.setEnabled(enabled);
    }

	private void enableListing()
    {
        boolean enabled = listingCheckBox.isSelected();

        listingText.setEnabled(enabled);
		listingBrowseButton.setEnabled(enabled);
    }

	private void enableObject()
    {
        boolean enabled = objectCheckBox.isSelected();

        objectText.setEnabled(enabled);
		objectBrowseButton.setEnabled(enabled);
    }

	private void enableTape()
    {
        boolean enabled = tapeCheckBox.isSelected();

        tapeText.setEnabled(enabled);
		tapeBrowseButton.setEnabled(enabled);
    }

	private void enableDiagnostic()
    {
        boolean enabled = diagnosticCheckBox.isSelected();

        diagnosticText.setEnabled(enabled);
		diagnosticBrowseButton.setEnabled(enabled);
    }

	private void enableMacro()
    {
        boolean enabled = macroCheckBox.isSelected();

        macroText.setEnabled(enabled);
		macroBrowseButton.setEnabled(enabled);
    }

    private void enablePage()
    {
        boolean enabled = pageCheckBox.isSelected();

        pageText.setEnabled(enabled);
    }

    private void enableTrace()
    {
        boolean enabled = traceCheckBox.isSelected();

        traceLexerCheckBox.setEnabled(enabled);
        traceParserCheckBox.setEnabled(enabled);
        traceProcessCheckBox.setEnabled(enabled);
    }

    private void enableExtras()
    {
        boolean enabled = extrasCheckBox.isSelected();

        extrasExCheckBox.setEnabled(enabled);
        extrasEndCheckBox.setEnabled(enabled);
        extrasQueueCheckBox.setEnabled(enabled);
        extrasReloaderCheckBox.setEnabled(enabled);
    }

    Vector<String> buildCommand()
    {
        Vector<String> command = new Vector<String>();

        command.add(assemblerText.getText());

        if (bootCheckBox.isSelected() && !bootNoneRadioButton.isSelected()) 
		{
            command.add("-b");

            if (bootIBMRadioButton.isSelected()) 
			{
                command.add(size1400RadioButton.isSelected()      ? "I1"
                              : size2000RadioButton.isSelected()  ? "I2"
                              : size4000RadioButton.isSelected()  ? "I4"
                              : size8000RadioButton.isSelected()  ? "I8"
                              : size12000RadioButton.isSelected() ? "Iv"
                              : "Ix");
           }
            else 
			{
                command.add(bootVan1RadioButton.isSelected() ? "B" : "V");
            }
        }

        if (encodingCheckBox.isSelected())
		{
            command.add("-e");
            command.add( encodingSimhRadioButton.isSelected() ? "S"
                          : encodingARadioButton.isSelected() ? "A"
                          : encodingHRadioButton.isSelected() ? "H"
                          : "?");
        }

        if (listingCheckBox.isSelected()) 
		{
            command.add("-l");			
            command.add(listingText.getText());
        }

        if (objectCheckBox.isSelected()) 
		{
            command.add("-o");
            command.add(objectText.getText());
        }

        if (macroCheckBox.isSelected()) 
		{
            for (String macro : AssemblerOptions.macros.split(";")) 
			{
                command.add("-m");
                command.add(macro);
            }
			
            for (String path : macroText.getText().split(";")) 
			{
                command.add("-I");
                command.add(path);
            }
        }

        if (tapeCheckBox.isSelected()) 
		{
            command.add("-t");
            command.add(tapeText.getText());
        }

        if (diagnosticCheckBox.isSelected()) 
		{			
            command.add("-d");
            command.add(diagnosticText.getText());
        }

        if (codeOkCheckBox.isSelected()) 
		{
            command.add("-a");
        }

        if (interleaveCheckBox.isEnabled() && interleaveCheckBox.isSelected()) 
		{
            command.add("-i");
        }

        if (storeCheckBox.isSelected()) 
		{
            command.add("-L");
        }

        if (dumpCheckBox.isSelected()) 
		{
            command.add("-s");
        }

        if (pageCheckBox.isSelected()) 
		{
            String pageLength = pageText.getText();

            if (pageLength.length() > 0) 
			{
                command.add("-p");
			    command.add(pageLength);
            }
        }

        if (traceCheckBox.isSelected()) 
		{
            StringBuffer letters = new StringBuffer(3);

            if (traceLexerCheckBox.isSelected()) 
			{
                letters.append('l');
            }
			
            if (traceParserCheckBox.isSelected()) 
			{
                letters.append('p');
            }
			
            if (traceProcessCheckBox.isSelected()) 
			{
                letters.append('P');
            }
			
            if (letters.length() > 0) 
			{
                command.add("-T");
                command.add(letters.toString());
            }
        }

        if (extrasCheckBox.isSelected()) 
		{
            int flag = 0;
			
            if (extrasExCheckBox.isSelected()) 
			{
                flag += 1;
            }
			
            if (extrasEndCheckBox.isSelected()) 
			{
                flag += 2;
            }
			
            if (extrasQueueCheckBox.isSelected()) 
			{
                flag += 4;
            }
			
            if (extrasReloaderCheckBox.isSelected()) 
			{
                flag += 8;
            }
			
            if (flag > 0) 
			{
                command.add("-X");
                command.add("" + flag);
            }
        }
		
        command.add(AssemblerOptions.sourcePath);
		
		String commandStr = "";
		for(int idx = 0; idx < command.size(); idx++)
		{
			if(idx < command.size() - 1)
			{
				commandStr = commandStr.concat(command.get(idx) + " ");
			}
			else
			{
				commandStr = commandStr.concat(command.get(idx));
			}
		}
		
        commandArea.setText(commandStr);

        return command;
    }

    private void browseAction(String title, String filePath, JTextField textField, Vector<RopeFileFilter> filters, 
																	 boolean directories, boolean multiple)
    {
        RopeFileChooser chooser = new RopeFileChooser(DataOptions.directoryPath, filePath, filters, directories, multiple);
		chooser.setDialogTitle(title);
        File file = chooser.choose(textField, this, multiple);
        if (file != null) 
		{
            DataOptions.directoryPath = file.getParent();
        }
    }

    private void okAction()
    {
        AssemblerOptions.assemblerPath = assemblerText.getText();

        AssemblerOptions.boot = bootCheckBox.isSelected();
        AssemblerOptions.bootLoader =
              bootIBMRadioButton.isSelected() ? AssemblerOptions.BOOT_IBM
            : bootVan1RadioButton.isSelected() ? AssemblerOptions.BOOT_VAN_1
            : bootVan2RadioButton.isSelected() ? AssemblerOptions.BOOT_VAN_2
            : AssemblerOptions.BOOT_NONE;

        AssemblerOptions.encoding = encodingCheckBox.isSelected();
        AssemblerOptions.encodingChoice =
              encodingSimhRadioButton.isSelected() ? AssemblerOptions.ENCODING_SIMH
            : encodingARadioButton.isSelected() ? AssemblerOptions.ENCODING_A
            : encodingHRadioButton.isSelected() ? AssemblerOptions.ENCODING_H
            : AssemblerOptions.ENCODING_PRINT;

        AssemblerOptions.listing = listingCheckBox.isSelected();
        AssemblerOptions.listingPath = listingText.getText();
        AssemblerOptions.object = objectCheckBox.isSelected();
        AssemblerOptions.objectPath = objectText.getText();
        AssemblerOptions.macro = macroCheckBox.isSelected();
        AssemblerOptions.macroPath = macroText.getText();
        AssemblerOptions.tape = tapeCheckBox.isSelected();
        AssemblerOptions.tapePath = tapeText.getText();
        AssemblerOptions.diagnostic = diagnosticCheckBox.isSelected();
        AssemblerOptions.diagnosticPath = diagnosticText.getText();

        AssemblerOptions.codeOk = codeOkCheckBox.isSelected();
        AssemblerOptions.interleave = interleaveCheckBox.isSelected();
        AssemblerOptions.store = storeCheckBox.isSelected();
        AssemblerOptions.dump = dumpCheckBox.isSelected();

        AssemblerOptions.page = pageCheckBox.isSelected();
        AssemblerOptions.pageLength = pageText.getText();

        AssemblerOptions.trace = traceCheckBox.isSelected();
        AssemblerOptions.traceLexer = traceLexerCheckBox.isSelected();
        AssemblerOptions.traceParser = traceParserCheckBox.isSelected();
        AssemblerOptions.traceProcess = traceProcessCheckBox.isSelected();

        AssemblerOptions.extras = extrasCheckBox.isSelected();
        AssemblerOptions.extrasEx = extrasExCheckBox.isSelected();
        AssemblerOptions.extrasEnd = extrasEndCheckBox.isSelected();
        AssemblerOptions.extrasQueue = extrasQueueCheckBox.isSelected();
        AssemblerOptions.extrasReloader = extrasReloaderCheckBox.isSelected();

        AssemblerOptions.command = buildCommand();
		
		Rope.savePreferences();
		
        this.setVisible(false);
    }

    private void cancelAction()
    {
        this.setVisible(false);
    }

	@Override
    public void actionPerformed(ActionEvent event)
    {
        Object source = event.getSource();

        if (source == assemblerBrowseButton) 
		{
 			Vector<RopeFileFilter> filters = null;
			if(RopeHelper.isWindows)
			{
				filters = new Vector<RopeFileFilter>();
				filters.add(new RopeFileFilter( new String[] {".exe",}, "Windows executable (*.exe)"));
			}
            browseAction("Assembler/Autocoder selection", AssemblerOptions.assemblerPath, assemblerText, filters, false, false);
            buildCommand();
        }
        else if (source == listingBrowseButton) 
		{
			Vector<RopeFileFilter> filters = new Vector<RopeFileFilter>();
			filters.add(new RopeFileFilter( new String[] {".lst", ".txt"}, "Assembly files (*.lst, *.txt)"));
            browseAction("Listing path selection", AssemblerOptions.listingPath, listingText, filters, false, false);
            buildCommand();
        }
        else if (source == objectBrowseButton) 
		{
			Vector<RopeFileFilter> filters = new Vector<RopeFileFilter>();
			filters.add(new RopeFileFilter( new String[] {".cd", ".crd", ".obj"}, "Object deck files (*.cd, *.crd, *.obj)"));
            browseAction("Object path selection", AssemblerOptions.objectPath, objectText, filters, false, false);
            buildCommand();
        }
        else if (source == macroBrowseButton) 
		{
            browseAction("Macro path selection", AssemblerOptions.macroPath, macroText, null, true, true);
            buildCommand();
        }
        else if (source == tapeBrowseButton) 
		{
            browseAction("Tape path selection", AssemblerOptions.tapePath, tapeText, null, false, false);
            buildCommand();
        }
        else if (source == diagnosticBrowseButton) 
		{
            browseAction("Diagnostic path selection", AssemblerOptions.diagnosticPath, diagnosticText, null, false, false);
            buildCommand();
        }
        else if (source == pageText) 
		{
            buildCommand();
        }
        else if (source == okButton) 
		{
            okAction();
        }
        else if (source == cancelButton) 
		{
            cancelAction();
        }
    }

	@Override
    public void caretUpdate(CaretEvent event)
    {
        Object source = event.getSource();

        if (source == pageText) {
            buildCommand();
        }
    }

	@Override
    protected void processWindowEvent(WindowEvent event)
    {
        super.processWindowEvent(event);

        if (event.getID() == WindowEvent.WINDOW_CLOSING) {
            cancelAction();
        }
    }

	@Override
    public void stateChanged(ChangeEvent event)
    {
        Object source = event.getSource();

        if ((source == bootCheckBox) || (source == bootIBMRadioButton)) 
		{
            enableBoot();
        }
        else if ((source == listingCheckBox) || (source == objectCheckBox)) 
		{
			enableListing();
			enableObject();
            enableInterleave();
        }
        else if (source == pageCheckBox) 
		{
            pageText.setEnabled(pageCheckBox.isSelected());
        }
        else if (source == traceCheckBox) 
		{
            enableTrace();
        }
        else if (source == extrasCheckBox) 
		{
            enableExtras();
        }
        else if (source == macroCheckBox) 
		{
            enableMacro();
        }
        else if (source == tapeCheckBox) 
		{
            enableTape();
        }
        else if (source == diagnosticCheckBox) 
		{
            enableDiagnostic();
        }
        else if (source == encodingCheckBox) 
		{
            enableEncoding();
        }

        buildCommand();
    }
}
