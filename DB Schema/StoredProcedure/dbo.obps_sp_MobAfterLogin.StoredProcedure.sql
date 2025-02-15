USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_MobAfterLogin]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_MobAfterLogin]
@username nvarchar(MAX)=''
AS
BEGIN
	DECLARE @spname nvarchar(MAX)='',
	@roleid int='',@count int=0

	set @roleid=(select roleid from obps_Users where UserName=@username)
	SET @count=(select count(AfterLoginSp) from obps_MobAfterLogin where Roleid=@roleid)

	if(@count>0)
		SET @spname=(select AfterLoginSp from obps_MobAfterLogin where Roleid=@roleid)
	else
		SET @spname=(select top 1 AfterLoginSp from obps_MobAfterLogin where Roleid is null or roleid='')
	if(len(LTRIM(rtrim(@spname)))>1)
	exec @spname
END
GO
