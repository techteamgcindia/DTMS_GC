USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteFile]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DeleteFile]
@Id nvarchar(MAX)='',
@LinkId nvarchar(MAX)=''
AS 
BEGIN
	DECLARE @Count int=0
	SET @Count=(SELECT count(*) from obps_FileUpload where id=@Id)
	if @Count>0
	BEGIN
		DELETE from obps_FileUpload where id=@Id
		SELECT'1'
	END
	ELSE
		SELECT '0'
END
GO
