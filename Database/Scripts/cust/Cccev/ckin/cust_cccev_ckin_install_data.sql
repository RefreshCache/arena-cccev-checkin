/**********************************************************************
* Description: Script to use when installing the CCCEV Arena Childrens
*              check-in module.
* Created By:  Nick Airdo @ Central Christian Church of the East Valley
*              Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	1/12/2009 10:16 AM
*
* $Workfile: cust_cccev_ckin_install_data.sql $
* $Revision: 13' $ 
* $Header: /trunk/Database/Scripts/cust/Cccev/ckin/cust_cccev_ckin_install_data.sql   13'   2011-03-02 22:27:15-07:00   nicka $
* 
* $Log: /trunk/Database/Scripts/cust/Cccev/ckin/cust_cccev_ckin_install_data.sql $
*  
*  Revision: 12   Date: 2009-11-25 20:27:15Z   User: nicka 
*  for v1.2.0, add new data items (like reporting services related stuff) to 
*  lookup tables, etc. 
*  
*  Revision: 11   Date: 2009-10-15 22:07:06Z   User: nicka 
*  
*  Revision: 10   Date: 2009-10-15 22:03:01Z   User: nicka 
*  Bug Fix: changed Namespace qualifier from 1 to 2 
*  
*  Revision: 9   Date: 2009-10-14 23:35:36Z   User: nicka 
*  added cust_cccev_applog table and corresponding lookup data (for upgrade 
*  script) 
*  
*  Revision: 8   Date: 2009-10-01 16:56:41Z   User: nicka 
*  Changed SQL job name to have dbname prepended to it 
*  
*  Revision: 7   Date: 2009-03-02 17:12:18Z   User: nicka 
*  
*  Revision: 6   Date: 2009-02-26 21:45:29Z   User: nicka 
*  now runs the SP to add 0-9999 for the default security code provider 
*  
*  Revision: 4   Date: 2009-02-24 21:56:32Z   User: nicka 
*  final draft 
*  
*  Revision: 3   Date: 2009-02-24 18:38:39Z   User: nicka 
*  Added Org Setting Categories, Default Security and Label providers and 
*  default org setting values. 
*  
*  Revision: 2   Date: 2009-02-17 00:55:28Z   User: nicka 
*  
*  Revision: 1   Date: 2009-01-14 00:19:31Z   User: nicka 
**********************************************************************/
BEGIN TRANSACTION

DECLARE @OrganizationID int
SET @OrganizationID = 1

DECLARE @CurrentUser varchar(50)
SELECT @CurrentUser = SYSTEM_USER

DECLARE @Today DateTime
SET @Today = GetDate()

DECLARE @CheckinAttrGroupGuid uniqueidentifier
SET @CheckinAttrGroupGuid = 'fe30ac51-5b67-44a5-9d73-a7d3c63a7e9e'

DECLARE @CheckinAttrGroupID int
SELECT @CheckinAttrGroupID = attribute_group_id FROM core_attribute_group WHERE @CheckinAttrGroupGuid = guid

DECLARE @LegalAttrGuid uniqueidentifier
SET @LegalAttrGuid = '4a437f23-9bac-443d-82cd-4093e7ae3779'

DECLARE @HealthAttrGuid uniqueidentifier
SET @HealthAttrGuid = '4c0e69a8-db55-428a-86f7-5fcf40647f1d'

DECLARE @SpecialNeedsAttrGuid uniqueidentifier
SET @SpecialNeedsAttrGuid = '48cb5d61-10c6-4d86-95d5-927ce5376d64'

DECLARE @SelfCheckoutAttrGuid uniqueidentifier
SET @SelfCheckoutAttrGuid = 'd19c5bf2-cb04-4f4f-a839-5facf5dbe796'

DECLARE @AbilityLevelAttrGuid uniqueidentifier
SET @AbilityLevelAttrGuid = '98467444-df8d-40aa-9d11-1119e40d6e6c'

DECLARE @AbilityLevelLookupTypeGuid uniqueidentifier
SET @AbilityLevelLookupTypeGuid = 'b242694f-13dd-4eb9-9d03-6b58e62f11ec'

-- Here are the 4 Ability Level lookups that Jason has on his system
DECLARE @AbilityLevelInfant uniqueidentifier
SET @AbilityLevelInfant = '03a15683-bc72-4fe4-b47e-60dca63684e3'

DECLARE @AbilityLevelCrawler uniqueidentifier
SET @AbilityLevelCrawler = 'db36f2ed-7c7e-457c-9cc8-bbded00ddfd7'

DECLARE @AbilityLevelWalkingConfidently uniqueidentifier
SET @AbilityLevelWalkingConfidently = '983324ad-9311-4ca2-a69d-fa851cbbdac6'

DECLARE @AbilityLevelPottyTrained uniqueidentifier
SET @AbilityLevelPottyTrained = 'caafbc06-f9b8-43ce-b778-3cdd1045023c'

-- This is used with the Arena.Core.Bone utility classes:
DECLARE @OccurrenceTypeAttributeEntityTypeGUID uniqueidentifier
SET @OccurrenceTypeAttributeEntityTypeGUID = 'b8903b32-3200-41e3-8c08-66c372a38d12'

-- These are system Lookup Types
DECLARE @EntityLookupTypeID int
SELECT @EntityLookupTypeID = lookup_type_id FROM core_lookup_type WHERE guid = '15fe6acd-f986-4a92-9410-75eb67e531a6'

DECLARE @OrgSettingCategoriesLookupTypeID int
SELECT @OrgSettingCategoriesLookupTypeID = lookup_type_id FROM core_lookup_type WHERE guid = '0851948a-2d81-44fc-9cef-bfa1572f42d9'

-- Organization Setting Categories (Lookup Type)
-- Cccev Check-in Labels
DECLARE @CccevCheckinLabelsCategoryGuid uniqueidentifier
SET @CccevCheckinLabelsCategoryGuid = 'a5f7d5ad-0a36-412d-98be-75e50202179c'

-- Organization Setting Categories (Lookup Type)
-- Cccev Check-in Wizard
DECLARE @CccevCheckinWizardCategoryGuid uniqueidentifier
SET @CccevCheckinWizardCategoryGuid = 'f0da7805-8590-406f-83c0-f7f074d14c1e'

-- Print Label Provider Lookup Type
DECLARE @CheckInPrintLabelSystemGuid uniqueidentifier
SET @CheckInPrintLabelSystemGuid = '420221aa-8c79-435b-b884-fa3f6855d0d1'

-- GUID for the default Print Label provider
DECLARE @DefaultCheckInPrintLabelGuid uniqueidentifier
SET @DefaultCheckInPrintLabelGuid = 'e81af83a-10f5-417f-ab76-220cebb927cc'

-- GUID for the RS Print Label provider
DECLARE @RSCheckInPrintLabelGuid uniqueidentifier
SET @RSCheckInPrintLabelGuid = '7C879FED-8B1B-4CE6-8EBD-8412331BEEC7'

-- GUID for the Null Print Label provider
DECLARE @NULLCheckInPrintLabelGuid uniqueidentifier
SET @NULLCheckInPrintLabelGuid = '5240e0f9-265d-4c2c-bbff-8cc1c3d302a8'

-- Security Code provider Lookup Type
DECLARE @CheckInSecurityCodeSystemGuid uniqueidentifier
SET @CheckInSecurityCodeSystemGuid = 'ea3f802d-29f0-4b7f-8dc3-b82c96007b8e'

-- GUID for the default Security Code provider
DECLARE @DefaultCheckInSecurityCodeGuid uniqueidentifier
SET @DefaultCheckInSecurityCodeGuid = '67edca89-1b02-46e5-a335-0bbc62e6305d'

-- GUID for the Application Log Type Lookup Type
DECLARE @AppLogTypeLookupTypeGuid uniqueidentifier
SET @AppLogTypeLookupTypeGuid = 'B79DBFB8-A7EE-407D-9D5A-B851CD60CFE1'

-- GUID for the 'Check-in' Application Log Type Lookup
DECLARE @CheckinAppLogTypeGuid uniqueidentifier
SET @CheckinAppLogTypeGuid = '2A33F0EA-10F8-416C-B341-AEB7D0C08190'

--------------------------------------------------------------------------
-- Lookup Type: Application Log Type
-- Add the 'Application Log Type' Lookup Type into the core_lookup_type table
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_lookup_type WHERE guid = @AppLogTypeLookupTypeGuid)
BEGIN
INSERT INTO core_lookup_type
           ([guid]
           ,[lookup_type_name]
           ,[lookup_type_desc]
           ,[lookup_category]
           ,[qualifier_1_title]
           ,[qualifier_2_title]
           ,[organization_id]
           ,[system_flag]
           ,[qualifier_3_title]
           ,[qualifier_4_title]
           ,[qualifier_5_title]
           ,[qualifier_6_title]
           ,[qualifier_7_title]
           ,[qualifier_8_title])
     VALUES
           (@AppLogTypeLookupTypeGuid
           ,'Cccev App Log Type'
           ,'A list of all application logging types'
           ,''
           ,'IsEnabled'
           ,''
           ,@OrganizationID
           ,0
           ,''
           ,''
           ,''
           ,''
           ,''
           ,'')
END

DECLARE @AppLogTypeLookupID int
SELECT @AppLogTypeLookupID = lookup_type_id FROM core_lookup_type WHERE @AppLogTypeLookupTypeGuid = guid

--------------------------------------------------------------------------
-- Add the Check-in Lookup Application Log Type default to off (false).
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @CheckinAppLogTypeGuid)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@CheckinAppLogTypeGuid, @AppLogTypeLookupID, 'Check-in', 'false', '', '', '', '', '', '', '', 1, 1, 0, NULL)
END

--------------------------------------------------------------------------
-- Lookup Value for Organization Setting Categories
-- Add the Cccev Check-in Labels lookup
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @CccevCheckinLabelsCategoryGuid)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@CccevCheckinLabelsCategoryGuid, @OrgSettingCategoriesLookupTypeID, 'Cccev Check-in Labels', '', '', '', '', '', '', '', '', 1, 1, 0, NULL)
END

DECLARE @CccevCheckinLabelsCategoryLookupID int
SELECT @CccevCheckinLabelsCategoryLookupID = lookup_id FROM core_lookup WHERE guid = @CccevCheckinLabelsCategoryGuid

--------------------------------------------------------------------------
-- Lookup Value for Organization Setting Categories
-- Add the Cccev Check-in Wizard lookup
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @CccevCheckinWizardCategoryGuid)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@CccevCheckinWizardCategoryGuid, @OrgSettingCategoriesLookupTypeID, 'Cccev Check-in Wizard', '', '', '', '', '', '', '', '', 1, 1, 0, NULL)
END

DECLARE @CccevCheckinWizardCategoryLookupID int
SELECT @CccevCheckinWizardCategoryLookupID = lookup_id FROM core_lookup WHERE guid = @CccevCheckinWizardCategoryGuid


--------------------------------------------------------------------------
-- Lookup Type: CheckIn Print Label System Provider
-- Add into the core_lookup_type table
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_lookup_type WHERE guid = @CheckInPrintLabelSystemGuid)
BEGIN
INSERT INTO core_lookup_type
           ([guid]
           ,[lookup_type_name]
           ,[lookup_type_desc]
           ,[lookup_category]
           ,[qualifier_1_title]
           ,[qualifier_2_title]
           ,[organization_id]
           ,[system_flag]
           ,[qualifier_3_title]
           ,[qualifier_4_title]
           ,[qualifier_5_title]
           ,[qualifier_6_title]
           ,[qualifier_7_title]
           ,[qualifier_8_title])
     VALUES
           (@CheckInPrintLabelSystemGuid
           ,'Cccev CheckIn Print Label Providers'
           ,'Providers for the custom Cccev Print Label System'
           ,''
           ,''
           ,'Namespace'
           ,@OrganizationID
           ,0
           ,''
           ,''
           ,''
           ,''
           ,''
           ,'Class')
END

DECLARE @CheckInPrintLabelSystemLookupTypeID int
SELECT @CheckInPrintLabelSystemLookupTypeID = lookup_type_id FROM core_lookup_type WHERE @CheckInPrintLabelSystemGuid = guid

--------------------------------------------------------------------------
-- Add the default providers
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @DefaultCheckInPrintLabelGuid )
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@DefaultCheckInPrintLabelGuid, @CheckInPrintLabelSystemLookupTypeID, 'Cccev Print Label Provider', '', 'Arena.Custom.Cccev.CheckIn', '', '', '', '', '', 'Arena.Custom.Cccev.CheckIn.Entity.CccevPrintLabel', 1, 1, 0, NULL)
END

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @RSCheckInPrintLabelGuid )
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@RSCheckInPrintLabelGuid, @CheckInPrintLabelSystemLookupTypeID, 'Cccev RS Print Label Provider', '', 'Arena.Custom.Cccev.CheckIn', '', '', '', '', '', 'Arena.Custom.Cccev.CheckIn.Entity.RSPrintLabel', 1, 1, 0, NULL)
END

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @NULLCheckInPrintLabelGuid )
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@NULLCheckInPrintLabelGuid, @CheckInPrintLabelSystemLookupTypeID, 'Cccev Null Print Label Provider', '', 'Arena.Custom.Cccev.CheckIn', '', '', '', '', '', 'Arena.Custom.Cccev.CheckIn.Entity.NullPrintLabel', 1, 1, 0, NULL)
END

--------------------------------------------------------------------------
-- Lookup Type: Security Code Provider
-- Add into the core_lookup_type table
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_lookup_type WHERE guid = @CheckInSecurityCodeSystemGuid)
BEGIN
INSERT INTO core_lookup_type
           ([guid]
           ,[lookup_type_name]
           ,[lookup_type_desc]
           ,[lookup_category]
           ,[qualifier_1_title]
           ,[qualifier_2_title]
           ,[organization_id]
           ,[system_flag]
           ,[qualifier_3_title]
           ,[qualifier_4_title]
           ,[qualifier_5_title]
           ,[qualifier_6_title]
           ,[qualifier_7_title]
           ,[qualifier_8_title])
     VALUES
           (@CheckInSecurityCodeSystemGuid
           ,'Cccev CheckIn Security Code Providers'
           ,'Providers for the custom Cccev Security Code System'
           ,''
           ,''
           ,'Namespace'
           ,@OrganizationID
           ,0
           ,''
           ,''
           ,''
           ,''
           ,''
           ,'Class')
END

DECLARE @CheckInSecurityCodeSystemLookupTypeID int
SELECT @CheckInSecurityCodeSystemLookupTypeID = lookup_type_id FROM core_lookup_type WHERE @CheckInSecurityCodeSystemGuid = guid

--------------------------------------------------------------------------
-- Add the default CheckIn Security Code provider
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @DefaultCheckInSecurityCodeGuid )
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@DefaultCheckInSecurityCodeGuid, @CheckInSecurityCodeSystemLookupTypeID, 'Default Security Code Provider', '', 'Arena.Custom.Cccev.CheckIn', '', '', '', '', '', 'Arena.Custom.Cccev.CheckIn.Entity.CccevSecurityCode', 1, 1, 0, NULL)
END
-- get the ID
DECLARE @DefaultCheckInSecurityCodeLookupID int
SELECT @DefaultCheckInSecurityCodeLookupID = lookup_id FROM core_lookup WHERE @DefaultCheckInSecurityCodeGuid = guid



--------------------------------------------------------------------------
-- Add the Occurrence Type Attribute to the list of Entity lookup
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @OccurrenceTypeAttributeEntityTypeGUID)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@OccurrenceTypeAttributeEntityTypeGUID, @EntityLookupTypeID, 'Occurrence Type Attribute', '', '', '', '', '', '', '', '', 1, 1, 0, NULL)
END

--------------------------------------------------------------------------
-- Lookup Type: Ability Level
-- Add the 'Ability Level' Lookup Type into the core_lookup_type table
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_lookup_type WHERE guid = @AbilityLevelLookupTypeGuid)
BEGIN
INSERT INTO core_lookup_type
           ([guid]
           ,[lookup_type_name]
           ,[lookup_type_desc]
           ,[lookup_category]
           ,[qualifier_1_title]
           ,[qualifier_2_title]
           ,[organization_id]
           ,[system_flag]
           ,[qualifier_3_title]
           ,[qualifier_4_title]
           ,[qualifier_5_title]
           ,[qualifier_6_title]
           ,[qualifier_7_title]
           ,[qualifier_8_title])
     VALUES
           (@AbilityLevelLookupTypeGuid
           ,'Ability Level'
           ,'Check-in Ability Level'
           ,''
           ,''
           ,''
           ,@OrganizationID
           ,0
           ,''
           ,''
           ,''
           ,''
           ,''
           ,'')
END

DECLARE @AbilityLevelTypeLookupID int
SELECT @AbilityLevelTypeLookupID = lookup_type_id FROM core_lookup_type WHERE @AbilityLevelLookupTypeGuid = guid

--------------------------------------------------------------------------
-- Add the 4 default Ability Level Lookups (Infant, Crawler, etc.)
--------------------------------------------------------------------------

-- Infant
IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @AbilityLevelInfant)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@AbilityLevelInfant, @AbilityLevelTypeLookupID, 'Infant', '', '', '', '', '', '', '', '', 1, 1, 0, NULL)
END

-- Crawler
IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @AbilityLevelCrawler)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@AbilityLevelCrawler, @AbilityLevelTypeLookupID, 'Crawler', '', '', '', '', '', '', '', '', 2, 1, 0, NULL)
END

-- Walker
IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @AbilityLevelWalkingConfidently)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@AbilityLevelWalkingConfidently, @AbilityLevelTypeLookupID, 'Walking Confidently', '', '', '', '', '', '', '', '', 3, 1, 0, NULL)
END

-- Potty Trained
IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @AbilityLevelPottyTrained)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@AbilityLevelPottyTrained, @AbilityLevelTypeLookupID, 'Walking and Potty Trained', '', '', '', '', '', '', '', '', 4, 1, 0, NULL)
END

--------------------------------------------------------------------------
-- Attribute: Ability Level
-- Add the attribute to the core_attribute table that will hold each
-- child's "ability level" value.
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_attribute WHERE guid = @AbilityLevelAttrGuid)
BEGIN
INSERT INTO core_attribute
           ([guid]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
           ,[attribute_group_id]
           ,[attribute_name]
           ,[attribute_type]
           ,[attribute_order]
           ,[visible]
           ,[required]
           ,[type_qualifier]
           ,[readonly]
           ,[system_flag])
     VALUES
           (@AbilityLevelAttrGuid
           ,GetDate()
           ,GetDate()
           ,@CurrentUser
           ,@CurrentUser
           ,@CheckinAttrGroupID
           ,'Ability Level'
           ,3
           ,-1
           ,1
           ,0
           ,CAST(@AbilityLevelTypeLookupID AS varchar(100))
           ,0
           ,0)
END

--------------------------------------------------------------------------
-- Attribute: Special Needs
-- Add the attribute to the core_attribute table that will hold each
-- child's "special needs" value.
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_attribute WHERE guid = @SpecialNeedsAttrGuid)
BEGIN
INSERT INTO core_attribute
           ([guid]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
           ,[attribute_group_id]
           ,[attribute_name]
           ,[attribute_type]
           ,[attribute_order]
           ,[visible]
           ,[required]
           ,[type_qualifier]
           ,[readonly]
           ,[system_flag])
     VALUES
           (@SpecialNeedsAttrGuid
           ,GetDate()
           ,GetDate()
           ,@CurrentUser
           ,@CurrentUser
           ,@CheckinAttrGroupID
           ,'Special Needs'
           ,4
           ,-1
           ,1
           ,0
           ,''
           ,0
           ,0)
END

--------------------------------------------------------------------------
-- Attribute: Self Check-out
-- Add the attribute to the core_attribute table that will hold each
-- child's "self check-out" value.
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_attribute WHERE guid = @SelfCheckoutAttrGuid)
BEGIN
INSERT INTO core_attribute
           ([guid]
           ,[date_created]
           ,[date_modified]
           ,[created_by]
           ,[modified_by]
           ,[attribute_group_id]
           ,[attribute_name]
           ,[attribute_type]
           ,[attribute_order]
           ,[visible]
           ,[required]
           ,[type_qualifier]
           ,[readonly]
           ,[system_flag])
     VALUES
           (@SelfCheckoutAttrGuid
           ,GetDate()
           ,GetDate()
           ,@CurrentUser
           ,@CurrentUser
           ,@CheckinAttrGroupID
           ,'Self Check-Out?'
           ,4
           ,-1
           ,1
           ,0
           ,''
           ,0
           ,0)
END

DECLARE @SelfCheckoutAttrID int
SELECT @SelfCheckoutAttrID = attribute_id FROM core_attribute WHERE @SelfCheckoutAttrGuid = guid

--------------------------------------------------------------------------
-- Organization Settings for Check-in Label (Category)
-- Settings used by the Cccev "default" Print Label provider
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.AttendanceLabelTitle')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.AttendanceLabelTitle', 'Expedition Attendance', @Today, @Today, @CurrentUser, @CurrentUser, 'The title to use on the Attendance label', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.BirthdayImageFile')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.BirthdayImageFile', 'C:\Inetpub\wwwroot\CheckIn\images\cake.bmp', @Today, @Today, 'JasonO', 'JasonO', 'Image (.bmp) to use on the Nametag label to indicate a person''s birthday occurs that week. Eg. "C:\Inetpub\wwwroot\images\cake.bmp"', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.ClaimCardFooter')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.ClaimCardFooter', 'Present ticket to the classroom supervisor when picking up your child.', @Today, @Today, @CurrentUser, @CurrentUser, 'Text to use on the footer of the Claim Card (eg. "Present this ticket when picking up your child.")', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.ClaimCardTitle')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.ClaimCardTitle', 'CLAIM TICKET', @Today, @Today, @CurrentUser, @CurrentUser, 'The title to use on the Claim Card label', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.DisplayRoomNameOnNameTag')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.DisplayRoomNameOnNameTag', 'false', @Today, @Today, @CurrentUser, @CurrentUser, 'Boolean value to determine whether location name will be printed on name tag.', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.HealthNotesAttributeID')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.HealthNotesAttributeID', '80', @Today, @Today, @CurrentUser, @CurrentUser, 'The attribute ID (string type attribute) that holds the person''s health notes.', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.HealthNotesTitle')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.HealthNotesTitle', 'Health Notes:', @Today, @Today, @CurrentUser, @CurrentUser, 'Text to use in front of any health notes on the Attendance label', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.LegalNotesAttributeID')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.LegalNotesAttributeID', '79', @Today, @Today, @CurrentUser, @CurrentUser, 'The attribute ID (string type attribute) that holds a person''s legal/custody details.', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.LogoImageFile')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.LogoImageFile', 'C:\Inetpub\wwwroot\CheckIn\images\xlogo_bw_lg.bmp', @Today, @Today, @CurrentUser, @CurrentUser, 'Logo (.bmp) to use on the Nametag label. (Eg. "C:\Inetpub\wwwroot\images\logo.bmp")', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.ParentsInitialsTitle')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.ParentsInitialsTitle', '____________________________________ Parent''s Signature', @Today, @Today, @CurrentUser, @CurrentUser, 'Text to use on the Attendance label where a parent can sign.', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.SelfCheckOutAttributeID')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.SelfCheckOutAttributeID', CAST( @SelfCheckoutAttrID AS VARCHAR ), @Today, @Today, @CurrentUser, @CurrentUser, 'The attribute ID (yes/no type attribute) that indicates whether or not a person is allowed to self check-out.', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.ServicesLabel')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.ServicesLabel', 'Service:', @Today, @Today, @CurrentUser, @CurrentUser, 'Text to use in front of the services/occurrence times, eg. "Services:"', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

--------------------------------------------------------------------------
-- Organization Settings for Check-in Wizard (Category)
-- Set the default Security Code Provider
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.SecurityCodeDefaultSystemID')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.SecurityCodeDefaultSystemID', CAST( @DefaultCheckInSecurityCodeLookupID AS VARCHAR), @Today, @Today, @CurrentUser, @CurrentUser, 'Lookup ID that points to the Security Code provider class.', 0, @CccevCheckinWizardCategoryLookupID, 0)
END

--------------------------------------------------------------------------
-- new for 1.3.0
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.AllowedInactiveReasons')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.AllowedInactiveReasons', '', @Today, @Today, @CurrentUser, @CurrentUser, 'Comma delimted list of LookupIDs (inactive reasons).  If set, will allow individuals whose record status is marked as inactive to check-in using the Check-in Wizard.', 0, @CccevCheckinWizardCategoryLookupID, 0)
END

--------------------------------------------------------------------------
-- 1.3.1 define the template if not already defined
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM port_template WHERE [template_url] like '%UserControls/Custom/Cccev/Checkin/misc/BlankTemplate.ascx')
BEGIN
	INSERT INTO [dbo].[port_template] ([date_created],[date_modified],[created_by],[modified_by],[template_name],[template_desc],[template_url]) VALUES (@Today, @Today, @CurrentUser, @CurrentUser, 'Check-in Wizard Blank Template', 'For use with the Check-in Wizard module', '~/UserControls/Custom/Cccev/Checkin/misc/BlankTemplate.ascx')
END
           
--------------------------------------------------------------------------
-- Run SP to setup security codes for the default Security Code provider
--------------------------------------------------------------------------

DECLARE @RC int
DECLARE @startVal int
DECLARE @endVal int

SET @startVal = 0
SET @endVal = 9999

EXECUTE @RC = [dbo].[cust_cccev_ckin_sp_insert_security_code_addNumbers] @startVal, @endVal


COMMIT TRANSACTION

--------------------------------------------------------------------------
-- Add "Reset Security Codes" SQL job programatically
--------------------------------------------------------------------------
DECLARE @DatabaseName varchar(50)
SELECT @DatabaseName = db_name()

DECLARE @JobName varchar(100)
SET @JobName = @DatabaseName + ' Check-in Reset Security Codes'

USE [msdb]

/****** Object:  Job [Check-in Reset Security Codes]    Script Date: 02/24/2009 14:32:25 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 02/24/2009 14:32:25 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@JobName, 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Clear the date and guid from the cust_cccev_ckin_security_code  (security code) table.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run cust_cccev_ckin_sp_update_security_code_clearAssignDate]    Script Date: 02/24/2009 14:32:26 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run cust_cccev_ckin_sp_update_security_code_clearAssignDate', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'cust_cccev_ckin_sp_update_security_code_clearAssignDate', 
		@database_name=@DatabaseName, 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Weekly Checkin Reset', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=32, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20090215, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

