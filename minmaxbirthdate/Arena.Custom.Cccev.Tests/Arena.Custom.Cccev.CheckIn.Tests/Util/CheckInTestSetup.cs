/**********************************************************************
* Description:  Setup methods to support integration tests.
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: 11/23/2009
*
* $Workfile: CheckInTestSetup.cs $
* $Revision: 1 $
* $Header: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/Util/CheckInTestSetup.cs   1   2009-12-14 17:26:50-07:00   JasonO $
*
* $Log: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/Util/CheckInTestSetup.cs $
*  
*  Revision: 1   Date: 2009-12-15 00:26:50Z   User: JasonO 
*  
*  Revision: 1   Date: 2009-12-01 22:39:45Z   User: JasonO 
**********************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using Arena.Computer;
using Arena.Core;
using Arena.Custom.Cccev.CheckIn.Entity;
using Arena.Custom.Cccev.DataUtils;
using Arena.Custom.Cccev.FrameworkUtils.FrameworkConstants;
using Arena.Enums;
using Arena.Organization;

namespace Arena.Custom.Cccev.CheckIn.Tests.Util
{
    public static class CheckInTestSetup
    {
        public static ComputerSystem SetupKiosk()
        {
            string hostName = Dns.GetHostName();
            ComputerSystem system = new ComputerSystem(hostName, true);
            IPHostEntry ipEntry;

            if (system.SystemId == Constants.NULL_INT)
            {
                ipEntry = Dns.GetHostEntry(hostName);
                var ipAddress = ipEntry.AddressList.First();

                foreach (var ip in ipEntry.AddressList)
                {
                    system.LoadByKioskIp(ip.ToString());

                    if (system.SystemId != Constants.NULL_INT)
                    {
                        ipAddress = ip;
                        break;
                    }
                }

                system.Kiosk = true;
                system.Active = true;
                system.OrganizationId = CheckInTestConstants.ORG_ID;

                if (system.SystemId == Constants.NULL_INT)
                {
                    system.SystemName = string.Format("Test System - {0}", ipAddress);
                    system.Save();
                    system.RegisterIpAddresses(ipEntry.AddressList);
                }
                else
                {
                    system.Save();
                }
            }

            return system;
        }

        public static void SetupAltIDSearch()
        {
            var family = CheckInTestFactories.CreateFamily();
            family.Save(CheckInTestConstants.USER_ID);
            var child = CheckInTestFactories.CreateFamilyMember();
            child.FamilyID = family.FamilyID;
            child.Save(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID, false);   // Person.Save()
            child.Save(CheckInTestConstants.USER_ID);                                       // FamilyMember.Save()
            child.SaveAlternativeIDs(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID);
        }

        public static FamilyMember SetupPhoneSearch()
        {
            var family = CheckInTestFactories.CreateFamily();
            family.Save(CheckInTestConstants.USER_ID);
            var child = CheckInTestFactories.CreateFamilyMember();
            child.FamilyID = family.FamilyID;
            child.Save(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID, false);   // Person.Save()
            child.Save(CheckInTestConstants.USER_ID);                                       // FamilyMember.Save()
            child.Phones[0].PersonID = child.PersonID;
            child.SavePhones(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID);
            return child;
        }

        public static Family SetupRelativeSearch()
        {
            var family = CheckInTestFactories.CreateFamily();
            family.Save(CheckInTestConstants.USER_ID);
            var child = CheckInTestFactories.CreateFamilyMember();
            child.FamilyID = family.FamilyID;
            child.Save(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID, false);   // Person.Save()
            child.Save(CheckInTestConstants.USER_ID);                                       // FamilyMember.Save()
            return family;
        }

        public static Family SetupRelativeSearchWithRelatives()
        {
            var family = CheckInTestFactories.CreateFamily();
            family.Save(CheckInTestConstants.USER_ID);

            var adult = CheckInTestFactories.CreateFamilyMember();
            adult.FamilyRole = new Lookup(29);
            adult.FamilyID = family.FamilyID;
            adult.BirthDate = new DateTime(1979, 1, 1);
            adult.Gender = Gender.Male;
            adult.Save(1, CheckInTestConstants.USER_ID, false);
            adult.Save(CheckInTestConstants.USER_ID);
            family.FamilyMembers.Add(adult);

            var child = CheckInTestFactories.CreateFamilyMember();
            child.FamilyID = family.FamilyID;
            child.Save(1, CheckInTestConstants.USER_ID, false);
            child.Save(CheckInTestConstants.USER_ID);
            family.FamilyMembers.Add(child);
            family.Save(CheckInTestConstants.USER_ID);

            var relatedFamily = CheckInTestFactories.CreateFamily();
            relatedFamily.Save(CheckInTestConstants.USER_ID);

            var relative = CheckInTestFactories.CreateFamilyMember();
            relative.FamilyID = relatedFamily.FamilyID;
            relative.Save(1, CheckInTestConstants.USER_ID, false);
            relative.Save(CheckInTestConstants.USER_ID);
            relatedFamily.FamilyMembers.Add(relative);
            relatedFamily.Save(CheckInTestConstants.USER_ID);

            var relationship = CheckInTestFactories.CreateRelationship(adult, relative);
            relationship.Save(CheckInTestConstants.USER_ID);
            return family;
        }

        public static Occurrence SetupOccurrenceSearch(ComputerSystem kiosk)
        {
            const string userID = CheckInTestConstants.USER_ID;

            var occurrence = CheckInTestFactories.CreateOccurrence();
            var type = CheckInTestFactories.CreateOccurrenceType();
            var group = CheckInTestFactories.CreateOccurrenceTypeGroup();

            group.Save(userID);
            type.GroupId = group.GroupId;
            type.Save(userID);
            group.OccurrenceTypes.Add(type);
            group.Save(userID);

            occurrence.OccurrenceTypeID = type.OccurrenceTypeId;
            occurrence.Save(userID);
            type.Occurrences.Add(occurrence);
            type.Save(userID);

            var location = CheckInTestFactories.CreateLocation();
            location.OccurrenceTypes.Add(type);
            location.Save(userID);

            occurrence.LocationID = location.LocationId;
            occurrence.Save(userID);

            type.Locations.Add(location);
            type.Save(userID);

            kiosk.Locations.Add(location);
            kiosk.Save();
            kiosk.SaveLocations(new[] { location.LocationId });
            return occurrence;
        }

        public static Occurrence SetupOccurrenceSearchFullRoom(ComputerSystem kiosk)
        {
            var occurrence = SetupOccurrenceSearch(kiosk);
            var location = new Location(occurrence.LocationID) { MaxPeople = 5 };
            location.Save(CheckInTestConstants.USER_ID);

            for (int i = 0; i < 5; i++)
            {
                var person = CheckInTestFactories.CreateFamilyMember();
                person.Save(1, CheckInTestConstants.USER_ID, false);
                var occurrenceAttendance = CheckInTestFactories.CreateAttendance(occurrence, person);
                occurrenceAttendance.Save(CheckInTestConstants.USER_ID);
            }

            return occurrence;
        }

        public static List<Occurrence> SetupOccurrenceSearchMultipleOccurrences(ComputerSystem kiosk)
        {
            List<Occurrence> occurrences = new List<Occurrence>();
            var occurrence = SetupOccurrenceSearch(kiosk);
            occurrences.Add(occurrence);

            var location = CheckInTestFactories.CreateLocation();
            location.OccurrenceTypes.Add(occurrence.OccurrenceType);
            location.Save(CheckInTestConstants.USER_ID);

            occurrence.OccurrenceType.Locations.Add(location);
            occurrence.OccurrenceType.Save(CheckInTestConstants.USER_ID);

            kiosk.Locations.Add(location);
            kiosk.Save();
            kiosk.SaveLocations(new[] { location.LocationId });

            var newOccurrence = CheckInTestFactories.CreateOccurrence();
            newOccurrence.OccurrenceTypeID = occurrence.OccurrenceTypeID;
            newOccurrence.StartTime = occurrence.StartTime;
            newOccurrence.LocationID = location.LocationId;
            newOccurrence.Save(CheckInTestConstants.USER_ID);

            occurrences.Add(newOccurrence);
            return occurrences;
        }

        public static List<Occurrence> SetupOccurrenceSearchMultipleOccurrencesWithClosedLocation(ComputerSystem kiosk)
        {
            var occurrences = SetupOccurrenceSearchMultipleOccurrences(kiosk);
            var location = new Location(occurrences.First().LocationID) { RoomClosed = true };
            location.Save(CheckInTestConstants.USER_ID);
            return occurrences;
        }

        public static List<Occurrence> SetupOccurrenceSearchRoomBalancing(ComputerSystem kiosk)
        {
            List<Occurrence> occurrences = SetupOccurrenceSearchMultipleOccurrences(kiosk);
            var attribute = new OccurrenceTypeAttribute
                                {
                                    OccurrenceTypeId = occurrences.First().OccurrenceTypeID, 
                                    IsRoomBalancing = true
                                };
            attribute.Save(CheckInTestConstants.USER_ID);

            var person = CheckInTestFactories.CreateFamilyMember();
            person.Save(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID, false);
            var attendance = new OccurrenceAttendance
                                 {
                                     OccurrenceID = occurrences.First().OccurrenceID, 
                                     PersonID = person.PersonID, 
                                     Attended = true,
                                     CheckInTime = DateTime.Now.AddMinutes(-2)
                                 };
            attendance.Save(CheckInTestConstants.USER_ID);
            return occurrences;
        }

        public static Occurrence SetupOccurrenceSearchSpecialNeeds(ComputerSystem kiosk)
        {
            var occurrence = SetupOccurrenceSearch(kiosk);
            var attribute = new OccurrenceTypeAttribute
                                {
                                    IsSpecialNeeds = true, 
                                    OccurrenceTypeId = occurrence.OccurrenceTypeID
                                };

            attribute.Save(CheckInTestConstants.USER_ID);
            return occurrence;
        }

        public static Occurrence SetupOccurrenceSearchAbilityLevel(ComputerSystem kiosk)
        {
            var occurrence = SetupOccurrenceSearch(kiosk);
            var attribute = new OccurrenceTypeAttribute
                                {
                                    IsSpecialNeeds = true,
                                    OccurrenceTypeId = occurrence.OccurrenceTypeID
                                };

            var abilityLevels = new LookupType(SystemGuids.ABILITY_LEVEL_LOOKUP_TYPE);
            var lookup = (from al in abilityLevels.Values.OfType<Lookup>()
                          orderby al.Order ascending
                          select al).Last();

            attribute.AbilityLevelLookupIDs = new List<int> { lookup.LookupID };
            attribute.Save(CheckInTestConstants.USER_ID);
            return occurrence;
        }

        public static Occurrence SetupOccurrenceSearchLastName(ComputerSystem kiosk)
        {
            var occurrence = SetupOccurrenceSearch(kiosk);
            var attribute = new OccurrenceTypeAttribute
                                {
                                    IsSpecialNeeds = false,
                                    OccurrenceTypeId = occurrence.OccurrenceTypeID,
                                    LastNameStartingLetter = "A",
                                    LastNameEndingLetter = "L"
                                };

            attribute.Save(CheckInTestConstants.USER_ID);
            return occurrence;
        }

        public static PersonAttribute SetupPersonAttribute(Person person)
        {
            var attribute = CheckInTestFactories.CreatePersonAttribute(person);
            attribute.AttributeType = DataType.Int;
            attribute.Save(CheckInTestConstants.USER_ID);
            person.SaveAttributes(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID);
            return attribute;
        }

        public static PersonAttribute SetupAbilityLevelAttributeInvalid(Person person)
        {
            var attribute = CheckInTestFactories.CreatePersonAttribute(person);
            attribute.AttributeType = DataType.Lookup;

            var abilityLevels = new LookupType(SystemGuids.ABILITY_LEVEL_LOOKUP_TYPE);
            var lookup = (from al in abilityLevels.Values.OfType<Lookup>()
                          orderby al.Order ascending
                          select al).First();

            attribute.IntValue = lookup.LookupID;
            attribute.Save(CheckInTestConstants.USER_ID);
            person.SaveAttributes(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID);
            return attribute;
        }

        public static PersonAttribute SetupAbilityLevelAttribute(Person person)
        {
            var attribute = CheckInTestFactories.CreatePersonAttribute(person);
            attribute.AttributeType = DataType.Lookup;

            var abilityLevels = new LookupType(SystemGuids.ABILITY_LEVEL_LOOKUP_TYPE);
            var lookup = (from al in abilityLevels.Values.OfType<Lookup>()
                          orderby al.Order ascending
                          select al).Last();

            attribute.IntValue = lookup.LookupID;
            attribute.Save(CheckInTestConstants.USER_ID);
            person.SaveAttributes(CheckInTestConstants.ORG_ID, CheckInTestConstants.USER_ID);
            return attribute;
        }

        public static Occurrence SetupOccurrenceSearchMembershipRequired(ComputerSystem kiosk, Person person)
        {
            var occurrence = SetupOccurrenceSearch(kiosk);
            var eventProfile = CheckInTestFactories.CreateEventProfile(occurrence);
            eventProfile.Save(CheckInTestConstants.USER_ID);

            var member = CheckInTestFactories.CreateProfileMember(eventProfile, person);
            eventProfile.Members.Add(member);
            member.Save(CheckInTestConstants.USER_ID);
            eventProfile.Save(CheckInTestConstants.USER_ID);

            var profileOccurrence = CheckInTestFactories.CreateProfileOccurrence(eventProfile, occurrence);
            profileOccurrence.Save(CheckInTestConstants.USER_ID);
            eventProfile.Occurrences.Add(profileOccurrence);
            eventProfile.Save(CheckInTestConstants.USER_ID);

            occurrence.OccurrenceType.MembershipRequired = true;
            occurrence.OccurrenceType.SyncWithProfile = eventProfile.ProfileID;
            occurrence.Save(CheckInTestConstants.USER_ID);
            return occurrence;
        }

        public static Occurrence SetupOccurrenceSearchInvalidMembershipRequired(ComputerSystem kiosk, Person person)
        {
            var occurrence = SetupOccurrenceSearch(kiosk);
            var eventProfile = CheckInTestFactories.CreateEventProfile(occurrence);
            eventProfile.Save(CheckInTestConstants.USER_ID);

            occurrence.OccurrenceType.MembershipRequired = true;
            occurrence.OccurrenceType.SyncWithProfile = eventProfile.ProfileID;
            occurrence.Save(CheckInTestConstants.USER_ID);
            return occurrence;
        }
    }
}
