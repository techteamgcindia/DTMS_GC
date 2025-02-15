USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getPaymentClient]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getPaymentClient]  
@usrname NVARCHAR(MAX)=''  
AS  
BEGIN  
 DECLARE @SearchLetter nvarchar(100)  
 SET @SearchLetter ='%'+ @usrname + '%'  
 select ID,clientname as name from obp_ClientMaster cm where 
 --Added on 24-05-2021--to have access control form obp_ClientMaster table 
(cm.SuperUser like @SearchLetter or cm.PD like @SearchLetter or cm.PC like @SearchLetter or cm.RM like @SearchLetter or cm.Implementer like @SearchLetter 
or cm.consultant like @SearchLetter or cm.AccessToUser like @SearchLetter)
 --AccessToUser like  @SearchLetter  
 and ClientName not in ('DevOps','Internal')
 order by ClientName  
 --select ID,clientname as name from obp_ClientMaster  
END  

GO
