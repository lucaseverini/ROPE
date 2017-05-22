/**
 * <p>Title: PreferencesDialog.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.awt.*;
import java.awt.Dimension;
import java.awt.event.*;
import java.io.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;
import javax.swing.*;
import javax.swing.border.*;

public class PreferencesDialog extends JDialog implements ActionListener
{
	private static final long serialVersionUID = 1L;

    JTextField assemblerPath;
    JTextField simulatorPath;	
    JTextField macroPath;	
    JTextField sourcePath;	
	JCheckBox reopenLastEditChk;
	JCheckBox reopenLastExecChk;
	JCheckBox reopenLastPrintoutChk;
    JCheckBox saveBeforeAssemblyChk;
	JCheckBox useOldConversionChk;
	JCheckBox convertPlusToAmpersandChk;
    JButton assemblerBrowseBtn;
    JButton simulatorBrowseBtn;
    JButton macroBrowseBtn;
    JButton sourceBrowseBtn;
    JButton confirmBtn;
    JButton cancelBtn;
    JButton resetBtn;
	Preferences userPrefs = Preferences.userRoot();
 
    PreferencesDialog(Frame owner, String title)
    {
        super(owner, title, Dialog.ModalityType.DOCUMENT_MODAL);

        try 
		{
            jbInit();
			
            pack();
			
			Dimension curSize = this.getSize();
			setMinimumSize(new Dimension(400, curSize.height));
			setMaximumSize(new Dimension(1200, curSize.height));
			this.setResizable(true);
        }
        catch (Exception ex) 
		{
            ex.printStackTrace();
        }
		
		assemblerBrowseBtn.addActionListener(this);
        simulatorBrowseBtn.addActionListener(this);
        macroBrowseBtn.addActionListener(this);
		sourceBrowseBtn.addActionListener(this);
		confirmBtn.addActionListener(this);
		cancelBtn.addActionListener(this);
		resetBtn.addActionListener(this);
				
		if(RopeHelper.isWindows)
		{
			assemblerPath.setText(userPrefs.get("assemblerPath", RopeResources.getString("AutocoderWindowsPath")));
			simulatorPath.setText(userPrefs.get("simulatorPath", RopeResources.getString("SimhWindowsPath")));
		}
		else if(RopeHelper.isMac)
		{
			assemblerPath.setText(userPrefs.get("assemblerPath", RopeResources.getString("AutocoderMacPath")));
			simulatorPath.setText(userPrefs.get("simulatorPath", RopeResources.getString("SimhMacPath")));			
		}
		else if(RopeHelper.isUnix)
		{
			assemblerPath.setText(userPrefs.get("assemblerPath", RopeResources.getString("AutocoderLinuxPath")));
			simulatorPath.setText(userPrefs.get("simulatorPath", RopeResources.getString("SimhLinuxPath")));			
		}
	
		macroPath.setText(userPrefs.get("macroPath", ""));
		sourcePath.setText(userPrefs.get("sourcePath", ""));

		String var = System.getenv("ROPE_ASSEMBLER");
		if(var != null && !var.isEmpty())
		{
			assemblerPath.setText(var);
		}
		
		var = System.getenv("ROPE_SIMULATOR");
		if(var != null && !var.isEmpty())
		{
			simulatorPath.setText(var);
		}

		var = System.getenv("ROPE_MACROS_DIR");
		if(var != null && !var.isEmpty())
		{
			macroPath.setText(var);
		}
		
		var = System.getenv("ROPE_SOURCES_DIR");
		if(var != null && !var.isEmpty())
		{
			sourcePath.setText(var);
		}
	
		reopenLastEditChk.setSelected(userPrefs.getBoolean("reopenLastSource", true));
		saveBeforeAssemblyChk.setSelected(userPrefs.getBoolean("saveBeforeAssembly", false));
		useOldConversionChk.setSelected(userPrefs.getBoolean("useOldConversion", true));
		convertPlusToAmpersandChk.setSelected(userPrefs.getBoolean("convertPlusToAmpersand", true));
     }

    private void jbInit() throws Exception
    {
		assemblerPath = new JTextField();
		simulatorPath = new JTextField();	
		macroPath = new JTextField();	
		sourcePath = new JTextField();	
		
		// Implementare anche la Riapertura della Memory Window...
	
		reopenLastEditChk = new JCheckBox("Reopen last editing file");
		reopenLastExecChk = new JCheckBox("Reopen last exec list");
		reopenLastPrintoutChk = new JCheckBox("Reopen last printout");
		saveBeforeAssemblyChk = new JCheckBox("Save source file before assembling");
		useOldConversionChk = new JCheckBox("Use Old Conversion option with SimH");
		convertPlusToAmpersandChk = new JCheckBox("Convert automatically all '+' in source file to '&' for Autocoder compatibility");
	
		assemblerBrowseBtn = new JButton("Select...");
		simulatorBrowseBtn = new JButton("Select...");
		macroBrowseBtn = new JButton("Select...");
		sourceBrowseBtn = new JButton("Select...");
		confirmBtn = new JButton("Confirm");
		cancelBtn = new JButton("Cancel");
		resetBtn = new JButton("Reset Preferences...");
		
		JPanel mainPanel = new JPanel();
		JPanel assemblerPanel = new JPanel();
		JPanel simulatorPanel = new JPanel();
		JPanel macroPanel = new JPanel();
		JPanel sourcePanel = new JPanel();
		JPanel checkPanel = new JPanel();
		JPanel buttonsPanel = new JPanel();

		TitledBorder assemblerBorder = new TitledBorder(BorderFactory.createLineBorder(Color.white, 1), "Assembler Path");
        TitledBorder simulatorBorder = new TitledBorder(BorderFactory.createLineBorder(Color.white, 1), "Simulator Path");
        TitledBorder macroBorder = new TitledBorder(BorderFactory.createLineBorder(Color.white, 1), "Macros Path");
        TitledBorder sourceBorder = new TitledBorder(BorderFactory.createLineBorder(Color.white, 1), "Sources Path");
  
        assemblerPanel.setBorder(assemblerBorder);
        assemblerPanel.setLayout(new GridBagLayout());
        assemblerPanel.add(assemblerPath, new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                                  GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                  new Insets(0, 5, 5, 0), 400, 0));
        assemblerPanel.add(assemblerBrowseBtn, new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                  GridBagConstraints.CENTER, GridBagConstraints.NONE,
                                                  new Insets(0, 5, 5, 5), 0, 0));
        
		simulatorPanel.setBorder(simulatorBorder);
        simulatorPanel.setLayout(new GridBagLayout());
        simulatorPanel.add(simulatorPath, new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                                  GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                  new Insets(0, 5, 5, 0), 400, 0));
        simulatorPanel.add(simulatorBrowseBtn, new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                  GridBagConstraints.CENTER, GridBagConstraints.NONE,
                                                  new Insets(0, 5, 5, 5), 0, 0));

        macroPanel.setBorder(macroBorder);
        macroPanel.setLayout(new GridBagLayout());
        macroPanel.add(macroPath, new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                                  GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                  new Insets(0, 5, 5, 0), 400, 0));
        macroPanel.add(macroBrowseBtn, new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                  GridBagConstraints.CENTER, GridBagConstraints.NONE,
                                                  new Insets(0, 5, 5, 5), 0, 0));

        sourcePanel.setBorder(sourceBorder);
        sourcePanel.setLayout(new GridBagLayout());
        sourcePanel.add(sourcePath, new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                                  GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                  new Insets(0, 5, 5, 0), 400, 0));
        sourcePanel.add(sourceBrowseBtn, new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                  GridBagConstraints.CENTER, GridBagConstraints.NONE,
                                                  new Insets(0, 5, 5, 5), 0, 0));

		checkPanel.setLayout(new GridBagLayout());
        checkPanel.add(reopenLastEditChk, new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 5, 5), 0, 0));
        checkPanel.add(reopenLastExecChk, new GridBagConstraints(0, 1, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                               new Insets(0, 5, 5, 5), 0, 0));
        checkPanel.add(reopenLastPrintoutChk, new GridBagConstraints(0, 2, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                               new Insets(0, 5, 5, 5), 0, 0));
        checkPanel.add(saveBeforeAssemblyChk, new GridBagConstraints(0, 3, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                               new Insets(0, 5, 5, 5), 0, 0));
        checkPanel.add(useOldConversionChk, new GridBagConstraints(0, 4, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                               new Insets(0, 5, 5, 5), 0, 0));
        checkPanel.add(convertPlusToAmpersandChk, new GridBagConstraints(0, 5, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                               new Insets(0, 5, 5, 5), 0, 0));

		buttonsPanel.setLayout(new GridBagLayout());
        buttonsPanel.add(confirmBtn, new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.NONE,
                                               new Insets(0, 0, 15, 10), 0, 0));
        buttonsPanel.add(cancelBtn, new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.NONE,
                                               new Insets(0, 10, 15, 0), 0, 0));
        buttonsPanel.add(resetBtn, new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.NONE,
                                               new Insets(0, 100, 15, 0), 0, 0));

		mainPanel.setLayout(new GridBagLayout());
        mainPanel.add(assemblerPanel, new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                new Insets(10, 10, 5, 10), 0, 0));
        mainPanel.add(simulatorPanel, new GridBagConstraints(0, 1, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 10, 5, 10), 0, 0));
        mainPanel.add(macroPanel, new GridBagConstraints(0, 2, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 10, 5, 10), 0, 0));
        mainPanel.add(sourcePanel, new GridBagConstraints(0, 3, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 10, 10, 10), 0, 0));
		mainPanel.add(checkPanel, new GridBagConstraints(0, 4, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                new Insets(0, 5, 0, 5), 0, 0));
		mainPanel.add(buttonsPanel, new GridBagConstraints(0, 5, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                new Insets(15, 10, 5, 10), 0, 0));
		getContentPane().add(mainPanel);	
	}

    private void browseAction(String title, String filePath, JTextField textField, ArrayList<RopeFileFilter> filters, 
																				boolean directories, boolean multiple)
    {
        RopeFileChooser chooser = new RopeFileChooser(DataOptions.directoryPath, filePath, filters, directories, multiple);
		chooser.setDialogTitle(title);
		
		if(filters != null)
		{
			chooser.setFileFilter(filters.get(0)); 
		}
		
        chooser.open(this, textField, multiple);
    }

    private void confirmAction()
    {
		File file = new File(assemblerPath.getText());
		if(!file.exists() || file.isDirectory())
		{
			String message = String.format("The Assembler executable is not available: %s.\n Continue?", assemblerPath.getText());
			if (JOptionPane.showConfirmDialog(null, message , "ROPE", JOptionPane.YES_NO_OPTION, JOptionPane.ERROR_MESSAGE) == JOptionPane.NO_OPTION)
			{
				return;
			}
		}
		
		file = new File(simulatorPath.getText());
		if(!file.exists() || file.isDirectory())
		{
			String message = String.format("The Simulator excutable is not available: %s.\n Continue?", simulatorPath.getText());
			if (JOptionPane.showConfirmDialog(null, message , "ROPE", JOptionPane.YES_NO_OPTION, JOptionPane.ERROR_MESSAGE) == JOptionPane.NO_OPTION)
			{
				return;
			}
		}

		file = new File(macroPath.getText());
		if(!file.exists() || !file.isDirectory())
		{
			String message = String.format("The Macros folder is not available: %s.\n Continue?", macroPath.getText());
			if (JOptionPane.showConfirmDialog(null, message , "ROPE", JOptionPane.YES_NO_OPTION, JOptionPane.ERROR_MESSAGE) == JOptionPane.NO_OPTION)
			{
				return;
			}
		}

		file = new File(sourcePath.getText());
		if(!file.exists() || !file.isDirectory())
		{
			String message = String.format("The Sources folder is not available: %s.\n Continue?", sourcePath.getText());
			if (JOptionPane.showConfirmDialog(null, message , "ROPE", JOptionPane.YES_NO_OPTION, JOptionPane.ERROR_MESSAGE) == JOptionPane.NO_OPTION)
			{
				return;
			}
		}

		try
		{
			Preferences userPrefs = Preferences.userRoot();
			
			userPrefs.put("assemblerPath", assemblerPath.getText());
			userPrefs.put("simulatorPath", simulatorPath.getText());
			userPrefs.put("macroPath", macroPath.getText());
			userPrefs.put("sourcePath", sourcePath.getText());
			
			userPrefs.putBoolean("reopenLastSource", reopenLastEditChk.isSelected());
			userPrefs.putBoolean("saveBeforeAssembly", saveBeforeAssemblyChk.isSelected());
			userPrefs.putBoolean("useOldConversion", useOldConversionChk.isSelected());
			userPrefs.putBoolean("convertPlusToAmpersand", convertPlusToAmpersandChk.isSelected());
			
			userPrefs.sync();
			userPrefs.flush();
		}
		catch(BackingStoreException ex)
		{
			Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
		}
	
		ROPE.mainFrame.reopenLastSource = reopenLastEditChk.isSelected();
		AssemblerOptions.saveBeforeAssembly = saveBeforeAssemblyChk.isSelected();
		SimulatorOptions.useOldConversion = useOldConversionChk.isSelected();
		AssemblerOptions.assemblerPath = assemblerPath.getText();
		SimulatorOptions.simulatorPath = simulatorPath.getText();
		AssemblerOptions.macroPath = macroPath.getText();

		String var = System.getenv("ROPE_ASSEMBLER");
		if(var == null || var.isEmpty())
		{
			AssemblerOptions.assemblerPath = assemblerPath.getText();
		}
		
		var = System.getenv("ROPE_SIMULATOR");
		if(var == null || var.isEmpty())
		{
			SimulatorOptions.simulatorPath = simulatorPath.getText();
		}

		var = System.getenv("ROPE_MACROS_DIR");
		if(var == null || var.isEmpty())
		{
			AssemblerOptions.macroPath = macroPath.getText();
		}

		dispose();
    }

    private void cancelAction()
    {
		dispose();
    }
	
	private void resetAction()
	{
		try
		{
			String message = "Do you want to reset all Rope preferences to default value and quit immediately?";
			int result = JOptionPane.showConfirmDialog(null, message, "ROPE", JOptionPane.OK_CANCEL_OPTION, JOptionPane.WARNING_MESSAGE);
			if (result == JOptionPane.OK_OPTION)
			{
				Preferences userPrefs = Preferences.userRoot();
				userPrefs.clear();
				userPrefs.sync();
				userPrefs.flush();

				Assembler.kill();
				Simulator.kill();
			
				ROPE.mainFrame.savePreferencesOnExit = false;
				
				System.exit(0);
			}
		}
		catch(BackingStoreException ex)
		{
			Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
		}
	}

	@Override
    public void actionPerformed(ActionEvent event)
    {
        Object source = event.getSource();

        if (source == assemblerBrowseBtn) 
		{
 			ArrayList<RopeFileFilter> filters = null;
			if(RopeHelper.isWindows)
			{
				filters = new ArrayList<RopeFileFilter>();
				filters.add(new RopeFileFilter( new String[] {".exe",}, "Windows executable (*.exe)"));
				// filters.add(new RopeFileFilter( new String[] {".bat",}, "Windows batch (*.bat)"));
			}
            browseAction("Assembler executable selection", assemblerPath.getText(), assemblerPath, filters, false, false);
        }
        else if (source == simulatorBrowseBtn) 
		{
			ArrayList<RopeFileFilter> filters = null;
			if(RopeHelper.isWindows)
			{
				filters = new ArrayList<RopeFileFilter>();
				filters.add(new RopeFileFilter( new String[] {".exe",}, "Windows executable (*.exe)"));
				// filters.add(new RopeFileFilter( new String[] {".bat",}, "Windows batch (*.bat)"));
			}
            browseAction("Simulator executable selection", simulatorPath.getText(), simulatorPath, filters, false, false);
        }
        else if (source == macroBrowseBtn) 
		{
			ArrayList<RopeFileFilter> filters = null;
			if(RopeHelper.isWindows)
			{
				filters = new ArrayList<RopeFileFilter>();
				// filters.add(new RopeFileFilter( new String[] {".exe",}, "Windows executable (*.exe)"));
				// filters.add(new RopeFileFilter( new String[] {".bat",}, "Windows batch (*.bat)"));
			}
            browseAction("Macros folder selection", macroPath.getText(), macroPath, filters, true, false);
        }
		else if (source == sourceBrowseBtn) 
		{
			ArrayList<RopeFileFilter> filters = null;
			if(RopeHelper.isWindows)
			{
				filters = new ArrayList<RopeFileFilter>();
				// filters.add(new RopeFileFilter( new String[] {".exe",}, "Windows executable (*.exe)"));
				// filters.add(new RopeFileFilter( new String[] {".bat",}, "Windows batch (*.bat)"));
			}
            browseAction("Sources folder selection", sourcePath.getText(), sourcePath, filters, true, false);
		}
        else if (source == confirmBtn) 
		{
            confirmAction();
        }
        else if (source == cancelBtn) 
		{
            cancelAction();
        }
        else if (source == resetBtn) 
		{
            resetAction();
        }
   }

	@Override
    protected void processWindowEvent(WindowEvent event)
    {
        super.processWindowEvent(event);

        if (event.getID() == WindowEvent.WINDOW_CLOSING) 
		{
            cancelAction();
        }
    }
}
