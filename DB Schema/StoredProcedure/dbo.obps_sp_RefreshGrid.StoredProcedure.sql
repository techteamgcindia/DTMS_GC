USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_RefreshGrid]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_RefreshGrid]  
   @Gridname NVARCHAR(MAX)=NULL,  
   @Linkid NVARCHAR(MAX)=NULL,  
   @usr nvarchar(MAX)=''  
AS  
BEGIN  
  
    DECLARE @refreshspname NVARCHAR(MAX), 
    @spnamequery NVARCHAR(MAX)
  
    SET NOCOUNT ON;  

	SET @spnamequery=('(SELECT @refreshspname='+@Gridname+' FROM Obps_TopLinks where '+@Gridname+'  is not null and Id='''+@Linkid+''')')  
	EXEC Sp_executesql  @spnamequery,  N'@refreshspname NVARCHAR(MAX) output', @refreshspname output  
  
	IF len(rtrim(ltrim(@refreshspname)))>0 
	BEGIN  
		EXEC @refreshspname @usr
	END  
   
END
GO
