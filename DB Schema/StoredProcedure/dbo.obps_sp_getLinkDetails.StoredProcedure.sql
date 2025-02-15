USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getLinkDetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[obps_sp_getLinkDetails]                  
@Id int=''                  
AS                  
BEGIN                  
DECLARE @newId int                  
 if @Id=''                  
 BEGIN                  
  SET @newId=(select top 1 Id from obps_TopLinks where IsAfterLogin=1)                  
 END                  
 IF @newId=''                  
 BEGIN                  
   SELECT 0                  
 END                  
 ELSE                  
 BEGIN                  
   select Id,tabid,tabtype,TabText,GridId,GridSp,GridTable            
   from obps_TopLinkExtended where Linkid=@Id-- and (TabText!=''or TabText is null)     
   order by tabid asc  
 END                  
END

GO
