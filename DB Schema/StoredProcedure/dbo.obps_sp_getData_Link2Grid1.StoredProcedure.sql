USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getData_Link2Grid1]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getData_Link2Grid1]
AS
BEGIN
select  top 10 * from OBP_PRJ_012 p1 inner join OBP_PRJ_013 p2 on p1.classification=p2.classification
END
GO
