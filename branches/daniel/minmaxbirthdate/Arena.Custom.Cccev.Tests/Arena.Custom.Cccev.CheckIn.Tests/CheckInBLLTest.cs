/**********************************************************************
* Description:  Integration tests for Check-In.
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: 11/23/2009
*
* $Workfile: CheckInBLLTest.cs $
* $Revision: 2 $
* $Header: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/CheckInBLLTest.cs   2   2010-11-03 15:24:27-07:00   JasonO $
*
* $Log: /trunk/Arena.Custom.Cccev.Tests/Arena.Custom.Cccev.CheckIn.Tests/CheckInBLLTest.cs $
*  
*  Revision: 2   Date: 2010-11-03 22:24:27Z   User: JasonO 
*  Updating test logic to reflect new BLL changes. 
*  
*  Revision: 1   Date: 2009-12-15 00:26:50Z   User: JasonO 
*  
*  Revision: 1   Date: 2009-12-01 22:39:45Z   User: JasonO 
**********************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Transactions;
using Arena.Core;
using Arena.Custom.Cccev.CheckIn.Entity;
using Arena.Custom.Cccev.CheckIn.Tests.Mocks;
using Arena.Custom.Cccev.CheckIn.Tests.Util;
using Arena.Custom.Cccev.DataUtils;
using Arena.Enums;
using Arena.Organization;
using NUnit.Framework;

namespace Arena.Custom.Cccev.CheckIn.Tests
{
    /// <summary>
    /// A suite of integration tests for Cccev's Check-In system. These tests
    /// should verify that all the domain logic within the Arena Framework is 
    /// working as expected, and that the business rules of Cccev's Check-In
    /// app are being adhered to.
    /// </summary>
    [TestFixture]
    public class CheckInBLLTest
    {
        [Test]
        public void CanCheckIn_Should_Return_False_If_Child_Is_Too_Old()
        {
            using (new TransactionScope())
            {
                var child = CheckInTestFactories.CreateFamilyMember();
                var result = CheckInController.CanCheckIn(child, 
                    CheckInTestConstants.MAX_AGE_LO, CheckInTestConstants.MAX_GRADE_LO);
                Assert.IsFalse(result);
            }
        }

        [Test]
        public void CanCheckIn_Should_Return_True_If_Child_Is_Old_Enough()
        {
            using (new TransactionScope())
            {
                var child = CheckInTestFactories.CreateFamilyMember();
                var result = CheckInController.CanCheckIn(child, 
                    CheckInTestConstants.MAX_AGE_HI, CheckInTestConstants.MAX_GRADE_HI);
                Assert.IsTrue(result);
            }
        }

        [Test]
        public void ReadyForCheckIn_Should_Return_False_If_CheckInStart_Has_Not_Passed()
        {
            using (new TransactionScope())
            {
                var occurrence = CheckInTestFactories.CreateInvalidOccurrence();
                var result = CheckInController.ReadyForCheckIn(occurrence);
                Assert.IsFalse(result);
            }
        }

        [Test]
        public void ReadyForCheckIn_Should_Return_True_If_CheckInStart_Has_Passed()
        {
            using (new TransactionScope())
            {
                var occurrence = CheckInTestFactories.CreateOccurrence();
                var result = CheckInController.ReadyForCheckIn(occurrence);
                Assert.IsTrue(result);
            }
        }

        [Test]
        public void GetFamily_Should_Return_Family_When_AltID_Is_Valid()
        {
            using (new TransactionScope())
            {
                CheckInTestSetup.SetupAltIDSearch();
                var result = CheckInController.GetFamily(CheckInSearchTypes.Scanner, CheckInTestConstants.ALT_ID);
                
                Assert.IsNotEmpty(result);
                Assert.AreNotEqual(result[0].FamilyID, Constants.NULL_INT);
            }
        }

        [Test]
        public void GetFamily_Should_Return_Empty_Family_When_AltID_Is_Invalid()
        {
            using (new TransactionScope())
            {
                CheckInTestSetup.SetupAltIDSearch();
                var result = CheckInController.GetFamily(CheckInSearchTypes.Scanner, "Invalid Alt ID");
                Assert.AreEqual(result[0].FamilyID, -1);
            }
        }

        [Test]
        public void GetFamily_Should_Return_Family_When_Phone_Is_Valid()
        {
            using (new TransactionScope())
            {
                CheckInTestSetup.SetupPhoneSearch();
                var result = CheckInController.GetFamily(CheckInSearchTypes.PhoneNumber, CheckInTestConstants.PHONE_NUMBER);
                
                Assert.IsNotEmpty(result);
                Assert.AreNotEqual(result[0].FamilyID, Constants.NULL_INT);
            }
        }

        [Test]
        public void GetFamily_Should_Return_Empty_When_Phone_Is_Invalid()
        {
            using (new TransactionScope())
            {
                CheckInTestSetup.SetupPhoneSearch();
                var result = CheckInController.GetFamily(CheckInSearchTypes.PhoneNumber, "Invalid Phone Number");
                Assert.IsEmpty(result);
            }
        }

        [Test]
        public void GetRelatives_Should_Return_Only_FamilyMembers_When_No_Relationships_Set()
        {
            using (new TransactionScope())
            {
                var family = CheckInTestSetup.SetupRelativeSearch();
                var result = CheckInController.GetRelatives(family);
                Assert.AreEqual(result.Count, family.Children().Count);
            }
        }

        [Test]
        public void GetRelatives_Should_Return_All_Relatives_When_Relationships_Set()
        {
            using (new TransactionScope())
            {
                var family = CheckInTestSetup.SetupRelativeSearchWithRelatives();
                var result = CheckInController.GetRelatives(family, new[] { CheckInTestConstants.RELATIONSHIP_TYPE_ID });
                Assert.Greater(result.Count, family.Children().Count);
            }
        }

        [Test]
        public void GetCurrentKiosk_Should_Return_Null_When_IP_Is_Invalid()
        {
            using (new TransactionScope())
            {
                var result = CheckInController.GetCurrentKiosk(CheckInTestConstants.INVALID_IP);
                Assert.Null(result);
            }
        }

        [Test]
        public void GetCurrentKiosk_Should_Return_Kiosk_When_IP_Is_Valid()
        {
            using (new TransactionScope())
            {
                CheckInTestSetup.SetupKiosk();
                var result = CheckInController.GetCurrentKiosk(Dns.GetHostName());

                Assert.IsNotNull(result);
                Assert.AreNotEqual(result.SystemId, Constants.NULL_INT);
            }
        }

        [Test]
        public void GetOccurrences_Should_Return_Empty_When_No_Occurrences_Found()
        {
            using (new TransactionScope())
            {
                var kiosk = CheckInTestSetup.SetupKiosk();
                var result = CheckInController.GetOccurrences(DateTime.Now.AddMinutes(2), DateTime.Now, kiosk);
                Assert.IsEmpty(result);
            }
        }

        [Test]
        public void GetOccurrences_Should_Return_List_When_Occurrences_Found()
        {
            using (new TransactionScope())
            {
                var kiosk = CheckInTestSetup.SetupKiosk();
                CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                var result = CheckInController.GetOccurrences(DateTime.Now.AddMinutes(30), DateTime.Now, kiosk);

                Assert.IsNotEmpty(result);
                Assert.AreNotEqual(result[0].OccurrenceID, Constants.NULL_INT);
            }
        }

        [Test]
        public void GetAttendance_Should_Return_Null_When_Attendance_Not_Found()
        {
            using (new TransactionScope())
            {
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                var attendee = CheckInTestFactories.CreateFamilyMember();
                attendee.Save(1, CheckInTestConstants.USER_ID, false);
                var result = CheckInController.GetAttendance(occurrence.StartTime, attendee.PersonID);
                Assert.IsNull(result);
            }
        }

        [Test]
        public void GetAttendance_Should_Return_OccurrenceAttendance_When_Attendance_Found()
        {
            using (new TransactionScope())
            {
                var kiosk = CheckInTestSetup.SetupKiosk(); 
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                var attendee = CheckInTestFactories.CreateFamilyMember();
                attendee.Save(1, CheckInTestConstants.USER_ID, false);
                var attendance = CheckInTestFactories.CreateAttendance(occurrence, attendee);

                attendance.Save(CheckInTestConstants.USER_ID);
                var result = CheckInController.GetAttendance(occurrence.StartTime, attendee.PersonID);
                
                Assert.IsNotNull(result);
                Assert.AreNotEqual(result.OccurrenceAttendanceID, Constants.NULL_INT);
            }
        }

        [Test]
        public void SetChildToMaxAbility_Should_Set_Person_Attribute_To_Value()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestFactories.CreateFamilyMember();
                person.Save(1, CheckInTestConstants.USER_ID, false);
                var attribute = CheckInTestFactories.CreatePersonAttribute(person);
                attribute.AttributeType = DataType.Int;
                attribute.Save(CheckInTestConstants.USER_ID);
                CheckInController.SetChildToMaxAbility(attribute, 2);
                Assert.AreEqual(attribute.IntValue, 2);
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_No_Classes_Found()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                List<Occurrence> classes = new List<Occurrence>();
                List<DateTime> times = new List<DateTime> { DateTime.Now };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_List_When_Classes_Found()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsNotEmpty(result);
                Assert.IsNotInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Occurrence_Closed()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                occurrence.OccurrenceClosed = true;
                occurrence.Save(CheckInTestConstants.USER_ID);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Location_Closed()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                var location = new Location(occurrence.LocationID) { RoomClosed = true };
                location.Save(CheckInTestConstants.USER_ID);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Location_Headcount_Reached()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchFullRoom(kiosk);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Result_When_Multiple_Locations_Available()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                List<Occurrence> classes = CheckInTestSetup.SetupOccurrenceSearchMultipleOccurrences(kiosk);
                List<DateTime> times = new List<DateTime> { classes.First().StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.AreEqual(result.Count, 1);
                Assert.IsInstanceOf(typeof(Occurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Alternate_Occurrence_When_First_Occurrence_Unavailable()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                List<Occurrence> classes = CheckInTestSetup.SetupOccurrenceSearchMultipleOccurrencesWithClosedLocation(kiosk);
                List<DateTime> times = new List<DateTime> { classes.First().StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.AreEqual(result.Count, 1);
                Assert.IsInstanceOf(typeof(Occurrence), result.First());
                Assert.AreEqual(result.First().LocationID, classes.Last().LocationID);
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Alternate_Occurrence_When_Room_Balancing()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                List<Occurrence> classes = CheckInTestSetup.SetupOccurrenceSearchRoomBalancing(kiosk);
                List<DateTime> times = new List<DateTime> { classes.First().StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.AreEqual(result.Count, 1);
                Assert.IsInstanceOf(typeof(Occurrence), result.First());
                Assert.AreEqual(result.First().LocationID, classes.Last().LocationID);
                Assert.AreNotEqual(result.First().LocationID, classes.First().LocationID);
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Person_Too_Old()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                person.BirthDate = new DateTime(1979, 1, 1);
                person.Save(1, CheckInTestConstants.USER_ID, false);
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                occurrence.OccurrenceType.MaxAge = 10;
                occurrence.OccurrenceType.Save(CheckInTestConstants.USER_ID);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Person_Grade_Too_High()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                person.GraduationDate = DateTime.Now.AddYears(1);
                person.Save(1, CheckInTestConstants.USER_ID, false);
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                occurrence.OccurrenceType.MaxGrade = 6;
                occurrence.OccurrenceType.Save(CheckInTestConstants.USER_ID);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Person_Gender_Invalid()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                occurrence.OccurrenceType.GenderPreference = GenderPreference.Female;
                occurrence.OccurrenceType.Save(CheckInTestConstants.USER_ID);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Special_Needs_Invalid()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchSpecialNeeds(kiosk);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);
                specialNeeds.IntValue = 0;
                specialNeeds.Save(CheckInTestConstants.USER_ID);
                person.SaveAttributes(1, CheckInTestConstants.USER_ID);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_List_When_Special_Needs_Valid()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchSpecialNeeds(kiosk);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);
                specialNeeds.IntValue = 1;
                specialNeeds.Save(CheckInTestConstants.USER_ID);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(Occurrence), result.First());
                Assert.AreEqual(occurrence.OccurrenceID, result.First().OccurrenceID);
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Ability_Level_Too_Low()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchAbilityLevel(kiosk);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupAbilityLevelAttributeInvalid(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_List_When_Ability_Level_Valid()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchAbilityLevel(kiosk);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupAbilityLevelAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(Occurrence), result.First());
                Assert.AreEqual(occurrence.OccurrenceID, result.First().OccurrenceID);
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Last_Name_Invalid()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                person.LastName = "Zeeeeeeee";
                person.Save(1, CheckInTestConstants.USER_ID, false);
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchLastName(kiosk);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_List_When_Last_Name_Valid()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchLastName(kiosk);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(Occurrence), result.First());
                Assert.AreEqual(occurrence.OccurrenceID, result.First().OccurrenceID);
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_Empty_When_Membership_Required_Invalid()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchInvalidMembershipRequired(kiosk, person);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(EmptyOccurrence), result.First());
            }
        }

        [Test]
        public void FilterOccurrences_Should_Return_List_When_Membership_Required()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearchMembershipRequired(kiosk, person);
                List<Occurrence> classes = new List<Occurrence> { occurrence };
                List<DateTime> times = new List<DateTime> { occurrence.StartTime };

                var maxAbility = CheckInTestSetup.SetupPersonAttribute(person);
                var specialNeeds = CheckInTestSetup.SetupPersonAttribute(person);

                var result = CheckInController.FilterOccurrences(
                    classes, person, times, maxAbility.AttributeId, specialNeeds.AttributeId);

                Assert.IsInstanceOf(typeof(Occurrence), result.First());
                Assert.AreEqual(occurrence.OccurrenceID, result.First().OccurrenceID);
            }
        }

        [Test]
        public void CheckInFamily_Should_Return_Invalid_When_CheckIn_Fails()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
				PersonCheckInRequest request = new PersonCheckInRequest
            	                               	{
													PersonID = person.PersonID,
													FamilyMember = person,
													Occurrences = new List<Occurrence> { new EmptyOccurrence(occurrence.StartTime) }
            	                               	};

            	var familyMap = new List<PersonCheckInRequest> { request };
                var results = CheckInController.CheckInFamily(new MockPrintLabel(), person.FamilyID, familyMap, kiosk);
                var location = new Location(occurrence.LocationID);
            	var result = results.First();

                Assert.False(result.CheckInResults.Any(r => r.IsCheckInSuccessful));
                Assert.AreEqual(location.CurrentCount, 0);
            }
        }

        [Test]
        public void CheckInFamily_Should_Return_Valid_When_Successful()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
				PersonCheckInRequest request = new PersonCheckInRequest
            	                               	{
            	                               		PersonID = person.PersonID,
            	                               		FamilyMember = person,
													Occurrences = new List<Occurrence> { occurrence }
            	                               	};

				var familyMap = new List<PersonCheckInRequest> { request };
                var results = CheckInController.CheckInFamily(new MockPrintLabel(), person.FamilyID, familyMap, kiosk);
                var location = new Location(occurrence.LocationID);
				var result = results.First();

                Assert.IsTrue(result.CheckInResults.All(r => r.IsCheckInSuccessful));
                Assert.AreEqual(location.CurrentCount, 1);
            }
        }

        [Test]
        public void Print_Should_Return_False_When_Unsuccessful()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                var attendance = CheckInTestFactories.CreateAttendance(occurrence, person);
                attendance.Save(CheckInTestConstants.USER_ID);

                var result = CheckInController.Print(new MockPrintLabel(), person, 
                    new List<Occurrence> { new EmptyOccurrence(occurrence.StartTime) }, attendance, kiosk);

                Assert.IsFalse(result);
            }
        }

        [Test]
        public void Print_Should_Return_True_When_Successful()
        {
            using (new TransactionScope())
            {
                var person = CheckInTestSetup.SetupPhoneSearch();
                var kiosk = CheckInTestSetup.SetupKiosk();
                var occurrence = CheckInTestSetup.SetupOccurrenceSearch(kiosk);
                var attendance = CheckInTestFactories.CreateAttendance(occurrence, person);
                attendance.Save(CheckInTestConstants.USER_ID);

                var result = CheckInController.Print(new MockPrintLabel(), person,
                    new List<Occurrence> { occurrence }, attendance, kiosk);

                Assert.IsTrue(result);
            }
        }
    }
}
