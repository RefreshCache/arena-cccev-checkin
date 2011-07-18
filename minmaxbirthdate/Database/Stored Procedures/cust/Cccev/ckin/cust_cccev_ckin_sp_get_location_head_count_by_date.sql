set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_location_head_count_by_date]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_location_head_count_by_date]
GO

CREATE Proc [dbo].[cust_cccev_ckin_sp_get_location_head_count_by_date]
@LocationID int,
@StartDate datetime
AS

	SELECT COUNT(distinct oa.person_id)
	FROM core_occurrence O
	INNER JOIN core_occurrence_attendance OA ON O.occurrence_id = OA.occurrence_id
	WHERE O.location_id = @LocationID
	AND (O.occurrence_start_time <= @StartDate OR check_in_start <= @StartDate)
	AND (O.occurrence_end_time >= @StartDate OR check_in_end >= @StartDate)
	AND OA.attended = 1
	AND OA.check_in_time IS NOT NULL
	AND OA.check_in_time <> '1/1/1900'
	AND OA.check_out_time = '1/1/1900'
