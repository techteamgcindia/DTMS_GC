USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteUserType]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DeleteUserType]
@id nvarchar(MAX)
AS
BEGIN

	declare @count int=0;
	set @count=(select count(*) from obps_UserType where id=@id and UserTypeId in(select distinct UserTypeId from obps_Users))
	if(@count=0)
	BEGIN
		delete from obps_UserType where id=@id
		select '1'
	END
	ELSE
	BEGIN
		select '0'
	END

END
GO
