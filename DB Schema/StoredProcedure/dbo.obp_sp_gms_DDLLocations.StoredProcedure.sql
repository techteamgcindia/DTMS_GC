USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DDLLocations]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DDLLocations]  
(  
@usrnme NVARCHAR(MAX)='',            
@linkid int='' ,      
@gridid nvarchar(MAX)=''  
)  
AS       
BEGIN       
SELECT id,convert(nvarchar,LocationCode) name from obp_gms_Locations
order by id      
END
GO
