SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[cust_cccev_ckin_sp_insert_security_code_addNumbers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [cust_cccev_ckin_sp_insert_security_code_addNumbers]
GO

/****** Object:  Stored Procedure dbo.ckin_I_SecurityCode_AddNumbers    Script Date: 8/17/2004 2:13:12 PM ******/

CREATE PROCEDURE [dbo].[cust_cccev_ckin_sp_insert_security_code_addNumbers]
   @startVal INT,
   @endVal INT
AS

SET NOCOUNT ON

WHILE @startVal <= @endVal
BEGIN
   IF (@startVal != 666 AND @startVal != 911 ) 
   BEGIN
      IF NOT EXISTS (SELECT * FROM [cust_cccev_ckin_security_code] WHERE [security_code] = @startVal)
         INSERT [cust_cccev_ckin_security_code] ([security_code]) VALUES (@startVal)
   END
   SET @startVal = @startVal + 1
END