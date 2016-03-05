## To check the dependency related to particular service
This script will get the information (Integration server IP address, Integration server username & Passwords, Element’s name to find out the dependency) from the user at runtime and provides the dependent services of Integration Server elements.
This script will be very helpful to webMethods Administrators who needs to monitor Integration server elements at regular intervals. With this script they can find the dependencies and take prompt action in the resolution of any related issue.  
The most dependent element in the integration server is “Adapter Connection”, which will be used for all transactions of the interfaces in Integration Server.
Any Adapter connection will have dependency over Adapter Services, Notifications, Document and these elements will be invoked by Flow or Java services in IS.
The entire interface gets affected when there is any issue in the adapter connection which is performing different transactions over the DB. The adapter connections are usually affected due to Network glitch, connectivity or timeout etc.
A webMethods Admin has to figure out the dependency of the Adapter connection which is triggering the Interface, Triggering Elements might be Scheduler, File poller, Adapter notification, and triggers. 
Once wM Admin get the all information which is triggering the interface used by the Adapter Connection, admin can suspend the triggering elements in IS to avoid loss of data or accumulation of errors in Integration server log file.
