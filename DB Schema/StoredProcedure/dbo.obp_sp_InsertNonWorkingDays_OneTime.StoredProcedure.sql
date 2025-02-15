USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_InsertNonWorkingDays_OneTime]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*To Insert all Sundays from a Selected Year*/
Create procedure [dbo].[obp_sp_InsertNonWorkingDays_OneTime]
(@var_StartDt date)
as
Begin

Declare @var_count int=367
--Declare @var_StartDt date = '2025-01-01'
Declare @var_Date1 date

While @var_count<>0
Begin
Set @var_Date1=@var_StartDt

If DATEPART(weekday,@var_Date1)=1
Begin
 If (Select isnull(count(*),0) from obps_NonWorkingDays where NonWorkingDays=@var_Date1)=0
 Begin
	 insert into obps_NonWorkingDays values(1,@var_Date1)
	 Select @var_Date1 as 'SelectedDate'
 End
End

set @var_StartDt=DATEADD(dd,1,@var_StartDt)
Set @var_count=@var_count-1
end

End

GO
