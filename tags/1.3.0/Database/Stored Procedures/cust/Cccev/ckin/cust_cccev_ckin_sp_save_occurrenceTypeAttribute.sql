SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
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