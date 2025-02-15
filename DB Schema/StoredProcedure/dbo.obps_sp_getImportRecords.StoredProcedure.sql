USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getImportRecords]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getImportRecords]            
AS            
BEGIN            
    
select T.id 'toplinkid',I.id 'importconfigid',DisplayName,LinkName,    
TableName,TempTableName,InsertSp,GenFileSp,deletesp,ImportErrorOutSp,    
ImportSavedOutSp from obps_toplinks T    
left join obps_excelimportconfig I on T.id=I.linkid    
inner join obps_MenuName M on T.MenuId=M.MenuId    
where T.IsImportEnabled=1    
    
END
GO
