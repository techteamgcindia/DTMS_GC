USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetToolBarButton]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetToolBarButton]                      
@GridId nvarchar(2)='',                      
@LinkId nvarchar(3)=''                      
AS                      
BEGIN                      
DECLARE @IsAdd nvarchar(MAX),                      
@IsEdit nvarchar(MAX),                      
@IsDelete nvarchar(MAX),                      
@IsExport nvarchar(MAX),                      
@IsFilterRow nvarchar(MAX),                      
@IsHeaderFilter nvarchar(MAX),                      
@IsColumnChooser nvarchar(MAX),                      
@IsPaging nvarchar(MAX),                      
@GridAddName nvarchar(MAX),                      
@GridEditName nvarchar(MAX),                      
@GridDeleteName nvarchar(MAX),                      
@GridExportName nvarchar(MAX),                      
@GridFilterRowName nvarchar(MAX),                      
@GridheaderFilterName nvarchar(MAX),                      
@GridColumnChooserName nvarchar(MAX),                      
@GridPagingName nvarchar(MAX),                      
@GridGroupPanelName nvarchar(MAX),                      
@IsUploadEnabled nvarchar(MAX),                      
@IssearchPanel nvarchar(MAX),                      
@IsGroupPanel nvarchar(MAX),                      
@IsDependentTab nvarchar(MAX) ,      
@IsHScrollbar nvarchar(MAX),                
@IsFormEdit int=0,@IsRefresh int=0,@IsRed int=0,@IsYellow int=0,@IsGreen int=0,              
@IsImportFromExcel int=0  ,      
@CustomContextMenuTxt1 nvarchar(MAX),         
@CustomContxtMenuLId1 nvarchar(MAX),         
@CustomContextMenuTxt2 nvarchar(MAX),         
@CustomContxtMenuLId2 nvarchar(MAX),       
@CustomContextMenuTxt3 nvarchar(MAX),         
@CustomContxtMenuLId3 nvarchar(MAX),                                                                                                                                                                                                                                                              
@ToolbarDDLTxt1 nvarchar(MAX),@ToolbarDDLSp1 nvarchar(MAX),                                                                                                                                                                                    
@ToolbarDDLTxt2 nvarchar(MAX),@ToolbarDDLSp2 nvarchar(MAX),
@ToolbarDDLTxt3 nvarchar(MAX),@ToolbarDDLSp3 nvarchar(MAX)
                    
SET @IsAdd=(select AllowAdd from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsEdit=(select AllowEdit from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsDelete=(select AllowDelete from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsExport=(select IsExport from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsFilterRow=(select AllowFilterRow from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsHeaderFilter=(select AllowheaderFilter from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsColumnChooser=(select AllowColumnChooser from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsPaging=(select AllowPaging from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsGroupPanel=(select AllowGroupPanel from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                 
SET @IsImportFromExcel=(select IsImportEnabled from obps_TopLinks where id=@LinkId)               
                      
if @IsExport is null                      
set @IsExport=0;                      
                     
if @IsFilterRow is null                      
set @IsFilterRow=0;                      
                      
if @IsHeaderFilter is null                      
set @IsHeaderFilter=0;                      
                      
if @IsColumnChooser is null                      
set @IsColumnChooser=0;                      
                    
if @IsPaging is null                      
set @IsPaging=0;                 
              
if @IsImportFromExcel is null                      
set @IsImportFromExcel=0;               
                      
SET @IsUploadEnabled=(select IsUploadEnabled from obps_TopLinks where id=@LinkId)                      
if @IsUploadEnabled is null                      
set @IsUploadEnabled=0;                      
                      
if @IsGroupPanel is null                      
set @IsGroupPanel=0;                      
                      
SET @IssearchPanel=(select EnableUniversalSearch from obps_TopLinks where id=@LinkId)                      
if @IssearchPanel is null                      
set @IssearchPanel=0;                      
          
--SET @IsDependentTab=(select IsDependentTab from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
--if @IsDependentTab is null                      
--set @IsDependentTab=0;                      
                      
SET @IsFormEdit=(select IsFormEdit from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)         
if @IsFormEdit is null                      
set @IsFormEdit=0;                  
                
SET @IsRefresh=(select RefreshEnabled from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @IsRefresh is null                     
set @IsRefresh=0;                 
                
SET @IsRed=(select IsRedBtn from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @IsRed is null                 
set @IsRed=0;                 
                
SET @IsYellow=(select IsYellowBtn from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                   
if @IsYellow is null                      
set @IsYellow=0;                 
                
SET @IsGreen=(select IsGreenBtn from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @IsGreen is null                      
set @IsGreen=0;                 
      
SET @IsHScrollbar=(select AllowHScrollBar from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @IsHScrollbar is null                      
set @IsHScrollbar=0;      
                
SET @CustomContextMenuTxt1=(select CustomContextMenuTxt1 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContextMenuTxt1 is null                      
set @CustomContextMenuTxt1='';      
      
SET @CustomContxtMenuLId1=(select CustomContextMenuLinkId1 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContxtMenuLId1 is null                      
set @CustomContxtMenuLId1='';      
      
SET @CustomContextMenuTxt2=(select CustomContextMenuTxt2 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContextMenuTxt2 is null                      
set @CustomContextMenuTxt2='';      
      
SET @CustomContxtMenuLId2=(select CustomContextMenuLinkId2 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContxtMenuLId2 is null                      
set @CustomContxtMenuLId2='';     
    SET @CustomContextMenuTxt3=(select CustomContextMenuTxt3 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContextMenuTxt3 is null                      
set @CustomContextMenuTxt3='';      
      
SET @CustomContxtMenuLId3=(select CustomContextMenuLinkId3 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContxtMenuLId3 is null                      
set @CustomContxtMenuLId3='';     

SET @ToolbarDDLTxt1=(select ToolBarDDLTxt1 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLTxt1 is null                      
set @ToolbarDDLTxt1='';     
    
SET @ToolbarDDLTxt2=(select ToolBarDDLTxt2 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLTxt2 is null                      
set @ToolbarDDLTxt2='';      
      
SET @ToolbarDDLTxt3=(select ToolBarDDLTxt3 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLTxt3 is null                      
set @ToolbarDDLTxt3=''; 

SET @ToolbarDDLSp1=(select ToolBarDDLSp1 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLSp1 is null                      
set @ToolbarDDLSp1='';     
    
SET @ToolbarDDLSp2=(select ToolBarDDLSp2 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLSp2 is null                      
set @ToolbarDDLSp2='';      
      
SET @ToolbarDDLSp3=(select ToolBarDDLSp3 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLSp3 is null                      
set @ToolBarDDLSp3='';

SELECT @IsAdd,@IsEdit,@IsDelete,@IsExport,@IsFilterRow,@IsHeaderFilter,@IsColumnChooser,@IsPaging,                      
    @IsUploadEnabled,@IsGroupPanel,@IssearchPanel,@IsFormEdit,@IsRefresh,@IsRed,@IsYellow,@IsGreen               
 ,@IsImportFromExcel  ,@IsHScrollbar  ,@CustomContextMenuTxt1,  @CustomContxtMenuLId1,@CustomContextMenuTxt2,    
 @CustomContxtMenuLId2,@CustomContextMenuTxt3,@CustomContxtMenuLId3,@ToolbarDDLTxt1,@ToolbarDDLTxt2,@ToolbarDDLTxt3    
 ,@ToolbarDDLSp1,@ToolbarDDLSp2,@ToolbarDDLSp3   

END
GO
