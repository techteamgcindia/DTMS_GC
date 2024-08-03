USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUserTypes]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getUserTypes]  
@id nvarchar(MAX)=''  
AS  
BEGIN  
 if @id<>''  
  select id,UserType,UserTypeDesc from obps_UserType where id=@id   
 else  
  select id,Usertypeid,UserType,UserTypeDesc from obps_UserType where UserType!='admin'  
END  


GO
