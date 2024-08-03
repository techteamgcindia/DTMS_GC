USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getIsUpload]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getIsUpload]
@LinkId nvarchar(MAX)=''
AS
BEGIN
DECLARE @IsEnable int=0
SET @IsEnable= (select IsUploadEnabled from obps_TopLinks where id=@LinkId)
select @IsEnable
END
GO
