USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[SP_Dash_ColorStatCombined]    Script Date: 2024-04-27 8:03:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[SP_Dash_ColorStatCombined] as

Select 'Site' Type,* 
from obp_finolex.dbo.CH_ColorStatSite a

union all

Select 'Pipe' Type,* 
from obp_finolex.dbo.CH_ColorStatSite a
order by updatedate, branch
GO
