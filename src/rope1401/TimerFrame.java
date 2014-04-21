/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import java.text.DecimalFormat;
import java.awt.*;
import java.awt.event.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;
import javax.swing.*;
import javax.swing.event.*;

public class TimerFrame extends ChildFrame implements ActionListener, CommandWindow
{
	private static final long serialVersionUID = 1L;
	
    BorderLayout borderLayout1 = new BorderLayout();
    GridBagLayout gridBagLayout1 = new GridBagLayout();
    GridBagLayout gridBagLayout2 = new GridBagLayout();

    JPanel controlPanel = new JPanel();
    JPanel timePanel = new JPanel();

    JLabel speedLabel = new JLabel();
    JTextField speedText = new JTextField();
    JLabel gHzLabel = new JLabel();
    JLabel speedMessage = new JLabel();
    JLabel simulatorTimeLabel = new JLabel();
    JLabel simulatorTimeText = new JLabel();
    JLabel wallTimeLabel = new JLabel();
    JLabel wallTimeText = new JLabel();
    JLabel estimatedTimeLabel = new JLabel();
    JLabel estimatedTimeText = new JLabel();

    JButton speedButton = new JButton();
    JButton resetButton = new JButton();

    private static final float SPEED_1401 = 0.000087f;      /* GHz */
    private static final float SIMULATOR_FUDGE = 10.0f;
    private static final float SIMULATOR_FACTOR = 1.0f / (SPEED_1401 * SIMULATOR_FUDGE);
    private static final float DEFAULT_HOST_SPEED = 2.40f;  /* GHz */

	private RopeFrame parent;
    private float hostSpeed;
    private float speedFactor;
    private boolean settingSpeed;

    public TimerFrame(RopeFrame myParent)
    {
        super(myParent);

		parent = myParent;

        // Implement a smarter way to set the initial frame position and size
		this.setLocation(1430, 890);
        this.setSize(480, 210);
	
		try 
		{
            jbInit();
        }
        catch (Exception exception) 
		{
            exception.printStackTrace();
        }
 
        this.addInternalFrameListener(new InternalFrameAdapter()
        {
			@Override
            public void internalFrameClosed(InternalFrameEvent event)
            {
 				savePreferences();
				
				mainFrame.removeTimerFrame();
            }
        });

        hostSpeed = DEFAULT_HOST_SPEED;
        speedFactor = hostSpeed*SIMULATOR_FACTOR;
        speedText.setText(Float.toString(hostSpeed));
        settingSpeed = false;

        speedButton.addActionListener(this);
        resetButton.addActionListener(this);

        parent.resetTimers();
		
        execute();
    }

    private void jbInit() throws Exception
    {
        this.setClosable(true);
        this.setIconifiable(true);
        this.setResizable(true);
        this.setTitle("TIMERS");

        speedLabel.setText("Host machine speed:");
        speedText.setMinimumSize(new Dimension(50, 20));
        speedText.setPreferredSize(new Dimension(50, 20));
        speedText.setEditable(false);
        gHzLabel.setText("GHz");
        speedButton.setText("Set speed");
        speedButton.setMinimumSize(new Dimension(100, 20));
        speedButton.setPreferredSize(new Dimension(100, 20));
        speedMessage.setFont(new java.awt.Font("Tahoma", Font.BOLD, 11));
        speedMessage.setText(" ");

        wallTimeLabel.setText("Elapsed wallclock time:");
        simulatorTimeLabel.setText("Elapsed simulator time:");
        estimatedTimeLabel.setText("Estimated 1401 time:");

        resetButton.setText("Reset timers");

        controlPanel.setLayout(gridBagLayout1);
        controlPanel.add(speedLabel,
                         new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));
        controlPanel.add(speedText,
                         new GridBagConstraints(1, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.
                                                NONE,
                                                new Insets(5, 5, 0, 0), 0, 0));
        controlPanel.add(gHzLabel,
                         new GridBagConstraints(2, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.WEST,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 0), 5, 5));
        controlPanel.add(speedButton,
                         new GridBagConstraints(3, 0, 1, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.NONE,
                                                new Insets(5, 5, 0, 5), 0, 0));
        controlPanel.add(speedMessage,
                         new GridBagConstraints(0, 1, 5, 1, 0.0, 0.0,
                                                GridBagConstraints.CENTER,
                                                GridBagConstraints.HORIZONTAL,
                                                new Insets(5, 5, 5, 5), 0, 0));

        timePanel.setLayout(gridBagLayout2);
        timePanel.add(wallTimeLabel,
                      new GridBagConstraints(0, 0, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        timePanel.add(wallTimeText,
                      new GridBagConstraints(1, 0, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));
        timePanel.add(simulatorTimeLabel,
                      new GridBagConstraints(0, 1, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        timePanel.add(simulatorTimeText,
                      new GridBagConstraints(1, 1, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));
        timePanel.add(estimatedTimeLabel,
                      new GridBagConstraints(0, 2, 1, 1, 0.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.NONE,
                                             new Insets(5, 5, 0, 0), 0, 0));
        timePanel.add(estimatedTimeText,
                      new GridBagConstraints(1, 2, 1, 1, 1.0, 0.0,
                                             GridBagConstraints.WEST,
                                             GridBagConstraints.HORIZONTAL,
                                             new Insets(5, 5, 0, 5), 0, 0));
        timePanel.add(resetButton,
                      new GridBagConstraints(0, 3, 2, 1, 0.0, 0.0,
                                             GridBagConstraints.CENTER,
                                             GridBagConstraints.NONE,
                                             new Insets(15, 0, 5, 0), 0, 0));

        getContentPane().setLayout(borderLayout1);
        this.getContentPane().add(controlPanel, java.awt.BorderLayout.NORTH);
        this.getContentPane().add(timePanel, java.awt.BorderLayout.CENTER);
    }

    private static final long SECOND = 1000;
    private static final long MINUTE = 60*SECOND;
    private static final long HOUR   = 60*MINUTE;
    private static final long DAY    = 24*HOUR;

    private static final DecimalFormat NN  = new DecimalFormat("00");
    private static final DecimalFormat NNN = new DecimalFormat("000");

    private String formatTime(long time)
    {
        long days = time/DAY;
        time -= days*DAY;

        long hours = time/HOUR;
        time -= hours*HOUR;

        long minutes = time/MINUTE;
        time -= minutes*MINUTE;

        long seconds = time/SECOND;
        long millis  = time - seconds*SECOND;

        StringBuffer buffer = new StringBuffer(64);
        buffer.append(NN.format(days)).append(" days ")
              .append(NN.format(hours)).append(" hours ")
              .append(NN.format(minutes)).append(" minutes ")
              .append(NN.format(seconds)).append(".")
              .append(NNN.format(millis)).append(" seconds");

        return buffer.toString();
    }

	@Override
    public void execute()
    {
        wallTimeText.setText(formatTime(Simulator.elapsedWallTime()));

        long elapsedSimulatorTime = Simulator.elapsedSimulatorTime();
        simulatorTimeText.setText(formatTime(elapsedSimulatorTime));
        estimatedTimeText.setText(formatTime((long) (speedFactor*elapsedSimulatorTime)));
    }

	@Override
    public void lock()
    {
    }

	@Override
    public void unlock()
    {
    }

    private void setSpeed()
    {
        boolean success = true;

        do 
		{
            try 
			{
                hostSpeed = Float.parseFloat(speedText.getText());
                speedFactor = hostSpeed*SIMULATOR_FACTOR;
                speedMessage.setText(" ");
                success = true;
            }
            catch (NumberFormatException ex) 
			{
                speedMessage.setText("Invalid speed format. Use: nn.nn");
            }
        } 
		while (!success);
    }

	@Override
    public void actionPerformed(ActionEvent event)
    {
        Object button = event.getSource();

        if (button == speedButton) 
		{
            if (settingSpeed) 
			{
                setSpeed();
                speedText.setEditable(false);
                speedButton.setText("Set speed");
                settingSpeed = false;
            }
            else 
			{
                speedText.setEditable(true);
                speedButton.setText("OK");
                settingSpeed = true;
            }
        }
        else if (button == resetButton) 
		{
            parent.resetTimers();
            execute();
        }
    }

	void savePreferences()
	{
		try
		{
			Preferences userPrefs = Preferences.userRoot();

			userPrefs.put("timerFrameLocation", this.getLocation().toString());
			userPrefs.put("timerFrameSize", this.getSize().toString());

			userPrefs.sync();
			userPrefs.flush();
		}
		catch(BackingStoreException ex) 
		{
			Logger.getLogger(RopeFrame.class.getName()).log(Level.SEVERE, null, ex);
		}
	}
}
