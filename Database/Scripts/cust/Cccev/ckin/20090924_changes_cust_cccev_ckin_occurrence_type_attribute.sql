/**********************************************************************
* Description:  To update cust_cccev_ckin_occurrence_type_attribute to latest version
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created: 9/23/2009
*
* $Workfile: 20090924_changes_cust_cccev_ckin_occurrence_type_attribute.sql $
* $Revision: 2 $
* $Header: /trunk/Database/Scripts/cust/Cccev/ckin/20090924_changes_cust_cccev_ckin_occurrence_type_attribute.sql   2   2009-09-24 14:09:14-07:00   JasonO $
*
* $Log: /trunk/Database/Scripts/cust/Cccev/ckin/20090924_changes_cust_cccev_ckin_occurrence_type_attribute.sql $
*  
*  Revision: 2   Date: 2009-09-24 21:09:14Z   User: JasonO 
**********************************************************************/

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
GO

BEGIN TRANSACTION

if exists (select * from dbo.sysobjects where id = object_id(N'[DF_cust_cccev_ckin_occurrence_type_attribute_min_age_months]') and OBJECTPROPERTY(id, N'IsConstraint') = 1)
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_min_age_months]
END

if exists (select * from dbo.sysobjects where id = object_id(N'[DF_cust_cccev_ckin_occurrence_type_attribute_max_age_months]') and OBJECTPROPERTY(id, N'IsConstraint') = 1)
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_cust_cccev_ckin_occurrence_type_attribute_max_age_months
END

if exists (select * from dbo.sysobjects where id = object_id(N'[DF_Table_1_grade_starting_age_group]') and OBJECTPROPERTY(id, N'IsConstraint') = 1)
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_Table_1_grade_starting_age_group
END

if exists (select * from dbo.sysobjects where id = object_id(N'[DF_Table_1_grade_ending_age_group]') and OBJECTPROPERTY(id, N'IsConstraint') = 1)
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_Table_1_grade_ending_age_group
END

if exists (select * from dbo.sysobjects where id = object_id(N'[DF_cust_cccev_ckin_occurrence_type_attribute_is_room_balancing]') and OBJECTPROPERTY(id, N'IsConstraint') = 1)
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_cust_cccev_ckin_occurrence_type_attribute_is_room_balancing
END

/* Now drop the no-longer-needed columns */

if exists ( select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='cust_cccev_ckin_occurrence_type_attribute' and table_schema = 'dbo' and COLUMN_NAME = 'min_age_months')
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP COLUMN min_age_months
END 

if exists ( select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='cust_cccev_ckin_occurrence_type_attribute' and table_schema = 'dbo' and COLUMN_NAME = 'max_age_months')
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP COLUMN max_age_months
END 

if exists ( select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='cust_cccev_ckin_occurrence_type_attribute' and table_schema = 'dbo' and COLUMN_NAME = 'max_grade')
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP COLUMN max_grade
END 

if exists ( select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='cust_cccev_ckin_occurrence_type_attribute' and table_schema = 'dbo' and COLUMN_NAME = 'min_grade')
BEGIN
	ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP COLUMN min_grade
END 


ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_cust_cccev_ckin_occurrence_type_attribute_is_special_needs

ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_cust_cccev_ckin_occurrence_type_attribute_last_name_starting_letter

ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_cust_cccev_ckin_occurrence_type_attribute_last_name_ending_letter

ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_cust_cccev_ckin_occurrence_type_attribute_date_created

ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute
	DROP CONSTRAINT DF_cust_cccev_ckin_occurrence_type_attribute_date_modified


/* Now setup the new table */

CREATE TABLE dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute
	(
	occurrence_type_attribute_id int NOT NULL IDENTITY (1, 1),
	occurrence_type_id int NOT NULL,
	is_special_needs bit NOT NULL,
	last_name_starting_letter varchar(1) NOT NULL,
	last_name_ending_letter varchar(1) NOT NULL,
	is_room_balancing bit NOT NULL,
	date_created datetime NOT NULL,
	date_modified datetime NOT NULL,
	created_by varchar(50) NULL,
	modified_by varchar(50) NULL
	)  ON [PRIMARY]

DECLARE @v sql_variant
SET @v = N'this field needs a cascade on delete'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cust_cccev_ckin_occurrence_type_attribute', N'COLUMN', N'occurrence_type_id'

ALTER TABLE dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute ADD CONSTRAINT
	DF_cust_cccev_ckin_occurrence_type_attribute_is_special_needs DEFAULT ((0)) FOR is_special_needs

ALTER TABLE dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute ADD CONSTRAINT
	DF_cust_cccev_ckin_occurrence_type_attribute_last_name_starting_letter DEFAULT ('') FOR last_name_starting_letter

ALTER TABLE dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute ADD CONSTRAINT
	DF_cust_cccev_ckin_occurrence_type_attribute_last_name_ending_letter DEFAULT ('') FOR last_name_ending_letter

ALTER TABLE dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute ADD CONSTRAINT
	DF_cust_cccev_ckin_occurrence_type_attribute_is_room_balancing DEFAULT 0 FOR is_room_balancing

ALTER TABLE dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute ADD CONSTRAINT
	DF_cust_cccev_ckin_occurrence_type_attribute_date_created DEFAULT (getdate()) FOR date_created

ALTER TABLE dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute ADD CONSTRAINT
	DF_cust_cccev_ckin_occurrence_type_attribute_date_modified DEFAULT (getdate()) FOR date_modified

SET IDENTITY_INSERT dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute ON

IF EXISTS(SELECT * FROM dbo.cust_cccev_ckin_occurrence_type_attribute)
	 EXEC('INSERT INTO dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute (occurrence_type_attribute_id, occurrence_type_id, is_special_needs, last_name_starting_letter, last_name_ending_letter, date_created, date_modified, created_by, modified_by)
		SELECT occurrence_type_attribute_id, occurrence_type_id, is_special_needs, last_name_starting_letter, last_name_ending_letter, date_created, date_modified, created_by, modified_by FROM dbo.cust_cccev_ckin_occurrence_type_attribute WITH (HOLDLOCK TABLOCKX)')

SET IDENTITY_INSERT dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute OFF

DROP TABLE dbo.cust_cccev_ckin_occurrence_type_attribute

EXECUTE sp_rename N'dbo.Tmp_cust_cccev_ckin_occurrence_type_attribute', N'cust_cccev_ckin_occurrence_type_attribute', 'OBJECT' 

ALTER TABLE dbo.cust_cccev_ckin_occurrence_type_attribute ADD CONSTRAINT
	PK_cust_cccev_ckin_occurrence_type_attribute PRIMARY KEY CLUSTERED 
	(
	occurrence_type_attribute_id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]



COMMIT
GO