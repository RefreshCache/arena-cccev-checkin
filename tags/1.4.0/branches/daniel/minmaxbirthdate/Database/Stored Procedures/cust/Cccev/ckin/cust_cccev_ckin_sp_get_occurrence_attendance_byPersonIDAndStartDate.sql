SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
	
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate]
GO 

CREATE PROC cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate

/**********************************************************************
* Description:	TBD
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	TBD
*
* $Workfile: cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate.sql $
* $Revision: 8 $ 
* $Header: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate.sql   8   2009-02-18 13:09:07-07:00   JasonO $
* 
* $Log: /trunk/Database/Stored Procedures/cust/Cccev/ckin/cust_cccev_ckin_sp_get_occurrence_attendance_byPersonIDAndStartDate.sql $
*  
*  Revision: 8   Date: 2009-02-18 20:09:07Z   User: JasonO 
*  
*  Revision: 6   Date: 2009-02-18 18:11:04Z   User: JasonO 
*  
*  Revision: 4   Date: 2009-01-27 16:02:29Z   User: JasonO 
**********************************************************************/

@StartDate datetime,
@PersonID int

AS

SELECT TOP 1 *
FROM [core_occurrence_attendance] OA
INNER JOIN [core_occurrence] O
	ON O.occurrence_id = OA.occurrence_id
WHERE O.occurrence_start_time = @StartDate
	AND OA.person_id = @PersonID
ORDER BY OA.check_in_time DESC