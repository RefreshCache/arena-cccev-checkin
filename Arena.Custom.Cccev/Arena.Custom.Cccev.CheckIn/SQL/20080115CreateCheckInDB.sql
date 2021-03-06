SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[log_Batch]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[log_Batch](
	[BatchID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](500) NULL,
	[Status] [char](1) NULL,
	[StartDateTime] [datetime] NOT NULL,
	[EndDateTime] [datetime] NULL,
	[Duration] [int] NULL,
	[Output] [varchar](8000) NULL,
 CONSTRAINT [PK_log_Batch] PRIMARY KEY CLUSTERED 
(
	[BatchID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'in seconds' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'log_Batch', @level2type=N'COLUMN', @level2name=N'Duration'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[lu_AbilityLevel]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[lu_AbilityLevel](
	[AbilityLevelID] [int] NOT NULL,
	[DisplayText] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_lu_AbilityLevel] PRIMARY KEY CLUSTERED 
(
	[AbilityLevelID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[lu_AgeGroup]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[lu_AgeGroup](
	[AgeGroupID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayText] [varchar](50) NULL,
	[AgeGroupDescription] [varchar](100) NULL,
	[MinAgeMonths] [int] NULL,
	[MaxAgeMonths] [int] NULL,
	[SchoolGradeNumber] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_lu_AgeGroup_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_lu_AgeGroup] PRIMARY KEY CLUSTERED 
(
	[AgeGroupID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[lu_Ministry]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[lu_Ministry](
	[MinistryID] [int] IDENTITY(1,1) NOT NULL,
	[ParentMinistryID] [int] NULL,
	[DisplayText] [varchar](50) NULL,
	[MinistryDescription] [varchar](100) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_lu_Ministry_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_lu_Ministry] PRIMARY KEY CLUSTERED 
(
	[MinistryID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[lu_RelationshipType]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[lu_RelationshipType](
	[RelationshipTypeID] [int] NOT NULL,
	[DisplayText] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_lu_RelationshipType] PRIMARY KEY CLUSTERED 
(
	[RelationshipTypeID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[com_Location]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[com_Location](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[CampusCode] [char](1) NOT NULL,
	[BuildingName] [varchar](50) NULL,
	[RoomNumber] [varchar](15) NULL,
	[FireCodeCapacity] [int] NULL,
	[PrinterName] [varchar](50) NULL,
	[PrinterAddress] [varchar](80) NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_com_Location_CreatedDate]  DEFAULT (getdate()),
	[LastUpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_com_Location_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_com_Location] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'(N)orth or (S)outh' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'com_Location', @level2type=N'COLUMN', @level2name=N'CampusCode'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ckin_AttendanceHistory]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ckin_AttendanceHistory](
	[AttendanceHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[PersonName] [varchar](100) NULL,
	[EventLocationID] [int] NULL,
	[EventName] [varchar](50) NULL,
	[EventLocation] [varchar](50) NULL,
	[CheckInDateTime] [datetime] NOT NULL,
	[SecurityCode] [char](8) NULL,
 CONSTRAINT [PK_ckin_AttendanceHistory] PRIMARY KEY CLUSTERED 
(
	[AttendanceHistoryID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ckin_SecurityCode]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ckin_SecurityCode](
	[SecurityCode] [int] NOT NULL,
	[AssignedDateTime] [datetime] NULL,
	[UniqueKey] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ckin_SecurityCode] PRIMARY KEY CLUSTERED 
(
	[SecurityCode] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[ckin_SecurityCode]') AND name = N'IX_ckin_SecurityCode')
CREATE NONCLUSTERED INDEX [IX_ckin_SecurityCode] ON [dbo].[ckin_SecurityCode] 
(
	[SecurityCode] ASC,
	[UniqueKey] ASC
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ckin_VolunteerHistory]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ckin_VolunteerHistory](
	[VolunteerHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[PersonName] [varchar](100) NULL,
	[EventDate] [datetime] NOT NULL,
	[Service] [varchar](10) NULL,
	[Location] [varchar](25) NULL,
	[Notes] [varchar](150) NULL,
 CONSTRAINT [PK_ckin_VolunteerHistory] PRIMARY KEY CLUSTERED 
(
	[VolunteerHistoryID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Helped' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ckin_VolunteerHistory', @level2type=N'COLUMN', @level2name=N'PersonID'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Helped' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ckin_VolunteerHistory', @level2type=N'COLUMN', @level2name=N'PersonName'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Helped' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ckin_VolunteerHistory', @level2type=N'COLUMN', @level2name=N'EventDate'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'Which Service Helped During' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ckin_VolunteerHistory', @level2type=N'COLUMN', @level2name=N'Service'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'Which Room' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ckin_VolunteerHistory', @level2type=N'COLUMN', @level2name=N'Location'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'any notes' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ckin_VolunteerHistory', @level2type=N'COLUMN', @level2name=N'Notes'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ckin_EventAbilityLevel]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ckin_EventAbilityLevel](
	[EventAbilityLevelID] [int] IDENTITY(1,1) NOT NULL,
	[EventID] [int] NOT NULL,
	[AbilityLevelID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ckin_EventAbilityLevel] PRIMARY KEY CLUSTERED 
(
	[EventAbilityLevelID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ckin_EventAgeGroup]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ckin_EventAgeGroup](
	[EventAgeGroupID] [int] IDENTITY(1,1) NOT NULL,
	[EventID] [int] NOT NULL,
	[AgeGroupID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ckin_EventAgeGroup] PRIMARY KEY CLUSTERED 
(
	[EventAgeGroupID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[com_Event]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[com_Event](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[MinistryID] [int] NOT NULL,
	[DisplayText] [varchar](50) NULL,
	[EventDetailDescription] [varchar](100) NULL,
	[DayOfWeekNumber] [int] NULL,
	[MeetingTime] [datetime] NULL,
	[StaffToEnrollmentNumerator] [int] NULL,
	[StaffToEnrollmentDenominator] [int] NULL,
	[MaxClassSize] [int] NULL,
	[IsSpecialNeeds] [bit] NULL CONSTRAINT [DF_com_Event_IsSpecialNeeds]  DEFAULT (0),
	[GenderCode] [char](1) NULL,
	[StartRangeLetter] [char](1) NULL,
	[EndRangeLetter] [char](1) NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_com_Event_IsDeleted]  DEFAULT (0),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_com_Event_CreatedDate]  DEFAULT (getdate()),
	[LastUpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_com_Event_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_com_Event] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'A brief, displayable name for this event.' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'com_Event', @level2type=N'COLUMN', @level2name=N'DisplayText'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'A longer description of this event for print purposes.' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'com_Event', @level2type=N'COLUMN', @level2name=N'EventDetailDescription'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'For the event''s staff:child ratio' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'com_Event', @level2type=N'COLUMN', @level2name=N'StaffToEnrollmentNumerator'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'For the event''s staff:child ratio' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'com_Event', @level2type=N'COLUMN', @level2name=N'StaffToEnrollmentDenominator'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'(M)ale, (F)emale or NULL for both' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'com_Event', @level2type=N'COLUMN', @level2name=N'GenderCode'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'Starting letter for a designated range.' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'com_Event', @level2type=N'COLUMN', @level2name=N'StartRangeLetter'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'Ending letter for a designated range.' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'com_Event', @level2type=N'COLUMN', @level2name=N'EndRangeLetter'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ckin_EventLocation]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ckin_EventLocation](
	[EventLocationID] [int] IDENTITY(1,1) NOT NULL,
	[EventID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[NextEventLocationID] [int] NULL,
	[IsPrinterUsed] [bit] NOT NULL,
	[IsStickerUsed] [bit] NOT NULL,
	[IsClaimCardUsed] [bit] NOT NULL,
	[TeacherCount] [int] NOT NULL,
	[EventLocationStatus] [varchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ckin_EventLocation_CreatedDate]  DEFAULT (getdate()),
	[LastUpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ckin_EventLocation_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ckin_EventLocation] PRIMARY KEY CLUSTERED 
(
	[EventLocationID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Description', @value=N'the EventLocationID which is replacing this one (due to administrative closure, etc).' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ckin_EventLocation', @level2type=N'COLUMN', @level2name=N'NextEventLocationID'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ckin_Enrollment]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ckin_Enrollment](
	[EnrollmentID] [int] IDENTITY(1,1) NOT NULL,
	[EventLocationID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[LastAttendDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ckin_Enrollment_CreatedDate]  DEFAULT (getdate()),
	[LastUpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ckin_Enrollment_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ckin_Enrollment] PRIMARY KEY CLUSTERED 
(
	[EnrollmentID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ckin_Attendance]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ckin_Attendance](
	[AttendanceID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[EventLocationID] [int] NOT NULL,
	[CheckInDateTime] [datetime] NOT NULL CONSTRAINT [DF_ckin_Attendance_CheckInDateTime]  DEFAULT (getdate()),
	[SecurityCode] [char](8) NULL,
	[IsLabelPrintSuccess] [bit] NULL CONSTRAINT [DF_ckin_Attendance_IsLabelPrintSuccess]  DEFAULT (1),
 CONSTRAINT [PK_ckin_Attendance] PRIMARY KEY CLUSTERED 
(
	[AttendanceID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_lu_Ministry_lu_Ministry]') AND type = 'F')
ALTER TABLE [dbo].[lu_Ministry]  WITH CHECK ADD  CONSTRAINT [FK_lu_Ministry_lu_Ministry] FOREIGN KEY([ParentMinistryID])
REFERENCES [dbo].[lu_Ministry] ([MinistryID])
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_EventAbilityLevel_com_Event]') AND type = 'F')
ALTER TABLE [dbo].[ckin_EventAbilityLevel]  WITH CHECK ADD  CONSTRAINT [FK_ckin_EventAbilityLevel_com_Event] FOREIGN KEY([EventID])
REFERENCES [dbo].[com_Event] ([EventID])
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_EventAbilityLevel_lu_AbilityLevel]') AND type = 'F')
ALTER TABLE [dbo].[ckin_EventAbilityLevel]  WITH CHECK ADD  CONSTRAINT [FK_ckin_EventAbilityLevel_lu_AbilityLevel] FOREIGN KEY([AbilityLevelID])
REFERENCES [dbo].[lu_AbilityLevel] ([AbilityLevelID])
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_EventAgeGroup_com_Event]') AND type = 'F')
ALTER TABLE [dbo].[ckin_EventAgeGroup]  WITH CHECK ADD  CONSTRAINT [FK_ckin_EventAgeGroup_com_Event] FOREIGN KEY([EventID])
REFERENCES [dbo].[com_Event] ([EventID])
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_EventAgeGroup_lu_AgeGroup]') AND type = 'F')
ALTER TABLE [dbo].[ckin_EventAgeGroup]  WITH CHECK ADD  CONSTRAINT [FK_ckin_EventAgeGroup_lu_AgeGroup] FOREIGN KEY([AgeGroupID])
REFERENCES [dbo].[lu_AgeGroup] ([AgeGroupID])
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_com_Event_lu_Ministry]') AND type = 'F')
ALTER TABLE [dbo].[com_Event]  WITH CHECK ADD  CONSTRAINT [FK_com_Event_lu_Ministry] FOREIGN KEY([MinistryID])
REFERENCES [dbo].[lu_Ministry] ([MinistryID])
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_EventLocation_com_Event]') AND type = 'F')
ALTER TABLE [dbo].[ckin_EventLocation]  WITH CHECK ADD  CONSTRAINT [FK_ckin_EventLocation_com_Event] FOREIGN KEY([EventID])
REFERENCES [dbo].[com_Event] ([EventID])
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_EventLocation_com_Location]') AND type = 'F')
ALTER TABLE [dbo].[ckin_EventLocation]  WITH NOCHECK ADD  CONSTRAINT [FK_ckin_EventLocation_com_Location] FOREIGN KEY([LocationID])
REFERENCES [dbo].[com_Location] ([LocationID])
GO
ALTER TABLE [dbo].[ckin_EventLocation] CHECK CONSTRAINT [FK_ckin_EventLocation_com_Location]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_Enrollment_ckin_EventLocation]') AND type = 'F')
ALTER TABLE [dbo].[ckin_Enrollment]  WITH CHECK ADD  CONSTRAINT [FK_ckin_Enrollment_ckin_EventLocation] FOREIGN KEY([EventLocationID])
REFERENCES [dbo].[ckin_EventLocation] ([EventLocationID])
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_Enrollment_com_Person]') AND type = 'F')
ALTER TABLE [dbo].[ckin_Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_ckin_Enrollment_com_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[com_Person] ([PersonID])
GO
ALTER TABLE [dbo].[ckin_Enrollment] CHECK CONSTRAINT [FK_ckin_Enrollment_com_Person]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_Attendance_ckin_EventLocation]') AND type = 'F')
ALTER TABLE [dbo].[ckin_Attendance]  WITH NOCHECK ADD  CONSTRAINT [FK_ckin_Attendance_ckin_EventLocation] FOREIGN KEY([EventLocationID])
REFERENCES [dbo].[ckin_EventLocation] ([EventLocationID])
GO
ALTER TABLE [dbo].[ckin_Attendance] CHECK CONSTRAINT [FK_ckin_Attendance_ckin_EventLocation]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ckin_Attendance_com_Person]') AND type = 'F')
ALTER TABLE [dbo].[ckin_Attendance]  WITH NOCHECK ADD  CONSTRAINT [FK_ckin_Attendance_com_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[com_Person] ([PersonID])
GO
ALTER TABLE [dbo].[ckin_Attendance] CHECK CONSTRAINT [FK_ckin_Attendance_com_Person]
