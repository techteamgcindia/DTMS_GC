USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteGridDataDetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DeleteGridDataDetails]  
   @gid NVARCHAR(MAX)=NULL,  
   @key nvarchar(50)=NULL,  
   @Id NVARCHAR(MAX)=NULL,  
   @usr nvarchar(MAX)=''  
AS  
BEGIN  
  
   DECLARE  @delsp NVARCHAR(MAX)
  
    SET NOCOUNT ON;  
	set @delsp=(SELECT deletesp from obps_TopLinkExtended where Linkid=@id and GridId=@gid)

  
 IF len(rtrim(ltrim(@delsp)))>1  
 BEGIN  
 EXEC @delsp @key,@usr	-------table id and username
 END  
   
END
GO
