USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_LocationSkusImportFormat]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_LocationSkusImportFormat]  
AS   
BEGIN  
 select 'LocationId'
 union
select 'SkuId'
union
select 'SkuDescription'
union
select 'BufferSize'
union
select 'ReplTime'
union
select 'UomId'
union
select 'InvAtStite'
union
select 'InvAtTransit'
union
select 'InvAtProduction'
union
select 'DispOriginId1'
union
select 'DispOriginId2'
union
select 'DispOriginId3'
union
select 'MinReplenishmentQty'
union
select 'ReplenishmentMultiples'
union
select 'IsReplenish'
END
GO
