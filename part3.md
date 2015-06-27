PART III
========
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

[Company.mmh](https://github.com/avisri/OssecWinAgent/blob/master/Company.mmh)


The next script file we are going to go over is DEPT.mmh.  Here we 
setup our company info so that the completed MSI install UI shows our 
informatino so that everyone knows who put this together in your 
company.  In this file you will want to edit lines 49 - 58.  In the 
code example these variables are generalized and look like this 
starting at line 46.  You might choose to just blank these things out 
or enter your own information.  You company policy will likely dictate 
what you should change these things to. 



This is pretty straightforward so I won't bore you with what each line 
here is.  The complete code for DEPT.mmh is just below here.  You may 
at some point choose to edit/cusustomize this information further. 
The project should still build successfully regardless of what you use 
for information in the lines shown above.  Outside of that, you will 
alter how the MSI and it's files are put together so be careful and 
always test before deploying. 

[DEPT.mmh](https://github.com/avisri/OssecWinAgent/blob/master/DEPT.mmh)

The next file we are going to go over is OSSEC.mmh.  Here we setup the 
standard build information.  What you put into DEPT.mmh WILL override 
the information you put in OSSEC.mmh.  The redundancies are there to 
make sure things come out the way we want them in the end.  DEPT.mmh 
does also do alot more processing of information that OSSEC.mmh whish 
is why we need them both.  Here is the code for OSSEC.mmh. 



[OSSSEC.mmh](https://github.com/avisri/OssecWinAgent/blob/master/OSSSEC.mmh)
 
Now we get to our OssecHIDS.MM file.  This is the main build file for 
making a 32-bit MSI installer that, depending on what you did with 
your uisample.mmh file earlier will have a full UI with all of the 
regular buttons and options you find in any other installer or will 
have a minimal UI which is essentially just a window with a title so 
the users know what is being installed and a progress bar. 


Near the top of this file you will see the following (lines 14 - 18). 
[OssecHIDS.MM](https://github.com/avisri/OssecWinAgent/blob/master/OssecHIDS.MM)


This is pretty self-explanatory as well.  This is the ONLY line you 
should edit here.  Again you can customize this file further but I 
would not until you really get to know MAKEMSI. 

Here is the complete code for OssecHIDS.MM. 
[OssecHIDS.MM](https://github.com/avisri/OssecWinAgent/blob/master/OssecHIDS.MM)



Next we go throught the OssecHIDSx64.MM.  This file is nearly 
identical to OssecHIDS.MM except for here we tell the build scripts to 
package the ossec_distribute_keys_x64 into our cab file (everything 
ends up in a single .MSI file, no worries, I''m just telling you what 
is going on here :-)).  As we went over in the previous posts this is 
necessary becuase of the differences in how 32-bit and 64-bit machines 
handle installer and paths.  You will need to edit the same line here 
that you did in the OssecHIDS.MM file. 

Here's the code for our 64-bit build script. 
[OssecHIDSx64.MM](https://github.com/avisri/OssecWinAgent/blob/master/OssecHIDSx64.MM)



We are getting close to wrapping up now.  This next file is not a 
script.  It is a copy of the EULA extracted from the base install .exe 
file that we downloaded from ossec.  It's not needed, but is nice to 
have.  Especially if we ever need to use the full UI installer. 

Here's the "code" for that. 

OssecHIDS.rtf 


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

```
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
```


Now that everything is organized and setup the way we need it, lets go 
ahead and test a build. 

For a 32-bit build: 

  1. Copy the ossec_distribute_keys.cmd file to C:\MSIBuilds\ossec\ 
  2. Right-click on OssecHIDS.MM 
  3. Click "Build MSI - Development" or "Build MSI - Production" 
  4. Wait for build to complete. 

For a 64-bit build: 

  1. Copy the ossec_distribute_keys_x64.cmd file to C:\MSIBuilds\ossec\ 
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


