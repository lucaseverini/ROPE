/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak
 * @version 2.0
 */

package rope1401;

import java.util.Vector;

class AssemblerOptions
{
    static final int BOOT_NONE  = 0;
    static final int BOOT_IBM   = 1;
    static final int BOOT_VAN_1 = 2;
    static final int BOOT_VAN_2 = 3;

    static final int SIZE_1400  =  1400;
    static final int SIZE_2000  =  2000;
    static final int SIZE_4000  =  4000;
    static final int SIZE_8000  =  8000;
    static final int SIZE_12000 = 12000;
    static final int SIZE_16000 = 14000;

    static final String ENCODING_SIMH  = "S";
    static final String ENCODING_A     = "A";
    static final String ENCODING_H     = "H";
    static final String ENCODING_PRINT = "?";

    static String assemblerPath;
    static String encodingChoice = ENCODING_SIMH;
    static String sourcePath;
    static String listingPath;
    static String objectPath;
    static String macroPath;
    static String tapePath;
    static String diagnosticPath;
    static String pageLength = "60";
    static Vector<String> command;

    static boolean boot       = true;
    static boolean encoding   = true;
    static boolean listing    = true;
    static boolean object     = true;
    static boolean macro      = true;
    static boolean tape       = false;
    static boolean diagnostic = false;
    static boolean codeOk     = false;
    static boolean interleave = false;
    static boolean store      = false;
    static boolean dump       = false;
    static boolean page       = false;

    static boolean trace        = false;
    static boolean traceLexer   = false;
    static boolean traceParser  = false;
    static boolean traceProcess = false;

    static boolean extras         = false;
    static boolean extrasEx       = false;
    static boolean extrasEnd      = false;
    static boolean extrasQueue    = false;
    static boolean extrasReloader = false;

    static int bootLoader = BOOT_IBM;
    static int coreSize   = SIZE_16000;
	
	static boolean saveBeforeAssembly = false;
}
