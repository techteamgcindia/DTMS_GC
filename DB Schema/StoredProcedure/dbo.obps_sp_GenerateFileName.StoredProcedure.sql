USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GenerateFileName]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GenerateFileName]
@id nvarchar(MAX)='',
@LinkId nvarchar(MAX)=''
AS
BEGIN

DECLARE @count nvarchar(MAX)=''
DECLARE @clientname nvarchar(MAX)=''
DECLARE @filename nvarchar(MAX)=''

SET @clientname=(select ClientName from obp_clientmaster where id in(select ClientID from obp_TaskHeader where id=@id))
set @count=(SELECT count(*) from obps_FileUpload where autoid=@id and Linkid=@LinkId)
SET @filename=@clientname+'_'+@id+'_'+@count
SELECT @filename

END
GO
