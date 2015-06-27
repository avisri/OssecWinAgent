@ECHO OFF

::************************************
::* SET YOUR OSSEC SERVER IP ADDRESS *
::************************************
SET OSSECSERVER=***Ossec Server IP here***

::*******************************************************************************************
::* DEFINE OSSECPATH VARIABLE AS SET BY THE Ossec HIDS INSTALLATION IN THE WINDOWS REGISTRY *
::*******************************************************************************************
FOR /f "tokens=1-2,*" %%i in ('reg query HKEY_LOCAL_MACHINE\SOFTWARE\ossec
^| find "Install_Dir"') do SET OSSECPATH=%%k
IF "%OSSECPATH:~-1%"==" " SET OSSECPATH=%OSSECPATH:~0,-1% 

::*******************************************************************************
::* VERIFY THAT OSSEC INSTALLED SUCCESSFULLY BEFORE PROCEEDING TO CONFIGURATION *
::*******************************************************************************
IF DEFINED OSSECPATH (ECHO Ossec installation found at %OSSECPATH%. Continuing with configuration.)
IF NOT DEFINED OSSECPATH GOTO EXIT_ON_ERROR

::***********************************
::* CHECK FOR MASTER CLIENT KEYFILE *
::***********************************
 IF EXIST "%CD%\ossec.keys" ECHO Client keyfile index found - Getting security configuration information.
IF NOT EXIST "%CD%\ossec.keys" GOTO MASTER_KEYFILE_NOT_FOUND

::*************************************
::* ENABLE DELAYED VARIABLE EXPANSION *
::*************************************
@ECHO OFF > "%OSSECPATH%\client.keys" & SETLOCAL ENABLEDELAYEDEXPANSION

::******************************************************************************************
::* FIND COMPUTERNAME IN  MASTER KEYFILE THEN GENERATE SPECIFIC AGENT KEYFILE IN OSSECPATH *
::******************************************************************************************
findstr /I /C:"%COMPUTERNAME%" ossec.keys > "%OSSECPATH%\client.keys"

::******************************************************************
::* CONFIGURE ossec.conf FILE BEFORE RESTARTING OSSEC HIDS SERVICE *
::******************************************************************
SET LINE1=^<ossec_config^>
SET LINE2=  ^<client^>
SET LINE3=   ^<server-ip^>%OSSECSERVER%^</server-ip^>
SET LINE4=  ^</client^>
SET LINE5=^</ossec_config^>

ECHO !LINE1!>>"%OSSECPATH%\ossec.conf"
ECHO !LINE2!>>"%OSSECPATH%\ossec.conf"
ECHO !LINE3!>>"%OSSECPATH%\ossec.conf"
ECHO !LINE4!>>"%OSSECPATH%\ossec.conf"
ECHO !LINE5!>>"%OSSECPATH%\ossec.conf"

::**********************************************
::* Restart Ossec Service and begin monitoring *
::**********************************************
NET STOP OSSECSVC
NET START OSSECSVC

::*************************************************************************
::* NOTIFY USERS/TECHS THAT INSTALLATION AND CONFIGURATION WAS SUCCESSFUL *
::*************************************************************************
MSG * Ossec HIDS installation and configuration completed successfully. Click OK to exit
DEL "%OSSECPATH%\ossec.keys"
DEL "%OSSECPATH%\ossec_distribute_keys.cmd"
EXIT


::***************************************************
::* NOTIFY USERS/TECHS IF OSSEC INSTALLATION FAILED *
::***************************************************
:EXIT_ON_ERROR
MSG * Ossec installation Failed.  Please contact support for assistance.
EXIT


::*****************************************************
::* NOTIFY USERS/TECHS IF MASTER KEYFILE IS NOT FOUND *
::*****************************************************
:MASTER_KEYFILE_NOT_FOUND
MSG * Client keyfile not found - Manual security configuration required.  Please contact support for assistance.
EXIT