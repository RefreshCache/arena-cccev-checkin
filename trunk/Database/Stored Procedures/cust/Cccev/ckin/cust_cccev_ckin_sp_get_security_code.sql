SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[cust_cccev_ckin_sp_get_security_code]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [cust_cccev_ckin_sp_get_security_code]
GO

CREATE PROCEDURE [dbo].[cust_cccev_ckin_sp_get_security_code]
   @FullCode CHAR(6) OUTPUT
AS


/******************************************************************************
**		File: 
**		Name: ckin_F_SecurityCode_GetNextCode
**		Desc: Assignes and returns the next security code.
**              
**		Return values:
** 
**		Called by:   Arena.Custom.Cccev.CheckIn.DataLayer.SecurityCodeData
**              
**		Parameters:
**		Input							Output
**		----------						-----------
**										SecurityCode CHAR(6)
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------	--------			-------------------------------------------
**		5/2004		Rod					Original version.
**		11/08/2004	Nick Airdo			Fix "returns same number" bug.
*******************************************************************************/

DECLARE @uniqueKey UNIQUEIDENTIFIER
SET @uniqueKey = NEWID()

DECLARE @dt DATETIME
SET @dt = GETDATE()

UPDATE [cust_cccev_ckin_security_code]
   SET
	[assigned_date] = @dt,
	[unique_key] = @uniqueKey
WHERE
   [unique_key] IS NULL
   AND [security_code] IN (SELECT MIN([security_code]) FROM [cust_cccev_ckin_security_code] WHERE [unique_key] IS NULL)

DECLARE @newCode INT

SELECT @newCode = [security_code]
FROM [cust_cccev_ckin_security_code]
WHERE [unique_key] = @uniqueKey

DECLARE @Seed INT

SET @Seed = DATEPART(ms, GETDATE())

SELECT @FullCode = CHAR(65 + CAST((RAND() * @Seed) AS INT) % 26) + CHAR(65 + CAST((RAND() * @Seed) AS INT) % 26) + RIGHT('0000' + CONVERT(VARCHAR(4), @newCode), 4)

PRINT @FullCode