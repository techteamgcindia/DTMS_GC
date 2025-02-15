USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ColAttribMapping]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_ColAttribMapping]      
@id nvarchar(MAX)=''      
AS      
BEGIN       
       
 DECLARE @tab nvarchar(MAX)=''      
 DECLARE CUR_ColAttrib CURSOR FAST_FORWARD FOR      
 SELECT   NAME as tabname FROM SYSOBJECTS WHERE ID IN (   SELECT SD.DEPID  FROM SYSOBJECTS SO,         
                SYSDEPENDS SD   WHERE SO.NAME in( select Gridsp from obps_TopLinkextended where Linkid=@id) ----name of stored procedures        
                AND SD.ID = SO.ID        
            )       
 OPEN CUR_ColAttrib      
 FETCH NEXT FROM CUR_ColAttrib INTO @tab      
       
   WHILE @@FETCH_STATUS = 0      
   BEGIN      
   print 'obps_sp_LinkMapping'    
   print @tab    
   print @id    
    exec obps_sp_LinkMapping  @tab,@id      
    FETCH NEXT FROM CUR_ColAttrib INTO @tab      
   END      
      
 CLOSE CUR_ColAttrib      
 DEALLOCATE CUR_ColAttrib      
       
 
END 
GO
