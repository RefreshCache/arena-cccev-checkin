SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		DallonF
-- Create date: 2/9/09
-- Description:	Gets Person records where there are health or legal notes, filtering by grade and/or age.
-- =============================================

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
/**********************************************************************
* Description:	Returns children with health and/or legal notes for
*				a given filter criteria.
* Created By:	Dallon Feldner
* Date Created:	2/10/2009
*
* $Workfile: cust_cccev_ckin_sp_get_personWithHealthOrLegalNotesByAgeOrGrade.sql $
* $Revision: 4 $ 
* $Header: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_personWithHealthOrLegalNotesByAgeOrGrade.sql   4   2009-02-11 16:10:50-07:00   nicka $
* 
* $Log: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_personWithHealthOrLegalNotesByAgeOrGrade.sql $
*  
*  Revision: 4   Date: 2009-02-11 23:10:50Z   User: nicka 
*  sort by last, first 
*  
*  Revision: 3   Date: 2009-02-11 21:33:30Z   User: nicka 
**********************************************************************/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
END
GO
