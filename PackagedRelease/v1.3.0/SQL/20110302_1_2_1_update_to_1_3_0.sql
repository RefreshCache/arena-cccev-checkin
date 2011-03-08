/**********************************************************************
* Description:  Upgrade to v1.3.0
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created: 03/02/2011
*
* $Workfile: $
* $Revision:  $
* $Header: $
*
* $Log: $
**********************************************************************/

BEGIN TRANSACTION

DECLARE @OrganizationID int
SET @OrganizationID = 1

DECLARE @CurrentUser varchar(50)
SELECT @CurrentUser = SYSTEM_USER

DECLARE @Today DateTime
SET @Today = GetDate()

-- Organization Setting Categories (Lookup Type)
-- Cccev Check-in Wizard
DECLARE @CccevCheckinWizardCategoryGuid uniqueidentifier
SET @CccevCheckinWizardCategoryGuid = 'f0da7805-8590-406f-83c0-f7f074d14c1e'

DECLARE @CccevCheckinWizardCategoryLookupID int
SELECT @CccevCheckinWizardCategoryLookupID = lookup_id FROM core_lookup WHERE guid = @CccevCheckinWizardCategoryGuid

--------------------------------------------------------------------------
-- New Organization Settings for 1.3.0
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.AllowedInactiveReasons')
BEGIN
	INSERT INTO [dbo].[orgn_organization_setting] ([organization_id], [Key], [Value], [date_created], [date_modified], [created_by], [modified_by], [Descr], [system_flag], [category_luid], [read_only]) VALUES (@OrganizationID, 'Cccev.AllowedInactiveReasons', '', @Today, @Today, @CurrentUser, @CurrentUser, 'Comma delimted list of LookupIDs (inactive reasons).  If set, will allow individuals whose record status is marked as inactive to check-in using the Check-in Wizard.', 0, @CccevCheckinWizardCategoryLookupID, 0)
END

--------------------------------------------------------------------------
-- Remove old org setting no longer used
--------------------------------------------------------------------------
IF EXISTS (SELECT * FROM orgn_organization_setting WHERE [Key] = 'Cccev.PrintLabelDefaultSystemID')
BEGIN
	DELETE FROM [dbo].[orgn_organization_setting] WHERE [Key] = 'Cccev.PrintLabelDefaultSystemID'
END

COMMIT
GO

--------------------------------------------------------------------------
-- Add two functions that are used by the sample RS label reports
--------------------------------------------------------------------------

-- #1 cust_hdc_funct_calc_age
--------------------------------------------------------------------------
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


-- #2 
--------------------------------------------------------------------------
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

