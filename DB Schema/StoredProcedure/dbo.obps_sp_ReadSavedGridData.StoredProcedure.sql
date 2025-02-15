USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadSavedGridData]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_ReadSavedGridData]        
@Gridname NVARCHAR(MAX)=NULL,        
@lId nvarchar(MAX) = '',        
@usrname NVARCHAR(MAX)= NULL,        
@Id NVARCHAR(MAX)= NULL,        
@clientid NVARCHAR(MAX)=''        
AS        
BEGIN        
 DECLARE @usrname_col NVARCHAR(MAX),        
    @query NVARCHAR(MAX),        
    @query_Key NVARCHAR(MAX),        
    @pkey NVARCHAR(MAX),        
    @tabname NVARCHAR(MAX),        
    @spquery NVARCHAR(MAX) ,        
    @count int        
 DECLARE @spname NVARCHAR(MAX)        
        
SET @spname=(SELECT ImportSavedOutSp FROM obps_TopLinks where id=@lId)        
        
     
IF (@Id<>'' and @clientid='')        
BEGIN        
 EXEC @spname @usrname,@Id         
END        
ELSE IF (@Id<>'' and @clientid='' and @usrname<>'')        
BEGIN        
 EXEC @spname @usrname,@Id, @clientid        
END        
ELSE        
BEGIN        
 EXEC @spname    @usrname      
END        
END 
GO
