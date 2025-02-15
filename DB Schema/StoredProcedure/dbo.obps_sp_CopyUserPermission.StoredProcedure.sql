USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CopyUserPermission]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_CopyUserPermission]
@fromuserid int='',
@touserid int='',
@linkid int=''
AS
BEGIN
BEGIN TRY
	DECLARE @count int=0
	SET @count=(select count(*) from obps_SpPermissions where Linkid=@linkid and UserId=@touserid)

	if(@count>0)
		delete from obps_SpPermissions where Linkid=@linkid and UserId=@touserid

	insert into obps_SpPermissions(UserId,Linkid,Gridid,Par1,Par2,Par3,Par4,Par5)
	select @touserid,Linkid,Gridid,Par1,Par2,Par3,Par4,Par5 
	from obps_SpPermissions where UserId=@fromuserid and linkid=@linkid

END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH
END
GO
