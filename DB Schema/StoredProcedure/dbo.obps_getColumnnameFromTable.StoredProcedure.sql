USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_getColumnnameFromTable]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_getColumnnameFromTable]
@tablename nvarchar(MAX)=''
AS
BEGIN

SELECT column_name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'obp_OFC_Demand' and column_name not in
('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo',
'isActive','isDeleted')

END
GO
