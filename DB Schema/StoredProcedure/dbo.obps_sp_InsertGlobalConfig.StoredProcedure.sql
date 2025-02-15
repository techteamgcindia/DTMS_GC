USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertGlobalConfig]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertGlobalConfig]  
@logo int,
@helpfilepath nvarchar(MAX)=''
AS  
BEGIN  
begin try  
 DECLARE @count int=0;  
 SET @count=(select count(*) from obps_GlobalConfig where Variables='logorequired')  
 if @count=0  
  insert into obps_GlobalConfig(Variables,Value)  
  values('LogoRequired',@logo)  
 else  
  update obps_GlobalConfig set Value=@logo where Variables='logorequired'  

  SET @count=(select count(*) from obps_GlobalConfig where Variables='helpfilepath')  
 if @count=0  
  insert into obps_GlobalConfig(Variables,Value)  
  values('helpfilepath',@helpfilepath)  
 else  
  update obps_GlobalConfig set Value=@helpfilepath where Variables='helpfilepath'  

end try  
begin catch  
 select ERROR_MESSAGE()  
end catch  
  
END
GO
