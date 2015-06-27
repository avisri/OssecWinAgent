OK, here we go, now we are getting to where all this reading, 
planning, building and coding pay off. 




Today we are going to go through the final steps of building our 
OssecHIDS Deployment Package.  I'll do my best to explain how 
everything works along the way as well as how to customize the scripts 
to make everything look really clean and professional. 




Now that's out of the way so let's just jump right into it.  The first 
of the MSI creation scripts is Company.mmh.  It is alot of code and 
really should not be changed until you are very comfortable with the 
MAKEMSI package.  It works with all of the variables that we setup in 
the files coming later and is needed.  It can be customized, but 
again, I would not change things here until you know exatly what 
everything does in MAKEMSI. 







Company.mmh 




<*Begin copy here*> 




;---------------------------------------------------------------------------- 
; 
;    MODULE NAME:   COMPANY.MMH 
; 
;        $Author:   USER "Phil Shramko"  $ 
;      $Revision:   1.00  $ 
;          $Date:   07 Oct 2010 14:13:58  $ 
;      COPYRIGHT:   (C)opyright Dennis Bareis, Australia, 2003 
;                   All rights reserved. 
; 
; Note that this header is one of the few intended to be "replaced". 
; It has however been written so physical altering or deleting of this 
; file should not be required. 
; 
; There are many options, some are: 
; 
;       1. Ignore this file altogether, create your own front end with 
;          different filenames so as not to clash. 
; 
;       2. Modify this file BUT if you do so you should move it to a 
;          different directory so as not be be deleted ALONG WITH YOUR 
;          CHANGES on a MAKEMSI uninstall! 
; 
;       3. Create a new header that overrides some things but still 
includes 
;          this one. 
; 
; Let me know of any issues. 
;---------------------------------------------------------------------------- 




;---------------------------------------------------------------------------- 
;--- Define Version number of this install support 
-------------------------- 
;---------------------------------------------------------------------------- 
#ifdef COMPANY_VERSION 
   ;--- Die, already included 
----------------------------------------------- 
   #error ^You have already included "<?InputComponent>"^ 
#endif 
#define  COMPANY_VERSION   1.0 




;---------------------------------------------------------------------------- 
;--- Create our own namespace 
----------------------------------------------- 
;---------------------------------------------------------------------------- 
#NextId 
#NextId LOCK "COMPANY.MMH" 




;---------------------------------------------------------------------------- 
;--- Does this actually look like Dennis' Development box? 
------------------ 
;---------------------------------------------------------------------------- 
#if ['<??*PRJ_INST_PATH?>' <> ''] 
   ;--- My company.mmh etc NOT JUST A SAMPLE! 
------------------------------- 
   #define IsMyBox 
#endif 




;---------------------------------------------------------------------------- 
;--- Define some company Information 
---------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_NAME Palm Coast Data 

;---------------------------------------------------------------------------- 
;--- License Options 
-------------------------------------------------------- 
;---------------------------------------------------------------------------- 
;###[ListedInDoco-LookForLicenceFileOptions]### 
#define? COMPANY_LICENCE_SPELLING_C_OR_S  s           ;;Spelling - 
Licence OR License? 
#define? COMPANY_LOOK_FOR_LICENCE_FILE    Y           ;;Y/N - Look for 
file or just use if supplied? 
#define? COMPANY_PREPROCESS_LICENCE_FILE  N           ;;Y/N - Does the 
file contain macros or decisions etc? 
#define? COMPANY_LICENCE_EXTN             .licen< 
$COMPANY_LICENCE_SPELLING_C_OR_S>e.rtf  ;;US spelling? 
#define? COMPANY_LICENCE_NAME             <?InputFile $$FilePart:w>< 
$COMPANY_LICENCE_EXTN> 
;###[ListedInDoco-LookForLicenceFileOptions]### 
#define? UISAMPLE_LICENCE_SPELLING_C_OR_S < 
$COMPANY_LICENCE_SPELLING_C_OR_S> 

;---------------------------------------------------------------------------- 
;--- Modify product info keywords for .VER  file 
---------------------------- 
;---------------------------------------------------------------------------- 
#ifndef VER_PRODINFO_VALID_KEYWORD_LIST_EXTRA 
   ;--- Extra "prodinfo" KeyWords 
------------------------------------------- 
   #define? COMPANY_PRODINFO_VALID_KEYWORD_LIST_EXTRA 
   #( "" 
       #define VER_PRODINFO_VALID_KEYWORD_LIST_EXTRA 
       ,UpgradeCodes  ;;A list of EXTRA upgrade codes 
       ,MsiName       ;;Short name of MSI (no extension) 
       ,Licence       ;;If not supplied then disabled, if starts with 
"@" then file name follows. 

       ;--- If supplied must begin with a comma 
----------------------------- 
       <$COMPANY_PRODINFO_VALID_KEYWORD_LIST_EXTRA> 
   #) 

   ;--- Define any "prodinfo" default values 
-------------------------------- 
   #define? ProdInfo.Default.UpgradeCodes 
   #define? ProdInfo.Default.Licence 
   #define? ProdInfo.Default.MsiName        <$ProdInfo.ProductName>< 
$ProductVersion> 
#endif 




;---------------------------------------------------------------------------- 
;--- Add Supported platform details to HTML report's summary 
---------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_HTMLSUMM_AFTER_SUPPORTED_PLATFORMS 
#define? HTMLSUMM_SUPPORTED_PLATFORMS_TT  \ 
         <$HTMLRPT_TT 'This lists platforms we support this product 
on.'> 
#define? COMPANY_HTMLSUMM_SUPPORTED_PLATFORMS_BEFORE_LIST 
#if ['<$DEPT_SUPPORT_WEB_URL $$IsBlank>' = 'Y'] 
    #define? COMPANY_HTMLSUMM_SUPPORTED_PLATFORMS_AFTER_LIST 
#elseif 
    #( 
        #define? COMPANY_HTMLSUMM_SUPPORTED_PLATFORMS_AFTER_LIST 
        Support can be obtained from 
        "<a href='<$DEPT_SUPPORT_WEB_URL>' title='click to visit the 
support website' target='_blank'><$DEPT_SUPPORT_WEB_URL></a>". 
    #) 
#endif 
#(  '' 
   #define? HTMLSUMM_AFTER_BUILT_AT 
   <TR<$HTMLSUMM_SUPPORTED_PLATFORMS_TT>> 
       <TD align="center"> 
           Supported<BR>Platforms 
       </TD> 
       <TD> 
          <$COMPANY_HTMLSUMM_SUPPORTED_PLATFORMS_BEFORE_LIST> 
          <$PLATFORM_MsiSupportedWhereHtml> 
          <$COMPANY_HTMLSUMM_SUPPORTED_PLATFORMS_AFTER_LIST> 
       </TD> 
   </TR> 
   <$COMPANY_HTMLSUMM_AFTER_SUPPORTED_PLATFORMS> 
#) 




;---------------------------------------------------------------------------- 
;--- Change way MSI comments  are used 
-------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_PACKAGED_BY Packaged by <$DEPT_NAME> (<$COMPANY_NAME> 
- <$DEPT_ADDRESS>). 
#( '' 
   ;--- This can be long but need CRLF for XP bug workaround 
---------------- 
   #define? COMPANY_PROPERTY_ARPCOMMENTS 
   <$ProdInfo.Productname> (<$ProductVersion>)<$CRLF> 
   was created <?CompileTime>.<$CRLF><$CRLF> 
   <$ProdInfo.Description><$CRLF> 
   <$COMPANY_PACKAGED_BY><$CRLF><$CRLF> 
   <$PLATFORM_MsiSupportedWhere> 
#) 




;---------------------------------------------------------------------------- 
;--- Load MAKEMSI support 
--------------------------------------------------- 
;---------------------------------------------------------------------------- 
#define HTMLRPT_SHOW_EMPTY_REPORTS   N       ;;Show reports for "null" 
entries! 
#NextId PUSH 
   #include "MakeMsi.MMH" 
#NextId POP 




;---------------------------------------------------------------------------------------- 
;--- Allow you to easily "mark" an MSI files as being in a specific 
mode (test maybe) --- 
;---------------------------------------------------------------------------------------- 
#define? COMPANY_MSINAME_PREFIX 
#define? COMPANY_MSINAME_SUFFIX 
#option PUSH DefineMacroReplace=YES 
    #define+ ProdInfo.MsiName <$COMPANY_MSINAME_PREFIX>< 
$ProdInfo.MsiName><$COMPANY_MSINAME_SUFFIX> 
#option POP 




;---------------------------------------------------------------------------- 
;--- Define platforms 
------------------------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_DEFINE_DEPARTMENTS_PLATFORMS 
<$COMPANY_DEFINE_DEPARTMENTS_PLATFORMS>    ;;Define them 
<$PlatformProcessing>                      ;;Thats all of them! 




;---------------------------------------------------------------------------- 
;--- Start the Package (use template) 
--------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_MSI_TEMPLATE_FILENAME <?? 
*MAKEMSI_DIR>UISAMPLE.msi  ;;Contents of "MAKEMSI_DIR" ends with a 
slash! 
#( 
   ;--- Allow user to use another method for getting template data 
---------- 
   #define? COMPANY_GET_TEMPLATE_AND_OPEN_MSI 
   <$Msi "<$ProdInfo.MsiName>.msi" Template="< 
$COMPANY_MSI_TEMPLATE_FILENAME>"> 
#) 
#define? COMPANY_IMMEDIATELY_AFTER_TEMPLATE_MSI_OPENED 
<$COMPANY_GET_TEMPLATE_AND_OPEN_MSI> 
<$COMPANY_IMMEDIATELY_AFTER_TEMPLATE_MSI_OPENED> 




;---[4Doco-OptionalResolveSourceInsertion]--- 
;---------------------------------------------------------------------------- 
;--- Add "ResolveSource" action 
--------------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_INSERT_ResolveSourceAction  N 
#if ['<$COMPANY_INSERT_ResolveSourceAction>' = 'Y'] 
    ;--- We do wish to insert the "ResolveSource" action 
-------------------- 
    #define COMPANY_RESOLVE_SOURCE_CONDITION   < 
$CONDITION_EXCEPT_UNINSTALL> 
    #( 
        #define ResolveSource           ;;Note that the SOURCE MSI 
MUST BE AVAILABLE (for example can't eneter maintenance mode if MSI 
gone...) 
        <$Table "{$#1}"> 
        #( 
            ;--- Need to do this or "SourceDir" null if UI=none or 
basic -------- 
            #ifndef @@RsSeqNumber 
                ;--- Only declare variable once 
--------------------------------- 
                dim RsSeqNumber<?NewLine> 
                #define @@RsSeqNumber 
            #endif 
            RsSeqNumber = GetSeqNumber("{$#1}", "CostInitialize- 
CostFinalize", 1) 
            <$Row 
                  Action="ResolveSource"                        ;;Set 
up the "sourceDir" property/directory 
               Condition=^< 
$COMPANY_RESOLVE_SOURCE_CONDITION>^  ;;Don't want during uninstall etc 
(may require source media, CD etc) 
               *Sequence=^RsSeqNumber^                          ;;Use 
Sequence number determined earlier 
            > 
        #) 
        <$/Table> 
    #) 
    <$ResolveSource "InstallUISequence"> 
    <$ResolveSource "InstallExecuteSequence"> 
#endif 
;---[4Doco-OptionalResolveSourceInsertion]--- 




;---------------------------------------------------------------------------------------- 
;--- Note ORCA bug has caused invalid value for security in the 
(UISAMPLE) template ----- 
;---------------------------------------------------------------------------------------- 
#define? COMPANY_SECURITY_VALUE_VBEXP PidSecurityNoRestriction  ;;VB 
expression (empty to turn off) 
#if ['<$COMPANY_SECURITY_VALUE_VBEXP>' <> ''] 
    ;--- Updating of the security "property" not disabled 
------------------- 
    <$Summary  "Security" *Value=^<$COMPANY_SECURITY_VALUE_VBEXP>^> 
#endif 




;---------------------------------------------------------------------------- 
;--- Alter or ADD common "Error" table messages 
---------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_ERROR_1335  The required cabinet file '[2]' may be 
corrupt or we could not create a file during extraction. This could 
indicate a network error, an error reading from the CD-ROM, a problem 
with this package, or perhaps a problem extracting a file (destination 
path too long?). 
#define? COMPANY_ERROR_1720  CUSTOM ACTION SCRIPT "[2]" COULDN'T START 
(OR TRAPPED DURING INITIALIZATION*). ERROR [3], [4]: [5] LINE [6], 
COLUMN [7], [8] 
#define? COMPANY_ERROR_2740  CUSTOM ACTION SCRIPT "[2]" STARTED BUT 
FAILED. ERROR [3], [4]: [5] LINE [6], COLUMN [7], [8] 
#define? COMPANY_ERROR_1721  CUSTOM ACTION "[2]" FAILED (could not 
start it). LOCATION: [3], COMMAND: [4] 
#define? COMPANY_ERROR_1722  CUSTOM ACTION "[2]" FAILED (unexpected 
return code). LOCATION: [3], COMMAND: [4] 
#define? COMPANY_ERROR_1909  Could not create Shortcut [2]. Verify 
that the destination folder exists and that you can access it. This 
can also happen if the "Target" of a shortcut doesn't exist (or not 
fully qualified) in the MSI. 
#define? COMPANY_ERROR_2103  Could not resolve path for the shell 
folder "[2]". If the MSI is being executed under the SYSTEM account 
then remember that you must have ALLUSERS=1. 
#define? COMPANY_ERROR_2705  Invalid table: "[2]" - Could not be 
linked as tree (this can occur if a directory tables "parent" 
directory is missing). 
#( 
    #define? COMPANY_ERROR_2755 
    The server process failed processing the package "[3]" (RC = [2]). 
    A return code of 3 probably indicates a problem accessing the 
drive 
    or directory (substituted drives and network drives can be 
problematic). 
    A return code of 110 probably indicates an error opening the MSI 
file 
    (this can occur if the MSI is encrypted). 
    Try moving the MSI to C:\ (make sure its not compressed or 
encrypted). 
#) 
#( 
    #define @@ErrorMsg 
    #if ['<$COMPANY_ERROR_{$#1} $$ISBLANK>' = 'N'] 
        ;--- User didn't disable this message 
------------------------------- 
        <$Row Error="{$#1}" Message=^<$COMPANY_ERROR_{$#1}>^> 
    #endif 
#) 
<$Table "Error"> 
   ;--- Current message too misleading 
-------------------------------------- 
   <$@@ErrorMsg "1335"> 

   ;--- Useful VBS Custom Action messages 
----------------------------------- 
   <$@@ErrorMsg "1720"> 
   <$@@ErrorMsg "2740"> 

   ;--- Buggy/Missing/Misleading Messages (we have seen at install 
time) --- 
   <$@@ErrorMsg "2705">         ;;ICE03 error at validation time, but 
if not validating... 

   ;--- Readable CA=EXE error messages 
-------------------------------------- 
   <$@@ErrorMsg "1721"> 
   <$@@ErrorMsg "1722"> 

   ;--- Useful when you try to install MSI in system account! 
--------------- 
   <$@@ErrorMsg "2103"> 
   <$@@ErrorMsg "2755"> 

   ;--- Shortcut related 
---------------------------------------------------- 
   <$@@ErrorMsg "1909"> 
<$/Table> 




;---------------------------------------------------------------------------- 
;--- Convert HTML to TEXT in a VB variable 
---------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_DISABLE_DESCRIPTION_Html2Text_CONVERSION 
N         ;;You'd only change as a workaround to a serious problem... 
Let me know if you need to! 
#(  '<?NewLine>' 
    #define Html2Text 

    ;--- Get the HTML in the form that can be placed between dowuble 
quotes --- 
    #RexxVar @@Html2Text = `{$HTML}` 
    #evaluate ^^ ^@@Html2Text = ReplaceString(@@Html2Text, '"', '""')^ 

    ;--- Only want to use each VB variable once... 
-------------------------- 
    #ifdef @@VBVAR_{$VBVAR} 
        #error ^We have already used the VB variable "{$VBVAR}"!^ 
    #end if 
    #define @@VBVAR_{$VBVAR} 

    ;--- Generate the VB code 
----------------------------------------------- 
    <$Vbs "HTML TO TEXT Conversion"> 
        #if ['<$COMPANY_DISABLE_DESCRIPTION_Html2Text_CONVERSION $ 
$UPPER>' = 'Y'] 
            ;--- UNUSUAL - DISABLED - WHY? (LET ME KNOW) 
-------------------- 
            dim {$VBVAR} : {$VBVAR} = "<??@@Html2Text>"     'No 
conversion done - Why not? 
        #elseif 
            ;--- Do the HTML to TEXT conversion 
----------------------------- 
            dim {$VBVAR} : {$VBVAR} = Html2Text("<??@@Html2Text>") 
            err.clear()         'Ignore any error in called routine... 
        #endif 
    <$/Vbs> 
#) 




;---------------------------------------------------------------------------- 
;--- UISAMPLE.MSI contains an invalid "Billboard" table 
--------------------- 
;---------------------------------------------------------------------------- 
<$Table "Billboard"> 
   <$TableDelete> 
<$/Table> 

;---------------------------------------------------------------------------- 
;--- UISAMPLE.MSI contains an invalid "ListView" validation 
----------------- 
;---------------------------------------------------------------------------- 
<$Table "_Validation"> 
   #( 
       <$Row 
             @Where="`Table` = 'ListView' AND `Column` = 'Value'" 
                @OK='=1' 
           Category="Formatted"      ;;Previous value = Identifier 
       > 
   #) 
<$/Table> 







;--- Always Need these tables 
----------------------------------------------- 
<$TableCreate "FeatureComponents"  DropExisting="N">   ;;Windows 
Installer will PV in MSI.DLL (in UI sequence) if missing 
<$TableCreate "File"               DropExisting="N">   ;;Windows 
Installer needs table (even if empty) 
<$TableCreate "Media"              DropExisting="N">   ;;Windows 
Installer needs table (even if empty) 

;---------------------------------------------------------------------------- 
;--- Set up some MAKEMSI tables (move eventually?) 
-------------------------- 
;---------------------------------------------------------------------------- 
<$TableCreate "<$MAKEMSI_TABLENAME_FILESOURCE>"> 
;**    [CommentBlockStart     (23 August 2008 13:08:03, Dennis) 
;** 
+---------------------------------------------------------------------- 
;**|<$Table "_Validation"> 
;**|#( 
;**|   <$Row 
;**|            Table="<$MAKEMSI_TABLENAME_FILESOURCE>" 
;**|           Column="File_" 
;**|         Nullable="N" 
;**|         KeyTable="File" 
;**|        KeyColumn="1" 
;**|         Category="Identifier" 
;**|      Description="Foreign key into the File table." 
;**|   > 
;**|#) 
;**|#( 
;**|   <$Row 
;**|            Table="<$MAKEMSI_TABLENAME_FILESOURCE>" 
;**|           Column="SourceFile" 
;**|         Nullable="N" 
;**|         Category="Text" 
;**|      Description="Full name of source file." 
;**|   > 
;**|#) 
;**|#( 
;**|   <$Row 
;**|            Table="<$MAKEMSI_TABLENAME_FILESOURCE>" 
;**|           Column="Date" 
;**|         Nullable="N" 
;**|         Category="Text" 
;**|      Description="Proposed date for the file." 
;**|   > 
;**|#) 
;**|#( 
;**|   <$Row 
;**|            Table="<$MAKEMSI_TABLENAME_FILESOURCE>" 
;**|           Column="Time" 
;**|         Nullable="N" 
;**|         Category="Text" 
;**|      Description="Proposed time for the file." 
;**|   > 
;**|#) 
;**|<$/Table> 
;** 
+---------------------------------------------------------------------- 
;**    CommentBlockEnd]       (23 August 2008 13:08:03, Dennis) 
#ifndef FILE_DISABLE_MD5_GENERATION_ALTOGETHER 
   <$TableCreate "MsiFileHash"> 
   <$Table "_Validation"> 
   #( 
       <$Row 
               Table="MsiFileHash" 
               Column="File_" 
           Nullable="N" 
           KeyTable="File" 
           KeyColumn="1" 
           Category="Identifier" 
       Description="Foreign key into the File table." 
       > 
   #) 
   #( 
       <$Row 
               Table="MsiFileHash" 
               Column="Options" 
           Nullable="N" 
           Category="Integer" 
           MinValue="0" 
           MaxValue="0" 
       Description="Reserved option (must be 0)." 
       > 
   #) 
   #( 
       #Define HashRow 
       <$Row 
               Table="MsiFileHash" 
               Column="HashPart{$#1}" 
           Nullable="N" 
           Category="DoubleInteger" 
       Description="MD5 part {$#1}/4." 
       > 
   #) 
   <$HashRow "1"> 
   <$HashRow "2"> 
   <$HashRow "3"> 
   <$HashRow "4"> 
   <$/Table> 
#endif 




;---------------------------------------------------------------------------- 
;--- Set up the "COMPLETE" feature 
------------------------------------------ 
;---------------------------------------------------------------------------- 
#define? COMPANY_WANT_COMPLETE_FEATURE  Y 
#if ['<$COMPANY_WANT_COMPLETE_FEATURE>' = 'Y'] 
   ;--- User did not disable complete feature 
------------------------------- 
   ;--[4Doco-COMPANY_WANT_COMPLETE_FEATURE]--- 
   #define? COMPANY_COMPLETE_FEATURE_TITLE 
Complete 
   #define? COMPANY_COMPLETE_FEATURE_DESCRIPTION                 The 
Complete feature 
   #define? 
COMPANY_COMPLETE_FEATURE_DIRECTORY                         ;;Must be a 
"Directory" key (or blank)! 
   #define? COMPANY_COMPLETE_FEATURE_DISPLAY 
1     ;;Expanded by default 
   #define? COMPANY_COMPLETE_FEATURE_DIRECTORY_AS_PRIMARY_FOLDER Y 
   #define? COMPANY_COMPLETE_FEATURE_INSTALL_ON_DEMAND           N 
   #if ['<$COMPANY_COMPLETE_FEATURE_INSTALL_ON_DEMAND>' = 'N'] 
       #define? COMPANY_COMPLETE_FEATURE_ATTRIBUTES 
UIDisallowAbsent 
   #elseif 
       #define? COMPANY_COMPLETE_FEATURE_ATTRIBUTES 
UIDisallowAbsent FavorSource FavorAdvertise 
   #endif 
   #ifndef  COMPANY_COMPLETE_FEATURE                            ;;Name 
of complete feature 
        ;--- Event log messages may show this but LITTLE other detail 
(make meaningful!) --- 
        #define? COMPANY_COMPLETE_FEATURE_TEMPLATE \ 
                 ALL.<$ProductVersion>.<$ProdInfo.ProductName>  ;;Will 
truncate to max length (move valuable stuff to the left...) 
        #DefineRexx '' nopack 
            ;--- Build ID that would identify product in Event log 
---------- 
            @@T = '<$COMPANY_COMPLETE_FEATURE_TEMPLATE>'; 

            ;--- Make sure it only contains valid chars for an ID 
----------- 
            <$Rexx2FixMsiId IDVAR="@@T"> 

            ;--- Make sure not longer than "Feature" table can handle 
------- 
            if  length(@@T) > <$TABLES_LNG_FEATURE_COLUMN> then 
                @@T = left(@@T, <$TABLES_LNG_FEATURE_COLUMN>); 

            ;--- Store it 
--------------------------------------------------- 
            Call MacroSet 'COMPANY_COMPLETE_FEATURE', @@T 
        #DefineRexx 
   #endif 
   ;--[4Doco-COMPANY_WANT_COMPLETE_FEATURE]--- 
   #( 
      <$Feature "<$COMPANY_COMPLETE_FEATURE>" 
               Directory_="<$COMPANY_COMPLETE_FEATURE_DIRECTORY>" 
                    Title="<$COMPANY_COMPLETE_FEATURE_TITLE>" 
              Description="<$COMPANY_COMPLETE_FEATURE_DESCRIPTION>" 
               Attributes="<$COMPANY_COMPLETE_FEATURE_ATTRIBUTES>" 
                  Display="<$COMPANY_COMPLETE_FEATURE_DISPLAY>" 
      > 
   #) 

   ;--- Do we know the "complete" directory (yet)? 
-------------------------- 
   #if  ['<$COMPANY_COMPLETE_FEATURE_DIRECTORY>' <> ''] 
        ;--- We do but do we allow its use as install location? 
------------- 
        #if  ['< 
$COMPANY_COMPLETE_FEATURE_DIRECTORY_AS_PRIMARY_FOLDER>' = 'Y'] 
            <$PrimaryFolder Key="< 
$COMPANY_COMPLETE_FEATURE_DIRECTORY>"> 
        #endif 
   #endif 
#endif 




;---------------------------------------------------------------------------- 
;--- Create standard directories 
-------------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_DEFINE_STANDARD_DIRECTORIES           Y 
#define? COMPANY_CREATE_STANDARD_DIRECTORIES_ON_DEMAND Y 
#if ['<$COMPANY_DEFINE_STANDARD_DIRECTORIES>' = 'Y'] 
    ;--- Define a macro to create the definitions while allowing user 
to individually disable them --- 
    #( 
        ;--- A "private" macro only used below 
------------------------------ 
        #define @@StdDir 

        ;--- Set a default value and check if definition allowed 
------------ 
        #define? COMPANY_DEFINE_STANDARD_DIRECTORY_{$Key}     Y 
        #if ['<$COMPANY_DEFINE_STANDARD_DIRECTORY_{$Key}>' = 'Y'] 
            ;--- We are allowed to create it 
-------------------------------- 
            <$Directory Key="{$Key}"  Parent="{$Parent}" Dir="{$Dir}" 
AsIs="Y" Conditional=^< 
$COMPANY_CREATE_STANDARD_DIRECTORIES_ON_DEMAND>^> 
        #endif 
    #) 

    ;--- User wants or is allowing these definitions 
------------------------ 
    <$@@StdDir Key="TARGETDIR"             Parent="" 
Dir="SourceDir"> 
    <$@@StdDir Key="LocalAppDataFolder"    Parent="TARGETDIR" 
Dir=".:APPLIC~1|Application Data"> 
    <$@@StdDir Key="CommonAppDataFolder"   Parent="TARGETDIR" 
Dir=".:APPLIC~1|Application Data"> 
    <$@@StdDir Key="ProgramFilesFolder"    Parent="TARGETDIR" 
Dir=".:ProgFile|Program Files"> 
    <$@@StdDir Key="ProgramFiles64Folder"  Parent="TARGETDIR" 
Dir=".:Prog64|Program Files 64"> 
    <$@@StdDir Key="WindowsFolder"         Parent="TARGETDIR" 
Dir=".:Windows"> 
    <$@@StdDir Key="CommonFilesFolder"     Parent="ProgramFilesFolder" 
Dir=".:Common"> 
    <$@@StdDir Key="CommonFiles64Folder"   Parent="ProgramFilesFolder" 
Dir=".:Comm64|Common Files 64"> 
    <$@@StdDir Key="StartupFolder"         Parent="ProgramMenuFolder" 
Dir=".:Startup"> 
    <$@@StdDir Key="AdminToolsFolder"      Parent="WindowsFolder" 
Dir=".:ADMINT~1|Admin Tools"> 
    <$@@StdDir Key="TemplateFolder"        Parent="WindowsFolder" 
Dir=".:ShellNew"> 
    <$@@StdDir Key="System16Folder"        Parent="WindowsFolder" 
Dir=".:System"> 
    <$@@StdDir Key="SystemFolder"          Parent="WindowsFolder" 
Dir=".:System32"> 
    <$@@StdDir Key="System64Folder"        Parent="WindowsFolder" 
Dir=".:System64"> 
    <$@@StdDir Key="TempFolder"            Parent="WindowsFolder" 
Dir=".:Temp"> 

    ;--- Profiles related folders 
------------------------------------------- 
    #define? COMPANY_DEFINE_PROFILE_RELATED_DIRECTORIES Y 
    #if ['<$COMPANY_DEFINE_PROFILE_RELATED_DIRECTORIES>' = 'Y'] 
        <$@@StdDir Key="ProfilesFolder" 
Parent="WindowsFolder"      Dir=".:Profiles"> 
        <$@@StdDir Key="StartMenuFolder" 
Parent="ProfilesFolder"     Dir=".:StartMen|Start Menu"> 
        <$@@StdDir Key="ProgramMenuFolder" 
Parent="StartMenuFolder"    Dir=".:Programs"> 
        <$@@StdDir Key="AppDataFolder" 
Parent="ProfilesFolder"     Dir=".:Applicat|Application Data"> 
        <$@@StdDir Key="DesktopFolder" 
Parent="ProfilesFolder"     Dir=".:Desktop"> 
        <$@@StdDir Key="FavoritesFolder" 
Parent="ProfilesFolder"     Dir=".:Favorite|Favorites"> 
        <$@@StdDir Key="NetHoodFolder" 
Parent="ProfilesFolder"     Dir=".:NetHood"> 
        <$@@StdDir Key="PersonalFolder" 
Parent="ProfilesFolder"     Dir=".:Personal"> 
        <$@@StdDir Key="PrintHoodFolder" 
Parent="ProfilesFolder"     Dir=".:PrintHoo|PrintHood"> 
        <$@@StdDir Key="RecentFolder" 
Parent="ProfilesFolder"     Dir=".:Recent"> 
        <$@@StdDir Key="SendToFolder" 
Parent="ProfilesFolder"     Dir=".:SendTo"> 
    #endif 

    ;--- Other folders 
------------------------------------------------------ 
    #define? COMPANY_DEFINE_OTHER_DIRECTORIES Y 
    #if ['<$COMPANY_DEFINE_OTHER_DIRECTORIES>' = 'Y'] 
        <$@@StdDir Key="MyPicturesFolder" 
Parent="TARGETDIR"          Dir=".:MYPICT~1|My Pictures"> 
        <$@@StdDir Key="FontsFolder" 
Parent="WindowsFolder"      Dir=".:Fonts"> 
    #endif 
#endif 




;[SetUpgradeGuid] 
;---------------------------------------------------------------------------- 
;--- Set MSI guids 
---------------------------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_UPGRADE_CODE_QUALIFIER              ;;Allow user 
scheme for having "sets" of upgrade codes 
#if ['<$COMPANY_UPGRADE_CODE_QUALIFIER>' = ''] 
    ;--- Not part of a set (or at least using standard name) 
---------------- 
    #define @@UPGRADE_CODE_NAME UpgradeCode 
#elseif 
    ;--- Upgrade code name qualified by name of a "set" 
--------------------- 
    #option PUSH DefineMacroReplace=YES 
    #define @@UPGRADE_CODE_NAME UpgradeCode.< 
$COMPANY_UPGRADE_CODE_QUALIFIER> 
    #option POP 

    ;--- Cludge so it can easily be referred to 
----------------------------- 
    #define VBSRET.GUID.UpgradeCode <$VBSRET.GUID. 
[@@UPGRADE_CODE_NAME]> 
#endif 
#define  UpgradeCodeValue <$VBSRET.GUID.UpgradeCode>          ;;Info 
returned from VBSCRIPT pass1 
#define? COMPANY_UPGRADECODE_HOOK_AFTER_SETTING               ;;Allow 
you to do something (perhaps validate value) 
#( '<?NewLine>' 
   #define? COMPANY_SET_PROPERTY_UPGRADECODE 
   dim UpgradeCode                                    ;;Need a 
VBSCRIPT variable 
   <$Guid '<$@@UPGRADE_CODE_NAME>' VB="UpgradeCode">  ;;Want same GUID 
every time! 
   <$Property "UpgradeCode"   *Value="UpgradeCode">   ;;Use GUID 
"calculated" above 
   <$COMPANY_UPGRADECODE_HOOK_AFTER_SETTING>          ;;Default is to 
do nothing (VBS variable "UpgradeCode" contains the value. 
#) 
#( '<?NewLine>' 
   #define? COMPANY_SET_PROPERTY_PRODUCTCODE 
   <$Property "ProductCode" 
*Value='GuidMake("ProductCode")'> ;;Random GUID 
#) 
#( '<?NewLine>' 
   #define? COMPANY_SET_PROPERTY_PACKAGECODE 
   <$Summary  "PackageCode" 
*Value='GuidMake("PackageCode")'> ;;Random GUID 
#) 
<$COMPANY_SET_PROPERTY_UPGRADECODE>       ;;User can override above 
macros to change behaviour... 
<$COMPANY_SET_PROPERTY_PRODUCTCODE> 
<$COMPANY_SET_PROPERTY_PACKAGECODE> 
;[SetUpgradeGuid] 




;---------------------------------------------------------------------------- 
;--- By default make PER MACHINE 
-------------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_ALLUSERS_CREATE_PROPERTY      Y    ;;Y/N 
#if ['<$COMPANY_ALLUSERS_CREATE_PROPERTY>' <> 'N'] 
    #define? COMPANY_ALLUSERS_PROPERTY         1    ;;1=Per Machine 
    <$Property "ALLUSERS"  Value="<$COMPANY_ALLUSERS_PROPERTY>"> 
#endif 




;[4Doco-COMPANY_REINSTALLMODE] 
;---------------------------------------------------------------------------- 
;--- Default to overwriting (file from package ALWAYS correct) 
-------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_REINSTALLMODE      amus      ;;Normal MSI default is 
"omus" 
#if    ['<$COMPANY_REINSTALLMODE>' <> ''] 
   ;--- User wants or allows this change (value wasn't blanked) 
------------- 
   <$Property "REINSTALLMODE"   Value=^<$COMPANY_REINSTALLMODE>^> 
#endif 
;[4Doco-COMPANY_REINSTALLMODE] 




;---------------------------------------------------------------------------- 
;--- Set Product name (allow overriding of default) 
------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_PRODUCT_NAME_PREFIX.P    ;;None for production 
#define? COMPANY_PRODUCT_NAME_PREFIX.D    ;;!!! etc = Developer 
friendy - sorts up front in ARP 
#define? COMPANY_PRODUCT_NAME_PREFIX   <$COMPANY_PRODUCT_NAME_PREFIX. 
[MMMODE]> 
#define? COMPANY_PROPERTY_PRODUCTNAME  <$COMPANY_PRODUCT_NAME_PREFIX>< 
$ProdInfo.ProductName> 
<$Property "ProductName"  Value="<$COMPANY_PROPERTY_PRODUCTNAME>"> 




;---------------------------------------------------------------------------- 
;--- Basic MSI summary items 
------------------------------------------------ 
;---------------------------------------------------------------------------- 
#define? COMPANY_SUMMARY_TITLE    <$COMPANY_PRODUCT_NAME_PREFIX>< 
$ProdInfo.ProductName> 
#define? COMPANY_SUMMARY_SUBJECT  <$ProductVersion> (created <? 
CompileTime>) 
#define? COMPANY_PACKAGE_REQUIRES_ELEVATED_PRIVLEDGES  Y 
#if ['<$COMPANY_PACKAGE_REQUIRES_ELEVATED_PRIVLEDGES $$UPPER>' <> 'N'] 
    ;--- Elevated privledges are (or may be) required 
----------------------- 
    #define? COMPANY_SUMMARY_SourceType 
msidbSumInfoSourceTypeCompressed 
#elseif 
    ;--- Elevated privledges are not required 
------------------------------- 
    #define? COMPANY_SUMMARY_SourceType 
msidbSumInfoSourceTypeCompressed or msidbSumInfoSourceTypeLUAPackage 
#endif 
;---[4Doco-COMPANY_SUMMARY_TEMPLATE]--- 
#define? COMPANY_SUMMARY_TEMPLATE Intel;1033      ;;Processor & 
Language Information 
<$Summary "TEMPLATE" Value="<$COMPANY_SUMMARY_TEMPLATE>"> 
;---[4Doco-COMPANY_SUMMARY_TEMPLATE]--- 
;---[4Doco-COMPANY_SUMMARY_SCHEMA]--- 
#define? COMPANY_SUMMARY_SCHEMA   110    ;;Minimum of Windows 
Installer v1.1 is required for this msi (a type of launch condition) 
<$Summary "MsiSchema" Value="<$COMPANY_SUMMARY_SCHEMA>"> 
;---[4Doco-COMPANY_SUMMARY_SCHEMA]--- 
<$Summary "TITLE"         VALUE="<$COMPANY_SUMMARY_TITLE>"> 
<$Summary "Subject"       VALUE="<$COMPANY_SUMMARY_SUBJECT>"> 
<$Summary "SourceType"    Value="<$COMPANY_SUMMARY_SourceType>"> 
<$Summary "CREATE_DTM"    VALUE="now()"> 
<$Summary "EDITTIME"      VALUE="now()"> 
<$Summary "LASTSAVE_DTM" *VALUE="Empty">   ;;Don't want 
<$Summary "LASTPRINTED"  *VALUE=^Empty^>   ;;Don't want 
#define? COMPANY_SET_SUMMARY_COMMENTS Y 
#if ['<$COMPANY_SET_SUMMARY_COMMENTS $$UPPER>' = 'Y'] 
    #define? COMPANY_SUMMARY_COMMENTS   <$ProdInfo.Description> 
    <$Html2Text VBVAR="VB_COMMENTS" HTML=^< 
$COMPANY_SUMMARY_COMMENTS>^> 
    <$Summary "COMMENTS"  *VALUE="VB_COMMENTS"> 
#endif 




;---------------------------------------------------------------------------- 
;--- Set AUTHOR related (allow overriding of default) 
----------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_PROPERTY_MANUFACTURER  <$DEPT_MSI_MANUFACTURER> 
#define? COMPANY_SUMMARY_AUTHOR         <$DEPT_MSI_AUTHOR> - using 
MAKEMSI 
#define? COMPANY_SUMMARY_LASTAUTHOR     <$DEPT_MSI_AUTHOR> 
<$Property "Manufacturer"   Value="<$COMPANY_PROPERTY_MANUFACTURER>"> 
<$Summary  "AUTHOR"         VALUE="<$COMPANY_SUMMARY_AUTHOR>"> 
<$Summary  "LastAuthor"     VALUE="<$COMPANY_SUMMARY_LASTAUTHOR>"> 




;---------------------------------------------------------------------------- 
;--- Set CONTACT details (allow overriding of default) 
---------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_CONTACT_NAME 
#define? COMPANY_CONTACT_NAME_PHONE 
#if ['<$COMPANY_CONTACT_NAME>' <> ''] 
   <$Property "ARPCONTACT" VALUE=^<$COMPANY_CONTACT_NAME>^> 
   #if ['<$COMPANY_CONTACT_NAME_PHONE>' <> ''] 
       <$Property "ARPHELPTELEPHONE" VALUE=^< 
$COMPANY_CONTACT_NAME_PHONE>^> 
   #endif 
#endif 




;---------------------------------------------------------------------------- 
;--- Web Links in Add/Remove programs 
--------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_ARP_URL_PUBLISHER                       < 
$DEPT_ARP_URL_PUBLISHER> 
#define? COMPANY_ARP_URL_TECHNICAL_SUPPORT               < 
$DEPT_ARP_URL_TECHNICAL_SUPPORT> 
#define? COMPANY_ARP_URL_APPLICATION_UPDATE_INFORMATION  < 
$DEPT_ARP_URL_APPLICATION_UPDATE_INFORMATION> 
#if ['<$COMPANY_ARP_URL_PUBLISHER>' <> ''] 
    ;--- "Publisher" becomes hypertext link in WINXP ARP 
-------------------- 
    <$Property "ARPURLINFOABOUT" Value="<$COMPANY_ARP_URL_PUBLISHER>"> 
#endif 
#if ['<$COMPANY_ARP_URL_TECHNICAL_SUPPORT>' <> ''] 
    ;--- "Support Information" in WINXP ARP 
--------------------------------- 
    <$Property "ARPHELPLINK" Value="< 
$COMPANY_ARP_URL_TECHNICAL_SUPPORT>"> 
#endif 
#if ['<$COMPANY_ARP_URL_APPLICATION_UPDATE_INFORMATION>' <> ''] 
    ;--- "Product Updates:" in WINXP ARP 
------------------------------------ 
    <$Property "ARPURLUPDATEINFO" Value="< 
$COMPANY_ARP_URL_APPLICATION_UPDATE_INFORMATION>"> 
#endif 




;---------------------------------------------------------------------------- 
;--- Set properties 
--------------------------------------------------------- 
;---------------------------------------------------------------------------- 
<$Property "ProductVersion" Value="<$ProductVersion>"> 
#define? COMPANY_SET_ARPCOMMENTS Y 
#if ['<$COMPANY_SET_ARPCOMMENTS $$UPPER>' = 'Y'] 
    #define? COMPANY_PROPERTY_ARPCOMMENTS    < 
$COMPANY_SUMMARY_COMMENTS> 
    <$Html2Text VBVAR="VB_ARPCOMMENTS" HTML=^< 
$COMPANY_PROPERTY_ARPCOMMENTS>^> 

    ;--- WinXP doesn't do good job of wrapping comments... 
------------------ 
    #define? COMPANY_ARPCOMMENTS_WRAP_AT_DOT Y 
    #if ['<$COMPANY_ARPCOMMENTS_WRAP_AT_DOT $$UPPER>' = 'Y'] 
        ;--- Assume dot is end of sentance, therefore good place to 
wrap ---- 
        VB_ARPCOMMENTS = replace(VB_ARPCOMMENTS, ". 
",                      "."   & vbCRLF) ;;Avoid dots in version 
numbers etc! 
        VB_ARPCOMMENTS = replace(VB_ARPCOMMENTS, vbCRLF & vbCRLF & 
vbCRLF, vbCRLF & vbCRLF) ;;If aleady had "para", above line made too 
big... 
    #endif 

    ;--- Set the property 
--------------------------------------------------- 
    <$Property "ARPCOMMENTS" *VALUE="VB_ARPCOMMENTS"> 
#endif 




;---------------------------------------------------------------------------- 
;--- Upgrade (REPLACE) and MSI we have upgrade codes for! 
------------------- 
;---------------------------------------------------------------------------- 
;[UseUpgradeCode] 
#define? COMPANY_AUTO_UNINSTALL_VIA_UPGRADE_TABLE  Y 
#if ['<$COMPANY_AUTO_UNINSTALL_VIA_UPGRADE_TABLE>' = 'Y'] 
   ;--- Look for older/newer versions of the same package (group) 
----------- 
   #define UpgradeCode_PROPERTY    UNINSTALLTHIS   ;;Use this property 
in "Upgrade" table entry 
   <$UpgradeTable "=UpgradeCode">                  ;;Use value in VB 
variable 

   ;--- Any EXTRA upgrade codes to be handled? 
------------------------------ 
   #if ['<$ProdInfo.UpgradeCodes>' <> ''] 
       <$UpgradeTable "<$ProdInfo.UpgradeCodes>"> 
   #endif 

   ;--- Install MSI AFTER complete uninstallation of older 
------------------ 
   #define? COMPANY_RemoveExistingProducts_HOOK_BEFORE_MOVING 
   #define? COMPANY_RemoveExistingProducts_HOOK_AFTER_MOVING 
   #define? COMPANY_RemoveExistingProducts_SEQ 
InstallValidate-InstallInitialize 
   #( 
        ;--- Allow easy overiding/removal of this step 
---------------------- 
        #define? COMPANY_MOVE_RemoveExistingProducts 
        <$Table "InstallExecuteSequence"> 
            ;--- Move to desired location 
----------------------------------- 
            dim RepSeq : RepSeq = 
GetSeqNumber("InstallExecuteSequence", "< 
$COMPANY_RemoveExistingProducts_SEQ>", 1) 
            <$Row Action="RemoveExistingProducts" *Sequence="RepSeq"> 
        <$/Table> 
   #) 
   <$COMPANY_RemoveExistingProducts_HOOK_BEFORE_MOVING> 
        <$COMPANY_MOVE_RemoveExistingProducts> 
   <$COMPANY_RemoveExistingProducts_HOOK_AFTER_MOVING> 
#endif 
;[UseUpgradeCode] 







;---------------------------------------------------------------------------- 
;--- Set up end of package 
-------------------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_ONEXIT_HOOK_BEFORE_ZIPPING 
#define? COMPANY_ONEXIT_HOOK_AFTER_ZIPPING 
#define? COMPANY_ONEXIT_HOOK_STILL_IN_COMPLETE_FEATURE 
#define? COMPANY_VBSCRIPT_FUNCTIONS 
#define? COMPANY_VALIDATE_NESTING       Y 
#if ['<$COMPANY_VALIDATE_NESTING>' = 'N'] 
    ;--- Turned off (Don't turn off unless theer is a reason AND if 
there is let me know!) --- 
    #define? @@COMPANY_VALIDATE_NESTING         ;;No nothing 
#elseif 
    ;--- User want or is allowing the validation (hopefully won't 
cause problems) --- 
    #define? @@COMPANY_VALIDATE_NESTING \ 
    #evaluate ^^ ^call ValidateNesting^ 
#endif 
#( '' 
   #define COMPANY_ONEXIT 

   ;--- Zip source code if wanted 
------------------------------------------- 
   <$COMPANY_ONEXIT_HOOK_BEFORE_ZIPPING> 
   <$CommonFramework-ZipSourceCode> 
   <$COMPANY_ONEXIT_HOOK_AFTER_ZIPPING> 

   ;--- A HOOK 
-------------------------------------------------------------- 
   <$COMPANY_ONEXIT_HOOK_STILL_IN_COMPLETE_FEATURE> 

   ;---------------------------------------------------------------------------- 
   ;--- Include "UISAMPLE" related changes 
------------------------------------- 
   ;---------------------------------------------------------------------------- 
   #NextId PUSH 
           #include "UiSample.MMH" 
   #NextId POP 

   ;--- Add generated DOCO to the MSI 
--------------------------------------- 
   <$@@COMPANY_ADD_GENERATED_DOCO> 

   ;--- Now finished with the "COMPLETE" feature 
---------------------------- 
   #if ['<$COMPANY_WANT_COMPLETE_FEATURE>' = 'Y'] 
       ;--- User did not disable complete feature 
--------------------------- 
       <$/Feature> 
   #endif 

   ;--- End the package 
----------------------------------------------------- 
   <$/Msi> 

   ;--- Include any user defined VBSCRIPT functions 
------------------------- 
   <$COMPANY_VBSCRIPT_FUNCTIONS> 

   ;--- PPWIZARD "05.203" onwards can validate nesting at any time 
---------- 
   <$@@COMPANY_VALIDATE_NESTING> 
#) 
#OnExit #69 <$COMPANY_ONEXIT> 




;---------------------------------------------------------------------------- 
;--- We wish to add the generated documentation to the MSI 
------------------ 
;---------------------------------------------------------------------------- 
;---[4Doco-COMPANY_ADD_GENERATED_DOCO]--- 
#if ['<$ONEXIT_GENERATE_HTML>' = 'N'] 
    ;--- We didn't create any documentation (so nothing to add!) 
------------ 
    #define? @@COMPANY_ADD_GENERATED_DOCO 
    #define+ MSI_COMPLETE_AT_END_OF_PASS     1      ;;No need for 2nd 
pass if not adding the doco! 
#elseif 
    ;--- We did generate the documentation 
---------------------------------- 
    #define? COMPANY_WANT_TO_INSTALL_DOCUMENTATION   Y 
    #if ['<$COMPANY_WANT_TO_INSTALL_DOCUMENTATION>' = 'N'] 
        ;--- We have been told not to add the documenation to the MSI 
------- 
        #define+ MSI_COMPLETE_AT_END_OF_PASS     1      ;;No need for 
2nd pass if not adding the doco! 
        #define? @@COMPANY_ADD_GENERATED_DOCO 
    #elseif 
        ;--- User wants us the add the documentation to the MSI 
------------- 
        #define? COMPANY_DOCO_BASE_DIR                c:\Program Files 
\ 
        #define? COMPANY_DOCO_ADD2_BASE_DIR           MAKEMSI Package 
Documentation\ 
        #define? COMPANY_DOCO_RELATIVE_DIR            <$COMPANY_NAME>\< 
$DEPT_NAME> 
        #define? COMPANY_HTMLRPT_DOCO_INSTALL_DIR     < 
$COMPANY_DOCO_BASE_DIR><$COMPANY_DOCO_ADD2_BASE_DIR>< 
$COMPANY_DOCO_RELATIVE_DIR> 
        #define? COMPANY_HTMLRPT_DOCO_COMPONENTS_GUID 
*             ;;Ramdom one is fine... 
        #ifndef  COMPANY_HTMLRPT_DOCO_INSTALL_DIR_KEY 
                 ;--- User didn't tell us what key to use 
------------------- 
                 #define COMPANY_HTMLRPT_DOCO_INSTALL_DIR_KEY 
MAKEMSI_DOCO 
                 #define @@CreateDocoKey 
        #endif 
        #define? COMPANY_HTMLRPT_NAME_LONG            <$MSI_HTMLNAME $ 
$FilePart:NAME>   ;;Alternative = "<$ProdInfo.ProductName>(< 
$ProductVersion>).hta" 
        #define? COMPANY_HTMLRPT_NAME_8.3             MSIRPT.HTA 
        #ifndef  COMPANY_COMPLETE_FEATURE 
            ;--- Don't have a complete feature 
------------------------------ 
            #define? COMPANY_HTMLRPT_FEATURE      ;;User will have to 
tell us! 
        #elseif 
            ;--- We know where we can add it! 
------------------------------- 
            #define? COMPANY_HTMLRPT_FEATURE      < 
$COMPANY_COMPLETE_FEATURE> 
        #endif 
        #if ['<$COMPANY_HTMLRPT_FEATURE>' = ''] 
            #error ^To add the HTML to the MSI we need to know the 
name of a feature, as{NL}you have turned off the "complete" feature 
you must supply this name in{NL}the "COMPANY_HTMLRPT_FEATURE" macro!^ 
        #endif 
        #( 
           #define? @@COMPANY_ADD_GENERATED_DOCO 

           <$HookInto "MAKEMSI_HOOK_SECOND_PASS_PROCESSING" 
After="@@AddDocumentationToTheMsi"> 
        #) 
        #( 
            #define @@AddDocumentationToTheMsi 

            ;--- Add later in case directory not yet known 
------------------- 
            #ifdef @@CreateDocoKey 
                  <$DirectoryTree Key="< 
$COMPANY_HTMLRPT_DOCO_INSTALL_DIR_KEY>" Dir="< 
$COMPANY_HTMLRPT_DOCO_INSTALL_DIR>"> 
            #endif 
            #define? FILE_HTMLRPT_INSTALLED_PER_MACHINE Y 
            #if  ['<$FILE_HTMLRPT_INSTALLED_PER_MACHINE $$UPPER>' = 
'Y'] 
                #define @@CurrentUserKeypath N 
            #elseif 
                #define @@CurrentUserKeypath Y 
            #endif 

            <$Component "<$FILE_HTMLRPT_ROWKEY>" Create="Y" 
Directory_="<$COMPANY_HTMLRPT_DOCO_INSTALL_DIR_KEY>" Feature=^< 
$COMPANY_HTMLRPT_FEATURE>^ ComponentId=^< 
$COMPANY_HTMLRPT_DOCO_COMPONENTS_GUID>^ CU="<$@@CurrentUserKeypath>"> 
               ;--- Add the generated doco 
---------------------------------- 
               #( 
                   ;--- Note that the doco has not yet actually been 
generated! --- 
                   <$File 
                       RowKey="<$FILE_HTMLRPT_ROWKEY>"    ;;Marks as 
special case 
                       Source="<$MSI_HTMLNAME>" 
                   Destination="<$COMPANY_HTMLRPT_NAME_LONG>" 
                       KeyPath="<$FILE_HTMLRPT_INSTALLED_PER_MACHINE>" 
                           8.3="< 
$COMPANY_HTMLRPT_NAME_8.3>"                ;;Must supply one! - May 
change VBS to fix up... 
                           HASH="N" 
                       Language="< 
$DEFAULT_FILE_LANG_WHEN_GETLANGUAGE_FAILS>" 
                       Version="" 
                          DOCO="N"               ;;too late for that! 
                   > 
               #) 
           <$/Component> 
           #ifndef COMPANY_DONT_UPDATE_ARPREADME 
               ;--- Update "Support Information" (readme) info 
-------------- 
               <$PropertyCa "ARPREADME"  VALUE=^file:///[!< 
$FILE_HTMLRPT_ROWKEY>]^ Seq="CostFinalize-"> 
           #endif 
        #) 
    #endif 
#endif 
;---[4Doco-COMPANY_ADD_GENERATED_DOCO]--- 




;---------------------------------------------------------------------------- 
;--- Set the Product ICON 
--------------------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_PRODUCT_ICON     MmDefaultProductIcon.ico  ;;Add- 
Remove or WI bug causes first icon in Icon table to be picked up if 
none set! 
#if ['<$COMPANY_PRODUCT_ICON>' <> ''] 
    <$Icon '<$COMPANY_PRODUCT_ICON>' Product="Y"> 
#endif 




;---------------------------------------------------------------------------- 
;--- Make sure we record details about this header 
-------------------------- 
;---------------------------------------------------------------------------- 
<$SourceFile Version="<$COMPANY_VERSION>"> 




;---------------------------------------------------------------------------- 
;--- Record some details in standard properties 
----------------------------- 
;---------------------------------------------------------------------------- 
#( '' 
    #define?   CompanyAddStampWithProperty 

    ;--- Define the default name for this property 
-------------------------- 
    #define?  COMPANY_PROPERTY_{$#1}    < 
$MAKEMSI_PROPERTY_PREFIX>{$#1} 

    ;--- If the property name is empty user doesn't want to create it 
------- 
    #if ['<$COMPANY_PROPERTY_{$#1} $$IsBlank>' = 'N'] 
        ;--- User didn't disable, so stamp with value 
----------------------- 
        <$Property "<$COMPANY_PROPERTY_{$#1}>" VALUE=^{$Value}^> 
    #endif 
#) 
#define? COMPANY_ADD_STAMP_PROPERTIES   Y 
#if ['<$COMPANY_ADD_STAMP_PROPERTIES>' <> 'N'] 
    ;--- User wants at least one of the following.... 
----------------------- 
    <$CompanyAddStampWithProperty "MakemsiVersion"     VALUE=^< 
$MAKEMSI_VERSION>^> 
    <$CompanyAddStampWithProperty "BuildComputer"      VALUE=^< 
$MAKEMSI_COMPUTERNAME>^> 
    <$CompanyAddStampWithProperty "BuildUser"          VALUE=^< 
$MAKEMSI_USERNAME> in <$MAKEMSI_USERDOMAIN>^> 
    <$CompanyAddStampWithProperty "BuildTime"          VALUE=^<? 
CompileTime>^> 
    <$CompanyAddStampWithProperty "ProcessingMode"     VALUE=^< 
$MMMODE_DESCRIPTION>^> 
    <$CompanyAddStampWithProperty "SupportedPlatforms" VALUE=^< 
$PLATFORM_MsiSupportedWhere>^> 
#endif 




;------------------------------------------------------------------------------------------- 
;--- "UserRegistrationDlg" is not optional (makes dialog inserts/ 
deletes too complicated --- 
;------------------------------------------------------------------------------------------- 
<$Table "Property"> 
   <$RowsDelete WHERE="Property = 'ShowUserRegistrationDlg'"> 
<$/Table> 
<$Table "ControlEvent"> 
   <$RowsDelete WHERE=^Dialog_ = 'LicenseAgreementDlg' AND Control_ = 
'Next' AND Event = 'NewDialog' AND Argument = 'SetupTypeDlg' AND 
Condition = 'IAgree = "Yes" AND ShowUserRegistrationDlg <> 1'^> 
   <$RowsDelete WHERE=^Dialog_ = 'LicenseAgreementDlg' AND Control_ = 
'Next' AND Event = 'NewDialog' AND Argument = 'UserRegistrationDlg' 
AND Condition = 'IAgree = "Yes" AND ShowUserRegistrationDlg = 1'^> 
   <$RowsDelete WHERE="Dialog_ = 'SetupTypeDlg' AND Control_ = 'Back' 
AND Event = 'NewDialog' AND Argument = 'LicenseAgreementDlg' AND 
Condition = 'ShowUserRegistrationDlg <> 1'"> 
   <$RowsDelete WHERE="Dialog_ = 'SetupTypeDlg' AND Control_ = 'Back' 
AND Event = 'NewDialog' AND Argument = 'UserRegistrationDlg' AND 
Condition = 'ShowUserRegistrationDlg = 1'"> 
   #( 
       <$Row 
             Dialog_="LicenseAgreementDlg" 
            Control_="Next" 
               Event="NewDialog" 
            Argument="UserRegistrationDlg" 
           Condition='IAgree = "Yes"' 
            Ordering="1" 
       > 
   #) 

   #( 
       <$Row 
             Dialog_="SetupTypeDlg" 
            Control_="Back" 
               Event="NewDialog" 
            Argument="UserRegistrationDlg" 
           Condition="1" 
            Ordering="" 
       > 
   #) 
<$/Table> 




;---------------------------------------------------------------------------- 
;--- Fix up the Licence agreement 
------------------------------------------- 
;---------------------------------------------------------------------------- 
#if  ['<$COMPANY_LOOK_FOR_LICENCE_FILE>' <> 'N'] 
    ;--- Look for a licence file 
-------------------------------------------- 
    #DefineRexx '' 
       ;--- Look for a ".licence" file 
-------------------------------------- 
       @@LicenceFile     = '<$COMPANY_LICENCE_NAME>'; 
       call Info 'Have licence?: ' || FilePart('n', @@LicenceFile); 
       @@LicenceFileFull = FileQueryExists(@@LicenceFile); 
       if  @@LicenceFileFull <> '' then 
       do 
           ;--- We found a ".licence" file 
---------------------------------- 
           @@FromVerLF = MacroGet('ProdInfo.Licence') 
           if  @@FromVerLF <> '' then 
           do 
               ;--- We found a file and one was specified in the .ver 
file (ignore if same) --- 
               @@FromVerLFFull = FileQueryExists(@@FromVerLF); 
               if translate(@@FromVerLFFull) <> 
translate(@@LicenceFileFull) then 
                  call Warning "LIC00", "Local Licence file is 
overriding the one specified in the version file!" 
               else 
                  call Info 'The licence file specified in the .VER 
file is the default'; 
           end 

           ;--- Set "ProdInfo.Licence" 
-------------------------------------- 
           call MacroSet 'ProdInfo.Licence', @@LicenceFileFull, 'Y'; 
       end; 
    #DefineRexx 
#endif 
#DefineRexx '' 
   ;--- Display the licence we will use (if any) 
---------------------------- 
   if  MacroGet('ProdInfo.Licence') = '' then 
        @@Using = "NONE" 
   else 
        @@Using = MacroGet('ProdInfo.Licence'); 
   call Info 'Using licence: ' || @@Using; 
#DefineRexx 
#if ['<$ProdInfo.Licence $$IsBlank>' = 'N'] 
   ;--- We have a licence (in a file) 
--------------------------------------- 
   #if  ['<$COMPANY_PREPROCESS_LICENCE_FILE>' <> 'N'] 
        ;--- Licence file contains macros or other formatting 
--------------- 
        #option PUSH DefineMacroReplace=ON 
        #define  COMPANY_LICENCE_TEMPLATE  <$ProdInfo.Licence> 
        #define+ ProdInfo.Licence          <$MAKEMSI_OUT_LOG_DIR $$DEL: 
\>PreProcessed.rtf 
        #option POP 
        <$FileMake "<$ProdInfo.Licence>"> 
            #include "<$COMPANY_LICENCE_TEMPLATE>" 
        <$/FileMake> 
   #endif 
   #DefineRexx '' 
       ;--- Make sure the licence file exists 
------------------------------- 
       @@Licence = MacroGet('ProdInfo.Licence'); 
       @@LicenceFile = FindFile(@@Licence) 
       if  @@LicenceFile = '' then 
           Error('We could not find the licence file "' || @@Licence 
|| '"'); 

       ;--- Read the information 
-------------------------------------------- 
       call FileClose @@LicenceFile, 'N'; 
       @@Text = charin(@@LicenceFile,1, 999999); 
       call FileClose @@LicenceFile; 

       ;--- Create a VB string (without the outer quotes) 
------------------- 
       @@Text = ReplaceString(@@Text, '"',   '""'); 
       @@Text = ReplaceString(@@Text, '00'x, ' ');   ;;God knows why 
the trailing null exists... 
       @@Text = ReplaceString(@@Text, '0D'x, '" & vbCR & "'); 
       @@Text = ReplaceString(@@Text, '0A'x, '" & vbLF & "'); 
   #DefineRexx 
   <$Table "Control"> 
       #( 
           <$Row @Where="Dialog_='LicenseAgreementDlg' and 
Control='AgreementText'" @OK="? = 1" 
               *Text=~"<??@@Text>"~ 
           > 
       #) 
   <$/Table> 
#endif 




;---------------------------------------------------------------------------- 
;--- Want user registration dialog? 
----------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_WANT_USER_REGISTRATION_DIALOG  N 
#if ['<$COMPANY_WANT_USER_REGISTRATION_DIALOG>' = 'N'] 
    #define REMOVED_UserRegistrationDlg 
    <$DialogRemove "UserRegistrationDlg"> 
#endif 

;---------------------------------------------------------------------------- 
;--- Want the licence Dialog? 
----------------------------------------------- 
;---------------------------------------------------------------------------- 
#if ['<$ProdInfo.Licence $$IsBlank>' = 'Y'] 
    #define REMOVED_LicenseAgreementDlg 
    <$DialogRemove "LicenseAgreementDlg"> 
#endif 




;---------------------------------------------------------------------------- 
;--- Some Validation Message Filtering 
-------------------------------------- 
;---------------------------------------------------------------------------- 
#define? COMPANY_MsiValFilter_CustomAction.ExtendedType \ 
         <$MsiValFilter "Column: ExtendedType of Table: CustomAction 
is not defined in database" Comment="This column is optional"> 
<$COMPANY_MsiValFilter_CustomAction.ExtendedType> 
#NextId UNLOCK "COMPANY.MMH" 




<*End copy here*> 

The next script file we are going to go over is DEPT.mmh.  Here we 
setup our company info so that the completed MSI install UI shows our 
informatino so that everyone knows who put this together in your 
company.  In this file you will want to edit lines 49 - 58.  In the 
code example these variables are generalized and look like this 
starting at line 46.  You might choose to just blank these things out 
or enter your own information.  You company policy will likely dictate 
what you should change these things to. 




;---------------------------------------------------------------------------- 
;--- Define some Department details 
----------------------------------------- 
;---------------------------------------------------------------------------- 
#define? DEPT_ARP_URL_PUBLISHER 
#define? DEPT_ARP_URL_TECHNICAL_SUPPORT                  < 
$DEPT_SUPPORT_WEB_URL> 
#define? DEPT_ARP_URL_APPLICATION_UPDATE_INFORMATION 
#define? DEPT_NAME                       Your Department 
#define? DEPT_ADDRESS                    Department Address 
#define? DEPT_MSI_MANUFACTURER           <$DEPT_NAME> 
#define? DEPT_MSI_AUTHOR                 <$DEPT_NAME> 
#define? COMPANY_CONTACT_NAME            Your Name 
#define? COMPANY_CONTACT_NAME_PHONE      Your Phone Number 
#define? COMPANY_PACKAGED_BY             Packaged by <$DEPT_NAME> (< 
$DEPT_ADDRESS>). 

This is pretty straightforward so I won't bore you with what each line 
here is.  The complete code for DEPT.mmh is just below here.  You may 
at some point choose to edit/cusustomize this information further. 
The project should still build successfully regardless of what you use 
for information in the lines shown above.  Outside of that, you will 
alter how the MSI and it's files are put together so be careful and 
always test before deploying. 




DEPT.mmh 




<*Begin copy here*> 




;---------------------------------------------------------------------------- 
; 
;    MODULE NAME:   DEPT.MMH 
; 
;        $Author:   USER "Phil Shramko"  $ 
;      $Revision:   1.00  $ 
;          $Date:   07 Oct 2010 14:13:58  $ 
;      COPYRIGHT:   (C)opyright Dennis Bareis, Australia, 2003 
;                   All rights reserved. 
; 
; Note that this header is one of the few intended to be "replaced". 
; It has however been written so physical altering or deleting of this 
; file should not be required. 
; 
; There are many options, some are: 
; 
;       1. Ignore this file altogether, create your own front end with 
;          different filenames so as not to clash. 
; 
;       2. Modify this file BUT if you do so you should move it to a 
;          different directory so as not be be deleted ALONG WITH YOUR 
;          CHANGES on a MAKEMSI uninstall! 
; 
;       3. Create a new header that overrides some things but still 
includes 
;          this one. 
; 
; Let me know of any issues. 
;---------------------------------------------------------------------------- 

;---------------------------------------------------------------------------- 
;--- Define Version number of this install support 
-------------------------- 
;---------------------------------------------------------------------------- 
#ifdef   DEPT_VERSION 
   ;--- Die, already included 
----------------------------------------------- 
   #error ^You have already included "<?InputComponent>"^ 
#endif 
#define  DEPT_VERSION   03.171 




;---------------------------------------------------------------------------- 
;--- Obsolete values (don't use!) 
------------------------------------------- 
;---------------------------------------------------------------------------- 
#define? DEPT_SUPPORT_WEB_URL 




;---------------------------------------------------------------------------- 
;--- Define some Department details 
----------------------------------------- 
;---------------------------------------------------------------------------- 
#define? DEPT_ARP_URL_PUBLISHER 
#define? DEPT_ARP_URL_TECHNICAL_SUPPORT                  < 
$DEPT_SUPPORT_WEB_URL> 
#define? DEPT_ARP_URL_APPLICATION_UPDATE_INFORMATION 
#define? DEPT_NAME                       Your Department 
#define? DEPT_ADDRESS                    Department Address 
#define? DEPT_MSI_MANUFACTURER           <$DEPT_NAME> 
#define? DEPT_MSI_AUTHOR                 <$DEPT_NAME> 
#define? COMPANY_CONTACT_NAME            Your Name 
#define? COMPANY_CONTACT_NAME_PHONE      Your Phone Number 
#define? COMPANY_PACKAGED_BY             Packaged by <$DEPT_NAME> (< 
$DEPT_ADDRESS>). 




;---------------------------------------------------------------------------- 
;--- Define the types of boxes your department/company supports 
------------- 
;---------------------------------------------------------------------------- 
#ifndef COMPANY_DEFINE_DEPARTMENTS_PLATFORMS 
   #( 
       #define COMPANY_DEFINE_DEPARTMENTS_PLATFORMS  ;;COMPANY.MMH 
expands... 

       ;--- User must override... 
------------------------------------------- 
       <$Platform "WINDOWS_ALL" DESC=^On any Windows Computer^ 
PLATDIR=AnyWindowsComputer"> 
       <$Platform "TEST"        DESC=^Testing (NOT SUPPORTED)^ 
PLATDIR="Testing-Unsupported"> 
   #) 
#endif 




;---------------------------------------------------------------------------- 
;--- Load MAKEMSI support 
--------------------------------------------------- 
;---------------------------------------------------------------------------- 
#NextId PUSH 
   #include "COMPANY.MMH" 
#NextId POP 

;---------------------------------------------------------------------------- 
;--- Make sure we record details about this header 
-------------------------- 
;---------------------------------------------------------------------------- 
<$SourceFile Version="<$DEPT_VERSION>"> 

;---------------------------------------------------------------------------- 
;--- Start "location" status information (if allowed) 
----------------------- 
;---------------------------------------------------------------------------- 
<$LocationVerboseOn>            ;;Outputs messages during length 
processing (to prove it hasn't hung etc) 




<*End copy here*> 




The next file we are going to go over is OSSEC.mmh.  Here we setup the 
standard build information.  What you put into DEPT.mmh WILL override 
the information you put in OSSEC.mmh.  The redundancies are there to 
make sure things come out the way we want them in the end.  DEPT.mmh 
does also do alot more processing of information that OSSEC.mmh whish 
is why we need them both.  Here is the code for OSSEC.mmh. 




OSSSEC.mmh 




<*Begin copy here*> 




;---------------------------------------------------------------------------- 
; 
;    MODULE NAME:   OCCEC.MMH 
; 
;        $Author:   USER "Phil Shramko"  $ 
;      $Revision:   1.0  $ 
;          $Date:   11 Oct 2010 17:38:34  $ 
; 
;---------------------------------------------------------------------------- 




;---------------------------------------------------------------------------- 
;--- Set up some options specific to your requirements 
------------------------ 
;---------------------------------------------------------------------------- 
#define? DEPT_ARP_URL_PUBLISHER           http://yourweb.address.com 
#define? DEPT_ARP_URL_TECHNICAL_SUPPORT   http://yoursupportweb.address.com 
#define? DEPT_NAME                        Your name or your department 
name 
#define? DEPT_ADDRESS                     Your Department Location 
#define? COMPANY_CONTACT_NAME             Your Company Name 
#define? COMPANY_CONTACT_NAME_PHONE       Your Phone 
Number        ;;Do you really want this here 
#define? COMPANY_SUMMARY_SCHEMA           110      ;;Minimum v1.1 
Installer 




;---------------------------------------------------------------------------- 
;--- Override/set some standard defaults 
------------------------------------ 
;---------------------------------------------------------------------------- 
#define? DBG_ALL                                   Y         ;;Add 
MAKEMSI debugging to "console file" 
#define? DBG_SAY_LOCATION                           call Say2Logs < 
$DBG_INDENT> || '  ' || time() || ' '  ;;Adding time makes it a bit 
slower but useful for debugging slow builds... 
#define? COMMONFRAMEWORK_ZIP_SOURCE_FOR_BACKUP     N         ;;No 
"insurance" until I bother to install "info zip"... 
#define? DEFAULT_SERVICE_CONTROL_UNINSTALL_EVENTS            ;;I think 
this option is safer than the MAKEMSI default 
#define? DEFAULT_SERVICE_CONTROL_INSTALL_EVENTS              ;;I think 
this option is better 
#define? DEFAULT_FILE_WANT_FILEHASH                Y         ;;My box 
can generate MD5 hashes! 
#define? COMPANY_PREPROCESS_LICENCE_FILE           Y         ;;Default 
is to preprocess licence files 
#define? MAKEMSI_HTML_EXTENSION                    hta       ;;Default 
extension (HTML Application - gets around WINXP SP2 issue) 
#define? UISAMPLE_LEFTSIDE_TEXT_FONT_COLOR         &H7F0000  ;;Medium 
Blue in BGR (believe it or not...) 
#( 
    #define? UISAMPLE_LEFTSIDE_TEXT 
    Developed by <$DEPT_NAME> - <$DEPT_ADDRESS>. 
    You can put whatever you like here or replace with your own 
graphics etc. 
    This text defined in "ME.MMH"! 
#) 
#( 
    #define? 
@VALIDATE_TEXT_FOR_MISSINGDATA                   ;;Example only as now 
duplicates exact text as new default value 
    This column is not mentioned in the _Validation table. 
    Either add the validation data or use the "@validate" parameter 
    on the "row" command (or alter its default). 
#) 




;---------------------------------------------------------------------------- 
;--- Include MAKEMSI support 
------------------------------------------------ 
;---------------------------------------------------------------------------- 
#include "DEPT.MMH" 




<*End copy here*> 




Now we get to our OssecHIDS.MM file.  This is the main build file for 
making a 32-bit MSI installer that, depending on what you did with 
your uisample.mmh file earlier will have a full UI with all of the 
regular buttons and options you find in any other installer or will 
have a minimal UI which is essentially just a window with a title so 
the users know what is being installed and a progress bar. 




Near the top of this file you will see the following (lines 14 - 18). 




;---------------------------------------------------------------------------------------------------- 
;-         Define path to Ossec Install 
executable                                                     - 
;- 
EXAMPLE: 
- 
;- define+ OSSECINSTEXE C:\MSIBuilds\ossec\ossec-agent-win32-2.5.exe - 
;---------------------------------------------------------------------------------------------------- 
#define+ OSSECINSTEXE C:\PATH\TO\YOUR\INSTALL.EXE 




This is pretty self-explanatory as well.  This is the ONLY line you 
should edit here.  Again you can customize this file further but I 
would not until you really get to know MAKEMSI. 




Here is the complete code for OssecHIDS.MM. 




OssecHIDS.MM 




<*Begin copy here*> 




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


;--- Want to debug (not common) 
--------------------------------------------- 
;#debug on 
;#Option DebugLevel=^NONE, +OpSys^ 
; Installer script to wrap an existing NSIS installer with a Windows 
InstallerMSI 
; designed to run as silently as possible and to handle any existing 
NSISinstaller 
;--- Define default location where file should install and add files 
-------- 
<$DirectoryTree Key="INSTALLDIR" DIR="[ProgramFilesFolder]\ossec- 
agent" CHANGE="\" PrimaryFolder="Y">     ;;Tree starts at 
"ProgramFilesFolder" 
<$Files "*keys*" DestDir="INSTALLDIR"> 
; Installer script to wrap an existing NSIS installer with a Windows 
Installer MSI 
; designed to run as silently as possible and to handle any existing 
NSIS installer 
#define? WRAPINST_SEQ_INSTALL StartServices-RegisterUser 
#define? WRAPINST_SEQ_UNINSTALL InstallInitialize-StopServices 
#define? WRAPINST_CONDITION_INSTALL <$CONDITION_INSTALL_ONLY> ;;You 
could add repair etc. 
#define? WRAPINST_CONDITION_UNINSTALL < 
$CONDITION_UNINSTALL_ONLY> ;;Make this "" if you don't want to ever 
uninstall(rare?) 
#define? WRAPINST_BASETYPE_INSTALL Deferred ;;Base CA attributes 
(install). You may need to add "SYSTEM". 
#define? WRAPINST_BASETYPE_UNINSTALL Deferred ;;Base CA attributes 
(uninstall). You may need to add "SYSTEM". 
#define? WRAPINST_HIDE_WRAPPED_PRODUCT Y ;;Don't show in ARP as 
wrapping product will uninstall 
#define? WRAPINST_(UN)INSTALL_VALIDATION Y 
#define? WRAPINST_INSTALL_VALIDATION < 
$WRAPINST_(UN)INSTALL_VALIDATION> 
#define? WRAPINST_UNINSTALL_VALIDATION < 
$WRAPINST_(UN)INSTALL_VALIDATION> 
#define? WRAPINST_UNINSTALL_VALIDATION_WAIT 5 ;;Some uninstalls are 
ASYNC with task returning before complete! If non-blank and non-zero 
then how many seconds do we wish to allow for the uninstall task to 
complete? 
;---------------------------------------------------------------------------- 
;--- Install Nullsoft NSIS based Installer 
---------------------------------- 
;---------------------------------------------------------------------------- 
#( 
    <$File source="ossec-agent-win32-2.5.exe" Destination="c:\MSIBUILDS 
\OSSEC\"> 
    <$WrapInstall 
        ;--- INSTALL 
-------------------------------------------------------- 
         EXE="<$OSSECINSTEXE>" 
         Args='/S' 
  ;--- UNINSTALL 
------------------------------------------------------ 
   ;NSIS uninstaller will handle this already so we don't need it but 
it gives the MSI the location of correct uninstall executable 
   UNINSTALLEXE="[INSTALLDIR]uninstall.exe" 
    > 
#) 
;---------------------------------------------------------------------------- 
;--- Configure Ossec HIDS agent after install 
------------------------------- 
;---------------------------------------------------------------------------- 
#( 
 <$ExeCa 
  ;--- Configure agent and add key 
------------------------------------ 
   EXE="[INSTALLDIR]ossec_distribute_keys.cmd" 
   WorkDir="INSTALLDIR" 
   SEQ="InstallFinalize-"   Type="immediate ASync AnyRc" 
   CONDITION="<$CONDITION_INSTALL_ONLY>" 
 > 
#) 

<*End copy here*> 

Next we go throught the OssecHIDSx64.MM.  This file is nearly 
identical to OssecHIDS.MM except for here we tell the build scripts to 
package the ossec_distribute_keys_x64 into our cab file (everything 
ends up in a single .MSI file, no worries, I''m just telling you what 
is going on here :-)).  As we went over in the previous posts this is 
necessary becuase of the differences in how 32-bit and 64-bit machines 
handle installer and paths.  You will need to edit the same line here 
that you did in the OssecHIDS.MM file. 

Here's the code for our 64-bit build script. 

OssecHIDSx64.MM 

<*Begin copy here*> 

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

;--- Want to debug (not common) 
--------------------------------------------- 
;#debug on 
;#Option DebugLevel=^NONE, +OpSys^ 
; Installer script to wrap an existing NSIS installer with a Windows 
InstallerMSI 
; designed to run as silently as possible and to handle any existing 
NSISinstaller 
;--- Define default location where file should install and add files 
-------- 
<$DirectoryTree Key="INSTALLDIR" DIR="[ProgramFilesFolder]\ossec- 
agent" CHANGE="\" PrimaryFolder="Y">     ;;Tree starts at 
"ProgramFilesFolder" 
<$Files "*keys*" DestDir="INSTALLDIR"> 
; Installer script to wrap an existing NSIS installer with a Windows 
Installer MSI 
; designed to run as silently as possible and to handle any existing 
NSIS installer 
#define? WRAPINST_SEQ_INSTALL StartServices-RegisterUser 
#define? WRAPINST_SEQ_UNINSTALL InstallInitialize-StopServices 
#define? WRAPINST_CONDITION_INSTALL <$CONDITION_INSTALL_ONLY> ;;You 
could add repair etc. 
#define? WRAPINST_CONDITION_UNINSTALL < 
$CONDITION_UNINSTALL_ONLY> ;;Make this "" if you don't want to ever 
uninstall(rare?) 
#define? WRAPINST_BASETYPE_INSTALL Deferred ;;Base CA attributes 
(install). You may need to add "SYSTEM". 
#define? WRAPINST_BASETYPE_UNINSTALL Deferred ;;Base CA attributes 
(uninstall). You may need to add "SYSTEM". 
#define? WRAPINST_HIDE_WRAPPED_PRODUCT Y ;;Don't show in ARP as 
wrapping product will uninstall 
#define? WRAPINST_(UN)INSTALL_VALIDATION Y 
#define? WRAPINST_INSTALL_VALIDATION < 
$WRAPINST_(UN)INSTALL_VALIDATION> 
#define? WRAPINST_UNINSTALL_VALIDATION < 
$WRAPINST_(UN)INSTALL_VALIDATION> 
#define? WRAPINST_UNINSTALL_VALIDATION_WAIT 5 ;;Some uninstalls are 
ASYNC with task returning before complete! If non-blank and non-zero 
then how many seconds do we wish to allow for the uninstall task to 
complete? 
;---------------------------------------------------------------------------- 
;--- Install Nullsoft NSIS based Installer 
---------------------------------- 
;---------------------------------------------------------------------------- 
#( 
    <$File source="ossec-agent-win32-2.5.exe" Destination="c:\MSIBUILDS 
\OSSEC\"> 
    <$WrapInstall 
        ;--- INSTALL 
-------------------------------------------------------- 
         EXE="<$OSSECINSTEXE>" 
         Args='/S' 
  ;--- UNINSTALL 
------------------------------------------------------ 
   ;NSIS uninstaller will handle this already so we don't need it but 
it gives the MSI the location of correct uninstall executable 
   UNINSTALLEXE="[INSTALLDIR]uninstall.exe" 
    > 
#) 
;---------------------------------------------------------------------------- 
;--- Configure Ossec HIDS agent after install 
------------------------------- 
;---------------------------------------------------------------------------- 
#( 
 <$ExeCa 
  ;--- Configure agent and add key 
------------------------------------ 
   EXE="[INSTALLDIR]ossec_distribute_keys_x64.cmd" 
   WorkDir="INSTALLDIR" 
   SEQ="InstallFinalize-" 
   Type="immediate ASync AnyRc" 
   CONDITION="<$CONDITION_INSTALL_ONLY>" 
 > 
#) 

<*End copy here*> 

We are getting close to wrapping up now.  This next file is not a 
script.  It is a copy of the EULA extracted from the base install .exe 
file that we downloaded from ossec.  It's not needed, but is nice to 
have.  Especially if we ever need to use the full UI installer. 

Here's the "code" for that. 

OssecHIDS.rtf 

<*Begin copy here*> 

{\rtf1\adeflang1025\ansi 
\ansicpg1252\uc1\adeff31507\deff0\stshfdbch31505\stshfloch31506\stshfhich31506\stshfbi31507\deflang1033\deflangfe1033\themelang1033\themelangfe0\themelangcs0{\fonttbl{\f0\fbidi 
\froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New 
Roman;}{\f1\fbidi \fswiss\fcharset0\fprq2{\*\panose 
020b0604020202020204}Arial;} 
{\f34\fbidi \froman\fcharset1\fprq2{\*\panose 02040503050406030204} 
Cambria Math;}{\f37\fbidi \fswiss\fcharset0\fprq2{\*\panose 
020f0502020204030204}Calibri;}{\flomajor\f31500\fbidi \froman 
\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;} 
{\fdbmajor\f31501\fbidi \froman\fcharset0\fprq2{\*\panose 
02020603050405020304}Times New Roman;}{\fhimajor\f31502\fbidi \froman 
\fcharset0\fprq2{\*\panose 02040503050406030204}Cambria;} 
{\fbimajor\f31503\fbidi \froman\fcharset0\fprq2{\*\panose 
02020603050405020304}Times New Roman;}{\flominor\f31504\fbidi \froman 
\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;} 
{\fdbminor\f31505\fbidi \froman\fcharset0\fprq2{\*\panose 
02020603050405020304}Times New Roman;}{\fhiminor\f31506\fbidi \fswiss 
\fcharset0\fprq2{\*\panose 020f0502020204030204}Calibri;} 
{\fbiminor\f31507\fbidi \froman\fcharset0\fprq2{\*\panose 
02020603050405020304}Times New Roman;}{\f40\fbidi \froman 
\fcharset238\fprq2 Times New Roman CE;}{\f41\fbidi \froman 
\fcharset204\fprq2 Times New Roman Cyr;} 
{\f43\fbidi \froman\fcharset161\fprq2 Times New Roman Greek;} 
{\f44\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;}{\f45\fbidi 
\froman\fcharset177\fprq2 Times New Roman (Hebrew);}{\f46\fbidi \froman 
\fcharset178\fprq2 Times New Roman (Arabic);} 
{\f47\fbidi \froman\fcharset186\fprq2 Times New Roman Baltic;} 
{\f48\fbidi \froman\fcharset163\fprq2 Times New Roman (Vietnamese);} 
{\f50\fbidi \fswiss\fcharset238\fprq2 Arial CE;}{\f51\fbidi \fswiss 
\fcharset204\fprq2 Arial Cyr;} 
{\f53\fbidi \fswiss\fcharset161\fprq2 Arial Greek;}{\f54\fbidi \fswiss 
\fcharset162\fprq2 Arial Tur;}{\f55\fbidi \fswiss\fcharset177\fprq2 
Arial (Hebrew);}{\f56\fbidi \fswiss\fcharset178\fprq2 Arial (Arabic);} 
{\f57\fbidi \fswiss\fcharset186\fprq2 Arial Baltic;}{\f58\fbidi \fswiss 
\fcharset163\fprq2 Arial (Vietnamese);}{\f410\fbidi \fswiss 
\fcharset238\fprq2 Calibri CE;}{\f411\fbidi \fswiss\fcharset204\fprq2 
Calibri Cyr;} 
{\f413\fbidi \fswiss\fcharset161\fprq2 Calibri Greek;}{\f414\fbidi 
\fswiss\fcharset162\fprq2 Calibri Tur;}{\f417\fbidi \fswiss 
\fcharset186\fprq2 Calibri Baltic;}{\f418\fbidi \fswiss 
\fcharset163\fprq2 Calibri (Vietnamese);} 
{\flomajor\f31508\fbidi \froman\fcharset238\fprq2 Times New Roman CE;} 
{\flomajor\f31509\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;} 
{\flomajor\f31511\fbidi \froman\fcharset161\fprq2 Times New Roman 
Greek;} 
{\flomajor\f31512\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;} 
{\flomajor\f31513\fbidi \froman\fcharset177\fprq2 Times New Roman 
(Hebrew);}{\flomajor\f31514\fbidi \froman\fcharset178\fprq2 Times New 
Roman (Arabic);} 
{\flomajor\f31515\fbidi \froman\fcharset186\fprq2 Times New Roman 
Baltic;}{\flomajor\f31516\fbidi \froman\fcharset163\fprq2 Times New 
Roman (Vietnamese);}{\fdbmajor\f31518\fbidi \froman\fcharset238\fprq2 
Times New Roman CE;} 
{\fdbmajor\f31519\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;} 
{\fdbmajor\f31521\fbidi \froman\fcharset161\fprq2 Times New Roman 
Greek;}{\fdbmajor\f31522\fbidi \froman\fcharset162\fprq2 Times New 
Roman Tur;} 
{\fdbmajor\f31523\fbidi \froman\fcharset177\fprq2 Times New Roman 
(Hebrew);}{\fdbmajor\f31524\fbidi \froman\fcharset178\fprq2 Times New 
Roman (Arabic);}{\fdbmajor\f31525\fbidi \froman\fcharset186\fprq2 
Times New Roman Baltic;} 
{\fdbmajor\f31526\fbidi \froman\fcharset163\fprq2 Times New Roman 
(Vietnamese);}{\fhimajor\f31528\fbidi \froman\fcharset238\fprq2 
Cambria CE;}{\fhimajor\f31529\fbidi \froman\fcharset204\fprq2 Cambria 
Cyr;} 
{\fhimajor\f31531\fbidi \froman\fcharset161\fprq2 Cambria Greek;} 
{\fhimajor\f31532\fbidi \froman\fcharset162\fprq2 Cambria Tur;} 
{\fhimajor\f31535\fbidi \froman\fcharset186\fprq2 Cambria Baltic;} 
{\fhimajor\f31536\fbidi \froman\fcharset163\fprq2 Cambria 
(Vietnamese);}{\fbimajor\f31538\fbidi \froman\fcharset238\fprq2 Times 
New Roman CE;}{\fbimajor\f31539\fbidi \froman\fcharset204\fprq2 Times 
New Roman Cyr;} 
{\fbimajor\f31541\fbidi \froman\fcharset161\fprq2 Times New Roman 
Greek;}{\fbimajor\f31542\fbidi \froman\fcharset162\fprq2 Times New 
Roman Tur;}{\fbimajor\f31543\fbidi \froman\fcharset177\fprq2 Times New 
Roman (Hebrew);} 
{\fbimajor\f31544\fbidi \froman\fcharset178\fprq2 Times New Roman 
(Arabic);}{\fbimajor\f31545\fbidi \froman\fcharset186\fprq2 Times New 
Roman Baltic;}{\fbimajor\f31546\fbidi \froman\fcharset163\fprq2 Times 
New Roman (Vietnamese);} 
{\flominor\f31548\fbidi \froman\fcharset238\fprq2 Times New Roman CE;} 
{\flominor\f31549\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;} 
{\flominor\f31551\fbidi \froman\fcharset161\fprq2 Times New Roman 
Greek;} 
{\flominor\f31552\fbidi \froman\fcharset162\fprq2 Times New Roman Tur;} 
{\flominor\f31553\fbidi \froman\fcharset177\fprq2 Times New Roman 
(Hebrew);}{\flominor\f31554\fbidi \froman\fcharset178\fprq2 Times New 
Roman (Arabic);} 
{\flominor\f31555\fbidi \froman\fcharset186\fprq2 Times New Roman 
Baltic;}{\flominor\f31556\fbidi \froman\fcharset163\fprq2 Times New 
Roman (Vietnamese);}{\fdbminor\f31558\fbidi \froman\fcharset238\fprq2 
Times New Roman CE;} 
{\fdbminor\f31559\fbidi \froman\fcharset204\fprq2 Times New Roman Cyr;} 
{\fdbminor\f31561\fbidi \froman\fcharset161\fprq2 Times New Roman 
Greek;}{\fdbminor\f31562\fbidi \froman\fcharset162\fprq2 Times New 
Roman Tur;} 
{\fdbminor\f31563\fbidi \froman\fcharset177\fprq2 Times New Roman 
(Hebrew);}{\fdbminor\f31564\fbidi \froman\fcharset178\fprq2 Times New 
Roman (Arabic);}{\fdbminor\f31565\fbidi \froman\fcharset186\fprq2 
Times New Roman Baltic;} 
{\fdbminor\f31566\fbidi \froman\fcharset163\fprq2 Times New Roman 
(Vietnamese);}{\fhiminor\f31568\fbidi \fswiss\fcharset238\fprq2 
Calibri CE;}{\fhiminor\f31569\fbidi \fswiss\fcharset204\fprq2 Calibri 
Cyr;} 
{\fhiminor\f31571\fbidi \fswiss\fcharset161\fprq2 Calibri Greek;} 
{\fhiminor\f31572\fbidi \fswiss\fcharset162\fprq2 Calibri Tur;} 
{\fhiminor\f31575\fbidi \fswiss\fcharset186\fprq2 Calibri Baltic;} 
{\fhiminor\f31576\fbidi \fswiss\fcharset163\fprq2 Calibri 
(Vietnamese);}{\fbiminor\f31578\fbidi \froman\fcharset238\fprq2 Times 
New Roman CE;}{\fbiminor\f31579\fbidi \froman\fcharset204\fprq2 Times 
New Roman Cyr;} 
{\fbiminor\f31581\fbidi \froman\fcharset161\fprq2 Times New Roman 
Greek;}{\fbiminor\f31582\fbidi \froman\fcharset162\fprq2 Times New 
Roman Tur;}{\fbiminor\f31583\fbidi \froman\fcharset177\fprq2 Times New 
Roman (Hebrew);} 
{\fbiminor\f31584\fbidi \froman\fcharset178\fprq2 Times New Roman 
(Arabic);}{\fbiminor\f31585\fbidi \froman\fcharset186\fprq2 Times New 
Roman Baltic;}{\fbiminor\f31586\fbidi \froman\fcharset163\fprq2 Times 
New Roman (Vietnamese);}} 
{\colortbl; 
\red0\green0\blue0;\red0\green0\blue255;\red0\green255\blue255;\red0\green255\blue0;\red255\green0\blue255;\red255\green0\blue0;\red255\green255\blue0;\red255\green255\blue255;\red0\green0\blue128;\red0\green128\blue128;\red0\green128\blue0; 
\red128\green0\blue128;\red128\green0\blue0;\red128\green128\blue0;\red128\green128\blue128;\red192\green192\blue192;} 
{\*\defchp \fs22\loch\af31506\hich\af31506\dbch\af31505 }{\*\defpap 
\ql \li0\ri0\sa200\sl276\slmult1 
\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright 
\rin0\lin0\itap0 }\noqfpromote {\stylesheet{\ql 
\li0\ri0\sa200\sl276\slmult1\widctlpar\wrapdefault\aspalpha\aspnum 
\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 
\af31507\afs22\alang1025 
\ltrch\fcs0 \fs22\lang1033\langfe1033\loch\f31506\hich\af31506\dbch 
\af31505\cgrid\langnp1033\langfenp1033 \snext0 \sqformat \spriority0 
Normal;}{\*\cs10 \additive \ssemihidden \sunhideused \spriority1 
Default Paragraph Font;}{\* 
\ts11\tsrowd 
\trftsWidthB3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\trcbpat1\trcfpat1\tblind0\tblindtype3\tsvertalt 
\tsbrdrt\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\tsbrdrdgr\tsbrdrh\tsbrdrv 
\ql \li0\ri0\sa200\sl276\slmult1 
\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright 
\rin0\lin0\itap0 \rtlch\fcs1 \af31507\afs22\alang1025 \ltrch\fcs0 
\fs22\lang1033\langfe1033\loch\f31506\hich\af31506\dbch\af31505\cgrid 
\langnp1033\langfenp1033 \snext11 \ssemihidden \sunhideused 
Normal Table;}}{\*\rsidtbl \rsid2444995\rsid13860386}{\mmathPr 
\mmathFont34\mbrkBin0\mbrkBinSub0\msmallFrac0\mdispDef1\mlMargin0\mrMargin0\mdefJc1\mwrapIndent1440\mintLim0\mnaryLim1} 
{\info{\operator Shramko.Philip}{\creatim\yr2010\mo10\dy12\hr23\min28} 
{\revtim\yr2010\mo10\dy12\hr23\min30}{\version2}{\edmins2}{\nofpages11} 
{\nofwords2513}{\nofchars14327}{\nofcharsws16807}{\vern49247}}{\* 
\xmlnstbl {\xmlns1 http://schemas.microsoft.com/office/word/2003/wordml}} 
\paperw12240\paperh15840\margl1440\margr1440\margt1440\margb1440\gutter0\ltrsect 
\widowctrl\ftnbj\aenddoc 
\trackmoves0\trackformatting1\donotembedsysfont0\relyonvml0\donotembedlingdata1\grfdocevents0\validatexml0\showplaceholdtext0\ignoremixedcontent0\saveinvalidxml0\showxmlerrors0\horzdoc 
\dghspace120\dgvspace120\dghorigin1701 
\dgvorigin1984\dghshow0\dgvshow3\jcompress 
\viewkind1\viewscale100\rsidroot2444995 \fet0{\*\wgrffmtfilter 
2450}\ilfomacatclnup0\ltrpar \sectd \ltrsect\linex0\sectdefaultcl 
\sftnbj {\*\pnseclvl1\pnucrm\pnstart1\pnindent720\pnhang {\pntxta .}} 
{\*\pnseclvl2 
\pnucltr\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl3\pndec 
\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl4\pnlcltr 
\pnstart1\pnindent720\pnhang {\pntxta )}}{\*\pnseclvl5\pndec 
\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl6 
\pnlcltr\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\* 
\pnseclvl7\pnlcrm\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}} 
{\*\pnseclvl8\pnlcltr\pnstart1\pnindent720\pnhang {\pntxtb (} 
{\pntxta )}}{\*\pnseclvl9\pnlcrm\pnstart1\pnindent720\pnhang 
{\pntxtb (}{\pntxta )}}\pard\plain \ltrpar\ql 
\li0\ri0\sa200\sl276\slmult1\widctlpar\wrapdefault\aspalpha\aspnum 
\faauto\adjustright\rin0\lin0\itap0\pararsid2444995 \rtlch\fcs1 
\af31507\afs22\alang1025 \ltrch\fcs0 
\fs22\lang1033\langfe1033\loch\af31506\hich\af31506\dbch\af31505\cgrid 
\langnp1033\langfenp1033 {\rtlch\fcs1 \af1\afs18 \ltrch\fcs0 
\f1\fs18\insrsid2444995\charrsid2444995 
\par \hich\af1\dbch\af31505\loch\f1  Copyright (C) 2010 Trend Micro 
Inc. All rights reserved. 
\par 
\par \hich\af1\dbch\af31505\loch\f1  OSSEC HIDS is a free software; 
you can redistribute it and/or modify 
\par \hich\af1\dbch\af31505\loch\f1  it under the terms of the GNU 
General Public License (version 2) as 
\par \hich\af1\dbch\af31505\loch\f1  published by the FSF - Free 
Software Foundation. 
\par 
\par \hich\af1\dbch\af31505\loch\f1  Note that this license applies to 
the source code, as well as 
\par \hich\af1\dbch\af31505\loch\f1  decoders, rules and any other 
data file included with OSSEC (unless 
\par \hich\af1\dbch\af31505\loch\f1  otherwise specified). 
\par 
\par \hich\af1\dbch\af31505\loch\f1  For the purpose of this license, 
we consider an application to constitute a 
\par \hich\af1\dbch\af31505\loch\f1  "derivative work" or \hich 
\af1\dbch\af31505\loch\f1 a work based on this program if it does any 
of the 
\par \hich\af1\dbch\af31505\loch\f1  following (list not exclusive): 
\par 
\par \hich\af1\dbch\af31505\loch\f1   * Integrates source code/data 
files from OSSEC. 
\par \hich\af1\dbch\af31505\loch\f1   * Includes OSSEC copyrighted 
material. 
\par \hich\af1\dbch\af31505\loch\f1   * Includes/integrates OSSEC into 
a proprietary executable installer. 
\par \hich\af1\dbch\af31505\loch\f1   * Links\hich\af1\dbch 
\af31505\loch\f1  to a library or executes a program that does any of 
the above. 
\par 
\par \hich\af1\dbch\af31505\loch\f1  This list is not exclusive, but 
just a clarification of our interpretation 
\par \hich\af1\dbch\af31505\loch\f1  of derived works. These 
restrictions only apply if you actually redistribute 
\par \hich\af1\dbch\af31505\loch\f1  OSSEC (or parts of it). 
\par 
\par \hich\af1\dbch\af31505\loch\f1  We don't c\hich\af1\dbch 
\af31505\loch\f1 onsider these to be added restrictions on top of the 
GPL, 
\par \hich\af1\dbch\af31505\loch\f1  but just a clarification of how 
we interpret "derived works" as it 
\par \hich\af1\dbch\af31505\loch\f1  applies to OSSEC. This is similar 
to the way Linus Torvalds has 
\par \hich\af1\dbch\af31505\loch\f1  announced his interpretation of 
how "derived works" applies to\hich\af1\dbch\af31505\loch\f1  Linux 
kernel 
\par \hich\af1\dbch\af31505\loch\f1  modules. Our interpretation 
refers only to OSSEC - we don't speak 
\par \hich\af1\dbch\af31505\loch\f1  for any other GPL products. 
\par 
\par \hich\af1\dbch\af31505\loch\f1  OSSEC HIDS is distributed in the 
hope that it will be useful, but WITHOUT 
\par \hich\af1\dbch\af31505\loch\f1  ANY WARRANTY; without even the 
implied warranty of MERCHANTABILITY or 
\par \hich\af1\dbch\af31505\loch\f1  FITNESS FOR A PARTICULAR PURPOSE. 
\par \hich\af1\dbch\af31505\loch\f1  See the GNU General Public 
License Version 3 below for more details. 
\par 
\par 
----------------------------------------------------------------------------- 
\par 
\par \tab \tab \hich\af1\dbch\af31505\loch\f1     GNU GENERAL PUBLIC 
LICENSE 
\par \tab \tab \hich\af1\dbch\af31505\loch\f1        Version 2, June 
1991 
\par 
\par \hich\af1\dbch\af31505\loch\f1  Copyright (C) 1989, 1991 Free 
Software Foundation, Inc., 
\par \hich\af1\dbch\af31505\loch\f1  51 Franklin Street, Fifth Floor, 
Boston, MA 02110-1301 USA 
\par \hich\af1\dbch\af31505\loch\f1  Everyone is permitted to copy and 
distribute verbatim copies 
\par \hich\af1\dbch\af31505\loch\f1  of this lic\hich\af1\dbch 
\af31505\loch\f1 ense document, but changing it is not allowed. 
\par 
\par \tab \tab \tab \hich\af1\dbch\af31505\loch\f1     Preamble 
\par 
\par \hich\af1\dbch\af31505\loch\f1   The licenses for most software 
are designed to take away your 
\par \hich\af1\dbch\af31505\loch\f1 freedom to share and change it. 
By contrast, the GNU General Public 
\par \hich\af1\dbch\af31505\loch\f1 License is intended to guarantee 
your freedom to share and\hich\af1\dbch\af31505\loch\f1  change free 
\par \hich\af1\dbch\af31505\loch\f1 software--to make sure the 
software is free for all its users.  This 
\par \hich\af1\dbch\af31505\loch\f1 General Public License applies to 
most of the Free Software 
\par \hich\af1\dbch\af31505\loch\f1 Foundation's software and to any 
other program whose authors commit to 
\par \hich\af1\dbch\af31505\loch\f1 using it.  (Some other Free 
Software Founda\hich\af1\dbch\af31505\loch\f1 tion software is covered 
by 
\par \hich\af1\dbch\af31505\loch\f1 the GNU Lesser General Public 
License instead.)  You can apply it to 
\par \hich\af1\dbch\af31505\loch\f1 your programs, too. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   When we speak of free software, 
we are referring to freedom, not 
\par \hich\af1\dbch\af31505\loch\f1 price.  Our General Public 
Licenses are designed to make sure that you 
\par \hich\af1\dbch\af31505\loch\f1 have the freedom to distribute 
copies of free software (and charge for 
\par \hich\af1\dbch\af31505\loch\f1 this service if you wish), that 
you receive source code or can get it 
\par \hich\af1\dbch\af31505\loch\f1 if you want it, that you can 
change the software or use pieces of it 
\par \hich\af1\dbch\af31505\loch\f1 in new free programs; and that you 
know you ca\hich\af1\dbch\af31505\loch\f1 n do these things. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   To protect your rights, we need 
to make restrictions that forbid 
\par \hich\af1\dbch\af31505\loch\f1 anyone to deny you these rights or 
to ask you to surrender the rights. 
\par \hich\af1\dbch\af31505\loch\f1 These restrictions translate to 
certain responsibilities for you if you 
\par \hich\af1\dbch\af31505\loch\f1 distribute copies of the s\hich 
\af1\dbch\af31505\loch\f1 oftware, or if you modify it. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   For example, if you distribute 
copies of such a program, whether 
\par \hich\af1\dbch\af31505\loch\f1 gratis or for a fee, you must give 
the recipients all the rights that 
\par \hich\af1\dbch\af31505\loch\f1 you have.  You must make sure that 
they, too, receive or can get the 
\par \hich\af1\dbch\af31505\loch\f1 source code.  And y\hich\af1\dbch 
\af31505\loch\f1 ou must show them these terms so they know their 
\par \hich\af1\dbch\af31505\loch\f1 rights. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   We protect your rights with two 
steps: (1) copyright the software, and 
\par \hich\af1\dbch\af31505\loch\f1 (2) offer you this license which 
gives you legal permission to copy, 
\par \hich\af1\dbch\af31505\loch\f1 distribute and/or modify the 
software. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   Also, for each\hich\af1\dbch 
\af31505\loch\f1  author's protection and ours, we want to make 
certain 
\par \hich\af1\dbch\af31505\loch\f1 that everyone understands that 
there is no warranty for this free 
\par \hich\af1\dbch\af31505\loch\f1 software.  If the software is 
modified by someone else and passed on, we 
\par \hich\af1\dbch\af31505\loch\f1 want its recipients to know that 
what they have is not the ori\hich\af1\dbch\af31505\loch\f1 ginal, so 
\par \hich\af1\dbch\af31505\loch\f1 that any problems introduced by 
others will not reflect on the original 
\par \hich\af1\dbch\af31505\loch\f1 authors' reputations. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   Finally, any free program is 
threatened constantly by software 
\par \hich\af1\dbch\af31505\loch\f1 patents.  We wish to avoid the 
danger that redistributors of a free 
\par \hich\af1\dbch\af31505\loch\f1 program will individually obtain 
patent licenses, in effect making the 
\par \hich\af1\dbch\af31505\loch\f1 program proprietary.  To prevent 
this, we have made it clear that any 
\par \hich\af1\dbch\af31505\loch\f1 patent must be licensed for 
everyone's free use or not licensed at all. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   The precise terms and conditions 
for cop\hich\af1\dbch\af31505\loch\f1 ying, distribution and 
\par \hich\af1\dbch\af31505\loch\f1 modification follow. 
\par 
\par \tab \tab \hich\af1\dbch\af31505\loch\f1     GNU GENERAL PUBLIC 
LICENSE 
\par \hich\af1\dbch\af31505\loch\f1    TERMS AND CONDITIONS FOR 
COPYING, DISTRIBUTION AND MODIFICATION 
\par 
\par \hich\af1\dbch\af31505\loch\f1   0. This License applies to any 
program or other work which contains 
\par \hich\af1\dbch\af31505\loch\f1 a notice placed by the copyright 
holder \hich\af1\dbch\af31505\loch\f1 saying it may be distributed 
\par \hich\af1\dbch\af31505\loch\f1 under the terms of this General 
Public License.  The "Program", below, 
\par \hich\af1\dbch\af31505\loch\f1 refers to any such program or 
work, and a "work based on the Program" 
\par \hich\af1\dbch\af31505\loch\f1 means either the Program or any 
derivative work under copyright law: 
\par \hich\af1\dbch\af31505\loch\f1 that is to say, a\hich\af1\dbch 
\af31505\loch\f1  work containing the Program or a portion of it, 
\par \hich\af1\dbch\af31505\loch\f1 either verbatim or with 
modifications and/or translated into another 
\par \hich\af1\dbch\af31505\loch\f1 language.  (Hereinafter, 
translation is included without limitation in 
\par \hich\af1\dbch\af31505\loch\f1 the term "modification".)  Each 
licensee is addressed as "you". 
\par 
\par \hich\af1\dbch\af31505\loch\f1 Ac\hich\af1\dbch\af31505\loch\f1 
tivities other than copying, distribution and modification are not 
\par \hich\af1\dbch\af31505\loch\f1 covered by this License; they are 
outside its scope.  The act of 
\par \hich\af1\dbch\af31505\loch\f1 running the Program is not 
restricted, and the output from the Program 
\par \hich\af1\dbch\af31505\loch\f1 is covered only if its contents 
constitute a work bas\hich\af1\dbch\af31505\loch\f1 ed on the 
\par \hich\af1\dbch\af31505\loch\f1 Program (independent of having 
been made by running the Program). 
\par \hich\af1\dbch\af31505\loch\f1 Whether that is true depends on 
what the Program does. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   1. You may copy and distribute 
verbatim copies of the Program's 
\par \hich\af1\dbch\af31505\loch\f1 source code as you receive it, in 
any medium, provided that you 
\par \hich\af1\dbch\af31505\loch\f1 conspicuously and appropriately 
publish on each copy an appropriate 
\par \hich\af1\dbch\af31505\loch\f1 copyright notice and disclaimer of 
warranty; keep intact all the 
\par \hich\af1\dbch\af31505\loch\f1 notices that refer to this License 
and to the absence of an\hich\af1\dbch\af31505\loch\f1 y warranty; 
\par \hich\af1\dbch\af31505\loch\f1 and give any other recipients of 
the Program a copy of this License 
\par \hich\af1\dbch\af31505\loch\f1 along with the Program. 
\par 
\par \hich\af1\dbch\af31505\loch\f1 You may charge a fee for the 
physical act of transferring a copy, and 
\par \hich\af1\dbch\af31505\loch\f1 you may at your option offer 
warranty protection in exchange for a fee. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   2. You\hich\af1\dbch\af31505\loch 
\f1  may modify your copy or copies of the Program or any portion 
\par \hich\af1\dbch\af31505\loch\f1 of it, thus forming a work based 
on the Program, and copy and 
\par \hich\af1\dbch\af31505\loch\f1 distribute such modifications or 
work under the terms of Section 1 
\par \hich\af1\dbch\af31505\loch\f1 above, provided that you also meet 
all of these conditions: 
\par 
\par \hich\af1\dbch\af31505\loch\f1     \hich\af1\dbch\af31505\loch\f1 
a) You must cause the modified files to carry prominent notices 
\par \hich\af1\dbch\af31505\loch\f1     stating that you changed the 
files and the date of any change. 
\par 
\par \hich\af1\dbch\af31505\loch\f1     b) You must cause any work 
that you distribute or publish, that in 
\par \hich\af1\dbch\af31505\loch\f1     whole or in part contains or 
is derived from the \hich\af1\dbch\af31505\loch\f1 Program or any 
\par \hich\af1\dbch\af31505\loch\f1     part thereof, to be licensed 
as a whole at no charge to all third 
\par \hich\af1\dbch\af31505\loch\f1     parties under the terms of 
this License. 
\par 
\par \hich\af1\dbch\af31505\loch\f1     c) If the modified program 
normally reads commands interactively 
\par \hich\af1\dbch\af31505\loch\f1     when run, you must cause it, 
when started running fo\hich\af1\dbch\af31505\loch\f1 r such 
\par \hich\af1\dbch\af31505\loch\f1     interactive use in the most 
ordinary way, to print or display an 
\par \hich\af1\dbch\af31505\loch\f1     announcement including an 
appropriate copyright notice and a 
\par \hich\af1\dbch\af31505\loch\f1     notice that there is no 
warranty (or else, saying that you provide 
\par \hich\af1\dbch\af31505\loch\f1     a warranty) and that users may 
redistrib\hich\af1\dbch\af31505\loch\f1 ute the program under 
\par \hich\af1\dbch\af31505\loch\f1     these conditions, and telling 
the user how to view a copy of this 
\par \hich\af1\dbch\af31505\loch\f1     License.  (Exception: if the 
Program itself is interactive but 
\par \hich\af1\dbch\af31505\loch\f1     does not normally print such 
an announcement, your work based on 
\par \hich\af1\dbch\af31505\loch\f1     the Program is not required to 
print an announcement.) 
\par 
\par \hich\af1\dbch\af31505\loch\f1 These requirements apply to the 
modified work as a whole.  If 
\par \hich\af1\dbch\af31505\loch\f1 identifiable sections of that work 
are not derived from the Program, 
\par \hich\af1\dbch\af31505\loch\f1 and can be reasonably considered 
independent and separate works i\hich\af1\dbch\af31505\loch\f1 n 
\par \hich\af1\dbch\af31505\loch\f1 themselves, then this License, and 
its terms, do not apply to those 
\par \hich\af1\dbch\af31505\loch\f1 sections when you distribute them 
as separate works.  But when you 
\par \hich\af1\dbch\af31505\loch\f1 distribute the same sections as 
part of a whole which is a work based 
\par \hich\af1\dbch\af31505\loch\f1 on the Program, the distribution 
of the whole mus\hich\af1\dbch\af31505\loch\f1 t be on the terms of 
\par \hich\af1\dbch\af31505\loch\f1 this License, whose permissions 
for other licensees extend to the 
\par \hich\af1\dbch\af31505\loch\f1 entire whole, and thus to each and 
every part regardless of who wrote it. 
\par 
\par \hich\af1\dbch\af31505\loch\f1 Thus, it is not the intent of this 
section to claim rights or contest 
\par \hich\af1\dbch\af31505\loch\f1 your rights to work writ\hich 
\af1\dbch\af31505\loch\f1 ten entirely by you; rather, the intent is 
to 
\par \hich\af1\dbch\af31505\loch\f1 exercise the right to control the 
distribution of derivative or 
\par \hich\af1\dbch\af31505\loch\f1 collective works based on the 
Program. 
\par 
\par \hich\af1\dbch\af31505\loch\f1 In addition, mere aggregation of 
another work not based on the Program 
\par \hich\af1\dbch\af31505\loch\f1 with the Program (or with a work ba 
\hich\af1\dbch\af31505\loch\f1 sed on the Program) on a volume of 
\par \hich\af1\dbch\af31505\loch\f1 a storage or distribution medium 
does not bring the other work under 
\par \hich\af1\dbch\af31505\loch\f1 the scope of this License. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   3. You may copy and distribute 
the Program (or a work based on it, 
\par \hich\af1\dbch\af31505\loch\f1 under Section 2) in object code or 
executable form unde\hich\af1\dbch\af31505\loch\f1 r the terms of 
\par \hich\af1\dbch\af31505\loch\f1 Sections 1 and 2 above provided 
that you also do one of the following: 
\par 
\par \hich\af1\dbch\af31505\loch\f1     a) Accompany it with the 
complete corresponding machine-readable 
\par \hich\af1\dbch\af31505\loch\f1     source code, which must be 
distributed under the terms of Sections 
\par \hich\af1\dbch\af31505\loch\f1     1 and 2 above on a medium 
customarily used for software interchange; or, 
\par 
\par \hich\af1\dbch\af31505\loch\f1     b) Accompany it with a written 
offer, valid for at least three 
\par \hich\af1\dbch\af31505\loch\f1     years, to give any third 
party, for a charge no more than your 
\par \hich\af1\dbch\af31505\loch\f1     cost of physically performing 
source dis\hich\af1\dbch\af31505\loch\f1 tribution, a complete 
\par \hich\af1\dbch\af31505\loch\f1     machine-readable copy of the 
corresponding source code, to be 
\par \hich\af1\dbch\af31505\loch\f1     distributed under the terms of 
Sections 1 and 2 above on a medium 
\par \hich\af1\dbch\af31505\loch\f1     customarily used for software 
interchange; or, 
\par 
\par \hich\af1\dbch\af31505\loch\f1     c) Accompany it with the 
information you r\hich\af1\dbch\af31505\loch\f1 eceived as to the 
offer 
\par \hich\af1\dbch\af31505\loch\f1     to distribute corresponding 
source code.  (This alternative is 
\par \hich\af1\dbch\af31505\loch\f1     allowed only for noncommercial 
distribution and only if you 
\par \hich\af1\dbch\af31505\loch\f1     received the program in object 
code or executable form with such 
\par \hich\af1\dbch\af31505\loch\f1     an offer, in accord with Sub 
\hich\af1\dbch\af31505\loch\f1 section b above.) 
\par 
\par \hich\af1\dbch\af31505\loch\f1 The source code for a work means 
the preferred form of the work for 
\par \hich\af1\dbch\af31505\loch\f1 making modifications to it.  For 
an executable work, complete source 
\par \hich\af1\dbch\af31505\loch\f1 code means all the source code for 
all modules it contains, plus any 
\par \hich\af1\dbch\af31505\loch\f1 associated interface definition 
\hich\af1\dbch\af31505\loch\f1  files, plus the scripts used to 
\par \hich\af1\dbch\af31505\loch\f1 control compilation and 
installation of the executable.  However, as a 
\par \hich\af1\dbch\af31505\loch\f1 special exception, the source code 
distributed need not include 
\par \hich\af1\dbch\af31505\loch\f1 anything that is normally 
distributed (in either source or binary 
\par \hich\af1\dbch\af31505\loch\f1 form) with the major c\hich 
\af1\dbch\af31505\loch\f1 omponents (compiler, kernel, and so on) of 
the 
\par \hich\af1\dbch\af31505\loch\f1 operating system on which the 
executable runs, unless that component 
\par \hich\af1\dbch\af31505\loch\f1 itself accompanies the executable. 
\par 
\par \hich\af1\dbch\af31505\loch\f1 If distribution of executable or 
object code is made by offering 
\par \hich\af1\dbch\af31505\loch\f1 access to copy from a designated 
place, then offering equivalent 
\par \hich\af1\dbch\af31505\loch\f1 access to copy the source code 
from the same place counts as 
\par \hich\af1\dbch\af31505\loch\f1 distribution of the source code, 
even though third parties are not 
\par \hich\af1\dbch\af31505\loch\f1 compelled to copy the source along 
with the object code. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   4. \hich\af1\dbch\af31505\loch 
\f1 You may not copy, modify, sublicense, or distribute the Program 
\par \hich\af1\dbch\af31505\loch\f1 except as expressly provided under 
this License.  Any attempt 
\par \hich\af1\dbch\af31505\loch\f1 otherwise to copy, modify, 
sublicense or distribute the Program is 
\par \hich\af1\dbch\af31505\loch\f1 void, and will automatically 
terminate your rights under this L\hich\af1\dbch\af31505\loch\f1 
icense. 
\par \hich\af1\dbch\af31505\loch\f1 However, parties who have received 
copies, or rights, from you under 
\par \hich\af1\dbch\af31505\loch\f1 this License will not have their 
licenses terminated so long as such 
\par \hich\af1\dbch\af31505\loch\f1 parties remain in full compliance. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   5. You are not required to 
accept this License, since you have not 
\par \hich\af1\dbch\af31505\loch\f1 signe\hich\af1\dbch\af31505\loch 
\f1 d it.  However, nothing else grants you permission to modify or 
\par \hich\af1\dbch\af31505\loch\f1 distribute the Program or its 
derivative works.  These actions are 
\par \hich\af1\dbch\af31505\loch\f1 prohibited by law if you do not 
accept this License.  Therefore, by 
\par \hich\af1\dbch\af31505\loch\f1 modifying or distributing the 
Program (or any work based \hich\af1\dbch\af31505\loch\f1 on the 
\par \hich\af1\dbch\af31505\loch\f1 Program), you indicate your 
acceptance of this License to do so, and 
\par \hich\af1\dbch\af31505\loch\f1 all its terms and conditions for 
copying, distributing or modifying 
\par \hich\af1\dbch\af31505\loch\f1 the Program or works based on it. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   6. Each time you redistribute 
the Program (or any work based on the 
\par \hich\af1\dbch\af31505\loch\f1 Program\hich\af1\dbch\af31505\loch 
\f1 ), the recipient automatically receives a license from the 
\par \hich\af1\dbch\af31505\loch\f1 original licensor to copy, 
distribute or modify the Program subject to 
\par \hich\af1\dbch\af31505\loch\f1 these terms and conditions.  You 
may not impose any further 
\par \hich\af1\dbch\af31505\loch\f1 restrictions on the recipients' 
exercise of the rights granted her\hich\af1\dbch\af31505\loch\f1 ein. 
\par \hich\af1\dbch\af31505\loch\f1 You are not responsible for 
enforcing compliance by third parties to 
\par \hich\af1\dbch\af31505\loch\f1 this License. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   7. If, as a consequence of a 
court judgment or allegation of patent 
\par \hich\af1\dbch\af31505\loch\f1 infringement or for any other 
reason (not limited to patent issues), 
\par \hich\af1\dbch\af31505\loch\f1 conditions are imposed on you 
(whether by court order, agreement or 
\par \hich\af1\dbch\af31505\loch\f1 otherwise) that contradict the 
conditions of this License, they do not 
\par \hich\af1\dbch\af31505\loch\f1 excuse you from the conditions of 
this License.  If you cannot 
\par \hich\af1\dbch\af31505\loch\f1 distribute so as to satisfy 
simultaneously your obliga\hich\af1\dbch\af31505\loch\f1 tions under 
this 
\par \hich\af1\dbch\af31505\loch\f1 License and any other pertinent 
obligations, then as a consequence you 
\par \hich\af1\dbch\af31505\loch\f1 may not distribute the Program at 
all.  For example, if a patent 
\par \hich\af1\dbch\af31505\loch\f1 license would not permit royalty- 
free redistribution of the Program by 
\par \hich\af1\dbch\af31505\loch\f1 all those who receive copies dir 
\hich\af1\dbch\af31505\loch\f1 ectly or indirectly through you, then 
\par \hich\af1\dbch\af31505\loch\f1 the only way you could satisfy 
both it and this License would be to 
\par \hich\af1\dbch\af31505\loch\f1 refrain entirely from distribution 
of the Program. 
\par 
\par \hich\af1\dbch\af31505\loch\f1 If any portion of this section is 
held invalid or unenforceable under 
\par \hich\af1\dbch\af31505\loch\f1 any particular circumstance,\hich 
\af1\dbch\af31505\loch\f1  the balance of the section is intended to 
\par \hich\af1\dbch\af31505\loch\f1 apply and the section as a whole 
is intended to apply in other 
\par \hich\af1\dbch\af31505\loch\f1 circumstances. 
\par 
\par \hich\af1\dbch\af31505\loch\f1 It is not the purpose of this 
section to induce you to infringe any 
\par \hich\af1\dbch\af31505\loch\f1 patents or other property right 
claims or to contest validity of a\hich\af1\dbch\af31505\loch\f1 ny 
\par \hich\af1\dbch\af31505\loch\f1 such claims; this section has the 
sole purpose of protecting the 
\par \hich\af1\dbch\af31505\loch\f1 integrity of the free software 
distribution system, which is 
\par \hich\af1\dbch\af31505\loch\f1 implemented by public license 
practices.  Many people have made 
\par \hich\af1\dbch\af31505\loch\f1 generous contributions to the wide 
range of software distribute\hich\af1\dbch\af31505\loch\f1 d 
\par \hich\af1\dbch\af31505\loch\f1 through that system in reliance on 
consistent application of that 
\par \hich\af1\dbch\af31505\loch\f1 system; it is up to the author/ 
donor to decide if he or she is willing 
\par \hich\af1\dbch\af31505\loch\f1 to distribute software through any 
other system and a licensee cannot 
\par \hich\af1\dbch\af31505\loch\f1 impose that choice. 
\par 
\par \hich\af1\dbch\af31505\loch\f1 This section is intended to make 
thoroughly clear what is believed to 
\par \hich\af1\dbch\af31505\loch\f1 be a consequence of the rest of 
this License. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   8. If the distribution and/or 
use of the Program is restricted in 
\par \hich\af1\dbch\af31505\loch\f1 certain countries either by 
patents or by copyrighted interfaces, the 
\par \hich\af1\dbch\af31505\loch\f1 o\hich\af1\dbch\af31505\loch\f1 
riginal copyright holder who places the Program under this License 
\par \hich\af1\dbch\af31505\loch\f1 may add an explicit geographical 
distribution limitation excluding 
\par \hich\af1\dbch\af31505\loch\f1 those countries, so that 
distribution is permitted only in or among 
\par \hich\af1\dbch\af31505\loch\f1 countries not thus excluded.  In 
such case, this Licen\hich\af1\dbch\af31505\loch\f1 se incorporates 
\par \hich\af1\dbch\af31505\loch\f1 the limitation as if written in 
the body of this License. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   9. The Free Software Foundation 
may publish revised and/or new versions 
\par \hich\af1\dbch\af31505\loch\f1 of the General Public License from 
time to time.  Such new versions will 
\par \hich\af1\dbch\af31505\loch\f1 be similar in spirit to the presen 
\hich\af1\dbch\af31505\loch\f1 t version, but may differ in detail to 
\par \hich\af1\dbch\af31505\loch\f1 address new problems or concerns. 
\par 
\par \hich\af1\dbch\af31505\loch\f1 Each version is given a 
distinguishing version number.  If the Program 
\par \hich\af1\dbch\af31505\loch\f1 specifies a version number of this 
License which applies to it and "any 
\par \hich\af1\dbch\af31505\loch\f1 later version", you have the 
option of \hich\af1\dbch\af31505\loch\f1 following the terms and 
conditions 
\par \hich\af1\dbch\af31505\loch\f1 either of that version or of any 
later version published by the Free 
\par \hich\af1\dbch\af31505\loch\f1 Software Foundation.  If the 
Program does not specify a version number of 
\par \hich\af1\dbch\af31505\loch\f1 this License, you may choose any 
version ever published by the Free Software 
\par \hich\af1\dbch\af31505\loch\f1 F\hich\af1\dbch\af31505\loch\f1 
oundation. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   10. If you wish to incorporate 
parts of the Program into other free 
\par \hich\af1\dbch\af31505\loch\f1 programs whose distribution 
conditions are different, write to the author 
\par \hich\af1\dbch\af31505\loch\f1 to ask for permission.  For 
software which is copyrighted by the Free 
\par \hich\af1\dbch\af31505\loch\f1 Software Foundation, write to \hich 
\af1\dbch\af31505\loch\f1 the Free Software Foundation; we sometimes 
\par \hich\af1\dbch\af31505\loch\f1 make exceptions for this.  Our 
decision will be guided by the two goals 
\par \hich\af1\dbch\af31505\loch\f1 of preserving the free status of 
all derivatives of our free software and 
\par \hich\af1\dbch\af31505\loch\f1 of promoting the sharing and reuse 
of software generally. 
\par 
\par \tab \tab \tab \hich\af1\dbch\af31505\loch\f1     NO WARRANTY 
\par 
\par \hich\af1\dbch\af31505\loch\f1   11. BECAUSE THE PROGRAM IS 
LICENSED FREE OF CHARGE, THERE IS NO WARRANTY 
\par \hich\af1\dbch\af31505\loch\f1 FOR THE PROGRAM, TO THE EXTENT 
PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN 
\par \hich\af1\dbch\af31505\loch\f1 OTHERWISE STATED IN WRITING THE 
COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
\par \hich\af1\dbch\af31505\loch\f1 PROVIDE THE PROGR\hich\af1\dbch 
\af31505\loch\f1 AM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER 
EXPRESSED 
\par \hich\af1\dbch\af31505\loch\f1 OR IMPLIED, INCLUDING, BUT NOT 
LIMITED TO, THE IMPLIED WARRANTIES OF 
\par \hich\af1\dbch\af31505\loch\f1 MERCHANTABILITY AND FITNESS FOR A 
PARTICULAR PURPOSE.  THE ENTIRE RISK AS 
\par \hich\af1\dbch\af31505\loch\f1 TO THE QUALITY AND PERFORMANCE OF 
THE PROGRAM IS WITH Y\hich\af1\dbch\af31505\loch\f1 OU.  SHOULD THE 
\par \hich\af1\dbch\af31505\loch\f1 PROGRAM PROVE DEFECTIVE, YOU 
ASSUME THE COST OF ALL NECESSARY SERVICING, 
\par \hich\af1\dbch\af31505\loch\f1 REPAIR OR CORRECTION. 
\par 
\par \hich\af1\dbch\af31505\loch\f1   12. IN NO EVENT UNLESS REQUIRED 
BY APPLICABLE LAW OR AGREED TO IN WRITING 
\par \hich\af1\dbch\af31505\loch\f1 WILL ANY COPYRIGHT HOLDER, OR ANY 
OTHER PARTY WHO MAY MODIFY AND/OR 
\par \hich\af1\dbch\af31505\loch\f1 REDISTRIBUTE THE PROGRAM AS 
PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, 
\par \hich\af1\dbch\af31505\loch\f1 INCLUDING ANY GENERAL, SPECIAL, 
INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING 
\par \hich\af1\dbch\af31505\loch\f1 OUT OF THE USE OR INABILITY TO USE 
THE PROGRAM (INCLUDING BUT NOT LIMITED 
\par \hich\af1\dbch\af31505\loch\f1 TO LOSS OF DATA OR DATA BEING R 
\hich\af1\dbch\af31505\loch\f1 ENDERED INACCURATE OR LOSSES SUSTAINED 
BY 
\par \hich\af1\dbch\af31505\loch\f1 YOU OR THIRD PARTIES OR A FAILURE 
OF THE PROGRAM TO OPERATE WITH ANY OTHER 
\par \hich\af1\dbch\af31505\loch\f1 PROGRAMS), EVEN IF SUCH HOLDER OR 
OTHER PARTY HAS BEEN ADVISED OF THE 
\par \hich\af1\dbch\af31505\loch\f1 POSSIBILITY OF SUCH DAMAGES. 
\par 
\par \tab \tab \hich\af1\dbch\af31505\loch\f1      END OF TERMS AND 
CONDITIONS 
\par }{\rtlch\fcs1 \af31507 \ltrch\fcs0 
\insrsid13860386\charrsid2444995 
\par }{\*\themedata 
504b030414000600080000002100e9de0fbfff0000001c020000130000005b436f6e74656e745f54797065735d2e786d6cac91cb4ec3301045f748fc83e52d4a 
9cb2400825e982c78ec7a27cc0c8992416c9d8b2a755fbf74cd25442a820166c2cd933f79e3be372bd1f07b5c3989ca74aaff2422b24eb1b475da5df374fd9ad 
5689811a183c61a50f98f4babebc2837878049899a52a57be670674cb23d8e90721f90a4d2fa3802cb35762680fd800ecd7551dc18eb899138e3c943d7e503b6 
b01d583deee5f99824e290b4ba3f364eac4a430883b3c092d4eca8f946c916422ecab927f52ea42b89a1cd59c254f919b0e85e6535d135a8de20f20b8c12c3b0 
0c895fcf6720192de6bf3b9e89ecdbd6596cbcdd8eb28e7c365ecc4ec1ff1460f53fe813d3cc7f5b7f020000ffff0300504b030414000600080000002100a5d6 
a7e7c0000000360100000b0000005f72656c732f2e72656c73848fcf6ac3300c87ef85bd83d17d51d2c31825762fa590432fa37d00e1287f68221bdb1bebdb4f 
c7060abb0884a4eff7a93dfeae8bf9e194e720169aaa06c3e2433fcb68e1763dbf7f82c985a4a725085b787086a37bdbb55fbc50d1a33ccd311ba548b6309512 
0f88d94fbc52ae4264d1c910d24a45db3462247fa791715fd71f989e19e0364cd3f51652d73760ae8fa8c9ffb3c330cc9e4fc17faf2ce545046e37944c69e462 
a1a82fe353bd90a865aad41ed0b5b8f9d6fd010000ffff0300504b0304140006000800000021006b799616830000008a0000001c0000007468656d652f746865 
6d652f7468656d654d616e616765722e786d6c0ccc4d0ac3201040e17da17790d93763bb284562b2cbaebbf600439c1a41c7a0d29fdbd7e5e38337cedf14d59b 
4b0d592c9c070d8a65cd2e88b7f07c2ca71ba8da481cc52c6ce1c715e6e97818c9b48d13df49c873517d23d59085adb5dd20d6b52bd521ef2cdd5eb9246a3d8b 
4757e8d3f729e245eb2b260a0238fd010000ffff0300504b03041400060008000000210030dd4329a8060000a41b0000160000007468656d652f7468656d652f 
7468656d65312e786d6cec594f6fdb3614bf0fd87720746f6327761a07758ad8b19b2d4d1bc46e871e698996d850a240d2497d1bdae38001c3ba618715d86d87 
615b8116d8a5fb34d93a6c1dd0afb0475292c5585e9236d88aad3e2412f9e3fbff1e1fa9abd7eec70c1d1221294fda5efd72cd4324f1794093b0eddd1ef62fad 
79482a9c0498f184b4bd2991deb58df7dfbb8ad755446282607d22d771db8b944ad79796a40fc3585ee62949606ecc458c15bc8a702910f808e8c66c69b9565b 
5d8a314d3c94e018c8de1a8fa94fd05093f43672e23d06af89927ac06762a049136785c10607758d9053d965021d62d6f6804fc08f86e4bef210c352c144dbab 
999fb7b4717509af678b985ab0b6b4ae6f7ed9ba6c4170b06c788a705430adf71bad2b5b057d03606a1ed7ebf5babd7a41cf00b0ef83a6569632cd467faddec9 
699640f6719e76b7d6ac355c7c89feca9cccad4ea7d36c65b258a206641f1b73f8b5da6a6373d9c11b90c537e7f08dce66b7bbeae00dc8e257e7f0fd2badd586 
8b37a088d1e4600ead1ddaef67d40bc898b3ed4af81ac0d76a197c86826828a24bb318f3442d8ab518dfe3a20f000d6458d104a9694ac6d88728eee2782428d6 
0cf03ac1a5193be4cbb921cd0b495fd054b5bd0f530c1931a3f7eaf9f7af9e3f45c70f9e1d3ff8e9f8e1c3e3073f5a42ceaa6d9c84e5552fbffdeccfc71fa33f 
9e7ef3f2d117d57859c6fffac327bffcfc793510d26726ce8b2f9ffcf6ecc98baf3efdfdbb4715f04d814765f890c644a29be408edf3181433567125272371be 
15c308d3f28acd249438c19a4b05fd9e8a1cf4cd296699771c393ac4b5e01d01e5a30a787d72cf1178108989a2159c77a2d801ee72ce3a5c545a6147f32a9979 
3849c26ae66252c6ed637c58c5bb8b13c7bfbd490a75330f4b47f16e441c31f7184e140e494214d273fc80900aedee52ead87597fa824b3e56e82e451d4c2b4d 
32a423279a668bb6690c7e9956e90cfe766cb37b077538abd27a8b1cba48c80acc2a841f12e698f13a9e281c57911ce298950d7e03aba84ac8c154f8655c4f2a 
f074481847bd804859b5e696007d4b4edfc150b12addbecba6b18b148a1e54d1bc81392f23b7f84137c2715a851dd0242a633f900710a218ed715505dfe56e86 
e877f0034e16bafb0e258ebb4faf06b769e888340b103d331115bebc4eb813bf83291b63624a0d1475a756c734f9bbc2cd28546ecbe1e20a3794ca175f3fae90 
fb6d2dd99bb07b55e5ccf68942bd0877b23c77b908e8db5f9db7f024d9239010f35bd4bbe2fcae387bfff9e2bc289f2fbe24cfaa301468dd8bd846dbb4ddf1c2 
ae7b4c191ba8292337a469bc25ec3d411f06f53a73e224c5292c8de0516732307070a1c0660d125c7d44553488700a4d7bddd3444299910e254ab984c3a219ae 
a4adf1d0f82b7bd46cea4388ad1c12ab5d1ed8e1153d9c9f350a3246aad01c6873462b9ac05999ad5cc988826eafc3acae853a33b7ba11cd1445875ba1b236b1 
399483c90bd560b0b0263435085a21b0f22a9cf9356b38ec6046026d77eba3dc2dc60b17e92219e180643ed27acffba86e9c94c7ca9c225a0f1b0cfae0788ad5 
4adc5a9aec1b703b8b93caec1a0bd8e5de7b132fe5113cf312503b998e2c2927274bd051db6b35979b1ef271daf6c6704e86c73805af4bdd476216c26593af84 
0dfb5393d964f9cc9bad5c313709ea70f561ed3ea7b053075221d51696910d0d339585004b34272bff7213cc7a510a5454a3b349b1b206c1f0af490176745d4b 
c663e2abb2b34b23da76f6352ba57ca2881844c1111ab189d8c7e07e1daaa04f40255c77988aa05fe06e4e5bdb4cb9c5394bbaf28d98c1d971ccd20867e556a7 
689ec9166e0a522183792b8907ba55ca6e943bbf2a26e52f48957218ffcf54d1fb09dc3eac04da033e5c0d0b8c74a6b43d2e54c4a10aa511f5fb021a07533b20 
5ae07e17a621a8e082dafc17e450ffb739676998b48643a4daa7211214f623150942f6a02c99e83b85583ddbbb2c4996113211551257a656ec1139246ca86be0 
aadedb3d1441a89b6a929501833b197fee7b9641a3503739e57c732a59b1f7da1cf8a73b1f9bcca0945b874d4393dbbf10b1680f66bbaa5d6f96e77b6f59113d 
316bb31a795600b3d256d0cad2fe354538e7566b2bd69cc6cbcd5c38f0e2bcc63058344429dc2121fd07f63f2a7c66bf76e80d75c8f7a1b622f878a18941d840 
545fb28d07d205d20e8ea071b283369834296bdaac75d256cb37eb0bee740bbe278cad253b8bbfcf69eca23973d939b97891c6ce2cecd8da8e2d343578f6648a 
c2d0383fc818c798cf64e52f597c740f1cbd05df0c264c49134cf09d4a60e8a107260f20f92d47b374e32f000000ffff0300504b030414000600080000002100 
0dd1909fb60000001b010000270000007468656d652f7468656d652f5f72656c732f7468656d654d616e616765722e786d6c2e72656c73848f4d0ac2301484f7 
8277086f6fd3ba109126dd88d0add40384e4350d363f2451eced0dae2c082e8761be9969bb979dc9136332de3168aa1a083ae995719ac16db8ec8e4052164e89 
d93b64b060828e6f37ed1567914b284d262452282e3198720e274a939cd08a54f980ae38a38f56e422a3a641c8bbd048f7757da0f19b017cc524bd62107bd500 
1996509affb3fd381a89672f1f165dfe514173d9850528a2c6cce0239baa4c04ca5bbabac4df000000ffff0300504b01022d0014000600080000002100e9de0f 
bfff0000001c0200001300000000000000000000000000000000005b436f6e74656e745f54797065735d2e786d6c504b01022d0014000600080000002100a5d6 
a7e7c0000000360100000b00000000000000000000000000300100005f72656c732f2e72656c73504b01022d00140006000800000021006b799616830000008a 
0000001c00000000000000000000000000190200007468656d652f7468656d652f7468656d654d616e616765722e786d6c504b01022d00140006000800000021 
0030dd4329a8060000a41b00001600000000000000000000000000d60200007468656d652f7468656d652f7468656d65312e786d6c504b01022d001400060008 
00000021000dd1909fb60000001b0100002700000000000000000000000000b20900007468656d652f7468656d652f5f72656c732f7468656d654d616e616765722e786d6c2e72656c73504b050600000000050005005d010000ad0a00000000} 
{\*\colorschememapping 
3c3f786d6c2076657273696f6e3d22312e302220656e636f64696e673d225554462d3822207374616e64616c6f6e653d22796573223f3e0d0a3c613a636c724d 
617020786d6c6e733a613d22687474703a2f2f736368656d61732e6f70656e786d6c666f726d6174732e6f72672f64726177696e676d6c2f323030362f6d6169 
6e22206267313d226c743122207478313d22646b3122206267323d226c743222207478323d22646b322220616363656e74313d22616363656e74312220616363 
656e74323d22616363656e74322220616363656e74333d22616363656e74332220616363656e74343d22616363656e74342220616363656e74353d22616363656e74352220616363656e74363d22616363656e74362220686c696e6b3d22686c696e6b2220666f6c486c696e6b3d22666f6c486c696e6b222f3e} 
{\*\latentstyles 
\lsdstimax267\lsdlockeddef0\lsdsemihiddendef1\lsdunhideuseddef1\lsdqformatdef0\lsdprioritydef99{\lsdlockedexcept 
\lsdsemihidden0 \lsdunhideused0 \lsdqformat1 \lsdpriority0 \lsdlocked0 
Normal; 
\lsdsemihidden0 \lsdunhideused0 \lsdqformat1 \lsdpriority9 \lsdlocked0 
heading 1;\lsdqformat1 \lsdpriority9 \lsdlocked0 heading 
2;\lsdqformat1 \lsdpriority9 \lsdlocked0 heading 3;\lsdqformat1 
\lsdpriority9 \lsdlocked0 heading 4; 
\lsdqformat1 \lsdpriority9 \lsdlocked0 heading 5;\lsdqformat1 
\lsdpriority9 \lsdlocked0 heading 6;\lsdqformat1 \lsdpriority9 
\lsdlocked0 heading 7;\lsdqformat1 \lsdpriority9 \lsdlocked0 heading 
8;\lsdqformat1 \lsdpriority9 \lsdlocked0 heading 9; 
\lsdpriority39 \lsdlocked0 toc 1;\lsdpriority39 \lsdlocked0 toc 
2;\lsdpriority39 \lsdlocked0 toc 3;\lsdpriority39 \lsdlocked0 toc 
4;\lsdpriority39 \lsdlocked0 toc 5;\lsdpriority39 \lsdlocked0 toc 
6;\lsdpriority39 \lsdlocked0 toc 7; 
\lsdpriority39 \lsdlocked0 toc 8;\lsdpriority39 \lsdlocked0 toc 
9;\lsdqformat1 \lsdpriority35 \lsdlocked0 caption;\lsdsemihidden0 
\lsdunhideused0 \lsdqformat1 \lsdpriority10 \lsdlocked0 Title; 
\lsdpriority1 \lsdlocked0 Default Paragraph Font; 
\lsdsemihidden0 \lsdunhideused0 \lsdqformat1 \lsdpriority11 
\lsdlocked0 Subtitle;\lsdsemihidden0 \lsdunhideused0 \lsdqformat1 
\lsdpriority22 \lsdlocked0 Strong;\lsdsemihidden0 \lsdunhideused0 
\lsdqformat1 \lsdpriority20 \lsdlocked0 Emphasis; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority59 \lsdlocked0 Table Grid; 
\lsdunhideused0 \lsdlocked0 Placeholder Text;\lsdsemihidden0 
\lsdunhideused0 \lsdqformat1 \lsdpriority1 \lsdlocked0 No Spacing; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority60 \lsdlocked0 Light 
Shading;\lsdsemihidden0 \lsdunhideused0 \lsdpriority61 \lsdlocked0 
Light List;\lsdsemihidden0 \lsdunhideused0 \lsdpriority62 \lsdlocked0 
Light Grid; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority63 \lsdlocked0 Medium 
Shading 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority64 \lsdlocked0 
Medium Shading 2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority65 
\lsdlocked0 Medium List 1; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority66 \lsdlocked0 Medium List 
2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority67 \lsdlocked0 Medium 
Grid 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority68 \lsdlocked0 
Medium Grid 2; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority69 \lsdlocked0 Medium Grid 
3;\lsdsemihidden0 \lsdunhideused0 \lsdpriority70 \lsdlocked0 Dark List; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority71 \lsdlocked0 Colorful 
Shading; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority72 \lsdlocked0 Colorful 
List;\lsdsemihidden0 \lsdunhideused0 \lsdpriority73 \lsdlocked0 
Colorful Grid;\lsdsemihidden0 \lsdunhideused0 \lsdpriority60 
\lsdlocked0 Light Shading Accent 1; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority61 \lsdlocked0 Light List 
Accent 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority62 \lsdlocked0 
Light Grid Accent 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority63 
\lsdlocked0 Medium Shading 1 Accent 1; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority64 \lsdlocked0 Medium 
Shading 2 Accent 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority65 
\lsdlocked0 Medium List 1 Accent 1;\lsdunhideused0 \lsdlocked0 
Revision; 
\lsdsemihidden0 \lsdunhideused0 \lsdqformat1 \lsdpriority34 
\lsdlocked0 List Paragraph;\lsdsemihidden0 \lsdunhideused0 
\lsdqformat1 \lsdpriority29 \lsdlocked0 Quote;\lsdsemihidden0 
\lsdunhideused0 \lsdqformat1 \lsdpriority30 \lsdlocked0 Intense Quote; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority66 \lsdlocked0 Medium List 
2 Accent 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority67 \lsdlocked0 
Medium Grid 1 Accent 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority68 
\lsdlocked0 Medium Grid 2 Accent 1; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority69 \lsdlocked0 Medium Grid 
3 Accent 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority70 \lsdlocked0 
Dark List Accent 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority71 
\lsdlocked0 Colorful Shading Accent 1; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority72 \lsdlocked0 Colorful 
List Accent 1;\lsdsemihidden0 \lsdunhideused0 \lsdpriority73 
\lsdlocked0 Colorful Grid Accent 1;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority60 \lsdlocked0 Light Shading Accent 2; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority61 \lsdlocked0 Light List 
Accent 2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority62 \lsdlocked0 
Light Grid Accent 2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority63 
\lsdlocked0 Medium Shading 1 Accent 2; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority64 \lsdlocked0 Medium 
Shading 2 Accent 2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority65 
\lsdlocked0 Medium List 1 Accent 2;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority66 \lsdlocked0 Medium List 2 Accent 2; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority67 \lsdlocked0 Medium Grid 
1 Accent 2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority68 \lsdlocked0 
Medium Grid 2 Accent 2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority69 
\lsdlocked0 Medium Grid 3 Accent 2; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority70 \lsdlocked0 Dark List 
Accent 2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority71 \lsdlocked0 
Colorful Shading Accent 2;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority72 \lsdlocked0 Colorful List Accent 2; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority73 \lsdlocked0 Colorful 
Grid Accent 2;\lsdsemihidden0 \lsdunhideused0 \lsdpriority60 
\lsdlocked0 Light Shading Accent 3;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority61 \lsdlocked0 Light List Accent 3; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority62 \lsdlocked0 Light Grid 
Accent 3;\lsdsemihidden0 \lsdunhideused0 \lsdpriority63 \lsdlocked0 
Medium Shading 1 Accent 3;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority64 \lsdlocked0 Medium Shading 2 Accent 3; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority65 \lsdlocked0 Medium List 
1 Accent 3;\lsdsemihidden0 \lsdunhideused0 \lsdpriority66 \lsdlocked0 
Medium List 2 Accent 3;\lsdsemihidden0 \lsdunhideused0 \lsdpriority67 
\lsdlocked0 Medium Grid 1 Accent 3; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority68 \lsdlocked0 Medium Grid 
2 Accent 3;\lsdsemihidden0 \lsdunhideused0 \lsdpriority69 \lsdlocked0 
Medium Grid 3 Accent 3;\lsdsemihidden0 \lsdunhideused0 \lsdpriority70 
\lsdlocked0 Dark List Accent 3; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority71 \lsdlocked0 Colorful 
Shading Accent 3;\lsdsemihidden0 \lsdunhideused0 \lsdpriority72 
\lsdlocked0 Colorful List Accent 3;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority73 \lsdlocked0 Colorful Grid Accent 3; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority60 \lsdlocked0 Light 
Shading Accent 4;\lsdsemihidden0 \lsdunhideused0 \lsdpriority61 
\lsdlocked0 Light List Accent 4;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority62 \lsdlocked0 Light Grid Accent 4; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority63 \lsdlocked0 Medium 
Shading 1 Accent 4;\lsdsemihidden0 \lsdunhideused0 \lsdpriority64 
\lsdlocked0 Medium Shading 2 Accent 4;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority65 \lsdlocked0 Medium List 1 Accent 4; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority66 \lsdlocked0 Medium List 
2 Accent 4;\lsdsemihidden0 \lsdunhideused0 \lsdpriority67 \lsdlocked0 
Medium Grid 1 Accent 4;\lsdsemihidden0 \lsdunhideused0 \lsdpriority68 
\lsdlocked0 Medium Grid 2 Accent 4; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority69 \lsdlocked0 Medium Grid 
3 Accent 4;\lsdsemihidden0 \lsdunhideused0 \lsdpriority70 \lsdlocked0 
Dark List Accent 4;\lsdsemihidden0 \lsdunhideused0 \lsdpriority71 
\lsdlocked0 Colorful Shading Accent 4; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority72 \lsdlocked0 Colorful 
List Accent 4;\lsdsemihidden0 \lsdunhideused0 \lsdpriority73 
\lsdlocked0 Colorful Grid Accent 4;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority60 \lsdlocked0 Light Shading Accent 5; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority61 \lsdlocked0 Light List 
Accent 5;\lsdsemihidden0 \lsdunhideused0 \lsdpriority62 \lsdlocked0 
Light Grid Accent 5;\lsdsemihidden0 \lsdunhideused0 \lsdpriority63 
\lsdlocked0 Medium Shading 1 Accent 5; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority64 \lsdlocked0 Medium 
Shading 2 Accent 5;\lsdsemihidden0 \lsdunhideused0 \lsdpriority65 
\lsdlocked0 Medium List 1 Accent 5;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority66 \lsdlocked0 Medium List 2 Accent 5; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority67 \lsdlocked0 Medium Grid 
1 Accent 5;\lsdsemihidden0 \lsdunhideused0 \lsdpriority68 \lsdlocked0 
Medium Grid 2 Accent 5;\lsdsemihidden0 \lsdunhideused0 \lsdpriority69 
\lsdlocked0 Medium Grid 3 Accent 5; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority70 \lsdlocked0 Dark List 
Accent 5;\lsdsemihidden0 \lsdunhideused0 \lsdpriority71 \lsdlocked0 
Colorful Shading Accent 5;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority72 \lsdlocked0 Colorful List Accent 5; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority73 \lsdlocked0 Colorful 
Grid Accent 5;\lsdsemihidden0 \lsdunhideused0 \lsdpriority60 
\lsdlocked0 Light Shading Accent 6;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority61 \lsdlocked0 Light List Accent 6; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority62 \lsdlocked0 Light Grid 
Accent 6;\lsdsemihidden0 \lsdunhideused0 \lsdpriority63 \lsdlocked0 
Medium Shading 1 Accent 6;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority64 \lsdlocked0 Medium Shading 2 Accent 6; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority65 \lsdlocked0 Medium List 
1 Accent 6;\lsdsemihidden0 \lsdunhideused0 \lsdpriority66 \lsdlocked0 
Medium List 2 Accent 6;\lsdsemihidden0 \lsdunhideused0 \lsdpriority67 
\lsdlocked0 Medium Grid 1 Accent 6; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority68 \lsdlocked0 Medium Grid 
2 Accent 6;\lsdsemihidden0 \lsdunhideused0 \lsdpriority69 \lsdlocked0 
Medium Grid 3 Accent 6;\lsdsemihidden0 \lsdunhideused0 \lsdpriority70 
\lsdlocked0 Dark List Accent 6; 
\lsdsemihidden0 \lsdunhideused0 \lsdpriority71 \lsdlocked0 Colorful 
Shading Accent 6;\lsdsemihidden0 \lsdunhideused0 \lsdpriority72 
\lsdlocked0 Colorful List Accent 6;\lsdsemihidden0 \lsdunhideused0 
\lsdpriority73 \lsdlocked0 Colorful Grid Accent 6; 
\lsdsemihidden0 \lsdunhideused0 \lsdqformat1 \lsdpriority19 
\lsdlocked0 Subtle Emphasis;\lsdsemihidden0 \lsdunhideused0 
\lsdqformat1 \lsdpriority21 \lsdlocked0 Intense Emphasis; 
\lsdsemihidden0 \lsdunhideused0 \lsdqformat1 \lsdpriority31 
\lsdlocked0 Subtle Reference;\lsdsemihidden0 \lsdunhideused0 
\lsdqformat1 \lsdpriority32 \lsdlocked0 Intense Reference; 
\lsdsemihidden0 \lsdunhideused0 \lsdqformat1 \lsdpriority33 
\lsdlocked0 Book Title;\lsdpriority37 \lsdlocked0 Bibliography; 
\lsdqformat1 \lsdpriority39 \lsdlocked0 TOC Heading;}}{\*\datastore 
010500000200000018000000 
4d73786d6c322e534158584d4c5265616465722e362e3000000000000000000000060000 
d0cf11e0a1b11ae1000000000000000000000000000000003e000300feff090006000000000000000000000001000000010000000000000000100000feffffff00000000feffffff0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
fffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff 
ffffffffffffffffffffffffffffffff52006f006f007400200045006e00740072007900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016000500ffffffffffffffffffffffff0c6ad98892f1d411a65f0040963251e5000000000000000000000000b021 
06f6866acb01feffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000 
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000 
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000 
0000000000000000000000000000000000000000000000000105000000000000}} 

<*End copy here*> 

And now, the last file in our build files list.  This one is called 
OssecHIDS.VER.  Here we setup our GUID and the version information 
that is published and shown in the full UI and in Add/Remove 
Programs.  This is a very small file and is completely self 
explanatory.  One thing that should be mentione here though.  MAKEMSI 
comes bundled with a GUID generation tools.  You won't have to 
generate your own for things to work, but you might as well since you 
will need to change this every time you upgrade to the lates version 
of the Ossec Windows Agent and now is a good time to get familiar with 
it. 

Here's the final bit of code. 

OssecHIDS.VER 

<*Begin copy here*> 

;---------------------------------------------------------------------------- 
; 
;    MODULE NAME:   OssecHIDS.VER 
; 
;        $Author:   USER "Shramkop"  $ 
;      $Revision:   1.0  $ 
;          $Date:   11 Oct 2010 17:25:32  $ 
; 
;    DESCRIPTION:   Ossec HIDS Deployment MSI. 
; 
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
++++++ 
; ProductName = Ossec HIDS 
; DESCRIPTION = Setup Automated Ossec HIDS Deployment. 
; Installed   = WINDOWS_ALL 
; Guid.UpgradeCode = {DB79FB9D-A01D-49C4-967F-40BD13BA74EB} 
; MsiName     = OssecHIDS 
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
++++++ 

;############################################################################ 
VERSION : 2.5.0 
DATE    : 11 Oct 2010 
CHANGES : See OSSEC changelog if interested. 

<*End copy here*> 

Now that you have all of the code needed, it's time to do our final 
organization and do a test build. 

I'll go over how I have everything setup on my dev box.  You can setup 
whatever paths you like, but i need to use something for an 
example :-). 

Put all of your files except for the 2 ossec_distribute_keys file into 
a directory on your machine.  We'll use C:\MSIBuilds\ossec for our 
example. 

Now let's create a new directory.  Something like C:\MSIBuilds\ossec 
\ArchConfigs\ and put our ossec_distribute_keys.cmd and our 
ossec_distribute_keys_x64.cmd files in here.  We will copy whichever 
one of these files we need for the architecture we're building our MSI 
for.  So if we are building for Win 32, we will want to have the 
ossec_distribute_keys.cmd copied to our C:\MSIBuilds\ossec\ folder. 
If we are building for Win x64 machines then we want to have the 
ossec_distribute_keys_x64.cmd there. 

Our final directory tree should look something like this (keep in mind 
that we will want to copy the correct distribute keys file to our 
\MSIBuilds\ossec folder BEFORE we start compiling our build. 

[-](folder) C:\MSIBuilds\ossec\ 
                       Company.mmh 
                       DEPT.mmh 
                       ossec.keys 
                       OSSEC.mmh 
                       ossec-agent-win32-version#.exe 
                       OssecHIDS.MM 
                       OssecHIDS.rtf 
                       OssecHIDS.VER 
                       OssecHIDSx64.MM 

                            [-](folder) C:\MSIBuilds\ossec\ArchConfigs 
\ 
ossec_distribute_keys.cmd 
  
ossec_distribute_keys_x64.cmd 

Now that everything is organized and setup the way we need it, lets go 
ahead and test a build. 

For a 32-bit build: 

  1. Copy the ossec_distribute_keys.cmd file to C:\MSIBuilds\ossec\ 
  2. Right-click on OssecHIDS.MM 
  3. Click "Build MSI - Development" or "Build MSI - Production" 
  4. Wait for build to complete. 

For a 64-bit build: 

  1. Copy the ossec_distribute_keys_x64.cmd file to C:\MSIBuilds\ossec 
\ 
  2. Right-click on OssecHIDSx64.MM 
  3. Click "Build MSI - Development" or "Build MSI - Production" 
  4. Wait for build to complete. 

The builds will take about 30 seconds to complete, there should be no 
errors and there should be a command window still open that says "hit 
any key to continue".  If all things went well you will end up with a 
new folder (C:\MSIBuilds\ossec\out\).  In here you will have all of 
the files that got output during the build.  The ones we are most 
concerned with are going to be in the C:\MSIBuilds\ossec\out 
\OssecHIDS.MM\MSI\ or C:\MSIBuilds\ossec\out\OssecHIDSx64.MM\MSI\ 
folder... depending on what you decided to build.  There will be an 
MSI file in here and an hta file. 

The MSI file is our completed deployment file.  Double-click it and it 
will install and configure the OssecHIDS agent on your machine with no 
interaction needed by you if you chose the minimal UI and the machine 
you are running it on was added to the ossec server as an agent.  If 
yuo chose to use the full UI you will see a familiar looking install 
dialogue box that you can choose your paths and type of install etc. 

You can customize things to look very polished by creating a file 
called LeftSideOSSEC.bmp in the C:\Program Files\MakeMsi\ folder.  use 
one of the existing LeftSide-*****.BMP files as a template and editing 
it in G.I.M.P with your company and/or Ossec logos and replacing the 
MmDefaultProductIcon.ico icon file in the same directoy with an icon 
of your company logo or an icon of the Ossec symbol. 

The last steps are not necessary before building yuor packages, but 
again, it finishes up your MSI with a very clean, customized and 
professional look for that WOW! factor that will set your build apart 
and show that you  have some pride in the project you just spent all 
that time on...plus it just looks prettier that way :-) 

I'm going to assume that you already know how to setup OUs and GPOs 
for software deployment or you probably would not have read through 
and done all of this, but just in case, here is a link to a very clear 
and easy to follow how to on the subject. 

http://support.microsoft.com/kb/816102 

Good luck and happy building.  If you have any difficulties, leave me 
a comment at http://groups.google.com/group/ossec-list and I'll try to 
help.  This series is posted there as well so it should be easy to 
find. 


