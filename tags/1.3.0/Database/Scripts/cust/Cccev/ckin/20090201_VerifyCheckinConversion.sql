/**********************************************************************
* Description: Script to use when installing the CCCEV Arena Childrens
*              check-in module.
* Created By:  Nick Airdo @ Central Christian Church of the East Valley
*              Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	1/12/2009 10:16 AM
*
* $Workfile: VerifyCheckinConversion.sql $
* $Revision: 2 $ 
* $Header: /trunk/Database/Scripts/cust/Cccev/ckin/VerifyCheckinConversion.sql   2   2009-01-16 13:27:21-07:00   nicka $
* 
* $Log: /trunk/Database/Scripts/cust/Cccev/ckin/VerifyCheckinConversion.sql $
*  
*  Revision: 2   Date: 2009-01-16 20:27:21Z   User: nicka 
*  baseline version 
*  
*  Revision: 1   Date: 2009-01-14 00:16:07Z   User: nicka 
**********************************************************************/
DECLARE @Today DateTime
SET @Today = GetDate()

DECLARE @OrganizationID int
SET @OrganizationID = 1

DECLARE @CheckinAttrGroupGuid uniqueidentifier
SET @CheckinAttrGroupGuid = 'fe30ac51-5b67-44a5-9d73-a7d3c63a7e9e'

DECLARE @CheckinAttrGroupID int
SELECT @CheckinAttrGroupID = attribute_group_id FROM core_attribute_group WHERE @CheckinAttrGroupGuid = guid

DECLARE @CurrentUser varchar(50)
SELECT @CurrentUser = SYSTEM_USER

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

--SELECT @AbilityLevelInfantLookupID as 'Infant', @AbilityLevelCrawlerLookupID as 'Crawler', @AbilityLevelWalkingConfidentlyLookupID as 'Walking', @AbilityLevelPottyTrainedLookupID as 'Potty Trained'


/*
-- Select legal notes from old Checkin
select * from core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.LegalNotes IS NOT NULL AND cp.LegalNotes <> '')

-- Select legal notes from new/Arena.
select p.person_id, pa.varchar_value from core_person p
INNER JOIN core_person_attribute pa ON p.person_id = pa.person_id AND pa.attribute_id = @LegalAttrID AND pa.varchar_value <> ''
*/

/*
-- Select health notes from old Checkin
select person_id, cp.HealthNotes from core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.HealthNotes IS NOT NULL AND cp.HealthNotes <> '')
order by person_id

-- Select health notes from new/Arena.
select p.person_id, pa.varchar_value from core_person p
INNER JOIN core_person_attribute pa ON p.person_id = pa.person_id AND pa.attribute_id = @HealthAttrID AND pa.varchar_value <> ''
order by person_id

*/

/*
-- Select IsAllowedToSelfCheckOut from old Checkin
select person_id, cp.IsAllowedToSelfCheckOut from core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.IsAllowedToSelfCheckOut = 1)
order by person_id

-- Select SelfCheckout from new/Arena.
select p.person_id, pa.int_value from core_person p
INNER JOIN core_person_attribute pa ON p.person_id = pa.person_id AND pa.attribute_id = @SelfCheckoutAttrID AND pa.int_value = 1
order by person_id
*/

/*
-- Select IsSpecialNeeds from old Checkin
select person_id, cp.IsSpecialNeeds from core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.IsSpecialNeeds = 1)
order by p.person_id

-- Select SpecialNeeds from new/Arena.
select p.person_id, pa.int_value from core_person p
INNER JOIN core_person_attribute pa ON p.person_id = pa.person_id AND pa.attribute_id = @SpecialNeedsAttrID AND pa.int_value = 1
order by p.person_id

*/

/*
--select * from [CHECKIN].[CheckIn].[dbo].[lu_AbilityLevel] 
select person_id, cp.AbilityLevelID from core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
WHERE
(cp.AbilityLevelID <> -1)
AND dbo.fn_FractionalAge(p.birth_date, @Today) < 14
order by p.person_id

select pa.* from core_person_attribute pa 
where pa.attribute_id = @AbilityLevelAttrID
order by pa.person_id
*/


/*
select person_id, cp.AgeGroupID, ag.DisplayText from core_person p
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[com_Person] AS cp ON ( p.foreign_key = cp.ShelbyID )
LEFT JOIN [CHECKIN].[CheckIn].[dbo].[lu_AgeGroup] AS ag ON ( cp.AgeGroupID = ag.AgeGroupID )
WHERE cp.AgeGroupID IS NOT NULL AND cp.AgeGroupID <> -1
AND 7 <= cp.AgeGroupID AND cp.AgeGroupID <= 13 
order by cp.AgeGroupID 

select p.person_id, p.graduation_date from core_person p where p.graduation_date <> '1/1/1900 00:00:00' order by p.graduation_date
*/

-- Keytag/Barcode IDs:
select * from core_alt_id where id_type = 0