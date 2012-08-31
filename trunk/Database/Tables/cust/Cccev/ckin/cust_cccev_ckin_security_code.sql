 /****** Object:  Table [dbo].[ckin_SecurityCode]    Script Date: 12/04/2008 14:08:39 ******/
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