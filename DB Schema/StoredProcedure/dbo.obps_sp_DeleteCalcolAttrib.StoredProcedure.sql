USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteCalcolAttrib]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[obps_sp_DeleteCalcolAttrib]
@id int=''
AS
BEGIN

delete from obps_CalculatedColAttrib where id=@id

END
GO
