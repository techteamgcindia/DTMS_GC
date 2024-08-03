USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDataTypes]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getDataTypes]
@id nvarchar(MAX)=''
AS
BEGIN
	if @id<>''
		select id,DataType from [dbo].[obps_TableDataTypes] where id=@id
	else
		select id,DataType from [dbo].[obps_TableDataTypes]
END
GO
