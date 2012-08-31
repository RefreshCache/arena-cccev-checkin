SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[cust_hdc_funct_calc_age](@birthdate DATETIME, @mcutoff INT, @ycutoff INT)
RETURNS VARCHAR(10)
AS
BEGIN

DECLARE @years INT, @months INT, @decades INT

IF @birthdate > GETDATE()
    SET @months = 0
ELSE
    SET @months = (DATEDIFF(month,@birthdate,GETDATE()) - CASE WHEN DAY(GETDATE()) < DAY(@birthdate) THEN 1 ELSE 0 END)

SET @years = @months / 12
SET @decades = ROUND(@years/10,0)*10

RETURN CASE
    WHEN @years < @mcutoff THEN CAST(@months % (@mcutoff * 12) AS VARCHAR) + CASE WHEN @months = 1 THEN ' month' ELSE ' months' END
    WHEN @years < @ycutoff THEN CAST(@years AS VARCHAR) + CASE WHEN @years = 1 THEN ' year' ELSE ' years' END
    WHEN @years < 100 THEN CAST(@decades AS VARCHAR) + '''s'
    ELSE ''
	END
END


GO


