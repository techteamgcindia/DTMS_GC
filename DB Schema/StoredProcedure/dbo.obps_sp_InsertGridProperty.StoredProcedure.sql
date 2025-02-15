USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertGridProperty]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertGridProperty]  
@id int='',
@operation nvarchar(MAX)='',  
@tabid int='',
@tabtext nvarchar(MAX)='',
@TabType nvarchar(3)='',
@gridno int='',  
@linkid int='',    
@gridsp nvarchar(MAX)='',  
@tablename nvarchar(MAX)='',  
@IsAdd int='',   
@IsEdit int='',  
@IsDelete int='',   
@aftersavesp nvarchar(MAX)='',  
@refreshsp nvarchar(MAX)='',            
@deleteSp nvarchar(MAX)='',
@isredbtn int='',
@redbtnsp nvarchar(MAX)='', 
@isyellowbtn int='',
@yellowbtnsp nvarchar(MAX)='',  
@isgreenbtn int='',
@greenbtnsp nvarchar(MAX)='',
@dependentgrid nvarchar(MAX)='' ,  
@export int='',  
@filterrow int='', 
@headerfilter int='', 
@columnchooser int='',
@grouppanel int='',
@paging int='',
@formedit int='',
@Hscrollbar int='',
@menu1txt nvarchar(MAX)='' ,
@menu1linkid int='',
@menu2txt nvarchar(MAX)='' ,
@menu2linkid int='',
@menu3txt nvarchar(MAX)='' ,
@menu3linkid int=''
AS            
BEGIN            
 DECLARE @ins_id int=0  
 BEGIN TRY
	IF @operation = 'add'            
	BEGIN          
		  INSERT INTO obps_TopLinkextended            
			  (gridid,Linkid,TabId,TabText,TabType,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete
				,DeleteSp,AfterSaveSp,IsExport,AllowFilterRow,AllowheaderFilter
				,AllowColumnChooser,AllowGroupPanel,RefreshEnabled,RefreshSp,IsYellowBtn,YellowBtnSp
				,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit,DependentGrid,AllowHScrollBar
				,CustomContextMenuTxt1,CustomContextMenuLinkId1,CustomContextMenuTxt2,CustomContextMenuLinkId2
				,CustomContextMenuTxt3,CustomContextMenuLinkId3)  
		  values            
			  (@gridno,@linkid,@tabid,@tabtext,@tabtype,@gridsp,@tablename,@IsAdd,@IsEdit,@IsDelete,
			    @deleteSp,@aftersavesp,@export,@filterrow,@headerfilter,
				@columnchooser,@grouppanel,case when len(trim(@refreshsp))>0 then 1 else 0 end,@refreshsp,@isyellowbtn,@yellowbtnsp,
				@isgreenbtn,@greenbtnsp,@isredbtn,@redbtnsp,@paging,@formedit,@dependentgrid,@Hscrollbar,
				@menu1txt,@menu1linkid,@menu2txt,@menu2linkid,@menu3txt,@menu3linkid)  
		  select 'Grid Details Added'            
		  --SET @ins_id=(SELECT SCOPE_IDENTITY())            
		  --exec obps_sp_ColAttribMapping @ins_id     
		  --exec obps_sp_InsertRoleMapping @ins_id    
	END       
	ELSE            
	BEGIN            
		update obps_TopLinkextended set GridId=@gridno,Linkid=@linkid,TabId=@tabid,TabText=@tabtext,
				TabType=@TabType,GridSp=@gridsp,GridTable=@tablename,AllowAdd=@IsAdd,AllowEdit=@IsEdit,AllowDelete=@IsDelete
				,DeleteSp=@deleteSp,AfterSaveSp=@aftersavesp,IsExport=@export,AllowFilterRow=@filterrow,AllowheaderFilter=@headerfilter
				,AllowColumnChooser=@columnchooser,AllowGroupPanel=@grouppanel,RefreshEnabled=case when len(trim(@refreshsp))>0 then 1 else 0 end,
				RefreshSp=@refreshsp,IsYellowBtn=@isyellowbtn,YellowBtnSp=@yellowbtnsp
				,IsGreenBtn=@isgreenbtn,GreenBtnSp=@greenbtnsp,IsRedBtn=@isredbtn,RedBtnSp=@redbtnsp,
				AllowPaging=@paging,IsFormEdit=@formedit,DependentGrid=@dependentgrid,AllowHScrollBar=@Hscrollbar
				,CustomContextMenuTxt1=@menu1txt,CustomContextMenuLinkId1=@menu1linkid,CustomContextMenuTxt2=@menu2txt,CustomContextMenuLinkId2=@menu2linkid
				,CustomContextMenuTxt3=@menu3txt,CustomContextMenuLinkId3=@menu3linkid where id=@id
			select 'Grid Details Updated'
	END    
END TRY  
BEGIN CATCH  
    SELECT  ERROR_NUMBER()  +'  :  '+ERROR_MESSAGE()   
END CATCH  	
END 
GO
