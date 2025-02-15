USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertImportRecord]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertImportRecord]              
@linkid nvarchar(MAX)='',     
@Username nvarchar(max)     
AS              
BEGIN              

print 'validity check start'        

Exec obps_sp_GenDataValidityCheck_DataType   @linkid,   @Username    
print 'validity check end'    
/*Execute the Implementer's SP*/    
    
DECLARE @InsertSp nvarchar(MAX)='',@var_ValidRecCount int        
      
set @InsertSp=(select ltrim(rtrim(InsertSp)) from obps_ExcelImportConfig where LinkId=@linkid)        
    
if len(ltrim(rtrim(@InsertSp)))>1      
begin      
/*Implementer SP will have userid as parameter*/    
exec @InsertSp   @Username     
end      
    
/*End - Execute the Implementer's SP*/    
END   
GO
