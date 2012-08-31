SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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


