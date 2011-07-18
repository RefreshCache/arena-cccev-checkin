

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
	
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_checkin_sp_get_occurrenceTypeAttributeById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_checkin_sp_get_occurrenceTypeAttributeById]
GO
	
create Proc cust_cccev_checkin_sp_get_occurrenceTypeAttributeByID
@OccurrenceTypeAttributeId int
AS

	SELECT * 
	FROM cust_cccev_ckin_occurrence_type_attribute
	WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId
GO
		
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_checkin_sp_get_occurrenceTypeAttributeByOccurrenceTypeId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_checkin_sp_get_occurrenceTypeAttributeByOccurrenceTypeId]

GO

create Proc cust_cccev_checkin_sp_get_occurrenceTypeAttributeByOccurrenceTypeId
@OccurrenceTypeId int

AS

	SELECT * 
	FROM cust_cccev_ckin_occurrence_type_attribute
	WHERE [occurrence_type_id] = @OccurrenceTypeId

GO


if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_checkin_sp_del_occurrenceTypeAttribute]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_checkin_sp_del_occurrenceTypeAttribute]
GO
	
create Proc cust_cccev_checkin_sp_del_occurrenceTypeAttribute
@OccurrenceTypeAttributeId int
AS

	DELETE cust_cccev_ckin_occurrence_type_attribute
	WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId
GO		
		
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_checkin_sp_save_occurrenceTypeAttribute]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_checkin_sp_save_occurrenceTypeAttribute]
GO	


create Proc cust_cccev_checkin_sp_save_occurrenceTypeAttribute
@OccurrenceTypeAttributeId int,
@OccurrenceTypeId int,
@IsSpecialNeeds bit,
@LastNameStartingLetter varchar(1),
@LastNameEndingLetter varchar(1),
@AbilityLevelLuid int,
@MinAgeMonths int,
@MaxAgeMonths int,
@MinGrade int,
@MaxGrade int,
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
			,[last_name_starting_letter]
			,[last_name_ending_letter]
			,[ability_level_luid]
			,[min_age_months]
			,[max_age_months]
			,[min_grade]
			,[max_grade]
		)
		values
		(	
			 @UpdateDateTime
			,@UpdateDateTime
			,@UserID
			,@UserID
			,@OccurrenceTypeId
			,@IsSpecialNeeds
			,@LastNameStartingLetter
			,@LastNameEndingLetter
			,@AbilityLevelLuid
			,@MinAgeMonths
			,@MaxAgeMonths
			,@MinGrade
			,@MaxGrade
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
			,[last_name_starting_letter] = @LastNameStartingLetter
			,[last_name_ending_letter] = @LastNameEndingLetter
			,[ability_level_luid] = @AbilityLevelLuid
			,[min_age_months] = @MinAgeMonths
			,[max_age_months] = @MaxAgeMonths
			,[min_grade] = @MinGrade
			,[max_grade] = @MaxGrade
		WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId

		SET @ID = @OccurrenceTypeAttributeId

	END
GO
