USE [obp_dtms]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 2024-04-27 8:04:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[Split](@String2 varchar(MAX), @Delimiter char(1))         
returns @temptable TABLE (items varchar(MAX))         
as         
begin        
    declare @idx int      
 declare @string varchar(8000)     
    declare @slice varchar(8000)    
   
 if(substring(@String2,len(@string2),len(@string2))='"')
	select @string=REPLACE((left((substring(@String2, 2, len(@String2)-1) ), len(@String2)-2)),'"','')  
  else
	select @string=REPLACE((left((substring(@String2, 2, len(@String2)-1) ), len(@String2)-1)),'"','')  
	
 -- select @string=substring(@String, 2, len(@String)-1)   
    select @idx = 1         
        if len(@String)<1 or @String is null  return         
  
    while @idx!= 0         
    begin         
        set @idx = charindex(@Delimiter,@String)         
        if @idx!=0         
            set @slice = left(@String,@idx - 1)         
        else         
            set @slice = @String         
  
        if(len(@slice)>0)    
            insert into @temptable(Items) values(@slice)         
  
        set @String = right(@String,len(@String) - @idx)         
        if len(@String) = 0 break         
    end     
return   
end;  
GO
