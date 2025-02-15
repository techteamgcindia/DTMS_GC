USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkLinkName]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_checkLinkName]
@LinkName nvarchar(MAX),
@MenuId nvarchar(MAX),
@id nvarchar(MAX)=''
AS
BEGIN
DECLARE @mid int=0;
set @mid=(select id from obps_MenuName where DisplayName=@MenuId)
if @id<>''
BEGIN

	IF ((SELECT count(*) from obps_TopLinks where LinkName=@LinkName and MenuId=@mid and id<>@id)>0)
	BEGIN
		select 0--- exist in the db
	END
	ELSE
	BEGIN
		select 1--- not exist in the db
	END
END
ELSE
BEGIN
	IF ((SELECT count(*) from obps_TopLinks where LinkName=@LinkName and MenuId=@mid)>0)
	BEGIN
		select 0---user type exist in the db
	END
	ELSE
	BEGIN
		select 1---user type not exist in the db
	END
END
END
GO
