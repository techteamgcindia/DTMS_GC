USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadGlobalData]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadGlobalData]  
AS  
BEGIN  
DECLARE @count int=0,@logo int=0,@hepfilepath nvarchar(MAX)='';  
 SET @count=(select count(*) from obps_GlobalConfig where Variables='logorequired')  
 if @count=0  
 BEGIN  
  insert into obps_GlobalConfig(Variables,Value)  
  values('LogoRequired',0)  
 END  
 set @logo=(select Value from obps_GlobalConfig where Variables='logorequired')

 if((select count(Value) from obps_GlobalConfig where Variables='helpfilepath')>0)
	SET @hepfilepath=(select Value from obps_GlobalConfig where Variables='helpfilepath')
 else
	SET @hepfilepath=''

 select @logo,@hepfilepath
  
END

GO
