
/****** Object:  StoredProcedure [dbo].[cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId]    Script Date: 11/17/2008 11:53:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId]
GO

create Proc [dbo].[cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId]
@GroupId int
AS

/**********************************************************************
* Description: Procedure to find occurrence type attributes based on
*              a group id (occurrence category)
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created:	02/19/2008 10:25:00
*
* $Workfile: cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId.sql $
* $Revision: 5 $ 
* $Header: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId.sql   5   2009-02-18 11:06:20-07:00   JasonO $
* 
* $Log: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_occurrenceTypeAttributeByGroupId.sql $
*  
*  Revision: 5   Date: 2009-02-18 18:06:20Z   User: JasonO 
*  
*  Revision: 3   Date: 2009-01-19 03:09:29Z   User: nicka 
*  Order by the Attendance Type's order 
*  
*  Revision: 2   Date: 2008-11-17 18:54:53Z   User: nicka 
*  draft 
**********************************************************************/

SET NOCOUNT ON

	SELECT ota.* 
	FROM cust_cccev_ckin_occurrence_type_attribute ota
	INNER JOIN core_occurrence_type ot ON ot.occurrence_type_id = ota.occurrence_type_id
	WHERE ot.group_id = @GroupId
	ORDER BY ot.type_order ASC