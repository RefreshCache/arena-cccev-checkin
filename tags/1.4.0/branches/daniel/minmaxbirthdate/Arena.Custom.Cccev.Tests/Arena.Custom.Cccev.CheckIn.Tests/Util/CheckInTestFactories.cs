/**********************************************************************
* Description:  Factory methods to support integration tests.
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: 11/23/2009
*
* $Workfile: CheckInTestFactories.cs $
* $Revision: 1 $
* $Header: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/Util/CheckInTestFactories.cs   1   2009-12-14 17:26:50-07:00   JasonO $
*
* $Log: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/Util/CheckInTestFactories.cs $
*  
*  Revision: 1   Date: 2009-12-15 00:26:50Z   User: JasonO 
*  
*  Revision: 1   Date: 2009-12-01 22:39:45Z   User: JasonO 
**********************************************************************/

using System;
using Arena.Core;
using Arena.Enums;
using Arena.Event;
using Arena.Organization;

namespace Arena.Custom.Cccev.CheckIn.Tests.Util
{
    public class CheckInTestFactories
    {
        public static FamilyMember CreateFamilyMember()
        {
            FamilyMember child = new FamilyMember
                                     {
                                         FirstName = CheckInTestConstants.FIRST_NAME,
                                         NickName = CheckInTestConstants.FIRST_NAME,
                                         LastName = CheckInTestConstants.LAST_NAME,
                                         BirthDate = DateTime.Now.AddYears(-10),
                                         GraduationDate = DateTime.Now.AddYears(8),
                                         RecordStatus = RecordStatus.Active,
                                         MemberStatus = new Lookup(958),
                                         FamilyRole = new Lookup(31)
                                     };

            child.AlternateIDs.Add(CreateAltID());
            child.Phones.Add(CreatePersonPhone());
            return child;
        }

        public static Family CreateFamily()
        {
            Family family = new Family
                                {
                                    FamilyName = string.Format("{0} Family", CheckInTestConstants.LAST_NAME),
                                    OrganizationID = 1
                                };
            return family;
        }

        public static PersonAttribute CreatePersonAttribute(Person person)
        {
            PersonAttribute attribute = new PersonAttribute
                                            {
                                                IntValue = 1, 
                                                PersonID = person.PersonID
                                            };
            person.Attributes.Add(attribute);
            return attribute;
        }

        public static Relationship CreateRelationship(Person person, Person relative)
        {
            Relationship relationship = new Relationship
                                            {
                                                Person = person,
                                                RelatedPerson = relative,
                                                RelationshipType = new RelationshipType(CheckInTestConstants.RELATIONSHIP_TYPE_ID)
                                            };
            return relationship;
        }

        public static Occurrence CreateOccurrence()
        {
            Occurrence occurrence = new Occurrence
                                        {
                                            CheckInStart = DateTime.Now.AddMinutes(-1),
                                            StartTime = DateTime.Now.AddMinutes(5),
                                            CheckInEnd = DateTime.Now.AddMinutes(30),
                                            EndTime = DateTime.Now.AddMinutes(60)
                                        };
            return occurrence;
        }

        public static Occurrence CreateInvalidOccurrence()
        {
            Occurrence occurrence = new Occurrence
                                        {
                                            CheckInStart = DateTime.Now.AddMinutes(15),
                                            StartTime = DateTime.Now.AddMinutes(15),
                                            CheckInEnd = DateTime.Now.AddMinutes(40),
                                            EndTime = DateTime.Now.AddMinutes(70)
                                        };
            return occurrence;
        }

        public static OccurrenceType CreateOccurrenceType()
        {
            OccurrenceType occurrenceType = new OccurrenceType
                                                {
                                                    TypeName = "Test Occurrence Type",
                                                    IsService = true,
                                                    GenderPreference = GenderPreference.Everyone
                                                };
            return occurrenceType;
        }

        public static OccurrenceTypeGroup CreateOccurrenceTypeGroup()
        {
            OccurrenceTypeGroup group = new OccurrenceTypeGroup
                                            {
                                                GroupName = "Test Group",
                                                ReportStart = DateTime.Now.AddMinutes(-30),
                                                ReportEnd = DateTime.Now.AddMinutes(30),
                                                OrganizationId = 1
                                            };
            return group;
        }

        public static Location CreateLocation()
        {
            Location location = new Location
                                    {
                                        LocationName = "Test Location",
                                        OrganizationId = 1,
                                        RoomClosed = false
                                    };
            return location;
        }

        public static OccurrenceAttendance CreateAttendance(Occurrence occurrence, Person attendee)
        {
            OccurrenceAttendance attendance = new OccurrenceAttendance
                                                  {
                                                      Attended = true,
                                                      CheckInTime = DateTime.Now,
                                                      OccurrenceID = occurrence.OccurrenceID,
                                                      PersonID = attendee.PersonID
                                                  };
            return attendance;
        }

        public static EventProfile CreateEventProfile(Occurrence occurrence)
        {
            EventProfile eventProfile = new EventProfile
                                            {
                                                CategoryLevel = false,
                                                Details = "Test event profile",
                                                End = occurrence.EndTime,
                                                Location = new Location(occurrence.LocationID),
                                                Name = "Test Event",
                                                OrganizationID = 1,
                                                Start = occurrence.StartTime,
                                                ETicketEnabled = false
                                            };
            return eventProfile;
        }

        public static ProfileMember CreateProfileMember(EventProfile eventProfile, Person person)
        {
            ProfileMember member = new ProfileMember
                                       {
                                           ProfileID = eventProfile.ProfileID,
                                           PersonID = person.PersonID,
                                           Source = new Lookup(SystemLookup.TopicEntityType_EventTag),
                                           Status = new Lookup(SystemLookup.ServingActivityType_StatusChange)
                                       };
            return member;
        }

        public static ProfileOccurrence CreateProfileOccurrence(EventProfile eventProfile, Occurrence occurrence)
        {
            ProfileOccurrence profileOccurrence = new ProfileOccurrence
                                                      {
                                                          LocationID = occurrence.LocationID,
                                                          Name = eventProfile.Name,
                                                          OccurrenceClosed = occurrence.OccurrenceClosed,
                                                          OccurrenceID = occurrence.OccurrenceID,
                                                          OccurrenceType = occurrence.OccurrenceType,
                                                          ProfileID = eventProfile.ProfileID,
                                                          StartTime = occurrence.StartTime
                                                      };
            return profileOccurrence;
        }

        private static AltID CreateAltID()
        {
            return new AltID
                       {
                           IdType = AltIdType.Person,
                           AltId = CheckInTestConstants.ALT_ID
                       };
        }

        private static PersonPhone CreatePersonPhone()
        {
            return new PersonPhone
                       {
                           Number = CheckInTestConstants.PHONE_NUMBER,
                           PhoneType = new Lookup(CheckInTestConstants.PHONE_TYPE)
                       };
        }
    }
}
