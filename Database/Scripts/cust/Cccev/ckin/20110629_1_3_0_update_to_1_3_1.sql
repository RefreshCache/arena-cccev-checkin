/**********************************************************************
* Description:  Patch from v1.3.0 to v1.3.1
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created: 06/29/2011
*
* $Workfile: $
* $Revision:  $
* $Header: $
*
* $Log: $
**********************************************************************/

DECLARE @CurrentUser varchar(50)
SELECT @CurrentUser = SYSTEM_USER

DECLARE @Today DateTime
SET @Today = GetDate()

--------------------------------------------------------------------------
-- Define the template if not already defined
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM port_template WHERE [template_url] like '%UserControls/Custom/Cccev/Checkin/misc/BlankTemplate.ascx')
BEGIN
	INSERT INTO [dbo].[port_template] ([date_created],[date_modified],[created_by],[modified_by],[template_name],[template_desc],[template_url]) VALUES (@Today, @Today, @CurrentUser, @CurrentUser, 'Check-in Wizard Blank Template', 'For use with the Check-in Wizard module', '~/UserControls/Custom/Cccev/Checkin/misc/BlankTemplate.ascx')
END

--------------------------------------------------------------------------
-- Add missing is_room_balancing if not there while adding 'false' for
-- all existing records in the table.
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'cust_cccev_ckin_occurrence_type_attribute' AND COLUMN_NAME = 'is_room_balancing')
BEGIN
   ALTER TABLE cust_cccev_ckin_occurrence_type_attribute ADD is_room_balancing BIT NOT NULL
   CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_is_room_balancing] DEFAULT ((0)) WITH VALUES 
END


--------------------------------------------------------------------------
-- Correction for missing is_room_balancing parameter
--------------------------------------------------------------------------

-- Create Save Occurrence Type Attribute Proc --------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_save_occurrenceTypeAttribute]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_save_occurrenceTypeAttribute]
GO

create Proc cust_cccev_ckin_sp_save_occurrenceTypeAttribute
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
