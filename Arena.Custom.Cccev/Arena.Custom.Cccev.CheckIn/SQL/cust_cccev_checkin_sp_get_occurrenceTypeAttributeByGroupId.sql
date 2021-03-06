SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
	
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_checkin_sp_get_occurrenceByCategoryAndDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_checkin_sp_get_occurrenceByCategoryAndDate]
GO
	
create Proc cust_cccev_checkin_sp_get_occurrenceByCategoryAndDate
@GroupId int,
@StartDate datetime,
@EndDate datetime
AS

/**********************************************************************
* Description: Procedure to find occurrences based on
*              a group id (category) and start/end date.
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created:	09/03/2008 10:25:00
*
* $Workfile: cust_cccev_checkin_sp_get_occurrenceTypeAttributeByGroupId.sql $
* $Revision: 1 $ 
* $Header: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/SQL/cust_cccev_checkin_sp_get_occurrenceTypeAttributeByGroupId.sql   1   2008-11-12 14:53:34-07:00   nicka $
* 
* $Log: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/SQL/cust_cccev_checkin_sp_get_occurrenceTypeAttributeByGroupId.sql $
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
		O.occurrence_start_time >= @StartDate
		AND O.occurrence_start_time <= @EndDate
	)
	OR
	(
		o.
	)
	ORDER BY occurrence_start_time,
	OT.type_name,
	L.location_name


GO