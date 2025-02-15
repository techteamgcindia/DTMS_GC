USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AddRoleid]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_AddRoleid]
@desc nvarchar(MAX)=''
AS
BEGIN

DECLARE @roleid int,@count int

SET @count=(select count(*) from obps_rolemaster where roleid!='' or roleid is not null)

IF(@count>0)
	SET @roleid=(select MAX(roleid)from obps_rolemaster)+1
ELSE
	SET @roleid=1

INSERT INTO obps_rolemaster(roleid,roledescription)
VALUES(@roleid,@desc) 

END


  
GO
