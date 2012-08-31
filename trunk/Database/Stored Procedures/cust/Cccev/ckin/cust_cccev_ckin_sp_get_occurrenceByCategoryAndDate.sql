SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
	
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate]
GO
	
create Proc cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate
@GroupId int,
@StartDate datetime,
@EndDate datetime,
@CampusID int
AS

/**********************************************************************
* Description: Procedure to find occurrences based on
*              a group id (category) and start/end date.
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created:	09/03/2008 10:25:00
*
* $Workfile: cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate.sql $
* $Revision: 3 $ 
* $Header: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate.sql   3   2009-02-18 11:11:04-07:00   JasonO $
* 
* $Log: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_occurrenceByCategoryAndDate.sql $
*  
*  Revision: 3   Date: 2009-02-18 18:11:04Z   User: JasonO 
*  
*  Revision: 1   Date: 2009-01-27 00:57:37Z   User: JasonO 
*  
*  Revision: 2   Date: 2008-11-20 23:08:40Z   User: JasonO 
*  Adding logic to search constrain query to campus, filtering out closed 
*  events, and refactoring start/end time logic. 
*  
*  Revision: 1   Date: 2008-11-17 18:43:48Z   User: JasonO 
*  Adding SQL scripts for proc creation. 
*  
*  Revision: 1   Date: 2008-11-12 21:53:34Z   User: nicka 
**********************************************************************/

SET NOCOUNT ON

	SELECT O.* 
	FROM core_occurrence O
	INNER JOIN core_occurrence_type OT ON O.occurrence_type = OT.occurrence_type_id
	LEFT OUTER JOIN orgn_location L ON O.location_id = L.location_id
	WHERE OT.group_id = @GroupId
	AND
	(
		O.check_in_start BETWEEN @StartDate AND @EndDate
		OR O.check_in_end BETWEEN @StartDate AND @EndDate
	)
	AND (campus_luid = @CampusID OR @CampusID = -1)
	AND occurrence_closed <> 1
	ORDER BY occurrence_start_time,
	OT.type_name,
	L.location_name


GO  