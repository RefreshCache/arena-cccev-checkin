SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
	
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange]
GO

CREATE PROC [cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange]

@SystemID int,
@StartDate datetime,
@EndDate datetime
AS
/**********************************************************************
* Description:	Gets list of occurrences based on computer system id and
				start/end dates.
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	12/18/2008
*
* $Workfile: cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange.sql $
* $Revision: 6 $ 
* $Header: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange.sql   6   2009-02-18 11:06:20-07:00   JasonO $
* 
* $Log: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_occurrencesBySystemIDAndDateRange.sql $
*  
*  Revision: 6   Date: 2009-02-18 18:06:20Z   User: JasonO 
*  
*  Revision: 4   Date: 2009-02-03 21:10:16Z   User: JasonO 
*  refactoring again to account for long classes 
*  
*  Revision: 3   Date: 2009-01-21 15:26:34Z   User: JasonO 
*  refactoring proc 
*  
*  Revision: 2   Date: 2009-01-21 00:12:11Z   User: JasonO 
*  
*  Revision: 1   Date: 2008-12-17 21:46:17Z   User: JasonO 
*  gets valid list of occurrences 
**********************************************************************/


SELECT O.*
FROM [core_occurrence] O
INNER JOIN [core_occurrence_type] OT
	ON OT.occurrence_type_id = O.occurrence_type
INNER JOIN [comp_system_location] SL
	ON SL.location_id = O.location_id
INNER JOIN [orgn_location_occurrence_type] LOT
	ON LOT.occurrence_type_id = O.occurrence_type
		AND LOT.location_id = O.location_id
WHERE SL.system_id = @SystemID
	AND 
	(
		O.check_in_start BETWEEN @StartDate AND @EndDate
		OR O.check_in_end BETWEEN @StartDate AND @EndDate
		OR @StartDate BETWEEN O.check_in_start AND O.check_in_end
	)
ORDER BY O.occurrence_start_time, OT.type_order DESC, LOT.location_order