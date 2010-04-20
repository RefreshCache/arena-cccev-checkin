/**********************************************************************
* Description:  Print Provider for Reporting Services
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: 9/15/2009
*
* $Workfile: RSPrintLabel.cs $
* $Revision: 2 $
* $Header: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/Entity/RSPrintLabel.cs   2   2009-10-08 17:07:46-07:00   JasonO $
*
* $Log: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/Entity/RSPrintLabel.cs $
*  
*  Revision: 2   Date: 2009-10-09 00:07:46Z   User: JasonO 
*  
*  Revision: 1   Date: 2009-09-15 23:38:45Z   User: JasonO 
*  Adding Reporting Services Provider. 
**********************************************************************/

using System.Collections.Generic;
using System.Linq;
using Arena.Computer;
using Arena.Core;
using Arena.Organization;
using Arena.Reporting;
using ReportParameter = Arena.Reporting.ReportParameter;

namespace Arena.Custom.Cccev.CheckIn.Entity
{
    internal class RSPrintLabel : IPrintLabel
    {
        public void Print(FamilyMember person, IEnumerable<Occurrence> occurrences, OccurrenceAttendance attendance, ComputerSystem kiosk)
        {
            List<ReportParameter> parameters = new List<ReportParameter>
                                                   {
                                                       new ReportParameter("OccurrenceAttendanceID", attendance.OccurrenceAttendanceID.ToString())
                                                   };

            OccurrenceTypeReportCollection reports = new OccurrenceTypeReportCollection(occurrences.First().OccurrenceTypeID);
            ReportPrintJobCollection jobs = new ReportPrintJobCollection();

            foreach (OccurrenceTypeReport report in reports)
            {
                bool printLocally = true;
                string printerName;

                if (report.UseDefaultPrinter)
                {
                    printerName = kiosk.Printer.PrinterName;
                }
                else
                {
                    printerName = new Location(occurrences.First().LocationID).Printer.PrinterName;
                    printLocally = false;
                }

                ReportPrintJob printJob = new ReportPrintJob(printerName, report.ReportPath, 1, true, parameters, 
                    printLocally, string.Format("Cccev.CheckIn_Attendance-{0}", attendance.OccurrenceAttendanceID));
                jobs.Add(printJob);
            }

            ReportPrinter printer = new ReportPrinter();
            printer.PrintReports(jobs);
        }
    }
}
