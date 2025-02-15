USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[ValidateInput_AutocableDemand]    Script Date: 2024-04-27 8:03:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ValidateInput_AutocableDemand] 
AS
BEGIN
   declare  @Year INT,
    @Month INT,
    @Day INT,
    @SKU VARCHAR(50),
    @Plant VARCHAR(10),
	@count int,
	@i int=0,
	@rn int,
	@d int =100
	,@l int=0
		set @count=(select count(*) from obp_Demand_temp)
	while(@count>=@i)
	begin
	    declare @remark nvarchar(max)='Please Correct ',@k int =0
		select @Year=DueYYYY,@Month=DueMM,@Day=DueDD,@Plant=Plant,@SKU=MaterialCode,@rn=ID from obp_Demand_temp where ID=@d+@i
		
		if(@l=0)
		begin
		    set @d=100
			set @l=@l+2
        end
			IF LEN(@Year) <> 4 
			BEGIN
               
			   set @remark=@remark+' Year,'	
			   set @k=1;
			END
    
			-- Check Month
			IF @Month < 1 OR @Month > 12
			BEGIN
				 set @remark=@remark+' Month,'	
				 set @k=1;
			END
    
			-- Check Day
			IF @Day < 1 OR @Day > 31
			BEGIN
				 set @remark=@remark+' Day should be between 1 and 31,'
				set @k=1;
			END
    
			
			IF NOT EXISTS (SELECT 1 from  Onebeat_Finolex.dbo.Symphony_StockLocations  sl                     
							left join Onebeat_Finolex.dbo.Symphony_StockLocationSkus as sls on sls.stockLocationID=sl.stockLocationID 
							WHERE sls.locationSkuName   = @SKU and sl.stockLocationName=@Plant)
			BEGIN
				set @remark=@remark+' SKU is not registered in MTS SKUs,'
				set @k=1;
			END
    
			-- Check Plant
			IF @Plant <> 'UCAB' AND @Plant <> 'RCAB' 
			BEGIN
				set @remark=@remark+' Plant should be '+@Plant
				set @k=1;
			END
         
		 if(@k=1)
		 begin
		     update obp_Demand_temp set IsValid=0,remark=@remark where ID=@rn
			 set @k=0
		 end
				set @i=@i+1
		  end  
END
GO
