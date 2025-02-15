USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AddNonWorkingDaysWeekly]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_AddNonWorkingDaysWeekly]
--EXEC [sp_AddNonWorkingDaysWeekly] '','','','','','Saturday','',104,2021 ,2  
    
@pMonday as nvarchar(10) = NULL,    
@pTuesday as nvarchar(10) = NULL,    
@pWednesday as nvarchar(10) = NULL,    
@pThursday as nvarchar(10) = NULL,    
@pFriday as nvarchar(10) = NULL,    
@pSaturday as nvarchar(10) = NULL,    
@pSunday as nvarchar(10) = NULL,    
@Clientid as int ,  
@Year as int , 
@Month as int
AS
BEGIN    
-- SET NOCOUNT ON added to prevent extra result sets from    
-- interfering with SELECT statements.    
SET NOCOUNT ON;    
    
DECLARE    
/*@Year AS INT,  */  
@FirstDateOfYear DATETIME,    
@LastDateOfYear DATETIME,    
@CalendarDate AS INT    
    
SET @CalendarDate = -1    
    
-- You can change @year to any year you desire    
--SELECT @year = year(getdate())    
  
SELECT @FirstDateOfYear = DATEADD(yyyy, @Year - 1900, 0)    
SELECT @LastDateOfYear = DATEADD(yyyy, @Year - 1900 + 1, 0)    
   select @FirstDateOfYear , @LastDateOfYear
-- Creating Query to Prepare Year Data    
;WITH cte AS (    
SELECT 1 AS DayID,    
@FirstDateOfYear AS FromDate,    
DATENAME(dw, @FirstDateOfYear) AS Dayname    
UNION ALL    
SELECT cte.DayID + 1 AS DayID,    
DATEADD(d, 1 ,cte.FromDate),    
DATENAME(dw, DATEADD(d, 1 ,cte.FromDate)) AS Dayname    
FROM cte    
WHERE DATEADD(d,1,cte.FromDate) < @LastDateOfYear    
)    
INSERT INTO obps_NonWorkingDays(NonWorkingDays,Clientid)    
SELECT FromDate,@Clientid    
FROM CTE    
WHERE DayName IN (@pMonday,@pTuesday,@pWednesday,@pThursday,@pFriday,@pSaturday,@pSunday) and  
Month(FromDate)=@Month and
--FromDate NOT IN (SELECT nonWorkingDay FROM Symphony_ProductionCalendarNonWorkingDays) and     
NOT EXISTS (SELECT NonWorkingDays,Clientid FROM obps_NonWorkingDays WHERE NonWorkingDays = FromDate and Clientid = @Clientid)    
    
OPTION (MaxRecursion 370)    
    
--INSERT INTO Symphony_ProductionCalendarNonWorkingDays(nonWorkingDay,plantID,calenderID)    
--SELECT dates,@Clientid,@CalendarDate    
--FROM tblWeekSettings    
--WHERE datenames IN (@pMonday,@pTuesday,@pWednesday,@pThursday,@pFriday,@pSaturday,@pSunday)    
--OPTION (MaxRecursion 370)    
    
/*    
WHERE DayName IN ('Saturday,Sunday') -- For Weekend    
WHERE DayName NOT IN ('Saturday','Sunday') -- For Weekday    
WHERE DayName LIKE 'Monday' -- For Monday    
WHERE DayName LIKE 'Sunday'-- For Sunday    
*/    
     
END  

GO
