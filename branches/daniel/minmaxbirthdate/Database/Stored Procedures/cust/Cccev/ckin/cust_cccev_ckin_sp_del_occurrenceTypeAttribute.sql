SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[cust_cccev_ckin_sp_del_occurrenceTypeAttribute]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [cust_cccev_ckin_sp_del_occurrenceTypeAttribute]
GO
	
create Proc cust_cccev_ckin_sp_del_occurrenceTypeAttribute
@OccurrenceTypeAttributeId int
AS

	DELETE cust_cccev_ckin_occurrence_type_attribute
	WHERE [occurrence_type_attribute_id] = @OccurrenceTypeAttributeId
GO