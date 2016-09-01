#!/bin/bash
#
# This bash script creates the property file containing the properties used
# in the java program ROPE.
# On Windows, it requires MinGW (http://www.mingw.org) or compatible
# unix shell environment.
#
# By Luca Severini (lucaseverini@mac.com)
#
# Version date: July 23 2016
#

PROPERTIES_FILE_PATH=./src/rope1401/Resources/BuildTimeStrings.properties

if [[ "$(uname)" = "Darwin" ]] ; then
	PLATFORM="Mac OS X"
elif [[ "$(uname)" = "Linux" ]] ; then
        PLATFORM="Linux"
else
	PLATFORM="Windows"
fi

# Get Java/JDK version
JDK_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')" ("$PLATFORM")"

# Get current date and time
BUILD_TIME=`date +"%h-%d-%Y %H:%M"`

BUILD_NUMBER=`git rev-list HEAD --count`

echo "# This file is created anew at every build of ROPE" > $PROPERTIES_FILE_PATH
echo "# Created on "`date` >> $PROPERTIES_FILE_PATH
echo >> $PROPERTIES_FILE_PATH
echo BuildNumber=$BUILD_NUMBER >> $PROPERTIES_FILE_PATH
echo CompilerJDK=$JDK_VERSION >> $PROPERTIES_FILE_PATH
echo CompilerTime=$BUILD_TIME >> $PROPERTIES_FILE_PATH
