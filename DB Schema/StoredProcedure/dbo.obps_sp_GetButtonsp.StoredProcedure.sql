USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetButtonsp]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetButtonsp]  
 @LinkId NVARCHAR(MAX)='',  
 @ColumnName NVARCHAR(MAX)='', 
 @Id NVARCHAR(MAX)='', 
 @username NVARCHAR(MAX)='', 
 @ClickedVal NVARCHAR(MAX)=''
AS  
BEGIN  
  
  DECLARE @query NVARCHAR(MAX),  
  @query_Key NVARCHAR(MAX),  
  @tabname NVARCHAR(MAX),  
  @querystr nvarchar(MAX)='' ,
  @colnew nvarchar(MAX)='',@indx int,@btnSpname nvarchar(MAX)=''

  DECLARE @ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),  
  @controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int  
  
    SET NOCOUNT ON;  


--IF @tabname is not null  
--BEGIN  
SET @indx=(select CHARINDEX ('__',@ColumnName,0 ))    
SET @colnew=(SELECT SUBSTRING(@ColumnName, 1,@indx-1))  
SET @tabname=(SELECT SUBSTRING(@ColumnName, @indx+2, LEN(@ColumnName)))  
set @btnSpname=(select DropDownLink from obps_ColAttrib  where ColName=@colnew and TABLENAME = @tabname AND  linkid=@LinkId)  

if @btnSpname is not null
	exec @btnSpname @colnew,@Id, @username, @ClickedVal 

select @btnSpname,@colnew,@Id, @username, @ClickedVal 

END
GO
