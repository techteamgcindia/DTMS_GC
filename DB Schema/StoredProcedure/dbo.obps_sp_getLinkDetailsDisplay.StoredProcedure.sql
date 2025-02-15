USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getLinkDetailsDisplay]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getLinkDetailsDisplay]    
@Id int    
AS    
BEGIN    
select LinkName,Type,T.MenuId,SortOrder,IsAfterLogin,IsImportEnabled,IsMobile
		,EnableUniversalSearch,IsLocation,IsSamePage,ConditionalCRUDBtn,CondCRUDBtnAddSp,
		CondCRUDBtnEditSp ,CondCRUDBtnDeleteSp,CSVSeperator

--select Grid1Sp ,Grid2Sp,Grid3Sp,Grid4Sp,Grid5Sp,LinkName,Type,Grid1Table,    
--Grid2Table,Grid3Table,Grid4Table,Grid5Table,M.DisplayName,SortOrder,IsAfterLogin,    
--Grid1AllowAdd,Grid2AllowAdd,Grid3AllowAdd,Grid4AllowAdd,Grid5AllowAdd,    
--Grid1AllowEdit,Grid2AllowEdit,Grid3AllowEdit,Grid4AllowEdit,Grid5AllowEdit,    
--Grid1AllowDelete,Grid2AllowDelete,Grid3AllowDelete,Grid4AllowDelete,Grid5AllowDelete,  
--IsImportEnabled, ImportErrorOutSp,ImportSavedOutSp,ImportHelp,--(30,31,32,33)  
--case when tid.ForeignKey is null then  ''  else tid.ForeignKey end as 'ForeignKey',Type  as'Pagetype'  
from obps_TopLinks T    
inner join obps_MenuName M on T.MenuId=M.Id left join obps_TableId tid on tid.LinkId=T.id    
where T.id=@Id    
END    
GO
