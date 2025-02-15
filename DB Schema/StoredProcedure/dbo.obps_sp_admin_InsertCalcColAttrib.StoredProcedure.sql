USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertCalcColAttrib]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_InsertCalcColAttrib]  
@linkid nvarchar(MAX)='',  
@colname nvarchar(MAX)='',  
@displayname nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@colcolour nvarchar(MAX)='',  
@colwidth nvarchar(MAX)='',  
@sortindex nvarchar(MAX)='',  
@sortorder nvarchar(MAX)='',  
@isactive nvarchar(MAX)='',  
@ismobile nvarchar(MAX)='',
@tooltip nvarchar(MAX)='',
@formatCondIcon nvarchar(MAX)='',
@summarytype nvarchar(MAX)='',
@minval nvarchar(MAX)='',
@maxval nvarchar(MAX)=''
AS  
BEGIN  
  
INSERT INTO obps_CalculatedColAttrib  
(ColName,DisplayName,ColColor,GridId,ColumnWidth,LinkId,SortIndex,  
SortOrder,CreatedDate,CreatedBY,IsActive,IsMobile,ToolTip,SummaryType,MinVal,MaxVal,FormatCondIconId)  
values  
(@colname,@displayname,@colcolour,@gridid,@colwidth,@linkid,@sortindex,  
@sortorder,getdate(),'admin',@isactive,@ismobile,@tooltip,@summarytype,@minval,@maxval,@formatCondIcon)  
select '1'  
END  
GO
