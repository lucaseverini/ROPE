/**
 * @title PreferencesDialog.java
 * @author Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.awt.*;
import java.awt.Dimension;
import java.awt.event.*;
import java.io.*;
import java.util.Vector;
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
    JCheckBox saveBeforeAssemblyChk;
	JCheckBox useOldConversionChk;
    JButton assemblerBrowseBtn;
    JButton simulatorBrowseBtn;
    JButton confirmBtn;
    JButton cancelBtn;
    JButton resetBtn;
 
    PreferencesDialog(Frame owner, String title)
    {
        super(owner, title, Dialog.ModalityType.DOCUMENT_MODAL);

        setMinimumSize(new Dimension(400, 210));
		this.setResizable(false);

        try 
		{
            jbInit();
			
            pack();
        }
        catch (Exception ex) 
		{
            ex.printStackTrace();
        }
		
		assemblerBrowseBtn.addActionListener(this);
        simulatorBrowseBtn.addActionListener(this);
		confirmBtn.addActionListener(this);
		cancelBtn.addActionListener(this);
		resetBtn.addActionListener(this);
		
		Preferences userPrefs = Preferences.userRoot();
		
		String path1 = "", path2 = "";
		
		if(RopeHelper.isWindows)
		{
			path1 = userPrefs.get("assemblerPath", "tools/windows/autocoder.exe");
			path2 = userPrefs.get("simulatorPath", "tools/windows/i1401.exe");
		}
		else if(RopeHelper.isMac)
		{
			path1 = userPrefs.get("assemblerPath", "tools/mac/autocoder");
			path2 = userPrefs.get("simulatorPath", "tools/mac/i1401");			
		}
		else if(RopeHelper.isUnix)
		{
			path1 = userPrefs.get("assemblerPath", "tools/linux/autocoder");
			path2 = userPrefs.get("simulatorPath", "tools/linux/i1401");			
		}
	
		assemblerPath.setText(path1);
        simulatorPath.setText(path2);
		saveBeforeAssemblyChk.setSelected(userPrefs.getBoolean("saveBeforeAssembly", false));
		useOldConversionChk.setSelected(userPrefs.getBoolean("useOldConversion", true));
     }

    private void jbInit() throws Exception
    {
		assemblerPath = new JTextField();
		simulatorPath = new JTextField();	
	
		saveBeforeAssemblyChk = new JCheckBox("Save documents before assembling");
		useOldConversionChk = new JCheckBox("Use Old Conversion option with SimH");
	
		assemblerBrowseBtn = new JButton("Select...");
		simulatorBrowseBtn = new JButton("Select...");
		confirmBtn = new JButton("Confirm");
		cancelBtn = new JButton("Cancel");
		resetBtn = new JButton("Reset...");
		
		JPanel mainPanel = new JPanel();
		JPanel assemblerPanel = new JPanel();
		JPanel simulatorPanel = new JPanel();
		JPanel checkPanel = new JPanel();
		JPanel buttonsPanel = new JPanel();

		TitledBorder assemblerBorder = new TitledBorder(BorderFactory.createLineBorder(Color.white, 1), "Assembler Path");
        TitledBorder simulatorBorder = new TitledBorder(BorderFactory.createLineBorder(Color.white, 1), "Simulator Path");
  
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

		checkPanel.setLayout(new GridBagLayout());
        checkPanel.add(saveBeforeAssemblyChk, new GridBagConstraints(0, 0, 1, 1, 1.0, 0.0,
                                               GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                               new Insets(5, 5, 5, 5), 0, 0));
        checkPanel.add(useOldConversionChk, new GridBagConstraints(0, 1, 1, 1, 1.0, 0.0,
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
                                                new Insets(5, 10, 10, 10), 0, 0));
		mainPanel.add(checkPanel, new GridBagConstraints(0, 2, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                new Insets(0, 5, 0, 5), 0, 0));
		mainPanel.add(buttonsPanel, new GridBagConstraints(0, 3, 1, 1, 1.0, 0.0,
                                                GridBagConstraints.CENTER, GridBagConstraints.HORIZONTAL,
                                                new Insets(10, 10, 5, 10), 0, 0));
		getContentPane().add(mainPanel);
    }

    private void browseAction(String title, String filePath, JTextField textField, Vector<RopeFileFilter> filters, 
																				boolean directories, boolean multiple)
    {
        RopeFileChooser chooser = new RopeFileChooser(DataOptions.directoryPath, filePath, filters, directories, multiple);
		chooser.setDialogTitle(title);
		
		if(filters != null)
		{
			chooser.setFileFilter(filters.firstElement()); 
		}
		
        chooser.choose(textField, this, multiple);
    }

    private void confirmAction()
    {
		File file = new File(assemblerPath.getText());
		if(!file.exists() || file.isDirectory())
		{
			String message = String.format("Assembler is not available: %s.\n Continue?", assemblerPath.getText());
			if (JOptionPane.showConfirmDialog(null, message , "ROPE", JOptionPane.ERROR_MESSAGE, JOptionPane.YES_NO_OPTION) == JOptionPane.NO_OPTION)
			{
				return;
			}
		}
		
		file = new File(simulatorPath.getText());
		if(!file.exists() || file.isDirectory())
		{
			String message = String.format("Simulator is not available: %s.\n Continue?", simulatorPath.getText());
			if (JOptionPane.showConfirmDialog(null, message , "ROPE", JOptionPane.ERROR_MESSAGE, JOptionPane.YES_NO_OPTION) == JOptionPane.NO_OPTION)
			{
				return;
			}
		}
				
		try
		{
			Preferences userPrefs = Preferences.userRoot();
			
			userPrefs.put("assemblerPath", assemblerPath.getText());
			userPrefs.put("simulatorPath", simulatorPath.getText());
			userPrefs.putBoolean("saveBeforeAssembly", saveBeforeAssemblyChk.isSelected());
			userPrefs.putBoolean("useOldConversion", useOldConversionChk.isSelected());
			
			userPrefs.sync();
			userPrefs.flush();
		}
		catch(BackingStoreException ex)
		{
			Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
		}
	
		AssemblerOptions.saveBeforeAssembly = saveBeforeAssemblyChk.isSelected();
		SimulatorOptions.useOldConversion = useOldConversionChk.isSelected();
		AssemblerOptions.assemblerPath = assemblerPath.getText();
		SimulatorOptions.simulatorPath = simulatorPath.getText();

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
			int result = JOptionPane.showConfirmDialog(null, message, "ROPE", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
			if (result == JOptionPane.OK_OPTION)
			{
				Preferences userPrefs = Preferences.userRoot();
				userPrefs.clear();
				userPrefs.sync();
				userPrefs.flush();

				Assembler.kill();
				Simulator.kill();
			
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
 			Vector<RopeFileFilter> filters = null;
			if(RopeHelper.isWindows)
			{
				filters = new Vector<RopeFileFilter>();
				filters.add(new RopeFileFilter( new String[] {".exe",}, "Windows executable (*.exe)"));
				// filters.add(new RopeFileFilter( new String[] {".bat",}, "Windows batch (*.bat)"));
			}
            browseAction("Assembler selection", AssemblerOptions.assemblerPath, assemblerPath, filters, false, false);
        }
        else if (source == simulatorBrowseBtn) 
		{
			Vector<RopeFileFilter> filters = null;
			if(RopeHelper.isWindows)
			{
				filters = new Vector<RopeFileFilter>();
				filters.add(new RopeFileFilter( new String[] {".exe",}, "Windows executable (*.exe)"));
				// filters.add(new RopeFileFilter( new String[] {".bat",}, "Windows batch (*.bat)"));
			}
            browseAction("Simulator selection", SimulatorOptions.simulatorPath, simulatorPath, filters, false, false);
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
