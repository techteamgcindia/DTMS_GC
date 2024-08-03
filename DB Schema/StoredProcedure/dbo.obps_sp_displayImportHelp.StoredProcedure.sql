USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_displayImportHelp]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_displayImportHelp]
@linkId nvarchar(MAX)=''
AS
BEGIN
DECLARE @spname nvarchar(MAX)
SET @spname=(select ImportHelp from obps_TopLinks where id=@linkId)
if @spname is not null or @spname<>''
exec @spname
END
GO
