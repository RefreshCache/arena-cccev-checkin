Central Christian Church (Cccev) & High Desert Church (HDC)
Check-In Wizard v1.3.0


OVERVIEW & INSTALLATION
----------------------
Read the Check-In Wizard Admin Guide (docs\Central_Checkin_Wizard_Admin_Guide.pdf)
for information on installing the modules.

Read the Check-In Wizard Developer Guide (docs\Central_Checkin_Developer_Guide.pdf)
for details on how the system works and for information on writing your
own providers.


UPGRADING FROM v1.2.1
---------------------
If you are upgrading from v1.2.1:
    1) import the new pages and modules (
    2) run the SQL called 20110302_1_2_1_update_to_1_3_0.sql
    

SOURCE CODE
-----------
The source code can be obtained from the SVN Repository
(http://svn.refreshcache.com/cccevcheckin) under the following
folders:

 * trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.Checkin/
 * trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.DataUtils/
 * trunk/Arena/UserControls/Custom/Cccev/Checkin/
 * trunk/Database/
 	* Scripts/cust/Cccev/ckin/ (for installing all tables, sprocs, data)
	* Stored Procedures/cust/Cccev/ckin/
 	* Tables/cust/Cccev/ckin/
 * trunk/RDLs


RELEASE NOTES
-------------
V1.3.0 - Works with Arena 2010.X
       - Added support (via new organization settting) to designate which
         “inactive reasons” will still allow someone who is inactive to
         check-in.
       - Added support for group linked “Membership Required”.
       - Added support for “Membership Required” on occurrences.
       - Added a Maximum Phone Number Length module setting.
       - Added a Kiosk Management/Registration module and module setting.
       - Added a “post-checkin” target page module setting to redirect
         to after a family checkin occurs.
       - Layout and style changes to support mobile/iPad devices and other
         style cleanup.
       - Temporarily added a minimum and maximum age/grade module settings
         which are deprecated and will be removed in next version.
       - Updated to work with Arena 2010.1

v1.2.1 - Works with Arena 2009.2
       - Added support for "At Kiosk" and "At Location" printing.
       - Added support for print labels via Reporting Services.
       - New Feature: Application Logging – Will log information for each 
         attendee and detail which Occurrences the system attempts to match 
         them to.
       - New Feature: Room Balancing – New extended attribute to denote
         whether or not an Attendance Type is “Room Balancing”. If an
         Attendance Type is flagged for room balancing and has multiple
         locations tied to it, the system will now check attendees into 
         the room with the smallest head-count.
       - Added support for Maximum People on Locations.
       - Ctrl+Shift+R hot-key activates Family Registration page.
       - Option to display room/location name on standard check-in label
         nametag.

v1.1.0 - Added support for Attendance Type "Membership Required for Check-In".
         Attendance Types linked to Tags which have 'membership required' will
         now only match if the person is a member of the tag.
       - Bug fix for installations that do not have the GradePromotionDate
         org setting.

v1.0.3 - Optimized/simplified last change

v1.0.2 - Fixed bug in DateUtils.dll (GetFractionalAge) having to do
         with people having birthdays on or around the current day.

v1.0.1 - Now includes the SQL scripts in the zip file.

v1.0.0 - works with Arena 2008.3

