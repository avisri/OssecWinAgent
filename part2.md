 
ying Ossec HIDS via Active Directory Part 2 - Automating the 
Windows Agent Configuration 
In the first part of this series we went over getting a large number 
of agents to the Ossec Server from an easy to setup list of machines 
via script and getting the client.keys file ready.  Then we went ahead 
and installed the MAKEMSI package and all of it's requisites.  After a 
little break, here we are again to go over the next part... automating 
the windows agent installation. 

There's been a void for some time in the Ossec world - no pre-designed 
Windows deployment tools.  Many people have been left with the option 
of either figuring this out themselves or sneaker-netting all around 
the company and installing and configuring the agents one at a time. 
One at a time was just not an option for me with a few hundred agents 
to install, so I figured it out - with some help.  Now that the work 
has been done I'm trying to help fill that void so that other admins 
might be able to get this done and move on to the next project more 
quickly. 

Our next step is to setup some scripts that will need to handle some 
key tasks for us to automate the install. 

We need this script to: 
             a: determine where the Ossec Agent is installed 
             b: get the key for the machine we are deploying to and 
generate it's ossec.keys file 
             c: configure the Ossec Agent to connect to our Server and 
             d: restart the Ossec service on our client PC so that it 
starts reporting 

We might also want the script to perform some checks throughout the 
process and let our users know if the install failed so that they can 
let us know. 

Here is the setup script for 32-bit machines (text shrunken to 
preserve formatting).  You should keep the names of the script files 
as noted unless you are very familiar with MAKEMSI and can do the 
editing needed to the MSI build scripts. 

ossec_distribute_keys.cmd 


<*Begin copy here*> 


@ECHO OFF 

::***************************************** 
::* SET YOUR OSSEC SERVER IP ADDRESS * 
::***************************************** 
SET OSSECSERVER=***Ossec Server IP here*** 

::******************************************************************************************************* 
::* DEFINE OSSECPATH VARIABLE AS SET BY THE Ossec HIDS INSTALLATION IN 
THE WINDOWS REGISTRY * 
::******************************************************************************************************* 
FOR /f "tokens=1-2,*" %%i in ('reg query HKEY_LOCAL_MACHINE\SOFTWARE 
\ossec 
^| find "Install_Dir"') do SET OSSECPATH=%%k 
IF "%OSSECPATH:~-1%"==" " SET OSSECPATH=%OSSECPATH:~0,-1% 

::********************************************************************************************* 
::* VERIFY THAT OSSEC INSTALLED SUCCESSFULLY BEFORE PROCEEDING TO 
CONFIGURATION * 
::********************************************************************************************* 
IF DEFINED OSSECPATH (ECHO Ossec installation found at %OSSECPATH%. 
Continuing with configuration.) 
IF NOT DEFINED OSSECPATH GOTO EXIT_ON_ERROR 

::**************************************** 
::* CHECK FOR MASTER CLIENT KEYFILE * 
::**************************************** 
 IF EXIST "%CD%\ossec.keys" ECHO Client keyfile index found - Getting 
security configuration information. 
IF NOT EXIST "%CD%\ossec.keys" GOTO MASTER_KEYFILE_NOT_FOUND 

::******************************************* 
::* ENABLE DELAYED VARIABLE EXPANSION * 
::******************************************* 
@ECHO OFF > "%OSSECPATH%\client.keys" & SETLOCAL 
ENABLEDELAYEDEXPANSION 

::******************************************************************************************************** 
::* FIND COMPUTERNAME IN  MASTER KEYFILE THEN GENERATE SPECIFIC AGENT 
KEYFILE IN OSSECPATH * 
::******************************************************************************************************** 
findstr /I /C:"%COMPUTERNAME%" ossec.keys > "%OSSECPATH%\client.keys" 

::*********************************************************************** 
::* CONFIGURE ossec.conf FILE BEFORE RESTARTING OSSEC HIDS SERVICE * 
::*********************************************************************** 
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

::************************************** 
::* Restart Ossec Service and begin monitoring * 
::************************************** 
NET STOP OSSECSVC 
NET START OSSECSVC 

::************************************************************************************** 
::* NOTIFY USERS/TECHS THAT INSTALLATION AND CONFIGURATION WAS 
SUCCESSFUL * 
::************************************************************************************** 
MSG * Ossec HIDS installation and configuration completed 
successfully. Click OK to exit 

::*********************************************************************** 
::* DELETE SENSITIVE FILES ONCE INSTALL IS COMPLETE AND VERIFIED * 
::*********************************************************************** 
DEL "%OSSECPATH%\ossec.keys" 
DEL "%OSSECPATH%\ossec_distribute_keys.cmd" 
EXIT 

::********************************************************* 
::* NOTIFY USERS/TECHS IF OSSEC INSTALLATION FAILED * 
::********************************************************* 
:EXIT_ON_ERROR 
MSG * Ossec installation Failed.  Please contact support for 
assistance. 
EXIT 

::*********************************************************** 
::* NOTIFY USERS/TECHS IF MASTER KEYFILE IS NOT FOUND * 
::*********************************************************** 
:MASTER_KEYFILE_NOT_FOUND 
MSG * Client keyfile not found - Manual security configuration 
required.  Please contact support for assistance. 
EXIT 

<*End copy here*> 

And here is the script for x64 machines 

ossec_distribute_keys_x64.cmd 

<*Begin copy below here*> 

@ECHO OFF 


::********************************************** 
::* SET YOUR OSSEC SERVER IP ADDRESS HERE * 
::********************************************** 
SET OSSECSERVER=***Ossec Server IP here*** 


::******************************************************************************************************* 
::* DEFINE OSSECPATH VARIABLE AS SET BY THE Ossec HIDS INSTALLATION IN 
THE WINDOWS REGISTRY * 
::******************************************************************************************************* 
SETLOCAL ENABLEDELAYEDEXPANSION 
FOR /f "tokens=1-2,*" %%i in ('reg query HKEY_LOCAL_MACHINE\SOFTWARE 
\Wow6432Node\ossec 
^| find "Install_Dir"') do SET OSSECPATH=%%k 
IF "!OSSECPATH:~-1!"==" " SET OSSECPATH="!OSSECPATH:~0,-1!" 


::********************************************************************************************* 
::* VERIFY THAT OSSEC INSTALLED SUCCESSFULLY BEFORE PROCEEDING TO 
CONFIGURATION * 
::********************************************************************************************* 
IF DEFINED OSSECPATH (ECHO Ossec installation found at !OSSECPATH!. 
Continuing with configuration.) 
IF NOT DEFINED OSSECPATH GOTO EXIT_ON_ERROR 


::**************************************** 
::* CHECK FOR MASTER CLIENT KEYFILE * 
::**************************************** 
IF EXIST "%CD%\ossec.keys" ECHO Client keyfile index found - Getting 
security configuration information. 
IF NOT EXIST "%CD%\ossec.keys" GOTO MASTER_KEYFILE_NOT_FOUND 


::******************************************* 
::* ENABLE DELAYED VARIABLE EXPANSION * 
::******************************************* 
@ECHO OFF > %OSSECPATH%\ossec.keys & SETLOCAL ENABLEDELAYEDEXPANSION 


::******************************************************************************************************** 
::* FIND COMPUTERNAME IN  MASTER KEYFILE THEN GENERATE SPECIFIC AGENT 
KEYFILE IN OSSECPATH * 
::******************************************************************************************************** 
findstr /I /C:"%COMPUTERNAME%" ossec.keys > "%OSSECPATH%\client.keys" 


::*********************************************************************** 
::* CONFIGURE ossec.conf FILE BEFORE RESTARTING OSSEC HIDS SERVICE * 
::*********************************************************************** 
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


::************************************** 
::* Restart Ossec Service and begin monitoring * 
::************************************** 
NET STOP OSSECSVC 
NET START OSSECSVC 


::************************************************************************************** 
::* NOTIFY USERS/TECHS THAT INSTALLATION AND CONFIGURATION WAS 
SUCCESSFUL * 
::************************************************************************************** 
MSG * Ossec HIDS installation and configuration completed 
successfully. Click OK to EXIT 




::*********************************************************************** 
::* DELETE SENSITIVE FILES ONCE INSTALL IS COMPLETE AND VERIFIED * 
::*********************************************************************** 

DEL "%OSSECPATH%\ossec.keys" 
DEL "%OSSECPATH%\ossec_distribute_keys_x64.cmd" 
EXIT 




::********************************************************* 
::* NOTIFY USERS/TECHS IF OSSEC INSTALLATION FAILED * 
::********************************************************* 
:EXIT_ON_ERROR 
MSG * Ossec installation Failed.  Please contact support for 
assistance. 
EXIT 




::******************************************************I***** 
::* NOTIFY USERS/TECHS IF MASTER KEYFILE IS NOT FOUND * 
::*********************************************************** 
:MASTER_KEYFILE_NOT_FOUND 
MSG * Client keyfile not found - Manual security configuration 
required.  Please contact support for assistance. 
EXIT 


<*End copy here*> 


You'll need to edit the first variable to configure this to work in 
your environment. 


SET OSSECSERVER=***Ossec Server IP here*** 


This should be pretty self-explanatory.  The rest of the script should 
not need any modification.  Save these files and tuck them away for 
now...we need to get our MAKEMSI scripts ready.  These are quite a bit 
more complicated so i'll do my best to keep all of the configuration 
items on the tops of the scripts. 


The reason for separate 32-bit and 64-bit configuration files is that 
even though the installs are somewhat similar, the differences that 
exist make it very difficult to merge the code into one file and I am 
trying to keep it as simple and easy to understand as possible so that 
everyone can follow what is happening in the scripts so that if there 
is something else that you need to do in your deployment you will be 
able to make those changes with minimal time and difficulty. 


At this time you should, if you have not already, go ahead and setup a 
directory where you will place all of the files that will need.  They 
should all be kept together so that everything works as designed.  The 
directory I used is C:\MSIBuilds\ossec but of course you can put the 
files your anywhere on your dev box... as long as they are all 
together. 


The rest of the files needed to place in your MSI Build directory 
(most of which I will provide here) are as follows... 


Company.mmh 
DEPT.mmh 
ossec.keys - You should have your own by now so for security reasons I 
can't post mine. 
OSSEC.mmh 
ossec-agent-win32-version#.exe -Must be at least version 2.5 for the 
automated installation to work. 
OssecHIDS.MM 
OssecHIDS.rtf 
OssecHIDS.VER 
and 
OssecHIDSx64.MM 


You will likely want to edit the uisample.mmh file located in your 
main MAKEMSI install directory (specifically line 1088).  Set this 
value to 1 instead of 0 for installs that you want to have a progress 
bar but no user interaction. 

#define? UISAMPLE_REDUCED_UI_VALUE         0               ;;0 = 
normal, 1 = reduced UI (on install only) 

The rest of the code has been generalized so you will want to fill in 
your information in them.  Most of the code does not need to be 
edited, but if you want to customize the builds with your company 
information it will be very easy to do so.  The few things that MUST 
be changed will be very clearly defined in the next post coming 
tomorrow. 


By the end of tomorrows post you should be able to build customized 
and automated deployment MSIs for your companies and will be able to 
update them to the latest versions or setup deployments adding new 
machines in your companies in minutes instead of hours or days. 


Tomorrow in Part 3 of the series I will tie it all together and show 
you how it works.
