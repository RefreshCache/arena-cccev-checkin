SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[cust_cccev_ckin_sp_update_security_code_clearAssignDate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [cust_cccev_ckin_sp_update_security_code_clearAssignDate]
GO

CREATE Procedure [dbo].[cust_cccev_ckin_sp_update_security_code_clearAssignDate]
	/* Param List */
AS

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


/******************************************************************************
**		File: 
**		Name: ckin_U_SecurityCode_ClearAssignDate
**		Desc: Clears the SecurityCode table leaving only the Security Code value.
**              
**		Return values: None.
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**      11/08/2004	Nick Airdo		Support new UniqueKey column
*******************************************************************************/

UPDATE [cust_cccev_ckin_security_code]
   SET
	[assigned_date] = NULL,
	[unique_key] = NULL