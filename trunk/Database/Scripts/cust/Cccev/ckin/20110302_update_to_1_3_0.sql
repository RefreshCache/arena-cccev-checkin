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