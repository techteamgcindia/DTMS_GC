USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadUploadFile]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_ReadUploadFile]  
@LinkId nvarchar(MAX)='',  
@username nvarchar(MAX)='',  
@id nvarchar(MAX)=''  
AS  
BEGIN  
select id,FileNameDesc from obps_FileUpload where autoid=@id--  and Linkid=@LinkId --and Username=@username  
END  
GO
