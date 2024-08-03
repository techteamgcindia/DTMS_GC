USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUploadPath]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getUploadPath]
@LinkId nvarchar(MAX)='',
@id nvarchar(MAX)=''
AS
BEGIN
DECLARE @clientname nvarchar(MAX)
DECLARE @Uploadpath nvarchar(MAX)
SET @clientname=(select ClientName from obp_clientmaster where id in(select ClientID from obp_TaskHeader where id=@id))
SET @Uploadpath='~/Upload/'+UPPER(@clientname)+'/'
--select Uploadpath from obps_TopLinks where id=@LinkId
select @Uploadpath
END
GO
