USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttribCellEdit]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obps_sp_getRowAttribCellEdit]            
--declare            
@Gridname NVARCHAR(MAX)=NULL,            
@LinkId NVARCHAR(MAX)=NULL            
AS            
BEGIN            
    DECLARE @tabquery NVARCHAR(MAX),            
    @gridid VARCHAR(MAX),            
    @query NVARCHAR(MAX)            
            
            
    SET NOCOUNT ON;            
            
 SET @gridid=SUBSTRING(@Gridname,5,1)            
   select LOWER(CellEditColName)+'__'+LOWER(tablename),LOWER(MappedCol)             
 from obps_RowAttrib where GridId=@gridid and len(CellEditColName)>0 and LinkId=@LinkId         
        
 --set  @query=('select LOWER(CellEditColName),LOWER(ColName)+''__''+LOWER(tablename),LOWER(IsBackground)             
 --from obps_RowAttrib where GridId='+@gridid+' and (CellEditColName is not null or CellEditColName<>''''and LinkId='''+@LinkId+''')')            
 --EXEC Sp_executesql @query            
 --select @query            
            
END
GO
