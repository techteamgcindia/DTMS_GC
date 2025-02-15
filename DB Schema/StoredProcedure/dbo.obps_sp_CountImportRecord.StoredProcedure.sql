USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CountImportRecord]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_CountImportRecord]               
/******Finding the count of success/error out data**********/  
@linkid nvarchar(MAX)='',       
@Username nvarchar(max)       
AS                
BEGIN     
DECLARE @spname nvarchar(MAX)=''  
DECLARE @error_rowcount int, @success_rowcount int,@count int=0  
  
SET @spname=(SELECT ImportErrorOutSp FROM obps_TopLinks where id=@linkid)    
EXEC @spname  @usrname=@Username   
SET @error_rowcount = @@rowcount  
  
SET @spname=(SELECT ImportSavedOutSp FROM obps_TopLinks where id=@linkid)    
EXEC @spname  @usrname=@Username  
SET @success_rowcount = @@rowcount  
  
SET @count=@error_rowcount+@success_rowcount  
if(@count>0)  
 select @count  
END  
GO
