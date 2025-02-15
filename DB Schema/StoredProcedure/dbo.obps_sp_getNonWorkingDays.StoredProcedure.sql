USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getNonWorkingDays]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getNonWorkingDays] 
@ClientId nvarchar(MAX)='', 
@username nvarchar(MAX)='', 
@year nvarchar(MAX)='', 
@month nvarchar(MAX)='' 
AS BEGIN  
DECLARE @SearchLetter nvarchar(MAX)=''  
SET @SearchLetter ='%'+ @username + '%'   

if(@ClientId=null or @ClientId='')  
begin   
	select DAY(NonWorkingDays),FORMAT(NonWorkingDays,'MM/dd/yyyy') from obps_NonWorkingDays where ClientId=   ( select top 1 id from obp_ClientMaster where AccessToUser like  @SearchLetter      
	 order by id asc)   --(select top 1 ID from obp_ClientMaster where AccessToUser like  @SearchLetter)    and year(NonWorkingDays)=@year and month(NonWorkingDays)=@month  
 end  
 else  
 begin   
	 select DAY(NonWorkingDays),FORMAT(NonWorkingDays,'MM/dd/yyyy') from
	 obps_NonWorkingDays where ClientId=@ClientId   and year(NonWorkingDays)=@year and month(NonWorkingDays)=@month  
 end 
 END
GO
