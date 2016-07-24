/**
 * <p>Title: AssemblerOptions.java</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: NASA Ames Research Center</p>
 * @author Ronald Mak & Luca Severini <lucaseverini@mac.com>
 * @version 2.0
 */

package rope1401;

import java.util.ArrayList;

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
    static final int SIZE_16000 = 16000;

    static final String ENCODING_SIMH  = "S";
    static final String ENCODING_A     = "A";
    static final String ENCODING_H     = "H";
    static final String ENCODING_PRINT = "?";

    static String assemblerPath;
    static String deckEncodingChoice = ENCODING_SIMH;
    static String tapeEncodingChoice = ENCODING_A;
    static String sourcePath;
    static String listingPath;
    static String objectPath;
	static String macros = "mac";
    static String macroPath;
    static String tapePath;
    static String diagnosticPath;
    static String pageLength = "60";
    static ArrayList<String> command;

    static boolean boot							= true;
    static boolean deckEncoding					= true;
    static boolean tapeEncoding					= true;
    static boolean listing						= true;
    static boolean object						= true;
    static boolean tape							= true;
 	static boolean convertTapeForTapeSimulator	= false;
    static boolean macro						= true;
    static boolean diagnostic					= false;
    static boolean codeOk						= false;
    static boolean interleave					= false;
    static boolean store						= false;
    static boolean dump							= false;
    static boolean page							= false;
								
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
