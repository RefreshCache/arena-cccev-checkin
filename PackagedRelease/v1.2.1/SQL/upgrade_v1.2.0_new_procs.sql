/**********************************************************************
* Description:	Install new stored procedures and other data for the 1.2.0 release
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
*				Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	10/28/2009 14:02:29
*
* $Workfile: 20091028_v1.2.0_new_procs.sql $
* $Revision: 3 $ 
* $Header: /trunk/Database/Scripts/cust/Cccev/ckin/20091028_v1.2.0_new_procs.sql   3   2009-11-25 13:27:15-07:00   nicka $
* 
* $Log: /trunk/Database/Scripts/cust/Cccev/ckin/20091028_v1.2.0_new_procs.sql $
*  
*  Revision: 3   Date: 2009-11-25 20:27:15Z   User: nicka 
*  for v1.2.0, add new data items (like reporting services related stuff) to 
*  lookup tables, etc. 
*  
*  Revision: 2   Date: 2009-11-05 20:06:03Z   User: nicka 
*  adding the sproc that changed for this version 
*  
*  Revision: 1   Date: 2009-10-28 21:06:07Z   User: nicka 
***********************************************************************/

BEGIN TRANSACTION

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

DECLARE @OrganizationID int
SET @OrganizationID = 1

DECLARE @CurrentUser varchar(50)
SELECT @CurrentUser = SYSTEM_USER

DECLARE @Today DateTime
SET @Today = GetDate()

-- Organization Setting Categories (Lookup Type)
-- Cccev Check-in Labels
DECLARE @CccevCheckinLabelsCategoryGuid uniqueidentifier
SET @CccevCheckinLabelsCategoryGuid = 'a5f7d5ad-0a36-412d-98be-75e50202179c'

-- Print Label Provider Lookup Type
DECLARE @CheckInPrintLabelSystemGuid uniqueidentifier
SET @CheckInPrintLabelSystemGuid = '420221aa-8c79-435b-b884-fa3f6855d0d1'

--------------------------------------------------------------------------
-- Lookup Value for Organization Setting Categories
-- Add the Cccev Check-in Labels lookup
--------------------------------------------------------------------------
DECLARE @CccevCheckinLabelsCategoryLookupID int
SELECT @CccevCheckinLabelsCategoryLookupID = lookup_id FROM core_lookup WHERE guid = @CccevCheckinLabelsCategoryGuid

--------------------------------------------------------------------------
-- New Organization Settings for Check-in Label (Category)
-- Settings used by the Cccev "default" Print Label provider
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.DisplayRoomNameOnNameTag')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.DisplayRoomNameOnNameTag', 'false', @Today, @Today, @CurrentUser, @CurrentUser, 'Boolean value to determine whether location name will be printed on name tag.', 0, @CccevCheckinLabelsCategoryLookupID, 0)
END

--------------------------------------------------------------------------
-- Add the new RS print label provider
--------------------------------------------------------------------------

-- GUID for the RS Print Label provider
DECLARE @RSCheckInPrintLabelGuid uniqueidentifier
SET @RSCheckInPrintLabelGuid = '7C879FED-8B1B-4CE6-8EBD-8412331BEEC7'

DECLARE @CheckInPrintLabelSystemLookupTypeID int
SELECT @CheckInPrintLabelSystemLookupTypeID = lookup_type_id FROM core_lookup_type WHERE @CheckInPrintLabelSystemGuid = guid

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @RSCheckInPrintLabelGuid )
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@RSCheckInPrintLabelGuid, @CheckInPrintLabelSystemLookupTypeID, 'Cccev RS Print Label Provider', '', 'Arena.Custom.Cccev.CheckIn', '', '', '', '', '', 'Arena.Custom.Cccev.CheckIn.Entity.RSPrintLabel', 1, 1, 0, NULL)
END

COMMIT TRANSACTION

--------------------------------------------------------------------------
-- New stored procedures
--------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_location_head_count_by_date]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_location_head_count_by_date]
GO

CREATE Proc [dbo].[cust_cccev_ckin_sp_get_location_head_count_by_date]
@LocationID int,
@StartDate datetime
AS

	SELECT COUNT(distinct oa.person_id)
	FROM core_occurrence O
	INNER JOIN core_occurrence_attendance OA ON O.occurrence_id = OA.occurrence_id
	WHERE O.location_id = @LocationID
	AND (O.occurrence_start_time <= @StartDate OR check_in_start <= @StartDate)
	AND (O.occurrence_end_time >= @StartDate OR check_in_end >= @StartDate)
	AND OA.attended = 1
	AND OA.check_in_time IS NOT NULL
	AND OA.check_in_time <> '1/1/1900'
	AND OA.check_out_time = '1/1/1900'

GO

		
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_save_occurrenceTypeAttribute]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_save_occurrenceTypeAttribute]
GO	

CREATE Proc cust_cccev_ckin_sp_save_occurrenceTypeAttribute
@OccurrenceTypeAttributeId int,
@OccurrenceTypeId int,
@IsSpecialNeeds bit,
@IsRoomBalancing bit,
@LastNameStartingLetter varchar(1),
@LastNameEndingLetter varchar(1),
@UserId varchar(50),
@ID int OUTPUT

AS

	DECLARE @UpdateDateTime DateTime SET @UpdateDateTime = GETDATE()
		
	IF NOT EXISTS(
		SELECT * FROM cust_cccev_ckin_occurrence_type_attribute
		WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId
		)
		
	BEGIN
	
		INSERT INTO cust_cccev_ckin_occurrence_type_attribute
		(	
			 [date_created]
			,[date_modified]
			,[created_by]
			,[modified_by]
			,[occurrence_type_id]
			,[is_special_needs]
			,[is_room_balancing]
			,[last_name_starting_letter]
			,[last_name_ending_letter]
		)
		values
		(	
			 @UpdateDateTime
			,@UpdateDateTime
			,@UserID
			,@UserID
			,@OccurrenceTypeId
			,@IsSpecialNeeds
			,@IsRoomBalancing
			,@LastNameStartingLetter
			,@LastNameEndingLetter
		)

		SET @ID = @@IDENTITY

	END
	ELSE
	BEGIN

		UPDATE cust_cccev_ckin_occurrence_type_attribute Set
			 [date_modified] = @UpdateDateTime 
			,[modified_by] = @UserID
			,[occurrence_type_id] = @OccurrenceTypeId
			,[is_special_needs] = @IsSpecialNeeds
			,[is_room_balancing] = @IsRoomBalancing
			,[last_name_starting_letter] = @LastNameStartingLetter
			,[last_name_ending_letter] = @LastNameEndingLetter
		WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId

		SET @ID = @OccurrenceTypeAttributeId

	END
GO
