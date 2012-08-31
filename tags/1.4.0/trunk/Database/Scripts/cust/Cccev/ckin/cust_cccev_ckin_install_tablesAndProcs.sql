/**********************************************************************
* Description:	Install custom tables and stored procedures. 
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
*				Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	10/14/2009 15:42:29
*
* $Workfile: cust_cccev_ckin_install_tablesAndProcs.sql $
* $Revision: 5 $ 
* $Header: /trunk/Database/Scripts/cust/Cccev/ckin/cust_cccev_ckin_install_tablesAndProcs.sql   5   2009-10-14 16:35:36-07:00   nicka $
* 
* $Log: /trunk/Database/Scripts/cust/Cccev/ckin/cust_cccev_ckin_install_tablesAndProcs.sql $
*  
*  Revision: 5   Date: 2009-10-14 23:35:36Z   User: nicka 
*  added cust_cccev_applog table and corresponding lookup data (for upgrade 
*  script) 
***********************************************************************/

-- Create Application Log Table ---------------------------------------- 
CREATE TABLE [dbo].[cust_cccev_applog](
	[applog_id] [int] IDENTITY(1,1) NOT NULL,
	[type_luid] [int] NOT NULL,
	[date] [datetime] NOT NULL CONSTRAINT [DF_cust_cccev_applog_date]  DEFAULT (getdate()),
	[text] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_cust_cccev_applog] PRIMARY KEY CLUSTERED 
(
	[applog_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[cust_cccev_applog]  WITH CHECK ADD  CONSTRAINT [FK_cust_cccev_applog_core_lookup] FOREIGN KEY([type_luid])
REFERENCES [dbo].[core_lookup] ([lookup_id])
GO
ALTER TABLE [dbo].[cust_cccev_applog] CHECK CONSTRAINT [FK_cust_cccev_applog_core_lookup]


-- Create Occurrence Type Attribute Table ---------------------------------------- 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[cust_cccev_ckin_occurrence_type_attribute](
	[occurrence_type_attribute_id] [int] IDENTITY(1,1) NOT NULL,
	[occurrence_type_id] [int] NOT NULL,
	[is_special_needs] [bit] NOT NULL CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_is_special_needs]  DEFAULT ((0)),
	[last_name_starting_letter] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_last_name_starting_letter]  DEFAULT (''),
	[last_name_ending_letter] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_last_name_ending_letter]  DEFAULT (''),
	[is_room_balancing]  [bit] NOT NULL CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_is_room_balancing]  DEFAULT ((0)),
	[date_created] [datetime] NOT NULL CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_date_created]  DEFAULT (getdate()),
	[date_modified] [datetime] NOT NULL CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_date_modified]  DEFAULT (getdate()),
	[created_by] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[modified_by] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cust_cccev_ckin_occurrence_type_attribute] PRIMARY KEY CLUSTERED 
(
	[occurrence_type_attribute_id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'this field needs a cascade on delete' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cust_cccev_ckin_occurrence_type_attribute', @level2type=N'COLUMN', @level2name=N'occurrence_type_id'

ALTER TABLE [cust_cccev_ckin_occurrence_type_attribute]  WITH CHECK
ADD  CONSTRAINT [FK_cust_cccev_ckin_occurrence_type_attribute_core_occurrence_type]
FOREIGN KEY([occurrence_type_id]) REFERENCES [core_occurrence_type] ([occurrence_type_id]) ON DELETE CASCADE 

GO

-- Create Security Code Table -------------------------------------------------


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cust_cccev_ckin_security_code](
	[security_code] int NOT NULL,
	[assigned_date] datetime NULL,
	[unique_key] uniqueidentifier NULL,
 CONSTRAINT [PK_cust_cccev_ckin_security_code] PRIMARY KEY CLUSTERED 
(
	[security_code] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

-- Create Delete Occurrence Type Attribute Proc ---------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_del_occurrenceTypeAttribute]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_del_occurrenceTypeAttribute]
GO
	
create Proc cust_cccev_ckin_sp_del_occurrenceTypeAttribute
@OccurrenceTypeAttributeId int

AS

	DELETE cust_cccev_ckin_occurrence_type_attribute
	WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId
	
GO

-- Create Get Occurrence Attendance By Person ID and Start Date Proc ------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate]
GO

CREATE PROC cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate

@StartDate datetime,
@PersonID int

AS

SELECT TOP 1 *
FROM [core_occurrence_attendance] OA
INNER JOIN [core_occurrence] O
	ON O.occurrence_id = OA.occurrence_id
WHERE O.occurrence_start_time = @StartDate
	AND OA.person_id = @PersonID
ORDER BY OA.check_in_time DESC

GO

-- Create Get Occurrence By Category And Date Proc -----------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate]
GO

create Proc cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate
@GroupId int,
@StartDate datetime,
@EndDate datetime,
@CampusID int
AS

SET NOCOUNT ON

	SELECT O.* 
	FROM core_occurrence O
	INNER JOIN core_occurrence_type OT ON O.occurrence_type = OT.occurrence_type_id
	LEFT OUTER JOIN orgn_location L ON O.location_id = L.location_id
	WHERE OT.group_id = @GroupId
	AND
	(
		O.check_in_start BETWEEN @StartDate AND @EndDate
		OR O.check_in_end BETWEEN @StartDate AND @EndDate
	)
	AND (campus_luid = @CampusID OR @CampusID = -1)
	AND occurrence_closed <> 1
	ORDER BY occurrence_start_time,
	OT.type_name,
	L.location_name

GO

-- Create Get Occurrences By System ID and Date Range Proc ---------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange]
GO

CREATE PROC [cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange]

@SystemID int,
@StartDate datetime,
@EndDate datetime
AS

SELECT O.*
FROM [core_occurrence] O
INNER JOIN [core_occurrence_type] OT
	ON OT.occurrence_type_id = O.occurrence_type
INNER JOIN [comp_system_location] SL
	ON SL.location_id = O.location_id
INNER JOIN [orgn_location_occurrence_type] LOT
	ON LOT.occurrence_type_id = O.occurrence_type
		AND LOT.location_id = O.location_id
WHERE SL.system_id = @SystemID
	AND 
	(
		O.check_in_start BETWEEN @StartDate AND @EndDate
		OR O.check_in_end BETWEEN @StartDate AND @EndDate
		OR @StartDate BETWEEN O.check_in_start AND O.check_in_end
	)
ORDER BY O.occurrence_start_time, OT.type_order DESC, LOT.location_order

GO

-- Create Get Occurrence Type Attribute By Group ID  Proc -----------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId]
GO

create Proc [dbo].[cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId]
@GroupId int
AS

SET NOCOUNT ON

	SELECT ota.* 
	FROM cust_cccev_ckin_occurrence_type_attribute ota
	INNER JOIN core_occurrence_type ot ON ot.occurrence_type_id = ota.occurrence_type_id
	WHERE ot.group_id = @GroupId
	ORDER BY ot.type_order ASC

SET NOCOUNT OFF	

GO

-- Create Get Occurrence Type Attribute By ID Proc -----------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrenceTypeAttributeById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrenceTypeAttributeById]
GO

create Proc cust_cccev_ckin_sp_get_occurrenceTypeAttributeByID
@OccurrenceTypeAttributeId int
AS

	SELECT * 
	FROM cust_cccev_ckin_occurrence_type_attribute
	WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId
	
GO

-- Create Get Occurrence Type Attribute By Occurrence Type ID Proc -------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrenceTypeAttributeByOccurrenceTypeId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrenceTypeAttributeByOccurrenceTypeId]
GO

create Proc cust_cccev_ckin_sp_get_occurrenceTypeAttributeByOccurrenceTypeId
@OccurrenceTypeId int

AS

	SELECT * 
	FROM cust_cccev_ckin_occurrence_type_attribute
	WHERE [occurrence_type_id] = @OccurrenceTypeId
	
GO

-- Create Get Person With Health or Legal Notes By Age or Grade Proc -----------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cust_cccev_ckin_sp_get_personWithHealthOrLegalNotesByAgeOrGrade]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[cust_cccev_ckin_sp_get_personWithHealthOrLegalNotesByAgeOrGrade]
GO

CREATE PROCEDURE cust_cccev_ckin_sp_get_personWithHealthOrLegalNotesByAgeOrGrade
	-- Add the parameters for the stored procedure here
	@HealthNotesAttrId int,
	@LegalNotesAttrId int,
	@MinGrade int = -1,
	@MaxGrade int = -1,
	@MinAge int = -1,
	@MaxAge int = -1
AS

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON

-- Insert statements for procedure here
DECLARE @byGrade bit SET @byGrade = 0
DECLARE @byAge bit SET @byAge = 0
IF (@MinGrade<>-1 AND @MaxGrade<>-1)
BEGIN
	SET @byGrade = 1
	SET @MinGrade = @MinGrade + 1
	SET @MaxGrade = @MaxGrade + 1
END
IF (@MinAge<>-1 AND @MaxAge<>-1) BEGIN SET @byAge = 1 END

SELECT last_name + ', ' + first_name AS 'Name', hn.varchar_value AS 'Health Notes',
	ln.varchar_value AS 'Legal Notes'
	FROM core_person p
LEFT OUTER JOIN core_person_attribute hn ON hn.person_id = p.person_id 
	AND hn.attribute_id = @HealthNotesAttrId AND hn.varchar_value <> ''
LEFT OUTER JOIN core_person_attribute ln ON ln.person_id = p.person_id
	AND ln.attribute_id = @LegalNotesAttrId AND ln.varchar_value <> ''
WHERE NOT (hn.varchar_value = '' AND ln.varchar_value = '')
	AND (NOT @byAge=1 OR dbo.fn_age(p.birth_date, getdate()) BETWEEN @MinAge AND @MaxAge)
	AND (NOT @byGrade=1 OR dbo.core_grade(getdate(), p.graduation_date) BETWEEN @MinGrade AND @MaxGrade) -- core_grade() returns 1 for kindergarten 
	ORDER BY p.last_name, p.first_name

SET NOCOUNT OFF

GO

-- Create Get Security Code Proc -----------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[cust_cccev_ckin_sp_get_security_code]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [cust_cccev_ckin_sp_get_security_code]
GO

CREATE PROCEDURE [dbo].[cust_cccev_ckin_sp_get_security_code]
   @FullCode CHAR(6) OUTPUT
AS

DECLARE @uniqueKey UNIQUEIDENTIFIER
SET @uniqueKey = NEWID()

DECLARE @dt DATETIME
SET @dt = GETDATE()

UPDATE [cust_cccev_ckin_security_code]
   SET
	[assigned_date] = @dt,
	[unique_key] = @uniqueKey
WHERE
   [unique_key] IS NULL
   AND [security_code] IN (SELECT MIN([security_code]) FROM [cust_cccev_ckin_security_code] WHERE [unique_key] IS NULL)

DECLARE @newCode INT

SELECT @newCode = [security_code]
FROM [cust_cccev_ckin_security_code]
WHERE [unique_key] = @uniqueKey

DECLARE @Seed INT

SET @Seed = DATEPART(ms, GETDATE())

SELECT @FullCode = CHAR(65 + CAST((RAND() * @Seed) AS INT) % 26) + CHAR(65 + CAST((RAND() * @Seed) AS INT) % 26) + RIGHT('0000' + CONVERT(VARCHAR(4), @newCode), 4)

PRINT @FullCode

GO

-- Create Insert Security Code Add Numbers Proc --------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[cust_cccev_ckin_sp_insert_security_code_addNumbers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [cust_cccev_ckin_sp_insert_security_code_addNumbers]
GO

CREATE PROCEDURE [dbo].[cust_cccev_ckin_sp_insert_security_code_addNumbers]
   @startVal INT,
   @endVal INT
AS

SET NOCOUNT ON

WHILE @startVal <= @endVal
BEGIN
   IF (@startVal != 666 AND @startVal != 911 ) 
   BEGIN
      IF NOT EXISTS (SELECT * FROM [cust_cccev_ckin_security_code] WHERE [security_code] = @startVal)
         INSERT [cust_cccev_ckin_security_code] ([security_code]) VALUES (@startVal)
   END
   SET @startVal = @startVal + 1
END

SET NOCOUNT OFF

GO

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

-- Create Update Security Code Clear Assign Date Proc --------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[cust_cccev_ckin_sp_update_security_code_clearAssignDate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [cust_cccev_ckin_sp_update_security_code_clearAssignDate]
GO

CREATE Procedure [dbo].[cust_cccev_ckin_sp_update_security_code_clearAssignDate]

AS

UPDATE [cust_cccev_ckin_security_code]
   SET
	[assigned_date] = NULL,
	[unique_key] = NULL
	
GO
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- v1.3.0 Add two functions that are used by the sample RS label reports -------
--        Add one stored procedure that should have already existed      -------
--------------------------------------------------------------------------------

-- #1 cust_hdc_funct_calc_age
-----------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cust_hdc_funct_calc_age]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[cust_hdc_funct_calc_age]
GO

CREATE FUNCTION [dbo].[cust_hdc_funct_calc_age](@birthdate DATETIME, @mcutoff INT, @ycutoff INT)
RETURNS VARCHAR(10)
AS
BEGIN

DECLARE @years INT, @months INT, @decades INT

IF @birthdate > GETDATE()
    SET @months = 0
ELSE
    SET @months = (DATEDIFF(month,@birthdate,GETDATE()) - CASE WHEN DAY(GETDATE()) < DAY(@birthdate) THEN 1 ELSE 0 END)

SET @years = @months / 12
SET @decades = ROUND(@years/10,0)*10

RETURN CASE
    WHEN @years < @mcutoff THEN CAST(@months % (@mcutoff * 12) AS VARCHAR) + CASE WHEN @months = 1 THEN ' month' ELSE ' months' END
    WHEN @years < @ycutoff THEN CAST(@years AS VARCHAR) + CASE WHEN @years = 1 THEN ' year' ELSE ' years' END
    WHEN @years < 100 THEN CAST(@decades AS VARCHAR) + '''s'
    ELSE ''
	END
END

GO

-- #2 cust_hdc_funct_parent_names
---------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cust_hdc_funct_parent_names]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[cust_hdc_funct_parent_names]
GO

CREATE FUNCTION [dbo].[cust_hdc_funct_parent_names] (@PersonID int)
	RETURNS varchar(2000)
AS
BEGIN
	DECLARE @ParentNames varchar(2000)
	SET @ParentNames = ''
	
	DECLARE @AdultRoleID int
	SET @AdultRoleID = dbo.core_funct_luid_familyAdult()

	SELECT @ParentNames = 
		RTRIM(ISNULL(P.nick_name,'')) + ' ' + CASE @ParentNames WHEN '' THEN RTRIM(ISNULL(P.last_name,'')) ELSE 'and ' END +
		@ParentNames
	FROM core_family_member FM
	INNER JOIN core_family_member FM2 ON FM2.family_id = FM.family_id
	INNER JOIN core_person P ON P.person_id = FM2.person_id
	WHERE FM.person_id = @PersonID AND FM2.role_luid = @AdultRoleID
	ORDER BY P.gender DESC

	RETURN @ParentNames
END
GO

-- #3 cust_cccev_ckin_sp_get_location_head_count_by_date
--------------------------------------------------------
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

--------------------------------------------------------------------------------
