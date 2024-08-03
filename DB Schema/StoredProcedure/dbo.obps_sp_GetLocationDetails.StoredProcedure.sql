USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetLocationDetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetLocationDetails] 
@linkId nvarchar(2)=''  
AS  
BEGIN
DECLARE @IsLocation nvarchar(2) =0
SET @IsLocation=(select IsLocation from obps_TopLinks where id=@linkId)
if @IsLocation is null  
	set @IsLocation=0;  

select @IsLocation

END
GO
