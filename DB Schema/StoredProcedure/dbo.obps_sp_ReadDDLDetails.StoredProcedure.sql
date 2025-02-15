USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadDDLDetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
CREATE PROCEDURE [dbo].[obps_sp_ReadDDLDetails]            
@username nvarchar(MAX)='' ,          
@ddlid nvarchar(MAX)='' ,          
@linkid nvarchar(3)='',          
@selectedvalue nvarchar(MAX)=''          
AS            
BEGIN          
DECLARE @spname nvarchar(MAX),          
@spnamequery nvarchar(MAX),          
@ddlcolname nvarchar(MAX),          
@colnamequery nvarchar(MAX)          
          
SET @ddlcolname='ddl'+@ddlid+'sp'          
SET @spnamequery=('(select @spname='+@ddlcolname+' from obps_mobileConfig where linkid='''+@LinkId +''')')          
EXEC Sp_executesql  @spnamequery,  N'@spname NVARCHAR(MAX) output',  @spname output          
if(trim(@spname)<>''or trim(@spname)<>null)          
begin        
exec @spname @linkid,@selectedvalue ,@username         
end        
          
END
GO
