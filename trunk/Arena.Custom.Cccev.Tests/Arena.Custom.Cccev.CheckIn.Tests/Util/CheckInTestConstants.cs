/**********************************************************************
* Description:  Constants to support integration tests.
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: 11/23/2009
*
* $Workfile: CheckInTestConstants.cs $
* $Revision: 1 $
* $Header: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/Util/CheckInTestConstants.cs   1   2009-12-14 17:26:50-07:00   JasonO $
*
* $Log: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/Util/CheckInTestConstants.cs $
*  
*  Revision: 1   Date: 2009-12-15 00:26:50Z   User: JasonO 
*  
*  Revision: 1   Date: 2009-12-01 22:39:45Z   User: JasonO 
**********************************************************************/

using Arena.Core;

namespace Arena.Custom.Cccev.CheckIn.Tests.Util
{
    public class CheckInTestConstants
    {
        public const string ALT_ID = "123456";
        public const string PHONE_NUMBER = "6021234567";
        public const int RELATIONSHIP_TYPE_ID = 3;
        public const string USER_ID = "unitTests";
        public const string FIRST_NAME = "John";
        public const string LAST_NAME = "Doe";
        public const int PHONE_TYPE = 276;
        public static readonly int ORG_ID = ArenaContext.Current.Organization.OrganizationID;
        public const int MAX_AGE_HI = 18;
        public const int MAX_GRADE_HI = 12;
        public const int MAX_AGE_LO = 1;
        public const int MAX_GRADE_LO = 1;
        public const string INVALID_IP = "10.0.0.0";
    }
}
