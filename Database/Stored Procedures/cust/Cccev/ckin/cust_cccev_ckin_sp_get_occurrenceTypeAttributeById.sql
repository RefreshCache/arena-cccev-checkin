﻿SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
	
if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_get_occurrenceTypeAttributeById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_get_occurrenceTypeAttributeById]
GO
	
create Proc cust_cccev_ckin_sp_get_occurrenceTypeAttributeByID
@OccurrenceTypeAttributeId int
AS

	SELECT * 
	FROM cust_cccev_ckin_occurrence_type_attribute
	WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId
GO