USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GenerateFile]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GenerateFile]
@Id nvarchar(MAX)='',
@usr nvarchar(MAX)=''
AS
BEGIN

DECLARE @spname nvarchar(MAX)=''
SET @spname=(select GenFileSp from obps_ExcelImportConfig where LinkId=@Id)

if @spname<>'' or @spname is not null
	exec @spname @Id,@usr

END
GO
