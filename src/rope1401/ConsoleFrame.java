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
import javax.swing.border.*;

public class ConsoleFrame extends ChildFrame implements ActionListener, ChangeListener, CommandWindow
{
	private static final long serialVersionUID = 1L;
	
    Border border1;
    Border border2;
    Border border3;
    Border border4;
    Border border5;
    Border border6;
    Border border7 = BorderFactory.createBevelBorder(BevelBorder.LOWERED,
                                                     Color.white, Color.white,
                                                     new Color(103, 101, 98),
                                                     new Color(148, 145, 140));
    Border border8 = new TitledBorder(border7, "Sense switches");
    TitledBorder titledBorder1;
    TitledBorder titledBorder2;
    TitledBorder titledBorder3;
    TitledBorder titledBorder4;
    GridBagLayout gridBagLayout0 = new GridBagLayout();
    GridBagLayout gridBagLayout1 = new GridBagLayout();
    GridBagLayout gridBagLayout2 = new GridBagLayout();
    GridBagLayout gridBagLayout3 = new GridBagLayout();
    GridBagLayout gridBagLayout4 = new GridBagLayout();
    GridBagLayout gridBagLayout5 = new GridBagLayout();
    GridBagLayout gridBagLayout6 = new GridBagLayout();
    JPanel buttonPanel = new JPanel();
    JButton updateButton = new JButton();
    JCheckBox autoCheckBox = new JCheckBox();
    JPanel displayPanel = new JPanel();
    JPanel registerPanel = new JPanel();
    JLabel iAddressLabel = new JLabel();
    JLabel aAddressLabel = new JLabel();
    JLabel bAddressLabel = new JLabel();
    JLabel iAddressText = new JLabel();
    JLabel aAddressText = new JLabel();
    JLabel bAddressText = new JLabel();
    JPanel errorPanel = new JPanel();
    JLabel aLabel = new JLabel();
    JLabel bLabel = new JLabel();
    JPanel logicPanel = new JPanel();
    JLabel overflowLabel = new JLabel();
    JLabel eqLabel = new JLabel();
    JLabel neLabel = new JLabel();
    JLabel gtLabel = new JLabel();
    JLabel ltLabel = new JLabel();
    JPanel checkPanel = new JPanel();
    JLabel processLabel = new JLabel();
    JLabel ioLabel = new JLabel();
    JPanel switchPanel = new JPanel();
    JCheckBox aCheckBox = new JCheckBox();
    JCheckBox bCheckBox = new JCheckBox();
    JCheckBox cCheckBox = new JCheckBox();
    JCheckBox dCheckBox = new JCheckBox();
    JCheckBox eCheckBox = new JCheckBox();
    JCheckBox fCheckBox = new JCheckBox();
    JCheckBox gCheckBox = new JCheckBox();

    private boolean enabled = true;
    private final static int A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6;

    ConsoleFrame(final RopeFrame parent)
    {
        super(parent);
		
	    // Implement a smarter way to set the initial frame position and size
		setLocation(1440, 710);
		setSize(340, 330);
 
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
				
				mainFrame.removeConsoleFrame();
           }
        });

        Color titleColor = new Color(204, 204, 255);
        titledBorder1.setTitleColor(titleColor);
        titledBorder2.setTitleColor(titleColor);
        titledBorder3.setTitleColor(titleColor);
        titledBorder4.setTitleColor(titleColor);

        updateButton.addActionListener(this);
        aCheckBox.addChangeListener(this);
        bCheckBox.addChangeListener(this);
        cCheckBox.addChangeListener(this);
        dCheckBox.addChangeListener(this);
        eCheckBox.addChangeListener(this);
        fCheckBox.addChangeListener(this);
        gCheckBox.addChangeListener(this);

        update();

        if (parent.senseSwitchesEnabled()) 
		{
            enableSenseSwitches();
        }
        else 
		{
            disableSenseSwitches();
        }
    }

    void jbInit() throws Exception
    {
        this.setClosable(true);
        this.setIconifiable(true);
        this.setMaximizable(false);
        this.setTitle("CONSOLE");

		border1 = BorderFactory.createBevelBorder(BevelBorder.LOWERED,
                                                  Color.white, Color.white,
                                                  new Color(99, 99, 99),
                                                  new Color(142, 142, 142));
        border2 = BorderFactory.createBevelBorder(BevelBorder.LOWERED,
                                                  Color.white, Color.white,
                                                  new Color(99, 99, 99),
                                                  new Color(142, 142, 142));
        border3 = BorderFactory.createBevelBorder(BevelBorder.LOWERED,
                                                  Color.white, Color.white,
                                                  new Color(99, 99, 99),
                                                  new Color(142, 142, 142));
        border4 = BorderFactory.createBevelBorder(BevelBorder.LOWERED,
                                                  Color.white, Color.white,
                                                  new Color(99, 99, 99),
                                                  new Color(142, 142, 142));
        border5 = BorderFactory.createBevelBorder(BevelBorder.LOWERED,
                                                  Color.white, Color.white,
                                                  new Color(99, 99, 99),
                                                  new Color(142, 142, 142));
        border6 = BorderFactory.createBevelBorder(BevelBorder.LOWERED,
                                                  Color.white, Color.white,
                                                  new Color(99, 99, 99),
                                                  new Color(142, 142, 142));
		
        titledBorder1 = new TitledBorder(BorderFactory.createLineBorder(new Color(204, 204, 255), 1), "Registers");
        titledBorder2 = new TitledBorder(BorderFactory.createLineBorder(new Color(204, 204, 255), 1), "Error");
        titledBorder3 = new TitledBorder(BorderFactory.createLineBorder(new Color(204, 204, 255), 1), "Logic");
        titledBorder4 = new TitledBorder(BorderFactory.createLineBorder(new Color(204, 204, 255), 1), "Check");
		        
        this.buttonPanel.setLayout(gridBagLayout0);
        this.displayPanel.setLayout(gridBagLayout1);
		
        buttonPanel.setBorder(border6);
        autoCheckBox.setSelected(true);
        autoCheckBox.setText("Auto update");
        updateButton.setText("Update");
        registerPanel.setBackground(new Color(0, 70, 0));
        registerPanel.setForeground(Color.black);
        registerPanel.setBorder(titledBorder1);
        registerPanel.setMinimumSize(new Dimension(133, 120));
        registerPanel.setPreferredSize(new Dimension(133, 120));
        registerPanel.setRequestFocusEnabled(true);
        registerPanel.setLayout(gridBagLayout2);
        iAddressLabel.setForeground(new Color(204, 204, 255));
        iAddressLabel.setText("I  address:");
        aAddressLabel.setForeground(new Color(204, 204, 255));
        aAddressLabel.setText("A address:");
        bAddressLabel.setForeground(new Color(204, 204, 255));
        bAddressLabel.setText("B address:");
        errorPanel.setBackground(new Color(0, 70, 0));
        errorPanel.setBorder(titledBorder2);
        errorPanel.setLayout(gridBagLayout3);
        aLabel.setEnabled(true);
        aLabel.setForeground(Color.yellow);
        aLabel.setText("A");
        bLabel.setEnabled(true);
        bLabel.setForeground(Color.yellow);
        bLabel.setText("B");
        logicPanel.setBackground(new Color(0, 70, 0));
        logicPanel.setBorder(titledBorder3);
        logicPanel.setMinimumSize(new Dimension(100, 120));
        logicPanel.setPreferredSize(new Dimension(100, 120));
        logicPanel.setLayout(gridBagLayout4);
        overflowLabel.setEnabled(true);
        overflowLabel.setForeground(Color.yellow);
        overflowLabel.setText("OVFLO");
        eqLabel.setEnabled(true);
        eqLabel.setForeground(Color.yellow);
        eqLabel.setText("B = A");
        neLabel.setEnabled(true);
        neLabel.setForeground(Color.yellow);
        neLabel.setText("B # A");
        gtLabel.setEnabled(true);
        gtLabel.setForeground(Color.yellow);
        gtLabel.setText("B > A");
        ltLabel.setEnabled(true);
        ltLabel.setForeground(Color.yellow);
        ltLabel.setText("B < A");
        checkPanel.setLayout(gridBagLayout5);
        checkPanel.setBackground(new Color(0, 70, 0));
        checkPanel.setBorder(titledBorder4);
        processLabel.setEnabled(true);
        processLabel.setForeground(Color.yellow);
        processLabel.setText("Process");
        ioLabel.setEnabled(true);
        ioLabel.setForeground(Color.yellow);
        ioLabel.setText("I/O");
        switchPanel.setLayout(gridBagLayout6);
        aCheckBox.setBorderPainted(false);
        aCheckBox.setHorizontalAlignment(SwingConstants.LEADING);
        aCheckBox.setHorizontalTextPosition(SwingConstants.LEADING);
        aCheckBox.setText("A");
        bCheckBox.setBorderPainted(false);
        bCheckBox.setHorizontalTextPosition(SwingConstants.LEADING);
        bCheckBox.setText("B");
        cCheckBox.setBorderPainted(false);
        cCheckBox.setHorizontalTextPosition(SwingConstants.LEADING);
        cCheckBox.setText("C");
        dCheckBox.setBorderPainted(false);
        dCheckBox.setHorizontalTextPosition(SwingConstants.LEADING);
        dCheckBox.setText("D");
        eCheckBox.setBorderPainted(false);
        eCheckBox.setHorizontalTextPosition(SwingConstants.LEADING);
        eCheckBox.setText("E");
        fCheckBox.setBorderPainted(false);
        fCheckBox.setHorizontalTextPosition(SwingConstants.LEADING);
        fCheckBox.setText("F");
        gCheckBox.setBorderPainted(false);
        gCheckBox.setHorizontalTextPosition(SwingConstants.LEADING);
        gCheckBox.setText("G");
        displayPanel.setBackground(new Color(0, 70, 0));
        iAddressText.setForeground(Color.yellow);
        iAddressText.setMinimumSize(new Dimension(40, 16));
        iAddressText.setPreferredSize(new Dimension(40, 16));
        iAddressText.setHorizontalAlignment(SwingConstants.TRAILING);
        iAddressText.setText("00000");
        iAddressText.setForeground(Color.yellow);
        aAddressText.setForeground(Color.yellow);
        aAddressText.setMinimumSize(new Dimension(40, 16));
        aAddressText.setPreferredSize(new Dimension(40, 16));
        aAddressText.setHorizontalAlignment(SwingConstants.TRAILING);
        aAddressText.setText("00000");
        bAddressText.setForeground(Color.yellow);
        bAddressText.setMinimumSize(new Dimension(40, 16));
        bAddressText.setPreferredSize(new Dimension(40, 16));
        bAddressText.setHorizontalAlignment(SwingConstants.TRAILING);
        bAddressText.setText("00000");
        switchPanel.setBorder(border8);
		
        this.getContentPane().add(buttonPanel, BorderLayout.NORTH);
        buttonPanel.add(updateButton,
                        new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.WEST,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 15, 5, 5), 0, 0));
        buttonPanel.add(autoCheckBox,
                        new GridBagConstraints(1, 0, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.EAST,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 0, 5, 15), 0, 0));
        this.getContentPane().add(displayPanel, BorderLayout.CENTER);
        displayPanel.add(registerPanel,
                         new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 5, 0, 0),
                                                0, 0));
        registerPanel.add(iAddressLabel,
                          new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 5, 0, 0), 0, 0));
        registerPanel.add(aAddressLabel,
                          new GridBagConstraints(0, 1, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(5, 5, 0, 0), 0, 0));
        registerPanel.add(bAddressLabel,
                          new GridBagConstraints(0, 2, 1, 1, 0.0, 0.0,
                                                 GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(5, 5, 5, 0), 0, 0));
        displayPanel.add(errorPanel,
                         new GridBagConstraints(0, 1, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 5, 15, 0), 0, 0));
        errorPanel.add(aLabel,
                        new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.EAST,
                                               GridBagConstraints.NONE,
                                               new Insets(0, 5, 5, 0), 0, 0));
        errorPanel.add(bLabel,
                        new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.EAST,
                                               GridBagConstraints.NONE,
                                               new Insets(0, 20, 5, 0), 0, 0));
        displayPanel.add(logicPanel,
                         new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.NORTH,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 15, 0, 5),
                                                0, 0));
        logicPanel.add(overflowLabel,
                       new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.CENTER,
                                              GridBagConstraints.NONE,
                                              new Insets(0, 5, 0, 15), 0, 0));
        logicPanel.add(eqLabel,
                       new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.CENTER,
                                              GridBagConstraints.NONE,
                                              new Insets(0, 0, 0, 5), 0, 0));
        logicPanel.add(neLabel,
                       new GridBagConstraints(1, 1, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.CENTER,
                                              GridBagConstraints.NONE,
                                              new Insets(5, 0, 0, 5), 0, 0));
        logicPanel.add(gtLabel,
                       new GridBagConstraints(1, 2, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.CENTER,
                                              GridBagConstraints.NONE,
                                              new Insets(5, 0, 0, 5), 0, 0));
        logicPanel.add(ltLabel,
                       new GridBagConstraints(1, 3, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.CENTER,
                                              GridBagConstraints.NONE,
                                              new Insets(5, 0, 5, 5),
                                              0, 0));
        displayPanel.add(checkPanel,
                         new GridBagConstraints(1, 1, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 15, 15, 5), 0, 0));
        checkPanel.add(processLabel,
                       new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.WEST,
                                              GridBagConstraints.NONE,
                                              new Insets(0, 5, 5, 0), 0, 0));
        checkPanel.add(ioLabel,
                       new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                              GridBagConstraints.EAST,
                                              GridBagConstraints.NONE,
                                              new Insets(0, 15, 5, 5), 0, 0));
		
        this.getContentPane().add(switchPanel, BorderLayout.SOUTH);
        switchPanel.add(aCheckBox,
                        new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 5, 0), 0, 0));
        switchPanel.add(bCheckBox,
                        new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 5, 0), 0, 0));
        switchPanel.add(cCheckBox,
                        new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 5, 0), 0, 0));
        switchPanel.add(dCheckBox,
                        new GridBagConstraints(3, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 5, 0), 0, 0));
        switchPanel.add(eCheckBox,
                        new GridBagConstraints(4, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 5, 0), 0, 0));
        switchPanel.add(fCheckBox,
                        new GridBagConstraints(5, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 5, 0), 0, 0));
        switchPanel.add(gCheckBox,
                        new GridBagConstraints(6, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER,
                                               GridBagConstraints.NONE,
                                               new Insets(5, 5, 5, 5), 0, 0));
        registerPanel.add(iAddressText,
                          new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0
                                                 , GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(0, 5, 0, 5), 0, 0));
        registerPanel.add(aAddressText,
                          new GridBagConstraints(1, 1, 1, 1, 0.0, 0.0
                                                 , GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(5, 5, 0, 5), 0, 0));
        registerPanel.add(bAddressText,
                          new GridBagConstraints(1, 2, 1, 1, 0.0, 0.0
                                                 , GridBagConstraints.EAST,
                                                 GridBagConstraints.NONE,
                                                 new Insets(5, 5, 5, 5), 0, 0));
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
            iAddressText.setEnabled(false);
            aAddressText.setEnabled(false);
            bAddressText.setEnabled(false);
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
    public void actionPerformed(ActionEvent event)
    {
        update();
    }

    private String formatAddress(String text)
    {
        StringBuilder buffer = new StringBuilder("00000");
        buffer.replace(5-text.length(), 5, text);
        return buffer.toString();
    }

    private void update()
    {
        synchronized(Simulator.class) 
		{
            Simulator.execute("e is,as,bs,aserr,bserr,prchk,iochk," + "ovf,equ,uneq,high,low," + "ssa,ssb,ssc,ssd,sse,ssf,ssg");
            int i;
            String text;

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            iAddressText.setText(formatAddress(text.substring(i)));

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            aAddressText.setText(formatAddress(text.substring(i)));

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            bAddressText.setText(formatAddress(text.substring(i)));

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            aLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            bLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            processLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            ioLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            overflowLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            eqLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            neLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            gtLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            ltLabel.setEnabled(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            aCheckBox.setSelected(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            bCheckBox.setSelected(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            cCheckBox.setSelected(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            dCheckBox.setSelected(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            eCheckBox.setSelected(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            fCheckBox.setSelected(text.charAt(i) == '1');

            text = Simulator.output();
            if (text == null) return;
            i = text.indexOf("\t") + 1;
            gCheckBox.setSelected(text.charAt(i) == '1');
        }

        iAddressText.setEnabled(true);
        aAddressText.setEnabled(true);
        bAddressText.setEnabled(true);
    }

    void enableSenseSwitches()
    {
        if (!enabled) 
		{
            aCheckBox.setEnabled(true);
            bCheckBox.setEnabled(true);
            cCheckBox.setEnabled(true);
            dCheckBox.setEnabled(true);
            eCheckBox.setEnabled(true);
            fCheckBox.setEnabled(true);
            gCheckBox.setEnabled(true);

            enabled = true;
        }
    }

    void disableSenseSwitches()
    {
        if (enabled) 
		{
            aCheckBox.setEnabled(false);
            bCheckBox.setEnabled(false);
            cCheckBox.setEnabled(false);
            dCheckBox.setEnabled(false);
            eCheckBox.setEnabled(false);
            fCheckBox.setEnabled(false);
            gCheckBox.setEnabled(false);

            enabled = false;
        }
    }

	@Override
    public void stateChanged(ChangeEvent event)
    {
        JCheckBox ss = (JCheckBox) event.getSource();
        String state = ss.isSelected() ? " 1" : " 0";

        synchronized(Simulator.class) 
		{
            String command = "d ss" + ss.getActionCommand() + state;
            Simulator.execute(command);
        }
    }

	void savePreferences()
	{
		try
		{
			Preferences userPrefs = Preferences.userRoot();

			userPrefs.put("consoleFrameLocation", this.getLocation().toString());
			userPrefs.put("consoleFrameSize", this.getSize().toString());

			userPrefs.sync();
			userPrefs.flush();
		}
		catch(BackingStoreException ex) 
		{
			Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
		}
	}
}
