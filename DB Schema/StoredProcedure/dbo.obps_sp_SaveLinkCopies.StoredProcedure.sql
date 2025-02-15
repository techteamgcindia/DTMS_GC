USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_SaveLinkCopies]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_SaveLinkCopies]      
AS      
BEGIN      
      
declare @userid int,@newlinkid int      
declare @linkname nvarchar(MAX)='',@originallinkid  nvarchar(MAX)=''      
      
insert into obps_TopLinks     
(LinkName,Type,MenuId,SortOrder,IsAfterLogin,IsImportEnabled,ImportErrorOutSp,ImportSavedOutSp  
,IsMobile,EnableUniversalSearch,ImportHelp,AllowedExtension,IsLocation,DdlSp,IsSamePage,TriggerGrid,RefreshGrid  
,ConditionalCRUDBtn,CondCRUDBtnAddSp,CondCRUDBtnEditSp,CondCRUDBtnDeleteSp,IsSpreadSheet,IsPivot  
,SchedulerTypeSP,IsExportToCsv,CSVSeperator)      
select LinkName,Type,MenuId,SortOrder,IsAfterLogin,IsImportEnabled,ImportErrorOutSp,ImportSavedOutSp  
,IsMobile,EnableUniversalSearch,ImportHelp,AllowedExtension,IsLocation,DdlSp,IsSamePage,TriggerGrid,RefreshGrid  
,ConditionalCRUDBtn,CondCRUDBtnAddSp,CondCRUDBtnEditSp,CondCRUDBtnDeleteSp,IsSpreadSheet,IsPivot  
,SchedulerTypeSP,IsExportToCsv,CSVSeperator from obps_TopLinks_temp      
      
 SET @originallinkid=(select max(originallinkid) from obps_TopLinks_temp)     
      
DECLARE link_cursor CURSOR      
FOR SELECT linkname FROM obps_toplinks_temp;      
      
OPEN link_cursor;      
      
FETCH NEXT FROM link_cursor INTO       
    @linkname;      
      
 WHILE @@FETCH_STATUS = 0      
    BEGIN      
       
  SET @newlinkid=(select id from obps_TopLinks where LinkName=@linkname)      

  insert into obps_TopLinkExtended
  (Linkid,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp,AfterSaveSp,AllowToolbar,
  IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled,RefreshSp,IsYellowBtn,YellowBtnSp,
  IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit,DependentGrid,AllowHScrollBar,CustomContextMenuLinkId1,
  CustomContextMenuLinkId2,CustomContextMenuLinkId3,CustomContextMenuTxt1,CustomContextMenuTxt2,CustomContextMenuTxt3)  
  select @newlinkid,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp,AfterSaveSp
,AllowToolbar,IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled,RefreshSp
,IsYellowBtn,YellowBtnSp,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit,DependentGrid,AllowHScrollBar
,CustomContextMenuLinkId1,CustomContextMenuLinkId2,CustomContextMenuLinkId3,CustomContextMenuTxt1,CustomContextMenuTxt2,CustomContextMenuTxt3  
from obps_TopLinkExtended_temp where Linkid=(select id from obps_toplinks_temp where LinkName=@linkname)

  insert into obps_ColAttrib(TableID,TableName,ColName,DisplayName,ColControlType,IsEditable,ColColor,FontColor,FontAttrib  
  ,CreatedDate,CreatedBY,ModifiedBy,IsActive,IsDeleted,DropDownLink,GridId,ColumnWidth,LinkId  
  ,SortIndex,SortOrder,ToolTip,SummaryType,IsMobile,IsRequired,FormatCondIconId,MinVal,MaxVal)      
  select TableID,TableName,ColName,DisplayName,ColControlType,IsEditable,ColColor,FontColor,FontAttrib  
  ,getdate(),'admin',ModifiedBy,IsActive,IsDeleted,DropDownLink,GridId,ColumnWidth,@newlinkid  
  ,SortIndex,SortOrder,ToolTip,SummaryType,IsMobile,IsRequired,FormatCondIconId,MinVal,MaxVal   
  from obps_ColAttrib where LinkId=@originallinkid    
    
  insert into obps_CalculatedColAttrib(ColName,DisplayName,ColColor,GridId,ColumnWidth,  
  LinkId,SortIndex,SortOrder,CreatedDate,CreatedBY,ModifiedBy,IsActive,IsDeleted,IsMobile,  
  ToolTip,SummaryType,FormatCondIconId,MinVal,MaxVal)  
  select ColName,DisplayName,ColColor,GridId,ColumnWidth,  
  @newlinkid,SortIndex,SortOrder,getdate(),'admin',NULL,IsActive,IsDeleted,IsMobile,  
  ToolTip,SummaryType,FormatCondIconId,MinVal,MaxVal   
  from obps_CalculatedColAttrib where LinkId=@originallinkid  
  
  insert into obps_RowAttrib(TableID,TableName,ColName,MappedCol,GridId,  
 IsBackground,CellEditColName,LinkId,CellCtrlTypeColName,DdlCtrlSpColName)  
 select TableID,TableName,ColName,MappedCol,GridId,  
 IsBackground,CellEditColName,@newlinkid,CellCtrlTypeColName,DdlCtrlSpColName  
 from obps_RowAttrib where linkId=@originallinkid  
          
 insert into obps_CalculatedRowAttrib(ColName,MappedCol,GridId,IsBackground,  
 CellEditColName,LinkId,CellCtrlTypeColName,DdlCtrlSpColName)  
 select ColName,MappedCol,GridId,IsBackground,  
 CellEditColName,@newlinkid,CellCtrlTypeColName,DdlCtrlSpColName   
 from obps_CalculatedRowAttrib where linkId=@originallinkid  
      
        FETCH NEXT FROM link_cursor INTO @linkname;      
    END;      
      
CLOSE link_cursor;      
      
DEALLOCATE link_cursor;      
      
truncate table obps_toplinks_temp    
truncate table obps_toplinkextended_temp    
    
END 
GO
