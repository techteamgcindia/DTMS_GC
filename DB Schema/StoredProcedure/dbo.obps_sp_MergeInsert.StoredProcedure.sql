USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_MergeInsert]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_MergeInsert]           
@var_id int,  
@maintablename nvarchar(MAX)='',  
@linkid nvarchar(MAX)=''  
AS                           
BEGIN    

 DECLARE @InsertSp nvarchar(MAX)=''  
 exec [obps_sp_GenDataValidityCheck_DataType] @var_id,@maintablename,@linkid  
 set @InsertSp=(select ltrim(rtrim(InsertSp)) from obps_ExcelImportConfig where LinkId=@linkid)  

 if len(ltrim(rtrim(@InsertSp)))>1
 begin
  exec @InsertSp  
  end
END 
GO
