/**********************************************************************
* Description:	Nick Airdo
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created:	11/17/2008 11:46:29
*
* $Workfile: cust_cccev_checkin_tables.sql $
* $Revision: 6 $ 
* $Header: /trunk/Database/Tables/cust/Cccev/ckin/cust_cccev_checkin_tables.sql   6   2009-10-14 16:35:36-07:00   nicka $
* 
* $Log: /trunk/Database/Tables/cust/Cccev/ckin/cust_cccev_checkin_tables.sql $
*  
*  Revision: 6   Date: 2009-10-14 23:35:36Z   User: nicka 
*  added cust_cccev_applog table and corresponding lookup data (for upgrade 
*  script) 
*  
*  Revision: 5   Date: 2009-10-14 21:16:09Z   User: nicka 
*  removed columns min_age_months, max_age_months, min_grade, max_grade from 
*  from cust_cccev_ckin_occurrence_type_attribute table and added 
*  is_room_balancing 
*  
*  Revision: 4   Date: 2009-02-17 00:39:10Z   User: nicka 
*  removed ability_level_luid column 
*  
*  Revision: 3   Date: 2009-02-04 15:55:24Z   User: nicka 
*  added cascade delete for occurence_type_id FK reference 
***********************************************************************/

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
	[is_room_balancing] [bit] NOT NULL,
	[date_created] [datetime] NOT NULL CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_date_created]  DEFAULT (getdate()),
	[date_modified] [datetime] NOT NULL CONSTRAINT [DF_cust_cccev_ckin_occurrence_type_attribute_date_modified]  DEFAULT (getdate()),
	[created_by] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[modified_by] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cust_cccev_ckin_occurrence_type_attribute] PRIMARY KEY CLUSTERED 
(
	[occurrence_type_attribute_id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'this field needs a cascade on delete' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cust_cccev_ckin_occurrence_type_attribute', @level2type=N'COLUMN', @level2name=N'occurrence_type_id'

GO

ALTER TABLE [cust_cccev_ckin_occurrence_type_attribute]  WITH CHECK
ADD  CONSTRAINT [FK_cust_cccev_ckin_occurrence_type_attribute_core_occurrence_type]
FOREIGN KEY([occurrence_type_id]) REFERENCES [core_occurrence_type] ([occurrence_type_id]) ON DELETE CASCADE 


/****** Object:  Table [dbo].[cust_cccev_applog]    Script Date: 10/14/2009 15:35:37 ******/

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