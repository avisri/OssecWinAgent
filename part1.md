Deploying Ossec HIDS via Active Directory - Part 1 
===================================================
In my first blog series I'm going to go over one way to deploy Ossec 
HIDS to windows PCs in a network via Active Directory software 
deployment.  In it's current form, Ossec HIDS is fairly easy to deploy 
to larger Linux environments but it's not nearly as friendly for 
deployment to larger numbers of Windows clients.  The latest Ossec 
HIDS client for Windows now supports the /s switch which makes it 
easier to deploy windows agents using tools like PSEXEC.  We will be 
going into a PSEXEC deployment process more in-depth at a later time 
so I will not cover that deployment scenario here. 

While this is a good step in the direction of making the deployment 
process easier for Windows Administrators, there are more tasks that 
could be automated.  I am confident that the process I am going to 
outline here will make the task of deploying Ossec HIDS easier for 
both Windows and Linux Administrators.  In this process, I tie 
together some of great work that others have done in the Ossec 
community with my own work to create a fully automated deployment 
process that is designed to make this task easier and more time 
efficient for Administrators.  The second and arguably more important 
reason for this automation process is to address the need for being 
able to quickly rebuild the entire system in a disaster recovery 
scenario. 

Now that we've gone over some of the background and reasons that 
brought me to creating this automation process we'll get into the 
actual process.  For the purposes of this blog and to keep things as 
short as possible we are going to assume that you are familiar with 
building an Ossec Server and/or already have one setup and that you 
are at least somewhat  familiar with Active Directory Software 
Deployment.  This being the case, in this scenario we have hundreds of 
agents to add to our Ossec Server before we even start installing the 
Ossec HIDS client on our Windows agents.  I personally did not want to 
have to do this by hand so I found this automation script at 
http://www.mail-archive.com/ossec-list@googlegroups.com/msg05128.html. 
There were no instructions included so I had do a little bit of 
figuring out to get it working. 

Here's how I did it.... 

**NOTE:  Some Ossec Server installs are located in /var/ossec/ instead 
of /opt/ossec/ so double-check your paths before moving on.*** 

Create a shell script in /opt/ossec/ (I named the file 
"agentsaddfromlist.sh") and paste the following code into it. 

```bash
  #!/bin/bash 
  ## this is the last key's index number, taken via bin/agent_control 
  ## 
  ## -chuck 
  indexStart=`/opt/ossec/bin/agent_control -l |grep ID: |awk '{print $2}' |tail -1 |cut -f1 -d,` 
  indexStart=`expr $indexStart + 1` 

 ## loop through the list of clients 
 ## 
 for line in `cat /opt/ossec/ossec_client_add.lst` 
 do 
   HOST=`echo $line|awk -F":" ' { print $1 } '` 
   IP=`echo $line|awk -F":" ' { print $2 } '` 
   echo "<<EOF" > /opt/ossec/ossec_input_host.txt 
   echo "A" >> /opt/ossec/ossec_input_host.txt 
   echo $HOST >> /opt/ossec/ossec_input_host.txt 
   echo $IP >> /opt/ossec/ossec_input_host.txt 
   echo "$indexStart" >> /opt/ossec/ossec_input_host.txt 
   echo "" >> /opt/ossec/ossec_input_host.txt 
   echo "y" >> /opt/ossec/ossec_input_host.txt 
   echo "q" >> /opt/ossec/ossec_input_host.txt 
   echo ">>EOF" >> /opt/ossec/ossec_input_host.txt 
   sudo /opt/ossec/bin/manage_agents < ossec_input_host.txt 

   ## test the addition of this client to OSSEC. if we pass then add 1 
   ## to the value of index.  if we fail leave the index value as is 
   if [ $? -eq 0 ] 
   then 
           indexStart=`expr $indexStart + 1` 
           echo "Added $HOST to client.keys" 
   else : 
   fi 
 done 
```

Next we need to setup a list with the machines we want to add to our 
server.  This should also be placed in the /opt/ossec/ folder on your 
server.  As you can see in the script above the list file will need to 
be called  "ossec_client_add.lst".  This is just a simple text file 
but it needs to be formatted specifically for the script to properly 
parse it.  Below is a small sample of what your list should look 
like. 

**Note: that there are no spaces, the machine name and IP address are 
separated by a colon ":" and subnet masks work fine in here for those 
of us that have DHCP assigned IP addresses** 

abcd4321:172.10.14.45 
qwerty321:10.7.0.0/16 

As a suggestion, I created my list by querying the AD for computer 
names in the OU that I needed to deploy OssecHIDS to and exporting the 
list to csv.  I then opened it in MS Excel.  In the second column I 
put a : and in the 3rd column I put the IP Address of the machines.  I 
did this using a subnet mask so it was very quick to do it this way 
(explained at http://www.ossec.net/wiki/Know_How:DynamicIPs).  Once 
the list was complete in Excel, I copied the text to Notepad++ and 
removed the leading and trailing spaces around the : so the list went 
from this... 

abcd4321  :  172.10.14.45 
qwerty321  :  10.7.0.0/16 

to this 

abcd4321:172.10.14.45 
qwerty321:10.7.0.0/16 

Now that we have the script to add the agents via list and the list 
in /opt/ossec/ we need to run it. 


Type this into a console on your ossec server and watch it run: 

sudo ./opt/ossec/addagentsfromlist.sh 

You could be logged into the server as root and run the command 
without sudo.  It works well like that, but it's less security 
conscious.  The script should not take very long to run.  I ran it 
with 350 PC names in the list and it completed in about 30 seconds. 
Now double check that everything went as planned by looking at your 
list of agents using /opt/ossec/bin/manage_agents.  If you are 
satisfied with the results, restart the ossec service by typing "/opt/ 
ossec/bin/ossec-control restart". 


At this point we've added all of our agents to our Ossec Server.  Next 
we need to generate the client.keys file using manage agents and copy 
it over to the machine we are going to create the Windows Ossec HIDS 
agent deployment on.  We will need this to create the MSI we are going 
to create to deploy it using Active Directory. This will also be 
needed if you are going to deploy the agent to the PCs using the 
PSEXEC method that Michael Starks will be outlining as mentioned 
earlier in this post. 


Before we begin setting up the files for deployment we are going to 
want to make sure we have the right tools installed on our development 
machine. 


First you're going to need to install the MAKEMSI package and all 
associated packages to properly build the deployment installation 
files.  All the information you could ever need to do this is located 
on Dennis Barries site at http://dennisbareis.com/makemsi.htm.  This 
MSI packaging tool is very flexible and very powerful.  I will provide 
all of the scripts that are needed to create the OssecHIDS 
installation package so you won't NEED to read through the MAKEMSI 
manual if you are not familiar with it but I very highly recommend it 
so that you will know what the scripts are doing and will be able to 
use it to create more MSI packages in the future.  Dennis Barries' 
method for building MSI packages is far superior to the before/after 
snapshot method of generating MSI packages for a number of reasons not 
the least of which is that MSI packages created this way are more 
robust and reliable than the snapshot methods that many of us are 
familiar with, especially when re-packaging existing installers like 
we are going to do in this write-up. 

Admittedly there are alot of things needed to install MAKEMSI and have 
it working properly, but it is not very difficult and we end up with a 
very good package development machine in the process.  For now I will 
leave you to the task of setting up your development box.  Tomorrow we 
will cover the rest of this deployment process. 

I'll show you the scripts to fully automate the configuration of the 
OssecHIDS windows agents to connect to our Ossec server and distribute 
the individual keys to each agent.  I know what you're thinking now, 
but don't worry...we won't leave the master client.keys file on any of 
our agent machines and the client.keys file that is generated by the 
scripts will have only the line that each individual agent machine 
needs to connect to the server.  Good luck setting up your development 
box.  Tomorrow will be a big day with a number of scripts and 
configuration but the payoff is that once we are done with everything 
we will be able to re-create the MSI packages we're going to use to 
deploy to our agents very quickly (maybe a couple of minutes whenever 
there is an update to the Windows Agent posted on the main OSSEC site 
or a new agent added to the Ossec server).

