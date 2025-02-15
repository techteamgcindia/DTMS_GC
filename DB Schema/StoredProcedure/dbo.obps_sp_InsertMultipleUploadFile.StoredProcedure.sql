USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertMultipleUploadFile]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertMultipleUploadFile]  
@LinkId nvarchar(MAX)='',  
@username nvarchar(MAX)='',  
@filename nvarchar(MAX)='',  
@size float='',  
@createdtime nvarchar(MAX)='',  
@ext nvarchar(MAX)='',  
@filePath nvarchar(MAX)='',  
@batchid int=''  
AS  
BEGIN  
DECLARE @dt date='' ,@dtnew datetime=''   
DECLARE @count int=0  
set @dt=CONVERT(VARCHAR(10), getdate(), 111)  
set @dtnew=(SELECT CONVERT(VARCHAR(24), CONVERT(DATETIME, @createdtime, 103), 121) Date)
SET @size=(select convert(decimal(10, 2), @size))

INSERT INTO obps_FileUploadedHistory(UserName,FileName,Size,CreatedDate,Type,FilePath,LinkId,UploadedDate,batchid)   
values(@username,@filename,@size,@dtnew,@ext,@filePath,@LinkId,@dt,@batchid) 
  
END  
GO
