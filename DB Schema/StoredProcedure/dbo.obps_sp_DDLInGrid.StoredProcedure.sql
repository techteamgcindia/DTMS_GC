USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DDLInGrid]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DDLInGrid]      
@username nvarchar(MAX)='',      
@Linkid nvarchar(2)=''      
AS      
BEGIN      
DECLARE @idDdlReq int=0;      
DECLARE @GridDdlSp nvarchar(MAX)=''      
      
SET @idDdlReq = (select GridDdlReq from obps_mobileconfig where linkid=@linkid)      
      
if @idDdlReq=1      
BEGIN      
 SET @GridDdlSp=(Select GridDdlSp from obps_mobileconfig where linkid=@linkid)      
 if len(trim(@GridDdlSp))>0      
  exec @GridDdlSp @username,@linkid      
END      
      
END
GO
