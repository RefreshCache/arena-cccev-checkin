/**********************************************************************
* Description:  Mock Print Label to simulate behavior of printing.
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: 11/30/2009
*
* $Workfile: MockPrintLabel.cs $
* $Revision: 1 $
* $Header: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/Mocks/MockPrintLabel.cs   1   2009-12-14 17:26:50-07:00   JasonO $
*
* $Log: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/Mocks/MockPrintLabel.cs $
*  
*  Revision: 1   Date: 2009-12-15 00:26:50Z   User: JasonO 
*  
*  Revision: 1   Date: 2009-12-01 22:39:45Z   User: JasonO 
**********************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using Arena.Computer;
using Arena.Core;
using Arena.Custom.Cccev.CheckIn.Entity;

namespace Arena.Custom.Cccev.CheckIn.Tests.Mocks
{
    public class MockPrintLabel : IPrintLabel
    {
        public void Print(FamilyMember person, IEnumerable<Occurrence> occurrences, OccurrenceAttendance attendance, ComputerSystem kiosk)
        {
            if (occurrences.Any(o => o is EmptyOccurrence))
            {
                throw new ApplicationException("Invalid Occurrence!");
            }

            return;
        }
    }
}
