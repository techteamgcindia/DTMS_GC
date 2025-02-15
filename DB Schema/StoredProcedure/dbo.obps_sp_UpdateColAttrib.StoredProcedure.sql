USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateColAttrib]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[obps_sp_UpdateColAttrib]     
@linkid nvarchar(MAX)='',    
@tabname nvarchar(MAX)='',      
@ColName nvarchar(MAX)='',      
@DisplayName nvarchar(MAX)='',      
@ColControlType nvarchar(MAX)='',      
@ColColor nvarchar(MAX)='',      
@DropDownLink nvarchar(MAX)='',      
@ColumnWidth nvarchar(MAX),  
@iseditable nvarchar(MAX)='',  
@sortindex nvarchar(MAX)='',  
@sortorder nvarchar(MAX)='',
@summarytype nvarchar(MAX)='',
@formaticon nvarchar(MAX)='',
@ismobile nvarchar(MAX)='',
@isrequired nvarchar(MAX)='',
@minval nvarchar(MAX)='',
@maxval nvarchar(MAX)=''
AS      
BEGIN      
      
DECLARE @count nvarchar(MAX)      
 SET @count=(select count(*) from obps_ColAttrib where tablename=@tabname and ColName=@ColName)      
 IF @count>0       
 BEGIN      
  update obps_ColAttrib set DisplayName=@DisplayName,ColControlType=@ColControlType,DropDownLink=@DropDownLink,ColColor=@ColColor ,      
  ColumnWidth= case when (@ColumnWidth='' or @ColumnWidth='0') then NULL else @ColumnWidth end, IsEditable=@iseditable,   
  SortIndex=@sortindex,SortOrder=@sortorder, SummaryType=@summarytype,FormatCondIconId=@formaticon,IsMobile=@ismobile,
  IsRequired=@isrequired,MinVal=@minval,MaxVal=@maxval
  where tablename=@tabname and ColName=@ColName     
  and LinkId=@linkid    
 END      
END       
GO
