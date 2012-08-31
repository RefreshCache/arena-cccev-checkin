/**********************************************************************
* Description: Script to use when migrating/copying our old Checkin
*              system data to Arena for use with the new Arena 
*              checkin module.
*
*					1) Legal Notes (X)
*					2) Health Notes (X)
*					3) Self Checkout (X)
*					4) Special Needs (X)
*					5) Skill Level
*					6) Grade
*					7) Barcodes
*					8) non-family relationships
*     
* Created By:  Nick Airdo @ Central Christian Church of the East Valley
*              Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	1/12/2009 10:16 AM
*
* $Workfile: 20090201_CheckInConversionScript.sql $
* $Revision: 4 $ 
* $Header: /trunk/Database/Scripts/cust/Cccev/ckin/20090201_CheckInConversionScript.sql   4   2009-03-02 20:19:13-07:00   nicka $
* 
* $Log: /trunk/Database/Scripts/cust/Cccev/ckin/20090201_CheckInConversionScript.sql $
*  
*  Revision: 4   Date: 2009-03-03 03:19:13Z   User: nicka 
*  
*  Revision: 2   Date: 2009-01-16 20:27:15Z   User: nicka 
*  baseline version 
*  
*  Revision: 1   Date: 2009-01-14 00:16:07Z   User: nicka 
**********************************************************************/
DECLARE @CurrentUser varchar(50)
SELECT @CurrentUser = SYSTEM_USER

DECLARE @Today DateTime
SET @Today = GetDate()

DECLARE @CurrentYear DateTime
SET @CurrentYear = '1/1/' + CAST( DatePart( yyyy, GetDate() ) as varchar )

DECLARE @OrganizationID int
SET @OrganizationID = 1

DECLARE @CheckinAttrGroupGuid uniqueidentifier
SET @CheckinAttrGroupGuid = 'fe30ac51-5b67-44a5-9d73-a7d3c63a7e9e'

DECLARE @CheckinAttrGroupID int
SELECT @CheckinAttrGroupID = attribute_group_id FROM core_attribute_group WHERE @CheckinAttrGroupGuid = guid

DECLARE @LegalAttrGuid uniqueidentifier
SET @LegalAttrGuid = '4a437f23-9bac-443d-82cd-4093e7ae3779'

DECLARE @LegalAttrID int
SELECT @LegalAttrID = attribute_id FROM core_attribute WHERE @LegalAttrGuid = guid
--SELECT 'Legal Attribute ID (@LegalAttrID) is ' + CAST( @LegalAttrID as varchar )

DECLARE @HealthAttrGuid uniqueidentifier
SET @HealthAttrGuid = '4c0e69a8-db55-428a-86f7-5fcf40647f1d'

DECLARE @HealthAttrID int
SELECT @HealthAttrID = attribute_id FROM core_attribute WHERE @HealthAttrGuid = guid

DECLARE @SpecialNeedsAttrGuid uniqueidentifier
SET @SpecialNeedsAttrGuid = '48cb5d61-10c6-4d86-95d5-927ce5376d64'

DECLARE @SpecialNeedsAttrID int
SELECT @SpecialNeedsAttrID = attribute_id FROM core_attribute WHERE @SpecialNeedsAttrGuid = guid

DECLARE @SelfCheckoutAttrGuid uniqueidentifier
SET @SelfCheckoutAttrGuid = 'd19c5bf2-cb04-4f4f-a839-5facf5dbe796'

DECLARE @SelfCheckoutAttrID int
SELECT @SelfCheckoutAttrID = attribute_id FROM core_attribute WHERE @SelfCheckoutAttrGuid = guid

DECLARE @AbilityLevelAttrGuid uniqueidentifier
SET @AbilityLevelAttrGuid = '98467444-df8d-40aa-9d11-1119e40d6e6c'

DECLARE @AbilityLevelAttrID int
SELECT @AbilityLevelAttrID = attribute_id FROM core_attribute WHERE @AbilityLevelAttrGuid = guid

DECLARE @AbilityLevelLookupTypeGuid uniqueidentifier
SET @AbilityLevelLookupTypeGuid = 'b242694f-13dd-4eb9-9d03-6b58e62f11ec'

DECLARE @AbilityLevelTypeLookupID int
SELECT @AbilityLevelTypeLookupID = lookup_type_id FROM core_lookup_type WHERE @AbilityLevelLookupTypeGuid = guid

-- The 4 Ability Level lookup GUIDs
DECLARE @AbilityLevelInfant uniqueidentifier
SET @AbilityLevelInfant = '03a15683-bc72-4fe4-b47e-60dca63684e3'

DECLARE @AbilityLevelCrawler uniqueidentifier
SET @AbilityLevelCrawler = 'db36f2ed-7c7e-457c-9cc8-bbded00ddfd7'

DECLARE @AbilityLevelWalkingConfidently uniqueidentifier
SET @AbilityLevelWalkingConfidently = '983324ad-9311-4ca2-a69d-fa851cbbdac6'

DECLARE @AbilityLevelPottyTrained uniqueidentifier
SET @AbilityLevelPottyTrained = 'caafbc06-f9b8-43ce-b778-3cdd1045023c'

DECLARE @AbilityLevelInfantLookupID int
SELECT @AbilityLevelInfantLookupID = lookup_id FROM core_lookup WHERE @AbilityLevelInfant = guid

DECLARE @AbilityLevelCrawlerLookupID int
SELECT @AbilityLevelCrawlerLookupID = lookup_id FROM core_lookup WHERE @AbilityLevelCrawler = guid

DECLARE @AbilityLevelWalkingConfidentlyLookupID int
SELECT @AbilityLevelWalkingConfidentlyLookupID = lookup_id FROM core_lookup WHERE @AbilityLevelWalkingConfidently = guid

DECLARE @AbilityLevelPottyTrainedLookupID int
SELECT @AbilityLevelPottyTrainedLookupID = lookup_id FROM core_lookup WHERE @AbilityLevelPottyTrained = guid

BEGIN TRANSACTION

--SELECT @AbilityLevelInfantLookupID as 'Infant', @AbilityLevelCrawlerLookupID as 'Crawler', @AbilityLevelWalkingConfidentlyLookupID as 'Walking', @AbilityLevelPottyTrainedLookupID as 'Potty Trained'


/* x x x x x x  DEBUG x x x x x 
*/ -- x x x x x x  DEBUG x x x x x 

/************************************************************************************
* 1) Legal Notes (259+198)
************************************************************************************/
-- INSERTs
----------
SELECT 'Insert Legal Notes'

INSERT INTO	core_person_attribute
           ([person_id]
           ,[attribute_id]
           ,[int_value]
           ,[varchar_value]
           ,[datetime_value]
           ,[decimal_value]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
		)

-- 404 people have legal notes
--		259 here:
SELECT 	p.person_id
		, @LegalAttrID
		, -1
		, cp.LegalNotes
		, NULL
		, -1.0000
		, @Today
		, @Today
		, @CurrentUser
		, @CurrentUser
FROM	core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.LegalNotes IS NOT NULL AND cp.LegalNotes <> '')
-- and their Arena Legal Notes attribute does not exist missing or empty
AND NOT EXISTS
	( SELECT pa.person_id FROM core_person_attribute pa WHERE p.person_id = pa.person_id AND pa.attribute_id = @LegalAttrID )
ORDER BY p.person_id


-- UPDATEs (198)
----------------
SELECT 'Update Legal Notes'
UPDATE pa
SET pa.varchar_value = cp.LegalNotes
	, pa.date_modified = @Today
	, pa.modified_by = @CurrentUser
--SELECT
--		p.person_id
--		, cp.LegalNotes
--		, @Today
--		, @CurrentUser
FROM	core_person_attribute pa
JOIN core_person AS p ON p.person_id = pa.person_id
JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID ) 
WHERE  pa.attribute_id = @LegalAttrID
AND cp.LegalNotes IS NOT NULL AND cp.LegalNotes <> ''
AND (pa.varchar_value = '' OR pa.varchar_value IS NULL )


/************************************************************************************
* 2) Health Notes (708+559 people have health notes)
************************************************************************************/
-- INSERTs (644)
----------------
SELECT 'Insert Health Notes'
INSERT INTO	core_person_attribute
           ([person_id]
           ,[attribute_id]
           ,[int_value]
           ,[varchar_value]
           ,[datetime_value]
           ,[decimal_value]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
		)
SELECT 	p.person_id
		, @HealthAttrID
		, -1
		, cp.HealthNotes
		, NULL
		, -1.0000
		, @Today
		, @Today
		, @CurrentUser
		, @CurrentUser
FROM	core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.HealthNotes IS NOT NULL AND cp.HealthNotes <> '')
-- and their Arena Health Notes attribute does not exist missing or empty
AND NOT EXISTS
	( SELECT pa.person_id FROM core_person_attribute pa WHERE p.person_id = pa.person_id AND pa.attribute_id = @HealthAttrID )
ORDER BY p.person_id


-- UPDATEs (477)
----------------
SELECT 'Update Health Notes'
UPDATE pa
SET pa.varchar_value = cp.HealthNotes
	, pa.date_modified = @Today
	, pa.modified_by = @CurrentUser
--SELECT
--		p.person_id
--		, cp.LegalNotes
--		, @Today
--		, @CurrentUser
FROM	core_person_attribute pa
JOIN core_person AS p ON p.person_id = pa.person_id
JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID ) 
WHERE  pa.attribute_id = @HealthAttrID
AND cp.HealthNotes IS NOT NULL AND cp.HealthNotes <> ''
AND (pa.varchar_value = '' OR pa.varchar_value IS NULL )


/************************************************************************************
* 3) Self Checkout (848+0 people)
************************************************************************************/
-- INSERTs (859)
----------------
SELECT 'Insert Self Checkout'
INSERT INTO	core_person_attribute
           ([person_id]
           ,[attribute_id]
           ,[int_value]
           ,[varchar_value]
           ,[datetime_value]
           ,[decimal_value]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
		)
SELECT 	p.person_id
		, @SelfCheckoutAttrID
		, cp.IsAllowedToSelfCheckOut
		, NULL
		, NULL
		, -1.0000
		, @Today
		, @Today
		, @CurrentUser
		, @CurrentUser
FROM	core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.IsAllowedToSelfCheckOut = 1 )
-- and their Arena SelfCheckOut attribute does not exist missing or empty
AND NOT EXISTS
	( SELECT pa.person_id FROM core_person_attribute pa WHERE p.person_id = pa.person_id AND pa.attribute_id = @SelfCheckoutAttrID )
ORDER BY p.person_id


-- UPDATEs (0)
----------------
SELECT 'Update Self Checkout'
UPDATE pa
SET pa.int_value = cp.IsAllowedToSelfCheckOut
	, pa.date_modified = @Today
	, pa.modified_by = @CurrentUser
--SELECT
--		p.person_id
--		, cp.IsAllowedToSelfCheckOut
--		, @Today
--		, @CurrentUser
FROM	core_person_attribute pa
JOIN core_person AS p ON p.person_id = pa.person_id
JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID ) 
WHERE  pa.attribute_id = @SelfCheckoutAttrID
AND cp.IsAllowedToSelfCheckOut = 1
AND (pa.int_value = -1 OR pa.int_value IS NULL )



/************************************************************************************
* 4) Special Needs (40+0 people)
************************************************************************************/
-- INSERTs (37)
----------------
SELECT 'Insert Special Needs'
INSERT INTO	core_person_attribute
           ([person_id]
           ,[attribute_id]
           ,[int_value]
           ,[varchar_value]
           ,[datetime_value]
           ,[decimal_value]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
		)
SELECT 	p.person_id
		, @SpecialNeedsAttrID
		, cp.IsSpecialNeeds
		, NULL
		, NULL
		, -1.0000
		, @Today
		, @Today
		, @CurrentUser
		, @CurrentUser
FROM	core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.IsSpecialNeeds = 1 )
-- and their Arena SpecialNeeds attribute does not exist missing or empty
AND NOT EXISTS
	( SELECT pa.person_id FROM core_person_attribute pa WHERE p.person_id = pa.person_id AND pa.attribute_id = @SpecialNeedsAttrID )
ORDER BY p.person_id


-- UPDATEs (0)
----------------
SELECT 'Update Special Needs'
UPDATE pa
SET pa.int_value = cp.IsSpecialNeeds
	, pa.date_modified = @Today
	, pa.modified_by = @CurrentUser
--SELECT
--		p.person_id
--		, cp.IsSpecialNeeds
--		, @Today
--		, @CurrentUser
FROM	core_person_attribute pa
JOIN core_person AS p ON p.person_id = pa.person_id
JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID ) 
WHERE  pa.attribute_id = @SpecialNeedsAttrID
AND cp.IsSpecialNeeds = 1
AND (pa.int_value = -1 OR pa.int_value IS NULL )


/* -- x x x x x x  DEBUG x x x x x 

/************************************************************************************
* 5) Skill Level (12618 people)
*
*   Disregard anyone who is older than 14.
*
*	Update anyone's ability level to "potty trained" if they are
*	older than 3.5 years old.
************************************************************************************/
-- Create a map to map the old Check-in system's ability levels to the new
-- lookup type IDs.
DECLARE @MapToSkillLevel TABLE 
( 
    AbilityLevelID INT, 
    lookup_id INT
)
SELECT 'Insert Ability Levels into Temp Map'
Insert @MapToSkillLevel Values (1	,@AbilityLevelInfantLookupID )
Insert @MapToSkillLevel Values (2	,@AbilityLevelCrawlerLookupID)
Insert @MapToSkillLevel Values (3	,@AbilityLevelWalkingConfidentlyLookupID)

SELECT 'Insert Ability Level'
INSERT INTO	core_person_attribute
           ([person_id]
           ,[attribute_id]
           ,[int_value]
           ,[varchar_value]
           ,[datetime_value]
           ,[decimal_value]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
		)
SELECT 	p.person_id
		, @AbilityLevelAttrID
		,(CASE
			WHEN dbo.fn_FractionalAge(p.birth_date, @Today) > 13 THEN -1 
			WHEN dbo.fn_FractionalAge(p.birth_date, @Today) > 3.5 THEN @AbilityLevelPottyTrainedLookupID 
			ELSE (SELECT lookup_id FROM @MapToSkillLevel WHERE AbilityLevelID = cp.AbilityLevelID)
			END) AS 'int_value'
		, NULL
		, NULL
		, -1.0000
		, @Today
		, @Today
		, @CurrentUser
		, @CurrentUser
FROM	core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.AbilityLevelId <> -1 )
-- and they are younger than 13 years
AND dbo.fn_FractionalAge(p.birth_date, @Today) < 14
-- and their Arena AbilityLevel attribute does not exist missing or empty
AND NOT EXISTS
	( SELECT pa.person_id FROM core_person_attribute pa WHERE p.person_id = pa.person_id AND pa.attribute_id = @AbilityLevelAttrID )
ORDER BY p.person_id


*/ -- x x x x x x  DEBUG x x x x x 


/************************************************************************************
* 6) Grade (6661 people)
************************************************************************************/
-- maps an AgeGroupID to its appropriate Graduation Date 
DECLARE @MapGradDate TABLE 
( 
    AgeGroupID INT, 
    graduation_date DateTime
)
SELECT 'Insert Grades into Temp Map'
Insert @MapGradDate Values ( 7, DateAdd(year, 12, @CurrentYear) ) -- Kindergarten = current year + 12
Insert @MapGradDate Values ( 8, DateAdd(year, 11, @CurrentYear) ) -- 1st grade = current year + 11
Insert @MapGradDate Values ( 9, DateAdd(year, 10, @CurrentYear) ) -- 2st grade = current year + 10
Insert @MapGradDate Values (10, DateAdd(year,  9, @CurrentYear) ) -- 3rd grade = current year + 9
Insert @MapGradDate Values (11, DateAdd(year,  8, @CurrentYear) ) -- 4th grade = current year + 8
Insert @MapGradDate Values (12, DateAdd(year,  7, @CurrentYear) ) -- 5th grade = current year + 7
Insert @MapGradDate Values (13, DateAdd(year,  6, @CurrentYear) ) -- 6th grade = current year + 6

SELECT 'Update Grade'

UPDATE p
SET p.graduation_date = (SELECT graduation_date FROM @MapGradDate WHERE AgeGroupID = cp.AgeGroupID)
	, p.date_modified = @Today
	, p.modified_by = @CurrentUser
--SELECT 	p.person_id
--		, (SELECT graduation_date FROM @MapGradDate WHERE AgeGroupID = cp.AgeGroupID) as 'graduation_date'
FROM	core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
( 7 <= cp.AgeGroupID AND cp.AgeGroupID <= 13 )
AND
p.graduation_date <= '1/1/1900 00:00:00'



/************************************************************************************
* 7) Barcodes (41318 people)
************************************************************************************/
SELECT 'Insert Barcodes'

INSERT INTO	core_alt_id
           ([alt_id]
           ,[id_type]
           ,[primary_id]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
		)
SELECT 	cp.ShelbyID
		, 0
		, p.person_id
		, @Today
		, @Today
		, @CurrentUser
		, @CurrentUser
FROM	core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE     
p.record_status = 0
AND
(PersonID IN
			(SELECT DISTINCT HeadOfHouseholdID
			FROM          [CHECKIN].[CheckIn].[dbo].[com_Relation])
			)
AND NOT EXISTS
( SELECT ai.alt_id FROM core_alt_id ai WHERE ai.alt_id = cp.ShelbyID AND id_type = 0 )
ORDER BY p.person_id

/************************************************************************************
* 8) non-family relationships (6 people)
************************************************************************************/

-- These are being done by hand.

ROLLBACK TRANSACTION
