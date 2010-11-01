/**********************************************************************
* Description:  Controls business logic for Cccev Checkin Wizard
* Created By:	Nick Airdo, Jason Offutt
* Date Created:	11/12/2008
*
* $Workfile: CheckInBLL.cs $
* $Revision: 59 $ 
* $Header: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/CheckInBLL.cs   59   2010-01-20 15:42:48-07:00   JasonO $
* 
* $Log: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/CheckInBLL.cs $
*  
*  Revision: 59   Date: 2010-01-20 22:42:48Z   User: JasonO 
*  Adding support for declaring print-provider at the module level. 
*  
*  Revision: 58   Date: 2009-12-01 21:34:35Z   User: JasonO 
*  
*  Revision: 57   Date: 2009-11-30 23:19:44Z   User: JasonO 
*  Adding in overloads of CheckInFamily and Print to allow for custom Print 
*  Label injection. 
*  
*  Revision: 56   Date: 2009-11-16 20:18:15Z   User: JasonO 
*  Refactoring 
*  
*  Revision: 55   Date: 2009-10-28 20:29:47Z   User: JasonO 
*  
*  Revision: 54   Date: 2009-10-28 17:00:55Z   User: JasonO 
*  Merging changes from HDC 
*  
*  Revision: 53   Date: 2009-10-19 16:17:04Z   User: JasonO 
*  Removing un-used constant. 
*  
*  Revision: 52   Date: 2009-10-14 17:23:05Z   User: JasonO 
*  
*  Revision: 51   Date: 2009-10-09 00:07:46Z   User: JasonO 
*  
*  Revision: 50   Date: 2009-10-08 17:18:18Z   User: JasonO 
*  Merging/updating to make changes for 1.2 release. 
*  
*  Revision: 49   Date: 2009-09-23 22:38:02Z   User: JasonO 
*  
*  Revision: 48   Date: 2009-09-21 15:30:21Z   User: JasonO 
*  
*  Revision: 47   Date: 2009-09-15 23:38:59Z   User: JasonO 
*  
*  Revision: 46   Date: 2009-09-09 16:16:56Z   User: JasonO 
*  Fixing potential issues with lexical closure and Linq. 
*  
*  Revision: 45   Date: 2009-09-08 22:59:06Z   User: JasonO 
*  Updating class/object names to fix ambiguity issues. 
*  
*  Revision: 44   Date: 2009-09-02 06:51:49Z   User: nicka 
*  Correct bug with 12th graders still showing up on family list 
*  
*  Revision: 43   Date: 2009-08-24 15:59:11Z   User: nicka 
*  troubleshooting problem 
*  
*  Revision: 42   Date: 2009-07-15 22:42:12Z   User: nicka 
*  slight modification to logging format and order 
*  
*  Revision: 41   Date: 2009-07-15 18:15:35Z   User: JasonO 
*  
*  Revision: 40   Date: 2009-06-18 22:45:33Z   User: nicka 
*  DanielH|HDC patch 
*  
*  Revision: 39   Date: 2009-06-18 17:43:42Z   User: nicka 
*  Changes to handle new IPrintLabel that requires kiosk as discussed here: 
*  http://checkinwizard.codeplex.com/Thread/View.aspx?ThreadId=57675 
*  
*  Revision: 38   Date: 2009-06-08 18:39:10Z   User: JasonO 
*  Implementing reSharper recommendations. 
*  
*  Revision: 37   Date: 2009-06-05 00:12:07Z   User: JasonO 
*  Adding new GetCurrentKiosk() method to return instance of kiosk.  Decouples 
*  DNS/IP lookup logic from UI. 
*  
*  Revision: 36   Date: 2009-05-18 17:46:39Z   User: JasonO 
*  Added publid Print() method to provide API hooks to re-print labels 
*  manually. 
*  
*  Revision: 35   Date: 2009-05-18 17:25:57Z   User: JasonO 
*  Cleaning up unused constants. 
*  
*  Revision: 34   Date: 2009-05-18 16:58:17Z   User: JasonO 
*  Cleaning up usings. 
*  
*  Revision: 33   Date: 2009-05-18 16:51:24Z   User: JasonO 
*  Updating to call ArenaContext.Current.Organization.GradePromotionDate over 
*  explicit calls to specific GradePromotionDate org setting.  The property on 
*  the Organization class provides a default value of 6/1 instead of throwing 
*  an exception. 
*  
*  Revision: 32   Date: 2009-05-06 16:57:49Z   User: JasonO 
*  Adding tag sync/matching. 
*  
*  Revision: 31   Date: 2009-02-17 01:08:31Z   User: nicka 
*  simplify the AbilityLevel check... the pa IntValue is the AbilityLevel LUID 
*  
**********************************************************************/
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Arena.CheckIn;
using Arena.Computer;
using Arena.Core;
using Arena.Custom.Cccev.FrameworkUtils.Entity;
using Arena.Custom.Cccev.FrameworkUtils.FrameworkConstants;
using Arena.DataLayer.Core;
using Arena.Organization;

using Arena.Custom.Cccev.CheckIn.Entity;
using Arena.Custom.Cccev.DataUtils;

namespace Arena.Custom.Cccev.CheckIn
{
	/// <summary>
	/// CheckIn constants
	/// </summary>
	[Serializable]
	public class CheckInConstants
	{
		public const string SESS_STATE = "CCCEV_CHECKIN_STATE";
		public const string SESS_KEY_PEOPLEMAP = "cccev_peopleMap";
        public const string SESS_FAMILY = "cccev_checkInFamily";
		public const string SESS_LIST_CHECKIN_FAMILYMEMBERS = "cccev_checkinFamilyMemberList";
        public const string SESS_ATTENDEES = "cccev_checkinAttendees";
		public const string SESS_LIST_OCCURRENCES_CHECKIN = "cccev_checkinOccurrences";
        public const string SESS_SERVICE_TIMES = "serviceTimes";
        public const string SESS_RESULTS = "checkinResults";
	}

    [Serializable]
    public class CheckInServiceInfo
    {
        public DateTime StartTime { get; set; }
        public bool IgnoreCheckInStart { get; set; }

        public CheckInServiceInfo(DateTime startTime, bool ignoreCheckInStart)
        {
            StartTime = startTime;
            IgnoreCheckInStart = ignoreCheckInStart;
        }
    }

    public enum CheckInStates
    {
        Init,
        FamilySearch,
        SelectFamilyMember,
        NoEligiblePeople,
        SelectAbility,
        SelectService,
        Confirm,
        Result,
        BadKiosk
    }

    public enum CheckInSearchTypes
    { 
        Scanner,
        PhoneNumber
    }

    public class CheckInController
    {
        /// <summary>
        /// Determines whether or not a family member is allowed to check in based on age and grade passed in.
        /// </summary>
        /// <param name="fm"><see cref="Arena.Core.FamilyMember">FamilyMember</see> to check in</param>
        /// <param name="maxAge">Maximum age</param>
        /// <param name="maxGrade">Maximum grade level</param>
        /// <returns>bool indicating whether or not Family Member can check in to Occurrence Attendance</returns>
        public static bool CanCheckIn(FamilyMember fm, int maxAge, int maxGrade)
        {
            int gradeLevel = Person.CalculateGradeLevel(fm.GraduationDate, ArenaContext.Current.Organization.GradePromotionDate);

			if (gradeLevel != Constants.NULL_INT && !HasGraduated(fm))
            {
                return gradeLevel <= maxGrade;
            }

            if (fm.Age != Constants.NULL_INT)
            {
                if (maxAge != Constants.NULL_INT)
                {
                    return fm.Age <= maxAge;
                }

                return true;
            }

            return false;
        }

		/// <summary>
		/// Test to see if a person has hit their graduation date. 
		/// </summary>
		/// <param name="person">Person to test against</param>
		/// <returns>boolean idicating whether or not the given person has graduated</returns>
		private static bool HasGraduated( Person person )
		{
			DateTime promoMonthDay = ArenaContext.Current.Organization.GradePromotionDate;
			DateTime graduationDate = new DateTime( person.GraduationDate.Year, promoMonthDay.Month, promoMonthDay.Day );
			return ( DateTime.Now > graduationDate );
		}

        /// <summary>
        /// Determines whether or not any user has the ability to check in to the provided Occurrence.
        /// </summary>
        /// <param name="occurrence"><see cref="Arena.Core.Occurrence">Occurrence</see> to check into</param>
        /// <returns>bool indicating whether or not Occurrence's checkin start time has passed</returns>
        public static bool ReadyForCheckIn(Occurrence occurrence)
        {
            return (occurrence.CheckInStart <= DateTime.Now);
        }

        /// <summary>
        /// Gets a family based on the specified search type and value provided.
        /// </summary>
        /// <param name="checkInSearchType">Enum that determines the type of search being done (by barcode, or by phone number)</param>
        /// <param name="value">Family ID or phone number</param>
        /// <returns>Collection of families that match the criteria provided</returns>
        public static FamilyCollection GetFamily(CheckInSearchTypes checkInSearchType, string value)
        {
            FamilyCollection families;

            switch (checkInSearchType)
            {
                case CheckInSearchTypes.Scanner:
                    families = GetFamiliesByAltID(value);
                    break;
                case CheckInSearchTypes.PhoneNumber:
                    families = GetFamiliesByPhoneNumber(value);
                    break;
                default:
                    families = new FamilyCollection();
                    break;
            }

            return families;
        }

        private static FamilyCollection GetFamiliesByAltID(string altID)
        {
            FamilyCollection families = new FamilyCollection();
            Person person = new Person();
            person.LoadByAlternateID(altID);
            families.Add(person.Family());
            return families;
        }

        private static FamilyCollection GetFamiliesByPhoneNumber(string phone)
        {
            FamilyCollection families = new FamilyCollection();
            FamilyCollection activeFamilies = new FamilyCollection();
            families.LoadByPhoneNumber(phone);

            foreach (Family family in families)
            {
                if (family.FamilyMembersActive.Count > 0)
                {
                    activeFamilies.Add(family);
                }
            }

            return activeFamilies;
        }

        /// <summary>
        /// Overload to only pass family.
        /// </summary>
        /// <param name="family"><see cref="Arena.Core.Family">Family</see> to find relatives for</param>
        /// <returns><see cref="Arena.Core.FamilyMemberCollection">FamilyMemberCollection</see> of current family and any relatives</returns>
        public static FamilyMemberCollection GetRelatives(Family family)
        {
            return GetRelatives(family, new int[0]);
        }

        /// <summary>
        /// Creates a FamilyMemberCollection of provided family's members and any relationships whose type matches one of the array members.
        /// </summary>
        /// <param name="family"><see cref="Arena.Core.Family">Family</see> to find relatives for</param>
        /// <param name="relationshipTypeIDs">int array of Relationship ID's</param>
        /// <returns><see cref="Arena.Core.FamilyMemberCollection">FamilyMemberCollection</see> of current family and any relatives</returns>
        public static FamilyMemberCollection GetRelatives(Family family, int[] relationshipTypeIDs)
        {
            FamilyMemberCollection familyMembers = family.FamilyMembersActive;
            
            if (relationshipTypeIDs.Length > 0)
            {
                Person head = family.FamilyHead;
                Person spouse = head.Spouse();
                var relationships = from r in head.Relationships.OfType<Relationship>()
                                    select r;
                var spouseRelationships = spouse != null ? (from r in spouse.Relationships.OfType<Relationship>()
                                                            select r) : new List<Relationship>();
                relationships = relationships.Concat(spouseRelationships).ToList();

                foreach (var rel in relationships)
                {
                    foreach (int i in relationshipTypeIDs)
                    {
                        if (rel.RelationshipTypeId != i || familyMembers.FindByID(rel.RelatedPersonId) != null)
                        {
                            continue;
                        }

                        FamilyMember relative = new FamilyMember(rel.RelatedPersonId);

                        if (relative.RecordStatus != Enums.RecordStatus.Inactive)
                        {
                            familyMembers.Add(relative);
                        }
                    }
                }
            }

            return familyMembers;
        }

        /// <summary>
        /// Loads an instance of the current kiosk based on the IP address.  If not found, will return null.
        /// </summary>
        /// <param name="ip">IP address of the kiosk</param>
        /// <returns><see cref="Arena.Computer.ComputerSystem">ComputerSystem</see> kiosk</returns>
        public static ComputerSystem GetCurrentKiosk(string ip)
        {
            string hostValue;
            ComputerSystem computer;

            try
            {
                hostValue = System.Net.Dns.GetHostEntry(ip).HostName;
            }
            catch (System.Net.Sockets.SocketException)
            {
                /// NOTE: GetHostEntry() doesn't always work perfectly. See comments
                /// in "Community Content" section of the link below:
                /// http://msdn.microsoft.com/en-us/library/ms143998.aspx
                hostValue = System.Net.Dns.GetHostByAddress(ip).HostName;
            }

            if (Regex.IsMatch(hostValue, @"\d+\.\d+\.\d+\.\d+"))
            {
                computer = new ComputerSystem();
                computer.LoadByKioskIp(hostValue);
            }
            else
            {
                computer = new ComputerSystem(hostValue, true);
            }

            if (computer.SystemId != Constants.NULL_INT && computer.Kiosk)
            {
                return computer;
            }

            return null;
        }
        
        /// <summary>
        /// Loads the active occurrences based on the location of the kiosk passed in and will create
        ///  a filtered OccurrenceCollection based on start and end dates.
        /// </summary>
        /// <param name="lookAhead">DateTime to start filter</param>
        /// <param name="currentTime">DateTime to end filter</param>
        /// <param name="kiosk"><see cref="Arena.Computer.ComputerSystem">ComputerSystem</see> kiosk</param>
        /// <returns>Filtered IEnumerable</returns>
        public static List<Occurrence> GetOccurrences(DateTime lookAhead, DateTime currentTime, ComputerSystem kiosk)
        {
            OccurrenceCollection oc = new OccurrenceCollection();
            oc.LoadOccurrencesBySystemIDAndDateRange(kiosk.SystemId, currentTime, lookAhead);

            return (from o in oc
                    select o).Distinct().ToList();
        }

        /// <summary>
        /// Loads an OccurrenceAttendance based on Person ID and Occurrence Start Time.  Calls new extension method
        /// on OccurrenceAttendance (not part of the Arena Framework).
        /// </summary>
        /// <param name="startDate">Start Time of an occurrence</param>
        /// <param name="personID">Person ID</param>
        /// <returns>An <see cref="Arena.Core.OccurrenceAttendance">OccurrenceAttendance</see> loaded by start date and person id</returns>
        public static OccurrenceAttendance GetAttendance(DateTime startDate, int personID)
        {
            OccurrenceAttendance oa = new OccurrenceAttendance();
            return oa.LoadOccurrenceAttendanceByStartDateAndPersonID(startDate, personID);
        }

        /// <summary>
        /// Sets provided person attribute's value to max ability level lookup id.
        /// </summary>
        /// <param name="personAttribute">Value that represents the LookupID for max ability level.</param>
        /// <param name="maxAbilityLevelLookupValue">Int value for max ability lookup</param>
        public static void SetChildToMaxAbility(PersonAttribute personAttribute, int maxAbilityLevelLookupValue)
        {
            if (personAttribute != null)
            {
                personAttribute.IntValue = maxAbilityLevelLookupValue;
                personAttribute.Save(ArenaContext.Current.Organization.OrganizationID, ArenaContext.Current.User.Identity.Name);
            }
        }

        /// <summary>
        /// Creates an OccurrenceCollection based on the criteria passed in.
        /// </summary>
        /// <param name="occurrenceEvents">IEnumerable collection of Occurrences to filter</param>
        /// <param name="person"><see cref="Arena.Core.FamilyMember">FamilyMember</see> to filter occurrences for</param>
        /// <param name="serviceTimes">Generic list of service times to filter by</param>
        /// <param name="abilityAttributeID">ID representing an Ability Level PersonAttribute</param>
        /// <param name="specialNeedsAttributeID">ID representing a Special Needs PersonAttribute</param>
        /// <returns>Filtered <see cref="Arena.Core.OccurrenceCollection">OccurrenceCollection</see></returns>
        public static List<Occurrence> FilterOccurrences(IEnumerable<Occurrence> occurrenceEvents, FamilyMember person,
            List<DateTime> serviceTimes, int abilityAttributeID, int specialNeedsAttributeID)
        {
            List<CheckInServiceInfo> services = new List<CheckInServiceInfo>();

            for (int i = 0; i < serviceTimes.Count; i++)
            {
                services.Add(new CheckInServiceInfo(serviceTimes[i], true));
            }

            return FilterOccurrences(occurrenceEvents, person, services, DateTime.Now, abilityAttributeID, specialNeedsAttributeID);
        }

        public static List<Occurrence> FilterOccurrences(IEnumerable<Occurrence> allClasses, FamilyMember person,
            List<CheckInServiceInfo> serviceTimes, DateTime currentTime, int abilityAttributeID, int specialNeedsAttributeID)
        {
            Dictionary<DateTime, Occurrence> matchingClasses = new Dictionary<DateTime, Occurrence>();
            StringBuilder log = new StringBuilder();
            log.AppendFormat("Attendee: {0} - {1}", person.PersonID, person.FullName);

            // Filtering occurrence collection by start time
            var openClassesByStartTime = (from o in allClasses
                                          let loc = new Location(o.LocationID)
                                          where (serviceTimes.Any(st => (st.StartTime == o.StartTime) && (st.IgnoreCheckInStart || o.CheckInStart <= currentTime)) &&
                                                 !loc.RoomClosed && !o.OccurrenceClosed)
                                          select o).ToList();

            /// loop through each class occurrence and constrain choices by
            /// age/grade, special needs, ability level, etc
            for (int i = 0; i < openClassesByStartTime.Count; i++)
            {
                Occurrence occurrence = openClassesByStartTime[i];
                bool matchesCriteria = false;
                OccurrenceTypeAttributeCollection occurrenceTypeAttributes = new OccurrenceTypeAttributeCollection(occurrence.OccurrenceTypeID);
                OccurrenceTypeAttribute occurrenceTypeAttribute = occurrenceTypeAttributes[0];

                // Check to see if filteredOccurrences already has an object w/ the same
                // start time. If it does, then no need to add another one with the same key.
                if (matchingClasses.ContainsKey(occurrence.StartTime))
                {
                    continue;
                }

                log.AppendFormat("\nAttempting match: {0} ({1}) {2}", occurrence.StartTime.ToShortTimeString(),
                                 occurrence.OccurrenceTypeID, occurrence.OccurrenceType.TypeName);

                // Now check existing Arena criteria
                if (RequiredAgeAndGrade(person, occurrence.OccurrenceType) &&
                    RequiredGender(person, occurrence.OccurrenceType))
                {
                    log.Append(" - Matched Age, Grade, Gender");

                    // If there is no OccurrenceTypeAttribute skip these checks.
                    if (occurrenceTypeAttribute != null && occurrenceTypeAttribute.OccurrenceTypeAttributeId != Constants.NULL_INT)
                    {
                        if (RequiredSpecialNeeds(person, occurrenceTypeAttribute, specialNeedsAttributeID) &&
                            RequiredAbilityLevel(person, occurrenceTypeAttribute, abilityAttributeID) &&
                            RequiredLastName(person, occurrenceTypeAttribute))
                        {
                            matchesCriteria = true;
                            log.Append(", Special Needs, Ability Level, Last Name");
                        }
                    }
                    else
                    {
                        matchesCriteria = true;
                    }
                }

                if (!matchesCriteria)
                {
                    continue;
                }

                // Checking for tag syncing/membership
                if (occurrence.OccurrenceType.MembershipRequired)
                {
                    // if child is member of a synced profile, add occurrence
                    if (occurrence.OccurrenceType.SyncWithProfile != Constants.NULL_INT)
                    {
                        ProfileMember pm = new ProfileMember(occurrence.OccurrenceType.SyncWithProfile, person.PersonID);

                        if (pm.ProfileID != Constants.NULL_INT)
                        {
                            GetClassByLoad(occurrence.StartTime, occurrenceTypeAttribute, occurrence, openClassesByStartTime, matchingClasses);
                            log.Append(", Required Membership - FOUND MATCH!\n");
                        }
                    }
                }
                else
                {
                    GetClassByLoad(occurrence.StartTime, occurrenceTypeAttribute, occurrence, openClassesByStartTime, matchingClasses);
                    log.Append(" - FOUND MATCH!\n");
                }
            }

            LogResults(log.ToString());
            List<Occurrence> filteredClasses = new List<Occurrence>();

            for (int i = 0; i < serviceTimes.Count; i++)
            {
                CheckInServiceInfo service = serviceTimes[i];

                if (matchingClasses.ContainsKey(service.StartTime))
                {
                    filteredClasses.Add(matchingClasses[service.StartTime]);
                }
                else
                {
                    filteredClasses.Add(GetEmptyOccurrence(service.StartTime));
                }
            }

            return filteredClasses;
        }

        /// <summary>
        /// Responsible for adding the correct class to list of eligible classes. If load balancing is enabled, will attempt to find the best matching
        /// class. This functionality requires Location Specific Occurrences to be set to "true".
        /// </summary>
        /// <param name="startTime">Occurrence Start Time</param>
        /// <param name="occurrenceTypeAttribute">OccurrenceTypeAttribute to determine if load balancing is needed</param>
        /// <param name="occurrence">Occurrence to be matched against</param>
        /// <param name="classes">Collection of all open classes</param>
        /// <param name="filteredClasses">Dictionary to add classes that match criteria</param>
        private static void GetClassByLoad(DateTime startTime, OccurrenceTypeAttribute occurrenceTypeAttribute, 
            Occurrence occurrence, IEnumerable<Occurrence> classes, IDictionary<DateTime, Occurrence> filteredClasses)
        {
            Occurrence matchingOccurrence = null;
            int lowestAttendanceCount = int.MaxValue;
            Location location;
            int headCount;
            bool belowCapacity;

            if (occurrenceTypeAttribute != null && 
                occurrenceTypeAttribute.OccurrenceTypeAttributeId != Constants.NULL_INT && 
                occurrenceTypeAttribute.IsRoomBalancing)
            {
                var matchingClasses = (from o in classes
                                       where o.OccurrenceTypeID == occurrence.OccurrenceTypeID && o.StartTime == startTime
                                       select o).ToList();

                for (int i = 0; i < matchingClasses.Count; i++)
                {
                    location = new Location(matchingClasses[i].LocationID);
                    headCount = location.GetHeadCountByDate(startTime);
                    belowCapacity = (headCount < location.MaxPeople || location.MaxPeople <= 0);

                    if (location.LocationId != Constants.NULL_INT && headCount < lowestAttendanceCount && belowCapacity)
                    {
                        lowestAttendanceCount = headCount;
                        matchingOccurrence = matchingClasses[i];
                    }
                }

                if (matchingOccurrence != null)
                {
                    filteredClasses.Add(startTime, matchingOccurrence);
                }
            }
            else
            {
                location = new Location(occurrence.LocationID);

                if (location.MaxPeople <= 0)
                {
                    belowCapacity = true;
                }
                else
                {
                    headCount = location.GetHeadCountByDate(startTime);
                    belowCapacity = (headCount < location.MaxPeople);
                }

                if (belowCapacity)
                {
                    filteredClasses.Add(startTime, occurrence);
                }
            }
        }

        private static void LogResults(string text)
        {
            Lookup typeLookup = new Lookup(SystemGuids.CHECKIN_APP_LOG_TYPE_LOOKUP, true);

            try
            {
                // Qualifier 1 = "IsEnabled"
                if (Convert.ToBoolean(typeLookup.Qualifier))
                {
                    AppLog applog = new AppLog
                                        {
                                            TypeLuid = typeLookup.LookupID,
                                            Date = DateTime.Now,
                                            Text = text
                                        };
                    applog.Save();
                }
            }
            catch (FormatException) { }
        }

        /// <summary>
        /// Iterates through Dictionary of family members, checks them in, and returns a Generic List of status strings.
        /// </summary>
        /// <param name="printProviderID">Lookup ID of selected print provider</param>
        /// <param name="familyID">ID of the current <see cref="Arena.Core.Family">Family</see> loaded from search</param>
        /// <param name="familyMap">Generic Dictionary of FamilyMembers (key) and OccurrenceCollections (value)</param>
		/// <param name="kiosk"><see cref="Arena.Computer.ComputerSystem">ComputerSystem</see> the family is standing at</param>
        /// <returns>Generic List of status messages</returns>
        public static List<string> CheckInFamily(int printProviderID, int familyID, Dictionary<FamilyMember, List<Occurrence>> familyMap, ComputerSystem kiosk)
        {
            IPrintLabel pl = PrintLabelHelper.GetPrintLabelClass(printProviderID);
            return CheckInFamily(pl, familyID, familyMap, kiosk);
        }

        public static List<string> CheckInFamily(IPrintLabel printLabel, int familyID, Dictionary<FamilyMember, 
            List<Occurrence>> familyMap, ComputerSystem kiosk)
        {
            List<string> results = new List<string>();
            Session session = new Session
            {
                FamilyId = familyID,
                SystemId = kiosk.SystemId
            };
            session.Save(ArenaContext.Current.User.Identity.Name);

            foreach (KeyValuePair<FamilyMember, List<Occurrence>> person in familyMap)
            {
                results.Add(CheckInFamilyMember(printLabel, person.Key, person.Value, session.SessionId, kiosk));
            }

            CheckOccurrenceAttendance(familyMap);
            return results;
        }

        /// <summary>
        /// Checks in an individual attendee.
        /// </summary>
        /// <param name="printLabel"><see cref="Arena.Custom.Cccev.CheckIn">IPrintLabel</see> to handle printing</param>
        /// <param name="attendee"><see cref="Arena.Core.FamilyMember">FamilyMember</see> to check in</param>
        /// <param name="occurrences"><see cref="Arena.Core.OccurrenceCollection">OccurrenceCollection</see> of Occurrences attendee can check into</param>
        /// <param name="sessionID">ID of the current CheckIn <see cref="Arena.CheckIn.Session">Session</see></param>
		/// <param name="kiosk"><see cref="Arena.Computer.ComputerSystem">ComputerSystem</see> the family is standing at</param>
        /// <returns>Status variable to be displayed on the view</returns>
        private static string CheckInFamilyMember(IPrintLabel printLabel, FamilyMember attendee, IEnumerable<Occurrence> occurrences, 
            int sessionID, ComputerSystem kiosk)
        {
            bool success = true;
            string output = Constants.NULL_STRING;
            OccurrenceAttendance firstAttendance = null;

            foreach (Occurrence occurrence in occurrences)
            {
                try
                {
                    if ((occurrence is EmptyOccurrence ||
                        occurrence.OccurrenceID == Constants.NULL_INT) &&
                        DateTime.Now > occurrence.CheckInEnd)
                    {
                        success = false;
                        output = string.Format("\t<tr><td class=\"resultTable\">{0}</td><td colspan=\"2\" class=\"resultTable fail\"><span class=\"fail\">{1}</span></td></tr>\n",
                            attendee.NickName, occurrence.Location);
                    }
                    else
                    {
                        OccurrenceAttendance attendance = new OccurrenceAttendance
                                                              {
                                                                  OccurrenceID = occurrence.OccurrenceID,
                                                                  PersonID = attendee.PersonID
                                                              };
                        ISecurityCode securityCode =
                            SecurityCodeHelper.GetSecurityCodeClass(SecurityCodeHelper.DefaultSecurityCodeSystem(ArenaContext.Current.Organization.OrganizationID));
                        attendance.SecurityCode = securityCode.GetSecurityCode();
                        attendance.Attended = true;
                        attendance.CheckInTime = DateTime.Now;
                        attendance.SessionID = sessionID;
                        attendance.Save(ArenaContext.Current.User.Identity.Name);

                        if (firstAttendance == null)
                        {
                            firstAttendance = attendance;
                        }
                    }
                }
                catch (SqlException ex)
                {
                    success = false;
                    output = string.Format("\t<tr><td class=\"resultTable\">{0}</td><td class=\"resultTable fail\">{1}</td><td class=\"resultTable fail\"><span class=\"fail\">{2}</span></td></tr>\n",
                    attendee.NickName, occurrences.First().Location, "Check-In Failure");

                    try
                    {
                        // If SQL exception is generated, we want to log it w/o taking the user out of the checkin app
                        new ExceptionHistoryData().AddUpdate_Exception(ex, ArenaContext.Current.Organization.OrganizationID,
                                ArenaContext.Current.User.Identity.Name, ArenaContext.Current.ServerUrl);
                    }
                    catch (SqlException) { }
                }
            }

            if (success)
            {
                output = PrintLabel(printLabel, attendee, occurrences, firstAttendance, kiosk);
            }

            return output;
        }

        private static void CheckOccurrenceAttendance(Dictionary<FamilyMember, List<Occurrence>> familyMap)
        {
            List<Occurrence> processedOccurrences = new List<Occurrence>();

            foreach (KeyValuePair<FamilyMember, List<Occurrence>> map in familyMap)
            {
                foreach (Occurrence occurrence in map.Value)
                {
                    if (!processedOccurrences.Contains(occurrence))
                    {
                        processedOccurrences.Add(occurrence);
                        Location location = new Location(occurrence.OccurrenceID);

                        if (occurrence.IsMaximumReached(location.GetHeadCountByDate(occurrence.StartTime), 0))
                        {
                            occurrence.OccurrenceClosed = true;
                            occurrence.Save(ArenaContext.Current.User.Identity.Name, false);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Public facade to allow for manually printing labels.  Calls private PrintLabel() method.
        /// </summary>
        /// <param name="printProviderID">Lookup ID of selected print provider</param>
        /// <param name="attendee"><see cref="Arena.Core.FamilyMember">FamilyMember</see> attending occurrence</param>
        /// <param name="occurrences"><see cref="Arena.Core.OccurrenceCollection">OccurrenceCollection</see> of Occurrences the attendee can check into</param>
		/// <param name="attendance"><see cref="Arena.Core.OccurrenceAttendance">OccurrenceAttendance</see> to be updated with failure status if print job fails</param>
		/// <param name="kiosk"><see cref="Arena.Computer.ComputerSystem">ComputerSystem</see> the family is standing at</param>
        /// <returns>boolean indicating whether or not the print job succeeded</returns>
        public static bool Print(int printProviderID, FamilyMember attendee, IEnumerable<Occurrence> occurrences, OccurrenceAttendance attendance, ComputerSystem kiosk)
        {
            IPrintLabel pl = PrintLabelHelper.GetPrintLabelClass(printProviderID);

            if (PrintLabel(pl, attendee, occurrences, attendance, kiosk).Contains("Print Failure"))
            {
                return false;
            }

            return true;
        }

        
        public static bool Print(IPrintLabel printLabel, FamilyMember attendee, IEnumerable<Occurrence> occurrences, OccurrenceAttendance attendance, ComputerSystem kiosk)
        {
            if (PrintLabel(printLabel, attendee, occurrences, attendance, kiosk).Contains("Print Failure"))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Tells printer to print CheckIn label.
        /// </summary>
        /// <param name="printLabel"><see cref="Arena.Custom.Cccev.CheckIn">IPrintLabel</see> to handle printing</param>
        /// <param name="attendee"><see cref="Arena.Core.FamilyMember">FamilyMember</see> attending occurrence</param>
        /// <param name="occurrences"><see cref="Arena.Core.OccurrenceCollection">OccurrenceCollection</see> of Occurrences the attendee can check into</param>
        /// <param name="attendance"><see cref="Arena.Core.OccurrenceAttendance">OccurrenceAttendance</see> to be updated with failure status if print job fails</param>
		/// <param name="kiosk"><see cref="Arena.Computer.ComputerSystem">ComputerSystem</see> the family is standing at</param>
        /// <returns>Status variable to be displayed on the view</returns>
        private static string PrintLabel(IPrintLabel printLabel, FamilyMember attendee, IEnumerable<Occurrence> occurrences, OccurrenceAttendance attendance, ComputerSystem kiosk)
        {
			try
            {
                printLabel.Print(attendee, occurrences, attendance, kiosk);
                return string.Format("\t<tr><td class=\"resultTable\">{0}</td><td class=\"resultTable\"><span class=\"classroomText\">{1}</span></td><td class=\"resultTable success\">&nbsp;</td></tr>\n",
                    attendee.NickName, occurrences.First().Location);
            }
            catch (Exception ex)
            {
                attendance.Notes = "Print Failure";
                attendance.Save(ArenaContext.Current.User.Identity.Name);

                try
                {
                    new ExceptionHistoryData().AddUpdate_Exception(ex, ArenaContext.Current.Organization.OrganizationID,
                                ArenaContext.Current.User.Identity.Name, ArenaContext.Current.ServerUrl);
                }
                catch (SqlException) { }

                return string.Format("\t<tr><td class=\"resultTable\">{0}</td><td class=\"resultTable\">{1}</td><td class=\"resultTable fail\"><span class=\"fail\">{2}</span></td></tr>\n",
                    attendee.NickName, occurrences.First().Location, attendance.Notes);
            }
        }

        private static Occurrence GetEmptyOccurrence(DateTime startTime)
        {
            return new EmptyOccurrence(startTime);
        }

        /// <summary>
        /// Shortens and adds an elipsis ("...") to provides string to 36 characters.
        /// </summary>
        /// <param name="text">string to shorten</param>
        /// <returns>Truncated string</returns>
        public static string TruncateText(string text)
        {
            if (text.Length >= 20)
            {
                return text.Substring(0, 19) + "...";
            }

            return text;
        }

        /// <summary>
        /// Determines whether or not age or grade are required for checkin.
        /// </summary>
        /// <param name="person"><see cref="Arena.Core.FamilyMember">FamilyMember</see> to test against</param>
        /// <param name="type"><see cref="Arena.Core.OccurrenceType">OccurrenceType</see> that determines test criteria</param>
        /// <returns>bool based on whether the person's age or grade falls within the allowable ages or grades</returns>
        private static bool RequiredAgeAndGrade(Person person, OccurrenceType type)
        {
            if (type.MinGrade != Constants.NULL_INT || type.MaxGrade != Constants.NULL_INT)
            {
                int gradeLevel = Person.CalculateGradeLevel(person.GraduationDate, ArenaContext.Current.Organization.GradePromotionDate);
                return (gradeLevel >= type.MinGrade && gradeLevel <= type.MaxGrade);
            }
            
            if ((type.MinAge != 0 || type.MaxAge != 0) &&
                (type.MinAge != Constants.NULL_INT || type.MaxAge != Constants.NULL_INT))
            {
                decimal fractionalAge = DateUtils.GetFractionalAge(person.BirthDate);
                return (fractionalAge >= type.MinAge && fractionalAge <= type.MaxAge);
            }
            
            return true;
        }

        /// <summary>
        /// Determines whether or not special needs is required for checkin.
        /// </summary>
        /// <param name="person"><see cref="Arena.Core.FamilyMember">FamilyMember</see> to test against</param>
        /// <param name="attribute"><see cref="Arena.Custom.Cccev.CheckIn.Entity.OccurrenceTypeAttribute">OccurrenceTypeAttribute</see> that determines test criteria</param>
        /// <param name="attributeID">ID representing a Special Needs PersonAttribute</param>
        /// <returns>bool based on whether the person attribute matches the OccurrenceTypeAttribute's requirement for special needs</returns>
        private static bool RequiredSpecialNeeds(Person person, OccurrenceTypeAttribute attribute, int attributeID)
        {
            if (attribute == null)
            {
                return true;
            }
            
            if (!attribute.IsSpecialNeeds)
            {
                return true;
            }
            
            PersonAttribute pa = new PersonAttribute(person.PersonID, attributeID);
            bool specialNeeds = pa.IntValue == 1;  // Arena Framework uses int values in Person Attribute to reflect true/false
            return (specialNeeds == attribute.IsSpecialNeeds);
        }

        /// <summary>
        /// Determines whether or not certain ability levels are required for checkin.
        /// </summary>
        /// <param name="person"><see cref="Arena.Core.FamilyMember">FamilyMember</see> to test against</param>
        /// <param name="attribute"><see cref="Arena.Custom.Cccev.CheckIn.Entity.OccurrenceTypeAttribute">OccurrenceTypeAttribute</see> that determines test criteria</param>
        /// <param name="attributeID">ID representing an Ability Level PersonAttribute</param>
        /// <returns>bool based on whether the person attribute matches the OccurrenceTypeAttribute's requirement for ability level</returns>
        private static bool RequiredAbilityLevel(Person person, OccurrenceTypeAttribute attribute, int attributeID)
        {
            bool result = false;

            if (attribute == null)
            {
                result = true;
            }
            else if (attribute.AbilityLevelLookupIDs.Count == 0 )
            {
                result = true;
            }
            else
            {
                PersonAttribute pa = new PersonAttribute(person.PersonID, attributeID);
				foreach ( int abilityLevel in attribute.AbilityLevelLookupIDs )
				{
					if ( pa.IntValue == abilityLevel )
					{
						result = true;
						break;
					}
				}
            }

            return result;
        }

        /// <summary>
        /// Determines whether or not gender is required for checkin.
        /// </summary>
        /// <param name="person"><see cref="Arena.Core.FamilyMember">FamilyMember</see> to test against</param>
        /// <param name="type"><see cref="Arena.Core.OccurrenceType">OccurrenceType</see> that determines test criteria</param>
        /// <returns>bool based on whether the person's gender matches the gender requirement of the occurrence type</returns>
        private static bool RequiredGender(Person person, OccurrenceType type)
        {
            if (type.GenderPreference == GenderPreference.Everyone)
            {
                return true;
            }
            
            return (person.Gender.ToString() == type.GenderPreference.ToString());
        }

        /// <summary>
        /// Determines whether or not last initial needs to fall within a given range for checkin.
        /// </summary>
        /// <param name="person"><see cref="Arena.Core.FamilyMember">FamilyMember</see> to test against</param>
        /// <param name="attribute"><see cref="OccurrenceTypeAttribute">OccurrenceTypeAttribute</see> that determines test criteria</param>
        /// <returns>bool based on whether the person's last initial falls within the range required by the occurrence type attribute</returns>
        private static bool RequiredLastName(Person person, OccurrenceTypeAttribute attribute)
        {
            if (attribute == null)
            {
                return true;
            }
            
            if (attribute.LastNameStartingLetter.Trim() == Constants.NULL_STRING &&
                attribute.LastNameEndingLetter.Trim() == Constants.NULL_STRING)
            {
                return true;
            }
            
            char rangeStart = 'A';
            char rangeEnd = 'Z';

            if (attribute.LastNameStartingLetter.Trim() != Constants.NULL_STRING)
            {
                rangeStart = char.Parse(attribute.LastNameStartingLetter.ToUpper());
            }

            if (attribute.LastNameEndingLetter.Trim() != Constants.NULL_STRING)
            {
                rangeEnd = char.Parse(attribute.LastNameEndingLetter.ToUpper());
            }

            char lastInitial = char.Parse(person.LastName.Substring(0, 1).ToUpper());
            return (lastInitial >= rangeStart && lastInitial <= rangeEnd);
        }
    }
}