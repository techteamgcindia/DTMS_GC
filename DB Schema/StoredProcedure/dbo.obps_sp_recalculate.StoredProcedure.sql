USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_recalculate]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[obps_sp_recalculate]
@username nvarchar(MAX)=''
as
begin

select ''
	--exec [onebeat_VSL].dbo.[SP_After_LoadAndReCalculate]

end
GO
