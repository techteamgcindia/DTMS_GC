USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getIsGridDDL]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getIsGridDDL]  
@LinkId nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @IsDdlSp nvarchar(MAX)  
  
SET @IsDdlSp= (select DdlSp from obps_TopLinks where id=@LinkId)  
  
if(ltrim(rtrim(len(@IsDdlSp)))>0)  
 select '1'  
else  
 select '0'  
END  
GO
