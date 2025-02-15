USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_LocationSkusMergeInsert]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_LocationSkusMergeInsert]    
@UserName nvarchar(max)                                 
as    
begin     
    
 MERGE obp_gms_LocationSkus AS TARGET    
 USING obp_gms_LocationSkus_temp AS SOURCE    
 ON (TARGET.LocationId=SOURCE.LocationId and    
   TARGET.SkuId=SOURCE.SkuId)    
 WHEN NOT MATCHED BY TARGET    
 THEN     
  INSERT (LocationId,SkuId,SkuDescription,BufferSize,ReplTime
,UomId,InvAtStite,InvAtTransit,InvAtProduction,DispOriginId1
,DispOriginId2,DispOriginId3,MinReplenishmentQty,ReplenishmentMultiples
,UpdateDate,CreatedBy,CreatedDate)      
  VALUES ( SOURCE.LocationId,SOURCE.SkuId,SOURCE.SkuDescription, SOURCE.BufferSize, SOURCE.ReplTime
, SOURCE.UomId, SOURCE.InvAtStite, SOURCE.InvAtTransit, SOURCE.InvAtProduction, SOURCE.DispOriginId1
, SOURCE.DispOriginId2, SOURCE.DispOriginId3, SOURCE.MinReplenishmentQty, SOURCE.ReplenishmentMultiples
, getdate(),@username,getdate());
    
end    
GO
