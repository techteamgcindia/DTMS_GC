USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_readcopylinkdata]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[obps_sp_readcopylinkdata]
AS
BEGIN
	select T.id 'toplinkid', TE.id 'toplinkextendedid', DisplayName, 
	LinkName 'submenu',gridid,Gridsp,lower(Gridtable) 'Gridtable'
	from obps_TopLinks_temp T
	inner join obps_TopLinkExtended_temp TE on T.id=TE.Linkid
	inner join obps_MenuName M on M.MenuId=T.MenuId
END
GO
