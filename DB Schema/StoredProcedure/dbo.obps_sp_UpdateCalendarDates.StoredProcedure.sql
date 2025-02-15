USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateCalendarDates]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_UpdateCalendarDates]
@linkid nvarchar(MAX)='',
@username nvarchar(MAX)='',
@dateval nvarchar(MAX)='',
@loc nvarchar(25)=''
AS
BEGIN

DECLARE @tablename nvarchar(MAX)=(select top 1 gridtable from obps_TopLinkExtended where Linkid=@linkid)
	WHILE LEN(@dateval) > 0
	BEGIN
		DECLARE @TDay VARCHAR(100)
		IF CHARINDEX(',',@dateval) > 0
			SET  @TDay = SUBSTRING(@dateval,0,CHARINDEX(',',@dateval))
		ELSE
			BEGIN
			SET  @TDay = @dateval
			SET @dateval = ''
		 END
			INSERT INTO obp_HolidayList
			(date) values(CONVERT(NVARCHAR(255),CONVERT(date, @TDay,105)))
			SET @dateval = REPLACE(@dateval,@TDay + ',' , '')
	END
END
GO
