;----------------------------------------------------------------------------
;    MODULE NAME:   OssecHIDS.MM
;
;        $Author:   USER "Phil Shramko"  $
;      $Revision:   1.00  $
;          $Date:   07 Oct 2010 14:13:58  $
;
; DESCRIPTION
; ~~~~~~~~~~~
; This is a repackage of the Ossec HIDS Windows installer
; Automated for deployment.
;----------------------------------------------------------------------------

;---------------------------------------------------------------------
;-         Define path to Ossec Install executable                   -
;-                         EXAMPLE:                                  -
;- define+ OSSECINSTEXE C:\MSIBuilds\ossec\ossec-agent-win32-2.5.exe -
;---------------------------------------------------------------------
#define+ OSSECINSTEXE C:\PATH\TO\YOUR\INSTALL.EXE

;--- Include MAKEMSI support ------
#define VER_FILENAME.VER  OssecHIDS.Ver 
#include "OSSEC.MMH"


;--- Want to debug (not common) ---------------------------------------------
;#debug on
;#Option DebugLevel=^NONE, +OpSys^

; Installer script to wrap an existing NSIS installer with a Windows InstallerMSI
; designed to run as silently as possible and to handle any existing NSISinstaller

;--- Define default location where file should install and add files --------
<$DirectoryTree Key="INSTALLDIR" DIR="[ProgramFilesFolder]\ossec-agent" CHANGE="\" PrimaryFolder="Y">     ;;Tree starts at "ProgramFilesFolder"
<$Files "*keys*" DestDir="INSTALLDIR">

; Installer script to wrap an existing NSIS installer with a Windows Installer MSI
; designed to run as silently as possible and to handle any existing NSIS installer

#define? WRAPINST_SEQ_INSTALL StartServices-RegisterUser
#define? WRAPINST_SEQ_UNINSTALL InstallInitialize-StopServices
#define? WRAPINST_CONDITION_INSTALL <$CONDITION_INSTALL_ONLY> ;;You could add repair etc.
#define? WRAPINST_CONDITION_UNINSTALL <$CONDITION_UNINSTALL_ONLY> ;;Make this "" if you don't want to ever uninstall(rare?)
#define? WRAPINST_BASETYPE_INSTALL Deferred ;;Base CA attributes (install). You may need to add "SYSTEM".
#define? WRAPINST_BASETYPE_UNINSTALL Deferred ;;Base CA attributes (uninstall). You may need to add "SYSTEM".
#define? WRAPINST_HIDE_WRAPPED_PRODUCT Y ;;Don't show in ARP as wrapping product will uninstall
#define? WRAPINST_(UN)INSTALL_VALIDATION Y
#define? WRAPINST_INSTALL_VALIDATION <$WRAPINST_(UN)INSTALL_VALIDATION>
#define? WRAPINST_UNINSTALL_VALIDATION <$WRAPINST_(UN)INSTALL_VALIDATION>
#define? WRAPINST_UNINSTALL_VALIDATION_WAIT 5 ;;Some uninstalls are ASYNC with task returning before complete! If non-blank and non-zero then how many seconds do we wish to allow for the uninstall task to complete?

;----------------------------------------------------------------------------
;--- Install Nullsoft NSIS based Installer ----------------------------------
;----------------------------------------------------------------------------
#(
    <$File source="ossec-agent-win32-2.5.exe" Destination="c:\MSIBUILDS\OSSEC\">
    <$WrapInstall

        ;--- INSTALL --------------------------------------------------------
         EXE="<$OSSECINSTEXE>"
         Args='/S'

		;--- UNINSTALL ------------------------------------------------------
		 ;NSIS uninstaller will handle this already so we don't need it but it gives the MSI the location of correct uninstall executable
		 UNINSTALLEXE="[INSTALLDIR]uninstall.exe"
    >
#)

;----------------------------------------------------------------------------
;--- Configure Ossec HIDS agent after install -------------------------------
;----------------------------------------------------------------------------
#(
	<$ExeCa
		;--- Configure agent and add key ------------------------------------
		 EXE="[INSTALLDIR]ossec_distribute_keys.cmd"
		 WorkDir="INSTALLDIR"
		 SEQ="InstallFinalize-"
		 Type="immediate ASync AnyRc"
		 CONDITION="<$CONDITION_INSTALL_ONLY>"
	>
#)