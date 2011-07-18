/**********************************************************************
* Description:  Upgrade v1.1.0 to v1.2.0 the cust_cccev_applog table
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created: 10/14/2009
*
* $Workfile: 20091014_install_applog_table_and_data.sql $
* $Revision: 1 $
* $Header: /trunk/Database/Scripts/cust/Cccev/ckin/20091014_install_applog_table_and_data.sql   1   2009-10-14 16:43:13-07:00   nicka $
*
* $Log: /trunk/Database/Scripts/cust/Cccev/ckin/20091014_install_applog_table_and_data.sql $
*  
*  Revision: 1   Date: 2009-10-14 23:43:13Z   User: nicka 
**********************************************************************/

BEGIN TRANSACTION

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

DECLARE @OrganizationID int
SET @OrganizationID = 1

-- Create Application Log Table ---------------------------------------- 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cust_cccev_applog]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
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

ALTER TABLE [dbo].[cust_cccev_applog]  WITH CHECK ADD  CONSTRAINT [FK_cust_cccev_applog_core_lookup] FOREIGN KEY([type_luid])
REFERENCES [dbo].[core_lookup] ([lookup_id])

ALTER TABLE [dbo].[cust_cccev_applog] CHECK CONSTRAINT [FK_cust_cccev_applog_core_lookup]

END

-- GUID for the Application Log Type Lookup Type
DECLARE @AppLogTypeLookupTypeGuid uniqueidentifier
SET @AppLogTypeLookupTypeGuid = 'B79DBFB8-A7EE-407D-9D5A-B851CD60CFE1'

-- GUID for the 'Check-in' Application Log Type Lookup
DECLARE @CheckinAppLogTypeGuid uniqueidentifier
SET @CheckinAppLogTypeGuid = '2A33F0EA-10F8-416C-B341-AEB7D0C08190'

--------------------------------------------------------------------------
-- Lookup Type: Application Log Type
-- Add the 'Application Log Type' Lookup Type into the core_lookup_type table
--------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM core_lookup_type WHERE guid = @AppLogTypeLookupTypeGuid)
BEGIN
INSERT INTO core_lookup_type
           ([guid]
           ,[lookup_type_name]
           ,[lookup_type_desc]
           ,[lookup_category]
           ,[qualifier_1_title]
           ,[qualifier_2_title]
           ,[organization_id]
           ,[system_flag]
           ,[qualifier_3_title]
           ,[qualifier_4_title]
           ,[qualifier_5_title]
           ,[qualifier_6_title]
           ,[qualifier_7_title]
           ,[qualifier_8_title])
     VALUES
           (@AppLogTypeLookupTypeGuid
           ,'Cccev App Log Type'
           ,'A list of all application logging types'
           ,''
           ,'IsEnabled'
           ,''
           ,@OrganizationID
           ,0
           ,''
           ,''
           ,''
           ,''
           ,''
           ,'')
END

DECLARE @AppLogTypeLookupID int
SELECT @AppLogTypeLookupID = lookup_type_id FROM core_lookup_type WHERE @AppLogTypeLookupTypeGuid = guid

--------------------------------------------------------------------------
-- Add the Check-in Lookup Application Log Type default to off (false).
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @CheckinAppLogTypeGuid)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@CheckinAppLogTypeGuid, @AppLogTypeLookupID, 'Check-in', 'false', '', '', '', '', '', '', '', 1, 1, 0, NULL)
END

COMMIT
GO