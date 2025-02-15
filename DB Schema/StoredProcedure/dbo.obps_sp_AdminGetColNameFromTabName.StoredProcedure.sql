USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AdminGetColNameFromTabName]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_AdminGetColNameFromTabName]
@tabname nvarchar(MAX)=''
AS
BEGIN

SELECT name FROM sys.columns WHERE object_id = OBJECT_ID(@tabname) 
and name not in('id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate'
,'Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser') order by name asc

END

GO
