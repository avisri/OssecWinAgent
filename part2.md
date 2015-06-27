 
Deploying Ossec HIDS via Active Directory Part 2 - Automating the Windows Agent Configuration 
==============================================================================================

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

[ossec_distribute_keys.cmd](https://github.com/avisri/OssecWinAgent/blob/master/post%20install%20config%20scripts_CORRECT%20FILE%20NEEDED%20FOR%20WIN32%20OR%20WIN64/ossec_distribute_keys.cmd)


You'll need to edit the first variable to configure this to work in 
your environment. 

```
SET OSSECSERVER=<Ossec Server IP here>
```

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


-Company.mmh 
-DEPT.mmh 
-ossec.keys - You should have your own by now so for security reasons I can't post mine. 
-OSSEC.mmh 
-ossec-agent-win32-version#.exe -Must be at least version 2.5 for the automated installation to work. 
-OssecHIDS.MM 
-OssecHIDS.rtf 
-OssecHIDS.VER 
and 
-OssecHIDSx64.MM 


You will likely want to edit the uisample.mmh file located in your 
main MAKEMSI install directory (specifically line 1088).  Set this 
value to 1 instead of 0 for installs that you want to have a progress 
bar but no user interaction. 

```
#define? UISAMPLE_REDUCED_UI_VALUE         0        ;;0 = normal, 1 = reduced UI (on install only) 
```

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


Tomorrow in [Part 3](https://github.com/avisri/OssecWinAgent/blob/master/part3.md) of the series I will tie it all together and show you how it works.
