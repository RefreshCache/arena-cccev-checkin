/**********************************************************************
* Description:  Print Provider for Reporting Services
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: 9/15/2009
*
* $Workfile: RSPrintLabel.cs $
* $Revision: 3 $
* $Header: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/Entity/RSPrintLabel.cs   3   2010-09-23 13:53:58-07:00   JasonO $
*
* $Log: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/Entity/RSPrintLabel.cs $
*  
*  Revision: 3   Date: 2010-09-23 20:53:58Z   User: JasonO 
*  Implementing changes suggested by HDC. 
*  
*  Revision: 2   Date: 2009-10-09 00:07:46Z   User: JasonO 
*  
*  Revision: 1   Date: 2009-09-15 23:38:45Z   User: JasonO 
*  Adding Reporting Services Provider. 
**********************************************************************/

using System.Collections.Generic;
using Arena.CheckIn;
using Arena.Computer;
using Arena.Core;
using Arena.Reporting;

namespace Arena.Custom.Cccev.CheckIn.Entity
{
    internal class RSPrintLabel : IPrintLabel
    {
        public void Print(FamilyMember person, IEnumerable<Occurrence> occurrences, OccurrenceAttendance attendance, ComputerSystem system)
        {
            // Don't new up Kiosk w/o empty constructor, might be too costly
            Kiosk kiosk = new Kiosk() { System = system };
            var jobs = kiosk.GetPrintJobs(attendance);
            ReportPrinter printer = new ReportPrinter();
            printer.PrintReports(jobs);
        }
    }
}
