/*
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cust_cccev_batch_log]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[cust_cccev_batch_log](
	[batch_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](500) NULL,
	[status] [char](1) NULL,
	[start_date] [datetime] NOT NULL,
    [end_date] [datetime] NULL,
	[duration] [int] NULL,
	[output] [varchar](8000) NULL
	)
END
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'in seconds' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cust_cccev_batch_log', @level2type=N'COLUMN', @level2name=N'duration'
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cust_cccev_ckin_agegroup]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[cust_cccev_ckin_agegroup](
	[agegroup_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[description] [varchar](100) NULL,
	[min_age_months] [int] NULL,
	[max_age_months] [int] NULL,
	[school_grade_number] [int] NULL,
	[is_deleted] [bit] NOT NULL,
	[date_created] [datetime] NOT NULL DEFAULT (getdate())
)
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cust_cccev_ckin_location]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[cust_cccev_ckin_location](
	[location_id] [int] IDENTITY(1,1) NOT NULL,
	[campus_id] [char](1) NOT NULL,
	[building_name] [varchar](50) NULL,
	[room_number] [varchar](15) NULL,
	[printer_name] [varchar](50) NULL,
	[printer_address] [varchar](80) NULL,
	[date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[date_modified] [datetime] NOT NULL DEFAULT (getdate())
)
END
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'(N)orth or (S)outh' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cust_cccev_ckin_location', @level2type=N'COLUMN', @level2name=N'CampusCode'
