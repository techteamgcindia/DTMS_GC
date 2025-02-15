USE [master]
GO
/****** Object:  Database [obp_dtms]    Script Date: 2024-04-27 7:59:34 AM ******/
CREATE DATABASE [obp_dtms]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'obp_dtms', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\obp_dtms.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'obp_dtms_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\obp_dtms_log.ldf' , SIZE = 139264KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [obp_dtms] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [obp_dtms].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [obp_dtms] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [obp_dtms] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [obp_dtms] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [obp_dtms] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [obp_dtms] SET ARITHABORT OFF 
GO
ALTER DATABASE [obp_dtms] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [obp_dtms] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [obp_dtms] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [obp_dtms] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [obp_dtms] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [obp_dtms] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [obp_dtms] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [obp_dtms] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [obp_dtms] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [obp_dtms] SET  DISABLE_BROKER 
GO
ALTER DATABASE [obp_dtms] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [obp_dtms] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [obp_dtms] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [obp_dtms] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [obp_dtms] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [obp_dtms] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [obp_dtms] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [obp_dtms] SET RECOVERY FULL 
GO
ALTER DATABASE [obp_dtms] SET  MULTI_USER 
GO
ALTER DATABASE [obp_dtms] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [obp_dtms] SET DB_CHAINING OFF 
GO
ALTER DATABASE [obp_dtms] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [obp_dtms] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [obp_dtms] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [obp_dtms] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'obp_dtms', N'ON'
GO
ALTER DATABASE [obp_dtms] SET QUERY_STORE = OFF
GO
USE [obp_dtms]
GO
/****** Object:  User [dtmsview]    Script Date: 2024-04-27 7:59:34 AM ******/
CREATE USER [dtmsview] FOR LOGIN [dtmsview] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [dtmsview]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [dtmsview]
GO
/****** Object:  UserDefinedFunction [dbo].[ProperCase]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ProperCase](@Text as varchar(8000))
returns varchar(8000)
as
begin
  declare @Reset bit;
  declare @Ret varchar(8000);
  declare @i int;
  declare @c char(1);

  if @Text is null
    return null;

  select @Reset = 1, @i = 1, @Ret = '';

  while (@i <= len(@Text))
    select @c = substring(@Text, @i, 1),
      @Ret = @Ret + case when @Reset = 1 then UPPER(@c) else LOWER(@c) end,
      @Reset = case when @c like '[a-zA-Z]' then 0 else 1 end,
      @i = @i + 1
  return @Ret
end
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 2024-04-27 7:59:34 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[Split_ImportExcel]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split_ImportExcel](@String2 varchar(MAX), @Delimiter varchar(2))       
returns @temptable TABLE (items varchar(MAX))       
as       
begin      
   declare @idx int    
	declare @string varchar(8000)   
    declare @slice varchar(8000)  
	
	 select @string=REPLACE((left((substring(@String2, 1, len(@String2)-1) ), len(@String2)-2)),'"','') 
	 --select @string
	-- select @string=substring(@String, 2, len(@String)-1) 
    select @idx = 1       
        if len(@String)<1 or @String is null  return       

    while @idx!= 0       
    begin       
        set @idx = charindex(@Delimiter,@String)
	--	select @idx,@String

        if @idx!=0       
            set @slice = left(@String,@idx - 1)       
        else       
            set @slice = @String       

        if(len(@slice)>0)  
            insert into @temptable(Items) values(@slice)       
			--select @slice

        set @String = right(@String,len(@String) - (@idx+1))       
        if len(@String) = 0 break    
    end  
return 
end;
GO
/****** Object:  UserDefinedFunction [dbo].[Split_UpdateSp]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Split_UpdateSp](@String2 varchar(MAX), @Delimiter char(1))       
returns @temptable TABLE (items varchar(MAX))       
as       
begin      
    declare @idx int    
	declare @string varchar(8000)   
    declare @slice varchar(8000)  
	
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
/****** Object:  UserDefinedFunction [dbo].[Split_Upload]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create FUNCTION [dbo].[Split_Upload](@String varchar(MAX), @Delimiter char(1))       
returns @temptable TABLE (items varchar(MAX))       
as       
begin      
    declare @idx int       
    declare @slice varchar(8000)       

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
/****** Object:  UserDefinedFunction [dbo].[SplitUpdate]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- '"City__obp_customermaster":"Lucknow2"~^"MemberOfAssociation__obp_customermaster":"Hemant2"'

CREATE FUNCTION [dbo].[SplitUpdate](@String2 varchar(MAX), @Delimiter char(1))       
returns @temptable TABLE (items varchar(MAX))       
as       
begin      
    declare @idx int    
	declare @string varchar(8000)   
    declare @slice varchar(8000)  
	
	 select @string=REPLACE((left((substring(@String2, 2, len(@String2)-1) ), len(@String2)-2)),'"','')    
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

        set @String = right(@String,len(@String) - @idx-1)       
        if len(@String) = 0 break       
    end   
return 
end;
GO
/****** Object:  Table [dbo].[obp_ClientMaster]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_ClientMaster](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[Country] [nvarchar](max) NULL,
	[ClientName] [nvarchar](max) NULL,
	[LicenseValidityDate] [datetime] NULL,
	[ClientType] [nvarchar](max) NULL,
	[Implementer] [nvarchar](max) NULL,
	[isActive] [int] NULL,
	[isDeleted] [int] NULL,
	[Flg_Dash] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL,
	[OnebeatLicense] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_ClientTicketActionDDLValues]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_ClientTicketActionDDLValues](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TaskStatusValue] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_DHS_TicketCycleTimeRep]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_DHS_TicketCycleTimeRep](
	[TM] [nvarchar](max) NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[1-5Days] [int] NULL,
	[1-10Days] [int] NULL,
	[1-20Days] [int] NULL,
	[1-30Days] [int] NULL,
	[Over 30 Days] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_EmailList]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_EmailList](
	[id] [int] NOT NULL,
	[ClientName] [nvarchar](500) NULL,
	[UserName] [nvarchar](100) NULL,
	[LicenseDate] [date] NULL,
	[DaysLeft] [int] NULL,
	[Ind] [int] NOT NULL,
	[FeesPendingAmount] [int] NULL,
	[ExpensePendingAmount] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_eod]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_eod](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Project] [nvarchar](max) NULL,
	[TaskCategory] [nvarchar](max) NULL,
	[TaskType] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[EOD_Date] [datetime] NULL,
	[isActive] [int] NULL,
	[Hours] [int] NULL,
	[Minutes] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_eod_TaskCatDDLValues]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_eod_TaskCatDDLValues](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Priorityvalue] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_FKTypeDDLValues]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_FKTypeDDLValues](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TickTypeValue] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_DeactivationPolicy]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_DeactivationPolicy](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[EventName] [nvarchar](100) NULL,
	[LocationId] [int] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[IsDeactivated] [bit] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [datetime] NULL,
	[isrowedit1] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_HolidayList]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_HolidayList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[LocId] [int] NULL,
	[Date] [date] NULL,
	[ReplType] [nvarchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_Locations]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_Locations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[LocationCode] [int] NULL,
	[LocationDescription] [nvarchar](200) NULL,
	[LocationType] [nvarchar](15) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[Region] [nvarchar](50) NULL,
	[Pincode] [nvarchar](15) NULL,
	[DefaultOrigin] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[AutoInDays] [int] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [datetime] NULL,
	[ReplWeekDays] [nvarchar](max) NULL,
	[LocationPriority] [int] NOT NULL,
	[ReplPolicyName] [nvarchar](max) NOT NULL,
	[IsSmartReplAcitve] [bit] NOT NULL,
	[ReplHoldDays] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_Locations_temp]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_Locations_temp](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[LocationCode] [nvarchar](max) NULL,
	[LocationDescription] [nvarchar](max) NULL,
	[LocationType] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[State] [nvarchar](max) NULL,
	[Region] [nvarchar](max) NULL,
	[Pincode] [nvarchar](max) NULL,
	[DefaultOrigin] [nvarchar](max) NULL,
	[AutoInDays] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[ReplWeekDays] [nvarchar](max) NULL,
	[LocationPriority] [nvarchar](max) NULL,
	[ReplPolicyName] [nvarchar](max) NULL,
	[IsSmartReplAcitve] [nvarchar](max) NULL,
	[ReplHoldDays] [nvarchar](max) NULL,
	[IsValid] [int] NULL,
	[Reason] [nvarchar](max) NULL,
	[UserName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_LocationSkus]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_LocationSkus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [int] NULL,
	[SkuId] [nvarchar](50) NULL,
	[SkuDescription] [nvarchar](200) NULL,
	[BufferSize] [float] NULL,
	[ReplTime] [int] NULL,
	[UomId] [nvarchar](max) NULL,
	[InvAtStite] [float] NULL,
	[InvAtTransit] [float] NULL,
	[InvAtProduction] [float] NULL,
	[DispOriginId1] [int] NULL,
	[DispOriginId2] [int] NULL,
	[DispOriginId3] [int] NULL,
	[MinReplenishmentQty] [int] NULL,
	[ReplenishmentMultiples] [int] NULL,
	[IsReplenish] [bit] NULL,
	[UpdateDate] [datetime] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_LocationSkus_temp]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_LocationSkus_temp](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [nvarchar](max) NULL,
	[SkuId] [nvarchar](50) NULL,
	[SkuDescription] [nvarchar](200) NULL,
	[BufferSize] [nvarchar](max) NULL,
	[ReplTime] [nvarchar](max) NULL,
	[UomId] [nvarchar](max) NULL,
	[InvAtStite] [nvarchar](max) NULL,
	[InvAtTransit] [nvarchar](max) NULL,
	[InvAtProduction] [nvarchar](max) NULL,
	[DispOriginId1] [nvarchar](max) NULL,
	[DispOriginId2] [nvarchar](max) NULL,
	[DispOriginId3] [nvarchar](max) NULL,
	[MinReplenishmentQty] [nvarchar](max) NULL,
	[ReplenishmentMultiples] [nvarchar](max) NULL,
	[IsReplenish] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[Username] [nvarchar](100) NULL,
	[Isvalid] [int] NULL,
	[reason] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_ReplenishmentPolicy]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_ReplenishmentPolicy](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[PolicyName] [nvarchar](max) NOT NULL,
	[Mon] [bit] NULL,
	[Tue] [bit] NULL,
	[Wed] [bit] NULL,
	[Thur] [bit] NULL,
	[Fri] [bit] NULL,
	[Sat] [bit] NULL,
	[Sun] [bit] NULL,
	[AllDays] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_Skus]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_Skus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[SkuCode] [nvarchar](50) NULL,
	[SkuDescription] [nvarchar](300) NULL,
	[UpdateDate] [datetime] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_Skus_temp]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_Skus_temp](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[SkuCode] [nvarchar](50) NULL,
	[SkuDescription] [nvarchar](300) NULL,
	[CreatedDate] [datetime] NULL,
	[IsValid] [int] NULL,
	[Reason] [nvarchar](max) NULL,
	[UserName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_StmPolicy]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_StmPolicy](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[PolicyName] [nvarchar](max) NOT NULL,
	[PolicyState] [nvarchar](max) NULL,
	[IncreaseByPerc] [float] NULL,
	[DecreaseByPerc] [float] NULL,
	[IncreaseTrigger] [float] NULL,
	[DecreaseTrigger] [float] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_Transactions]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_Transactions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TransType] [nvarchar](15) NULL,
	[FromLocationCode] [int] NULL,
	[ToLocationCode] [int] NULL,
	[SkuCode] [int] NULL,
	[Quantity] [float] NULL,
	[FromLocationName] [nvarchar](100) NULL,
	[ToLocationName] [nvarchar](100) NULL,
	[TransNum] [nvarchar](100) NULL,
	[UpdateDate] [datetime] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsConsumption] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_gms_UOM]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_UOM](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[UOM] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_OnHoldReason]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_OnHoldReason](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Reason] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_Taskheader]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_Taskheader](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[ClientID] [int] NULL,
	[th_TaskHeader] [nvarchar](max) NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[EstDueDate] [datetime] NULL,
	[th_Remarks] [nvarchar](max) NULL,
	[TimeBuffer] [nvarchar](max) NULL,
	[BlackExcedDays] [int] NULL,
	[Color1] [nvarchar](max) NULL,
	[Color2] [nvarchar](max) NULL,
	[Color3] [nvarchar](max) NULL,
	[isActive] [int] NULL,
	[AccessToUser] [nvarchar](max) NULL,
	[ShareToUser] [nvarchar](max) NULL,
	[ScheduleType] [int] NULL,
	[TaskDuration] [float] NULL,
	[TaskActStartDt] [datetime] NULL,
	[TaskActEstDt] [datetime] NULL,
	[PlannedStartDt] [datetime] NULL,
	[Reason] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[ActualFinishDate] [datetime] NULL,
	[OnHoldReason] [nvarchar](max) NULL,
	[TicketCatg1] [nvarchar](max) NULL,
	[ActualDuration] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL,
	[td_SeqNo] [float] NULL,
	[ActFinishDate] [datetime] NULL,
	[FKBy] [nvarchar](max) NULL,
	[th_SeqNo] [int] NULL,
	[isEdit] [int] NULL,
	[Sprint] [nvarchar](max) NULL,
	[CommittedDate] [datetime] NULL,
	[ClientClosureAcceptance] [nvarchar](max) NULL,
	[ClientClosureAcceptanceDate] [datetime] NULL,
	[AssignToMain] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_Taskheader_20240329]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_Taskheader_20240329](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[ClientID] [int] NULL,
	[th_TaskHeader] [nvarchar](max) NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[EstDueDate] [datetime] NULL,
	[th_Remarks] [nvarchar](max) NULL,
	[TimeBuffer] [nvarchar](max) NULL,
	[BlackExcedDays] [int] NULL,
	[Color1] [nvarchar](max) NULL,
	[Color2] [nvarchar](max) NULL,
	[Color3] [nvarchar](max) NULL,
	[isActive] [int] NULL,
	[AccessToUser] [nvarchar](max) NULL,
	[ShareToUser] [nvarchar](max) NULL,
	[ScheduleType] [int] NULL,
	[TaskDuration] [float] NULL,
	[TaskActStartDt] [datetime] NULL,
	[TaskActEstDt] [datetime] NULL,
	[PlannedStartDt] [datetime] NULL,
	[Reason] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[ActualFinishDate] [datetime] NULL,
	[OnHoldReason] [nvarchar](max) NULL,
	[TicketCatg1] [nvarchar](max) NULL,
	[ActualDuration] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL,
	[td_SeqNo] [float] NULL,
	[ActFinishDate] [datetime] NULL,
	[FKBy] [nvarchar](max) NULL,
	[th_SeqNo] [int] NULL,
	[isEdit] [int] NULL,
	[Sprint] [nvarchar](max) NULL,
	[CommittedDate] [datetime] NULL,
	[ClientClosureAcceptance] [nvarchar](max) NULL,
	[ClientClosureAcceptanceDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_Taskheader_test]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_Taskheader_test](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[ClientID] [int] NULL,
	[th_TaskHeader] [nvarchar](max) NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[EstDueDate] [datetime] NULL,
	[th_Remarks] [nvarchar](max) NULL,
	[TimeBuffer] [nvarchar](max) NULL,
	[BlackExcedDays] [int] NULL,
	[Color1] [nvarchar](max) NULL,
	[Color2] [nvarchar](max) NULL,
	[Color3] [nvarchar](max) NULL,
	[isActive] [int] NULL,
	[AccessToUser] [nvarchar](max) NULL,
	[ShareToUser] [nvarchar](max) NULL,
	[ScheduleType] [int] NULL,
	[TaskDuration] [float] NULL,
	[TaskActStartDt] [datetime] NULL,
	[TaskActEstDt] [datetime] NULL,
	[PlannedStartDt] [datetime] NULL,
	[Reason] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[ActualFinishDate] [datetime] NULL,
	[OnHoldReason] [nvarchar](max) NULL,
	[TicketCatg1] [nvarchar](max) NULL,
	[ActualDuration] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL,
	[td_SeqNo] [float] NULL,
	[ActFinishDate] [datetime] NULL,
	[FKBy] [nvarchar](max) NULL,
	[th_SeqNo] [int] NULL,
	[isEdit] [int] NULL,
	[Sprint] [nvarchar](max) NULL,
	[CommittedDate] [datetime] NULL,
	[AssignTo] [nvarchar](max) NULL,
	[Assigntoemail] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_TaskHeader_Trace]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_TaskHeader_Trace](
	[id] [int] NULL,
	[ClientID] [int] NULL,
	[th_TaskHeader] [nvarchar](max) NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[EstDueDate] [datetime] NULL,
	[th_Remarks] [nvarchar](max) NULL,
	[TimeBuffer] [nvarchar](max) NULL,
	[BlackExcedDays] [int] NULL,
	[Color1] [nvarchar](max) NULL,
	[Color2] [nvarchar](max) NULL,
	[Color3] [nvarchar](max) NULL,
	[isActive] [int] NULL,
	[AccessToUser] [nvarchar](max) NULL,
	[ShareToUser] [nvarchar](max) NULL,
	[ScheduleType] [int] NULL,
	[TaskDuration] [float] NULL,
	[TaskActStartDt] [datetime] NULL,
	[TaskActEstDt] [datetime] NULL,
	[PlannedStartDt] [datetime] NULL,
	[Reason] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[ActualFinishDate] [datetime] NULL,
	[OnHoldReason] [nvarchar](max) NULL,
	[TicketCatg1] [nvarchar](max) NULL,
	[ActualDuration] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL,
	[Action] [nvarchar](20) NULL,
	[RecordDate] [datetime] NULL,
	[td_SeqNo] [float] NULL,
	[ActFinishDate] [datetime] NULL,
	[FKBy] [nvarchar](max) NULL,
	[th_SeqNo] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_TaskStatusDDLValues]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_TaskStatusDDLValues](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TaskStatusValue] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_TaskStatusDDLValues_20231214]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_TaskStatusDDLValues_20231214](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TaskStatusValue] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_TaskStatusDDLValuesST]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_TaskStatusDDLValuesST](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TaskStatusValue] [nvarchar](max) NULL,
	[CatgRank] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_tasksupdatedfromOutside]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_tasksupdatedfromOutside](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Taskid] [int] NULL,
	[ColumnName] [nvarchar](max) NULL,
	[CurrentValue] [nvarchar](max) NULL,
	[NewCurrentValue] [nvarchar](max) NULL,
	[ProcessDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_tb_DailyTaskEmails]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_tb_DailyTaskEmails](
	[Ticket] [int] NOT NULL,
	[ClientName] [nvarchar](max) NULL,
	[MainTask] [nvarchar](max) NULL,
	[Activity] [nvarchar](max) NULL,
	[Activity_TaskStatus] [nvarchar](max) NULL,
	[Main_TaskStatus] [nvarchar](max) NULL,
	[Committed] [nvarchar](max) NULL,
	[Color] [nvarchar](max) NULL,
	[Owner] [nvarchar](max) NULL,
	[UserEmail] [nvarchar](max) NULL,
	[ManagerEmail] [varchar](31) NOT NULL,
	[SendFlg] [int] NOT NULL,
	[ProcessDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_tb_DailyTaskEmails_CountToEmail]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_tb_DailyTaskEmails_CountToEmail](
	[Owner] [nvarchar](max) NULL,
	[TaskType] [nvarchar](max) NULL,
	[Nos] [int] NULL,
	[NS] [int] NULL,
	[IP] [int] NULL,
	[Red] [int] NULL,
	[Black] [int] NULL,
	[Non_RB] [int] NULL,
	[Status] [int] NOT NULL,
	[Ttl_Red] [nvarchar](5) NULL,
	[Ttl_Black] [nvarchar](5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_tb_DailyTaskEmails_SummaryToEmail]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_tb_DailyTaskEmails_SummaryToEmail](
	[Ticket] [int] NOT NULL,
	[Client] [nvarchar](max) NULL,
	[TaskName] [nvarchar](max) NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[ColorPriority] [nvarchar](max) NULL,
	[Owner] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Status] [int] NOT NULL,
	[Type] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_tb_test1]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_tb_test1](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[TaskName] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_TickTypeDDLValues]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_TickTypeDDLValues](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TickTypeValue] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_UserLicMapping]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_UserLicMapping](
	[ClientId] [int] NULL,
	[UserName] [nvarchar](100) NULL,
	[UserEmail] [nvarchar](100) NULL,
	[Ind01] [int] NULL,
	[ClientName] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[DaysLeft] [int] NULL,
	[LicenseValidityDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obp_UsersExtended]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_UsersExtended](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Username] [nvarchar](max) NULL,
	[Type] [nvarchar](100) NULL,
	[ReportingTo] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_CalculatedColAttrib]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_CalculatedColAttrib](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ColName] [nvarchar](max) NOT NULL,
	[DisplayName] [nvarchar](max) NULL,
	[ColColor] [nvarchar](max) NULL,
	[GridId] [nvarchar](max) NULL,
	[ColumnWidth] [nvarchar](max) NULL,
	[LinkId] [int] NULL,
	[SortIndex] [int] NULL,
	[SortOrder] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBY] [nvarchar](max) NULL,
	[ModifiedBy] [nvarchar](max) NULL,
	[IsActive] [int] NULL,
	[IsDeleted] [int] NULL,
	[IsMobile] [int] NULL,
	[ToolTip] [nvarchar](max) NULL,
	[SummaryType] [nvarchar](100) NULL,
	[FormatCondIconId] [int] NULL,
	[MinVal] [int] NULL,
	[MaxVal] [int] NULL,
	[IsRefreshDDL] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_CalculatedRowAttrib]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_CalculatedRowAttrib](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ColName] [nvarchar](max) NOT NULL,
	[MappedCol] [nvarchar](max) NOT NULL,
	[GridId] [int] NULL,
	[IsBackground] [int] NULL,
	[CellEditColName] [nvarchar](max) NULL,
	[LinkId] [int] NULL,
	[CellCtrlTypeColName] [nvarchar](max) NULL,
	[DdlCtrlSpColName] [nvarchar](max) NULL,
 CONSTRAINT [PK_obps_CalculatedRowAttrib] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_Charts]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_Charts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DivSp] [nvarchar](max) NOT NULL,
	[DivTitle] [nvarchar](max) NOT NULL,
	[Div1Charttype] [nvarchar](max) NULL,
	[Div2Charttype] [nvarchar](max) NULL,
	[Div3Charttype] [nvarchar](max) NULL,
	[Div4Charttype] [nvarchar](max) NULL,
	[Div5Charttype] [nvarchar](max) NULL,
	[Div6Charttype] [nvarchar](max) NULL,
	[Div1FilterSp] [nvarchar](max) NULL,
	[Div2FilterSp] [nvarchar](max) NULL,
	[Div3FilterSp] [nvarchar](max) NULL,
	[Div4FilterSp] [nvarchar](max) NULL,
	[Div5FilterSp] [nvarchar](max) NULL,
	[Div6FilterSp] [nvarchar](max) NULL,
	[Div1FilterText] [nvarchar](max) NULL,
	[Div2FilterText] [nvarchar](max) NULL,
	[Div3FilterText] [nvarchar](max) NULL,
	[Div4FilterText] [nvarchar](max) NULL,
	[Div5FilterText] [nvarchar](max) NULL,
	[Div6FilterText] [nvarchar](max) NULL,
	[IsSameFilter] [int] NULL,
	[DepenedentFilterDivs] [nvarchar](max) NULL,
	[IsSameChartType] [int] NULL,
	[DepenedentChartTypeDivs] [nvarchar](max) NULL,
	[LinkId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_ChartTypeMaster]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_ChartTypeMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ChartId] [int] NOT NULL,
	[Chart] [nvarchar](max) NOT NULL,
	[ChartTypes] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_ColAttrib]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_ColAttrib](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TableID] [int] NOT NULL,
	[TableName] [nvarchar](max) NOT NULL,
	[ColName] [nvarchar](max) NOT NULL,
	[DisplayName] [nvarchar](max) NOT NULL,
	[ColControlType] [nvarchar](max) NOT NULL,
	[IsEditable] [bit] NOT NULL,
	[ColColor] [nvarchar](max) NULL,
	[FontColor] [int] NULL,
	[FontAttrib] [nchar](10) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBY] [nvarchar](max) NOT NULL,
	[ModifiedBy] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DropDownLink] [nvarchar](max) NULL,
	[GridId] [int] NULL,
	[ColumnWidth] [int] NULL,
	[LinkId] [int] NULL,
	[SortIndex] [int] NULL,
	[SortOrder] [nvarchar](max) NULL,
	[ToolTip] [nvarchar](max) NULL,
	[SummaryType] [nvarchar](100) NULL,
	[IsMobile] [int] NULL,
	[IsRequired] [int] NULL,
	[FormatCondIconId] [int] NULL,
	[MinVal] [int] NULL,
	[MaxVal] [int] NULL,
	[IsValidation] [bit] NULL,
	[DependentDDLColid] [int] NULL,
	[IsRefreshDDL] [int] NULL,
	[ValidationSP] [nvarchar](max) NULL,
 CONSTRAINT [PK_Obp_ColAttrib] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_ColorPicker]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_ColorPicker](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Color] [nvarchar](max) NOT NULL,
	[HexCode] [nvarchar](max) NOT NULL,
	[ColorID] [int] NULL,
 CONSTRAINT [PK_Obp_ColorPicker] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_ControlTypes]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_ControlTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ControlType] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_obps_ControlTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_CreateTableTemp]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_CreateTableTemp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ColumnName] [nvarchar](max) NULL,
	[DataType] [nvarchar](max) NULL,
	[AllowNulls] [nvarchar](max) NULL,
	[DefaultValue] [nvarchar](max) NULL,
	[UserColumn] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_Dashboards]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_Dashboards](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Dashboard] [varbinary](max) NULL,
	[Caption] [nvarchar](255) NULL,
	[LinkId] [int] NULL,
 CONSTRAINT [PK_Dashboards] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_DropDownTable]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_DropDownTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ColumnId] [int] NOT NULL,
	[ColumnToInsert] [nvarchar](max) NULL,
	[ColumnToSelect] [nvarchar](max) NULL,
	[TableToSelect] [nvarchar](max) NULL,
	[IsId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_ExcelImportConfig]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_ExcelImportConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LinkId] [int] NOT NULL,
	[TableName] [nvarchar](max) NOT NULL,
	[TempTableName] [nvarchar](max) NOT NULL,
	[InsertSp] [nvarchar](max) NULL,
	[GenFileSp] [nvarchar](max) NULL,
	[DeleteSp] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_FileUpload]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_FileUpload](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AutoId] [int] NULL,
	[FileName] [nvarchar](max) NULL,
	[Username] [nvarchar](max) NULL,
	[FilePath] [nvarchar](max) NULL,
	[FileNameDesc] [nvarchar](max) NULL,
	[Linkid] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_FileUploadedHistory]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_FileUploadedHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[FileName] [nvarchar](max) NOT NULL,
	[Size] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[FilePath] [nvarchar](max) NOT NULL,
	[LinkId] [nvarchar](max) NOT NULL,
	[UploadedDate] [date] NULL,
	[BatchId] [int] NULL,
 CONSTRAINT [PK_obps_FileUploadedHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_FormatCondIcon]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_FormatCondIcon](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Icon] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_GanttConfig]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_GanttConfig](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Linkid] [int] NOT NULL,
	[Tablename] [nvarchar](max) NOT NULL,
	[SubjectColName] [nvarchar](max) NOT NULL,
	[StartColName] [nvarchar](max) NOT NULL,
	[EndColName] [nvarchar](max) NOT NULL,
	[PredecessorIdColName] [nvarchar](max) NULL,
	[SuccessorIdColName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_GlobalConfig]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_GlobalConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Variables] [nvarchar](max) NULL,
	[Value] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_HelpDoc]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_HelpDoc](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NULL,
	[GroupName] [nvarchar](max) NULL,
	[DisplayName] [nvarchar](max) NULL,
	[FileName] [nvarchar](max) NULL,
	[IsActive] [int] NULL,
	[UserType] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_JobExecutionHistory]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_JobExecutionHistory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Linkid] [int] NULL,
	[Jobname] [nvarchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_LocationConfig]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_LocationConfig](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[linkid] [nvarchar](50) NULL,
	[LocationColName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_MenuName]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_MenuName](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MenuId]  AS ([Id]),
	[DisplayName] [nvarchar](max) NOT NULL,
	[IsVisible] [int] NOT NULL,
	[DisplayOrder] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_MobAfterLogin]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_MobAfterLogin](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AfterLoginSp] [nvarchar](max) NOT NULL,
	[Roleid] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_MobileConfig]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_MobileConfig](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Ddl1Sp] [nvarchar](max) NULL,
	[Ddl2Sp] [nvarchar](max) NULL,
	[Ddl3Sp] [nvarchar](max) NULL,
	[Linkid] [int] NULL,
	[ddl1text] [nvarchar](max) NULL,
	[ddl2text] [nvarchar](max) NULL,
	[ddl3text] [nvarchar](max) NULL,
	[GridDdlReq] [int] NULL,
	[GridDdlSp] [nvarchar](max) NULL,
	[IsGrid2Required] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_NonWorkingDays]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_NonWorkingDays](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[NonWorkingDays] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_PageLayout]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_PageLayout](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LayoutName] [nvarchar](max) NOT NULL,
	[SpName] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NOT NULL,
	[IsActive] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_PageType]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_PageType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PageType] [nvarchar](max) NOT NULL,
	[PageTypeId] [int] NULL,
	[GridCount] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_ReportLayout]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_ReportLayout](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DisplayName] [nvarchar](max) NULL,
	[LayoutData] [nvarchar](max) NULL,
	[LinkId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_RoleMap]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_RoleMap](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[TableID] [int] NOT NULL,
	[ColName] [nvarchar](max) NOT NULL,
	[IsEditable] [bit] NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[TableName] [nvarchar](max) NULL,
	[Displayorder] [int] NULL,
	[gridid] [int] NULL,
	[IsMobile] [int] NULL,
	[LinkId] [int] NULL,
	[IsVisible] [int] NULL,
	[VisibilityIndex] [int] NULL,
 CONSTRAINT [PK_Obp_RoleMap] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_RoleMaster]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_RoleMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NULL,
	[LinkId] [int] NULL,
	[RoleDescription] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_RowAttrib]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_RowAttrib](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TableID] [int] NOT NULL,
	[TableName] [nvarchar](max) NOT NULL,
	[ColName] [nvarchar](max) NOT NULL,
	[MappedCol] [nvarchar](max) NOT NULL,
	[GridId] [int] NULL,
	[IsBackground] [int] NULL,
	[CellEditColName] [nvarchar](max) NULL,
	[LinkId] [int] NULL,
	[CellCtrlTypeColName] [nvarchar](max) NULL,
	[DdlCtrlSpColName] [nvarchar](max) NULL,
 CONSTRAINT [PK_Obp_RowAttrib] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_SchedulerDataMappingConfig]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_SchedulerDataMappingConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TextCol] [nvarchar](max) NULL,
	[StartdateCol] [nvarchar](max) NULL,
	[EnddateCol] [nvarchar](max) NULL,
	[SchedulerTypeCol] [nvarchar](max) NULL,
	[LinkId] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_SpPermissions]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_SpPermissions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Linkid] [int] NULL,
	[Gridid] [int] NULL,
	[Par1] [nvarchar](max) NULL,
	[Par2] [nvarchar](max) NULL,
	[Par3] [nvarchar](max) NULL,
	[Par4] [nvarchar](max) NULL,
	[Par5] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_SpPermissions_20231206]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_SpPermissions_20231206](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Linkid] [int] NULL,
	[Gridid] [int] NULL,
	[Par1] [nvarchar](max) NULL,
	[Par2] [nvarchar](max) NULL,
	[Par3] [nvarchar](max) NULL,
	[Par4] [nvarchar](max) NULL,
	[Par5] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_SubLayout]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_SubLayout](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LayoutId] [int] NOT NULL,
	[SubLayoutValues] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_TableDataTypes]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_TableDataTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DataType] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_obps_TableDataTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_TableId]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_TableId](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](max) NOT NULL,
	[TableId] [int] NOT NULL,
	[TableKey] [nvarchar](max) NULL,
	[TableUserCol] [nvarchar](max) NULL,
	[ForeignKey] [nvarchar](500) NULL,
	[GridId] [int] NULL,
	[LinkId] [int] NULL,
 CONSTRAINT [PK_Obj_TableId] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_TopLinkExtended]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_TopLinkExtended](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Linkid] [int] NULL,
	[TabId] [int] NULL,
	[TabText] [nvarchar](max) NULL,
	[TabType] [varchar](1) NULL,
	[GridId] [int] NULL,
	[GridSp] [nvarchar](max) NULL,
	[GridTable] [nvarchar](max) NULL,
	[AllowAdd] [int] NULL,
	[AllowEdit] [int] NULL,
	[AllowDelete] [int] NULL,
	[DeleteSp] [nvarchar](max) NULL,
	[AfterSaveSp] [nvarchar](max) NULL,
	[AllowToolbar] [int] NULL,
	[IsExport] [int] NULL,
	[AllowFilterRow] [int] NULL,
	[AllowheaderFilter] [int] NULL,
	[AllowColumnChooser] [int] NULL,
	[AllowGroupPanel] [int] NULL,
	[RefreshEnabled] [int] NULL,
	[RefreshSp] [nvarchar](max) NULL,
	[IsYellowBtn] [int] NULL,
	[YellowBtnSp] [nvarchar](max) NULL,
	[IsGreenBtn] [int] NULL,
	[GreenBtnSp] [nvarchar](max) NULL,
	[IsRedBtn] [int] NULL,
	[RedBtnSp] [nvarchar](max) NULL,
	[AllowPaging] [int] NULL,
	[IsFormEdit] [int] NULL,
	[DependentGrid] [int] NULL,
	[AllowHScrollBar] [int] NULL,
	[CustomContextMenuTxt1] [nvarchar](max) NULL,
	[CustomContextMenuLinkId1] [nvarchar](max) NULL,
	[CustomContextMenuTxt2] [nvarchar](max) NULL,
	[CustomContextMenuLinkId2] [nvarchar](max) NULL,
	[CustomContextMenuTxt3] [nvarchar](max) NULL,
	[CustomContextMenuLinkId3] [nvarchar](max) NULL,
	[ToolBarDDLTxt1] [nvarchar](max) NULL,
	[ToolBarDDLTxt2] [nvarchar](max) NULL,
	[ToolBarDDLTxt3] [nvarchar](max) NULL,
	[ToolBarDDLSp1] [nvarchar](max) NULL,
	[ToolBarDDLSp2] [nvarchar](max) NULL,
	[ToolBarDDLSp3] [nvarchar](max) NULL,
	[ShowJobHistory] [int] NULL,
	[ValidationSp] [nvarchar](500) NULL,
	[GridRowButtonSp] [nvarchar](max) NULL,
	[GridRowButtonText] [nvarchar](max) NULL,
	[GridRowButtonColWidth] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_TopLinkExtended_temp]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_TopLinkExtended_temp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Linkid] [int] NULL,
	[TabId] [int] NULL,
	[TabText] [nvarchar](max) NULL,
	[TabType] [varchar](1) NULL,
	[GridId] [int] NULL,
	[GridSp] [nvarchar](max) NULL,
	[GridTable] [nvarchar](max) NULL,
	[AllowAdd] [int] NULL,
	[AllowEdit] [int] NULL,
	[AllowDelete] [int] NULL,
	[DeleteSp] [nvarchar](max) NULL,
	[AfterSaveSp] [nvarchar](max) NULL,
	[AllowToolbar] [int] NULL,
	[IsExport] [int] NULL,
	[AllowFilterRow] [int] NULL,
	[AllowheaderFilter] [int] NULL,
	[AllowColumnChooser] [int] NULL,
	[AllowGroupPanel] [int] NULL,
	[RefreshEnabled] [int] NULL,
	[RefreshSp] [nvarchar](max) NULL,
	[IsYellowBtn] [int] NULL,
	[YellowBtnSp] [nvarchar](max) NULL,
	[IsGreenBtn] [int] NULL,
	[GreenBtnSp] [nvarchar](max) NULL,
	[IsRedBtn] [int] NULL,
	[RedBtnSp] [nvarchar](max) NULL,
	[AllowPaging] [int] NULL,
	[IsFormEdit] [int] NULL,
	[DependentGrid] [int] NULL,
	[AllowHScrollBar] [int] NULL,
	[CustomContextMenuLinkId1] [int] NULL,
	[CustomContextMenuLinkId2] [int] NULL,
	[CustomContextMenuLinkId3] [int] NULL,
	[CustomContextMenuTxt1] [nvarchar](max) NULL,
	[CustomContextMenuTxt2] [nvarchar](max) NULL,
	[CustomContextMenuTxt3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_TopLinks]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_TopLinks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LinkName] [nvarchar](max) NOT NULL,
	[Type] [int] NULL,
	[MenuId] [int] NULL,
	[SortOrder] [int] NULL,
	[IsAfterLogin] [int] NULL,
	[IsImportEnabled] [int] NULL,
	[IsUploadEnabled] [int] NULL,
	[UploadPath] [nvarchar](max) NULL,
	[ImportErrorOutSp] [nvarchar](max) NULL,
	[ImportSavedOutSp] [nvarchar](max) NULL,
	[IsMobile] [int] NULL,
	[EnableUniversalSearch] [int] NULL,
	[ImportHelp] [nvarchar](max) NULL,
	[AllowedExtension] [nvarchar](max) NULL,
	[IsDependentTab] [int] NULL,
	[IsLocation] [int] NULL,
	[DdlSp] [nvarchar](max) NULL,
	[IsSamePage] [int] NULL,
	[TriggerGrid] [nvarchar](max) NULL,
	[RefreshGrid] [nvarchar](max) NULL,
	[ConditionalCRUDBtn] [nvarchar](max) NULL,
	[CondCRUDBtnAddSp] [nvarchar](max) NULL,
	[CondCRUDBtnEditSp] [nvarchar](max) NULL,
	[CondCRUDBtnDeleteSp] [nvarchar](max) NULL,
	[IsSpreadSheet] [int] NULL,
	[IsPivot] [int] NULL,
	[SchedulerTypeSP] [nvarchar](max) NULL,
	[IsExportToCsv] [int] NULL,
	[CSVSeperator] [nvarchar](5) NULL,
	[AllowPivotFieldChooser] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_toplinks_temp]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_toplinks_temp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LinkName] [nvarchar](max) NOT NULL,
	[Type] [int] NULL,
	[MenuId] [int] NULL,
	[SortOrder] [int] NULL,
	[IsAfterLogin] [int] NULL,
	[IsImportEnabled] [int] NULL,
	[ImportErrorOutSp] [nvarchar](max) NULL,
	[ImportSavedOutSp] [nvarchar](max) NULL,
	[IsMobile] [int] NULL,
	[EnableUniversalSearch] [int] NULL,
	[ImportHelp] [nvarchar](max) NULL,
	[AllowedExtension] [nvarchar](max) NULL,
	[IsLocation] [int] NULL,
	[DdlSp] [nvarchar](max) NULL,
	[IsSamePage] [int] NULL,
	[TriggerGrid] [nvarchar](max) NULL,
	[RefreshGrid] [nvarchar](max) NULL,
	[ConditionalCRUDBtn] [nvarchar](max) NULL,
	[CondCRUDBtnAddSp] [nvarchar](max) NULL,
	[CondCRUDBtnEditSp] [nvarchar](max) NULL,
	[CondCRUDBtnDeleteSp] [nvarchar](max) NULL,
	[IsSpreadSheet] [int] NULL,
	[IsPivot] [int] NULL,
	[SchedulerTypeSP] [nvarchar](max) NULL,
	[IsExportToCsv] [int] NULL,
	[CSVSeperator] [nvarchar](5) NULL,
	[originallinkid] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_UserLinks]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_UserLinks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[UserName] [nvarchar](max) NULL,
	[LinkId] [int] NOT NULL,
	[LinkName] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[ModifiedBy] [nvarchar](max) NULL,
	[IsActive] [int] NOT NULL,
	[IsDeleted] [int] NOT NULL,
	[RoleId] [int] NULL,
	[sublinkid] [int] NULL,
	[IsRoleAttached] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_Userlinks_20231206]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_Userlinks_20231206](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[UserName] [nvarchar](max) NULL,
	[LinkId] [int] NOT NULL,
	[LinkName] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[ModifiedBy] [nvarchar](max) NULL,
	[IsActive] [int] NOT NULL,
	[IsDeleted] [int] NOT NULL,
	[RoleId] [int] NULL,
	[sublinkid] [int] NULL,
	[IsRoleAttached] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_Users]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[RoleId] [nvarchar](max) NOT NULL,
	[Company] [nvarchar](max) NULL,
	[Division] [nvarchar](max) NULL,
	[Department] [nvarchar](max) NULL,
	[SubDept] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[UserTypeId] [int] NULL,
	[DefaultLinkId] [int] NULL,
	[PrefLang] [bit] NULL,
	[AfterLoginSP] [nvarchar](max) NULL,
	[Permission] [nvarchar](max) NULL,
	[ReportingManager] [nvarchar](max) NULL,
	[IsResetPassword] [int] NULL,
	[EmailId] [nvarchar](max) NULL,
 CONSTRAINT [PK_Obp_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_Users_20231206]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_Users_20231206](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[RoleId] [nvarchar](max) NOT NULL,
	[Company] [nvarchar](max) NULL,
	[Division] [nvarchar](max) NULL,
	[Department] [nvarchar](max) NULL,
	[SubDept] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[UserTypeId] [int] NULL,
	[DefaultLinkId] [int] NULL,
	[PrefLang] [bit] NULL,
	[AfterLoginSP] [nvarchar](max) NULL,
	[Permission] [nvarchar](max) NULL,
	[ReportingManager] [nvarchar](max) NULL,
	[IsResetPassword] [int] NULL,
	[EmailId] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_Users_temp]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_Users_temp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[RoleId] [nvarchar](max) NOT NULL,
	[Company] [nvarchar](max) NULL,
	[Division] [nvarchar](max) NULL,
	[Department] [nvarchar](max) NULL,
	[SubDept] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[UserTypeId] [int] NULL,
	[DefaultLinkId] [int] NULL,
	[PrefLang] [bit] NULL,
	[AfterLoginSP] [nvarchar](max) NULL,
	[Permission] [nvarchar](max) NULL,
	[ReportingManager] [nvarchar](max) NULL,
	[EmailId] [nvarchar](max) NULL,
	[originaluser] [nvarchar](max) NULL,
 CONSTRAINT [PK_obps_Users_temp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_UserType]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_UserType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[UserType] [nvarchar](max) NOT NULL,
	[UserTypeDesc] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_obp_usertype] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obps_ValidColumnsForImport]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_ValidColumnsForImport](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](500) NULL,
	[ColumnName] [nvarchar](500) NULL,
	[DataType] [nvarchar](500) NULL,
	[LinkId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableNameTab]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableNameTab](
	[table_name] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tb_NewOrdersEmail]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_NewOrdersEmail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Distributor] [nvarchar](200) NULL,
	[DealerName] [nvarchar](200) NULL,
	[DemandNo] [nvarchar](100) NULL,
	[MaterialDescription] [nvarchar](200) NULL,
	[Qty] [decimal](18, 2) NULL,
	[OrderDate] [date] NULL,
	[Email] [nvarchar](200) NULL,
	[ind01] [int] NULL,
	[OrderStatus] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tb_test1]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_test1](
	[id] [int] NULL,
	[CustomerName] [nvarchar](100) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT ((1)) FOR [Flg_Dash]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT ((1)) FOR [OnebeatLicense]
GO
ALTER TABLE [dbo].[obp_eod] ADD  CONSTRAINT [DF__obp_eod__EOD_Dat__297722B6]  DEFAULT (getdate()) FOR [EOD_Date]
GO
ALTER TABLE [dbo].[obp_eod] ADD  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[obp_eod] ADD  DEFAULT ((0)) FOR [Hours]
GO
ALTER TABLE [dbo].[obp_eod] ADD  DEFAULT ((0)) FOR [Minutes]
GO
ALTER TABLE [dbo].[obp_eod] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obp_gms_DeactivationPolicy] ADD  DEFAULT ((1)) FOR [isrowedit1]
GO
ALTER TABLE [dbo].[obp_gms_Locations] ADD  DEFAULT ((0)) FOR [LocationPriority]
GO
ALTER TABLE [dbo].[obp_gms_Locations] ADD  DEFAULT ('ALL') FOR [ReplPolicyName]
GO
ALTER TABLE [dbo].[obp_gms_Locations] ADD  DEFAULT ((0)) FOR [IsSmartReplAcitve]
GO
ALTER TABLE [dbo].[obp_gms_Locations] ADD  DEFAULT ((0)) FOR [ReplHoldDays]
GO
ALTER TABLE [dbo].[obp_gms_ReplenishmentPolicy] ADD  DEFAULT ((1)) FOR [AllDays]
GO
ALTER TABLE [dbo].[obp_gms_ReplenishmentPolicy] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obp_gms_StmPolicy] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obp_gms_UOM] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  CONSTRAINT [df_TaskStatus]  DEFAULT ('NS') FOR [TaskStatus]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  DEFAULT ((0)) FOR [BlackExcedDays]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  DEFAULT ((1)) FOR [ScheduleType]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  DEFAULT ((0)) FOR [ParentId]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  DEFAULT ((0)) FOR [ActualDuration]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  DEFAULT ('N') FOR [FKBy]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  DEFAULT ((1)) FOR [isEdit]
GO
ALTER TABLE [dbo].[obp_Taskheader] ADD  CONSTRAINT [DF_Sprint_20231208]  DEFAULT ('Backlog') FOR [Sprint]
GO
ALTER TABLE [dbo].[obp_tb_test1] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obps_CalculatedColAttrib] ADD  CONSTRAINT [DF_obps_CalculatedColAttrib_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[obps_CalculatedColAttrib] ADD  CONSTRAINT [DF_obps_CalculatedColAttrib_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[obps_CalculatedColAttrib] ADD  DEFAULT ((1)) FOR [IsMobile]
GO
ALTER TABLE [dbo].[obps_CalculatedColAttrib] ADD  DEFAULT ('') FOR [ToolTip]
GO
ALTER TABLE [dbo].[obps_CalculatedColAttrib] ADD  DEFAULT ((0)) FOR [IsRefreshDDL]
GO
ALTER TABLE [dbo].[obps_CalculatedRowAttrib] ADD  DEFAULT ((0)) FOR [IsBackground]
GO
ALTER TABLE [dbo].[obps_ColAttrib] ADD  DEFAULT ('') FOR [SortOrder]
GO
ALTER TABLE [dbo].[obps_ColAttrib] ADD  DEFAULT ('') FOR [ToolTip]
GO
ALTER TABLE [dbo].[obps_ColAttrib] ADD  DEFAULT ((0)) FOR [IsRequired]
GO
ALTER TABLE [dbo].[obps_ColAttrib] ADD  DEFAULT ((0)) FOR [IsValidation]
GO
ALTER TABLE [dbo].[obps_ColAttrib] ADD  DEFAULT (NULL) FOR [DependentDDLColid]
GO
ALTER TABLE [dbo].[obps_ColAttrib] ADD  DEFAULT ((0)) FOR [IsRefreshDDL]
GO
ALTER TABLE [dbo].[obps_CreateTableTemp] ADD  DEFAULT ((0)) FOR [UserColumn]
GO
ALTER TABLE [dbo].[obps_Dashboards] ADD  DEFAULT ((0)) FOR [LinkId]
GO
ALTER TABLE [dbo].[obps_ExcelImportConfig] ADD  DEFAULT ('') FOR [GenFileSp]
GO
ALTER TABLE [dbo].[obps_FileUploadedHistory] ADD  DEFAULT ((0)) FOR [BatchId]
GO
ALTER TABLE [dbo].[obps_HelpDoc] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[obps_MenuName] ADD  CONSTRAINT [DF_obps_MenuName_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
GO
ALTER TABLE [dbo].[obps_MobileConfig] ADD  DEFAULT ((0)) FOR [GridDdlReq]
GO
ALTER TABLE [dbo].[obps_MobileConfig] ADD  DEFAULT ('') FOR [GridDdlSp]
GO
ALTER TABLE [dbo].[obps_MobileConfig] ADD  DEFAULT ((0)) FOR [IsGrid2Required]
GO
ALTER TABLE [dbo].[obps_PageType] ADD  DEFAULT ((0)) FOR [GridCount]
GO
ALTER TABLE [dbo].[obps_RoleMap] ADD  CONSTRAINT [DF_Obp_RoleMap_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obps_RoleMap] ADD  DEFAULT ((1)) FOR [IsMobile]
GO
ALTER TABLE [dbo].[obps_RowAttrib] ADD  DEFAULT ((0)) FOR [IsBackground]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((1)) FOR [TabId]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('A') FOR [TabType]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowAdd]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowEdit]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowDelete]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowToolbar]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [IsExport]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowFilterRow]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowheaderFilter]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowColumnChooser]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowGroupPanel]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [RefreshEnabled]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [IsYellowBtn]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [IsGreenBtn]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [IsRedBtn]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [AllowPaging]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((0)) FOR [IsFormEdit]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT (NULL) FOR [DependentGrid]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((1)) FOR [AllowHScrollBar]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [CustomContextMenuTxt1]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [CustomContextMenuLinkId1]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [CustomContextMenuTxt2]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [CustomContextMenuLinkId2]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [CustomContextMenuTxt3]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [CustomContextMenuLinkId3]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [ToolBarDDLTxt1]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [ToolBarDDLTxt2]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [ToolBarDDLTxt3]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [ToolBarDDLSp1]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [ToolBarDDLSp2]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ('') FOR [ToolBarDDLSp3]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT ((1)) FOR [ShowJobHistory]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT (NULL) FOR [ValidationSp]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT (NULL) FOR [GridRowButtonSp]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT (NULL) FOR [GridRowButtonText]
GO
ALTER TABLE [dbo].[obps_TopLinkExtended] ADD  DEFAULT (NULL) FOR [GridRowButtonColWidth]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ((0)) FOR [IsImportEnabled]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ((0)) FOR [IsUploadEnabled]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ((0)) FOR [IsMobile]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT (NULL) FOR [ImportHelp]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT (NULL) FOR [AllowedExtension]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ('') FOR [ConditionalCRUDBtn]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ('') FOR [CondCRUDBtnAddSp]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ('') FOR [CondCRUDBtnEditSp]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ('') FOR [CondCRUDBtnDeleteSp]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ((0)) FOR [IsSpreadSheet]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ((0)) FOR [IsPivot]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ((0)) FOR [IsExportToCsv]
GO
ALTER TABLE [dbo].[obps_TopLinks] ADD  DEFAULT ((0)) FOR [AllowPivotFieldChooser]
GO
ALTER TABLE [dbo].[obps_UserLinks] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obps_Users] ADD  CONSTRAINT [DF_obps_Users_DefaultLinkId]  DEFAULT (NULL) FOR [DefaultLinkId]
GO
ALTER TABLE [dbo].[obps_Users] ADD  DEFAULT ((0)) FOR [PrefLang]
GO
ALTER TABLE [dbo].[obps_Users] ADD  DEFAULT (NULL) FOR [AfterLoginSP]
GO
ALTER TABLE [dbo].[obps_Users_temp] ADD  CONSTRAINT [DF_obps_Users_temp_DefaultLinkId]  DEFAULT (NULL) FOR [DefaultLinkId]
GO
ALTER TABLE [dbo].[obps_Users_temp] ADD  DEFAULT ((0)) FOR [PrefLang]
GO
ALTER TABLE [dbo].[obps_Users_temp] ADD  DEFAULT (NULL) FOR [AfterLoginSP]
GO
ALTER TABLE [dbo].[tb_NewOrdersEmail] ADD  DEFAULT ((0)) FOR [ind01]
GO
/****** Object:  StoredProcedure [dbo].[Addstartandendstoreproc]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*SP created to update obp_taskheader from sharepoint*/  
CREATE   PROCEDURE [dbo].[Addstartandendstoreproc]  
-- Add the parameters for the stored procedure here 
 @TaskStartDate Datetime,  @TaskEndEstDate Datetime,  @Ticketid int,  @Duration float,  @assignto varchar(50),  @assigntoEmail varchar(50),  @Remakers Varchar(50),  @Sprint varchar(50),  @FKBY Varchar(50)   
AS BEGIN  
-- SET NOCOUNT ON added to prevent extra result sets from  
-- interfering with SELECT statements.  SET NOCOUNT ON;   
Declare @Prev@TaskStartDate date,@PrevTaskEndEstDate date  
set @Prev@TaskStartDate=(Select top 1 TaskActStartDt from obp_Taskheader_test WHERE id = @Ticketid)  set @PrevTaskEndEstDate=(Select top 1 TaskActEstDt from obp_Taskheader_test WHERE id = @Ticketid)       
-- Insert statements for procedure here  
UPDATE [dbo].[obp_Taskheader_test]  SET TaskActStartDt = @TaskStartDate,  TaskActEstDt = @TaskEndEstDate,  TaskDuration = @Duration,  FKBy = @FKBY,  th_Remarks=@Remakers,  Sprint=@Sprint,  AssignTo =@assignto,Assigntoemail =@assigntoEmail
WHERE id = @Ticketid;
exec obp_sp_MainTaskCompletionCheck @Ticketid 
/*Update the Log  insert into obp_tasksupdatedfromOutside(TaskId,Column
Name,CurrentValue,NewCurrentValue,ProcessDate)  Select id,'TaskActStartDt',cast(@Prev@TaskStartDate as varchar(21)),cast(TaskActStartDt as varchar(21)),getdate() from obp_Taskheader where id=@Ticketid   insert into obp_tasksupdatedfromOutside(TaskId,Colum
nName,CurrentValue,NewCurrentValue,ProcessDate)  Select id,'TaskActEstDt',cast(@PrevTaskEndEstDate as varchar(21)),cast(TaskActEstDt as varchar(21)),getdate() from obp_Taskheader where id=@Ticketid   */  

END 
GO
/****** Object:  StoredProcedure [dbo].[bkp_20231202_obps_sp_UpdateGridDataDetails]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[bkp_20231202_obps_sp_UpdateGridDataDetails]                            
 @gridid NVARCHAR(MAX)=NULL,                            
 @str nvarchar(MAX),                            
 @key nvarchar(50)=NULL,                            
 @LinkId NVARCHAR(MAX)=NULL,                            
 @usr nvarchar(MAX)='' ,                        
 @loc nvarchar(MAX)=''                        
AS                            
BEGIN                            
  DECLARE @query NVARCHAR(MAX),                            
  @tabname NVARCHAR(MAX),                            
  @pkey NVARCHAR(MAX),                            
  @indx int,                            
  @colname_new NVARCHAR(MAX),                            
  @count int,                            
  @datatype nvarchar(MAX),                            
  @col varchar(MAX),                            
  @colnew varchar(MAX)='',                            
  @val nvarchar(MAX)='',                            
  @querystr nvarchar(MAX)=''  ,                          
  @aftersavespname nvarchar(MAX)='',                          
  @isLocation nvarchar(2)='',                        
  @locationColName nvarchar(max)=''                        
                          
  DECLARE @ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),                            
@controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int                            
                            
    SET NOCOUNT ON;                            
SET @tabname=(select GridTable from obps_TopLinkExtended where Linkid=@LinkId and GridId=@gridid)                         
                    
IF @tabname is not null                            
BEGIN                            
                            
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                            
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval                            
FROM [dbo].[Split_UpdateSp] (@str, '^') ;                            
                             
OPEN CUR_TEST                            
FETCH NEXT FROM CUR_TEST INTO @col,@val                            
                             
WHILE @@FETCH_STATUS = 0                            
BEGIN                            
--select @col,@val                        
if CHARINDEX('__',@col) > 0                        
begin                        
SET @indx=(select CHARINDEX ('__',@col,0 ))                            
  --select 'value is '+@val                          
SET @colnew=(SELECT SUBSTRING(@col, 1,@indx-1))                            
SET @tabname=(SELECT SUBSTRING(@col, @indx+2, LEN(@col)))                            
SET @datatype=(SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE                             
TABLE_NAME = @tabname AND                             
COLUMN_NAME = @colnew)                            
--select @datatype                            
                    
set @controltype=(select ColControlType from obps_ColAttrib  where ColName=@colnew and TABLENAME = @tabname AND  linkid=@LinkId)                            
--if @datatype is not null                        
--begin                        
 if (CHARINDEX(@colnew,@querystr) <= 0  and lower(@colnew)<>'modifieddate'and lower(@colnew)<>'createddate')                      
 begin                        
  if LOWER(@controltype)='dropdownlist'                            
  begin                            
   --select 'inside'                            
   SET @colid=(SELECT id from obps_ColAttrib where colname=@colnew AND TABLENAME = @tabname and linkid=@linkid)                            
   SET @ddlcoltosel=(SELECT columntoselect from obps_dropdowntable where columnid=@colid)                             
   SET @ddlcoltoinsert=(SELECT columntoinsert from obps_dropdowntable where columnid=@colid)                            
   SET @ddltabletosel=(SELECT tabletoselect from obps_dropdowntable where columnid=@colid)                            
   SET @IsId=(SELECT IsId from obps_dropdowntable where columnid=@colid)                    
   --select @colid,@ddlcoltosel,@ddlcoltoinsert,@ddltabletosel,@IsId                            
IF @IsId=1                            
   BEGIN                            
    set @queryvalstr='select @ddlid=id from '+@ddltabletosel+' where '+@ddlcoltosel+'=N'''+@val+''''                   
    EXEC Sp_executesql  @queryvalstr,  N'@ddlid NVARCHAR(MAX) output',  @ddlid output                            
    SET @val=@ddlid                     
   --select @val,@queryvalstr,@ddltabletosel,@ddlcoltosel,@ddlid                          
   END                         
                         
   if @querystr=''                          
   begin                            
    set @querystr=@querystr+RTRIM(LTRIM(@ddlcoltoinsert)) +'='''+@val+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+RTRIM(LTRIM(@ddlcoltoinsert)) +'='''+@val+''''                            
   end                            
  end                      
  else  if @datatype='int'                            
  begin                            
   if @querystr=''                            
   begin                          
    set @querystr=@querystr+@colnew+'='+case when len(@val)>0 then @val else '''''' end                         
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'='+case when len(@val)>0 then @val else '''''' end                       
   end                            
  end                            
  else if @datatype='datetime' or @datatype='date'                            
  begin                            
   IF @val='null'                          
   BEGIN                            
    SET @val= ' '                            
   END                            
   if @querystr=''                            
   begin          
   set @querystr=@querystr+@colnew+'='''+ convert(CHAR(19),@val,120)+''''         
   -- set @querystr=@querystr+@colnew+'='''+ convert(CHAR(19),PARSE(@val AS datetime USING 'it-IT'),120)+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'='''+ convert(CHAR(19),@val,120)+''''                            
   end                            
  end                            
  else                            
  begin                            
   if @querystr=''                            
   begin                            
    set @querystr=@querystr+@colnew+'=N'''+@val+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'=N'''+@val+''''                            
   end                            
  end                            
                        
 end                        
end                        
--select @querystr                            
--END                            
  FETCH NEXT FROM CUR_TEST INTO @col,@val                            
END                            
CLOSE CUR_TEST                            
DEALLOCATE CUR_TEST                            
                            
                            
SET @isLocation=(select IsLocation from obps_TopLinks where id=@LinkId)                        
if(@isLocation='1')                        
BEGIN                        
                         
 SET @locationColName=(select locationcolname from obps_locationconfig where linkid=@LinkId)                        
 SET @querystr=@querystr+','+@locationColName+'='''+@loc+''''                        
                        
END                        
if(len(@querystr)>0)                      
BEGIN                      
                  
 SET @pkey=(SELECT TableKey FROM Obps_TableId WHERE TableName=@tabname )--and Linkid=@LinkId)                  
            
 set @querystr='update '+@tabname+' set '+@querystr+',ModifiedDate='''+CONVERT(VARCHAR,GETDATE(),121)+''',ModifiedBy='''+@usr+''' where '+@pkey+'='+@key+''                 
 select (@querystr)                            
 --EXEC (@querystr)                            
                          
  SET @aftersavespname=(SELECT AfterSaveSp FROM Obps_TopLinkextended where GridId=@gridid and Linkid=@LinkId)             
                            
  IF len(Ltrim(rtrim(@aftersavespname)))>1                         
  BEGIN                            
  --EXEC @aftersavespname @key
  Select @aftersavespname 'AfterSaveSP', @key 'Key'
  END                            
 END                         
END                            
END   
  
GO
/****** Object:  StoredProcedure [dbo].[oba_sp_SAP_Stock]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[oba_sp_SAP_Stock]
(
@var_user nvarchar(100)=''                                   
,@var_pid int=''                                   
,@var_clientid int=''
)
as

 select  ROW_NUMBER() OVER (ORDER BY (SELECT 1)) as id,* 
 from [Onebeat_Finolex].dbo.SAP_Stock_Temp


	 
GO
/****** Object:  StoredProcedure [dbo].[oba_sp_TotalTruckRequirment]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[oba_sp_TotalTruckRequirment]
(
@var_user nvarchar(100)=''                                             
,@var_pid int=''                                             
,@var_clientid int=''    
,@par1 nvarchar(MAX)='' 
)
as
select id, SentFrom 'Plant',ToLocation 'Branch',WtInTon 'Weight(Ton)'from obp_TotalLoad
GO
/****** Object:  StoredProcedure [dbo].[obp_DailyTasksEmail]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[obp_DailyTasksEmail]                                      
(@var_emailto nvarchar(100),@var_uname nvarchar(100))                                      
AS                                        
Begin           
      
         
DECLARE @xml NVARCHAR(MAX)                                      
DECLARE @body NVARCHAR(MAX)                 
              
DECLARE @xml1 NVARCHAR(MAX)                                      
DECLARE @body1 NVARCHAR(MAX)                                    
    
/*Get the Data for specific user - Ticket Count*/      
SET @xml = CAST(( SELECT [Owner] AS 'td','',[TaskType] AS 'td','', [Nos] AS 'td','' ,[NS] as 'td','' ,[IP] as 'td','' ,[Ttl_Red] as 'td','' ,[Ttl_Black] as 'td'             
FROM obp_tb_DailyTaskEmails_CountToEmail where Owner= @var_uname                                      
ORDER BY Owner,TaskType desc                                      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
   
/*Get the Data for specific user - Tickets*/      
SET @xml1 = CAST(( SELECT [Type] AS 'td','',[Ticket] AS 'td','',[Client] AS 'td','', [TaskName] AS 'td','' ,[TaskStatus] as 'td','' ,[ColorPriority] as 'td',''                
FROM obp_tb_DailyTaskEmails_SummaryToEmail where Owner= @var_uname                                      
ORDER BY Owner,Type desc,Ticket                                      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                  
                                    
                                      
/*Prepare the Header for specific user - Ticket Count*/    
      
SET @body ='<html><body>Dear Sir/Madam'+' '+'<P><BR>Please find below Task Status Summary and Details for Tickets assigned to you.</BR><P>Task Summary: <P>  
<table border = 1>                                       
<tr bgcolor=Orange>                                      
<th> Owner </th> <th> TaskType </th> <th> Total </th><th> NS </th><th> IP </th><th> Red </th><th> Black </th></tr>'                      
              
SET @body = @body + @xml +'</table><BR></BR>'             
    
/*Prepare the Header for specific user - Tickets*/              
Set @body1='<P>Task Details:<P><table border = 1>                                       
<tr bgcolor=Orange>                                      
<th>Type </th><th>Ticket </th> <th> Client </th> <th> TaskName </th><th> TaskStatus </th><th> ColorPriority </th></tr>'                
SET @body = @body + @body1 + @xml1+'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>-----This is an auto generated email. Please Do not Reply-----</BR></body></html>'                 
    
    
/*Sending the Email*/                              
EXEC msdb.dbo.sp_send_dbmail                                      
@profile_name = 'Autoemails',                                      
@body = @body,                                      
@body_format ='HTML',                                      
@recipients = @var_emailto,                                      
@subject = 'DTMS : Task Summary' ;                                      
                          
                                        
end   
GO
/****** Object:  StoredProcedure [dbo].[obp_DTMSTaskUpdtReminderEmail]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROCEDURE [dbo].[obp_DTMSTaskUpdtReminderEmail]                                                
AS                                
begin            
Declare @var_emailto nvarchar(max)                            
DECLARE @xml NVARCHAR(MAX)                              
DECLARE @body NVARCHAR(MAX)                              
        
        
Set  @var_emailto=( Select STRING_AGG(subdept,';') from obps_users where Department='InfoTech' )        
        
/*Comment the below line for live run*/        
 --Set  @var_emailto='bharat.sharma@goldrattgroup.com;ravindra.udagatti@goldrattgroup.com;srinivasan.v@goldrattgroup.com'      
--Set  @var_emailto='bharat.sharma@goldrattgroup.com'  
  
SET @body ='<html><body>Dear Team'+'<P>This is a gentle reminder to update the DTMS tasks for effective reporting and discussion.<P><U><B>Please ensure :</B></U> <BR>- Tasks for current week have been updated for progress.</BR></n>- Tasks for next week ha
ve been planned in DTMS.<P>Please ignore the email if already done.<P>'        
        
SET @body = @body  +'<BR>Thanks</BR><BR>OneBeat Team</BR><BR>-----This is an auto generated email. Please Do not Reply-----</BR></body></html>'                              
EXEC msdb.dbo.sp_send_dbmail                              
@profile_name = 'Autoemails',                              
@body = @body,                              
@body_format ='HTML',                              
@recipients = @var_emailto,                              
@subject = 'Goldratt : Reminder to update DTMS Tasks' ;          
                  
                                
end           
GO
/****** Object:  StoredProcedure [dbo].[obp_LicDailyEmail]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obp_LicDailyEmail]                        
(@var_emailto nvarchar(100),@var_uname nvarchar(100))                        
AS                          
begin                          
DECLARE @xml NVARCHAR(MAX)                        
DECLARE @body NVARCHAR(MAX)                        
        
SET @xml = CAST(( SELECT [ClientName] AS 'td','',[LicenseValidityDate] AS 'td','', [DaysLeft] AS 'td'            
FROM obp_UserLicMapping where username= @var_uname                        
ORDER BY ClientName                        
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                        
/*                        
SET @xml = CAST(( SELECT [ClientName] AS 'td','',[LicenseDate] AS 'td','', [DaysLeft] AS 'td','' ,[FeesPendingAmount] as 'td','', [ExpensePendingAmount] as 'td'                        
FROM obp_EmailList where username= @var_uname                        
ORDER BY ClientName                        
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                        
*/                        
                        
SET @body ='<html><body>Dear '+@var_uname+'<BR>Onebeat License for below mentioned list of Client will be expiring soon.</BR><P>                        
<table border = 1>                         
<tr bgcolor=Orange>                        
<th> ClientName </th> <th> ValidityDate </th> <th> DaysLeft </th></tr>'        
/*<th> ClientName </th> <th> LicenseValidityDate </th> <th> DaysLeft </th><th> FeesPendingAmount </th><th> ExpensePendingAmount </th>*/                            
/*                         
SET @body = @body + @xml +'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>Goldratt Group</BR><BR>-----This is an auto generated email from http://164.52.203.134/ . Please Do not Reply-----</BR></body></html>'                        
*/                        
SET @body = @body + @xml +'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>-----This is an auto generated email. Please Do not Reply-----</BR></body></html>'                        
EXEC msdb.dbo.sp_send_dbmail                        
@profile_name = 'Autoemails',                        
@body = @body,                        
@body_format ='HTML',                        
@recipients = @var_emailto,                        
@subject = 'Goldratt : Client OneBeat License/ Contract' ;                        
            
                          
end     
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_ClientDetail]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[obp_sp_ClientDetail]      
(@var_user nvarchar(100)=''     
,@var_pid int=''     
,@var_clientid int=''      
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''         
)                  
as                  
begin                  
                  
DECLARE @SearchLetter nvarchar(100)                  
SET @SearchLetter ='%'+ @var_user + '%'                  
                  
          
Select id  
,ClientName   
--,convert(varchar,LicenseValidityDate, 111) as 'licensevaliditydate__obp_clientmaster'  
,licensevaliditydate as 'licensevaliditydate__obp_clientmaster'  
,case when LicenseValidityDate is not null then datediff(dd,getdate(),LicenseValidityDate) else 0 end 'DaysLeftToExpireLicense'  
from obp_ClientMaster  
where id in (select value from string_split(@var_par1,','))   
and isActive=1  
order by ClientName      

End 

GO
/****** Object:  StoredProcedure [dbo].[obp_sp_CompletedTaskCurrentWeek]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Completed Planned Tasks for Current Week*/  
/*Date: 2023-09-29; Author: Bharat; Reason: To get the list of Completed Tasks from Planned for Status Report */  
  
CREATE procedure [dbo].[obp_sp_CompletedTaskCurrentWeek]  
as  
Begin  
  
Select   
 CM.ClientName,TH.th_TaskHeader 'Task Name',TH.TaskStatus,cast(TH.PlannedStartDt as date) 'Planned Start Date'  
 ,cast(TH.TaskActEstDt as date) 'Planned Finish Date',TH.BlackExcedDays 'Delay Days'  
 ,TH.OnHoldReason 'Delay Reason',TH.AccessToUser 'Owner',replace(TH.ShareToUser,'/','') 'Task Assign To'  
from obp_TaskHeader TH  
join obp_ClientMaster CM on CM.id=TH.ClientID  
join obps_users US on US.UserName= TH.Createdby  
where   
 cast(TH.CreatedDate as date) > '2023-03-01' and  
 ClientID>1 and   
 ParentId=0 and  
 th_TaskHeader is not null and  
 DATEPART(WEEK,TH.PlannedStartDt) <=  (DATEPART(WEEK,GETDATE())) and  
 DATEPART(WEEK,TH.TaskActEstDt) >=  (DATEPART(WEEK,GETDATE())) and  
 TH.TaskStatus in ('CP')  
order by CM.ClientName,TH.TaskActEstDt  
  
End
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Custom_TicketsView]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    proc [dbo].[obp_sp_Custom_TicketsView]  
  
@Lastrun Varchar(50)  
as  
Begin  
  
select th.id TicketID,cm.ClientName Client,th.th_Remarks 'Remarks',th.td_SeqNo as 'TouchTime',th.FKBy 'FullKit',th.TicketCatg1 Category,th.Sprint [Committed],th_TaskHeader [Task],th.AssignToMain [Assigned To],th.PlannedStartDt [Start], th.TaskActEstDt [Finish]
from  [dbo].[obp_Taskheader] th 
join obp_ClientMaster cm on cm.id = th.ClientID
where 
isnull(th.ParentId,0)=0 and 
th.th_TaskHeader not in ('Click + Sign to Add Records')
and th.isEdit=1
and th.TaskStatus<>'CP'
and 
th.Createdby in (Select UserName from obps_Users where Company='OPS' or UserTypeId in (2))

  
End
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_DailyLicEmailProcess]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[obp_sp_DailyLicEmailProcess]                                      
as                                      
begin    
print getdate()  
      
truncate table obp_EmailList                              
truncate table obp_UserLicMapping                              
                              
                              
/*Getting Valid Clients For Lic Email*/    

insert into obp_UserLicMapping(ClientId,UserName,UserEmail,Ind01,ClientName,Email,DaysLeft,LicenseValidityDate)
select a.id,a.Implementer ,US.EmailId,0,a.ClientName,US.EmailId
, datediff(dd,getdate(),a.LicenseValidityDate) 'DaysLeft' ,convert(date,a.LicenseValidityDate) 'LicenseDate'
from  obp_ClientMaster a
join obps_Users US on US.UserName=a.Implementer 
where datediff(dd,getdate(),LicenseValidityDate) between -30 and 10 and isDeleted=0 and isActive=1 and a.onebeatlicense =1 and len(isnull(a.Implementer,''))>3
order by ClientName
                          
                              
/*Insert All valid clients for Hemant and Bharat User*/
Insert into obp_UserLicMapping
Select ClientId,'Hemant','hemant.kalia@goldrattgroup.com',1,ClientName,'hemant.kalia@goldrattgroup.com',DaysLeft,LicenseValidityDate from obp_UserLicMapping 

Insert into obp_UserLicMapping
Select ClientId,'Bharat','bharat.sharma@goldrattgroup.com',1,ClientName,'bharat.sharma@goldrattgroup.com',DaysLeft,LicenseValidityDate from obp_UserLicMapping  where ind01=1

Delete from obp_UserLicMapping where ind01=0 and UserName in ('Hemant','Bharat')

Update obp_UserLicMapping set ind01=0 

/*End - Generating Records for Client Contract Date For Hemant and Bharat User*/       

--Select * from obp_UserLicMapping order by UserName


If object_Id('tempdb..#tb_EmailLic') is not null drop table #tb_EmailLic

Select distinct UserName,UserEmail,0 'ind01' into #tb_EmailLic from obp_UserLicMapping

/*End - Getting Valid Clients For Lic Email*/                         
                      
                             
                                
/*Start Email Sending Process*/                              
declare @var_cnt int, @var_user nvarchar(100),@var_email nvarchar(100)                                    
set @var_cnt=(select count(*) from #tb_EmailLic where ind01=0)                             
                        
                       
while @var_cnt<>0                                    
begin                                    
set @var_user=(select top 1 UserName from #tb_EmailLic where ind01=0)                                    
set @var_email =(select top 1 Useremail  from #tb_EmailLic where username=@var_user)                                    
                                    
exec obp_LicDailyEmail @var_email,@var_user                                  
                                    
update #tb_EmailLic set ind01=1 where username=@var_user                                    
set @var_cnt=@var_cnt-1                                    
end                               
/*End - Email Sending Process*/     
                           
       
end 

  
GO
/****** Object:  StoredProcedure [dbo].[obp_SP_DSH_TicketCycleTime]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obp_SP_DSH_TicketCycleTime]    
as    
Begin    
If object_id('tempdb..##tb_ClientTickets') is not null drop table ##tb_ClientTickets    
If object_id('tempdb..##tb_Report1') is not null drop table ##tb_Report1    
If object_id('tempdb..#tb_users') is not null drop table #tb_users    
    
Select CM.ClientName,TH.id 'TicketNo',TH.th_TaskHeader 'TaskHeader'
--,TH.ShareToUser 'AssignToUser'
,TH.AssignToMain 'AssignToUser'
,TH.TaskStatus,TH.CreatedDate,TH.EstDueDate, case when TH.TaskStatus='CP' then TH.ModifiedDate else getdate() end 'CompletionDate'    
,case when TH.TaskStatus in ('CP','CL') then datediff(dd,TH.CreatedDate,TH.ModifiedDate) else datediff(dd,TH.CreatedDate,getdate())  end 'DaysUsedForTask'    
into ##tb_ClientTickets    
from obp_taskheader TH    
join obp_ClientMaster CM on CM.id=TH.ClientID    
where TH.TaskStatus is not null    
order by CM.ClientName,isnull(TH.EstDueDate,getdate())    
    
/*    
Select ClientName,TaskStatus,count(*) 'Nos'     
from ##tb_ClientTickets    
group by ClientName,TaskStatus    
order by ClientName    
    
Select AssignToUser,TaskStatus,count(*) 'Nos'     
from ##tb_ClientTickets    
where DaysUsedForTask between 0 and 5    
group by AssignToUser,TaskStatus    
order by AssignToUser,TaskStatus    
*/    
    
    
Select username,0 'ind01' into #tb_users from obps_users where Company in ('GC','OPS')
    
Create table ##tb_Report1    
(    
TM nvarchar(max)    
,TaskStatus nvarchar(max)    
,[1-5Days] int    
,[1-10Days] int    
,[1-20Days] int    
,[1-30Days] int    
,[Over 30 Days] int    
)    
    
Declare @var_usrcnt int,@var_usr nvarchar(max)    
Set @var_usrcnt=(Select count(*) from #tb_users)    
    
While @var_usrcnt<>0    
Begin    
set @var_usr='%'+(Select top 1 username from #tb_users where ind01=0)+'%'    
    
print @var_usr    
    
insert into ##tb_Report1    
Select replace(@var_usr,'%','') 'TM',TaskStatus    
,sum(case when DaysUsedForTask between 0 and 5 then  1 else 0 end) '1-5Days'    
,sum(case when DaysUsedForTask between 6 and 10 then  1 else 0  end) '1-10Days'    
,sum(case when DaysUsedForTask between 11 and 20 then  1 else 0  end) '1-20Days'    
,sum(case when DaysUsedForTask between 21 and 30 then 1 else 0  end) '1-30Days'    
,sum(case when DaysUsedForTask > 30 then  1  else 0 end) 'Over 30 Days'    
from ##tb_ClientTickets     
where AssignToUser like @var_usr    
--where AssignToUser like '%Bharat%'    
group by TaskStatus    
    
update #tb_users set ind01=1 where username =replace(@var_usr,'%','')    
set @var_usrcnt=@var_usrcnt-1    
End    
    
/*Select * from ##tb_Report1 order by TM,TaskStatus*/    

   
Merge obp_DHS_TicketCycleTimeRep as Target    
using ##tb_Report1 as Source    
on Source.TM collate database_default=Target.TM and Source.TaskStatus collate database_default=Target.TaskStatus    
When not matched by target then    
insert (TM,TaskStatus,[1-5Days],[1-10Days],[1-20Days],[1-30Days],[Over 30 Days])    
Values (Source.TM,Source.TaskStatus,Source.[1-5Days],Source.[1-10Days],Source.[1-20Days],Source.[1-30Days],Source.[Over 30 Days])    
When matched then    
Update Set Target.[1-5Days]=Source.[1-5Days],Target.[1-10Days]=Source.[1-10Days],Target.[1-20Days]=Source.[1-20Days],Target.[1-30Days]=Source.[1-30Days],Target.[Over 30 Days]=Source.[Over 30 Days]    
When not matched by Source then    
Delete;    
    
    
Select * from obp_DHS_TicketCycleTimeRep order by TM,TaskStatus    
End  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_eod]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     proc [dbo].[obp_sp_eod]          
(@var_user nvarchar(100)=''                                                       
,@var_pid int=''                                                       
,@var_clientid int=''                                                        
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''                                                           
)                                                                    
as                                                                    
begin                                                                    
                                                                    
DECLARE @SearchLetter nvarchar(100)                                                                    
SET @SearchLetter ='%'+ @var_user + '%'                                           
                                          
Declare @var_usertype int                                          
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)                                                                   
          
Declare @var_reccount int          
Set @var_reccount=0          
Set @var_reccount=(Select count(*) from obp_eod where cast(EOD_Date as date)=cast(getdate() as date) and Createdby=@var_user and id<>100)          
--Set @var_reccount=1          
                                                             
If isnull(@var_reccount,0)=0          
Begin          
 Select           
 1 as id          
 --,Name as 'name__obp_eod'          
 ,Project as 'project__obp_eod'          
 ,TaskCategory as 'taskcategory__obp_eod'          
 ,TaskType as 'tasktype__obp_eod'          
 --,TimeSpent as 'timespent__obp_eod'          
 ,Hours as 'hours__obp_eod'          
 ,Minutes as 'minutes__obp_eod'          
 ,Comments as 'comments__obp_eod'          
 ,EOD_Date as 'eod_date__obp_eod'          
 from obp_eod where id =100          
          
End          
Else          
Begin          
 Select           
 id          
 --,Name as 'name__obp_eod'          
 ,Project as 'project__obp_eod'          
 ,TaskCategory as 'taskcategory__obp_eod'          
 ,TaskType as 'tasktype__obp_eod'          
 --,TimeSpent as 'timespent__obp_eod'          
 ,Hours as 'hours__obp_eod'          
 ,Minutes as 'minutes__obp_eod'          
 ,Comments as 'comments__obp_eod'          
 ,EOD_Date as 'eod_date__obp_eod'          
 from obp_eod where cast(EOD_Date as date)=cast(getdate() as date) and Createdby=@var_user          
End          
End   


GO
/****** Object:  StoredProcedure [dbo].[obp_sp_eod_GetTaskCat]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obp_sp_eod_GetTaskCat]       
@usrnme nvarchar(MAX)='',          
@linkid int='' ,                  
@gridid nvarchar(MAX)=''      
,@id nvarchar(10)=''     
AS       
BEGIN     
select id as ID,Priorityvalue as name from [dbo].[obp_eod_TaskCatDDLValues]     
END  
  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_eod_GetTaskType]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obp_sp_eod_GetTaskType]       
@usrnme nvarchar(MAX)='',          
@linkid int='' ,                  
@gridid nvarchar(MAX)=''      
,@id nvarchar(10)=''       
AS       
BEGIN     
select 1 as ID,'Planned' as name     
Union all    
select 2 as ID,'Un-Planned' as name     
END 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_eod_report]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE proc [dbo].[obp_sp_eod_report]            
(@var_user nvarchar(100)=''                                                         
,@var_pid int=''                                                         
,@var_clientid int=''                                                          
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''                                                             
)                                                                      
as                                                                      
begin                                                                      
                                                                      
DECLARE @SearchLetter nvarchar(100)                                                                      
SET @SearchLetter ='%'+ @var_user + '%'                                             
                                            
Declare @var_usertype int,@var_userid int                                            
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)      
Set @var_userid= (Select id from obps_Users where UserName=@var_user)      
    
Declare @var_reccount int              
Set @var_reccount=0              
Set @var_reccount=(Select count(*) from obp_eod where id <> 1878 )         
    
/*Data: 2023-09-16 ; Desc:User created tasks will be show to below users */    
If (@var_userid in (12,13,17,64))    
Begin    
 If isnull(@var_reccount,0)=0              
 Begin        
 Select             
  1 as 'id'            
  ,Name as 'Name'            
  ,Project as 'Project'            
  ,TaskCategory as 'TaskCategory'            
  ,TaskType as 'TaskType'            
  --,TimeSpent as 'TimeSpent(HH:MM)'            
  ,Hours 'TimeSpent(Hours)'      
  ,Minutes 'TimeSpent(Minutes)'      
  ,Comments as 'Comments'            
  ,CONVERT(VARCHAR(10), EOD_Date, 111) as 'EOD Date'            
  --,cast((convert(date,CreatedDate,111)) as datetime)'EOD Punch Date'        
  ,null as 'EOD Punch Date'        
  from obp_eod        
  order by [EOD_Date] desc,Createdby        
 End        
 Else        
 Begin            
 Select             
  id            
  ,Createdby as 'Name'            
  ,Project as 'Project'            
  ,TaskCategory as 'TaskCategory'            
  ,TaskType as 'TaskType'            
  --,TimeSpent as 'TimeSpent(HH:MM)'            
  ,Hours 'TimeSpent(Hours)'      
  ,Minutes 'TimeSpent(Minutes)'      
  ,Comments as 'Comments'            
  --,CONVERT(VARCHAR(10), EOD_Date, 111) as 'EOD Date'                  
  --,CONVERT(VARCHAR(10), CreatedDate, 111) as 'EOD Punch Date'        
  ,cast(EOD_Date as date) as 'eod_date__obp_eod'  
  ,cast(CreatedDate as date) as 'createddate__obp_eod'  
  from obp_eod where id <> 1878   
  order by [EOD_Date] desc,Createdby        
 End        
End    
    
/*Data: 2023-09-16 ; Desc:All Tasks will be show to below users ; Reason: Validation and Report Analysis*/    
If (@var_userid not in (12,13,17,64))    
Begin    
 If isnull(@var_reccount,0)=0              
 Begin        
 Select             
  1 as 'id'            
  ,Name as 'Name'            
  ,Project as 'Project'            
  ,TaskCategory as 'TaskCategory'            
  ,TaskType as 'TaskType'            
  --,TimeSpent as 'TimeSpent(HH:MM)'            
  ,Hours 'TimeSpent(Hours)'      
  ,Minutes 'TimeSpent(Minutes)'      
  ,Comments as 'Comments'            
  ,CONVERT(VARCHAR(10), EOD_Date, 111) as 'EOD Date'            
  --,cast((convert(date,CreatedDate,111)) as datetime)'EOD Punch Date'        
  ,null as 'EOD Punch Date'        
  from obp_eod        
  order by [EOD_Date] desc,Createdby        
 End        
 Else        
 Begin            
 Select             
  id            
  ,Createdby as 'Name'            
  ,Project as 'Project'            
  ,TaskCategory as 'TaskCategory'            
  ,TaskType as 'TaskType'            
  --,TimeSpent as 'TimeSpent(HH:MM)'            
  ,Hours 'TimeSpent(Hours)'      
  ,Minutes 'TimeSpent(Minutes)'      
  ,Comments as 'Comments'            
  --,CONVERT(VARCHAR(10), EOD_Date, 111) as 'EOD Date'                  
  --,CONVERT(VARCHAR(10), CreatedDate, 111) as 'EOD Punch Date'        
  ,cast(EOD_Date as date) as 'eod_date__obp_eod'  
  ,cast(CreatedDate as date) as 'createddate__obp_eod'  
  from obp_eod where id > 100 and Createdby=@var_user       
  order by [EOD_Date] desc,Createdby        
 End     
End    
    
        
    
          
End       
GO
/****** Object:  StoredProcedure [dbo].[obp_SP_GenerateDailyTaskSummaryToEmail]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Created on 2023-12-15; Author: Bharat; Reason: To Email Daily Task Status*/        
Create       procedure [dbo].[obp_SP_GenerateDailyTaskSummaryToEmail]        
as        
Begin        
/*  
Select * from obp_tb_DailyTaskEmails_CountToEmail  
  
Alter table obp_tb_DailyTaskEmails_CountToEmail  
Add Ttl_Red nvarchar(5),Ttl_Black nvarchar(5)  
*/        
Truncate table obp_tb_DailyTaskEmails        
Truncate table obp_tb_DailyTaskEmails_CountToEmail        
Truncate table obp_tb_DailyTaskEmails_SummaryToEmail        
--drop table obp_tb_DailyTaskEmails        
        
        
insert into obp_tb_DailyTaskEmails        
select         
th.id 'Ticket'         
,cm.ClientName        
,th.th_TaskHeader 'MainTask'        
,st.th_TaskHeader 'Activity'        
,st.TaskStatus 'Activity_TaskStatus'        
,th.TaskStatus 'Main_TaskStatus'        
,th.Sprint 'Committed'        
,th.Color3 'Color'        
,st.ShareToUser 'Owner'        
,us.EmailId 'UserEmail'        
,'bharat.sharma@goldrattgroup.com' 'ManagerEmail'        
,1 as 'SendFlg'        
,cast(getdate() as date) 'ProcessDate'        
from obp_TaskHeader th               
join obp_ClientMaster cm on th.ClientID=cm.id            
left join obp_TaskHeader st on st.ParentId=th.id         
join obps_users US on us.UserName=st.ShareToUser              
where               
th.th_taskheader<>'Click + Sign to Add Records'  and st.th_taskheader<>'Click + Sign to Add Records'        
and cm.ClientName not in ('GC_Prabhat')         
and isnull(th.TicketCatg1,'-')<>'Delete Task'                                        
and  cast(th.CreatedDate as date) > '2023-01-31'         
and th.TaskStatus in ('NS','IP') --and st.TaskStatus in ('NS','IP')         
and th.ShareToUser is not null        
and us.Company in ('GC','OPS')
Union All        
select         
th.id 'Ticket'         
,cm.ClientName        
,th.th_TaskHeader 'MainTask'        
,th.th_TaskHeader 'Activity'        
,th.TaskStatus 'Activity_TaskStatus'        
,th.TaskStatus 'Main_TaskStatus'        
,th.Sprint 'Committed'        
,th.Color3 'Color'        
,th.Createdby 'Owner'        
,us.EmailId 'UserEmail'        
,'bharat.sharma@goldrattgroup.com' 'ManagerEmail'        
,1 as 'SendFlg'        
,cast(getdate() as date) 'ProcessDate'        
from obp_TaskHeader th         
join obp_ClientMaster cm on th.ClientID=cm.id            
join obps_users US on us.UserName=th.Createdby              
where               
th.th_taskheader<>'Click + Sign to Add Records'          
and cm.ClientName not in ('GC_Prabhat')         
and isnull(th.TicketCatg1,'-')<>'Delete Task'                                        
and  cast(th.CreatedDate as date) > '2023-01-31'         
and th.TaskStatus in ('NS','IP')         
and th.ShareToUser is not null        
and us.Company in ('GC','OPS')
        
/*Delete Invalid Records*/        
Delete from obp_tb_DailyTaskEmails where Activity_TaskStatus in ('CP','CL')         
Delete from obp_tb_DailyTaskEmails where owner is null or maintask in ('No Record Exists') or useremail is null or activity='Click + Sign to Add Records'        
        
        
/*Populate Task Count Summary*/        
insert into obp_tb_DailyTaskEmails_CountToEmail        
Select         
Owner        
,case when Committed='Committed' then 'Committed' else 'Backlog' end 'TaskType'        
,count(*) 'Nos'        
,sum(case when TaskStatus='NS' then 1 else 0 end) 'NS'        
,sum(case when TaskStatus='IP' then 1 else 0 end) 'IP'        
,sum(case when isnull(Color,'')='Red' then 1 else 0 end) 'Red'        
,sum(case when isnull(Color,'')='Black' then 1 else 0 end) 'Black'        
,sum(case when isnull(Color,'') not in ('Red','Black') then 1 else 0 end) 'Non_RB'        
,0 'Status'   
,'',''       
from         
(        
Select Owner,Ticket,max(Committed) 'Committed',max(Color) 'Color',max(Main_TaskStatus) 'TaskStatus'         
from obp_tb_DailyTaskEmails group by Owner,Ticket        
--order by Owner,Committed        
) a        
group by Owner,Committed        
order by owner        
  
update obp_tb_DailyTaskEmails_CountToEmail set Ttl_Red=convert(varchar(5),Red) ,Ttl_Black=convert(varchar(5),Black)  where   TaskType='Committed'    
update obp_tb_DailyTaskEmails_CountToEmail set Ttl_Red='NA' ,Ttl_Black='NA'  where   TaskType='Backlog'    
        
/*Populate Task Summary*/        
        
insert into obp_tb_DailyTaskEmails_SummaryToEmail        
select Ticket,max(ClientName) 'Client',max(MainTask) 'TaskName',max(Main_TaskStatus) 'TaskStatus',max(Color) 'ColorPriority'      
,Owner 'Owner',max(UserEmail) 'Email',0 as 'Status'  ,case when committed='committed' then 'Committed' else 'Backlog' end 'Type'      
from obp_tb_DailyTaskEmails         
--where  committed='committed'         
group by Ticket,Owner,committed        
order by  Type desc      
      
Delete from obp_tb_DailyTaskEmails_SummaryToEmail where Len(isnull(Email,'')) < 5      
        
End    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_getClient]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_getClient]                
@User_Name NVARCHAR(MAX)='',          
@linkid int='' ,                  
@gridid nvarchar(MAX)=''                
,@id nvarchar(10)=''       
AS                
BEGIN                
 DECLARE @SearchLetter int  ,@var_clientid nvarchar(max),@var_SearchUser nvarchar(max)             
 SET @SearchLetter =(Select id from obps_users where UserName=@User_Name)        
 Set @var_clientid=(Select par1 from obps_SpPermissions where Linkid=@linkid and userid =  @SearchLetter)     
 set @var_SearchUser='%'+@User_Name+'%'       
        
 select id,clientname as name from obp_ClientMaster where id in     
 --(Select value from string_split(@var_clientid,','))                 
 (    
 select distinct ClientID from obp_TaskHeader where isActive=1 and ParentId = 0 and th_TaskHeader<> 'Click + Sign to Add Records' and TaskStatus<>'CP'    
 and ShareToUser like @var_SearchUser    
 union all    
 Select value from string_split(@var_clientid,',')    
 )    
 order by clientname asc                
 --select ID,clientname as name from obp_ClientMaster                
END 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_getClient_EOD]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[obp_sp_getClient_EOD]                        
@usrnme nvarchar(MAX)='',              
@linkid int='' ,                      
@gridid nvarchar(MAX)=''          
,@id nvarchar(10)=''                       
AS                        
BEGIN           
/*Reason : This will show the same clients as shown in MyTask against each user*/          
 --Set @linkid=1          
 DECLARE @SearchLetter int  ,@var_clientid nvarchar(max),@var_SearchUser nvarchar(max)                     
 SET @SearchLetter =(Select id from obps_users where UserName=@usrnme)                
 Set @var_clientid=(Select par1 from obps_SpPermissions where Linkid=@linkid and userid =  @SearchLetter)             
 set @var_SearchUser='%'+@usrnme+'%'               
                
 select id,clientname as name from obp_ClientMaster where id in             
 --(Select value from string_split(@var_clientid,','))                         
 (            
 select distinct ClientID from obp_TaskHeader where isDeleted=0 and ClientID>1 and th_TaskHeader<> 'Click + Sign to Add Records' and TaskStatus<>'CP'            
 and ShareToUser like @var_SearchUser            
 union all            
 Select value from string_split(@var_clientid,',')        
 --union all        
 --Select 'Others'            
 )         
 union all        
 Select 1 'id','Others'    as 'name'        
 order by clientname asc                        
 --select ID,clientname as name from obp_ClientMaster                        
END   
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetClientTicketActionOptions]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[obp_sp_GetClientTicketActionOptions]         
@usrnme nvarchar(MAX)='' ,        
@linkid int='' ,                
@gridid nvarchar(MAX)='' ,    
@id nvarchar(10)=''         
AS       
BEGIN     
   
 Select id,TaskStatusValue 'name' from obp_ClientTicketActionDDLValues where id<>1 order by TaskStatusValue  
   
End
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetFKType]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_GetFKType]       
@usrnme nvarchar(MAX)='' ,      
@linkid int='' ,              
@gridid nvarchar(MAX)=''
,@id nvarchar(10)=''       
AS       
BEGIN select id as ID,TickTypeValue as name from [dbo].[obp_FKTypeDDLValues] where TickTypeValue in ('Y','N') END   
  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetMainTaskStatus]    Script Date: 2024-04-27 7:59:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[obp_sp_GetMainTaskStatus]              
(@var_MainTaskId int)              
as              
Begin              
              
Declare @var_MTStatus nvarchar(50) , @var_curTaskCatg nvarchar(100) ,@var_Check01 int            
            
set @var_Check01=0            
              
Select top 1 @var_MTStatus = STAT.TaskStatusValue              
from obp_TaskHeader ST               
join obp_TaskStatusDDLValuesST STAT on STAT.TaskStatusValue collate database_default=ST.TaskStatus              
where ST.ParentId =@var_MainTaskId and ST.th_TaskHeader <>'Click + Sign to Add Records'              
order by STAT.CatgRank              
            
Select @var_curTaskCatg=isnull(TicketCatg1,'-') from obp_TaskHeader where id=@var_MainTaskId             
            
if (Select isnull(count(*),0) from obp_TaskHeader where id=@var_MainTaskId and (TaskDuration is NULL or TaskActStartDt is NULL or TaskActEstDt is NULL or PlannedStartDt is NULL )) >=1            
Begin            
set @var_Check01=1            
End            
            
if (Select isnull(count(*),0) from obp_TaskHeader where id=@var_MainTaskId and ((len(trim(isnull(TicketCatg1,'-'))) < 3))) >=1            
Begin            
set @var_Check01=1            
End            
            
if (Select isnull(count(*),0) from obp_TaskHeader where id=@var_MainTaskId and TimeBuffer='Black' and len(trim(isnull(OnHoldReason,'-'))) < 3 ) >=1            
Begin            
set @var_Check01=1            
End            
print   @var_Check01          
          
--if @var_curTaskCatg='Delete Task'            
--Begin            
--set @var_Check01=0            
--End            
        
if (@var_MTStatus<>'CP' )        
Begin        
update obp_TaskHeader set TaskStatus=@var_MTStatus,ActualDuration=null,ActualFinishDate=null where id=@var_MainTaskId         
End        
        
if (isnull(@var_curTaskCatg,'-')='Delete Task')        
Begin        
set @var_MTStatus='CP'        
update obp_TaskHeader set TaskStatus=@var_MTStatus,ActualFinishDate=cast(getdate() as date),ActualDuration=(datediff(dd,TaskActStartDt,getdate())+1) where id=@var_MainTaskId         
      
End        
        
          
/*Check TicketType Blank before moving to Completed Status*/            
--If(@var_MTStatus='CP' and isnull(@var_curTaskCatg,'-')<>'Delete Task' and @var_Check01=0)            
if (@var_MTStatus='CP' and isnull(@var_curTaskCatg,'-')<>'Delete Task' and @var_Check01=0)        
Begin        
update obp_TaskHeader set TaskStatus=@var_MTStatus,ActualFinishDate=cast(getdate() as date),ActualDuration=(datediff(dd,TaskActStartDt,getdate())+1) where id=@var_MainTaskId              
End          

Declare @var_CreatedUserType int    

Select @var_CreatedUserType=UserTypeId from obps_users where username= (Select top 1 Createdby from obp_Taskheader where id= @var_MainTaskId )    

/*Auto Close Non-Client tasks */
If @var_CreatedUserType <> 2
Begin
 
If (Select isnull(TaskStatus,'') from obp_Taskheader where id=@var_MainTaskId )='CP'            
 Update obp_Taskheader set TaskStatus='CL',ClientClosureAcceptanceDate=cast(getdate() as date),ClientClosureAcceptance='True' 
 where id = @var_MainTaskId and TaskStatus='CP' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01' 
End

          
print @var_MTStatus              
--select * from obp_TaskStatusDDLValuesST              
              
              
End 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetOnHoldReason]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_GetOnHoldReason]         
@usrnme nvarchar(MAX)='',        
@linkid int='' ,                
@gridid nvarchar(MAX)=''    
,@id nvarchar(10)=''         
AS         
BEGIN       
select id as ID,Reason as name from [dbo].[obp_OnHoldReason]       
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetSprint]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obp_sp_GetSprint]         
@usrnme nvarchar(MAX)='' ,        
@linkid int='' ,                
@gridid nvarchar(MAX)='' ,    
@id nvarchar(10)=''         
AS       
BEGIN       
  
Declare @var_TaskStatus nvarchar(50)  
Set @var_TaskStatus=(Select TaskStatus from obp_Taskheader where id=@id)  
  
If @var_TaskStatus='CP'  
Begin  
Select 1 'id', 'Completed' as 'name'   
End  
Else  
Begin  
Select 2 'id', 'Backlog' as 'name'   
Union All  
Select 3 'id', 'Committed' as 'name'   
End  
    
END   
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetTaskStatus]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[obp_sp_GetTaskStatus]         
@usrnme nvarchar(MAX)='' ,        
@linkid int='' ,                
@gridid nvarchar(MAX)='' ,    
@id nvarchar(10)=''         
AS       
BEGIN       
  
Declare @var_CurrTS nvarchar(50) ,@var_UserType int   
Set @var_CurrTS=(Select Taskstatus from obp_Taskheader where id=@id)    
set @var_UserType=(Select UserTypeId from obps_users where UserName=@usrnme)    
  
/* select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]  */    
    
If @var_CurrTS='NS'    
Begin    
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('Backlog','IP','DEL')    
End    
    
If @var_CurrTS='IP'    
Begin    
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('Backlog','CP','DEL')    
End    
    
If @var_CurrTS='CP'  
Begin 
 If @var_UserType=2
 Begin
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('CL')     
 End
 Else
 Begin   
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('CP')    
 End
End    
  
    
If @var_CurrTS='Backlog'    
Begin    
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('IP','DEL')    
End    
    
END 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetTaskStatus_v1]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_GetTaskStatus_v1]     
@usrnme nvarchar(MAX)='' ,    
@linkid int='' ,            
@gridid nvarchar(MAX)=''     
AS   
BEGIN   
select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]   
END   
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetTickType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_GetTickType]           
@usrnme nvarchar(MAX)='' ,          
@linkid int='' ,                  
@gridid nvarchar(MAX)=''
,@id nvarchar(10)=''       
AS           
BEGIN     
select id as ID,TickTypeValue as name from [dbo].[obp_TickTypeDDLValues]  where   TickTypeValue <> 'Delete Task'       
order by TickTypeValue        
        
END 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetUserName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obp_sp_GetUserName]             
@usrnme nvarchar(MAX)='' ,            
@linkid int='' ,                    
@gridid nvarchar(MAX)=''  
,@id nvarchar(10)=''         
AS             
BEGIN       
select id,UserName 'name' from obps_Users where Company in ('GC','OPS') order by UserName      
          
END 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetUserName_OPS]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obp_sp_GetUserName_OPS]             
@usrnme nvarchar(MAX)='' ,            
@linkid int='' ,                    
@gridid nvarchar(MAX)=''  
,@id nvarchar(10)=''         
AS             
BEGIN     

  
select id,UserName 'name' from obps_Users where Company in ('GC','OPS') order by UserName      
          
END 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DDLLocations]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DDLLocations]  
(  
@usrnme NVARCHAR(MAX)='',            
@linkid int='' ,      
@gridid nvarchar(MAX)=''  
)  
AS       
BEGIN       
SELECT id,convert(nvarchar,LocationCode) name from obp_gms_Locations
order by id      
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DDLLocationType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DDLLocationType]   
(@usrnme NVARCHAR(MAX)='',             
@linkid int='' ,       
@gridid nvarchar(MAX)=''   
)   
AS        
BEGIN        
SELECT 1 'id','SP' 'name'  
UNION 
SELECT 1 'id','PL' 'name'  
UNION 
SELECT 1 'id','WH' 'name'  
 order by id       
 END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DDLSkuCode]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DDLSkuCode]      
(      
@usrnme NVARCHAR(MAX)='',                
@linkid int='' ,          
@gridid nvarchar(MAX)=''  ,
@ddlSelectedValue nvarchar(MAX)=''
)      
AS           
BEGIN           
SELECT id,convert(nvarchar,skucode) name from obp_gms_Skus  
order by id          
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DDLUom]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DDLUom]  
(  
@usrnme NVARCHAR(MAX)='',            
@linkid int='' ,      
@gridid nvarchar(MAX)=''  
)  
AS       
BEGIN       
SELECT id,convert(nvarchar,uom) name from obp_gms_UOM
order by id      
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DDLWeekDays]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DDLWeekDays]    
(    
@usrnme NVARCHAR(MAX)='',              
@linkid int='' ,        
@gridid nvarchar(MAX)=''    
)    
AS         
BEGIN         
SELECT 1 id,'Mon' name 
UNION
SELECT 2 id,'Tue' name 
UNION
SELECT 3 id,'Wed' name 
UNION
SELECT 4 id,'Thur' name 
UNION
SELECT 5 id,'Fri' name 
UNION
SELECT 6 id,'Sat' name 
UNION
SELECT 7 id,'Sun' name 
order by id        
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DeactivationPolicy]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DeactivationPolicy]    
(@var_user nvarchar(100)=''                                        
,@var_pid int=''                                        
,@var_clientid int='')      
AS    
BEGIN    
    
select id  
,EventName 'eventname__obp_gms_deactivationpolicy'  
,LocationId 'locationid__obp_gms_deactivationpolicy'  
,FromDate  'fromdate__obp_gms_deactivationpolicy'  
,ToDate 'todate__obp_gms_deactivationpolicy'  
,IsDeactivated 'isdeactivated__obp_gms_deactivationpolicy'  
,isrowedit1
from obp_gms_DeactivationPolicy  
where isdeactivated=0

END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DeactivationPolicyAfterSave]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DeactivationPolicyAfterSave]
@id nvarchar(10)=''
AS
BEGIN

update obp_gms_DeactivationPolicy set isrowedit1=0 where id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_DeactivationPolicyDelete]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_DeactivationPolicyDelete]  
@key nvarchar(10)='',  
@usr nvarchar(100)  
AS  
BEGIN  
  
update obp_gms_DeactivationPolicy set IsDeactivated=1 where id=@key  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_Location_ImportErrorOut]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obp_sp_gms_Location_ImportErrorOut]         
@usrname NVARCHAR(MAX)= NULL        
as                            
begin                            
                        
 select id
,LocationCode
,LocationDescription
,LocationType
,City
,State
,Region
,Pincode
,DefaultOrigin
,AutoInDays
,ReplWeekDays
,LocationPriority
,ReplPolicyName
,IsSmartReplAcitve
,ReplHoldDays
,Reason
,CreatedDate 'UpdatedDate'
 from obp_gms_Locations_temp                            
 where IsValid=0           
 and       
 UserName=@usrname      
                            
end 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_Location_ImportSavedOut]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obp_sp_gms_Location_ImportSavedOut]         
@usrname NVARCHAR(MAX)= NULL        
as                            
begin                            
                        
 select id
,LocationCode
,LocationDescription
,LocationType
,City
,State
,Region
,Pincode
,DefaultOrigin
,AutoInDays
,ReplWeekDays
,LocationPriority
,ReplPolicyName
,IsSmartReplAcitve
,ReplHoldDays
,Reason
,CreatedDate 'UpdatedDate'
 from obp_gms_Locations_temp                            
 where IsValid=1           
 and       
 UserName=@usrname      
                            
end 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_Locations]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_Locations]    
(@var_user nvarchar(100)=''                                        
,@var_pid int=''                                        
,@var_clientid int='')      
AS    
BEGIN    
    
select id    
,LocationCode  'locationcode__obp_gms_locations'  
,LocationDescription  'locationdescription__obp_gms_locations'  
,LocationType  'locationtype__obp_gms_locations'  
,City  'city__obp_gms_locations'  
,State  'state__obp_gms_locations'  
,Region  'region__obp_gms_locations'  
,Pincode  'pincode__obp_gms_locations'  
,DefaultOrigin  'defaultorigin__obp_gms_locations'  
,LocationPriority 'locationpriority__obp_gms_locations'
,ReplWeekDays --'replweekdays__obp_gms_locations'  
,ReplPolicyName-- 'replpolicyname__obp_gms_locations'
,AutoInDays  'autoindays__obp_gms_locations'  
,IsSmartReplAcitve 'issmartreplacitve__obp_gms_locations'
from obp_gms_Locations    
    
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_LocationsImportFormat]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_LocationsImportFormat]
AS 
BEGIN
	select 'LocationCode'
	UNION
	select 'LocationDescription'
	UNION
	select 'LocationType'
	UNION
	select 'City'
	UNION
	select 'State'
	UNION
	select 'Region'
	UNION
	select 'Pincode'
	UNION
	select 'DefaultOrigin'
	UNION
	select 'AutoInDays'
	UNION
	select 'ReplWeekDays'
	UNION
	select 'LocationPriority'
	UNION
	select 'ReplPolicyName'
	UNION
	select 'IsSmartReplAcitve'
	UNION
	select 'ReplHoldDays'
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_LocationSkus]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_LocationSkus]      
(@var_user nvarchar(100)=''                                          
,@var_pid int=''                                          
,@var_clientid int='')        
AS      
BEGIN      
      
select id    
,LocationId locationid__obp_gms_locationskus    
,SkuId skuid__obp_gms_locationskus    
--,SkuDescription skudescription__obp_gms_locationskus    
,BufferSize buffersize__obp_gms_locationskus    
,ReplTime repltime__obp_gms_locationskus    
,UomId uomid__obp_gms_locationskus    
,InvAtStite invatstite__obp_gms_locationskus    
,InvAtTransit invattransit__obp_gms_locationskus    
,InvAtProduction invatproduction__obp_gms_locationskus    
,DispOriginId1 disporiginid1__obp_gms_locationskus    
,DispOriginId2 disporiginid2__obp_gms_locationskus    
,DispOriginId3 disporiginid3__obp_gms_locationskus    
,MinReplenishmentQty minreplenishmentqty__obp_gms_locationskus    
,ReplenishmentMultiples replenishmentmultiples__obp_gms_locationskus    
,IsReplenish isreplenish__obp_gms_locationskus    
,CreatedDate 'UpdatedDate'    
from obp_gms_LocationSkus      
      
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_LocationSkus_ImportErrorOut]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obp_sp_gms_LocationSkus_ImportErrorOut]           
@usrname NVARCHAR(MAX)= NULL          
as                              
begin                              
                          
 select id
,LocationId
,SkuId
,SkuDescription
,BufferSize
,ReplTime
,UomId
,InvAtStite
,InvAtTransit
,InvAtProduction
,DispOriginId1
,DispOriginId2
,DispOriginId3
,MinReplenishmentQty
,ReplenishmentMultiples
,IsReplenish
,CreatedDate 'UpdatedDate'  
 from obp_gms_locationskus_temp                              
 where IsValid=0             
 and         
 UserName=@usrname        
                              
end 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_LocationSkus_ImportSavedOut]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obp_sp_gms_LocationSkus_ImportSavedOut]           
@usrname NVARCHAR(MAX)= NULL          
as                              
begin                              
                          
 select id
,LocationId
,SkuId
,SkuDescription
,BufferSize
,ReplTime
,UomId
,InvAtStite
,InvAtTransit
,InvAtProduction
,DispOriginId1
,DispOriginId2
,DispOriginId3
,MinReplenishmentQty
,ReplenishmentMultiples
,IsReplenish
,CreatedDate 'UpdatedDate'  
 from obp_gms_LocationSkus_temp                              
 where IsValid=1            
 and         
 UserName=@usrname        
                              
end 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_LocationSkusImportFormat]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_LocationSkusImportFormat]  
AS   
BEGIN  
 select 'LocationId'
 union
select 'SkuId'
union
select 'SkuDescription'
union
select 'BufferSize'
union
select 'ReplTime'
union
select 'UomId'
union
select 'InvAtStite'
union
select 'InvAtTransit'
union
select 'InvAtProduction'
union
select 'DispOriginId1'
union
select 'DispOriginId2'
union
select 'DispOriginId3'
union
select 'MinReplenishmentQty'
union
select 'ReplenishmentMultiples'
union
select 'IsReplenish'
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_ReplenishmentPolicy]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[obp_sp_gms_ReplenishmentPolicy]  
(@var_user nvarchar(100)=''                                      
,@var_pid int=''                                      
,@var_clientid int='')    
AS  
BEGIN  
  
select id
,PolicyName policyname__obp_gms_ReplenishmentPolicy
,Mon mon__obp_gms_ReplenishmentPolicy
,Tue tue__obp_gms_ReplenishmentPolicy
,Wed wed__obp_gms_ReplenishmentPolicy
,Thur thur__obp_gms_ReplenishmentPolicy
,Fri fri__obp_gms_ReplenishmentPolicy
,alldays alldays__obp_gms_ReplenishmentPolicy
from   [dbo].obp_gms_ReplenishmentPolicy
  
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_Skus]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_Skus]    
(@var_user nvarchar(100)=''                                        
,@var_pid int=''                                        
,@var_clientid int='')      
AS    
BEGIN    
    
select id  
,SkuCode 'skucode__obp_gms_skus'  
,SkuDescription 'skudescription__obp_gms_skus'  
,CreatedDate 'Updateddate'  
from   [dbo].[obp_gms_Skus]  
    
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_SKUsImportFormat]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_SKUsImportFormat]
AS 
BEGIN
	select 'SkuCode'
	UNION
	SELECT 'SkuDescription'
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_StmPolicy]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_StmPolicy]    
(@var_user nvarchar(100)=''                                        
,@var_pid int=''                                        
,@var_clientid int='')      
AS    
BEGIN    
    
select id  
,PolicyName   policyname__obp_gms_stmpolicy
,PolicyState  policystate__obp_gms_stmpolicy
,IncreaseByPerc   increasebyperc__obp_gms_stmpolicy
,DecreaseByPerc decreasebyperc__obp_gms_stmpolicy
,IncreaseTrigger   increasetrigger__obp_gms_stmpolicy
,DecreaseTrigger   decreasetrigger__obp_gms_stmpolicy
,CreatedDate UpdatedDate  
from   [dbo].[obp_gms_StmPolicy]  
    
END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_Transactions]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_Transactions]  
(@var_user nvarchar(100)=''                                      
,@var_pid int=''                                      
,@var_clientid int='')    
AS  
BEGIN  
  
select id
,TransType
,FromLocationCode
,ToLocationCode
,SkuCode
,Quantity
,FromLocationName
,ToLocationName
,TransNum
,IsConsumption
,UpdateDate
from obp_gms_Transactions  

END
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_UOM]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_UOM]    
(@var_user nvarchar(100)=''                                        
,@var_pid int=''                                        
,@var_clientid int='')      
AS    
BEGIN    
    
select id  
,UOM 'uom__obp_gms_uom'  
from   [dbo].[obp_gms_uom]  
    
END
GO
/****** Object:  StoredProcedure [dbo].[obp_SP_GMSScheduler]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[obp_SP_GMSScheduler]
(
@var_user nvarchar(100)=''                                                                                 
,@var_pid int=''                                                                                 
,@var_clientid int=''                                                                                  
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''  
)
as
Begin

DECLARE @SearchLetter nvarchar(100)                                                                                              
SET @SearchLetter ='%'+ @var_user + '%'                                                                     

Select 
id,
PlannedStartDt as 'start',
TaskActEstDt as 'end',
th_taskheader as 'text',
0 as 'allday'
from 
obp_taskheader
where taskstatus<> 'CP'
and ClientID>1 and ParentId=0
and PlannedStartDt is not null
and Createdby=@var_user

End
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_InsertNonWorkingDays_OneTime]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[obp_sp_LocationMergeInsert]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_LocationMergeInsert]    
@UserName nvarchar(max)                                 
as    
begin     
    
 MERGE obp_gms_Locations AS TARGET    
 USING obp_gms_Locations_temp AS SOURCE    
 ON (TARGET.locationcode=SOURCE.locationcode and    
   TARGET.locationType=SOURCE.locationType)    
 WHEN NOT MATCHED BY TARGET    
 THEN     
  INSERT (LocationCode,LocationDescription,LocationType,City,State
,Region,Pincode,DefaultOrigin,IsActive,AutoInDays,CreatedBy
,CreatedDate,ReplWeekDays,LocationPriority
,ReplPolicyName,IsSmartReplAcitve,ReplHoldDays)      
  VALUES (SOURCE.LocationCode,SOURCE.LocationDescription,SOURCE.LocationType,SOURCE.City,SOURCE.State
,SOURCE.Region,SOURCE.Pincode,SOURCE.DefaultOrigin,1,AutoInDays,@username
,getdate(),SOURCE.ReplWeekDays,SOURCE.LocationPriority
,SOURCE.ReplPolicyName,SOURCE.IsSmartReplAcitve,SOURCE.ReplHoldDays)    
     WHEN MATCHED THEN UPDATE SET    
   TARGET.LocationDescription=SOURCE.LocationDescription ,    
  TARGET.city=SOURCE.city ,    
  TARGET.state=SOURCE.state;    
    
end    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_LocationSkusMergeInsert]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_LocationSkusMergeInsert]    
@UserName nvarchar(max)                                 
as    
begin     
    
 MERGE obp_gms_LocationSkus AS TARGET    
 USING obp_gms_LocationSkus_temp AS SOURCE    
 ON (TARGET.LocationId=SOURCE.LocationId and    
   TARGET.SkuId=SOURCE.SkuId)    
 WHEN NOT MATCHED BY TARGET    
 THEN     
  INSERT (LocationId,SkuId,SkuDescription,BufferSize,ReplTime
,UomId,InvAtStite,InvAtTransit,InvAtProduction,DispOriginId1
,DispOriginId2,DispOriginId3,MinReplenishmentQty,ReplenishmentMultiples
,UpdateDate,CreatedBy,CreatedDate)      
  VALUES ( SOURCE.LocationId,SOURCE.SkuId,SOURCE.SkuDescription, SOURCE.BufferSize, SOURCE.ReplTime
, SOURCE.UomId, SOURCE.InvAtStite, SOURCE.InvAtTransit, SOURCE.InvAtProduction, SOURCE.DispOriginId1
, SOURCE.DispOriginId2, SOURCE.DispOriginId3, SOURCE.MinReplenishmentQty, SOURCE.ReplenishmentMultiples
, getdate(),@username,getdate());
    
end    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_MainTaskCompletionCheck]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       Procedure [dbo].[obp_sp_MainTaskCompletionCheck]                                                  
(@var_RID int)                                                  
as                                                  
Begin                                 
        
        
/*If MainTask is moved to Backlog from Committed*/        
Declare @var_CommitStatus nvarchar(max), @var_CommitDate date    
Declare @var_CreatedUserType int        
    
Select @var_CreatedUserType=UserTypeId from obps_users where username= (Select top 1 Createdby from obp_Taskheader where id= @var_RID )        
Select @var_CommitStatus=Sprint,@var_CommitDate=CommittedDate from obp_Taskheader where Sprint='Backlog' and CommittedDate is not null and id= @var_RID        
        
/*Clear the entries when task is moved from Committed to Backlog Status*/        
    
If @var_CommitStatus='Backlog' and @var_CommitDate is not null        
Begin        
update obp_Taskheader        
set TaskStatus='NS',TimeBuffer='',BlackExcedDays=0,Color2=null,Color3=null,TaskDuration=null,        
TaskActStartDt=null,TaskActEstDt=null,PlannedStartDt=null,        
ActualFinishDate=null,OnHoldReason=null,ActualDuration=null,ActFinishDate=null,FKBy='N',th_SeqNo=null,CommittedDate=null,ClientClosureAcceptance=null        
,ClientClosureAcceptanceDate=null        
where Sprint='Backlog' and CommittedDate is not null and id= @var_RID        
        
update obp_Taskheader        
set TaskStatus='NS',TimeBuffer='',BlackExcedDays=0,Color2=null,Color3=null,TaskDuration=null,        
TaskActStartDt=null,TaskActEstDt=null,PlannedStartDt=null,        
ActualFinishDate=null,OnHoldReason=null,ActualDuration=null,ActFinishDate=null,FKBy='N',th_SeqNo=null,CommittedDate=null,ClientClosureAcceptance=null        
,ClientClosureAcceptanceDate=null        
where  ParentId= @var_RID        
        
End        
        
/*Make all Task Auto Committed for Non OPS users*/          
Declare @var_comp nvarchar(max),@var_Createdby nvarchar(max)          
Set @var_comp=(Select isnull(company,'') from obps_users where UserName=(Select createdby from obp_Taskheader where id=@var_RID))          
          
-- select * from obp_Taskheader order by id desc where sprint='Committed'          
If @var_comp='GC'          
Begin          
 update obp_Taskheader set Sprint='Committed',CommittedDate=cast(getdate() as date) where id=@var_RID and isnull(Sprint,'') not in ('Committed','Completed')  and  CommittedDate is null        
End          
        
--update obp_Taskheader set CommittedDate=getdate() where id=16256        
          
/*Check for Committed Column*/                                
Update obp_Taskheader set Sprint= (Select sprint from obp_Taskheader where id=@var_RID)                                
where ParentId=@var_RID                              
                            
/*Get the Committed Date*/                            
Update obp_Taskheader set CommittedDate=getdate() where id=@var_RID and Sprint='Committed' and CommittedDate is null                            
                              
/*Additional Checks for Single MainTask*/                                        
Declare @isEditFlg int = 0                                        
Set @isEditFlg=(Select isnull(isEdit,0) from obp_Taskheader where id=@var_RID)                                        
                                        
If @isEditFlg=1                                        
Begin                         
                                    
                                 
                                
/*Delete the task if selected status is DEL*/                                   
Delete from obp_Taskheader where id=@var_RID and TaskStatus='DEL'                       
                      
/*Add Implementer Details*/                            
Declare @var_TypeId int,@var_Implementer nvarchar(500),@var_SR_Implementer nvarchar(500) ,@var_MainAssingToUser nvarchar(max)                     
                      
Select                       
--TH.Createdby,             
@var_TypeId= U.UserTypeId          
--, @var_Implementer=CM.Implementer           
, @var_Implementer=( SELECT top 1 abc = STUFF(       
(Select '/ '+username from obps_users t1 where t1.company='OPS' FOR XML PATH(''))           
, 1          
, 1          
, ''          
) from obps_users t2  where t2.company='OPS'          
group by id)          
,@var_SR_Implementer='%'+CM.Implementer+'%'      
,@var_MainAssingToUser=CM.Implementer                    
 --,CM.ClientName                      
from (Select * from obp_Taskheader ) TH                        
join obps_users U on U.UserName=TH.Createdby                      
join obp_ClientMaster cm on cm.id =TH.ClientID                      
where Th.id = @var_RID                      
                      
if @var_TypeId=2                      
Begin                      
 If (Select isnull(count(*),0) from  obp_Taskheader where id=@var_RID and ShareToUser like @var_SR_Implementer)=0                      
    --Update obp_Taskheader set ShareToUser=ShareToUser+' / '+@var_Implementer where id=@var_RID                      
 Update obp_Taskheader set ShareToUser=ShareToUser+' / '+@var_Implementer,AssignToMain=@var_MainAssingToUser where id=@var_RID                      
End                      
                      
/*End - Add Implementer Details*/                         
                             
                          
/*If Task Status becomes Blank*/                              
update obp_TaskHeader set TaskStatus= case when isnull(TaskActStartDt,'1900-01-01') > '1900-01-01' then 'IP' else 'NS' end where id=@var_RID and isnull(TaskStatus,'')='' and isEdit=1                           
                            
                                  
/*To make TaskActualStart Date =today date if not provided for IP Tasks*/                                          
update obp_TaskHeader set TaskActStartDt=cast(getdate() as date)  where id=@var_rid and isnull(TaskActStartDt,'1900-01-01') ='1900-01-01' and TaskStatus='IP'                                          
      
/*To make MainTaskAssignToUser */      
/*2024-04-09*/      
update obp_TaskHeader set AssignToMain=Createdby  where id=@var_rid and AssignToMain is null      
      
                                        
Exec obp_sp_SubTaskEstDateCal @var_rid                                        
                                        
Exec obp_sp_TimeBufferCal_SMT @var_rid                                        
                                        
/*Check If CP Status is Valid*/                                        
Declare @var_Cat nvarchar(100),@var_DR nvarchar(100),@var_FinishEstDt date,@var_TB nvarchar(100),@var_TS nvarchar(100)                                        
Select @var_Cat=isnull(TicketCatg1,'-'),@var_DR=isnull(OnHoldReason,'-'),@var_TB=isnull(color3,'-'),@var_TS=isnull(TaskStatus,'-'),@var_FinishEstDt=isnull(TaskActEstDt,'1900-01-01')                                         
from obp_Taskheader where id=@var_RID                                        
                                        
If (@var_TB='Black' and @var_TS='CP')                                        
Begin                                        
 If(@var_Cat='-' or @var_DR='-' or @var_FinishEstDt='1900-01-01')                                        
 Begin                                        
 update obp_Taskheader set TaskStatus='IP' where id=@var_RID                                        
 End                                        
End                                        
                                        
/*Trace is moved from here to end of script on 2024-03-12*/                  
                                        
End                                        
/*End - Additional Checks for Single MainTask*/                                    
                           
                                        
/*Comments to be added                                            
Also indicate which block can be removed when it is handled in UI                                  
*/                                                  
                                           
Declare @var_TicketCatg nvarchar(100),@var_TicketDelayReason nvarchar(200),@var_TimeBufferColor nvarchar(10)                                                  
Declare @var_CnfFlg int                                                   
Declare @vaR_STStatus nvarchar(10),@vaR_MTStatus nvarchar(10)                                                  
                                              
Set @var_CnfFlg=0                                              
                                                  
Select @vaR_MTStatus=TaskStatus,@var_TicketCatg=isnull(TicketCatg1,'-'),@var_TimeBufferColor=Color3,@var_TicketDelayReason=isnull(OnHoldReason,'-') from obp_TaskHeader where id=@var_RID  and ParentId=0                                                 
Set @vaR_STStatus=(Select isnull(max(TaskStatus),'-') from obp_TaskHeader where parentid=@var_RID and TaskStatus<>'CP' and isActive=1)                                                  
                                
--Select isnull(max(TaskStatus),'-') from obp_TaskHeader where parentid=11316 and TaskStatus<>'CP' and isDeleted=0                                              
Select @var_TicketCatg ,@var_TicketDelayReason ,@var_TimeBufferColor                                              
Select @vaR_MTStatus,@vaR_STStatus                                              
                                              
print @var_CnfFlg                                              
                                                  
If (@vaR_STStatus='-' and @vaR_MTStatus='IP')                                                  
Begin                                                  
Set @var_CnfFlg = 1                                                  
End                                                  
Else                                                  
Begin                                                  
Set @var_CnfFlg = 0                                                  
End                                              
                                            
/*                                            
If (@vaR_STStatus='-' and @vaR_MTStatus='IP')                                                  
 Set @var_CnfFlg = 1                                                 
Else                                                  
 Set @var_CnfFlg = 0                                                  
*/                                               
                                              
print @var_CnfFlg                                               
                                                  
If (@var_TicketCatg<>'-'  and @var_CnfFlg=1)                                              
Begin                                                  
Set @var_CnfFlg = 1                                                  
End                                                  
Else                                                  
Begin                                                  
Set @var_CnfFlg = 0                                                  
End                            
                                              
print @var_CnfFlg                                              
                                                  
If (@var_TimeBufferColor='Black' and @var_TicketDelayReason<>'-' and @var_CnfFlg=1)                                                  
Begin                                                  
Set @var_CnfFlg = 1                                        
End                                                  
Else                                                  
Begin                                                  
Set @var_CnfFlg = 0                                                  
End                                                  
                                              
print @var_CnfFlg                                                  
IF (@var_CnfFlg = 1)                                             
Begin                                                  
Update obp_TaskHeader set taskstatus='CP' where id=@var_RID and isnull(ParentId,0)=0                                                  
End                                                  
    
/*                
/*Client Close the tasks*/                                                  
If (Select isnull(ClientClosureAcceptance,'') from obp_Taskheader where id=@var_RID and TaskStatus='CP')='True'                
 Update obp_Taskheader set ClientClosureAcceptanceDate=cast(getdate() as date) where id = @var_RID and TaskStatus='CP' and ClientClosureAcceptance='True' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01'                
*/    
    
/*Client Close the tasks*/      
If @var_CreatedUserType=2    
Begin    
     
If (Select isnull(TaskStatus,'') from obp_Taskheader where id=@var_RID )='CL'                
 Update obp_Taskheader set ModifiedDate = cast(getdate() as date),ActFinishDate=cast(getdate() as date)
 , ClientClosureAcceptanceDate=cast(getdate() as date),ClientClosureAcceptance='True'     
 where id = @var_RID and TaskStatus='CL' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01'     
End    
    
/*Auto Close Non-Client tasks */    
If @var_CreatedUserType <> 2    
Begin    
     
If (Select isnull(TaskStatus,'') from obp_Taskheader where id=@var_RID )='CP'                
 Update obp_Taskheader set TaskStatus='CL',ModifiedDate = cast(getdate() as date),ActFinishDate=cast(getdate() as date) 
 ,ClientClosureAcceptanceDate=cast(getdate() as date),ClientClosureAcceptance='True'     
 where id = @var_RID and TaskStatus='CP' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01'     
End    
    
/* Commented as Reopen is not required                
/*Client Re-open the tasks completed by Team*/                  
If (Select isnull(ClientClosureAcceptance,'') from obp_Taskheader where id=@var_RID and TaskStatus='CP')='Reopen'                
 Update obp_Taskheader set TaskStatus='IP',ClientClosureAcceptance='',Sprint='Committed' where id = @var_RID and TaskStatus='CP' and ClientClosureAcceptance='Reopen' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01'                
*/    
                
/*Insert Trace Record*/                                        
Insert into obp_TaskHeader_Trace                                                  
Select                                               
 id,                                              
ClientID,                                              
th_TaskHeader,                                              
TaskStatus,                                              
EstDueDate,                                              
th_Remarks,                                              
TimeBuffer,              
BlackExcedDays,                                              
Color1,                                              
Color2,                                              
Color3,                                              
isActive,                                              
AccessToUser,                                              
ShareToUser,                                              
ScheduleType,                     
TaskDuration,                                              
TaskActStartDt,                                            
TaskActEstDt,                                              
PlannedStartDt,                                              
Reason,                                              
ParentId,                                              
ActualFinishDate,                                              
OnHoldReason,                                              
TicketCatg1,                                              
ActualDuration,                                              
CreatedDate,                                              
ModifiedDate,                                              
Createdby,                                              
Modifiedby,                                              
'M-U',                                              
getdate(),                      
td_SeqNo,                                              
ActFinishDate,                                              
FKBy,                                              
th_SeqNo                                              
--*,'M-U',getdate()                                               
from obp_TaskHeader where id in (@var_rid)                                          
                                                                      
                                     
End                                       

GO
/****** Object:  StoredProcedure [dbo].[obp_sp_MainTaskCompletionCheck_20240229]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    procedure [dbo].[obp_sp_MainTaskCompletionCheck_20240229]
(@var_RID int)                            
as                            
Begin                  
/*Check for Committed Column*/          
Update obp_Taskheader set Sprint= (Select sprint from obp_Taskheader where id=@var_RID)          
where ParentId=@var_RID        
      
/*Get the Committed Date*/      
Update obp_Taskheader set CommittedDate=getdate() where id=@var_RID and Sprint='Committed' and CommittedDate is null      
        
/*Additional Checks for Single MainTask*/                  
Declare @isEditFlg int = 0                  
Set @isEditFlg=(Select isnull(isEdit,0) from obp_Taskheader where id=@var_RID)                  
                  
If @isEditFlg=1                  
Begin                 
           
          
/*Delete the task if selected status is DEL*/             
Delete from obp_Taskheader where id=@var_RID and TaskStatus='DEL'          
    
/*If Task Status becomes Blank*/        
update obp_TaskHeader set TaskStatus= case when isnull(TaskActStartDt,'1900-01-01') > '1900-01-01' then 'IP' else 'NS' end where id=@var_RID and isnull(TaskStatus,'')='' and isEdit=1     
      
            
/*To make TaskActualStart Date =today date if not provided for IP Tasks*/                    
update obp_TaskHeader set TaskActStartDt=cast(getdate() as date)  where id=@var_rid and isnull(TaskActStartDt,'1900-01-01') ='1900-01-01' and TaskStatus='IP'                    
                  
Exec obp_sp_SubTaskEstDateCal @var_rid                  
                  
Exec obp_sp_TimeBufferCal_SMT @var_rid                  
                  
/*Check If CP Status is Valid*/                  
Declare @var_Cat nvarchar(100),@var_DR nvarchar(100),@var_FinishEstDt date,@var_TB nvarchar(100),@var_TS nvarchar(100)                  
Select @var_Cat=isnull(TicketCatg1,'-'),@var_DR=isnull(OnHoldReason,'-'),@var_TB=isnull(color3,'-'),@var_TS=isnull(TaskStatus,'-'),@var_FinishEstDt=isnull(TaskActEstDt,'1900-01-01')                   
from obp_Taskheader where id=@var_RID                  
                  
If (@var_TB='Black' and @var_TS='CP')                  
Begin                  
 If(@var_Cat='-' or @var_DR='-' or @var_FinishEstDt='1900-01-01')                  
 Begin                  
 update obp_Taskheader set TaskStatus='IP' where id=@var_RID                  
 End                  
End                  
                  
/*Insert Trace Record*/                  
Insert into obp_TaskHeader_Trace                            
Select                         
 id,                        
ClientID,                        
th_TaskHeader,                        
TaskStatus,                        
EstDueDate,                        
th_Remarks,                        
TimeBuffer,                        
BlackExcedDays,                        
Color1,                        
Color2,                        
Color3,                        
isActive,                        
AccessToUser,                        
ShareToUser,                        
ScheduleType,                        
TaskDuration,                        
TaskActStartDt,                        
TaskActEstDt,                        
PlannedStartDt,                        
Reason,                        
ParentId,                        
ActualFinishDate,                        
OnHoldReason,                        
TicketCatg1,                        
ActualDuration,                        
CreatedDate,                        
ModifiedDate,                        
Createdby,                        
Modifiedby,                        
'M-U',                        
getdate(),                        
td_SeqNo,                        
ActFinishDate,                        
FKBy,                        
th_SeqNo                        
--*,'M-U',getdate()                         
from obp_TaskHeader where id in (@var_rid)                    
                  
                  
End                  
/*End - Additional Checks for Single MainTask*/                  
     
                  
/*Comments to be added                      
Also indicate which block can be removed when it is handled in UI                      
*/                            
                     
Declare @var_TicketCatg nvarchar(100),@var_TicketDelayReason nvarchar(200),@var_TimeBufferColor nvarchar(10)                            
Declare @var_CnfFlg int                             
Declare @vaR_STStatus nvarchar(10),@vaR_MTStatus nvarchar(10)                            
                        
Set @var_CnfFlg=0                        
                            
Select @vaR_MTStatus=TaskStatus,@var_TicketCatg=isnull(TicketCatg1,'-'),@var_TimeBufferColor=Color3,@var_TicketDelayReason=isnull(OnHoldReason,'-') from obp_TaskHeader where id=@var_RID  and ParentId=0                           
Set @vaR_STStatus=(Select isnull(max(TaskStatus),'-') from obp_TaskHeader where parentid=@var_RID and TaskStatus<>'CP' and isActive=1)                            
          
--Select isnull(max(TaskStatus),'-') from obp_TaskHeader where parentid=11316 and TaskStatus<>'CP' and isDeleted=0                        
Select @var_TicketCatg ,@var_TicketDelayReason ,@var_TimeBufferColor                        
Select @vaR_MTStatus,@vaR_STStatus                        
                        
print @var_CnfFlg                        
                            
If (@vaR_STStatus='-' and @vaR_MTStatus='IP')                            
Begin                            
Set @var_CnfFlg = 1                            
End                            
Else                            
Begin                            
Set @var_CnfFlg = 0                            
End                        
                      
/*                      
If (@vaR_STStatus='-' and @vaR_MTStatus='IP')                            
 Set @var_CnfFlg = 1                           
Else                            
 Set @var_CnfFlg = 0                            
*/                         
                        
print @var_CnfFlg                         
                            
If (@var_TicketCatg<>'-'  and @var_CnfFlg=1)                        
Begin                            
Set @var_CnfFlg = 1                            
End                            
Else                            
Begin                            
Set @var_CnfFlg = 0                            
End                            
                        
print @var_CnfFlg                        
                            
If (@var_TimeBufferColor='Black' and @var_TicketDelayReason<>'-' and @var_CnfFlg=1)                            
Begin                            
Set @var_CnfFlg = 1                            
End                            
Else                            
Begin                            
Set @var_CnfFlg = 0                            
End                            
                        
print @var_CnfFlg                            
IF (@var_CnfFlg = 1)                            
Begin                            
Update obp_TaskHeader set taskstatus='CP' where id=@var_RID and isnull(ParentId,0)=0                            
End                            
                            
                          
                            
End                 
    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_MaiTaskDatesCal]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[obp_sp_MaiTaskDatesCal]    
( @var_RID int )    
as    
Begin    
    
/*Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                                  
Declare @var_headerticketid int,@var_PlannedStartDt datetime,@var_TaskActEstDt datetime,@var_TaskDuration int,@var_TaskActStartDt datetime                      
                      
Set @var_headerticketid =(Select top 1 ParentId from obp_TaskHeader where id=@var_RID)                      
Set @var_PlannedStartDt =(Select min(isnull(PlannedStartDt,'1900-01-01')) from obp_TaskHeader where ParentId=@var_headerticketid  and th_TaskHeader<>'Click + Sign to Add Records' and isnull(PlannedStartDt,'1900-01-01')<>'1900-01-01')                     
     
Set @var_TaskActEstDt =(Select max(isnull(TaskActEstDt,'1900-01-01')) from obp_TaskHeader where ParentId=@var_headerticketid and th_TaskHeader<>'Click + Sign to Add Records')                      
Set @var_TaskActStartDt =(Select min(isnull(TaskActStartDt,'1900-01-01')) from obp_TaskHeader where ParentId=@var_headerticketid and TaskActStartDt is not null and th_TaskHeader<>'Click + Sign to Add Records')                 
                
    
Select @var_headerticketid ,@var_PlannedStartDt ,@var_TaskActEstDt ,@var_TaskDuration,@var_TaskActStartDt                      
                      
if @var_PlannedStartDt<>'1900-01-01'                      
Begin                      
Update obp_TaskHeader set PlannedStartDt=@var_PlannedStartDt where id=@var_headerticketid                      
End                      
Else                      
Begin                      
Update obp_TaskHeader set PlannedStartDt=null where id=@var_headerticketid                      
End                      
                      
if @var_TaskActEstDt<>'1900-01-01'                      
Begin                      
Update obp_TaskHeader set TaskActEstDt=@var_TaskActEstDt where id=@var_headerticketid                      
End                      
Else                      
Begin                      
Update obp_TaskHeader set TaskActEstDt=null where id=@var_headerticketid                      
End                      
                      
if @var_TaskActStartDt<>'1900-01-01'                      
Begin                      
Update obp_TaskHeader set TaskActStartDt=@var_TaskActStartDt where id=@var_headerticketid                      
End                      
Else                      
Begin                      
Update obp_TaskHeader set TaskActStartDt=null where id=@var_headerticketid                      
End                      
                      
update obp_TaskHeader set TaskDuration= case when (isnull(@var_PlannedStartDt,'1900-01-01')<>'1900-01-01' and isnull(@var_TaskActEstDt,'1900-01-01')<>'1900-01-01') then                       
datediff(dd,@var_PlannedStartDt,@var_TaskActEstDt)+1 else null end                       
where id=@var_headerticketid     
    
    
End  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_AllClientSubTasks]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  proc [dbo].[obp_sp_Pl_AllClientSubTasks]                                                          
(@var_user nvarchar(100)=''                
,@var_pid int='',                                                          
@var_clientid int='')                                                          
as                                                          
begin                                                          
                                                          
DECLARE @SearchLetter nvarchar(100)                                                          
SET @SearchLetter ='%'+ @var_user + '%'                                                          
                                                          
 select td.id,        
 case when th.Sprint='Committed' then 1 else 0 end 'iscelledit1',                              
 th.color1,td.color2,td.color3                                                  
 ,td.id as 'Task No'                                             
 ,td.th_TaskHeader as th_taskheader__obp_taskheader                                          
                                                 
,td.PlannedStartDt  as plannedstartdt__obp_taskheader                                      
 ,td.TaskDuration as taskduration__obp_taskheader                  
--,convert(nvarchar(4),datepart(yyyy,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,td.TaskActEstDt)) as 'Planned Finish'                 
,convert(nvarchar(10),cast(td.TaskActEstDt as date)) as TaskActEstDt__obp_taskheader          
,td.TaskActStartDt as 'taskactstartdt__obp_taskheader'                   
,td.TaskStatus as taskstatus__obp_taskheader                                                           
 ,td.TimeBuffer as timebuffer__obp_taskheader                                                                                                                          
 ,td.th_Remarks as th_remarks__obp_taskheader                                          
 ,td.ShareToUser as sharetouser__obp_taskheader                                                                                    
 --,convert(nvarchar(10),cast(td.ModifiedDate as date)) as ModifiedDate__obp_taskheader                                                                      
 ,convert(char(10),td.ModifiedDate,126) 'LastModDt'  
  from   (Select * from obp_taskheader where id=@var_pid) th                                                                                                       
  right join  obp_taskheader td                                                          
  --on th.id=td.TaskHeaderID                                                          
  on th.id=td.ParentId                                                          
  --Added on 24-05-2021--to have access control form obp_ClientMaster table                                                           
  left join obp_ClientMaster cm on th.ClientID=cm.id                                                                                                      
 where                           
  --td.taskheaderid=@var_pid  or  td.ParentId=@var_pid                                            
  td.ParentId=@var_pid                
  and td.isActive=1               
  order by isnull(td.PlannedStartDt,'2050-01-01'),isnull(td.TaskActEstDt,'2050-01-01')                      
                                                           
end           
      
	    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_AllClientTasks]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     proc [dbo].[obp_sp_Pl_AllClientTasks]              
(@var_user nvarchar(100)=''                                                                                       
,@var_pid int=''                                                                                       
,@var_clientid int=''                                                                                        
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''            
)                                                                                                    
as                                                                                                    
begin                                                                                                    
                                                                                                    
DECLARE @SearchLetter nvarchar(100)                                                                                                    
SET @SearchLetter ='%'+ @var_user + '%'                                                                           
                                                                          
Declare @var_usertype int                                                                          
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)                            
print @var_usertype                                                                  
/*Client*/                                                                                                    
If @var_usertype=2                                                                         
Begin                                                                          
                                                                                     
select                                                                                       
th.id,                                                                                                    
th.color1,th.color2,th.color3                                                                                       
,th.id as 'TicketNo'                                                                                     
,cm.clientname as clientid__obp_taskheader                                                                                                  
,th.th_taskheader as th_taskheader__obp_taskheader                                                                        
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'Expected Delivery Date'         
,th.th_remarks as th_remarks__obp_taskheader                                         
 ,th.taskstatus as 'Task Status'                                                           
,cm.Implementer as 'Owner'           
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'LastModDate'        
                             
from obp_TaskHeader th                                                                                               
left join obp_ClientMaster cm  on th.ClientID=cm.id          
where                                                                                          
((cm.id in (select value from string_split(@var_par1,',')) ) )                                                                          
and isnull(th.Createdby,'') like @SearchLetter                                                                                     
and th.isActive=1                                                                         
--and th.taskheaderid is null                                                                                           
and isnull(th.ParentId,0) =0                                                                           
--and th.TaskStatus in (select value from string_split(@var_par3,','))                  
--and th.TicketType in (select value from string_split(@var_par2,','))                                                                          
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                
and th.TaskStatus not in ('CP','CL')                                                                                      
End                                                                          
  
/*                                                                          
/*Managers*/                                                                   
If @var_usertype=4                                                                         
Begin                                                                          
select                                                                                                          
th.id,                                                                                                    
th.color1,th.color2,th.color3                                                                                       
,th.id as 'TicketNo'                                                                                     
,cm.clientname as clientid__obp_taskheader                                                                                                  
,th.th_taskheader as th_taskheader__obp_taskheader                                                                        
,th.TimeBuffer as timebuffer__obp_taskheader                                                      
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                                             
 ,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'PlannedStart'                                                 
,th.TaskDuration as 'Duration'                                         
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                       
,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'ActualStart'                                                                     
/*,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish' */                                                      
 --,th.taskstatus as taskstatus__obp_taskheader                                                                               
 ,th.taskstatus as 'Task Status'                                                                                
,th.EstDueDate as estduedate__obp_taskheader                                                                      
                                     
,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                                                       
                                                                 
,th.th_remarks as th_remarks__obp_taskheader                                                     
,th.OnHoldReason as onholdreason__obp_taskheader                                                                                                   
,replace(th.ShareToUser,'/','')  as 'AssignToUser'                                                                                                     
,cm.Implementer as 'Incharge'                                                                   
,th.ModifiedDate as ModifiedDate__obp_taskheader                                                     
,th.CreatedDate as CreatedDate__obp_taskheader                                     
                                      
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                         
,ActFinishDate as 'actfinishdate__obp_taskheader'                                                      
,FKBy as 'fkby__obp_taskheader'                                                                          
,th_SeqNo as 'th_seqno__obp_taskheader'                              
from obp_TaskHeader th                                                                                                    
left join obp_ClientMaster cm  on th.ClientID=cm.id                                               
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                              
--on tl.TicketId=th.id                                                                 
where                                                                                          
--((cm.id in (select value from string_split(@var_par1,',')) ) )     and       
th.ClientID >1 and     
th.isActive=1                                                                         
--and th.taskheaderid is null                                                                                           
and isnull(th.ParentId,0) =0                                              
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                           
and th.TaskStatus not in ('CP')                                                                          
--and th.ShareToUser like @SearchLetter                                           
and cast(th.CreatedDate as date) > '2023-03-01'                                             
                                          
                                                                      
End               
*/                                                                          
                                                                         
/*Tech - Buss Users*/                                                                          
If (@var_usertype=5    or @var_usertype=4)  
Begin                                          
Select                 
th.id,                 
case when (th.isedit=1 and th.Sprint='Committed') then 1 else 0 end 'iscelledit1',                                   
case when th.isedit=1 then 1 else 0 end 'iscelledit2',                             
case when th.isedit=1 then 1 else 0 end 'iscelledit3',                                   
case when th.isedit=1 then 1 else 0 end 'iscelledit4',                    
th.color1,th.color2,th.color3                                                                                       
,th.id as 'TicketNo'                                                       
--,th.id as id__obp_taskheader                                                    
,cm.clientname as clientid__obp_taskheader             
,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'           
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                  
,th.th_taskheader as th_taskheader__obp_taskheader            
,FKBy as 'fkby__obp_taskheader'                                   
,replace(th.ShareToUser,'/','')  as 'assigntouser'           
,th.TaskDuration as 'taskduration__obp_taskheader'          
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'           
,th.PlannedStartDt 'plannedstartdt__obp_taskheader'           
,convert(nvarchar(10),cast(th.TaskActEstDt as date)) 'Planned Finish'          
,ActFinishDate as 'actfinishdate__obp_taskheader'          
,th_SeqNo as 'th_seqno__obp_taskheader'          
,Sprint as 'sprint__obp_taskheader'          
,th.taskstatus as 'taskstatus__obp_taskheader'          
,th.TaskActStartDt 'taskactstartdt__obp_taskheader'          
,th.TimeBuffer as timebuffer__obp_taskheader          
,th.BlackExcedDays as blackexceddays__obp_taskheader           
,th.th_remarks as th_remarks__obp_taskheader          
,th.OnHoldReason as onholdreason__obp_taskheader          
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as ModifiedDate__obp_taskheader            
,convert(nvarchar(10),cast(th.CreatedDate as date)) as CreatedDate__obp_taskheader          
/*,th.EstDueDate as estduedate__obp_taskheader*/          
          
from obp_TaskHeader th                                                                                                    
--left join obp_ClientMaster cm  on th.ClientID=cm.id                     
 join obp_ClientMaster cm  on th.ClientID=cm.id                                                                                           
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                     
--on tl.TicketId=th.id                                              
where                                                                                          
((cm.id in (select value from string_split(@var_par1,',')) ) )     and                                                                
th.isActive=1                                                                         
--and th.taskheaderid is null                                                                                           
and isnull(th.ParentId,0) =0                                              
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                           
and th.TaskStatus not in ('CP','CL')                                                                          
--and th.ShareToUser like @SearchLetter                                           
and cast(th.CreatedDate as date) > '2023-03-01'                                                             
End                                                                          
                                                                          
                                                          
                                                       
End                           
                
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_AllClientTasks_20231222]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    proc [dbo].[obp_sp_Pl_AllClientTasks_20231222]            
(@var_user nvarchar(100)=''                                                                                     
,@var_pid int=''                                                                                     
,@var_clientid int=''                                                                                      
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''          
)                                                                                                  
as                                                                                                  
begin                                                                                                  
                                                                                                  
DECLARE @SearchLetter nvarchar(100)                                                                                                  
SET @SearchLetter ='%'+ @var_user + '%'                                                                         
                                                                        
Declare @var_usertype int                                                                        
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)                          
print @var_usertype                                                                
/*Client*/                                                                                                  
If @var_usertype=2                                                                       
Begin                                                                        
                                                                                   
select                                                                                     
th.id,                                                                                                  
th.color1,th.color2,th.color3                                                                                     
,th.id as 'TicketNo'                                                                                   
,cm.clientname as clientid__obp_taskheader                                                                                                
,th.th_taskheader as th_taskheader__obp_taskheader                                                                      
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'Expected Delivery Date'       
,th.th_remarks as th_remarks__obp_taskheader                                       
 ,th.taskstatus as 'Task Status'                                                         
,cm.Implementer as 'Owner'         
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'LastModDate'      
                           
from obp_TaskHeader th                                                                                             
left join obp_ClientMaster cm  on th.ClientID=cm.id        
where                                                                                        
((cm.id in (select value from string_split(@var_par1,',')) ) )                                                                        
and isnull(th.Createdby,'') like @SearchLetter                                                                                   
and th.isActive=1                                                                       
--and th.taskheaderid is null                                                                                         
and isnull(th.ParentId,0) =0                                                                         
--and th.TaskStatus in (select value from string_split(@var_par3,','))                                                                                
--and th.TicketType in (select value from string_split(@var_par2,','))                                                                        
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                              
and th.TaskStatus not in ('CP')                                                                                    
End                                                                        
                                                                        
/*Managers*/                                                                 
If @var_usertype=4                                                                       
Begin                                                                        
select                                                                                                        
th.id,                                                                                                  
th.color1,th.color2,th.color3                                                                                     
,th.id as 'TicketNo'                                                                                   
,cm.clientname as clientid__obp_taskheader                                                                                                
,th.th_taskheader as th_taskheader__obp_taskheader                                                                      
,th.TimeBuffer as timebuffer__obp_taskheader                                                    
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                                           
 ,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'PlannedStart'                                               
,th.TaskDuration as 'Duration'                                       
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                     
,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'ActualStart'                                                                   
/*,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish' */                                                    
 --,th.taskstatus as taskstatus__obp_taskheader                                                                             
 ,th.taskstatus as 'Task Status'                                                                              
,th.EstDueDate as estduedate__obp_taskheader                                                                    
                                   
,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                                                     
                                                               
,th.th_remarks as th_remarks__obp_taskheader                                                   
,th.OnHoldReason as onholdreason__obp_taskheader                                                                                                 
,replace(th.ShareToUser,'/','')  as 'AssignToUser'                                                                                                   
,cm.Implementer as 'Incharge'                                                                 
,th.ModifiedDate as ModifiedDate__obp_taskheader                                                   
,th.CreatedDate as CreatedDate__obp_taskheader                                                                                                   
                                    
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                       
,ActFinishDate as 'actfinishdate__obp_taskheader'                                                    
,FKBy as 'fkby__obp_taskheader'                                                                        
,th_SeqNo as 'th_seqno__obp_taskheader'                            
from obp_TaskHeader th                                                                                                  
left join obp_ClientMaster cm  on th.ClientID=cm.id                                             
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                            
--on tl.TicketId=th.id                                                               
where                                                                                        
--((cm.id in (select value from string_split(@var_par1,',')) ) )     and     
th.ClientID >1 and   
th.isActive=1                                                                       
--and th.taskheaderid is null                                                                                         
and isnull(th.ParentId,0) =0                                            
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                         
and th.TaskStatus not in ('CP')                                                                        
--and th.ShareToUser like @SearchLetter                                         
and cast(th.CreatedDate as date) > '2023-03-01'                                           
                                        
                                                                    
End             
                                                                        
                                                                       
/*Tech - Buss Users*/                                                                        
If @var_usertype=5                                                                        
Begin                                        
Select               
th.id,               
case when (th.isedit=1 and th.Sprint='Committed') then 1 else 0 end 'iscelledit1',                                 
case when th.isedit=1 then 1 else 0 end 'iscelledit2',                           
case when th.isedit=1 then 1 else 0 end 'iscelledit3',                                 
case when th.isedit=1 then 1 else 0 end 'iscelledit4',                  
th.color1,th.color2,th.color3                                                                                     
,th.id as 'TicketNo'                                                     
--,th.id as id__obp_taskheader                                                  
,cm.clientname as clientid__obp_taskheader           
,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'         
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                
,th.th_taskheader as th_taskheader__obp_taskheader          
,FKBy as 'fkby__obp_taskheader'                                 
,replace(th.ShareToUser,'/','')  as 'assigntouser'         
,th.TaskDuration as 'taskduration__obp_taskheader'        
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'         
,th.PlannedStartDt 'plannedstartdt__obp_taskheader'         
,convert(nvarchar(10),cast(th.TaskActEstDt as date)) 'Planned Finish'        
,ActFinishDate as 'actfinishdate__obp_taskheader'        
,th_SeqNo as 'th_seqno__obp_taskheader'        
,Sprint as 'sprint__obp_taskheader'        
,th.taskstatus as 'taskstatus__obp_taskheader'        
,th.TaskActStartDt 'taskactstartdt__obp_taskheader'        
,th.TimeBuffer as timebuffer__obp_taskheader        
,th.BlackExcedDays as blackexceddays__obp_taskheader         
,th.th_remarks as th_remarks__obp_taskheader        
,th.OnHoldReason as onholdreason__obp_taskheader        
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as ModifiedDate__obp_taskheader          
,convert(nvarchar(10),cast(th.CreatedDate as date)) as CreatedDate__obp_taskheader        
/*,th.EstDueDate as estduedate__obp_taskheader*/        
        
from obp_TaskHeader th                                                                                                  
--left join obp_ClientMaster cm  on th.ClientID=cm.id                   
 join obp_ClientMaster cm  on th.ClientID=cm.id                                                                                         
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                   
--on tl.TicketId=th.id                                            
where                                                                                        
((cm.id in (select value from string_split(@var_par1,',')) ) )     and                                                              
th.isActive=1                                                                       
--and th.taskheaderid is null                                                                                         
and isnull(th.ParentId,0) =0                                            
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                         
and th.TaskStatus not in ('CP')                                                                        
--and th.ShareToUser like @SearchLetter                                         
and cast(th.CreatedDate as date) > '2023-03-01'                                                           
End                                                                        
                                                                        
                                                        
                                                     
End                         
                
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_Type02]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    Proc [dbo].[obp_sp_Pl_Type02]                          
(@var_user nvarchar(100)=''                                                                                                   
,@var_pid int=''                                                                                                   
,@var_clientid int=''                                                                                                    
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''                        
)                                                                                                                
as                                                                                                                
begin                                                                                                                
                                                                                                                
DECLARE @SearchLetter nvarchar(100)  ,@var_comp nvarchar(max)                                                                                                              
SET @SearchLetter ='%'+ @var_user + '%'             
SET @var_comp =(Select company from obps_Users where UserName = @var_user)          
                                                                                      
Declare @var_usertype int                                                                                      
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)                                        
print @var_usertype                                                                              
/*Client*/                                                                                                                
If @var_usertype=2                                                                                     
Begin                                                                                      
                                                                                                 
select                                                                                                   
th.id                
,case when th.TaskStatus='CP' then 1 else 0 end 'iscelledit1'      
,case when th.TaskStatus='CP' then 1 else 0 end 'iscelledit5'                 
,th.color1,th.color2,th.color3                                                                                                   
,th.id as 'TicketNo'                                                                                                 
,cm.clientname as clientid__obp_taskheader                                                                                                              
,th.th_taskheader as th_taskheader__obp_taskheader                                                                                    
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'Expected Delivery Date'                     
,th.th_remarks as th_remarks__obp_taskheader                                                     
,th.taskstatus as 'taskstatus__obp_taskheader'      
--,th.ClientClosureAcceptance as 'clientclosureacceptance__obp_taskheader'                  
,cm.Implementer as 'Owner'                       
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'LastModDate'        
from obp_TaskHeader th                  
left join obp_ClientMaster cm  on th.ClientID=cm.id                 
where                                                                                                      
((cm.id in (select value from string_split(@var_par1,',')) ) )                                                                                      
and isnull(th.Createdby,'') like @SearchLetter                                                                                                 
and th.isActive=1                                                       
--and th.taskheaderid is null                          
and isnull(th.ParentId,0) =0                                      
--and th.TaskStatus in (select value from string_split(@var_par3,','))                                                                                              
--and th.TicketType in (select value from string_split(@var_par2,','))                                                               
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                            
and th.TaskStatus not in ('CL')          
--and isnull(th.ClientClosureAcceptance,'')<>'True'                
order by th.id desc              
End                                                                                      
                                                                                      
                                                                                
                                                                                     
/*Tech - Buss Users - Managers*/                                                                                      
If (@var_usertype=5 or @var_usertype=4)                   
Begin                         
          
If @var_comp='OPS'           
Begin          
 Select                             
 th.id,                             
 case when (th.isedit=1 and th.Sprint='Committed') then 1 else 0 end 'iscelledit1',                                               
 case when th.isedit=1 then 1 else 0 end 'iscelledit2',                                         
 case when th.isedit=1 then 1 else 0 end 'iscelledit3',                                               
 case when th.isedit=1 then 1 else 0 end 'iscelledit4',                                
 th.color1,th.color2,th.color3                                                                                                   
 ,th.id as 'TicketNo'       
 --,th.id as id__obp_taskheader                                                                
 ,cm.clientname as clientid__obp_taskheader                         
 ,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'                       
 ,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                              
 ,th.th_taskheader as th_taskheader__obp_taskheader                        
 ,FKBy as 'fkby__obp_taskheader'                                               
 --,replace(th.ShareToUser,'/','')  as 'assigntouser'             
 ,AssignToMain as  'assigntomain__obp_taskheader'                      
 ,th.TaskDuration as 'taskduration__obp_taskheader'                      
 ,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                       
 ,case when th.PlannedStartDt='1900-01-01' then null else th.PlannedStartDt end 'plannedstartdt__obp_taskheader'                       
 ,convert(nvarchar(10),cast(th.TaskActEstDt as date)) 'Planned Finish'                      
 ,ActFinishDate as 'actfinishdate__obp_taskheader'                      
 ,th_SeqNo as 'th_seqno__obp_taskheader'                      
 ,Sprint as 'sprint__obp_taskheader'                      
 ,th.taskstatus as 'taskstatus__obp_taskheader'                      
 ,case when th.TaskActStartDt='1900-01-01' then null else th.TaskActStartDt end 'taskactstartdt__obp_taskheader'  
 ,th.TimeBuffer as timebuffer__obp_taskheader                      
 ,th.BlackExcedDays as blackexceddays__obp_taskheader                       
 ,th.th_remarks as th_remarks__obp_taskheader                      
 ,th.OnHoldReason as onholdreason__obp_taskheader                      
 ,convert(nvarchar(10),cast(th.ModifiedDate as date)) as ModifiedDate__obp_taskheader                        
 ,convert(nvarchar(10),cast(th.CreatedDate as date)) as CreatedDate__obp_taskheader                      
 /*,th.EstDueDate as estduedate__obp_taskheader*/                      
                      
 from obp_TaskHeader th                                                                                                    
 --left join obp_ClientMaster cm  on th.ClientID=cm.id                                 
  join obp_ClientMaster cm  on th.ClientID=cm.id                                                    
 --left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                                 
 --on tl.TicketId=th.id                     
 where                                                                                                      
 --((cm.id in (select value from string_split(@var_par1,',')) ) )     and                                                                            
 th.isActive=1                                                                                     
 --and th.taskheaderid is null                                                                                                       
 and isnull(th.ParentId,0) =0                                                          
 and th.th_TaskHeader not in ('Click + Sign to Add Records')                    
 and th.TaskStatus not in ('CL')                                                                                      
 and (th.ShareToUser like @SearchLetter or th.AssignToMain like @SearchLetter )            
 and cast(th.CreatedDate as date) > '2023-03-01'           
End          
Else          
Begin          
 Select                             
 th.id,                             
 case when (th.isedit=1 and th.Sprint='Committed') then 1 else 0 end 'iscelledit1',                                               
 case when th.isedit=1 then 1 else 0 end 'iscelledit2',                                         
 case when th.isedit=1 then 1 else 0 end 'iscelledit3',                                               
 case when th.isedit=1 then 1 else 0 end 'iscelledit4',                                
 th.color1,th.color2,th.color3                                                                                                   
 ,th.id as 'TicketNo'                                                                   
 --,th.id as id__obp_taskheader                                                                
 ,cm.clientname as clientid__obp_taskheader                         
 ,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                              
 ,th.th_taskheader as th_taskheader__obp_taskheader           
 ,th.TimeBuffer as timebuffer__obp_taskheader                          
 ,FKBy as 'fkby__obp_taskheader'                                               
 --,replace(th.ShareToUser,'/','')  as 'assigntouser'             
 --,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                       
 ,case when th.PlannedStartDt='1900-01-01' then null else th.PlannedStartDt end 'plannedstartdt__obp_taskheader'                       
 ,th.TaskDuration as 'taskduration__obp_taskheader'                      
 ,convert(nvarchar(10),cast(th.TaskActEstDt as date)) 'Planned Finish'                      
 ,th.th_remarks as th_remarks__obp_taskheader                    
 ,ActFinishDate as 'actfinishdate__obp_taskheader'                      
 --,th_SeqNo as 'th_seqno__obp_taskheader'                      
 --,Sprint as 'sprint__obp_taskheader'                      
 ,th.taskstatus as 'taskstatus__obp_taskheader'            
 ,AssignToMain as  'assigntomain__obp_taskheader'          
 ,case when th.TaskActStartDt='1900-01-01' then null else th.TaskActStartDt end 'taskactstartdt__obp_taskheader'                               
 ,th.BlackExcedDays as blackexceddays__obp_taskheader                       
          
                         
 ,th.OnHoldReason as onholdreason__obp_taskheader                      
 ,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'           
 ,convert(nvarchar(10),cast(th.ModifiedDate as date)) as ModifiedDate__obp_taskheader                        
 ,convert(nvarchar(10),cast(th.CreatedDate as date)) as CreatedDate__obp_taskheader                      
 /*,th.EstDueDate as estduedate__obp_taskheader*/                      
                      
 from obp_TaskHeader th                                                                                                                
 --left join obp_ClientMaster cm  on th.ClientID=cm.id     
  join obp_ClientMaster cm  on th.ClientID=cm.id                                                                                                       
 --left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                               
 --on tl.TicketId=th.id                                                          
 where                                                                                                      
 --((cm.id in (select value from string_split(@var_par1,',')) ) )     and                                                                            
 th.isActive=1                                                                                     
 --and th.taskheaderid is null                                                                                                       
 and isnull(th.ParentId,0) =0                                                          
 and th.th_TaskHeader not in ('Click + Sign to Add Records')                    
 and th.TaskStatus not in ('CL')                                                                                      
 and (th.ShareToUser like @SearchLetter or th.AssignToMain like @SearchLetter )            
 and cast(th.CreatedDate as date) > '2023-03-01'           
 order by th.id desc          
End          
                                                                         
End                                                                                      
                                                                                      
                                                                      
                                                                   
End               

  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_Type02_20231222]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    proc [dbo].[obp_sp_Pl_Type02_20231222]        
(@var_user nvarchar(100)=''                                                                                 
,@var_pid int=''                                                                                 
,@var_clientid int=''                                                                                  
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''      
)                                                                                              
as                                                                                              
begin                                                                                              
                                                                                              
DECLARE @SearchLetter nvarchar(100)                                                                                              
SET @SearchLetter ='%'+ @var_user + '%'                                                                     
                                                                    
Declare @var_usertype int                                                                    
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)                      
print @var_usertype                                                            
/*Client*/                                                                                              
If @var_usertype=2                                                                   
Begin                                                                    
                                                                               
select                                                                                 
th.id,                                                                                              
th.color1,th.color2,th.color3                                                                                 
,th.id as 'TicketNo'                                                                               
,cm.clientname as clientid__obp_taskheader                                                                                            
,th.th_taskheader as th_taskheader__obp_taskheader                                                                  
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'Expected Delivery Date'   
,th.th_remarks as th_remarks__obp_taskheader                                   
 ,th.taskstatus as 'Task Status'                                                     
,cm.Implementer as 'Owner'     
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'LastModDate'  
                       
from obp_TaskHeader th                                                                                         
left join obp_ClientMaster cm  on th.ClientID=cm.id    
where                                                                                    
((cm.id in (select value from string_split(@var_par1,',')) ) )                                                                    
and isnull(th.Createdby,'') like @SearchLetter                                                                               
and th.isActive=1                                                                   
--and th.taskheaderid is null                                                                                     
and isnull(th.ParentId,0) =0                                                                     
--and th.TaskStatus in (select value from string_split(@var_par3,','))                                                                            
--and th.TicketType in (select value from string_split(@var_par2,','))                                                                    
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                          
and th.TaskStatus not in ('CP')                                                                                
End                                                                    
                                                                    
/*Managers*/                                                             
If @var_usertype=4                                                                   
Begin                                                                    
select                                                                                                    
th.id,                                                                                              
th.color1,th.color2,th.color3                                                                                 
,th.id as 'TicketNo'                                                                               
,cm.clientname as clientid__obp_taskheader                                                                                            
,th.th_taskheader as th_taskheader__obp_taskheader                                                                  
,th.TimeBuffer as timebuffer__obp_taskheader                                                
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                                       
 ,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'PlannedStart'                                           
,th.TaskDuration as 'Duration'                                   
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                 
,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'ActualStart'                                                               
/*,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish' */                                                
 --,th.taskstatus as taskstatus__obp_taskheader                                                                         
 ,th.taskstatus as 'Task Status'                                                                          
,th.EstDueDate as estduedate__obp_taskheader                                                                
                               
,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                                                 
                                                           
,th.th_remarks as th_remarks__obp_taskheader                                               
,th.OnHoldReason as onholdreason__obp_taskheader                                                                                             
,replace(th.ShareToUser,'/','')  as 'AssignToUser'                                                                                               
,cm.Implementer as 'Incharge'                                                             
,th.ModifiedDate as ModifiedDate__obp_taskheader                                               
,th.CreatedDate as CreatedDate__obp_taskheader                                                                                               
                                
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                                                
,ActFinishDate as 'actfinishdate__obp_taskheader'                                                
,FKBy as 'fkby__obp_taskheader'                                                                    
,th_SeqNo as 'th_seqno__obp_taskheader'                        
from obp_TaskHeader th                                                                                              
left join obp_ClientMaster cm  on th.ClientID=cm.id                                         
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                        
--on tl.TicketId=th.id                                                           
where                                                                                    
cm.id in (select value from string_split(@var_par1,','))                                                                     
and (isnull(th.Createdby,'')+isnull(th.ShareToUser,'')) like @SearchLetter                                                                               
and th.isActive=1                                                      
--and th.taskheaderid is null                                                                                     
and isnull(th.ParentId,0) =0                                                                                    
and th.TaskStatus in (select value from string_split(@var_par3,','))                                                                                  
--and th.TaskStatus not in ('CP')                                                                    
--and th.TicketType in (select value from string_split(@var_par2,','))                                                                            
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                       
                                    
                                                                
End         
                                                                    
                                                                   
/*Tech - Buss Users*/                                                                    
If @var_usertype=5                                                                    
Begin                                    
Select           
th.id,           
case when (th.isedit=1 and th.Sprint='Committed') then 1 else 0 end 'iscelledit1',                             
case when th.isedit=1 then 1 else 0 end 'iscelledit2',                       
case when th.isedit=1 then 1 else 0 end 'iscelledit3',                             
case when th.isedit=1 then 1 else 0 end 'iscelledit4',              
th.color1,th.color2,th.color3                                                                                 
,th.id as 'TicketNo'                                                 
--,th.id as id__obp_taskheader                                              
,cm.clientname as clientid__obp_taskheader       
,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'     
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                            
,th.th_taskheader as th_taskheader__obp_taskheader      
,FKBy as 'fkby__obp_taskheader'                             
,replace(th.ShareToUser,'/','')  as 'assigntouser'     
,th.TaskDuration as 'taskduration__obp_taskheader'    
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'     
,th.PlannedStartDt 'plannedstartdt__obp_taskheader'     
,convert(nvarchar(10),cast(th.TaskActEstDt as date)) 'Planned Finish'    
,ActFinishDate as 'actfinishdate__obp_taskheader'    
,th_SeqNo as 'th_seqno__obp_taskheader'    
,Sprint as 'sprint__obp_taskheader'    
,th.taskstatus as 'taskstatus__obp_taskheader'    
,th.TaskActStartDt 'taskactstartdt__obp_taskheader'    
,th.TimeBuffer as timebuffer__obp_taskheader    
,th.BlackExcedDays as blackexceddays__obp_taskheader     
,th.th_remarks as th_remarks__obp_taskheader    
,th.OnHoldReason as onholdreason__obp_taskheader    
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as ModifiedDate__obp_taskheader      
,convert(nvarchar(10),cast(th.CreatedDate as date)) as CreatedDate__obp_taskheader    
/*,th.EstDueDate as estduedate__obp_taskheader*/    
    
from obp_TaskHeader th                                                                                              
--left join obp_ClientMaster cm  on th.ClientID=cm.id               
 join obp_ClientMaster cm  on th.ClientID=cm.id                                                                                     
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                               
--on tl.TicketId=th.id                                        
where                                                                                    
--((cm.id in (select value from string_split(@var_par1,',')) ) )     and                                                          
th.isActive=1                                                                   
--and th.taskheaderid is null                                                                                     
and isnull(th.ParentId,0) =0                                        
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                     
and th.TaskStatus not in ('CP')                                                                    
and th.ShareToUser like @SearchLetter                                     
and cast(th.CreatedDate as date) > '2023-03-01'                                                       
End                                                                    
                                                                    
                                                    
                                                 
End                     
            
  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_Type02_bkp_20231215]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obp_sp_Pl_Type02_bkp_20231215]    
(@var_user nvarchar(100)=''                                                                             
,@var_pid int=''                                                                             
,@var_clientid int=''                                                                              
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''                                                                                 
)                                                                                          
as                                                                                          
begin                                                                                          
                                                                                          
DECLARE @SearchLetter nvarchar(100)                                                                                          
SET @SearchLetter ='%'+ @var_user + '%'                                                                 
                                                                
Declare @var_usertype int                                                                
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)                  
print @var_usertype                                                        
/*Client*/                                                                                          
If @var_usertype=6                                                               
Begin                                                                
                                                                           
select                                                                             
th.id,                                                                                          
th.color1,th.color2,th.color3                                                                             
,th.id as 'TicketNo'                                                                           
,cm.clientname as clientid__obp_taskheader                                                                                        
,th.th_taskheader as th_taskheader__obp_taskheader                                                              
--,th.TaskDuration as 'Duration'                                                                    
--,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'PlannedStart'                                                           
--,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'ActualStart'                                                           
--,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish'                                                          
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                                                                      
,th.EstDueDate as estduedate__obp_taskheader                                                                                          
--,th.TimeBuffer as timebuffer__obp_taskheader                                                                                               
--,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                                             
--,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                    
,th.th_remarks as th_remarks__obp_taskheader                                               
 --,th.taskstatus as taskstatus__obp_taskheader                   
 ,th.taskstatus as 'Task Status'                              
--,th.OnHoldReason as onholdreason__obp_taskheader                                                                    
--,th.ShareToUser as sharetouser__obp_taskheader                                          
,cm.Implementer as 'Incharge'                                 
,th.ModifiedDate as ModifiedDate__obp_taskheader                                                                   
--,predecessorid as 'predecessorid__obp_taskheader'                                                                  
--,successorid as 'successorid__obp_taskheader'                                                                                           
from obp_TaskHeader th                                                                                     
left join obp_ClientMaster cm  on th.ClientID=cm.id                                                                                 
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                                                                          
--on tl.TicketId=th.id                                                          
where                                                                                
((cm.id in (select value from string_split(@var_par1,',')) ) )                                                                
and isnull(th.Createdby,'') like @SearchLetter                                                                           
and th.isActive=1                                                               
--and th.taskheaderid is null                                                                                 
and isnull(th.ParentId,0) =0                                                                 
--and th.TaskStatus in (select value from string_split(@var_par3,','))                                                                        
--and th.TicketType in (select value from string_split(@var_par2,','))                                                                
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                   
and th.TaskStatus not in ('CP')                                                                            
End                                                                
                                                                
/*Managers*/                                                         
If @var_usertype=4                                                               
Begin                                                                
select                                                                                                
th.id,                                                                                          
th.color1,th.color2,th.color3                                                                             
,th.id as 'TicketNo'                                                                           
,cm.clientname as clientid__obp_taskheader                                                                                        
,th.th_taskheader as th_taskheader__obp_taskheader                                                              
,th.TimeBuffer as timebuffer__obp_taskheader                                            
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                                   
 ,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'PlannedStart'                                                
,th.TaskDuration as 'Duration'                               
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'             
,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'ActualStart'                                                           
/*,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish' */                                            
 --,th.taskstatus as taskstatus__obp_taskheader                                                                     
 ,th.taskstatus as 'Task Status'                                                                      
,th.EstDueDate as estduedate__obp_taskheader                                                            
                           
,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                                             
                                                       
,th.th_remarks as th_remarks__obp_taskheader                                           
,th.OnHoldReason as onholdreason__obp_taskheader                                                                                         
,replace(th.ShareToUser,'/','')  as 'AssignToUser'                                                                                           
,cm.Implementer as 'Incharge'                                                         
,th.ModifiedDate as ModifiedDate__obp_taskheader                                           
,th.CreatedDate as CreatedDate__obp_taskheader                                                                                           
                            
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                                            
,ActFinishDate as 'actfinishdate__obp_taskheader'                                            
,FKBy as 'fkby__obp_taskheader'                                                                
,th_SeqNo as 'th_seqno__obp_taskheader'                                     
from obp_TaskHeader th                                                                                          
left join obp_ClientMaster cm  on th.ClientID=cm.id                                     
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                    
--on tl.TicketId=th.id                                                       
where                                                                                
cm.id in (select value from string_split(@var_par1,','))                                                                 
and (isnull(th.Createdby,'')+isnull(th.ShareToUser,'')) like @SearchLetter                                                                           
and th.isActive=1                                                  
--and th.taskheaderid is null                                                                                 
and isnull(th.ParentId,0) =0                                                                                
and th.TaskStatus in (select value from string_split(@var_par3,','))                                                                              
--and th.TaskStatus not in ('CP')                                                                
--and th.TicketType in (select value from string_split(@var_par2,','))                                                                        
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                         
                                
                                                            
End     
                                                                
                                                               
/*Tech - Buss Users*/                                                                
If @var_usertype=5                                                                
Begin                                
Select       
th.id,       
case when (th.isedit=1 and th.Sprint='Committed') then 1 else 0 end 'iscelledit1',                         
case when th.isedit=1 then 1 else 0 end 'iscelledit2',                   
case when th.isedit=1 then 1 else 0 end 'iscelledit3',                         
case when th.isedit=1 then 1 else 0 end 'iscelledit4',          
th.color1,th.color2,th.color3                                                                             
,th.id as 'TicketNo'                                             
--,th.id as id__obp_taskheader                                          
,cm.clientname as clientid__obp_taskheader                                              
,th.th_taskheader as th_taskheader__obp_taskheader                                                         
,th.TimeBuffer as timebuffer__obp_taskheader                                              
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                             
/*                                              
,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'plannedstartdt__obp_taskheader'                                                     
 
     
     
       
,th.TaskDuration as 'taskduration__obp_taskheader'                                                
 */                          
 ,th.PlannedStartDt 'plannedstartdt__obp_taskheader'                      
 --,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'plannedstartdt__obp_taskheader'                                                
,th.TaskDuration as 'taskduration__obp_taskheader'                                              
--,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                                                  
--,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'taskactstartdt__obp_taskheader'                                                   
  
    
      
       
         
--,cast(th.TaskActEstDt as date) 'taskactestdt__obp_taskheader' --'Planned Finish'                     
,convert(nvarchar(10),cast(th.TaskActEstDt as date)) 'Planned Finish'             
            
,th.TaskActStartDt 'taskactstartdt__obp_taskheader'                     
/*,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish' */                                            
 --,th.taskstatus as taskstatus__obp_taskheader                                  
 ,th.taskstatus as 'taskstatus__obp_taskheader'                                      
,th.EstDueDate as estduedate__obp_taskheader                                                                                          
                                                                                           
,th.BlackExcedDays as blackexceddays__obp_taskheader                                                             
                                                                                        
,th.th_remarks as th_remarks__obp_taskheader                     
                                                           
,th.OnHoldReason as onholdreason__obp_taskheader                         
,replace(th.ShareToUser,'/','')  as 'assigntouser'                                                                                         
--,cm.Implementer as 'Incharge'                   
,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'    
--,th.ModifiedDate as ModifiedDate__obp_taskheader                    
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as ModifiedDate__obp_taskheader                      
,convert(nvarchar(10),cast(th.CreatedDate as date)) as CreatedDate__obp_taskheader                                                                                           
,Sprint as 'sprint__obp_taskheader'         
--,Sprint                             
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                                            
,ActFinishDate as 'actfinishdate__obp_taskheader'                                            
,FKBy as 'fkby__obp_taskheader'                                                                
,th_SeqNo as 'th_seqno__obp_taskheader'                                                                 
        
from obp_TaskHeader th                                                                                          
--left join obp_ClientMaster cm  on th.ClientID=cm.id           
 join obp_ClientMaster cm  on th.ClientID=cm.id                                                                                 
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                           
--on tl.TicketId=th.id                                    
where                                                                                
--((cm.id in (select value from string_split(@var_par1,',')) ) )     and                                                      
th.isActive=1                                                               
--and th.taskheaderid is null                                                                                 
and isnull(th.ParentId,0) =0                                    
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                 
and th.TaskStatus not in ('CP')                                                                
and th.ShareToUser like @SearchLetter                                 
and cast(th.CreatedDate as date) > '2023-03-01'                                                   
End                                                                
                                                                
                                                
                                                                              
End                 
        
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_Type02_old]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[obp_sp_Pl_Type02_old]                                                        
(@var_user nvarchar(100)=''                                                       
,@var_pid int=''                                                       
,@var_clientid int=''                                                        
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''                                                           
)                                                                    
as                                                                    
begin                                                                    
                                                                    
DECLARE @SearchLetter nvarchar(100)                                                                    
SET @SearchLetter ='%'+ @var_user + '%'                                           
                                          
Declare @var_usertype int                                          
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)                                                                   
print @var_usertype                                  
/*Client*/                                                                    
If @var_usertype=6                                         
Begin                                          
                                                     
select                                                       
th.id,                                                                    
th.color1,th.color2,th.color3                                                       
,th.id as 'TicketNo'                                                     
,cm.clientname as clientid__obp_taskheader                                                                  
,th.th_taskheader as th_taskheader__obp_taskheader                                        
--,th.TaskDuration as 'Duration'                                              
--,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'PlannedStart'                                     
--,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'ActualStart'                                     
--,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish'                                    
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                                                
,th.EstDueDate as estduedate__obp_taskheader                                                                    
--,th.TimeBuffer as timebuffer__obp_taskheader                                                                         
--,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                       
--,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                                   
,th.th_remarks as th_remarks__obp_taskheader                                                                     
 --,th.taskstatus as taskstatus__obp_taskheader                                               
 ,th.taskstatus as 'Task Status'                                     
--,th.OnHoldReason as onholdreason__obp_taskheader                                                                   
--,th.ShareToUser as sharetouser__obp_taskheader                                                                    
,cm.Implementer as 'Incharge'           
,th.ModifiedDate as ModifiedDate__obp_taskheader                                             
--,predecessorid as 'predecessorid__obp_taskheader'                                            
--,successorid as 'successorid__obp_taskheader'                                                                     
from obp_TaskHeader th                                                               
left join obp_ClientMaster cm  on th.ClientID=cm.id                                                           
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                                                    
--on tl.TicketId=th.id                                    
where                                                          
((cm.id in (select value from string_split(@var_par1,',')) ) )                                          
and isnull(th.Createdby,'') like @SearchLetter                                                     
and th.isActive=1                                         
--and th.taskheaderid is null                                                           
and isnull(th.ParentId,0) =0                                           
--and th.TaskStatus in (select value from string_split(@var_par3,','))                                                  
--and th.TicketType in (select value from string_split(@var_par2,','))                                          
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                             
and th.TaskStatus not in ('CP')                                                      
End                                          
                                          
/*Managers*/                                   
If @var_usertype=4                                         
Begin                                          
select                                                                          
th.id,                                                                    
th.color1,th.color2,th.color3                                                       
,th.id as 'TicketNo'                                                     
,cm.clientname as clientid__obp_taskheader                                                                  
,th.th_taskheader as th_taskheader__obp_taskheader                                        
,th.TimeBuffer as timebuffer__obp_taskheader                      
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                             
 ,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'PlannedStart'                          
,th.TaskDuration as 'Duration'                             
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                            
,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'ActualStart'                                     
/*,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish' */                      
 --,th.taskstatus as taskstatus__obp_taskheader                                               
 ,th.taskstatus as 'Task Status'                                                
,th.EstDueDate as estduedate__obp_taskheader                                                                    
                                                                         
,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                       
                                 
,th.th_remarks as th_remarks__obp_taskheader                     
,th.OnHoldReason as onholdreason__obp_taskheader                                                                   
,replace(th.ShareToUser,'/','')  as 'AssignToUser'                                                                     
,cm.Implementer as 'Incharge'                                   
,th.ModifiedDate as ModifiedDate__obp_taskheader                     
,th.CreatedDate as CreatedDate__obp_taskheader                                                                     
      
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                      
,ActFinishDate as 'actfinishdate__obp_taskheader'                      
,FKBy as 'fkby__obp_taskheader'                                          
,th_SeqNo as 'th_seqno__obp_taskheader'               
from obp_TaskHeader th                                                                    
left join obp_ClientMaster cm  on th.ClientID=cm.id               
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl              
--on tl.TicketId=th.id                                 
where                                                          
cm.id in (select value from string_split(@var_par1,','))                                           
and (isnull(th.Createdby,'')+isnull(th.ShareToUser,'')) like @SearchLetter                                                     
and th.isActive=1                            
--and th.taskheaderid is null                                                           
and isnull(th.ParentId,0) =0                                                          
and th.TaskStatus in (select value from string_split(@var_par3,','))                                                        
--and th.TaskStatus not in ('CP')                                          
--and th.TicketType in (select value from string_split(@var_par2,','))                                                  
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                   
                                  
                                      
End                                          
                                          
                                         
/*Tech - Buss Users*/                                          
If @var_usertype=5                                          
Begin          
                                       
select                                                     
th.id,    
case when th.isedit=1 then 1 else 0 end 'iscelledit1',   
case when th.isedit=1 then 1 else 0 end 'iscelledit2',   
case when th.isedit=1 then 1 else 0 end 'iscelledit3',   
case when th.isedit=1 then 1 else 0 end 'iscelledit4',   
  
th.color1,th.color2,th.color3                                                       
,th.id as 'TicketNo'                       
,cm.clientname as clientid__obp_taskheader                        
,th.th_taskheader as th_taskheader__obp_taskheader                                   
,th.TimeBuffer as timebuffer__obp_taskheader                        
,th.TicketCatg1 as ticketcatg1__obp_taskheader                       
/*                        
,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'plannedstartdt__obp_taskheader'                                     
,th.TaskDuration as 'taskduration__obp_taskheader'                          
 */                           
 ,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'plannedstartdt__obp_taskheader'                          
,th.TaskDuration as 'taskduration__obp_taskheader'                        
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                            
,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'taskactstartdt__obp_taskheader'                                     
/*,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish' */                      
 --,th.taskstatus as taskstatus__obp_taskheader            
 ,th.taskstatus as 'taskstatus__obp_taskheader'                
,th.EstDueDate as estduedate__obp_taskheader                                                                    
                                                                     
,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                       
                                                                  
,th.th_remarks as th_remarks__obp_taskheader                                                                     
                                     
,th.OnHoldReason as onholdreason__obp_taskheader                                                                   
,replace(th.ShareToUser,'/','')  as 'AssignToUser'                                                                   
,cm.Implementer as 'Incharge'             
,th.ModifiedDate as ModifiedDate__obp_taskheader                     
,th.CreatedDate as CreatedDate__obp_taskheader                                                                     
      
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                      
,ActFinishDate as 'actfinishdate__obp_taskheader'                      
,FKBy as 'fkby__obp_taskheader'                                          
,th_SeqNo as 'th_seqno__obp_taskheader'                                           
                                                                 
from obp_TaskHeader th                                                                    
left join obp_ClientMaster cm  on th.ClientID=cm.id                                                           
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                 
--on tl.TicketId=th.id              
where                                                          
--((cm.id in (select value from string_split(@var_par1,',')) ) )     and                                
th.isActive=1                                         
--and th.taskheaderid is null                                                           
and isnull(th.ParentId,0) =0              
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                           
and th.TaskStatus not in ('CP')                                          
and th.ShareToUser like @SearchLetter           
and cast(th.CreatedDate as date) > '2023-03-01'                             
End                                          
                                          
                                                             
                                                        
End       
  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_Type03]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      proc [dbo].[obp_sp_Pl_Type03]                                                          
(@var_user nvarchar(100)=''                
,@var_pid int='',                                                          
@var_clientid int='')                                                          
as                                                          
begin                                                          
                                                          
DECLARE @SearchLetter nvarchar(100)                                                          
SET @SearchLetter ='%'+ @var_user + '%'      

                                                          
 select td.id,        
 case when th.Sprint='Committed' then 1 else 0 end 'iscelledit1',                              
 th.color1,td.color2,td.color3                                                  
 ,td.id as 'Task No'                                             
 ,td.th_TaskHeader as th_taskheader__obp_taskheader                                          
                                                 
,td.PlannedStartDt  as plannedstartdt__obp_taskheader                                      
 ,td.TaskDuration as taskduration__obp_taskheader                  
--,convert(nvarchar(4),datepart(yyyy,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,td.TaskActEstDt)) as 'Planned Finish'                 
,convert(nvarchar(10),cast(td.TaskActEstDt as date)) as TaskActEstDt__obp_taskheader          
,td.TaskActStartDt as 'taskactstartdt__obp_taskheader'                   
,td.TaskStatus as taskstatus__obp_taskheader                                                           
 ,td.TimeBuffer as timebuffer__obp_taskheader                                                                                                                          
 ,td.th_Remarks as th_remarks__obp_taskheader                                          
 ,td.ShareToUser as sharetouser__obp_taskheader                                                                                    
 --,convert(nvarchar(10),cast(td.ModifiedDate as date)) as ModifiedDate__obp_taskheader                                                                      
 ,convert(char(10),td.ModifiedDate,126) 'LastModDt'  
  from   (Select * from obp_taskheader where id=@var_pid) th                                                                                                       
  right join  obp_taskheader td                                                          
  --on th.id=td.TaskHeaderID                                                          
  on th.id=td.ParentId                                                          
  --Added on 24-05-2021--to have access control form obp_ClientMaster table                                                           
  left join obp_ClientMaster cm on th.ClientID=cm.id                                                                                                      
 where                           
  --td.taskheaderid=@var_pid  or  td.ParentId=@var_pid                                            
  td.ParentId=@var_pid                
  and td.isActive=1               
  order by isnull(td.PlannedStartDt,'2050-01-01'),isnull(td.TaskActEstDt,'2050-01-01')                      

                                                           
end           
      
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_PlannedTaskCurrentWeek]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Planned Open Tasks for Current Week*/                          
/*Date: 2023-09-29; Author: Bharat; Reason: To get the list of Planned Tasks for Status Report */                          
CREATE         procedure [dbo].[obp_sp_PlannedTaskCurrentWeek]                          
as                          
Begin                   
             
 Declare @var_DateFrom date,@var_DateTo date,@var_DayofWeek int ,@var_todaydate date                  
 Set @var_todaydate=Cast((getdate()-0) as date)            
 Set @var_DayofWeek=(Select datepart(weekday,@var_todaydate))            
           
 Set @var_DateTo= Dateadd(dd,(7-@var_DayofWeek),@var_todaydate)          
 Set @var_DateFrom = Dateadd(dd,-6,@var_DateTo)          
          
 /*          
 Select @var_DayofWeek            
 Select @var_todaydate 'TodayDate'  ,@var_DateFrom 'Week From' ,@var_DateTo 'Weekend'           
*/                          
 Select                 
   replace(TH.Sprint,'Completed','Committed')   'Committed'                      
  ,CM.ClientName,TH.th_TaskHeader 'Task Name',TH.TaskStatus                
  /*                
  ,cast(TH.PlannedStartDt as date) 'Planned Start Date'                          
  ,cast(TH.TaskActEstDt as date) 'Planned Finish Date'                        
  ,TH.ActFinishDate 'Actual Finish Date'                        
  */                
  ,convert(char(10),TH.PlannedStartDt,126) 'Planned Start Date'                
  ,convert(char(10),TH.TaskActEstDt,126) 'Planned Finish Date'                
  ,convert(char(10),TH.ActFinishDate,126) 'Actual Finish Date'                
  ,TH.BlackExcedDays 'Delay Days'                          
  ,TH.OnHoldReason 'Delay Reason'  
  ,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'  
  /* ,replace(TH.ShareToUser,'/','') 'Task Assign To' */
  ,case when replace(TH.ShareToUser,'/','') like '%'+isnull(Th.AssignToMain,'')+'%' then  replace(TH.ShareToUser,'/','') else (replace(TH.ShareToUser,'/','')+' ' +isnull(Th.AssignToMain,'')) end 
  'Task Assign To'  
  ,TH.TimeBuffer                      
  ,TH.th_Remarks 'Remarks'                    
  ,TH.FkBy 'Full Kitted'                      
 from obp_TaskHeader TH                          
 join obp_ClientMaster CM on CM.id=isnull(TH.ClientID,1)              
 join obps_users US on US.UserName= TH.Createdby                          
 where                           
  cast(TH.CreatedDate as date) > '2023-03-01' and                          
  isnull(ClientID,1)>1 and                           
  ParentId=0 and                          
  th_TaskHeader is not null and                
  /*                        
  DATEPART(WEEK,TH.PlannedStartDt) <=  (DATEPART(WEEK,GETDATE())) and                          
  DATEPART(WEEK,TH.TaskActEstDt) >=  (DATEPART(WEEK,GETDATE())) and                          
               
 isnull(TH.PlannedStartDt,'1900-01-01') <= '2023-12-30' and              
 isnull(TH.TaskActEstDt,'1900-01-01') >= '2023-12-24' and             
  */             
   isnull(TH.PlannedStartDt,'1900-01-01') <= @var_DateTo and              
 isnull(TH.TaskActEstDt,'1900-01-01') >= @var_DateFrom and           
  TH.TaskStatus in ('IP','NS','CP','CL')              
 and TH.Sprint in ('Completed','Committed')          
 /*and (case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end)  ='Suman'  */          
 order by CM.ClientName,TH.TaskActEstDt                 
               
                        
End 

GO
/****** Object:  StoredProcedure [dbo].[obp_sp_PlannedTaskNextWeek]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*Planned Open Tasks for Next Week*/                        
/*Date: 2023-09-29; Author: Bharat; Reason: To get the list of Planned Tasks Next week for Status Report */                        
                        
CREATE       procedure [dbo].[obp_sp_PlannedTaskNextWeek]                        
as                        
Begin          
        
 Declare @var_DateFrom date,@var_DateTo date,@var_DayofWeek int ,@var_todaydate date                
 Set @var_todaydate=Cast((getdate()-0) as date)          
 Set @var_DayofWeek=(Select datepart(weekday,@var_todaydate))          
         
 Set @var_DateTo= Dateadd(dd,(7-@var_DayofWeek),@var_todaydate)        
 Set @var_DateFrom = Dateadd(dd,-6,@var_DateTo)        
        
 set @var_DateTo=dateadd(dd,7,@var_DateTo)        
 set @var_DateFrom=dateadd(dd,7,@var_DateFrom)        
 /*        
 Select @var_DayofWeek          
 Select @var_todaydate 'TodayDate'  ,@var_DateFrom 'Week From' ,@var_DateTo 'Weekend'         
*/                        
                        
Select              
 replace(TH.Sprint,'Completed','Committed') 'Committed'                         
 ,CM.ClientName,TH.th_TaskHeader 'Task Name',TH.TaskStatus              
 /*              
 ,cast(TH.PlannedStartDt as date) 'Planned Start Date'                        
 ,cast(TH.TaskActEstDt as date) 'Planned Finish Date'              
 */              
 ,convert(char(10),TH.PlannedStartDt,126) 'Planned Start Date'              
 ,convert(char(10),TH.TaskActEstDt,126) 'Planned Finish Date'              
 ,TH.BlackExcedDays 'Delay Days'                        
 ,TH.OnHoldReason 'Delay Reason'  
 ,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'  
 /* ,replace(TH.ShareToUser,'/','') 'Task Assign To' */
 ,case when replace(TH.ShareToUser,'/','') like '%'+isnull(Th.AssignToMain,'')+'%' then  replace(TH.ShareToUser,'/','') else (replace(TH.ShareToUser,'/','')+' ' +isnull(Th.AssignToMain,'')) end 
  'Task Assign To'  
 ,TH.TimeBuffer                      
 ,TH.th_Remarks 'Remarks'                  
 ,TH.FkBy 'Full Kitted'                        
from obp_TaskHeader TH                        
join obp_ClientMaster CM on CM.id=isnull(TH.ClientID,1)          
join obps_users US on US.UserName= TH.Createdby                        
where                         
 cast(TH.CreatedDate as date) > '2023-03-01' and                        
 isnull(ClientID,1)>1 and                         
 ParentId=0 and                        
 th_TaskHeader is not null and                        
 /*          
 DATEPART(WEEK,TH.PlannedStartDt) <=  (DATEPART(WEEK,GETDATE()+7)) and                      
 DATEPART(WEEK,TH.TaskActEstDt) >=  (DATEPART(WEEK,GETDATE()+7)) and                      
          
 isnull(TH.PlannedStartDt,'1900-01-01') <= '2024-01-06' and          
 isnull(TH.TaskActEstDt,'1900-01-01') >= '2023-12-31' and            
 */        
  isnull(TH.PlannedStartDt,'1900-01-01') <= @var_DateTo and          
 isnull(TH.TaskActEstDt,'1900-01-01') >= @var_DateFrom and                     
 TH.TaskStatus in ('IP','NS')  and          
 TH.Sprint in ('Completed','Committed')         
 /* and (case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end)    ='Anita' */        
order by CM.ClientName,TH.TaskActEstDt                        
                        
End       
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_PlannedTaskNextWeek_v1]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Planned Open Tasks for Next Week*/            
/*Date: 2023-09-29; Author: Bharat; Reason: To get the list of Planned Tasks Next week for Status Report */            
            
CREATE    procedure [dbo].[obp_sp_PlannedTaskNextWeek_v1]            
as            
Begin  
/*         
Declare @var_FromDt date,@var_ToDt date,@var_day int,@var_par1 int

Set @var_day= (select DATEPART(WEEKDAY,getdate()))

If @var_day>1 
Set @var_par1=@var_day-1
Else
Set @var_par1=0

/*First Day of Week*/
Set @var_FromDt= cast((getdate()-@var_par1) as date)


Set @var_day=DATEPART(WEEKDAY,getdate())
*/
Select  
 TH.Sprint 'Committed'             
 ,CM.ClientName,TH.th_TaskHeader 'Task Name',TH.TaskStatus  
 /*  
 ,cast(TH.PlannedStartDt as date) 'Planned Start Date'            
 ,cast(TH.TaskActEstDt as date) 'Planned Finish Date'  
 */  
 ,convert(char(10),TH.PlannedStartDt,126) 'Planned Start Date'  
 ,convert(char(10),TH.TaskActEstDt,126) 'Planned Finish Date'  
 ,TH.BlackExcedDays 'Delay Days'            
 ,TH.OnHoldReason 'Delay Reason',case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner',replace(TH.ShareToUser,'/','') 'Task Assign To'          
 ,TH.TimeBuffer          
 ,TH.th_Remarks 'Remarks'      
 ,TH.FkBy 'Full Kitted'            
from obp_TaskHeader TH            
join obp_ClientMaster CM on CM.id=isnull(TH.ClientID,1)
join obps_users US on US.UserName= TH.Createdby            
where             
 cast(TH.CreatedDate as date) > '2023-03-01' and            
 isnull(ClientID,1)>1 and             
 ParentId=0 and            
 th_TaskHeader is not null and            
 /*
 DATEPART(WEEK,TH.PlannedStartDt) <=  (DATEPART(WEEK,GETDATE()+7)) and            
 DATEPART(WEEK,TH.TaskActEstDt) >=  (DATEPART(WEEK,GETDATE()+7)) and            
 */
 isnull(TH.PlannedStartDt,'1900-01-01') <= '2023-12-31' and
 isnull(TH.TaskActEstDt,'1900-01-01') >= '2023-12-31' and
 TH.TaskStatus in ('IP','NS')            
order by CM.ClientName,TH.TaskActEstDt            
            
End 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Rep_AllSubTasks]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[obp_sp_Rep_AllSubTasks]            
(@var_user nvarchar(100)=''            
--,@var_pid int,            
,@var_pid int='',            
@var_clientid int='')            
as            
begin            
            
DECLARE @SearchLetter nvarchar(100)            
SET @SearchLetter ='%'+ @var_user + '%'            
    
 select td.id,th.color1,td.color2,td.color3
 --,td.color4,td.color5                                
 ,td.id as 'Task No'              
 ,td.td_SeqNo as 'SeqNo'                
 ,td.th_TaskHeader as 'Task Name'                
                       
 ,convert(nvarchar(4),datepart(yyyy,td.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,td.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,td.PlannedStartDt)) as 'Planned Start Date'                
 ,td.TaskDuration as 'Duration'         
,convert(nvarchar(4),datepart(yyyy,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,td.TaskActEstDt)) as 'Planned Finish'              
,convert(nvarchar(4),datepart(yyyy,td.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,td.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,td.TaskActStartDt)) as 'Actual Start'    
,td.TaskStatus as 'taskstatus'            
 ,td.TimeBuffer as timebuffer__obp_taskheader                                                                     
 ,td.th_Remarks as 'Remarks'                
 ,convert(date,td.ModifiedDate) as ModifiedDate__obp_taskheader                
  from   (Select * from obp_taskheader where id=@var_pid) th                                   
  right join  obp_taskheader td                                
  on th.id=td.ParentId                                
  left join obp_ClientMaster cm on th.ClientID=cm.id                                
 where                                 
 --(cm.SuperUser like @SearchLetter or cm.PD like @SearchLetter or cm.PC like @SearchLetter or cm.RM like @SearchLetter or cm.Implementer like @SearchLetter                                 
 --or cm.consultant like @SearchLetter or cm.AccessToUser like @SearchLetter or th.ShareToUser like @SearchLetter)                                
 -- and   
  td.ParentId=@var_pid                     
  --and td.isDeleted=0                                
  order by td.td_SeqNo                      
            
end 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Rep_AllTasks]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       proc [dbo].[obp_sp_Rep_AllTasks]           
(@var_user nvarchar(100)=''                                                              
,@var_pid int=''                                                              
,@var_clientid int='')                                                              
as                                                              
Begin           
                                                              
DECLARE @SearchLetter nvarchar(100)                                                              
SET @SearchLetter ='%'+ @var_user + '%'                                                              
            
select                                                                       
st.id,                                                                                      
st.color1,st.color2,st.color3                                                                                
,th.id as 'TicketNo'                                         
,cm.clientname as clientid__obp_taskheader                                          
,th.th_taskheader as th_taskheader__obp_taskheader                                  
,st.id as 'ActivityId'                                                                              
,st.th_taskheader  as 'Activity'                                   
,case when st.TimeBuffer ='Cyan' then '0Cyan'                        
 when st.TimeBuffer ='Green' then '1Green'                        
 when st.TimeBuffer ='Yellow' then '2Yellow'                        
 when st.TimeBuffer ='Red' then '3Red'                        
 when st.TimeBuffer ='Black' then '4Black'                        
end 'timebuffer__obp_taskheader'                         
,th.TicketCatg1 as ticketcatg1__obp_taskheader            
 ,convert(char(10),st.PlannedStartDt,126)     as 'PlannedStart'                                        
,st.TaskDuration as 'Duration'                       
 ,convert(char(10),st.TaskActEstDt,126)     as 'Planned Finish'              
  ,convert(char(10),st.TaskActStartDt,126)     as 'ActualStart'              
 ,st.taskstatus as taskstatus__obp_taskheader                                                                 
,convert(char(10),st.EstDueDate,126)     as 'Requested Need Date'             
,st.BlackExcedDays as BlackExcedDays__obp_taskheader            
,st.th_remarks as th_remarks__obp_taskheader            
,replace(st.ShareToUser,'/','')  as 'AssignToUser'             
,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'              
,convert(char(10),st.ModifiedDate,126) 'LastModDt'              
,convert(char(10),st.CreatedDate,126)  'CreatedDate'                                                 
,st.Createdby as createdby__obp_taskheader                           
--,case when st.ActualFinishDate is null then convert(char(10),st.ModifiedDate,126)  else convert(char(10),st.ActualFinishDate,126) end 'ActualFinishDate'      
, case   
   when st.TaskStatus not in ('CP','CL') then  convert(char(10),st.ActualFinishDate,126)    
   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is not null) then convert(char(10),st.ClientClosureAcceptanceDate,126)  
   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is null) then convert(char(10),st.ModifiedDate,126)   
  end 'ActualFinishDate'  
, replace(th.Sprint,'Completed','Committed') 'Committed'                                                
from obp_TaskHeader st                                   
join obp_TaskHeader th on th.id=st.ParentId                                                             
left join obp_ClientMaster cm on th.ClientID=cm.id                                                    
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl  on tl.TicketId=th.id                         
where           
--th.Createdby='Bharat'   and                                                        
 --th.isDeleted=0 and                     
 th.th_taskheader<>'Click + Sign to Add Records'                      
 --and th.ParentId is null and                                     
 and isnull(th.ParentId,0)=0 and                    
 --st.isDeleted=0 and                     
 st.th_taskheader<>'Click + Sign to Add Records'                      
 and st.ParentId is not null                                   
 --and th.TaskStatus  in ('IP','NS','IP-HOLD','CP')                                                    
 and cm.ClientName not in ('GC_Prabhat')       
 and isnull(th.TicketCatg1,'-')<>'Delete Task'                                      
 and  cast(th.CreatedDate as date) > '2023-01-31'                 
 --and th.id=16320          
                           
union all          
          
select                                                    
st.id,           
st.color1,st.color2,st.color3                                                                                
,th.id as 'TicketNo'                                         
,cm.clientname as clientid__obp_taskheader                                          
,th.th_taskheader as th_taskheader__obp_taskheader                                  
,st.id as 'ActivityId'                                                                              
,st.th_taskheader  as 'Activity'                                   
,case when st.TimeBuffer ='Cyan' then '0Cyan'                        
 when st.TimeBuffer ='Green' then '1Green'                        
 when st.TimeBuffer ='Yellow' then '2Yellow'                        
 when st.TimeBuffer ='Red' then '3Red'                        
 when st.TimeBuffer ='Black' then '4Black'                        
end 'timebuffer__obp_taskheader'                         
,th.TicketCatg1 as ticketcatg1__obp_taskheader            
 ,convert(char(10),st.PlannedStartDt,126)     as 'PlannedStart'                                        
,st.TaskDuration as 'Duration'                       
 ,convert(char(10),st.TaskActEstDt,126)     as 'Planned Finish'              
  ,convert(char(10),st.TaskActStartDt,126)     as 'ActualStart'              
 ,st.taskstatus as taskstatus__obp_taskheader                                                                 
,convert(char(10),st.EstDueDate,126)     as 'Requested Need Date'             
,st.BlackExcedDays as BlackExcedDays__obp_taskheader            
,st.th_remarks as th_remarks__obp_taskheader            
,replace(st.ShareToUser,'/','')  as 'AssignToUser'             
,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'              
,convert(char(10),st.ModifiedDate,126) 'LastModDt'              
,convert(char(10),st.CreatedDate,126)  'CreatedDate'                                                 
,st.Createdby as createdby__obp_taskheader                           
--,convert(char(10),st.ActualFinishDate,126)  'ActualFinishDate'     
, case   
   when st.TaskStatus not in ('CP','CL') then  convert(char(10),st.ActualFinishDate,126)    
   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is not null) then convert(char(10),st.ClientClosureAcceptanceDate,126)  
   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is null) then convert(char(10),st.ModifiedDate,126)   
  end 'ActualFinishDate'  
  
, replace(th.Sprint,'Completed','Committed') 'Committed'   
from obp_TaskHeader st                                   
join obp_TaskHeader th on th.id=st.id           
left join obp_ClientMaster cm on th.ClientID=cm.id                                                    
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl  on tl.TicketId=th.id                         
where                                                           
 --th.isDeleted=0 and                     
 --th.Createdby='Bharat'   and           
 th.th_taskheader<>'Click + Sign to Add Records'                      
 --and th.ParentId is null and                                     
 and isnull(th.ParentId,0)=0 and                    
 --st.isDeleted=0 and                     
 st.th_taskheader<>'Click + Sign to Add Records'                      
 and st.ParentId is not null                                   
 --and th.TaskStatus  in ('IP','NS','IP-HOLD','CP')                                                    
 and cm.ClientName not in ('GC_Prabhat')                               
 and isnull(th.TicketCatg1,'-')<>'Delete Task'                                      
 and  cast(th.CreatedDate as date) > '2023-01-31'                                        
 --and th.id=16320          
 and th.Createdby=th.ShareToUser                                  
                                               
END                 
              
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Rep_AllTasks_Main]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE        proc [dbo].[obp_sp_Rep_AllTasks_Main]                 
(              
@var_user nvarchar(100)=''                 
,@var_pid int=''               
,@var_clientid int=''              
)               
as                
begin                
      
DECLARE @SearchLetter nvarchar(100)                                                              
SET @SearchLetter ='%'+ @var_user + '%'                                                              
        
select                 
th.id,                
th.color1,th.color2,th.color3        
,th.id as 'TicketNo'                
,cm.clientname as clientid__obp_taskheader                                          
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                         
,th.th_taskheader as 'Task Name'                        
,FKBy as 'Full Kitted'               
,th_SeqNo as 'Rank'                          
,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'          
,round(td_SeqNo,2) as 'Touch Time (Hrs)'              
,th.TaskDuration as 'Duration (days)'         
/*                           
,th.PlannedStartDt  as 'plannedstartdt__obp_taskheader'               
,th.TaskActEstDt  as 'taskactestdt__obp_taskheader'                   
,ActFinishDate as 'actfinishdate__obp_taskheader'               
*/        
,convert(char(10),th.PlannedStartDt,126) 'Planned Start'        
,convert(char(10),th.TaskActEstDt,126) 'Planned Finish'        
,convert(char(10),th.TaskActEstDt,126) 'Customer Committed Date'        
,th.taskstatus as taskstatus__obp_taskheader                 
,th.TimeBuffer as timebuffer__obp_taskheader                 
,th.BlackExcedDays as 'Delay Days'         
/*              
,th.TaskActStartDt  as 'taskactstartdt__obp_taskheader'                 
,th.ActualFinishDate as actualfinishdate__obp_taskheader                  
,th.ModifiedDate as modifieddate__obp_taskheader                  
,th.CreatedDate as createddate__obp_taskheader            
*/        
,convert(char(10),th.TaskActStartDt,126) 'Actual Start'        
--,convert(char(10),th.ActualFinishDate,126) 'Actual Finish Date'      
--,case when th.ActualFinishDate is null then convert(char(10),th.ModifiedDate,126) else convert(char(10),th.ActualFinishDate,126) end   'Actual Finish Date'  
, case 
   when th.TaskStatus not in ('CP','CL') then  convert(char(10),th.ActualFinishDate,126)  
   When (th.TaskStatus in ('CP','CL')  and  th.ClientClosureAcceptanceDate is not null) then convert(char(10),th.ClientClosureAcceptanceDate,126)
   When (th.TaskStatus in ('CP','CL')  and  th.ClientClosureAcceptanceDate is null) then convert(char(10),th.ModifiedDate,126) 
  end 'ActualFinishDate'
,convert(char(10),th.ModifiedDate,126) 'Last Mod Date'        
,convert(char(10),th.CreatedDate,126) 'Created Date'        
        
,th.Createdby as createdby__obp_taskheader        
,case when isEdit=0 then 'Yes' when isEdit=1 then 'No'  end 'SubTaskExists'           
                  
from obp_TaskHeader th             
left join obp_ClientMaster cm on th.ClientID=cm.id          
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl on tl.TicketId=th.id           
where           
--th.isDeleted=0 and         
th.th_taskheader<>'Click + Sign to Add Records'  and isnull(th.ParentId,0)=0         
--and st.isDeleted=0 and st.th_taskheader<>'Click + Sign to Add Records'  and st.taskheaderid is not null                                                                  
and cm.ClientName not in ('GC_Prabhat')                               
and isnull(th.TicketCatg1,'-')<>'Delete Task'                                      
and  cast(th.CreatedDate as date) > '2023-01-31'                                
                                    
                                    
                                               
END                         
                        

GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Rep_ClosedTasks]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    proc [dbo].[obp_sp_Rep_ClosedTasks]               
(@var_user nvarchar(100)=''                                                                  
,@var_pid int=''                                                                  
,@var_clientid int=''  
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''    
)  
as                                                                  
Begin               
                                                                  
DECLARE @SearchLetter nvarchar(100),@var_usertype int                                                                  
SET @SearchLetter ='%'+ @var_user + '%'              

Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)

/*For clients*/
If @var_usertype = 2
Begin
	select                                                                                                   
	th.id   
	,th.color1,th.color2,th.color3                                                                                                   
	,th.id as 'TicketNo'                                                                                                 
	,cm.clientname as 'Client Name'
	,th.th_taskheader as 'Task Name'
	,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'Expected Delivery Date'                     
	,th.th_remarks as 'Remarks'
	,th.taskstatus as 'Task Status'
	,cm.Implementer as 'Owner'                       
	,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'LastModDate'        
	from obp_TaskHeader th                  
	left join obp_ClientMaster cm  on th.ClientID=cm.id                 
	where                                                                                                      
	isnull(th.Createdby,'') like @SearchLetter 
	and th.isActive=1 
	and isnull(th.ParentId,0) =0  
	and th.th_TaskHeader not in ('Click + Sign to Add Records') 
	and th.TaskStatus in ('CL')
	order by th.id desc  

End

If @var_usertype <> 2
Begin
                
	select                                                                           
	st.id,                                                                                          
	st.color1,st.color2  
	,st.color3                                                                                    
	,th.id as 'TicketNo'                                             
	,cm.clientname as clientid__obp_taskheader                                              
	,th.th_taskheader as th_taskheader__obp_taskheader                                      
	,st.id as 'ActivityId'                                                                                  
	,st.th_taskheader  as 'Activity'                                       
	,case when st.TimeBuffer ='Cyan' then '0Cyan'                            
	 when st.TimeBuffer ='Green' then '1Green'                            
	 when st.TimeBuffer ='Yellow' then '2Yellow'                            
	 when st.TimeBuffer ='Red' then '3Red'                            
	 when st.TimeBuffer ='Black' then '4Black'                            
	end 'timebuffer__obp_taskheader'                             
	,th.TicketCatg1 as ticketcatg1__obp_taskheader                
	 ,convert(char(10),st.PlannedStartDt,126)     as 'PlannedStart'                                            
	,st.TaskDuration as 'Duration'                           
	 ,convert(char(10),st.TaskActEstDt,126)     as 'Planned Finish'                  
	  ,convert(char(10),st.TaskActStartDt,126)     as 'ActualStart'                  
	 ,st.taskstatus as taskstatus__obp_taskheader                                                                     
	,convert(char(10),st.EstDueDate,126)     as 'Requested Need Date'                 
	,st.BlackExcedDays as BlackExcedDays__obp_taskheader                
	,st.th_remarks as th_remarks__obp_taskheader                
	,replace(st.ShareToUser,'/','')  as 'AssignToUser'                 
	,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'                  
	,convert(char(10),st.ModifiedDate,126) 'LastModDt'                  
	,convert(char(10),st.CreatedDate,126)  'CreatedDate'                                                     
	,st.Createdby as createdby__obp_taskheader                               
	--,case when st.ActualFinishDate is null then convert(char(10),st.ModifiedDate,126)  else convert(char(10),st.ActualFinishDate,126) end 'ActualFinishDate'          
	, case       
	   when st.TaskStatus not in ('CP','CL') then  convert(char(10),st.ActualFinishDate,126)        
	   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is not null) then convert(char(10),st.ClientClosureAcceptanceDate,126)      
	   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is null) then convert(char(10),st.ModifiedDate,126)       
	  end 'ActualFinishDate'      
	, replace(th.Sprint,'Completed','Committed') 'Committed'                                                    
	from obp_TaskHeader st                                       
	join obp_TaskHeader th on th.id=st.ParentId                                                                 
	left join obp_ClientMaster cm on th.ClientID=cm.id                                                        
	--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl  on tl.TicketId=th.id                            
	where               
	((cm.id in (select value from string_split(@var_par1,',')) ) ) and  
	th.TaskStatus in ('CP','CL') and   
	 th.th_taskheader<>'Click + Sign to Add Records'                          
	 --and th.ParentId is null and                                         
	 and isnull(th.ParentId,0)=0 and                        
	 --st.isDeleted=0 and                         
	 st.th_taskheader<>'Click + Sign to Add Records'                          
	 and st.ParentId is not null                                       
	 --and th.TaskStatus  in ('IP','NS','IP-HOLD','CP')                                                        
	 and cm.ClientName not in ('GC_Prabhat')           
	 and isnull(th.TicketCatg1,'-')<>'Delete Task'   
	 and  cast(th.CreatedDate as date) > '2023-01-31'                     
	 --and th.id=16320              
                               
	union all              
              
	select                                                        
	st.id,               
	st.color1,st.color2,st.color3                                                                                    
	,th.id as 'TicketNo'                                             
	,cm.clientname as clientid__obp_taskheader                                              
	,th.th_taskheader as th_taskheader__obp_taskheader                                      
	,st.id as 'ActivityId'                                                                                  
	,st.th_taskheader  as 'Activity'                                       
	,case when st.TimeBuffer ='Cyan' then '0Cyan'                            
	 when st.TimeBuffer ='Green' then '1Green'                            
	 when st.TimeBuffer ='Yellow' then '2Yellow'                            
	 when st.TimeBuffer ='Red' then '3Red'                            
	 when st.TimeBuffer ='Black' then '4Black'                            
	end 'timebuffer__obp_taskheader'                             
	,th.TicketCatg1 as ticketcatg1__obp_taskheader                
	 ,convert(char(10),st.PlannedStartDt,126)     as 'PlannedStart'                                            
	,st.TaskDuration as 'Duration'                           
	 ,convert(char(10),st.TaskActEstDt,126)     as 'Planned Finish'                  
	  ,convert(char(10),st.TaskActStartDt,126)     as 'ActualStart'                  
	 ,st.taskstatus as taskstatus__obp_taskheader                                                                     
	,convert(char(10),st.EstDueDate,126)     as 'Requested Need Date'                 
	,st.BlackExcedDays as BlackExcedDays__obp_taskheader                
	,st.th_remarks as th_remarks__obp_taskheader                
	,replace(st.ShareToUser,'/','')  as 'AssignToUser'                 
	,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'                  
	,convert(char(10),st.ModifiedDate,126) 'LastModDt'                  
	,convert(char(10),st.CreatedDate,126)  'CreatedDate'                                                     
	,st.Createdby as createdby__obp_taskheader                               
	--,convert(char(10),st.ActualFinishDate,126)  'ActualFinishDate'         
	, case       
	   when st.TaskStatus not in ('CP','CL') then  convert(char(10),st.ActualFinishDate,126)        
	   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is not null) then convert(char(10),st.ClientClosureAcceptanceDate,126)      
	   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is null) then convert(char(10),st.ModifiedDate,126)       
	  end 'ActualFinishDate'      
      
	, replace(th.Sprint,'Completed','Committed') 'Committed'       
	from obp_TaskHeader st                                       
	join obp_TaskHeader th on th.id=st.id               
	left join obp_ClientMaster cm on th.ClientID=cm.id                            
	--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl  on tl.TicketId=th.id                 
	where                                                               
	((cm.id in (select value from string_split(@var_par1,',')) ) ) and  
	th.TaskStatus in ('CP','CL') and                
	 th.th_taskheader<>'Click + Sign to Add Records'                          
	 --and th.ParentId is null and                                         
	 and isnull(th.ParentId,0)=0 and                        
	 --st.isDeleted=0 and                         
	 st.th_taskheader<>'Click + Sign to Add Records'                          
	 and st.ParentId is not null                                       
	 --and th.TaskStatus  in ('IP','NS','IP-HOLD','CP')                                                        
	 and cm.ClientName not in ('GC_Prabhat')                                   
	 and isnull(th.TicketCatg1,'-')<>'Delete Task'                                          
	 and  cast(th.CreatedDate as date) > '2023-01-31'                                            
	 --and th.id=16320              
	 and th.Createdby=th.ShareToUser                                      
End
                                                   
END                     
                  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SendDailyTaskEmail]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create      proc [dbo].[obp_sp_SendDailyTaskEmail]      
as      
Begin      
/*ReCalculate Colors*/      
Exec obp_sp_TimeBuffer    
    
/*ReCalculate Tickets For Emails*/      
Exec obp_SP_GenerateDailyTaskSummaryToEmail    
  
/*Colors are not applicable for Backlog Tickets */  
update obp_tb_DailyTaskEmails_SummaryToEmail set ColorPriority='NA'  where Type='Backlog'   
      
Declare @var_username nvarchar(100),@var_email nvarchar(200),@var_count int      
    
      
set @var_count=(Select count(distinct Owner) from obp_tb_DailyTaskEmails_CountToEmail where status=0)      
      
/*Email to Members*/      
While @var_count<>0      
Begin      
 Set @var_username=(Select top 1 owner from obp_tb_DailyTaskEmails_CountToEmail where Status=0)      
 Set @var_email=(Select top 1 email from obp_tb_DailyTaskEmails_SummaryToEmail where Owner=@var_username)      
      
 Exec obp_DailyTasksEmail @var_email, @var_username      
      
 update obp_tb_DailyTaskEmails_CountToEmail set status=1 where owner=@var_username      
 Set @var_count=@var_count-1      
End      
    
      
/*Email to manager*/      
/*Exec obp_sp_SendDailyTaskEmail_Manager    */

if OBJECT_ID('tempdb..#tb_mgr') is not null drop table #tb_mgr
select distinct userid,0 'ind01' into #tb_mgr from obp_UsersExtended where type='Manager'


Declare @var_Mcount int, @var_MgrId int
set @var_Mcount =(Select count(*) from #tb_mgr where ind01=0)

while @var_Mcount<>0
Begin
set @var_MgrId=(Select top 1 userid from #tb_mgr where ind01=0)

/*print @var_MgrId*/

Exec obp_sp_SendDailyTaskEmail_Manager_v2 @var_MgrId

update #tb_mgr set ind01=1 where userid=@var_MgrId
set @var_Mcount=@var_Mcount-1
End

    
End    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SendDailyTaskEmail_Manager]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create      proc [dbo].[obp_sp_SendDailyTaskEmail_Manager]                
as                
Begin                
                
Declare @var_emailto nvarchar(100),@var_uname nvarchar(100)                
                
Set @var_emailto='hemant.kalia@goldrattgroup.com;srinivasan.v@goldrattgroup.com'                   
/*Set @var_emailto='bharat.sharma@goldrattgroup.com'        */
Set @var_uname='Hemant'                
                
DECLARE @xml NVARCHAR(MAX)                                        
DECLARE @body NVARCHAR(MAX)                   
                
DECLARE @xml1 NVARCHAR(MAX)                                        
DECLARE @body1 NVARCHAR(MAX)                                      
  
/*                        
SET @xml = CAST(( SELECT [Owner] AS 'td','',[TaskType] AS 'td','', [Nos] AS 'td','' ,[NS] as 'td','' ,[IP] as 'td','' ,[Red] as 'td','' ,[Black] as 'td'                                         
FROM obp_tb_DailyTaskEmails_CountToEmail   
ORDER BY Owner,TaskType desc    
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))           
*/  
  
/*Get the Data for specific user - Ticket Count*/          
SET @xml = CAST(( SELECT [Owner] AS 'td','',[TaskType] AS 'td','', [Nos] AS 'td','' ,[NS] as 'td','' ,[IP] as 'td','' ,[Ttl_Red] as 'td','' ,[Ttl_Black] as 'td'                 
FROM obp_tb_DailyTaskEmails_CountToEmail   
ORDER BY Owner,TaskType desc                                          
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                                   
                
SET @xml1 = CAST(( SELECT [Owner] AS 'td','',[Type] AS 'td','',[Ticket] AS 'td','',[Client] AS 'td','', [TaskName] AS 'td','' ,[TaskStatus] as 'td','' ,[ColorPriority] as 'td',''                  
FROM obp_tb_DailyTaskEmails_SummaryToEmail                 
ORDER BY Owner,Type Desc,Ticket                                        
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                    
  
                                                                         
                                        
SET @body ='<html><body>Dear Sir/Madam'+' '+'<P><BR>Please find below Task Status Summary and Details for Tickets assigned to the Team.</BR><P> Task Summary: <P>      
<table border = 1>                                         
<tr bgcolor=Orange>                                        
<th> Owner </th> <th> TaskType </th> <th> Total </th><th> NS </th><th> IP </th><th> Red </th><th> Black </th></tr>'                        
                       
                
SET @body = @body + @xml                
                
Set @body1='<P></table><BR>Task Details:</BR><P><table border = 1>                                         
<tr bgcolor=Orange>                                        
<th>Owner </th><th>Type </th><th>Ticket </th> <th> Client </th> <th> TaskName </th><th> TaskStatus </th><th> ColorPriority </th></tr>'            
              
SET @body = @body +'<P>' + @body1 + @xml1+'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>-----This is an auto generated email. Please Do not Reply-----</BR></body></html>'                   
                                
EXEC msdb.dbo.sp_send_dbmail                                        
@profile_name = 'Autoemails',                                        
@body = @body,                                        
@body_format ='HTML',                               
@recipients = @var_emailto,                               
@subject = 'DTMS : Task Summary & Details of your Team' ;                 
                
            
End           
      
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SendDailyTaskEmail_Manager_v1]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create    proc [dbo].[obp_sp_SendDailyTaskEmail_Manager_v1]              
as              
Begin              
              
Declare @var_emailto nvarchar(100),@var_uname nvarchar(100)              
              
Set @var_emailto='hemant.kalia@goldrattgroup.com;srinivasan.v@goldrattgroup.com'                 
--Set @var_emailto='bharat.sharma@goldrattgroup.com'      
Set @var_uname='Hemant'              
              
DECLARE @xml NVARCHAR(MAX)                                      
DECLARE @body NVARCHAR(MAX)                 
              
DECLARE @xml1 NVARCHAR(MAX)                                      
DECLARE @body1 NVARCHAR(MAX)                                    
                      
SET @xml = CAST(( SELECT [Owner] AS 'td','',[TaskType] AS 'td','', [Nos] AS 'td','' ,[NS] as 'td','' ,[IP] as 'td','' ,[Red] as 'td','' ,[Black] as 'td'                                       
FROM obp_tb_DailyTaskEmails_CountToEmail               
ORDER BY Owner,TaskType desc                                     
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                   
              
SET @xml1 = CAST(( SELECT [Owner] AS 'td','',[Type] AS 'td','',[Ticket] AS 'td','',[Client] AS 'td','', [TaskName] AS 'td','' ,[TaskStatus] as 'td','' ,[ColorPriority] as 'td',''                
FROM obp_tb_DailyTaskEmails_SummaryToEmail               
ORDER BY Owner,Type Desc,Ticket                                      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                  
/*                                      
SET @xml = CAST(( SELECT [ClientName] AS 'td','',[LicenseDate] AS 'td','', [DaysLeft] AS 'td','' ,[FeesPendingAmount] as 'td','', [ExpensePendingAmount] as 'td'                                      
FROM obp_EmailList where username= @var_uname                                      
ORDER BY ClientName                                      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                      
*/                                      
                                      
SET @body ='<html><body>Dear Sir/Madam'+' '+'<P><BR>Please find below Task Status Summary and Details for Tickets assigned to the Team.</BR><P> Task Summary: <P>    
<table border = 1>                                       
<tr bgcolor=Orange>                                      
<th> Owner </th> <th> TaskType </th> <th> Total </th><th> NS </th><th> IP </th><th> Red </th><th> Black </th></tr>'                      
/*<th> ClientName </th> <th> LicenseValidityDate </th> <th> DaysLeft </th><th> FeesPendingAmount </th><th> ExpensePendingAmount </th>*/                                          
/*                                       
SET @body = @body + @xml +'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>Goldratt Group</BR><BR>-----This is an auto generated email from http://164.52.203.134/ . Please Do not Reply-----</BR></body></html>'                                      
*/                                      
--SET @body = @body + @xml +'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>-----This is an auto generated email. Please Do not Reply-----</BR></body></html>'                      
              
SET @body = @body + @xml              
              
Set @body1='<P></table><BR>Task Details:</BR><P><table border = 1>                                       
<tr bgcolor=Orange>                                      
<th>Owner </th><th>Type </th><th>Ticket </th> <th> Client </th> <th> TaskName </th><th> TaskStatus </th><th> ColorPriority </th></tr>'          
            
SET @body = @body +'<P>' + @body1 + @xml1+'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>-----This is an auto generated email. Please Do not Reply-----</BR></body></html>'                 
                              
EXEC msdb.dbo.sp_send_dbmail                                      
@profile_name = 'Autoemails',                                      
@body = @body,                                      
@body_format ='HTML',                                      
@recipients = @var_emailto,                             
@subject = 'DTMS : Task Summary & Details of your Team' ;               
              
          
End         
    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SendDailyTaskEmail_Manager_v2]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create   procedure [dbo].[obp_sp_SendDailyTaskEmail_Manager_v2]  
(@var_ManagerId int)                
as                  
Begin                  
                  
Declare @var_emailto nvarchar(100),@var_uname nvarchar(100),@var_SearchId varchar(10)                  

set @var_SearchId='%;'+cast(@var_ManagerId as varchar(10))+';%'   

               
Set @var_emailto=(Select top 1 EmailId from obps_Users where id=@var_ManagerId)
/*Set @var_emailto='bharat.sharma@goldrattgroup.com'        */
Set @var_uname='Hemant'                  
                  
DECLARE @xml NVARCHAR(MAX)                                          
DECLARE @body NVARCHAR(MAX)                     
                  
DECLARE @xml1 NVARCHAR(MAX)                                          
DECLARE @body1 NVARCHAR(MAX)                                        
    
/*                          
SET @xml = CAST(( SELECT [Owner] AS 'td','',[TaskType] AS 'td','', [Nos] AS 'td','' ,[NS] as 'td','' ,[IP] as 'td','' ,[Red] as 'td','' ,[Black] as 'td'                                           
FROM obp_tb_DailyTaskEmails_CountToEmail     
ORDER BY Owner,TaskType desc      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))             
*/    

/*
Select * from obp_tb_DailyTaskEmails_CountToEmail order by owner
select ce.* 
from obp_tb_DailyTaskEmails_CountToEmail ce
join obps_Users us on us.UserName=ce.Owner
join obp_UsersExtended ue on ue.UserId=us.id 
where isnull(ue.ReportingTo,'') like '%;12;%'
order by ce.Owner

select ce.* 
from obp_tb_DailyTaskEmails_SummaryToEmail ce
join obps_Users us on us.UserName=ce.Owner
join obp_UsersExtended ue on ue.UserId=us.id 
where isnull(ue.ReportingTo,'') like '%;12;%'
order by ce.Owner
*/    

/*Get the Data for specific user - Ticket Count*/            
SET @xml = CAST(( SELECT ce.[Owner] AS 'td','',ce.[TaskType] AS 'td','', ce.[Nos] AS 'td','' ,ce.[NS] as 'td','' ,ce.[IP] as 'td','' ,ce.[Ttl_Red] as 'td'
,'' ,ce.[Ttl_Black] as 'td'                   
FROM obp_tb_DailyTaskEmails_CountToEmail ce
join obps_Users us on us.UserName=ce.Owner
join obp_UsersExtended ue on ue.UserId=us.id 
where isnull(ue.ReportingTo,'') like @var_SearchId   
ORDER BY Owner,TaskType desc                                            
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                                     
                  
SET @xml1 = CAST(( SELECT ce.[Owner] AS 'td','',ce.[Type] AS 'td','',ce.[Ticket] AS 'td','',ce.[Client] AS 'td','', ce.[TaskName] AS 'td','' ,ce.[TaskStatus] as 'td'
,'' ,ce.[ColorPriority] as 'td',''                    
FROM obp_tb_DailyTaskEmails_SummaryToEmail ce
join obps_Users us on us.UserName=ce.Owner
join obp_UsersExtended ue on ue.UserId=us.id 
where isnull(ue.ReportingTo,'') like @var_SearchId                    
ORDER BY Owner,ce.Type Desc,Ticket                                          
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                      
    
                                                                           
                                          
SET @body ='<html><body>Dear Sir/Madam'+' '+'<P><BR>Please find below Task Status Summary and Details for Tickets assigned to the Team.</BR><P> Task Summary: <P>        
<table border = 1>                                           
<tr bgcolor=Orange>                                          
<th> Owner </th> <th> TaskType </th> <th> Total </th><th> NS </th><th> IP </th><th> Red </th><th> Black </th></tr>'                          
                         
                  
SET @body = @body + @xml                  
                  
Set @body1='<P></table><BR>Task Details:</BR><P><table border = 1>                                           
<tr bgcolor=Orange>                                          
<th>Owner </th><th>Type </th><th>Ticket </th> <th> Client </th> <th> TaskName </th><th> TaskStatus </th><th> ColorPriority </th></tr>'              
                
SET @body = @body +'<P>' + @body1 + @xml1+'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>-----This is an auto generated email. Please Do not Reply-----</BR></body></html>'                     
                                  
EXEC msdb.dbo.sp_send_dbmail                                          
@profile_name = 'Autoemails',                                          
@body = @body,                                          
@body_format ='HTML',                                 
@recipients = @var_emailto,                                 
@subject = 'DTMS : Task Summary & Details of your Team' ;                   
                  
              
End             
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SkusMergeInsert]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_SkusMergeInsert]    
@UserName nvarchar(max)                                 
as    
begin     
    
 MERGE obp_gms_skus AS TARGET    
 USING obp_gms_skus_temp AS SOURCE    
 ON (TARGET.skucode=SOURCE.skucode )    
 WHEN NOT MATCHED BY TARGET    
 THEN     
	  INSERT (Skucode,skudescription)      
	  VALUES (SOURCE.skucode,SOURCE.skudescription)    
 WHEN MATCHED THEN 
	  UPDATE SET    
	  TARGET.skudescription=SOURCE.skudescription;  
    
end    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SubTaskAfterSave]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    procedure [dbo].[obp_sp_SubTaskAfterSave]                
(@var_rid int)                
as                
Begin                
Declare @var_taskheaderid int                
                
Set @var_taskheaderid=(Select isnull(ParentId,0) from obp_TaskHeader where id=@var_rid)    
  
/*If Task Status becomes Blank*/      
update obp_TaskHeader set TaskStatus= case when isnull(TaskActStartDt,'1900-01-01') > '1900-01-01' then 'IP' else 'NS' end where id=@var_rid and isnull(TaskStatus,'')=''   
      
                
/* Exec obp_sp_SubTaskTaskStatuscal @var_rid  */        
      
/*Delete the SubTask and MainTask when TaskStatus=DEL*/        
Delete from obp_Taskheader where id=@var_RID and TaskStatus = 'DEL'      
      
If ((Select isnull(count(*),0) from obp_Taskheader where ParentId=@var_taskheaderid) = 0)      
Delete from obp_Taskheader where id=@var_taskheaderid       
      
/*To make TaskActualStart Date =today date if not provided for IP Tasks*/        
update obp_TaskHeader set TaskActStartDt=cast(getdate() as date)  where id=@var_rid and isnull(TaskActStartDt,'1900-01-01') ='1900-01-01' and TaskStatus='IP'        
          
--Select id,TaskStatus,1 'Stage'  from obp_Taskheader where id=12856          
--Select id,TaskStatus,5 'Stage'  from obp_Taskheader where id=12854          
          
Exec obp_sp_SubTaskEstDateCal @var_rid               
          
--Select id,TaskStatus,2 'Stage'  from obp_Taskheader where id=12856          
                
Exec obp_sp_MaiTaskDatesCal @var_rid                
          
--Select id,TaskStatus,3 'Stage'  from obp_Taskheader where id=12856          
          
Exec obp_sp_TimeBufferCal @var_rid                
          
--Select id,TaskStatus,4 'Stage'  from obp_Taskheader where id=12856          
      
      
          
/*Trace Record*/                
If isnull(@var_taskheaderid,0)<>0                
Begin                
                
/*SP to update Share to user in Main Task*/                            
Exec obp_sp_UpdtShareToUser  @var_taskheaderid                 
                
/*SP to update taskstatus in Main Task*/                            
Exec obp_sp_GetMainTaskStatus  @var_taskheaderid                 
          
--Select id,TaskStatus,5 'Stage'  from obp_Taskheader where id=12856          
--Select id,TaskStatus,5 'Stage'  from obp_Taskheader where id=12854          
          
Insert into obp_TaskHeader_Trace                
Select             
 id,            
ClientID,            
th_TaskHeader,            
TaskStatus,            
EstDueDate,            
th_Remarks,            
TimeBuffer,            
BlackExcedDays,            
Color1,            
Color2,            
Color3,            
isActive,            
AccessToUser,            
ShareToUser,            
ScheduleType,            
TaskDuration,            
TaskActStartDt,            
TaskActEstDt,            
PlannedStartDt,            
Reason,            
ParentId,            
ActualFinishDate,            
OnHoldReason,            
TicketCatg1,            
ActualDuration,            
CreatedDate,            
ModifiedDate,            
Createdby,            
Modifiedby,            
'S-U',            
getdate(),            
td_SeqNo,            
ActFinishDate,            
FKBy,            
th_SeqNo            
--*,'S-U',getdate()             
from obp_TaskHeader where id in (@var_rid)                
End                
Else                
Begin                
Insert into obp_TaskHeader_Trace                
Select             
 id,            
ClientID,            
th_TaskHeader,            
TaskStatus,            
EstDueDate,            
th_Remarks,            
TimeBuffer,            
BlackExcedDays,            
Color1,            
Color2,            
Color3,            
isActive,            
AccessToUser,            
ShareToUser,            
ScheduleType,            
TaskDuration,            
TaskActStartDt,            
TaskActEstDt,            
PlannedStartDt,            
Reason,            
ParentId,            
ActualFinishDate,            
OnHoldReason,            
TicketCatg1,            
ActualDuration,            
CreatedDate,            
ModifiedDate,            
Createdby,            
Modifiedby,            
'M-U',            
getdate(),            
td_SeqNo,            
ActFinishDate,            
FKBy,            
th_SeqNo            
--*,'M-U',getdate()             
from obp_TaskHeader where id in (@var_rid)                
End                
    
/*Sprint Condition*/          
Update obp_Taskheader set Sprint ='Completed' where id = @var_taskheaderid and TaskStatus = 'CP'      
    
                
End       
      
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SubTaskDetectNoRecords]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[obp_sp_SubTaskDetectNoRecords]    
(@var_RID int)    
as    
Begin    
Declare @var_ParentId int, @var_RecCount int    
Declare @var_createdby nvarchar(100),@var_task nvarchar(max)    
    
Set @var_RecCount=0    
Set @var_ParentId=(Select ParentId from obp_Taskheader where id=@var_RID)    
    
Set @var_RecCount= (Select isnull(count(*),0) from obp_TaskHeader where ParentId=@var_ParentId and isActive=1 and TaskStatus not in ('DEL'))    
print @var_RecCount  
    
/*Insert First Sub Task for Main Task*/    
IF @var_RecCount=0    
Begin    
    
 Set @var_createdby=(Select Createdby from obp_Taskheader where id=@var_ParentId)    
 Set @var_task=(Select th_TaskHeader from obp_Taskheader where id=@var_ParentId)   
 print  @var_task  
  
 insert into obp_TaskHeader(ClientID,th_TaskHeader,CreatedDate,ModifiedDate,Createdby,isActive,ShareToUser,ScheduleType    
 ,ParentId)     
 values(1,@var_task,getdate(),getdate(),@var_createdby,1,@var_createdby,1,@var_ParentId);    
   
End    
    
End
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SubTaskEstDateCal]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[obp_sp_SubTaskEstDateCal]      
(@RID int)      
as      
Begin      
Declare @var_taskduration float,@var_taskplandt datetime      
Declare @var_CnfFlg int     
Declare @var_CurrTaskStatus nvarchar(50)  
      
Set @var_CnfFlg=0      
Set @var_taskduration=(Select taskduration from obp_TaskHeader where id=@RID)      
Set @var_taskplandt=(Select PlannedStartDt from obp_TaskHeader where id=@RID)      
Set @var_CurrTaskStatus=(Select TaskStatus from obp_TaskHeader where id=@RID)     
      
/*Check TaskDuration*/      
If isnull(@var_taskduration,-999) > -999      
Begin      
      
 /*Setting TaskDuration to min value*/      
 If (@var_taskduration < 1 and isnull(@var_taskduration,-999) > -999)      
 Begin      
  update obp_TaskHeader set TaskDuration=1 where id=@RID      
  set @var_taskduration=1      
  Set @var_CnfFlg=1      
 End      
      
 If isnull(@var_taskduration,-999) > 0      
 Begin      
  Set @var_CnfFlg=1      
 End      
      
End      
Else      
Begin      
 update obp_TaskHeader set TaskDuration=NULL where id=@RID      
 Set @var_CnfFlg=0      
End      
      
/*End - Check TaskDuration*/      
      
/*Check PlanStartDate*/      
      
If (@var_CnfFlg=1 and convert(date,isnull(@var_taskplandt,'1900-01-01'))<>'1900-01-01')      
Begin      
Set @var_CnfFlg=1      
End      
Else      
Begin      
Set @var_CnfFlg=0      
End      
      
      
/*End - Check PlanStartDate*/      
      
/*Setting PlannedEstDate*/      
      
IF @var_CnfFlg=1      
Begin      
 update obp_TaskHeader set TaskActEstDt=dateadd(DD,@var_taskduration-1,@var_taskplandt)  where id=@RID      
      
 update obp_TaskHeader set TaskActEstDt=dateadd(DD,(Select isnull(count(*),0) 'NWD' from obps_NonWorkingDays       
 where NonWorkingDays between isnull(PlannedStartDt,'1900-01-01') and isnull(TaskActEstDt,'1900-01-01')),TaskActEstDt)        
 where id=@RID      
      
End      
Else      
Begin   
 If @var_CurrTaskStatus<>'Backlog'  
 update obp_TaskHeader set TaskActEstDt=null,TaskActStartDt=null,TaskStatus='NS' where id=@RID      
 Else  
 update obp_TaskHeader set TaskActEstDt=null,TaskActStartDt=null where id=@RID      
End      
      
/*End - Setting PlannedEstDate*/      
      
/*Sprint Condition*/      
Update obp_Taskheader set Sprint ='Completed' where id=@RID and TaskStatus='CP'
End      

GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SubTaskTaskStatuscal]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obp_sp_SubTaskTaskStatuscal]                  
( @var_RID int )                  
as                  
Begin                
            
/*Make the TaskActualStart Date column as editable. Let the user punch the date when task is moved from NS-->CP*/              
/*Test the application*/            
                  
Declare @var_PrevTaskStatus nvarchar(10),@var_CurrentTaskStatus nvarchar(10)                  
Declare @var_PlanEstDate date          
Declare @var_TaskActStartDt date                
                  
Set @var_PrevTaskStatus=(Select top 1 isnull(TaskStatus,'NA') from obp_TaskHeader_Trace where id=@var_RID order by RecordDate desc)         
set @var_PrevTaskStatus=isnull(@var_PrevTaskStatus,'NA')               
Set @var_CurrentTaskStatus=(Select taskstatus from obp_TaskHeader where id=@var_RID)                  
set @var_PlanEstDate=(Select cast(isnull(TaskActEstDt,'1900-01-01') as date) from obp_TaskHeader where id=@var_RID)                  
set @var_TaskActStartDt=(Select cast(isnull(TaskActStartDt,'1900-01-01') as date) from obp_TaskHeader where id=@var_RID)          
                  
print @var_RID                  
print @var_CurrentTaskStatus                  
print @var_PrevTaskStatus                  
      
--insert into tb1_test values(getdate(),@var_RID,@var_PrevTaskStatus,@var_CurrentTaskStatus,@var_PlanEstDate,@var_TaskActStartDt,1)      
                  
/*Processing Task Status Transactions */                  
If (@var_PrevTaskStatus<>'NA'  and @var_PlanEstDate > '1900-01-01')                
Begin 
Print 'In-1'
 IF(@var_PrevTaskStatus='NS' and @var_CurrentTaskStatus='IP')                  
 Begin                  
 Update obp_TaskHeader set TaskActStartDt= case when (@var_TaskActStartDt='1900-01-01') then cast(getdate() as date) else @var_TaskActStartDt end  where id=@var_RID                  
 print 'NS-IP'                  
 End                  
                  
 IF(@var_PrevTaskStatus='NS' and @var_CurrentTaskStatus='CP')                  
 Begin                  
   If @var_TaskActStartDt>'1900-01-01'          
    Update obp_TaskHeader set ActualFinishDate=cast(getdate() as date),ActualDuration=(datediff(dd,TaskActStartDt,getdate())+1) where id=@var_RID                  
   Else          
    Update obp_TaskHeader set TaskStatus='NS',TaskActStartDt=NULL,ActualFinishDate=NULL,ActualDuration=NULL where id=@var_RID                  
             
 End                  
                  
 IF(@var_PrevTaskStatus='IP' and @var_CurrentTaskStatus='CP')                  
 Begin                  
 Update obp_TaskHeader set ActualFinishDate=cast(getdate() as date),ActualDuration=(datediff(dd,TaskActStartDt,getdate())+1) where id=@var_RID                  
 End                  
                  
 If (@var_CurrentTaskStatus='DEL')                  
 Begin                   
 Exec obp_sp_SubTaskDetectNoRecords @var_RID              
              
 Delete from obp_TaskHeader where id=@var_RID                  
 End                  
                  
 IF(@var_PrevTaskStatus='CP' and @var_CurrentTaskStatus='IP')                  
 Begin                  
 Update obp_TaskHeader set TaskActStartDt=cast(getdate() as date),ActualFinishDate=NULL,ActualDuration=NULL where id=@var_RID                  
 End                  
                  
 IF(@var_PrevTaskStatus='CP' and @var_CurrentTaskStatus='NS')                  
 Begin                  
 Update obp_TaskHeader set TaskActStartDt=NULL,ActualFinishDate=NULL,ActualDuration=NULL where id=@var_RID                  
 End       
     
 IF(@var_PrevTaskStatus='IP' and @var_CurrentTaskStatus='NS')                  
 Begin                  
 Update obp_TaskHeader set TaskActStartDt=NULL,ActualFinishDate=NULL,ActualDuration=NULL where id=@var_RID                  
 End 

print 'In-2' 
print @var_CurrentTaskStatus
print @var_PrevTaskStatus

 If (@var_PrevTaskStatus<>'Backlog' and @var_CurrentTaskStatus='Backlog') 
 --If (@var_PrevTaskStatus='NS' and @var_CurrentTaskStatus='Backlog') 
 Begin
 print 'B1'
 Update obp_taskheader set TaskStatus='Backlog' where id=(Select ParentId from obp_taskheader where id=@var_RID)
 End
                  
End                
--Else                
--Begin                
--Update obp_TaskHeader set TaskActStartDt=NULL,ActualFinishDate=NULL,ActualDuration=NULL,TaskStatus='NS' where id=@var_RID       
--End                  
/*End - Processing Task Status Transactions */        
      
--insert into tb1_test values(getdate(),@var_RID,@var_PrevTaskStatus,@var_CurrentTaskStatus,@var_PlanEstDate,@var_TaskActStartDt,2)      
      
/*For First time inserted SubTask*/              
IF(@var_PrevTaskStatus='NA')      
Begin      
--@var_CurrentTaskStatus                  
--@var_TaskActStartDt      
 If @var_CurrentTaskStatus='IP'       
 Begin      
  If @var_TaskActStartDt ='1900-01-01'      
  update obp_TaskHeader set @var_TaskActStartDt=cast(getdate() as date) where id=@var_RID;      
      
  If @var_TaskActStartDt >cast(getdate() as date)      
  update obp_TaskHeader set TaskActStartDt=cast(getdate() as date) where id=@var_RID;      
      
 End      
      
 If @var_CurrentTaskStatus<>'IP'      
  update obp_TaskHeader set TaskActStartDt=null,TaskStatus='NS' where id=@var_RID;      
      
End      
                
/*Deleting Task with Del Task Status*/          
If (@var_CurrentTaskStatus='DEL')                  
 Begin           
 Exec obp_sp_SubTaskDetectNoRecords @var_RID                  
           
 Delete from obp_TaskHeader where id=@var_RID                  
          
End             
/*End - Deleting Task with Del Task Status*/                  

/*To - Backlog*/ 
print @var_CurrentTaskStatus
print @var_PrevTaskStatus

 If (@var_PrevTaskStatus<>'Backlog' and @var_CurrentTaskStatus='Backlog') 
 --If (@var_PrevTaskStatus='NS' and @var_CurrentTaskStatus='Backlog') 
 Begin
 print 'B1'
 --Update obp_taskheader set TaskStatus='Backlog' where id=(Select ParentId from obp_taskheader where id=@var_RID)
 Update obp_taskheader set TaskStatus='Backlog' where id=@var_RID
 End

/*From - Backlog*/                  
If (@var_PrevTaskStatus='Backlog' and @var_CurrentTaskStatus<>'Backlog') 
 Begin
 print 'B2'
 Update obp_taskheader set TaskStatus='IP' where id=(Select ParentId from obp_taskheader where id=@var_RID)
 End

End 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_TimeBuffer]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   proc [dbo].[obp_sp_TimeBuffer]            
as            
Begin         
If OBJECT_ID('tempdb..##tb_Main') is not null drop table ##tb_Main        
      
select id,0 'ind01'             
into ##tb_Main            
from obp_TaskHeader where isActive=1 and isnull(parentid,0)=0 and th_TaskHeader<> 'Click + Sign to Add Records' and TaskStatus not in ('CP','CL')       
and ClientID>1        
    
       
/*     
 Select * from ##tb_Main        
delete from ##tb_Main where id <> 5519        
*/
            
Declare @var_MTID_cnt int,@var_headerticketid int,@var_id int            
Declare @var_color nvarchar(10)        
            
Set @var_MTID_cnt=(Select count(*) from ##tb_Main where ind01=0)            
            
While @var_MTID_cnt<>0            
Begin            
        
      
        
Set @var_headerticketid=(Select top 1 id from ##tb_Main where ind01=0)            
      
         
/*TimeBuffer*/                
update obp_TaskHeader set TimeBuffer=case                 
when datediff(dd, PlannedStartDt,getdate())  < 0  then 'Cyan'                
when datediff(dd, PlannedStartDt,getdate())  between 0 and (datediff(dd, PlannedStartDt,TaskActEstDt)/3) then 'Green'                              
when datediff(dd, PlannedStartDt,getdate())  between ((datediff(dd, PlannedStartDt,TaskActEstDt)/3)+1) and ((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3) then 'Yellow'                             
when datediff(dd, PlannedStartDt,getdate())  between (((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3)+1) and datediff(dd, PlannedStartDt,TaskActEstDt) then 'Red'                             
when datediff(dd, PlannedStartDt,getdate()) > datediff(dd, PlannedStartDt,TaskActEstDt) then 'Black' end                            
where                               
(id=@var_headerticketid or parentid=@var_headerticketid  ) and                               
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'           
                      
                          
                          
update obp_TaskHeader set TimeBuffer='Black' where (id=@var_headerticketid or parentid=@var_headerticketid )         
/*--and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<=0   */
and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<0         
and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                  
                                  
update obp_TaskHeader set color3=TimeBuffer where (id=@var_headerticketid or parentid=@var_headerticketid ) and                                     
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                  
                                  
update obp_TaskHeader set BlackExcedDays=case when datediff(dd,TaskActEstDt,getdate()) > 0 then datediff(dd,TaskActEstDt,getdate()) else 0 end                                  
where (id=@var_headerticketid or parentid=@var_headerticketid ) and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                   
/*and timebuffer ='Black'*/
        
        
/*Making all cyan where planned date > today*/        
update  obp_TaskHeader set color3='Cyan',TimeBuffer='Cyan' where         
(id=@var_headerticketid or parentid=@var_headerticketid ) and         
isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date) > cast(getdate()  as date)        
        
        
/*Color to be Red for tasks with same day*/        
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where         
(id=@var_headerticketid or parentid=@var_headerticketid ) and         
TaskDuration<=1 and isnull(BlackExcedDays,0)<1 and  cast(TaskActEstDt as date)=cast(getdate()  as date)        
        
        
        
/*Color to be Green and Red for tasks with 2 days*/         
update  obp_TaskHeader set color3='Green',TimeBuffer='Green' where (id=@var_headerticketid or parentid=@var_headerticketid ) and         
TaskDuration=2 and isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date)=cast(getdate()  as date)        
/*and  cast((DATEADD(dd,1,PlannedStartDt)) as date) =cast(getdate()  as date)        */
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where (id=@var_headerticketid or parentid=@var_headerticketid ) and          
TaskDuration=2 and isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date) < cast(getdate()  as date)         
/*End - TimeBuffer*/             
            
update ##tb_Main set ind01=1 where id=@var_headerticketid            
Set @var_MTID_cnt=@var_MTID_cnt-1            
      
End            
            
End 
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_TimeBufferCal]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obp_sp_TimeBufferCal]              
( @var_RID int )                  
as              
Begin    
/*Comment: This method can be moved to UI */  
   
/*Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                                    
Declare @var_headerticketid int,@var_PlannedStartDt datetime,@var_TaskActEstDt datetime,@var_TaskDuration int,@var_TaskActStartDt datetime                        
                        
Set @var_headerticketid =(Select top 1 ParentId from obp_TaskHeader where id=@var_RID)                               
              
/*TimeBuffer*/                    
update obp_TaskHeader set TimeBuffer=case                     
when datediff(dd, PlannedStartDt,getdate())  < 0  then 'Cyan'                    
when datediff(dd, PlannedStartDt,getdate())  between 0 and (datediff(dd, PlannedStartDt,TaskActEstDt)/3) then 'Green'                                  
when datediff(dd, PlannedStartDt,getdate())  between ((datediff(dd, PlannedStartDt,TaskActEstDt)/3)+1) and ((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3) then 'Yellow'                                 
when datediff(dd, PlannedStartDt,getdate())  between (((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3)+1) and datediff(dd, PlannedStartDt,TaskActEstDt) then 'Red'                                 
when datediff(dd, PlannedStartDt,getdate()) > datediff(dd, PlannedStartDt,TaskActEstDt) then 'Black' end                                
where                                   
(id=@var_headerticketid or ParentId=@var_headerticketid  ) and                         
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                
                              
                              
update obp_TaskHeader set TimeBuffer='Black' where (id=@var_headerticketid or ParentId=@var_headerticketid  )       
--and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<=0                              
and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<0       
and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                
                                
update obp_TaskHeader set color3=TimeBuffer where (id=@var_headerticketid or ParentId=@var_headerticketid  ) and                                   
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                
                                
update obp_TaskHeader set BlackExcedDays=case when datediff(dd,TaskActEstDt,getdate()) > 0 then datediff(dd,TaskActEstDt,getdate()) else 0 end                                
where (id=@var_headerticketid or ParentId=@var_headerticketid  ) and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                 
--and timebuffer ='Black'                            
      
/*Color to be Red for tasks with same day*/      
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where TaskDuration<=1 and isnull(BlackExcedDays,0)<1 and  cast(TaskActEstDt as date)=cast(getdate()  as date)      
and TaskStatus <> 'CP'  and (id=@var_headerticketid or ParentId=@var_headerticketid  )    
    
/*Color to be Green and Red for tasks with 2 days*/       
update  obp_TaskHeader set color3='Green',TimeBuffer='Green' where TaskDuration=2 and isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date)=cast(getdate()  as date)    
and TaskStatus <> 'CP'  and (id=@var_headerticketid or ParentId=@var_headerticketid  )    
      
--and  cast((DATEADD(dd,1,PlannedStartDt)) as date) =cast(getdate()  as date)      
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where TaskDuration=2 and isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date) < cast(getdate()  as date)      
and TaskStatus <> 'CP'  and (id=@var_headerticketid or ParentId=@var_headerticketid  )      
/*End - TimeBuffer*/        
                      
--update obp_TaskHeader set PlannedStartDt= TaskHeaderID                      
/*End - Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                                  
--update obp_TaskDetails set Color1=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='NS' then 'Red' else 'White' end where id=@var_id                                  
update obp_TaskHeader set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end                                   
where (id=@var_headerticketid or ParentId=@var_headerticketid  )      
              
              
End            
    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_TimeBufferCal_SMT]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obp_sp_TimeBufferCal_SMT]                
( @var_RID int )                    
as                
Begin      
/*Comment: This method can be moved to UI */    
     
/*Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                                      
Declare @var_headerticketid int,@var_PlannedStartDt datetime,@var_TaskActEstDt datetime,@var_TaskDuration int,@var_TaskActStartDt datetime                          
                          
Set @var_headerticketid = @var_RID
                
/*TimeBuffer*/                      
update obp_TaskHeader set TimeBuffer=case                       
when datediff(dd, PlannedStartDt,getdate())  < 0  then 'Cyan'                      
when datediff(dd, PlannedStartDt,getdate())  between 0 and (datediff(dd, PlannedStartDt,TaskActEstDt)/3) then 'Green'                                    
when datediff(dd, PlannedStartDt,getdate())  between ((datediff(dd, PlannedStartDt,TaskActEstDt)/3)+1) and ((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3) then 'Yellow'                                   
when datediff(dd, PlannedStartDt,getdate())  between (((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3)+1) and datediff(dd, PlannedStartDt,TaskActEstDt) then 'Red'                                   
when datediff(dd, PlannedStartDt,getdate()) > datediff(dd, PlannedStartDt,TaskActEstDt) then 'Black' end                                  
where                                     
id=@var_headerticketid  and                           
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                  
                                
                                
update obp_TaskHeader set TimeBuffer='Black' where id=@var_headerticketid  
--and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<=0                                
and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<0         
and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                  
                                  
update obp_TaskHeader set color3=TimeBuffer where id=@var_headerticketid and  
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                  
                                  
update obp_TaskHeader set BlackExcedDays=case when datediff(dd,TaskActEstDt,getdate()) > 0 then datediff(dd,TaskActEstDt,getdate()) else 0 end                                  
where id=@var_headerticketid  and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                   
--and timebuffer ='Black'                              
        
/*Color to be Red for tasks with same day*/        
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where TaskDuration<=1 and isnull(BlackExcedDays,0)<1 and  cast(TaskActEstDt as date)=cast(getdate()  as date)        
and TaskStatus <> 'CP'  and id=@var_headerticketid  
      
/*Color to be Green and Red for tasks with 2 days*/         
update  obp_TaskHeader set color3='Green',TimeBuffer='Green' where TaskDuration=2 and isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date)=cast(getdate()  as date)      
and TaskStatus <> 'CP'  and id=@var_headerticketid  
        
--and  cast((DATEADD(dd,1,PlannedStartDt)) as date) =cast(getdate()  as date)        
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where TaskDuration=2 and isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date) < cast(getdate()  as date)        
and TaskStatus <> 'CP'  and id=@var_headerticketid  
/*End - TimeBuffer*/          
                        
--update obp_TaskHeader set PlannedStartDt= TaskHeaderID                        
/*End - Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                                    
--update obp_TaskDetails set Color1=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='NS' then 'Red' else 'White' end where id=@var_id                                    
update obp_TaskHeader set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end                                     
where id=@var_headerticketid  
                
                
End    
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_UpdtShareToUser]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     proc [dbo].[obp_sp_UpdtShareToUser]          
(@var_MainTaskID int)          
as          
Begin          
        
          
if object_id('tempdb..#tb_names') is not null drop table #tb_names          
if object_id('tempdb..##tb_MTID') is not null drop table ##tb_MTID          
          
Declare @var_MTID int,@var_AllUsers nvarchar(max),@var_MTUser nvarchar(max)          
Declare @var_TikCont int          
DECLARE @Names VARCHAR(8000)          
          
Create table #tb_names          
(          
Users nvarchar(max)          
)           
        
         
select id,0 'ind01'         
into ##tb_MTID         
from obp_TaskHeader where isActive=1 and ParentId = 0 and th_TaskHeader<> 'Click + Sign to Add Records' and TaskStatus<>'CP'          
and id=@var_MainTaskID          
          
          
set @var_TikCont=(Select count(*) from ##tb_MTID)          
          
While @var_TikCont<>0          
Begin          
set @var_MTID=(Select top 1 id from ##tb_MTID where ind01=0)          
          
set @Names=''          
truncate table #tb_names          
          
insert into #tb_names          
Select distinct Createdby from obp_taskheader where id=@var_MTID          
          
insert into #tb_names          
Select distinct isnull(sharetouser,Createdby) from obp_taskheader where ParentId=@var_MTID and isnull(sharetouser,Createdby) collate database_default not in (Select a.Users from #tb_names a)          
          
SELECT @Names = COALESCE(@Names + '/ ', '') + Users           
FROM #tb_names           
          
print @var_MTID          
print @Names          
          
update obp_taskheader set sharetouser=@Names where id=@var_MTID and taskstatus<>'CP'    
    
/*Add Implementer Details*/        
Declare @var_TypeId int,@var_Implementer nvarchar(500),@var_SR_Implementer nvarchar(500)  
  
Select   
--TH.Createdby,   
@var_TypeId= U.UserTypeId, @var_Implementer=CM.Implementer  
,@var_SR_Implementer='%'+CM.Implementer+'%'  
 --,CM.ClientName  
from (Select * from obp_Taskheader ) TH    
join obps_users U on U.UserName=TH.Createdby  
join obp_ClientMaster cm on cm.id =TH.ClientID  
where Th.id = @var_MTID  
  
--Select @var_TypeId, @var_Implementer  
if @var_TypeId=2  
Begin  
 If (Select isnull(count(*),0) from  obp_Taskheader where id=@var_MTID and ShareToUser like @var_SR_Implementer)=0  
    Update obp_Taskheader set ShareToUser=ShareToUser+' / '+@var_Implementer where id=@var_MTID  
End  
  
/*End - Add Implementer Details*/        
          
update ##tb_MTID set ind01=1 where id=@var_MTID          
set @var_TikCont=@var_TikCont-1          
End          
/*End loop*/          
          
if object_id('tempdb..#tb_names') is not null drop table #tb_names          
if object_id('tempdb..##tb_MTID') is not null drop table ##tb_MTID          
          
End       
  
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_UpdtShareToUser_1Time]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     proc [dbo].[obp_sp_UpdtShareToUser_1Time]            
(@var_MainTaskID int)            
as            
Begin            
          
            
if object_id('tempdb..#tb_names') is not null drop table #tb_names            
if object_id('tempdb..##tb_MTID') is not null drop table ##tb_MTID            
            
Declare @var_MTID int,@var_AllUsers nvarchar(max),@var_MTUser nvarchar(max)            
Declare @var_TikCont int            
DECLARE @Names VARCHAR(8000)            
            
Create table #tb_names            
(            
Users nvarchar(max)            
)             
          
           
select id,0 'ind01'           
into ##tb_MTID           
from obp_TaskHeader where isActive=1 and ParentId = 0 and th_TaskHeader<> 'Click + Sign to Add Records'
-- and TaskStatus<>'CP'            
and id=@var_MainTaskID            
            
            
set @var_TikCont=(Select count(*) from ##tb_MTID)            
            
While @var_TikCont<>0            
Begin            
set @var_MTID=(Select top 1 id from ##tb_MTID where ind01=0)            
            
set @Names=''            
truncate table #tb_names            
            
insert into #tb_names            
Select distinct Createdby from obp_taskheader where id=@var_MTID            
            
insert into #tb_names            
Select distinct isnull(sharetouser,Createdby) from obp_taskheader where ParentId=@var_MTID and isnull(sharetouser,Createdby) collate database_default not in (Select a.Users from #tb_names a)            
            
SELECT @Names = COALESCE(@Names + '/ ', '') + Users             
FROM #tb_names             
            
print @var_MTID            
print @Names            
            
update obp_taskheader set sharetouser=@Names where id=@var_MTID 
--and taskstatus<>'CP'      
      
/*Add Implementer Details*/          
Declare @var_TypeId int,@var_Implementer nvarchar(500),@var_SR_Implementer nvarchar(500)    
    
Select     
--TH.Createdby,     
@var_TypeId= U.UserTypeId, @var_Implementer=CM.Implementer    
,@var_SR_Implementer='%'+CM.Implementer+'%'    
 --,CM.ClientName    
from (Select * from obp_Taskheader ) TH      
join obps_users U on U.UserName=TH.Createdby    
join obp_ClientMaster cm on cm.id =TH.ClientID    
where Th.id = @var_MTID    
    
--Select @var_TypeId, @var_Implementer    
if @var_TypeId=2    
Begin    
 If (Select isnull(count(*),0) from  obp_Taskheader where id=@var_MTID and ShareToUser like @var_SR_Implementer)=0    
    Update obp_Taskheader set ShareToUser=ShareToUser+' / '+@var_Implementer where id=@var_MTID    
End    
    
/*End - Add Implementer Details*/          
            
update ##tb_MTID set ind01=1 where id=@var_MTID            
set @var_TikCont=@var_TikCont-1            
End            
/*End loop*/            
            
if object_id('tempdb..#tb_names') is not null drop table #tb_names            
if object_id('tempdb..##tb_MTID') is not null drop table ##tb_MTID            
            
End         
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_UpdtShareToUser_20240229]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obp_sp_UpdtShareToUser_20240229]      
(@var_MainTaskID int)      
as      
Begin      
    
      
if object_id('tempdb..#tb_names') is not null drop table #tb_names      
if object_id('tempdb..##tb_MTID') is not null drop table ##tb_MTID      
      
Declare @var_MTID int,@var_AllUsers nvarchar(max),@var_MTUser nvarchar(max)      
Declare @var_TikCont int      
DECLARE @Names VARCHAR(8000)      
      
Create table #tb_names      
(      
Users nvarchar(max)      
)       
    
     
select id,0 'ind01'     
into ##tb_MTID     
from obp_TaskHeader where isActive=1 and ParentId = 0 and th_TaskHeader<> 'Click + Sign to Add Records' and TaskStatus<>'CP'      
and id=@var_MainTaskID      
      
      
set @var_TikCont=(Select count(*) from ##tb_MTID)      
      
While @var_TikCont<>0      
Begin      
set @var_MTID=(Select top 1 id from ##tb_MTID where ind01=0)      
      
set @Names=''      
truncate table #tb_names      
      
insert into #tb_names      
Select distinct Createdby from obp_taskheader where id=@var_MTID      
      
insert into #tb_names      
Select distinct isnull(sharetouser,Createdby) from obp_taskheader where ParentId=@var_MTID and isnull(sharetouser,Createdby) collate database_default not in (Select a.Users from #tb_names a)      
      
SELECT @Names = COALESCE(@Names + '/ ', '') + Users       
FROM #tb_names       
      
print @var_MTID      
print @Names      
      
update obp_taskheader set sharetouser=@Names where id=@var_MTID and taskstatus<>'CP'      
      
update ##tb_MTID set ind01=1 where id=@var_MTID      
set @var_TikCont=@var_TikCont-1      
End      
/*End loop*/      
      
if object_id('tempdb..#tb_names') is not null drop table #tb_names      
if object_id('tempdb..##tb_MTID') is not null drop table ##tb_MTID      
      
End   
  
GO
/****** Object:  StoredProcedure [dbo].[obps_admin_charttype]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_admin_charttype]  
AS  
BEGIN  
select distinct id,charttypes from obps_ChartTypeMaster  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_admin_sp_DropColumn]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_admin_sp_DropColumn]  
@tabname nvarchar(MAX)='',  
@colname nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @str nvarchar(MAX)=''  
SET @str='ALTER TABLE '+@tabname+' DROP COLUMN '+@colname  
exec (@str)  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_ap_admin_getValidationImport]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_ap_admin_getValidationImport]
@linkid nvarchar(MAX)='',
@tablename nvarchar(MAX)=''
AS
BEGIN
 
 SELECT id,ColumnName,Datatype FROM obps_ValidColumnsForImport
 WHERE LinkId=@linkid AND TableName=@tablename

END
GO
/****** Object:  StoredProcedure [dbo].[obps_CreatePageLayout1GridClass]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_CreatePageLayout1GridClass]
@LayoutId INT=1
AS
BEGIN
		DECLARE @GridSp NVARCHAR(MAX)
		DECLARE @Data_Type nvarchar(150),
				@Column_Name nvarchar(150)

		select @GridSp=spName from obps_PageLayout where Id=@LayoutId

		print 
	   'using System;
		using System.Collections.Generic;
		using System.Linq;
		using System.Web;

		namespace Onebeat_PL.Models
		{
			public class Layout1GridDetailsClass
			{'
		DECLARE cur CURSOR FOR
		select 

		case 
			when Data_Type like 'nvarchar%' then
			'string'
			when Data_Type like '%datetime%' or  Data_Type like '%date%' then
			'DateTime'
			when Data_Type like 'bit%' then
			'int'
			else
			Data_Type
			end ,Column_Name
		--into #inpclass
		FROM INFORMATION_SCHEMA.COLUMNS
		inner join Obps_LayoutPageTabAttr PA on Column_Name=PA.ColumnName
		and Table_Name=PA.TableName
		WHERE  PA.IsVisible=1 and PA.TableName in 
		(SELECT DISTINCT t.name 
		FROM sys.sql_dependencies d 
		INNER JOIN sys.procedures p ON p.object_id = d.object_id
		INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
		where p.name=@GridSp) 
		--order by ColName
		OPEN cur

		FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
		WHILE @@FETCH_STATUS = 0
		BEGIN   

		PRINT 'public '+@Data_Type+ ' '+@Column_Name+' { get; set;}'
		FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
		END

		CLOSE cur;
		DEALLOCATE cur;
		print 
		'}
		 }'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_deletedashboardconfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_deletedashboardconfig]
@id int=''
AS
BEGIN

delete from obps_Dashboards where id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_getColNameDatatype]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_getColNameDatatype]      
@tablename nvarchar(MAX)=''   ,  
@linkid nvarchar(MAX)=''  
AS      
BEGIN      
if(@tablename LIKE '%_temp')
	set @tablename=(select TempTableName from obps_ExcelImportConfig where LinkId=@linkid) 

SELECT column_name as 'Column Name', data_type as 'Data Type',case IS_NULLABLE      
            when 'NO' then 0      
            else 1      
            end as nullable      
FROM information_schema.columns       
WHERE table_name = @tablename      
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_getColumnnameFromTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_getColumnnameFromTable]
@tablename nvarchar(MAX)=''
AS
BEGIN

SELECT column_name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'obp_OFC_Demand' and column_name not in
('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo',
'isActive','isDeleted')

END
GO
/****** Object:  StoredProcedure [dbo].[obps_getGanttTask_old]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_getGanttTask_old]
@selData nvarchar(MAX)='',
@lnkId  nvarchar(MAX)=''
AS
BEGIN
--Gant -1
/* For Work Order Status*/
--exec obp_sp_PH_wogantt
/*End -  For Work Order Status */

--Gant -2
/*  For Resource Detail Status */

--exec obp_sp_PH_ResourceLoadDetailsGantt

/*End-   For Resource Detail Status */

--Gant -3
/*  For Resource Status */

--exec obp_sp_PH_ResourceLoadGantt

/*End-   For Resource Status */

DECLARE @ganttsp nvarchar(MAX)

SET @ganttsp= (select GanttSp from obps_ganttconfiguration where LinkId=@lnkId)
if @selData='' or @selData is null
	exec @ganttsp 
else
	exec @ganttsp @selData
END
GO
/****** Object:  StoredProcedure [dbo].[obps_getImportDeleteTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_getImportDeleteTable]        
@tablename nvarchar(MAX)=''   ,    
@linkid nvarchar(MAX)='',
@userName nvarchar(MAX)=''
AS        
BEGIN        
DECLARE @DeleteSp nvarchar(MAX)=''

set @DeleteSp=(select ltrim(rtrim(DeleteSp)) from obps_ExcelImportConfig where LinkId=@linkid)        
    
if len(ltrim(rtrim(@DeleteSp)))>1      
begin      
/*Implementer SP will have userid as parameter*/    
exec @DeleteSp   @Username     
end        
END

GO
/****** Object:  StoredProcedure [dbo].[obps_getLayout1GridDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_getLayout1GridDetails]
@usrname nvarchar(MAX)=''
AS
BEGIN

	DECLARE @spname NVARCHAR(MAX)

SET @spname=(select spName from obps_pagelayout where isActive=1)

exec @spname @usrname

END
GO
/****** Object:  StoredProcedure [dbo].[obps_getPageLayout]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_getPageLayout]
AS
BEGIN
select layoutName,SpName from [dbo].[Obps_PageLayout] where IsActive=1
END


GO
/****** Object:  StoredProcedure [dbo].[obps_jobs_database_backup]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Created to take backup every day*/              
CREATE   proc [dbo].[obps_jobs_database_backup]              
as              
begin              
              
Declare @var_dt varchar(10),@var_path varchar(500)              
Declare @var_timestamp varchar(10)            
            
set @var_dt=(select convert(varchar(10),convert(date,getdate())))              
set @var_timestamp=convert(varchar(4),datepart(hh,getdate()))+'_'+convert(varchar(4),datepart(mi,getdate()))            
set @var_path='C:\GCData\DbBackup\SQLDBAutoBkup\obp_dtms_'+@var_dt+'_'+@var_timestamp+'.bak'              
              
BACKUP DATABASE [obp_dtms]              
TO  DISK = @var_path              
WITH CHECKSUM;              
end 
GO
/****** Object:  StoredProcedure [dbo].[obps_largeorder]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obps_largeorder]
(
@var_user nvarchar(100)=''                                   
,@var_pid int=''                                   
,@var_clientid int=''   
)
as
BEGIN
    -- Update/insert data in obp_largeOrders based on the inserted data in obp_largeOrders_temp

   MERGE INTO obp_largeOrders AS target
USING obp_largeOrders_temp AS source
ON target.Sono = source.Sono AND target.Sku = source.Sku
WHEN MATCHED THEN
    UPDATE SET
        target.SalesOffice = source.SalesOffice,
        target.CrtDt = source.CrtDt,
        target.SkuDesc = source.SkuDesc,
        target.CustomerCode = source.CustomerCode,
        target.CustomerName = source.CustomerName,
        target.SOqty = source.SOqty,
        target.SoUoM = source.SoUoM,
        target.OpenQty = source.OpenQty,
        target.CableType = source.CableType,
        target.IsValid = source.IsValid,
        target.UpdateDate = source.UpdateDate
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        SalesOffice, SoNo, CrtDt, Sku, SkuDesc,
        CustomerCode, CustomerName, SOqty, SoUoM,
        OpenQty, CableType, IsValid, UpdateDate
    )
    VALUES (
        source.SalesOffice, source.SoNo, source.CrtDt, source.Sku, source.SkuDesc,
        source.CustomerCode, source.CustomerName, source.SOqty, source.SoUoM,
        source.OpenQty, source.CableType,'1', source.UpdateDate
    );

END;
GO
/****** Object:  StoredProcedure [dbo].[obps_ReadGanttTask_old]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_ReadGanttTask_old]
@lnkId nvarchar(MAX)=''
AS
BEGIN

DECLARE @ganttsp nvarchar(MAX)

SET @ganttsp= (select GanttSp from obps_ganttconfiguration where LinkId=@lnkId)

exec @ganttsp

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AddColumnToTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_AddColumnToTable]    
@tabname nvarchar(MAX)='',    
@ColName nvarchar(MAX)='',    
@Datatype nvarchar(MAX)='',    
@Default nvarchar(MAX)='',    
@AllowNull nvarchar(MAX)='',    
@UserCol nvarchar(MAX)=''    
AS    
BEGIN    
DECLARE @str nvarchar(MAX),@allownullstr nvarchar(MAX),@def nvarchar(MAX)    
DECLARE @id nvarchar(MAX),@sp nvarchar(MAX),@spname nvarchar(MAX),@count int=0    
 if @AllowNull='true'    
 BEGIN    
  SET @allownullstr='  NULL;'    
 END    
 else    
  SET @allownullstr='  NOT NULL;'    
 IF Lower(@Datatype)='nvarchar'    
 BEGIN    
  set @Datatype='nvarchar(MAX)'    
  if @default<>''    
  BEGIN    
   set @default=''''+@default+''''    
  END    
 END    
 select @default    
 IF Lower(@Datatype)='datetime' and @default<>''    
 BEGIN    
  set @default=''''+@default+''''    
 END    
        
    
    
	 if @Default=''    
	 BEGIN  
	  SET @def=''    
	  if @allownullstr='  NOT NULL;'  
	 SET @allownullstr='  NULL;'  
	 end  
	 else    
	  SET @def='DEFAULT '+@default    

	 SET @str='ALTER TABLE '+@tabname+' ADD '+@ColName+' '+ @Datatype+' '+@def+' '+@allownullstr    
	 select @str     
	 exec (@str)    

	DECLARE CUR_tabCol CURSOR FAST_FORWARD FOR    
	SELECT Linkid,gridsp from obps_TopLinkextended      
	OPEN CUR_tabCol    
	FETCH NEXT FROM CUR_tabCol INTO @id,@sp    
	WHILE @@FETCH_STATUS = 0    
	BEGIN    

		set @count=(SELECT count(SPECIFIC_NAME) FROM information_schema.routines ISR WHERE CHARINDEX(@tabname, ISR.ROUTINE_DEFINITION) > 0   
		and ROUTINE_NAME=@sp and ROUTINE_TYPE='PROCEDURE')
		  IF @count>0  
		   exec obps_sp_ColAttribMapping @id     
    
	FETCH NEXT FROM CUR_tabCol INTO @id,@sp    
	END    
    
	CLOSE CUR_tabCol    
	DEALLOCATE CUR_tabCol      
END    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AddDate]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_AddDate]  
@date NVARCHAR(MAX)='',
@clientid NVARCHAR(MAX)
--@lId int=''
AS  
BEGIN  
insert into obps_NonWorkingDays values( @clientid,@date)
 --select ID,clientname as name from obp_ClientMaster  
END  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AddNonWorkingDaysWeekly]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[obps_sp_AddRoleid]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_AddRoleid]
@desc nvarchar(MAX)=''
AS
BEGIN

DECLARE @roleid int,@count int

SET @count=(select count(*) from obps_rolemaster where roleid!='' or roleid is not null)

IF(@count>0)
	SET @roleid=(select MAX(roleid)from obps_rolemaster)+1
ELSE
	SET @roleid=1

INSERT INTO obps_rolemaster(roleid,roledescription)
VALUES(@roleid,@desc) 

END


  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AddUserPermission]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_AddUserPermission]
@userid int='',
@linkid int='',
@gid int='',
@par1 nvarchar(MAX)='',
@par2 nvarchar(MAX)='',
@par3 nvarchar(MAX)='',
@par4 nvarchar(MAX)='',
@par5 nvarchar(MAX)=''
AS
BEGIN

BEGIN TRY

	INSERT INTO obps_SpPermissions(UserId,Linkid,Gridid,Par1,Par2,Par3,Par4,Par5)
	VALUES(@userid,@linkid,@gid,@par1,@par2,@par3,@par4,@par5)

END TRY
BEGIN CATCH

	SELECT ERROR_MESSAGE()

END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_CheckImportExist]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_CheckImportExist]
@LinkId nvarchar(MAX)=''
AS
BEGIN
	DECLARE @count int=0
	SET @count=(select count(*) from obps_ExcelImportConfig where LinkId=@LinkId)
	IF @count>0
		select '1'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteCalculatedRowAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteCalculatedRowAttrib]  
@id nvarchar(MAX)=''  
AS  
BEGIN  
  
delete from obps_CalculatedRowAttrib where id=@id  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteChartSettings]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteChartSettings]
@linkid int=''
AS
BEGIN

delete from obps_charts where LinkId=@linkid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteDropDownConfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteDropDownConfig]
@id nvarchar(MAX)=''
AS
BEGIN

delete from obps_DropDownTable where id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteImportValidation]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteImportValidation]
@id nvarchar(MAX)=''
AS
BEGIN
 
 Delete from obps_ValidColumnsForImport
 WHERE id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteMenu]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteMenu]
@linkid nvarchar(MAX)=''
AS
BEGIN

delete from obps_TopLinks where id=@linkid
delete from obps_ColAttrib where LinkId=@linkid
delete from obps_UserLinks where sublinkid=@linkid
delete from obps_RowAttrib where LinkId=@linkid
delete from obps_ExcelImportConfig where LinkId=@linkid
delete from obps_ValidColumnsForImport where LinkId=@linkid
delete from obps_FileUpload where LinkId=@linkid
delete from obps_GanttConfiguration where LinkId=@linkid
delete from obps_CalculatedColAttrib where LinkId=@linkid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteRowAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteRowAttrib]
@id nvarchar(MAX)=''
AS
BEGIN

delete from obps_RowAttrib where id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteUserLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteUserLink]  
@id nvarchar(MAX)=''  
AS  
BEGIN  
 update obps_UserLinks set IsDeleted=1 where id=@id  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_getAttachmentFileDisplay]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_getAttachmentFileDisplay]  
  @Linkid nvarchar(MAX)=''  
  AS  
  BEGIN  
  
 SELECT UploadPath,AllowedExtension from obps_TopLinks where id=@Linkid  
  
  END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_GetCalculatedattribDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_GetCalculatedattribDetails]  
AS  
BEGIN  
select C.id,C.ColName,C.DisplayName as DisplayColName,ColColor,GridId,ColumnWidth,M.DisplayName,T.LinkName,  
SortIndex,C.SortOrder,IsActive,C.IsMobile,ToolTip,SummaryType,FormatCondIconId 'Icon',MinVal,
MaxVal from obps_CalculatedColAttrib C  
inner join obps_TopLinks T on t.id=C.LinkId inner join obps_MenuName M  
on M.Id=T.MenuId where C.IsDeleted=0  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_GetCalculatedRowattribDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[obps_sp_admin_GetCalculatedRowattribDetails]  
AS  
BEGIN  
  
 select R.id,M.DisplayName,L.LinkName,ColName,MappedCol,R.GridId,IsBackground,CellEditColName  
 from obps_calculatedRowAttrib R inner join obps_TopLinks L on L.id=R.LinkId 
 inner join obps_MenuName M on L.MenuId=M.Id  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_getChartSettingsDetailsDisplay]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_getChartSettingsDetailsDisplay]    
@Id nvarchar(MAX)=''    
AS    
BEGIN    
    
DECLARE @ddlsp nvarchar(MAX)='',@divsp nvarchar(MAX)='',@divtitle nvarchar(MAX)='',    
@type int=0,@divcount int=0,    
@div1type nvarchar(MAX)='',@div1spname nvarchar(MAX)='',@div2type nvarchar(MAX)='',@div2spname nvarchar(MAX)='',    
@div3type nvarchar(MAX)='',@div3spname nvarchar(MAX)='',@div4type nvarchar(MAX)='',@div4spname nvarchar(MAX)='',    
@div1title nvarchar(MAX)='',@div2title nvarchar(MAX)='',@div3title nvarchar(MAX)='',@div4title nvarchar(MAX)='',    
@div1filtertxt nvarchar(MAX)='',@div2filtertxt nvarchar(MAX)='',@div3filtertxt nvarchar(MAX)='',@div4filtertxt nvarchar(MAX)='',    
@div1filtersp nvarchar(MAX)='',@div2filtersp nvarchar(MAX)='',@div3filtersp nvarchar(MAX)='',@div4filtersp nvarchar(MAX)='',    
    
@div1filter1txt nvarchar(MAX)='',@div1filter2txt nvarchar(MAX)='',@div1filter3txt nvarchar(MAX)='',    
@div2filter1txt nvarchar(MAX)='',@div2filter2txt nvarchar(MAX)='',@div2filter3txt nvarchar(MAX)='',    
@div3filter1txt nvarchar(MAX)='',@div3filter2txt nvarchar(MAX)='',@div3filter3txt nvarchar(MAX)='',    
@div4filter1txt nvarchar(MAX)='',@div4filter2txt nvarchar(MAX)='',@div4filter3txt nvarchar(MAX)='',    
    
@div1filter1sp nvarchar(MAX)='',@div1filter2sp nvarchar(MAX)='',@div1filter3sp nvarchar(MAX)='',    
@div2filter1sp nvarchar(MAX)='',@div2filter2sp nvarchar(MAX)='',@div2filter3sp nvarchar(MAX)='',    
@div3filter1sp nvarchar(MAX)='',@div3filter2sp nvarchar(MAX)='',@div3filter3sp nvarchar(MAX)='',    
@div4filter1sp nvarchar(MAX)='',@div4filter2sp nvarchar(MAX)='',@div4filter3sp nvarchar(MAX)=''    
    
SET @type=(SELECT type from obps_TopLinks where ID=@Id)    
    
if(@type=23)    
 SET @divcount=2    
else if(@type=24)    
 SET @divcount=4    
else if(@type=21)    
 SET @divcount=1    
    
SET @divsp=(select divsp from obps_charts where linkid=@Id)    
SET @divtitle=(select DivTitle from obps_charts where linkid=@Id)    
    
SET @div1filtertxt=(select Div1FilterText from obps_charts where linkid=@Id)    
SET @div2filtertxt=(select Div2FilterText from obps_charts where linkid=@Id)    
SET @div3filtertxt=(select Div3FilterText from obps_charts where linkid=@Id)    
SET @div4filtertxt=(select Div4FilterText from obps_charts where linkid=@Id)    
    
SET @div1filtersp=(select Div1Filtersp from obps_charts where linkid=@Id)    
SET @div2filtersp=(select Div2Filtersp from obps_charts where linkid=@Id)    
SET @div3filtersp=(select Div3Filtersp from obps_charts where linkid=@Id)    
SET @div4filtersp=(select Div4Filtersp from obps_charts where linkid=@Id)    
    
if object_id('tempdb..#Chartdata','U') is not null    
 drop table #Chartdata    
CREATE TABLE #Chartdata(id int,divsp nvarchar(MAX),divtitle nvarchar(MAX)    
,divfilter1text nvarchar(MAX),divfilter2text nvarchar(MAX),divfilter3text nvarchar(MAX)    
,divfilter1sp nvarchar(MAX),divfilter2sp nvarchar(MAX),divfilter3sp nvarchar(MAX))    
        
if len(rtrim(ltrim(@divsp)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@divsp,';')      
     )      
 insert into #Chartdata(id,divsp)    
 Select ROW_NUM,value from cte    
    
 end    
    
 if len(rtrim(ltrim(@divtitle)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@divtitle,';')      
     )      
 update #Chartdata set divtitle=(select value from cte where  ROW_NUM= id )    
    
 end    
 ------------GETTING FILTER TEXT-----------------------------------    
if len(rtrim(ltrim(@div1filtertxt)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,1 as 'cteid',* FROM STRING_SPLIT(@div1filtertxt,';')      
     )      
 update #Chartdata set divfilter1text=(select value from cte where  ROW_NUM=1 ),    
 divfilter2text=(select value from cte where  ROW_NUM=2  ),divfilter3text=(select value from cte where  ROW_NUM=3 )where id=1        
 end    
if len(rtrim(ltrim(@div2filtertxt)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,2 as 'cteid',* FROM STRING_SPLIT(@div2filtertxt,';')      
     )      
 update #Chartdata set divfilter1text=(select value from cte where ROW_NUM=1 ),    
 divfilter2text=(select value from cte where ROW_NUM=2  ),divfilter3text=(select value from cte where  ROW_NUM=3 ) where id=2    
 end    
    
 if len(rtrim(ltrim(@div3filtertxt)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,1 as 'cteid',* FROM STRING_SPLIT(@div3filtertxt,';')      
     )      
 update #Chartdata set divfilter1text=(select value from cte where  ROW_NUM=1 ),    
 divfilter2text=(select value from cte where  ROW_NUM=2  ),divfilter3text=(select value from cte where  ROW_NUM=3 )where id=3    
    
 end    
if len(rtrim(ltrim(@div4filtertxt)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,2 as 'cteid',* FROM STRING_SPLIT(@div4filtertxt,';')      
     )      
 update #Chartdata set divfilter1text=(select value from cte where ROW_NUM=1 ),    
 divfilter2text=(select value from cte where ROW_NUM=2  ),divfilter3text=(select value from cte where  ROW_NUM=3 ) where id=4    
 end    
 ------------END GETTING FILTER TEXT-----------------------------------    
    
 ------------GETTING FILTER SP-----------------------------------    
if len(rtrim(ltrim(@div1filtersp)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,1 as 'cteid',* FROM STRING_SPLIT(@div1filtersp,';')      
     )      
 update #Chartdata set divfilter1sp=(select value from cte where  ROW_NUM=1 ),    
 divfilter2sp=(select value from cte where  ROW_NUM=2  ),divfilter3sp=(select value from cte where  ROW_NUM=3 )where id=1    
    
 end    
if len(rtrim(ltrim(@div2filtersp)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,2 as 'cteid',* FROM STRING_SPLIT(@div2filtersp,';')      
     )      
 update #Chartdata set divfilter1sp=(select value from cte where ROW_NUM=1 ),    
 divfilter2text=(select value from cte where ROW_NUM=2  ),divfilter3sp=(select value from cte where  ROW_NUM=3 ) where id=2    
 end    
    
 if len(rtrim(ltrim(@div3filtersp)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,1 as 'cteid',* FROM STRING_SPLIT(@div3filtersp,';')      
     )      
 update #Chartdata set divfilter1sp=(select value from cte where  ROW_NUM=1 ),    
 divfilter2sp=(select value from cte where  ROW_NUM=2  ),divfilter3sp=(select value from cte where  ROW_NUM=3 )where id=3    
    
 end    
if len(rtrim(ltrim(@div4filtersp)))>0        
BEGIN      
 ;WITH   cte      
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,2 as 'cteid',* FROM STRING_SPLIT(@div4filtersp,';')      
     )      
 update #Chartdata set divfilter1sp=(select value from cte where ROW_NUM=1 ),    
 divfilter2sp=(select value from cte where ROW_NUM=2  ),divfilter3sp=(select value from cte where  ROW_NUM=3 ) where id=4    
 end    
 ------------END GETTING FILTER SP-----------------------------------    
    
 if(@divcount=1 or @divcount=2 or @divcount=4)    
 BEGIN    
  SET @div1type=(SELECT SUBSTRING(divsp,0,CHARINDEX ('__', divsp)) from #Chartdata where id=1 )      
  SET @div1spname=(SELECT SUBSTRING(divsp,CHARINDEX ('__', divsp)+2,len(divsp)) from #Chartdata where id=1 )      
  SET @div1title=(SELECT divtitle from #Chartdata where id=1 )      
    
  SET @div1filter1txt=(SELECT divfilter1text from #Chartdata where id=1 )     
  SET @div1filter2txt=(SELECT divfilter2text from #Chartdata where id=1 )     
  SET @div1filter3txt=(SELECT divfilter3text from #Chartdata where id=1 )     
    
  SET @div1filter1sp=(SELECT divfilter1sp from #Chartdata where id=1 )     
  SET @div1filter2sp=(SELECT divfilter2sp from #Chartdata where id=1 )     
  SET @div1filter3sp=(SELECT divfilter3sp from #Chartdata where id=1 )     
 END    
 IF (@divcount=2 or @divcount=4)    
 BEGIN    
  SET @div2type=(SELECT SUBSTRING(divsp,0,CHARINDEX ('__', divsp)) from #Chartdata where id=2 )      
  SET @div2spname=(SELECT SUBSTRING(divsp,CHARINDEX ('__', divsp)+2,len(divsp)) from #Chartdata where id=2 )      
  SET @div2title=(SELECT divtitle from #Chartdata where id=2 )      
    
  SET @div2filter1txt=(SELECT divfilter1text from #Chartdata where id=2 )     
  SET @div2filter2txt=(SELECT divfilter2text from #Chartdata where id=2 )     
  SET @div2filter3txt=(SELECT divfilter3text from #Chartdata where id=2 )     
    
  SET @div2filter1sp=(SELECT divfilter1sp from #Chartdata where id=2 )     
  SET @div2filter2sp=(SELECT divfilter2sp from #Chartdata where id=2 )     
  SET @div2filter3sp=(SELECT divfilter3sp from #Chartdata where id=2 )     
    
 END    
 IF ( @divcount=4)    
 BEGIN    
  SET @div3type=(SELECT SUBSTRING(divsp,0,CHARINDEX ('__', divsp)) from #Chartdata where id=3 )      
  SET @div3spname=(SELECT SUBSTRING(divsp,CHARINDEX ('__', divsp)+2,len(divsp)) from #Chartdata where id=3 )     
  SET @div3title=(SELECT divtitle from #Chartdata where id=3 )      
  SET @div3filter1txt=(SELECT divfilter1text from #Chartdata where id=3 )     
  SET @div3filter2txt=(SELECT divfilter2text from #Chartdata where id=3 )     
  SET @div3filter3txt=(SELECT divfilter3text from #Chartdata where id=3 )     
  SET @div3filter1sp=(SELECT divfilter1sp from #Chartdata where id=3 )     
  SET @div3filter2sp=(SELECT divfilter2sp from #Chartdata where id=3 )     
  SET @div3filter3sp=(SELECT divfilter3sp from #Chartdata where id=3 )     
    
  SET @div4type=(SELECT SUBSTRING(divsp,0,CHARINDEX ('__', divsp)) from #Chartdata where id=4 )      
  SET @div4spname=(SELECT SUBSTRING(divsp,CHARINDEX ('__', divsp)+2,len(divsp)) from #Chartdata where id=4 )     
  SET @div4title=(SELECT divtitle from #Chartdata where id=4 )      
  SET @div4filter1txt=(SELECT divfilter1text from #Chartdata where id=4)     
  SET @div4filter2txt=(SELECT divfilter2text from #Chartdata where id=4 )     
  SET @div4filter3txt=(SELECT divfilter3text from #Chartdata where id=4 )     
  SET @div4filter1sp=(SELECT divfilter1sp from #Chartdata where id=4 )     
  SET @div4filter2sp=(SELECT divfilter2sp from #Chartdata where id=4 )     
  SET @div4filter3sp=(SELECT divfilter3sp from #Chartdata where id=4 )     
     
 END    
  select  @divcount,@div1type,@div1spname,@div2type,@div2spname,@div3type,@div3spname,@div4type,@div4spname,    
    Div1Charttype,Div2Charttype,Div3Charttype,Div4Charttype,@div1title,@div2title,@div3title,@div4title,    
   @div1filter1txt,@div1filter2txt,@div1filter3txt,@div2filter1txt,@div2filter2txt,@div2filter3txt,    
   @div3filter1txt,@div3filter2txt,@div3filter3txt,@div4filter1txt,@div4filter2txt,@div4filter3txt,    
   @div1filter1sp,@div1filter2sp,@div1filter3sp,@div2filter1sp,@div2filter2sp,@div2filter3sp,    
   @div3filter1sp,@div3filter2sp,@div3filter3sp,@div4filter1sp,@div4filter2sp,@div4filter3sp,    
   IsSameFilter,DepenedentFilterDivs,IsSameChartType,DepenedentChartTypeDivs     
   from obps_charts where LinkId=@Id    
    
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_GetColNameRowattrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_GetColNameRowattrib]            
@tabname nvarchar(MAX)=''  ,          
@condition nvarchar(MAX)=''        
AS            
BEGIN            
 IF @condition='color'          
 BEGIN     
	  select 1 'id','color1' 'ColName' 
	  union
	  select 2 'id','color2' 'ColName'
	  union
	  select 3 'id','color3' 'ColName'
	  union
	  select 4 'id','color4' 'ColName' 
	  union
	  select 5 'id','color5' 'ColName'
	  union
	  select 6 'id','color6' 'ColName'
	  union
	  select 7 'id','color7' 'ColName'
  --SELECT ORDINAL_POSITION 'id',lower(COLUMN_NAME) 'ColName'          
  --FROM INFORMATION_SCHEMA.COLUMNS          
  --WHERE TABLE_NAME = @tabname          
  --and COLUMN_NAME not in ('id','id1','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser',        
  --'ShareToUser','iscelledit1','iscelledit2','iscelledit3','iscelledit4','iscelledit5','iscelledit6','iscelledit7')          
  --and COLUMN_NAME in('Color1','Color2','Color3','Color4','Color5','Color6','Color7')        
  --ORDER BY ORDINAL_POSITION        
 END        
 ELSE IF @condition='edit'        
 BEGIN      
	  select 1 'id','iscelledit1' 'ColName' 
	  union
	  select 2 'id','iscelledit2' 'ColName'
	  union
	  select 3 'id','iscelledit3' 'ColName'
	  union
	  select 4 'id','iscelledit4' 'ColName' 
	  union
	  select 5 'id','iscelledit5' 'ColName'
	  union
	  select 6 'id','iscelledit6' 'ColName'
	  union
	  select 7 'id','iscelledit7' 'ColName'
  --select  ORDINAL_POSITION 'id',lower(COLUMN_NAME) 'ColName'               
  --FROM INFORMATION_SCHEMA.COLUMNS          
  --WHERE TABLE_NAME = @tabname         
  --and COLUMN_NAME not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate',        
  --'Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')            
  --and COLUMN_NAME in('iscelledit1','iscelledit2','iscelledit3','iscelledit4','iscelledit5','iscelledit6','iscelledit7')         
 END    
  ELSE IF @condition='mctrl'        
 BEGIN        
  select  ORDINAL_POSITION 'id',lower(COLUMN_NAME) 'ColName'               
  FROM INFORMATION_SCHEMA.COLUMNS          
  WHERE TABLE_NAME = @tabname         
  and COLUMN_NAME not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate',        
  'Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')            
  and COLUMN_NAME in('ctrltype1','ctrltype2','ctrltype3','ctrltype4','ctrltype5','ctrltype6','ctrltype7')         
 END   
 ElSE      
 BEGIN      
  select  ORDINAL_POSITION 'id',lower(COLUMN_NAME) 'ColName'               
  FROM INFORMATION_SCHEMA.COLUMNS          
  WHERE TABLE_NAME = @tabname         
  and COLUMN_NAME not in ('id','id1','SeqNo','CreatedDate','ModifiedDate',        
  'Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')            
  and COLUMN_NAME in('Color1','Color2','Color3','Color4','Color5','iscelledit1','iscelledit2','iscelledit3','iscelledit4','iscelledit5','iscelledit6','iscelledit7')         
 END      
END     
    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_GetDDLColName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_GetDDLColName]
@tabname nvarchar(MAX)=''  ,    
@ddltable nvarchar(MAX)='',
@linkid nvarchar(MAX)=''   
AS
BEGIN
IF @ddltable='yes'
 SELECT ORDINAL_POSITION 'id',COLUMN_NAME 'ColName'        
 FROM INFORMATION_SCHEMA.COLUMNS        
 WHERE TABLE_NAME = @tabname        
 and COLUMN_NAME not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')        
 ORDER BY ORDINAL_POSITION  
ELSE
	select id,ColName from obps_ColAttrib           
   where ColName not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')          
   and IsActive=1 and LOWER(ColControlType)='dropdownlist' and TableName=@tabname  and LinkId=@linkid
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_getGanttSettingsDetailsDisplay]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[obps_sp_admin_getGanttSettingsDetailsDisplay]
  @id nvarchar(MAX)=''
  AS
  BEGIN

	SELECT GanttSp,DependencySp from obps_GanttConfiguration where LinkId=@id

  END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_getGridCount]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_admin_getGridCount]
@sublink int=0
AS
BEGIN
DECLARE @pagetype int,
@gcount int

SET @pagetype=(select type from obps_TopLinks where id=@sublink)

SET @gcount=(SELECT Gridcount from obps_PageType where PageTypeId=@pagetype)

select @gcount

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_GetImportDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_GetImportDetails]
AS
BEGIN
select I.Id,Displayname  as 'MainMenu',LinkName as 'SubMenu',
TableName,TempTableName,InsertSp from
obps_ExcelImportConfig I inner join obps_toplinks T on T.id=I.linkid 
inner join obps_MenuName M on T.MenuId=M.MenuId
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_getMenuNameByCond]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_getMenuNameByCond]           
@PageType nvarchar(MAX)=''      
AS            
BEGIN        
 if @PageType='gantt'      
 BEGIN      
  select Id,DisplayName from obps_MenuName where IsVisible=1 and  id in(select menuid from obps_TopLinks where Type in(4,11))      
 END      
 ELSE  if @PageType='import'      
 BEGIN    
   select Id,DisplayName from obps_MenuName where IsVisible=1 and  id in(select menuid from obps_TopLinks where IsImportEnabled=1)      
   or id in(select menuid from obps_TopLinks where Type in(20))    
 END      
 ELSE  if @PageType='chart'      
 BEGIN    
   select Id,DisplayName from obps_MenuName where IsVisible=1 and  id in(select menuid from obps_TopLinks where Type in(21,22,23,24,2526,27))      
 END    
 ELSE    
 BEGIN    
 if @PageType='attach'      
   select Id,DisplayName from obps_MenuName where IsVisible=1 and  (id in(select menuid from obps_TopLinks where Type =19)    
   or id in(select menuid from obps_TopLinks where IsUploadEnabled=1) )    
 END      
END   
  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_getPageLayoutId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[obps_sp_admin_getPageLayoutId]  
@linkid nvarchar(MAX)=''  
AS   
BEGIN  
select Type from obps_TopLinks where id=@linkid  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_GetRowattribDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_GetRowattribDetails]  
AS  
BEGIN  
  
 select R.id,M.DisplayName,L.LinkName,R.TableName,ColName,MappedCol,R.GridId,IsBackground,CellEditColName,CellCtrlTypeColName,DdlCtrlSpColName  
 from obps_RowAttrib R inner join obps_TableId T on R.TableID=T.TableId  
 inner join obps_TopLinks L on L.id=R.LinkId inner join obps_MenuName M on L.MenuId=M.Id  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertAttachmentFileSettings]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[obps_sp_admin_InsertAttachmentFileSettings]  
  @linkid nvarchar(MAX)='',  
  @uploadPath nvarchar(MAX)='',
  @allowedExtensions nvarchar(MAX)=''
  AS  
  BEGIN  
  
 update obps_TopLinks set uploadpath=@uploadPath,AllowedExtension=@allowedExtensions where id=@linkid  
  select '1'
  END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertCalcColAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_InsertCalcColAttrib]  
@linkid nvarchar(MAX)='',  
@colname nvarchar(MAX)='',  
@displayname nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@colcolour nvarchar(MAX)='',  
@colwidth nvarchar(MAX)='',  
@sortindex nvarchar(MAX)='',  
@sortorder nvarchar(MAX)='',  
@isactive nvarchar(MAX)='',  
@ismobile nvarchar(MAX)='',
@tooltip nvarchar(MAX)='',
@formatCondIcon nvarchar(MAX)='',
@summarytype nvarchar(MAX)='',
@minval nvarchar(MAX)='',
@maxval nvarchar(MAX)=''
AS  
BEGIN  
  
INSERT INTO obps_CalculatedColAttrib  
(ColName,DisplayName,ColColor,GridId,ColumnWidth,LinkId,SortIndex,  
SortOrder,CreatedDate,CreatedBY,IsActive,IsMobile,ToolTip,SummaryType,MinVal,MaxVal,FormatCondIconId)  
values  
(@colname,@displayname,@colcolour,@gridid,@colwidth,@linkid,@sortindex,  
@sortorder,getdate(),'admin',@isactive,@ismobile,@tooltip,@summarytype,@minval,@maxval,@formatCondIcon)  
select '1'  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertCalculatedRowAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_admin_InsertCalculatedRowAttrib]  
@linkid nvarchar(MAX)='',  
@tabname nvarchar(MAX)='',  
@colname nvarchar(MAX)='',  
@mappedcol nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@isbackground nvarchar(MAX)='',  
@celleditcol nvarchar(MAX)=''  
AS  
BEGIN  
  
  INSERT INTO obps_calculatedrowattrib(ColName,MappedCol,GridId,IsBackground,CellEditColName,LinkId)  
  values(@colname,@mappedcol,@gridid,@isbackground,@celleditcol,@linkid)  
  select '1'  

END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertGanttSettings]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[obps_sp_admin_InsertGanttSettings]
  @linkid nvarchar(MAX)='',
  @ganttsp nvarchar(MAX)='',
  @dependencysp nvarchar(MAX)=''
  AS
  BEGIN
  DECLARE @count int=0
  SET @count=(SELECT count(*) from obps_GanttConfiguration where LinkId=@linkid) 
  if @count>0
  BEGIN
		update obps_GanttConfiguration set GanttSp=@ganttsp,DependencySp=@dependencysp where LinkId=@linkid
		select '1'
  END
  else
  BEGIN
	  INSERT INTO obps_GanttConfiguration(GanttSp,DependencySp,LinkId)
	  values(@ganttsp,@dependencysp,@linkid)
	  select '1'
  END
  END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertImportDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_InsertImportDetails]
@LinkId nvarchar(MAX)='',
@TableName nvarchar(MAX)='',
@TempTableName nvarchar(MAX)='',
@InsertSp nvarchar(MAX)=''
AS
BEGIN

	insert into obps_ExcelImportConfig(LinkId,TableName,TempTableName,InsertSp) values(@LinkId,@TableName,@TempTableName,@InsertSp)
END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertImportValidation]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_InsertImportValidation]
@linkid nvarchar(MAX)='',
@tablename nvarchar(MAX)='',
@colname nvarchar(MAX)='',
@datatype nvarchar(MAX)=''
AS
BEGIN

insert into obps_ValidColumnsForImport(Tablename,ColumnName,Datatype,linkid) 
values(@tablename,@colname,@datatype,@linkid)

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertRowAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_admin_InsertRowAttrib]  
@linkid nvarchar(MAX)='',  
@tabname nvarchar(MAX)='',  
@colname nvarchar(MAX)='',  
@mappedcol nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@isbackground nvarchar(MAX)='', 
@cellctrlcol nvarchar(MAX)='',
@ddlsp nvarchar(MAX)='',
@celleditcol nvarchar(MAX)=''  
AS  
BEGIN  
 DECLARE @tabid nvarchar(MAX)='',@count int=0;  
 SET @count=(select count(*) from obps_TableId where TableName=@tabname)  
  
 IF @count>0  
 BEGIN  
  SET @tabid=(select tableid from obps_TableId where TableName=@tabname)  
  INSERT INTO obps_RowAttrib(TableID,TableName,ColName,MappedCol,GridId,IsBackground,CellEditColName,CellCtrlTypeColName,DdlCtrlSpColName,LinkId)  
  values(@tabid,@tabname,@colname,@mappedcol,@gridid,@isbackground,@celleditcol,@cellctrlcol,@ddlsp,@linkid)  
  select '1'  
 END  
 ELSE  
  Select '0'  
END  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertUpdateChartSettings]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     
CREATE PROCEDURE [dbo].[obps_sp_admin_InsertUpdateChartSettings]          
@id int='',    
@linkid int='',     
@savetype nvarchar(MAX)='',    
@DivSp nvarchar(MAX)='',@DivTitle nvarchar(MAX)='',@Div1Charttype nvarchar(MAX)='',    
@Div2Charttype nvarchar(MAX)='',@Div3Charttype nvarchar(MAX)='',@Div4Charttype nvarchar(MAX)='',    
@Div5Charttype nvarchar(MAX)='',@Div6Charttype nvarchar(MAX)='',@Div1FilterSp nvarchar(MAX)='',    
@Div2FilterSp nvarchar(MAX)='',@Div3FilterSp nvarchar(MAX)='',@Div4FilterSp nvarchar(MAX)='',    
@Div5FilterSp nvarchar(MAX)='',@Div6FilterSp nvarchar(MAX)='',@Div1FilterText nvarchar(MAX)='',    
@Div2FilterText nvarchar(MAX)='',@Div3FilterText nvarchar(MAX)='',@Div4FilterText nvarchar(MAX)='',    
@Div5FilterText nvarchar(MAX)='',@Div6FilterText nvarchar(MAX)='',@IsSameFilter nvarchar(MAX)='',    
@DepenedentFilterDivs nvarchar(MAX)='', @IsSameChartType nvarchar(MAX)='',@DepenedentChartTypeDivs nvarchar(MAX)=''    
AS          
BEGIN          
  
DECLARE @count int=0;   
SET @count=(select count(*) from obps_Charts where LinkId=@linkid)  
  
IF @count>0  
 SET @savetype='update'  
else  
 set @savetype='insert'  
   
if(@savetype='insert')    
BEGIN  
 insert into obps_Charts(DivSp,DivTitle,Div1Charttype,Div2Charttype,Div3Charttype,Div4Charttype,Div5Charttype,Div6Charttype,Div1FilterSp,Div2FilterSp,Div3FilterSp,    
 Div4FilterSp,Div5FilterSp,Div6FilterSp,Div1FilterText,Div2FilterText,Div3FilterText,Div4FilterText,Div5FilterText,Div6FilterText,IsSameFilter,DepenedentFilterDivs,    
 IsSameChartType,DepenedentChartTypeDivs,LinkId)    
 values(@DivSp,@DivTitle,@Div1Charttype,@Div2Charttype,@Div3Charttype,@Div4Charttype,@Div5Charttype,@Div6Charttype,@Div1FilterSp,@Div2FilterSp,@Div3FilterSp,    
 @Div4FilterSp,@Div5FilterSp,@Div6FilterSp,@Div1FilterText,@Div2FilterText,@Div3FilterText,@Div4FilterText,@Div5FilterText,@Div6FilterText,@IsSameFilter,@DepenedentFilterDivs,    
 @IsSameChartType,@DepenedentChartTypeDivs,@LinkId)    
END    
else    
BEGIN  
    update obps_charts set DivSp=@DivSp,DivTitle=@DivTitle,Div1Charttype=@Div1Charttype,Div2Charttype=@Div2Charttype,Div3Charttype=@Div3Charttype,Div4Charttype=@Div4Charttype,    
 Div5Charttype=@Div5Charttype,Div6Charttype=@Div6Charttype,Div1FilterSp=@Div1FilterSp,Div2FilterSp=@Div2FilterSp,Div3FilterSp=@Div3FilterSp,Div4FilterSp=@Div4FilterSp,    
 Div5FilterSp=@Div5FilterSp,Div6FilterSp=@Div6FilterSp,Div1FilterText=@Div1FilterText,Div2FilterText=@Div2FilterText,Div3FilterText=@Div3FilterText,Div4FilterText=@Div4FilterText,    
 Div5FilterText=@Div5FilterText,Div6FilterText=@Div6FilterText,IsSameFilter=@IsSameFilter,DepenedentFilterDivs=@DepenedentFilterDivs,IsSameChartType=@IsSameChartType,    
 DepenedentChartTypeDivs=@DepenedentChartTypeDivs where LinkId=@LinkId    
END        
Select '1'          
          
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_UpdateCalcColAttribSettings]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_admin_UpdateCalcColAttribSettings]  
@linkid nvarchar(MAX)='',  
@colname nvarchar(MAX)='',  
@displayname nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@colcolour nvarchar(MAX)='',  
@colwidth nvarchar(MAX)='',  
@sortindex nvarchar(MAX)='',  
@sortorder nvarchar(MAX)='',  
@isactive nvarchar(MAX)='',  
@ismobile nvarchar(MAX)='',
@tooltip nvarchar(MAX)='',
@minval nvarchar(MAX)='',
@maxval nvarchar(MAX)='',
@summarytype nvarchar(MAX)='',
@formatcondicon nvarchar(MAX)='',
@id nvarchar(MAX)=''  
AS  
BEGIN  
  
update obps_CalculatedColAttrib set ColName=@colname,DisplayName=@displayname,ColColor=@colcolour,  
GridId=@gridid,ColumnWidth=@colwidth,LinkId=@linkid,SortIndex=@sortindex,SortOrder=@sortorder,  
ModifiedBy='admin',IsActive=@isactive,IsMobile=@ismobile ,ToolTip=@tooltip,MinVal=@minval,
MaxVal=@maxval,SummaryType=@summarytype,FormatCondIconId=@formatcondicon
where id=@id  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_UpdateCalculatedRowAttribSettings]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_UpdateCalculatedRowAttribSettings]  
@linkid nvarchar(MAX)='',  
@columnname nvarchar(MAX)='',  
@mappedcol nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@issamebackground nvarchar(MAX)='',  
@celleditcolname nvarchar(MAX)='',  
@id nvarchar(MAX)=''  
AS  
BEGIN  
  
update obps_calculatedRowAttrib set LinkId=@linkid,ColName=@columnname,  
  MappedCol=@mappedcol,GridId=@gridid,IsBackground=@issamebackground,  
  CellEditColName=@celleditcolname where id=@id  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_UpdateExcelImportTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_admin_UpdateExcelImportTable]
@LinkId nvarchar(MAX)='',
@TableName nvarchar(MAX)='',
@TempTableName nvarchar(MAX)='',
@InsertSp nvarchar(MAX)='',
@id int
AS
BEGIN
	update obps_ExcelImportConfig set LinkId=@LinkId,TableName=@TableName,TempTableName=@TempTableName,InsertSp=@InsertSp where id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_UpdateRowAttribSettings]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_UpdateRowAttribSettings]
@linkid nvarchar(MAX)='',
@tablename nvarchar(MAX)='',
@columnname nvarchar(MAX)='',
@mappedcol nvarchar(MAX)='',
@gridid nvarchar(MAX)='',
@issamebackground nvarchar(MAX)='',
@celleditcolname nvarchar(MAX)='',
@id nvarchar(MAX)=''
AS
BEGIN

DECLARE @tabid nvarchar(MAX)=''
SET @tabid=(select TableId from obps_TableId where TableName=@tablename)

update obps_RowAttrib set LinkId=@linkid,TableID=@tabid,ColName=@columnname,
		MappedCol=@mappedcol,GridId=@gridid,IsBackground=@issamebackground,
		CellEditColName=@celleditcolname where id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_updateuserlink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_updateuserlink]
@linkid nvarchar(MAX)='',
@MenuId nvarchar(MAX)=''
AS
BEGIN
DECLARE @sublinkname nvarchar(MAX)='',@mainmenuname nvarchar(MAX)=''
SET @mainmenuname=(select DisplayName from obps_MenuName where MenuId=@MenuId)

update obps_UserLinks set linkname=@mainmenuname,LinkId=@MenuId where sublinkId=@linkid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AdminGetColNameFromTabName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_AdminGetColNameFromTabName]
@tabname nvarchar(MAX)=''
AS
BEGIN

SELECT name FROM sys.columns WHERE object_id = OBJECT_ID(@tabname) 
and name not in('id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate'
,'Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser') order by name asc

END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_adminGetlinkdetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_adminGetlinkdetails]    
AS    
BEGIN    
    
select LinkName,PageType,M.DisplayName 'menuname',SortOrder,    
case when IsAfterLogin=0 then 'false' else 'true' end IsAfterLogin,    
case when IsImportEnabled=0 then 'false' else 'true' end IsImportEnabled,    
case when IsMobile=0 then 'false' else 'true' end IsMobile,    
case when EnableUniversalSearch=0 then 'false' else 'true' end EnableUniversalSearch,    
case when IsLocation=0 then 'false' else 'true' end IsLocation,    
case when IsSamePage=0 then 'false' else 'true' end IsSamePage,    
case when ConditionalCRUDBtn=0 then 'false' else 'true' end ConditionalCRUDBtn,    
case when IsExportToCsv=0 then 'false' else 'true' end IsExportToCsv,    
CSVSeperator     
from obps_toplinks T inner join obps_MenuName M on T.MenuId=M.MenuId    
inner join obps_PageType P on P.PageTypeId=T.Type    
    
END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_AfterLoginSP]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_AfterLoginSP]
@usrname NVARCHAR(MAX)=''
AS
BEGIN
DECLARE @AfterLoginSP nvarchar(MAX)=''
SET @AfterLoginSP=(select AfterLoginSP from obps_Users where UserName=@usrname)
if(LEN(RTRIM(LTRIM(@AfterLoginSP)))>1)
exec @AfterLoginSP
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ccpi_getClient_old]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ccpi_getClient_old]  
@usrname NVARCHAR(MAX)=''  
AS  
BEGIN  
 DECLARE @SearchLetter nvarchar(100)  
 SET @SearchLetter ='%'+ @usrname + '%'  
 select ID,clientname as name from obp_ccpi_ClientMaster where AccessToUser like  @SearchLetter  
 order by ClientName  
 --select ID,clientname as name from obp_ClientMaster  
END  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_changePassword]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obps_sp_changePassword]  
@Username NVARCHAR(MAX)=NULL,  
@currentpassword NVARCHAR(MAX)=NULL,  
@newpassword NVARCHAR(MAX)=NULL  
AS  
BEGIN  
  if(Exists( select Id from obps_Users  
   where UserName=@Username and Password=@currentpassword))  
   BEGIN  
  
   update obps_Users  
   SET Password=@newpassword ,
   IsResetPassword=0
   where UserName=@Username  
  
   select 1 as IsPasswordChanged  
  
   END  
   ELSE  
   BEGIN  
   select 0 as IsPasswordChanged  
  END  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkColNameExistance]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[obps_sp_checkColNameExistance]
@tablename nvarchar(MAX)='',
@colname nvarchar(MAX)=''
AS
BEGIN

IF EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = @colname
          AND Object_ID = Object_ID(@tablename))
BEGIN
	SELECT '1'
END
ELSE
	SELECT '0'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CheckIsIdForDDL]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_CheckIsIdForDDL]
@linkid nvarchar(5)='',
@gid nvarchar(2)='',
@colname nvarchar(MAX)=''
AS
BEGIN

DECLARE @isid nvarchar(2)='',@colid nvarchar(max)

SET @colid=(select id from obps_ColAttrib where LinkId=@linkid and ColName=
			substring(@colname,0,CHARINDEX('_',@colname,0)) and ColControlType='dropdownlist')

SET @isid=(select isid from obps_DropDownTable where ColumnId=@colid)

select @isid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkLinkName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_checkLinkName]
@LinkName nvarchar(MAX),
@MenuId nvarchar(MAX),
@id nvarchar(MAX)=''
AS
BEGIN
DECLARE @mid int=0;
set @mid=(select id from obps_MenuName where DisplayName=@MenuId)
if @id<>''
BEGIN

	IF ((SELECT count(*) from obps_TopLinks where LinkName=@LinkName and MenuId=@mid and id<>@id)>0)
	BEGIN
		select 0--- exist in the db
	END
	ELSE
	BEGIN
		select 1--- not exist in the db
	END
END
ELSE
BEGIN
	IF ((SELECT count(*) from obps_TopLinks where LinkName=@LinkName and MenuId=@mid)>0)
	BEGIN
		select 0---user type exist in the db
	END
	ELSE
	BEGIN
		select 1---user type not exist in the db
	END
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkMenuName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_checkMenuName]
@dispname nvarchar(MAX),
@id nvarchar(MAX)=''
AS
BEGIN
	if @id<>''
	BEGIN
		IF ((SELECT count(*) from obps_MenuName where DisplayName=@dispname and id<>@id)>0)
		BEGIN
			select 0---user type exist in the db
		END
		ELSE
		BEGIN
			select 1---user type not exist in the db
		END
	END
	ELSE
	BEGIN
	IF ((SELECT count(*) from obps_MenuName where DisplayName=@dispname)>0)
	BEGIN
		select 0---user type exist in the db
	END
	ELSE
	BEGIN
		select 1---user type not exist in the db
	END	
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CheckResetPassword]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_CheckResetPassword]  
@usrname nvarchar(100)  
AS  
BEGIN  
 select IsResetPassword from obps_Users   
 where UserName=@usrname  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkRoleId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_checkRoleId]
@RoleId nvarchar(MAX)
AS
BEGIN
IF ((SELECT count(*) from obps_RoleMaster where RoleId=@RoleId)>0)
BEGIN
    select 0---role exist in the db
END
ELSE
BEGIN
	select 1---role not exist in the db
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CheckSPExistance]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_CheckSPExistance]  
@Linkd nvarchar(MAX)='',  
@Gridid nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @spquery nvarchar(Max)='',@spname nvarchar(MAX)=''  

set @spname=( select GridSp from obps_TopLinkExtended where linkid=@Linkd and GridId=@Gridid)
  
if(len(@spname)<=0)  
BEGIN  
  SELECT 0  
END  
ELSE  
BEGIN  
  SELECT 1  
END  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checksubmenuDashboard]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_checksubmenuDashboard]
@linkid nvarchar(3)='',
@id nvarchar(3)=''
AS
BEGIN

 IF ((SELECT count(*) from obps_Dashboards where LinkId=@linkid and id<>@id)>0)  
 BEGIN  
  select 0--- exist in the db  
 END  
 ELSE  
 BEGIN  
  select 1--- not exist in the db  
 END  

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkTableExistance]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_checkTableExistance]      
@tablename NVARCHAR(MAX)=''      
AS      
BEGIN      
DECLARE @id int=''  
DECLARE @out int=0 ,@str1 nvarchar(MAX)='' 
DECLARE @count int=0,@sp nvarchar(MAX)='' 

DECLARE @gridcount int=0;
SET @gridcount=(SELECT count(*) from obps_TopLinkExtended where Linkid=@id)

while @gridcount>=0
BEGIN

set @sp=(select gridsp from obps_TopLinkExtended where Linkid=@id and GridId=@gridcount)

set @str1=('SELECT @out=count(Name)  
    FROM sys.procedures  
    WHERE OBJECT_DEFINITION(OBJECT_ID) LIKE ''%'+@tablename+'%''   
    and name in('''+@sp+''')')  
    EXEC Sp_executesql  @str1,  N'@out NVARCHAR(MAX) output',  @out output  

SET @count=@count+@out 
SET @gridcount=@gridcount-1

END

if @count>0  
begin  
 select '1' as 'result'  
end  
else  
begin  
 select '0' as 'result'  
end  

END     
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkTableName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_checkTableName]    
@tablename NVARCHAR(MAX)=''    
AS    
BEGIN    
SET @tablename='obp_'+@tablename
truncate table obps_CreateTableTemp 
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE --TABLE_SCHEMA = 'TheSchema' 
                 --AND 
TABLE_NAME = @tablename))
BEGIN
    select 0---table name exist in the db
END
ELSE
BEGIN
select 1---table name not exist in the db
END

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CheckUserLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_CheckUserLink]  
@id nvarchar(MAX)='',  
@linkid nvarchar(MAX)='',  
@sublinkid nvarchar(MAX)='',  
@userid nvarchar(MAX)=''  
AS  
BEGIN  
if @id<>''  
BEGIN  
 IF ((SELECT count(*) from obps_UserLinks where LinkId=@linkid and sublinkid=@sublinkid and UserName=@userid  
 and IsDeleted=0 and id<>@id)>0)  
 BEGIN  
  select 0---user type exist in the db  
 END  
 ELSE  
 BEGIN  
  select 1---user type not exist in the db  
 END          
END  
ELSE  
BEGIN  
 IF ((SELECT count(*) from obps_UserLinks where LinkId=@linkid and sublinkid=@sublinkid   
 and IsDeleted=0 and UserId=@userid)>0)  
 BEGIN  
  select 0---user type exist in the db  
 END  
 ELSE  
 BEGIN  
  select 1---user type not exist in the db  
 END   
END  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkUserType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_checkUserType]
@UserType nvarchar(MAX),
@id nvarchar(MAX)=''
AS
BEGIN
if @id<>''
BEGIN
	IF ((SELECT count(*) from obps_UserType where UserType=@UserType and id<>@id)>0)
	BEGIN
		select 0---user type exist in the db
	END
	ELSE
	BEGIN
		select 1---user type not exist in the db
	END								
END
ELSE
BEGIN
	IF ((SELECT count(*) from obps_UserType where UserType=@UserType)>0)
	BEGIN
		select 0---user type exist in the db
	END
	ELSE
	BEGIN
		select 1---user type not exist in the db
	END	
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkValidation]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[obps_sp_checkValidation]
@gid nvarchar(5)=''
,@linkid nvarchar(5)=''
,@usrname nvarchar(200)=''
,@colname nvarchar(200)=''
,@colvalue nvarchar(200)=''
AS
BEGIN
DECLARE @validationsp nvarchar(50)
if(@linkid=201 and @gid=2)
BEGIN
	if(LOWER(@colname)='fromdate__obp_gms_deactivationpolicy' )
	begin
		if(CONVERT(DATETIME, SUBSTRING(@colvalue, 5, 20), 9)<GETDATE())
			select '0','From date should be greater than today'
	end	
	else if(LOWER(@colname)='todate__obp_gms_deactivationpolicy' )
	begin
		if(CONVERT(DATETIME, SUBSTRING(@colvalue, 5, 20), 9)<GETDATE())
			select '0','To date should be greater than today'
	end	
	else
		select '1'
		
END
else
begin

 set @validationsp=(select ValidationSp from obps_TopLinkExtended where Linkid=@linkid)
 if(len(@validationsp)>0)
	exec @validationsp @gid,@colname,@colvalue,@usrname
end
END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ColAttribMapping]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[obps_sp_CopyUserPermission]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_CopyUserPermission]
@fromuserid int='',
@touserid int='',
@linkid int=''
AS
BEGIN
BEGIN TRY
	DECLARE @count int=0
	SET @count=(select count(*) from obps_SpPermissions where Linkid=@linkid and UserId=@touserid)

	if(@count>0)
		delete from obps_SpPermissions where Linkid=@linkid and UserId=@touserid

	insert into obps_SpPermissions(UserId,Linkid,Gridid,Par1,Par2,Par3,Par4,Par5)
	select @touserid,Linkid,Gridid,Par1,Par2,Par3,Par4,Par5 
	from obps_SpPermissions where UserId=@fromuserid and linkid=@linkid

END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CountHelpFileName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[obps_sp_CountHelpFileName]    
@UserName nvarchar(MAX)=''
AS    
BEGIN   

select count(Filename) from obps_helpdoc where  isactive=1

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CountImportRecord]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_CountImportRecord]               
/******Finding the count of success/error out data**********/  
@linkid nvarchar(MAX)='',       
@Username nvarchar(max)       
AS                
BEGIN     
DECLARE @spname nvarchar(MAX)=''  
DECLARE @error_rowcount int, @success_rowcount int,@count int=0  
  
SET @spname=(SELECT ImportErrorOutSp FROM obps_TopLinks where id=@linkid)    
EXEC @spname  @usrname=@Username   
SET @error_rowcount = @@rowcount  
  
SET @spname=(SELECT ImportSavedOutSp FROM obps_TopLinks where id=@linkid)    
EXEC @spname  @usrname=@Username  
SET @success_rowcount = @@rowcount  
  
SET @count=@error_rowcount+@success_rowcount  
if(@count>0)  
 select @count  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CreateClass]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_CreateClass]
@LinkId VARCHAR(MAX)=1,
@Gridid NVARCHAR(MAX)=1
AS
BEGIN
		DECLARE @GridClassnameColumn NVARCHAR(MAX),
				@Query1 NVARCHAR(MAX),
				@Classname NVARCHAR(MAX),
				@RoleId int,
				@GridSpName NVARCHAR(MAX),
				@GridSpNameQuery NVARCHAR(MAX),
				@GridSp NVARCHAR(MAX),
				@tableid NVARCHAR(MAX)

		
		SET @RoleId= (select DISTINCT RoleId from Obp_UserLinks where LinkId=@LinkId)

		--getting the sp for data to be displayed in datagrid
		SET @GridSpName='Grid'+@Gridid+'Sp'
		SET @GridSpNameQuery='select DISTINCT @GridSp='+@GridSpName+' from Obp_LFLinks where LinkId='+@LinkId
		EXEC Sp_executesql  @GridSpNameQuery,  N'@GridSp NVARCHAR(MAX) output',  @GridSp output 

		--get the class name
		SET @GridClassnameColumn='Grid'+@Gridid+'ClassName' --get the coloumn name for the table Obp_LinkClassName as : Grid1ClassName
		SET @Query1='SELECT @Classname='+@GridClassnameColumn+' FROM Obp_LinkClassName where LinkId='+@LinkId 
		EXEC Sp_executesql  @Query1,  N'@Classname NVARCHAR(MAX) output',  @Classname output --get the classname as class1

		DECLARE @Data_Type nvarchar(150),
				@Column_Name nvarchar(150)

		print 
	   'using System;
		using System.Collections.Generic;
		using System.Linq;
		using System.Web;

		namespace Onebeat_PL.Models
		{
			public class '+@Classname+'
			{'
		DECLARE cur CURSOR FOR
		select 

		case 
			when Data_Type like 'nvarchar%' then
			'string'
			when Data_Type like '%datetime%' or  Data_Type like '%date%' then
			'DateTime'
			when Data_Type like 'bit%' then
			'int'
			else
			Data_Type
			end ,Column_Name
		--into #inpclass
		FROM INFORMATION_SCHEMA.COLUMNS
		inner join Obp_RoleMap RM on Column_Name=RM.ColName
		 and table_name=RM.TableName
		WHERE  RM.IsVisible=1 and TableId in 
		(SELECT TableId FROM Obp_TableId where TABLENAME in 
		(SELECT DISTINCT t.name 
		FROM sys.sql_dependencies d 
		INNER JOIN sys.procedures p ON p.object_id = d.object_id
		INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
		where p.name=@GridSp)) and RoleId=@RoleId
		order by ColName
		OPEN cur

		FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
		WHILE @@FETCH_STATUS = 0
		BEGIN   

		PRINT 'public '+@Data_Type+ ' '+@Column_Name+' { get; set;}'
		FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
		END

		CLOSE cur;
		DEALLOCATE cur;
		print 
		'}
		 }'
END


GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CreateTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_CreateTable]  
@tabname nvarchar(MAX)=''  
AS  
BEGIN  
 DECLARE @id int='',@UserCol int  
 DECLARE @str nvarchar(MAX)='',@createStr nvarchar(MAX)  
 DECLARE @TableIdStr nvarchar(MAX)  
 DECLARE @TabId nvarchar(MAX)  
 DECLARE  @col nvarchar(MAX),@dat nvarchar(MAX),@allownull nvarchar(MAX),@default nvarchar(MAX)  
 DECLARE @i int=2;  
 DECLARE @count int=0;  
  
 ---------------------------------------insert to tableid table-------------------------------------  
 SET @TabId=(select max(tableid) from  obps_TableId)  
 SET @TabId= case when @TabId IS NULL then 300 else @TabId+1 end  
 select @TabId  
 set @count=(SELECT count(*) from obps_TableId where TableName=@tabname)  
 if @count=0  
 begin  
 SET @TableIdStr='insert into obps_TableId(TableName,TableId,TableKey) values('''+@tabname+''','+@TabId+',''id'')'  
 exec (@TableIdStr)  
 select @TableIdStr    
 end  
  
 DECLARE CUR_TEST CURSOR FAST_FORWARD FOR  
 select ColumnName,DataType,AllowNulls,DefaultValue,UserColumn from [dbo].[obps_CreateTableTemp] ;  
 OPEN CUR_TEST  
 FETCH NEXT FROM CUR_TEST INTO @col,@dat,@allownull,@default,@UserCol  
   WHILE @@FETCH_STATUS = 0  
   BEGIN  
    if @UserCol=1  
    begin  
     select 'inside'  
     update obps_TableId set TableUserCol=@col where TableName=@tabname  
    end  
  
    IF Lower(@dat)='nvarchar'  
    BEGIN  
     set @dat='nvarchar(MAX)'  
     if @default<>''  
     BEGIN  
      set @default=''''+@default+''''  
     END  
    END  
    select @default  
    IF Lower(@dat)='datetime' and @default<>''  
    BEGIN  
     set @default=''''+@default+''''  
    END  
      
    if @default=''  
    BEGIN  
     SET @default=''  
    END  
    ELSE  
    BEGIN  
     SET @default=' DEFAULT '+@default  
    END  
    IF @str=''  
    BEGIN  
     SET @str='['+@col+'] '+@dat+' '+@allownull +@default  
    END  
    ELSE  
    BEGIN  
     SET @str= @str+',['+@col+'] '+@dat+' '+@allownull +@default  
    END  
    
  
    SET @i=@i+1  
    --select  @col,@dat,@allownull,@default   
    FETCH NEXT FROM CUR_TEST INTO @col,@dat,@allownull,@default,@UserCol  
   END  
     
 --END  
 set @str=@str+','  
 CLOSE CUR_TEST  
 DEALLOCATE CUR_TEST  
  
 ---select @str  
  
  
 IF @str<>''  
 BEGIN  
  SET @createStr='CREATE TABLE [dbo].['+@tabname+  
      ']([id] [int] IDENTITY(100,1) NOT NULL,'+  
      @str+  
      '[CreatedDate] [datetime] NULL DEFAULT (getdate()),  
      [ModifiedDate] [datetime] NULL,  
      [Createdby] [nvarchar](100) NULL,  
      [Modifiedby] [nvarchar](100) NULL)'  
      --ALTER TABLE [dbo].['+@tabname+'] ADD  DEFAULT (getdate()) FOR [CreatedDate]  
      --ALTER TABLE [dbo].['+@tabname+'] ADD  DEFAULT ((1)) FOR [isActive]  
      --ALTER TABLE [dbo].['+@tabname+'] ADD  DEFAULT ((0)) FOR [isDeleted]  
  delete from obps_CreateTableTemp  
  select @createStr  
  exec (@createStr)  
    
    
 END  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CreateTableTemp]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_CreateTableTemp]
@ColumnName nvarchar(MAX),
@DataType nvarchar(MAX),
@AllowNulls nvarchar(MAX),
@Defaults nvarchar(MAX),
@UserCol nvarchar(MAX)
AS
BEGIN
	INSERT INTO obps_CreateTableTemp values(@ColumnName,@DataType,@AllowNulls,@Defaults,@UserCol)
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_datavaliditycheck]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obps_sp_datavaliditycheck]        
as        
begin        
        
declare @var_id int        
declare @var_string nvarchar(max),@var_string_cnt int        
declare @var_num nvarchar(max),@var_num_cnt int        
declare @var_date nvarchar(max),@var_date_cnt int        
declare @var_col nvarchar(max)        
declare @var_qry nvarchar(max)      
declare @var_maxbatchid nvarchar(10)        
        
if OBJECT_ID('tempdb.dbo.#tb_coldata') is not null        
drop table tempdb.dbo.#tb_coldata        
        
if OBJECT_ID('tempdb.dbo.#tb_invrec') is not null        
drop table tempdb.dbo.#tb_invrec        
        
create table #tb_coldata        
(        
id int identity(1,1)        
,dbname nvarchar(max)        
,tablename nvarchar(max)        
,colname nvarchar(max)        
,datatype nvarchar(max)        
,ind01 int default 0        
)        
        
create table #tb_invrec        
(        
rid int        
,val int        
,colname nvarchar(max)        
)        
        
      
/*Num Col Section*/        
        
set @var_id=0        
set @var_num_cnt=0        
set @var_maxbatchid=(select convert(nvarchar(10),max(batchid)) from obp_DemandOrders_temp)        
      
set @var_num_cnt=(select count(*) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='obp_DemandOrders'        
and column_name not in ('Id','Size','Quantity','OrderId','AvgSaleMth','SkuCode','OrderModifiedDate','ModifiedBy','ModifiedQuantity','UserID','CreatedBy','CreatedDate','Modifieddate','color1','color2','color3','color4','color5','isDeleted','AccessToUser','isActive')        
and DATA_TYPE in ('int','float'))        
        
if @var_num_cnt>0        
begin        
        
truncate table #tb_coldata        
        
insert into #tb_coldata        
select TABLE_CATALOG,TABLE_NAME,COLUMN_NAME,DATA_TYPE,0 from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='obp_DemandOrders'        
and column_name not in ('Id','Size','Quantity','OrderId','AvgSaleMth','SkuCode','OrderModifiedDate','ModifiedBy','ModifiedQuantity','UserID','CreatedBy','CreatedDate','Modifieddate','color1','color2','color3','color4','color5','isDeleted','AccessToUser','isActive')        
and DATA_TYPE in ('int','float')        
order by DATA_TYPE        
        
set @var_num=''        
        
while @var_num_cnt<>0        
begin        
if object_id('dbo.tb_01val') is not null        
drop table tb_01val;        
        
set @var_id=(select top 1 id from #tb_coldata where ind01=0)        
set @var_num='isnumeric('+(select top 1 colname from #tb_coldata where id=@var_id and ind01=0)+')'        
set @var_col=(select top 1 colname from #tb_coldata where id=@var_id and ind01=0)        
        
set @var_qry='Select id,'+@var_num+' as val into tb_01val from obp_DemandOrders_temp where batchid = '  +@var_maxbatchid      
        
exec (@var_qry);        
        
insert into #tb_invrec        
select id,val,@var_col from tb_01val where val=0;        
        
update obp_DemandOrders_temp set isvalid=0,reason=isnull(reason,'')+','+@var_col where id in (select rid from #tb_invrec where colname=@var_col) and BatchId=cast(@var_maxbatchid as int)        
        
set @var_num_cnt=@var_num_cnt-1        
update #tb_coldata set ind01=1 where id=@var_id        
end        
/*Num Col Done*/        
        
end        
        
/*Date Col Section*/        
       
  
set @var_id=0        
set @var_date_cnt=0        
        
set @var_date_cnt=(select count(*) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='obp_DemandOrders'        
and column_name not in ('Id','Size','Quantity','RequiredDate','OrderCreateDt','OrderId','AvgSaleMth','SkuCode','OrderModifiedDate','ModifiedBy','ModifiedQuantity','UserID','CreatedBy','CreatedDate','Modifieddate','color1','color2','color3','color4','color5','isDeleted','Ac
cessToUser','isActive')        
and DATA_TYPE in ('datetime','date'))        
        
if @var_date_cnt>0        
begin        
        
truncate table #tb_coldata        
        
insert into #tb_coldata        
select TABLE_CATALOG,TABLE_NAME,COLUMN_NAME,DATA_TYPE,0 from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='obp_DemandOrders'        
and column_name not in ('Id','Size','Quantity','RequiredDate','OrderCreateDt','OrderId','AvgSaleMth','SkuCode','OrderModifiedDate','ModifiedBy','ModifiedQuantity','UserID','CreatedBy','CreatedDate','Modifieddate','color1','color2','color3','color4','color5','isDeleted','Ac
cessToUser','isActive')        
and DATA_TYPE in ('datetime','date')        
order by DATA_TYPE        
        
set @var_date=''        
        
while @var_date_cnt<>0        
begin        
if object_id('dbo.tb_01val') is not null        
drop table tb_01val;        
        
set @var_id=(select top 1 id from #tb_coldata where ind01=0)        
set @var_date='isdate('+(select top 1 colname from #tb_coldata where id=@var_id and ind01=0)+')'        
set @var_col=(select top 1 colname from #tb_coldata where id=@var_id and ind01=0)        
        
set @var_qry='Select id,'+@var_date+' as val into tb_01val from obp_DemandOrders_temp where batchid = '  +@var_maxbatchid      
        
exec (@var_qry);        
        
insert into #tb_invrec        
select id,val,@var_col from tb_01val where val=0;        
        
update obp_DemandOrders_temp set isvalid=0,reason=isnull(reason,'')+','+@var_col where id in (select rid from #tb_invrec where colname=@var_col)   and BatchId = cast(@var_maxbatchid as int)      
        
set @var_date_cnt=@var_date_cnt-1        
update #tb_coldata set ind01=1 where id=@var_id        
end        
/*Date Col Done*/        
        
end        
        
        
update obp_DemandOrders_temp set reason=substring(Reason,2,len(Reason)) where SUBSTRING(Reason,1,1)=','  and batchid=cast(@var_maxbatchid as int)      
        
end 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DDLInGrid]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteCalcolAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[obps_sp_DeleteCalcolAttrib]
@id int=''
AS
BEGIN

delete from obps_CalculatedColAttrib where id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_deletecolname]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_deletecolname]
@colname nvarchar(MAX)='',
@tablename nvarchar(MAX)=''
AS
BEGIN
DECLARE @str nvarchar(MAX)=''
BEGIN TRY

	SET @str='ALTER TABLE '+@tablename+' DROP COLUMN '+@colname 
	exec (@str)

END TRY
BEGIN CATCH
	select ERROR_MESSAGE()
END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteDashboardConfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_DeleteDashboardConfig]    
@id nvarchar(MAX)=''    
AS    
BEGIN    
 delete from obps_Dashboards where id=@id    
END    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteFile]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DeleteFile]
@Id nvarchar(MAX)='',
@LinkId nvarchar(MAX)=''
AS 
BEGIN
	DECLARE @Count int=0
	SET @Count=(SELECT count(*) from obps_FileUpload where id=@Id)
	if @Count>0
	BEGIN
		DELETE from obps_FileUpload where id=@Id
		SELECT'1'
	END
	ELSE
		SELECT '0'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteGanttDependency]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_DeleteGanttDependency]
@LinkId int,
@usr nvarchar(MAX)='',
@key  nvarchar(10)=''
AS
BEGIN

DECLARE @succid nvarchar(MAX)='',@predeid nvarchar(MAX)=''
,@tabname nvarchar(MAX)='',@string1 nvarchar(MAX)=''
,@string2 nvarchar(MAX)=''

SET @succid=(SELECT successoridColName from obps_GanttConfig where linkid=@LinkId)
SET @predeid=(SELECT PredecessorIdColName from obps_GanttConfig where linkid=@LinkId)
SET @tabname=(SELECT Tablename from obps_GanttConfig where linkid=@LinkId)

SET @string1='update '+@tabname+' set '+@predeid+'=NULL where '+@predeid+'='+@key
SET @string2='update '+@tabname+' set '+@succid+'=NULL where '+@succid+'='+@key
exec (@string1)
exec (@string2)

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteGridDataDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DeleteGridDataDetails]  
   @gid NVARCHAR(MAX)=NULL,  
   @key nvarchar(50)=NULL,  
   @Id NVARCHAR(MAX)=NULL,  
   @usr nvarchar(MAX)=''  
AS  
BEGIN  
  
   DECLARE  @delsp NVARCHAR(MAX)
  
    SET NOCOUNT ON;  
	set @delsp=(SELECT deletesp from obps_TopLinkExtended where Linkid=@id and GridId=@gid)

  
 IF len(rtrim(ltrim(@delsp)))>1  
 BEGIN  
 EXEC @delsp @key,@usr	-------table id and username
 END  
   
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteHelpDoc]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_DeleteHelpDoc]
@id int=''
AS
BEGIN

delete from obps_HelpDoc where id=@id

END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_deleteImportconfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_deleteImportconfig]  
@id int='',  
@topid nvarchar(MAX)=''  
AS  
BEGIN  
select len(@topid)
if(len(@id)>0)  
DELETE from obps_ExcelImportConfig where id=@id   
if(len(@topid)>0)  
begin
select '1'
update obps_TopLinks set importerroroutsp='',importsavedoutsp='', IsImportEnabled=0
  where id=@topid  
  end
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_deleteMenuName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_deleteMenuName]
@id nvarchar(MAX)
AS
BEGIN
	declare @count int=0;
	set @count=(select count(*) from obps_MenuName where id=@id and @id in(select MenuId from obps_TopLinks))
	if(@count=0)
	BEGIN
		delete from obps_MenuName where id=@id
		select '1'
	END
	ELSE
	BEGIN
		select '0'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DeleteTable]
@id nvarchar(MAX)
AS
BEGIN
	DECLARE @tabname nvarchar(MAX)='',@str nvarchar(MAX)=''
	SET @tabname=(select tablename from obps_TableId where TableId=@id)

	delete from obps_TableId where TableId=@id
	delete from obps_ColAttrib where TableID=@id
	delete from obps_RoleMap where TableID=@id
	SET @str='DROP table '+@tabname
	exec (@str)
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_deletetempLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_deletetempLink]
@Topid int='',
@TopExtndid int=''
AS
BEGIN

delete from obps_TopLinks_temp where id=@Topid
delete from obps_TopLinkextended_temp where id=@TopExtndid


END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteUser]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_DeleteUser]
@id nvarchar(MAX)
AS
BEGIN
	delete from obps_Users where id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteUserPermission]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_DeleteUserPermission]
@id int=0
AS
BEGIN
BEGIN TRY

	delete from obps_SpPermissions where id=@id

END TRY
BEGIN CATCH
	select ERROR_MESSAGE()
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteUserRole]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DeleteUserRole]
@id nvarchar(MAX)
AS
BEGIN
	declare @count int=0;
	set @count=(select count(*) from obps_RoleMaster where RoleId=@id and @id in(select roleid from obps_Users))
	if(@count=0)
	BEGIN
		delete from obps_RoleMaster where RoleId=@id
		select '1'
	END
	ELSE
	BEGIN
		select '0'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteUsertemp]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_DeleteUsertemp]  
@id nvarchar(MAX)  
AS  
BEGIN  
 delete from obps_Users_temp where id=@id  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_DeleteUserType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_DeleteUserType]
@id nvarchar(MAX)
AS
BEGIN

	declare @count int=0;
	set @count=(select count(*) from obps_UserType where id=@id and UserTypeId in(select distinct UserTypeId from obps_Users))
	if(@count=0)
	BEGIN
		delete from obps_UserType where id=@id
		select '1'
	END
	ELSE
	BEGIN
		select '0'
	END

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_displayImportHelp]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_displayImportHelp]
@linkId nvarchar(MAX)=''
AS
BEGIN
DECLARE @spname nvarchar(MAX)
SET @spname=(select ImportHelp from obps_TopLinks where id=@linkId)
if @spname is not null or @spname<>''
exec @spname
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_EditMainMenu]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_EditMainMenu]
@id nvarchar(MAX)='',
@dispName nvarchar(MAX)='',
@visible nvarchar(MAX)=''
AS
BEGIN
	update obps_MenuName set DisplayName=@dispName,IsVisible=@visible where id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_EditUserRole]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_EditUserRole]
@id nvarchar(MAX),
@RoleId nvarchar(MAX)
--@GroupName nvarchar(MAX)
AS
BEGIN
	update obps_RoleMaster set RoleId=@RoleId where id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_EditUserType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_EditUserType]
@id nvarchar(MAX),
@UserType nvarchar(MAX),
@UserTypeDesc nvarchar(MAX)
AS
BEGIN
	update obps_UserType set UserType=@UserType,UserTypeDesc=@UserTypeDesc where id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GenDataValidityCheck_DataType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obps_sp_GenDataValidityCheck_DataType]    
(  
@linkid nvarchar(MAX)=''  
,@Username nvarchar(MAX)=''  
)  
as   
Begin  
  
declare @UserId nvarchar(MAX)='' 
set  @UserId= @Username
declare @var_id int                          
--declare @var_string nvarchar(max),@var_string_cnt int                          
--declare @var_num nvarchar(max),@var_num_cnt int                          
--declare @var_date nvarchar(max),@var_date_cnt int                          
--declare @var_col nvarchar(max)                                              
declare @var_qry varchar(8000)    
--declare @var_maxbatchid nvarchar(10)      
declare @var_TempTableName varchar(max)    
declare @var_MainTableName nvarchar(max)   
  
  
Set @var_MainTableName=(select TableName from obps_ExcelImportConfig where LinkId=@linkid)     
Set @var_TempTableName=(select TempTableName from obps_ExcelImportConfig where LinkId=@linkid)    
  
/*Code to test from test table*/  
--set @var_TempTableName='obp_VN_FabricBuffer_temp_01'  
  
DECLARE @NullFilterString varchar(max)  
DECLARE @ColNameForReason varchar(max)  
  
  
/*Create filter to check NULL value in Col*/  
SET @NullFilterString = NULL  
  
select @NullFilterString = COALESCE(@NullFilterString + ' or ','') +COLUMN_NAME+ ' is null' from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName  
and column_name in  
(select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_TempTableName  and column_name not in ('id','BatchNo','IsValid','BatchId','Reason','UserId'))  
and IS_NULLABLE='NO'  


  
  
set @var_qry=''  
/*set @var_qry='Update '+@var_TempTableName+' set isvalid=0,Reason='''+'NULL Values exists in Mandatory Columns'+''+' where Id in (Select Id from '+@var_MainTableName + 'where '+')' */  
set @var_qry=';With CTE_01 as (Select Id from '+@var_TempTableName+' where UserName='''+@UserId+ ''' and IsValid=1 and ( '+@NullFilterString+')) Update TB set TB.IsValid=0 ,TB.Reason=''NULL Values exists in Mandatory Columns'' from ' +@var_TempTableName +
' TB, CTE_01 RT where TB.id=RT.id'  

print '1'
print @var_qry
exec (@var_qry);    
  
  
/*End - Create Dynamic Qry for NULL*/  
  
  
/*Create filter to check Numeric value in Col*/  
SET @NullFilterString = NULL  
SET @ColNameForReason = NULL  
  
--select @NullFilterString = COALESCE(@NullFilterString + 'isnumeric(','') +COLUMN_NAME+ ')=0 or ' from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName  
select @NullFilterString = COALESCE(isnull(@NullFilterString,'isnull(') + 'isnumeric(isnull(','') +COLUMN_NAME+ ',1))=0 or ' from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName  
and column_name in  
(select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_TempTableName  and column_name not in ('id','BatchNo','IsValid','BatchId','Reason','UserId'))  
and DATA_TYPE in ('float','int')  

--set @NullFilterString=substring(@NullFilterString,17,len(@NullFilterString))

  
select @ColNameForReason = COALESCE(@ColNameForReason + ',','') +COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName  
and column_name in  
(select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_TempTableName  and column_name not in ('id','BatchNo','IsValid','BatchId','Reason','UserId'))  
and DATA_TYPE in ('float','int')  
  
  
If len(@NullFilterString)>2  
Begin  
/*
set @NullFilterString=SUBSTRING(@NullFilterString,1,len(@NullFilterString)-3)  
 set @NullFilterString='isnumeric('+@NullFilterString  */
print @NullFilterString
set @NullFilterString=SUBSTRING(@NullFilterString,17,len(@NullFilterString)-6)  
set @NullFilterString=SUBSTRING(@NullFilterString,1,len(@NullFilterString)-3)  
set @NullFilterString='isnumeric'+@NullFilterString 
print '2.1'
print @NullFilterString  
End  
  
set @var_qry=''  
/*set @var_qry='Update '+@var_TempTableName+' set isvalid=0,Reason='''+'NULL Values exists in Mandatory Columns'+''+' where Id in (Select Id from '+@var_MainTableName + 'where '+')' */  
set @var_qry=';With CTE_01 as (Select Id from '+@var_TempTableName+' where UserName='''+@UserId+ ''' and IsValid=1 and ( '+@NullFilterString+')) Update TB set TB.IsValid=0 ,TB.Reason=''Invalid Numeric Value in ('+@ColNameForReason+')'' from ' +@var_TempTableName +' TB, CTE_01 RT where TB.id=RT.id'  

print '2'
print @var_qry
exec (@var_qry);   
  
--print @var_qry  
  
  
/*End - Create filter to check Numeric value in Col*/  


/*To Update Date in Date Columns. Added on 26-03-2022*/  
If OBJECT_ID('tempdb..#tb_DateCol') is not null drop table #tb_DateCol

Select ROW_NUMBER() over(order by column_name ) 'SNO',column_name 
into #tb_DateCol
from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName 
and column_name in  
(select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_TempTableName  and column_name not in ('id','BatchNo','IsValid','BatchId','Reason','UserId'))  
and 
DATA_TYPE in ('date','datetime')  

--Select * from #tb_DateCol

declare @var_RecCount int,@var_Rec int,@var_ColName nvarchar(max)

set @var_RecCount=(Select count(*) from #tb_DateCol)
set @var_Rec=1
--print @var_Rec
--print @var_RecCount
--print  '---'
while @var_Rec <= @var_RecCount
begin
set @var_ColName=(Select column_name from #tb_DateCol where sno=@var_Rec)

/*
set @var_qry=''
set @var_qry='update '  +@var_TempTableName+ ' set '+@var_ColName+ ' =SUBSTRING('+@var_ColName+',7,4)+'''+'-''+SUBSTRING('+@var_ColName+',4,2)+'''+'-''+SUBSTRING('+@var_ColName+',1,2) where isvalid=1 and len(ltrim(rtrim('+@var_ColName+'))) >=10 and Username='''+@UserId+''''
*/
set @var_qry=''
set @var_qry='update '  +@var_TempTableName+ ' set '+@var_ColName+ ' =SUBSTRING('+@var_ColName+',1,10) where isvalid=1 and len(ltrim(rtrim('+@var_ColName+'))) >=10 and Username='''+@UserId+''''


print @var_qry
exec (@var_qry);

set @var_Rec=@var_Rec+1
end

/*End - Update Date in Columns*/

  
/*Create filter to check Date value in Col*/  
SET @NullFilterString = NULL  
SET @ColNameForReason = NULL  
  
/*  
--select @NullFilterString = COALESCE(@NullFilterString + 'isnumeric(','') +COLUMN_NAME+ ')=0 or ' from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName  
select @NullFilterString = COALESCE(@NullFilterString + 'isdate(','') +COLUMN_NAME+ ')=0 or ' from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName  
and column_name in  
(select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_TempTableName  and column_name not in ('id','BatchNo','IsValid','BatchId','Reason','UserId'))  
and DATA_TYPE in ('date','datetime')  
*/

select @NullFilterString = COALESCE(@NullFilterString + 'ISDATE( CONVERT(CHAR(10), CONVERT(date,(isnull(','') +COLUMN_NAME+ ',''01-01-1900'+''')), 103)))=0 or ' from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName  
and column_name in  
(select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_TempTableName  and column_name not in ('id','BatchNo','IsValid','BatchId','Reason','UserId'))  
and DATA_TYPE in ('date','datetime')  


print @NullFilterString

select @ColNameForReason = COALESCE(@ColNameForReason + ',','') +COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_MainTableName  
and column_name in  
--(select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_TempTableName  and column_name not in ('id','BatchNo','IsValid','BatchId','Reason','UserId'))  
(select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME= @var_TempTableName  )  
and DATA_TYPE in ('date','datetime')  
  
  
  
If len(@NullFilterString)>2  
Begin  
--set @NullFilterString=SUBSTRING(@NullFilterString,1,len(@NullFilterString)-3) 
set @NullFilterString=SUBSTRING(@NullFilterString,1,len(@NullFilterString)-3) 
print @NullFilterString 
--set @NullFilterString='isdate('+@NullFilterString  
/*set @NullFilterString='ISDATE( CONVERT(CHAR(10), CONVERT(date,'+@NullFilterString  */
set @NullFilterString='ISDATE( CONVERT(CHAR(10), CONVERT(date,(isnull('+@NullFilterString  
End  

print @NullFilterString
  
set @var_qry=''  
/*set @var_qry='Update '+@var_TempTableName+' set isvalid=0,Reason='''+'NULL Values exists in Mandatory Columns'+''+' where Id in (Select Id from '+@var_MainTableName + 'where '+')' */  
set @var_qry=';With CTE_01 as (Select Id from '+@var_TempTableName+' where UserName='''+@UserId+ ''' and IsValid=1 and ( '+@NullFilterString+')) Update TB set TB.IsValid=0 ,TB.Reason=''Invalid Date in ('+@ColNameForReason+')'' from ' +@var_TempTableName +
' TB, CTE_01 RT where TB.id=RT.id'  

print '3'
print @var_qry
exec (@var_qry);   
  
  
/*End - Create filter to check Date value in Col*/  
  


  
End  
  

  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GenerateFile]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GenerateFile]
@Id nvarchar(MAX)='',
@usr nvarchar(MAX)=''
AS
BEGIN

DECLARE @spname nvarchar(MAX)=''
SET @spname=(select GenFileSp from obps_ExcelImportConfig where LinkId=@Id)

if @spname<>'' or @spname is not null
	exec @spname @Id,@usr

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GenerateFileName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GenerateFileName]
@id nvarchar(MAX)='',
@LinkId nvarchar(MAX)=''
AS
BEGIN

DECLARE @count nvarchar(MAX)=''
DECLARE @clientname nvarchar(MAX)=''
DECLARE @filename nvarchar(MAX)=''

SET @clientname=(select ClientName from obp_clientmaster where id in(select ClientID from obp_TaskHeader where id=@id))
set @count=(SELECT count(*) from obps_FileUpload where autoid=@id and Linkid=@LinkId)
SET @filename=@clientname+'_'+@id+'_'+@count
SELECT @filename

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getAdminSubLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getAdminSubLink]        
@linkid int=''
AS
BEGIN

select  Id,linkname from obps_toplinks where MenuId=@linkid  
order by LinkName    

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetAllowedExtensions]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GetAllowedExtensions]
@linkid nvarchar(MAX)=''
AS
BEGIN

DECLARE @Values nvarchar(MAX)=''
SET @Values=(select AllowedExtension from obps_toplinks where id=@linkid)
	SELECT items
    FROM [dbo].[Split_Upload] (@Values, ',')
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetAvailableCRUDButton]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GetAvailableCRUDButton]  
@GridId nvarchar(2)='',  
@LinkId nvarchar(2)=''  
AS  
BEGIN  
DECLARE @IsAdd nvarchar(MAX),  
@IsEdit nvarchar(MAX),  
@IsDelete nvarchar(MAX),  
@IsExport nvarchar(MAX),  
@IsFilterRow nvarchar(MAX),  
@IsHeaderFilter nvarchar(MAX),  
@IsColumnChooser nvarchar(MAX),  
@IsPaging nvarchar(MAX),  
@GridAddName nvarchar(MAX),  
@GridEditName nvarchar(MAX),  
@GridDeleteName nvarchar(MAX),  
@GridExportName nvarchar(MAX),  
@GridFilterRowName nvarchar(MAX),  
@GridheaderFilterName nvarchar(MAX),  
@GridColumnChooserName nvarchar(MAX),  
@GridPagingName nvarchar(MAX),  
@GridGroupPanelName nvarchar(MAX),  
@colnamequery nvarchar(MAX),  
@colnamequery1 nvarchar(MAX),  
@colnamequery2 nvarchar(MAX),  
@colnamequery3 nvarchar(MAX),  
@colnamequery4 nvarchar(MAX),  
@colnamequery5 nvarchar(MAX),  
@colnamequery6 nvarchar(MAX),  
@colnamequery7 nvarchar(MAX),  
@colnamequery8 nvarchar(MAX),  
@IsUploadEnabled nvarchar(MAX),  
@IssearchPanel nvarchar(MAX),  
@IsGroupPanel nvarchar(MAX),  
@IsDependentTab nvarchar(MAX)  
  
SET @GridAddName='Grid'+@GridId+'AllowAdd'  
SET @GridEditName='Grid'+@GridId+'AllowEdit'  
SET @GridDeleteName='Grid'+@GridId+'AllowDelete'  
SET @GridExportName='Grid'+@GridId+'IsExport'  
SET @GridFilterRowName='Grid'+@GridId+'AllowFilterRow'  
SET @GridheaderFilterName='Grid'+@GridId+'AllowheaderFilter'  
SET @GridColumnChooserName='Grid'+@GridId+'AllowColumnChooser'  
SET @GridPagingName='Grid'+@GridId+'AllowPaging'  
SET @GridGroupPanelName='Grid'+@GridId+'AllowGroupPanel'  
  
SET @colnamequery=('(select @IsAdd='+@GridAddName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery,  N'@IsAdd NVARCHAR(MAX) output',  @IsAdd output  
  
SET @colnamequery1=('(select @IsEdit='+@GridEditName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery1,  N'@IsEdit NVARCHAR(MAX) output',  @IsEdit output  
  
SET @colnamequery2=('(select @IsDelete='+@GridDeleteName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery2,  N'@IsDelete NVARCHAR(MAX) output',  @IsDelete output  
  
SET @colnamequery3=('(select @IsExport='+@GridExportName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery3,  N'@IsExport NVARCHAR(MAX) output',  @IsExport output  
if @IsExport is null  
set @IsExport=0;  
  
SET @colnamequery4=('(select @IsFilterRow='+@GridFilterRowName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery4,  N'@IsFilterRow NVARCHAR(MAX) output',  @IsFilterRow output  
if @IsFilterRow is null  
set @IsFilterRow=0;  
  
SET @colnamequery5=('(select @IsHeaderFilter='+@GridheaderFilterName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery5,  N'@IsHeaderFilter NVARCHAR(MAX) output',  @IsHeaderFilter output  
if @IsHeaderFilter is null  
set @IsHeaderFilter=0;  
  
SET @colnamequery6=('(select @IsColumnChooser='+@GridColumnChooserName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery6,  N'@IsColumnChooser NVARCHAR(MAX) output',  @IsColumnChooser output  
if @IsColumnChooser is null  
set @IsColumnChooser=0;  
  
SET @colnamequery7=('(select @IsPaging='+@GridPagingName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery7,  N'@IsPaging NVARCHAR(MAX) output',  @IsPaging output  
if @IsPaging is null  
set @IsPaging=0;  
  
SET @IsUploadEnabled=(select IsUploadEnabled from obps_TopLinks where id=@LinkId)  
if @IsUploadEnabled is null  
set @IsUploadEnabled=0;  
  
SET @colnamequery8=('(select @IsGroupPanel='+@GridGroupPanelName+' from obps_TopLinks where ID='''+@LinkId +''')')  
EXEC Sp_executesql  @colnamequery8,  N'@IsGroupPanel NVARCHAR(MAX) output',  @IsGroupPanel output  
if @IsGroupPanel is null  
set @IsGroupPanel=0;  
  
SET @IssearchPanel=(select EnableUniversalSearch from obps_TopLinks where id=@LinkId)  
if @IssearchPanel is null  
set @IssearchPanel=0;  
  
SET @IsDependentTab=(select IsDependentTab from obps_TopLinks where id=@LinkId)  
if @IsDependentTab is null  
set @IsDependentTab=0;  
  
SELECT @IsAdd,@IsEdit,@IsDelete,@IsExport,@IsFilterRow,@IsHeaderFilter,@IsColumnChooser,@IsPaging,  
    @IsUploadEnabled,@IsGroupPanel,@IssearchPanel,@IsDependentTab  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetButtonsp]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetButtonsp]  
 @LinkId NVARCHAR(MAX)='',  
 @ColumnName NVARCHAR(MAX)='', 
 @Id NVARCHAR(MAX)='', 
 @username NVARCHAR(MAX)='', 
 @ClickedVal NVARCHAR(MAX)=''
AS  
BEGIN  
  
  DECLARE @query NVARCHAR(MAX),  
  @query_Key NVARCHAR(MAX),  
  @tabname NVARCHAR(MAX),  
  @querystr nvarchar(MAX)='' ,
  @colnew nvarchar(MAX)='',@indx int,@btnSpname nvarchar(MAX)=''

  DECLARE @ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),  
  @controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int  
  
    SET NOCOUNT ON;  


--IF @tabname is not null  
--BEGIN  
SET @indx=(select CHARINDEX ('__',@ColumnName,0 ))    
SET @colnew=(SELECT SUBSTRING(@ColumnName, 1,@indx-1))  
SET @tabname=(SELECT SUBSTRING(@ColumnName, @indx+2, LEN(@ColumnName)))  
set @btnSpname=(select DropDownLink from obps_ColAttrib  where ColName=@colnew and TABLENAME = @tabname AND  linkid=@LinkId)  

if @btnSpname is not null
	exec @btnSpname @colnew,@Id, @username, @ClickedVal 

select @btnSpname,@colnew,@Id, @username, @ClickedVal 

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getCaption]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getCaption]
AS
BEGIN

select id,caption 'DisplayName' from obps_Dashboards

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getCellDDLValues]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getCellDDLValues]          
@colname nvarchar(MAX)='',          
@gridid nvarchar(MAX)='', 
@id nvarchar(MAX)='',
@mappedspcol nvarchar(MAX)='',
@usrname NVARCHAR(MAX)='',          
@linkid NVARCHAR(MAX)=''          
AS          
BEGIN          
           
 DECLARE @sp nvarchar(MAX)='',          
 @colnew nvarchar(MAX)='',          
 @tabname nvarchar(MAX)='',          
 @indx int,          
 @Gridtabname NVARCHAR(MAX)='',@tabquery nvarchar(MAX)='',
 @spquery nvarchar(MAX)=''
 
   
   
 SET @Gridtabname='Grid'+@gridid+'table'
 SET @tabquery=('(SELECT @tabname='+@Gridtabname+' FROM Obps_TopLinks where '+@Gridtabname+'  is not null and id='''+@LinkId+''')')  
 EXEC Sp_executesql  @tabquery,  N'@tabname NVARCHAR(MAX) output',  @tabname output  
 
 SET @spquery=('(SELECT @sp='+@mappedspcol+' FROM '+@tabname+' where id='''+@id+''')')  
 EXEC Sp_executesql  @spquery,  N'@sp NVARCHAR(MAX) output',  @sp output  		 

if len(rtrim(ltrim(@sp)))>0      
exec @sp @usrname,@linkid,@gridid  

END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetChartProperties]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetChartProperties]
@LinkId nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @i int = 1,@j int = 1
DECLARE @Title nvarchar(MAX)='',@Divnametitle nvarchar(MAX)='',
@Div1Title nvarchar(MAX)='',@Div2Title nvarchar(MAX)='',@Div3Title nvarchar(MAX)='',@Div4Title nvarchar(MAX)='',
@Div5Title nvarchar(MAX)='',@Div6Title nvarchar(MAX)=''
--,@Div1Type nvarchar(MAX)='',@Div2Type nvarchar(MAX)='',
--@Div3Type nvarchar(MAX)='',@Div4Type nvarchar(MAX)='',@Div5Type nvarchar(MAX)='',@Div6Type nvarchar(MAX)=''

if @LinkId<>''  


SET @Title=(select DivTitle from obps_Charts where LinkId=@LinkId)

if len(rtrim(ltrim(@Title)))>0  
BEGIN


WHILE @i <7
BEGIN
	--set @Divnametitle='Div'+CONVERT(varchar(10),@i) +'Title'
	;WITH   cte
			  AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@Title,';')
				 )
		SELECT  @Divnametitle=value
		FROM    cte
		WHERE   ROW_NUM =@i
	if @i=1
		SET @Div1Title=@Divnametitle
	else if @i=2
		SET @Div2Title=@Divnametitle
	else if @i=3
		SET @Div3Title=@Divnametitle
	else if @i=4
		SET @Div4Title=@Divnametitle
	else if @i=5
		SET @Div5Title=@Divnametitle
	else if @i=6
		SET @Div6Title=@Divnametitle

	SET @i  = @i  + 1

END  
END

 select @Div1Title,@Div2Title,@Div3Title,@Div4Title,@Div5Title,@Div6Title,
 Div1Charttype,Div2Charttype,Div3Charttype,Div4Charttype,Div5Charttype,Div6Charttype 
 from obps_charts

 END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getClient]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getClient]        
@User_Name NVARCHAR(MAX)='',  
@linkid int='' ,          
@gridid nvarchar(MAX)=''        
AS        
BEGIN        
 DECLARE @SearchLetter int  ,@var_clientid nvarchar(max)     
 SET @SearchLetter =(Select id from obps_users where UserName=@User_Name)
 Set @var_clientid=(Select par1 from obps_SpPermissions where Linkid=@linkid and userid =  @SearchLetter)

 select id,clientname as name from obp_ClientMaster where id in (Select value from string_split(@var_clientid,','))         
 order by id asc        
 --select ID,clientname as name from obp_ClientMaster        
END    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getClientId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getClientId]  
@clientname NVARCHAR(MAX)=''  --,
--@lId int=''
AS  
BEGIN  
	select id from obp_ClientMaster  where ClientName=@clientname
END  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getColColor]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getColColor]
@Gridname NVARCHAR(MAX)=NULL,
@colname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
		DECLARE @query NVARCHAR(MAX),
	   @query_colorid NVARCHAR(MAX),
	   @tabname NVARCHAR(MAX),
	   @cid NVARCHAR(MAX),
	   @spquery NVARCHAR(MAX) ,
	   @spname NVARCHAR(MAX),
	   @query_color NVARCHAR(MAX),
	   @colorname NVARCHAR(MAX)

    SET NOCOUNT ON;
 
	SET @spquery=('(SELECT @spname='+@Gridname+' FROM Obp_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
	EXEC Sp_executesql  @spquery,  N'@spname NVARCHAR(MAX) output',  @spname output

	SET @tabname=(SELECT DISTINCT t.name 
	FROM sys.sql_dependencies d 
	INNER JOIN sys.procedures p ON p.object_id = d.object_id
	INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
	where p.name=@spname )

	SET @query_colorid=('SELECT @colorid = ColColor FROM Obp_ColAttrib WHERE TableName='''+@tabname+''' and ColName='''+@colname+'''')
	EXEC Sp_executesql  @query_colorid,  N'@colorid int output',  @cid output
	
	SET @query_color=('select @colourname=Color from Obp_ColorPicker where id='''+@cid+'''')
	EXEC Sp_executesql  @query_color,  N'@colourname NVARCHAR(MAX) output',  @colorname output
	select @colorname

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getColDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[obps_sp_getColDetails]                                                  
@username NVARCHAR(MAX)='',                                
@RoleId NVARCHAR(MAX)='',                                                  
@LinkId NVARCHAR(MAX)='',                                                  
@GridId int=''                                                  
AS                                                  
BEGIN                                                  
DECLARE @query NVARCHAR(MAX),                                                  
    @query_colorid NVARCHAR(MAX),                                                  
    @tabname NVARCHAR(MAX),                                                  
    @cid NVARCHAR(MAX),                                                  
    @spquery NVARCHAR(MAX) ,                                                  
    @spname NVARCHAR(MAX),                                                  
    @query_color NVARCHAR(MAX),                                                  
    @colorname NVARCHAR(MAX),                                                  
    @iRoleId int      ,                                
    @IsRoleAttached int                                
                                                  
    SET NOCOUNT ON;                                   
               
  SET  @spname=(SELECT gridsp FROM obps_TopLinkExtended where gridid=@GridId and Linkid=@LinkId)            
                               print 0  
  SET @IsRoleAttached=COALESCE((SELECT top 1 case when IsRoleAttached=''  then 0 else IsRoleAttached end from obps_UserLinks                                 
   where UserId=(select top 1 id from obps_Users where UserName=@username) and subLinkId=@LinkId and isdeleted=0),0)     
     print 012  
  SET @iRoleId=(SELECT SUBSTRING(@RoleId, 5, 1))                                      
                               
   if(@IsRoleAttached=1)                          
   BEGIN                          
   print 1  
     select lower(COL.ColName) +'__'+LOWER(Col.TableName) as ColumnName,data_type,COL.DisplayName,COL.ColControlType,                                                   
     COL.ColColor,COALESCE(RM.IsEditable,1),col.ColumnWidth,col.SortIndex ,col.SortOrder,col.IsMobile,col.tooltip,              
     col.SummaryType,COALESCE(RM.IsVisible,1) 'isvisible',COALESCE(RM.VisibilityIndex,-1)'VisibilityIndex',              
     @IsRoleAttached 'IsRoleAttached',IsRequired,F.Icon,MinVal,MaxVal,IsValidation,IsRefreshDDL                                       
     --into #inpclass                                                  
     FROM INFORMATION_SCHEMA.COLUMNS                                                  
     inner join Obps_RoleMap RM on Column_Name=RM.ColName                                                  
     and table_name=RM.TableName                                                  
     inner join Obps_ColAttrib COL on RM.TableName=Col.TableName                 
     --and RM.GridId=Col.GridId                                                  
     and RM.ColName=COL.ColName                      
     left join obps_FormatCondIcon F on Col.FormatCondIconId=F.id              
     -- left join Obps_ColorPicker colr on COL.ColColor=colr.ID                                                  
     WHERE  --RM.IsVisible=1 and                                               
     RM.TableID in                                                  
     (SELECT TableId FROM Obps_TableId where TABLENAME in                                                   
     (SELECT DISTINCT t.name                                                   
     FROM sys.sql_dependencies d                                                   
     INNER JOIN sys.procedures p ON p.object_id = d.object_id                                                  
     INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id                                                  
     where p.name=@spname)) and RoleId=@iRoleId and RM.GridId=@GridId and Col.LinkId=@LinkId                   
                
     UNION              
              
     select lower(ColName) as ColumnName,'nvarchar(MAX)',DisplayName,'textbox',                                                   
     ColColor,0,ColumnWidth,SortIndex ,SortOrder,IsMobile ,tooltip ,SummaryType,1,'-1',              
     @IsRoleAttached,0,F.Icon,MinVal,MaxVal,0,IsRefreshDDL                   
     FROM obps_CalculatedColAttrib               
     left join obps_FormatCondIcon F on FormatCondIconId=F.id            
     where LinkId=@LinkId    and   GridId=@GridId                
                
   END                          
   ELSE                          
   BEGIN           
   print 2  
     select lower(COL.ColName) +'__'+LOWER(Col.TableName) as ColumnName,data_type,COL.DisplayName,COL.ColControlType,              
     COL.ColColor,col.IsEditable,col.ColumnWidth,col.SortIndex ,col.SortOrder,col.IsMobile,col.tooltip,                  
     col.SummaryType,COALESCE(IsActive,1) 'isvisible',                                
     -1 'VisibilityIndex',0 'IsRoleAttached',IsRequired,F.Icon,MinVal,MaxVal,IsValidation,IsRefreshDDL                                       
     --into #inpclass                                                 
     FROM INFORMATION_SCHEMA.COLUMNS                          
     inner join Obps_ColAttrib COL on                           
     table_name=TableName and Column_Name=ColName                     
     left join obps_FormatCondIcon F on FormatCondIconId=F.id              
     where  TableID in                                                  
     (SELECT TableId FROM Obps_TableId where TABLENAME in                                                   
     (SELECT DISTINCT t.name                                                   
     FROM sys.sql_dependencies d                                                   
     INNER JOIN sys.procedures p ON p.object_id = d.object_id                                                  
     INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id              
     where p.name=@spname))  --and GridId=@GridId                           
     and LinkId=@LinkId                        
                
     UNION                                              
                
     select lower(ColName) as ColumnName,'nvarchar(MAX)',DisplayName,'textbox',                                                   
     ColColor,0,ColumnWidth,SortIndex ,SortOrder,IsMobile ,tooltip ,SummaryType,1,'-1',              
     @IsRoleAttached,0,F.Icon,MinVal,MaxVal,0,IsRefreshDDL                                          
     FROM obps_CalculatedColAttrib                
     left join obps_FormatCondIcon F on FormatCondIconId=F.id              
     where LinkId=@LinkId and GridId=@GridId                                  
   END                          
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getColEditable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getColEditable]
@Gridname NVARCHAR(MAX)=NULL,
@colname NVARCHAR(MAX)=NULL,
@RoleId NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
	   DECLARE @query NVARCHAR(MAX),
	   @query_Isditid NVARCHAR(MAX),
	   @tabname NVARCHAR(MAX),
	   @cid NVARCHAR(MAX),
	   @indx int,
	   @spquery NVARCHAR(MAX) ,
	   @spname NVARCHAR(MAX),
	   @IsEdit NVARCHAR(20),
	   @colname_new NVARCHAR(MAX)

	SET NOCOUNT ON

	SET @indx=(select CHARINDEX ('__',@colname,0 ))
	SET @colname_new=(SELECT SUBSTRING(@colname, 1, @indx-1))

	SET @spquery=('(SELECT @spname='+@Gridname+' FROM Obps_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
	EXEC Sp_executesql  @spquery,  N'@spname NVARCHAR(MAX) output',  @spname output

	SET @query_Isditid=('SELECT @IsEdit=IsEditable FROM Obps_RoleMap WHERE TableId in 
						(select TableId from Obps_TableId where TableName in(SELECT DISTINCT t.name 
	FROM sys.sql_dependencies d 
	INNER JOIN sys.procedures p ON p.object_id = d.object_id
	INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
	where p.name='''+@spname+'''))and ColName='''+@colname_new+'''and RoleId='+@RoleId+'')

	EXEC Sp_executesql  @query_Isditid,  N'@IsEdit int output',  @cid output
	SELECT @cid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getColNames]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getColNames]    
@tablename nvarchar(MAX)=''    
AS    
BEGIN    
	SELECT COLUMN_NAME as 'colname'
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @tablename
	AND COLUMN_NAME not in('id','id1','Color1','Color2','Color3','Color4',
						'Color5','SeqNo','CreatedDate','ModifiedDate',
						'Createdby','Modifiedby','isActive','isDeleted',
						'AccessToUser','ShareToUser')
	ORDER BY ORDINAL_POSITION
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getColourNames]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getColourNames]
AS
BEGIN
	select colorid,HexCode from obps_ColorPicker order by ColorID
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getcolumndetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getcolumndetails]
@Gridname NVARCHAR(MAX)=NULL,
@colname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
		DECLARE @query NVARCHAR(MAX),
	   @query_colorid NVARCHAR(MAX),
	   @tabname NVARCHAR(MAX),
	   @cid NVARCHAR(MAX),
	   @spquery NVARCHAR(MAX) ,
	   @spname NVARCHAR(MAX),
	   @query_color NVARCHAR(MAX),
	   @colorname NVARCHAR(MAX),
	   @dispname NVARCHAR(MAX),
	   @ParmDefinition NVARCHAR(500),
	   @ctrltype NVARCHAR(MAX),
	   @PrefLang int=0
    SET NOCOUNT ON;

	/* Need to check how to get Current User Display Name Setting to @PrefLang -- 1 OR 0*/
 
	SET @spquery=('(SELECT @spname='+@Gridname+' FROM Obp_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
	EXEC Sp_executesql  @spquery,  N'@spname NVARCHAR(MAX) output',  @spname output

	SET @tabname=(SELECT DISTINCT t.name 
	FROM sys.sql_dependencies d 
	INNER JOIN sys.procedures p ON p.object_id = d.object_id
	INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
	where p.name=@spname )
	------,@dispname=ColControlType
	/*
	SET @query_colorid=('SELECT @cid = ColColor,@dispname=DisplayName,@ctrltype=ColControlType
	FROM Obp_ColAttrib WHERE TableName='''+@tabname+''' and ColName='''+@colname+'''')
	*/

	SET @query_colorid=('SELECT @cid = ColColor,@dispname=case when @PrefLang=1 then isnull(AltLang,DisplayName) else DisplayName end ,@ctrltype=ColControlType
	FROM Obp_ColAttrib WHERE TableName='''+@tabname+''' and ColName='''+@colname+'''')

	SET @ParmDefinition=N'@cid int output,@dispname nvarchar(MAX) output,@ctrltype nvarchar(MAX)OUTPUT'

	EXEC Sp_executesql  @query_colorid,  @ParmDefinition,  @cid output,@dispname output,@ctrltype output

	SET @query_color=('select @colourname=Color from Obp_ColorPicker where id='''+@cid+'''')
	EXEC Sp_executesql  @query_color,  N'@colourname NVARCHAR(MAX) output',  @colorname output

	select @colorname,@dispname,@ctrltype

END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getCondFormatIcon]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[obps_sp_getCondFormatIcon]
AS
BEGIN

select id,icon 'image' from obps_FormatCondIcon

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getControlType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getControlType]
@Gridname NVARCHAR(MAX)=NULL,
@colname NVARCHAR(MAX)=NULL
AS
BEGIN
	DECLARE @query NVARCHAR(MAX),
			   @query_control NVARCHAR(MAX),
			   @tabname NVARCHAR(MAX),
			   @cid NVARCHAR(MAX),
			   @spquery NVARCHAR(MAX) ,
			   @spname NVARCHAR(MAX)

    SET NOCOUNT ON;
 
	SET @spquery=('(SELECT @spname='+@Gridname+' FROM Obp_LFLinks where '+@Gridname+'  is not null)')
	EXEC Sp_executesql  @spquery,  N'@spname NVARCHAR(MAX) output',  @spname output

	SET @tabname=(SELECT DISTINCT t.name 
	FROM sys.sql_dependencies d 
	INNER JOIN sys.procedures p ON p.object_id = d.object_id
	INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
	where p.name=@spname )

	SET @query_control=('SELECT @control = ColControlType FROM Obp_ColAttrib WHERE TableName='''+@tabname+'''
						and ColName='''+@colname+'''')
	EXEC Sp_executesql  @query_control,  N'@control NVARCHAR(MAX) output',  @cid output
	IF @cid='DropDownList' 
	BEGIN
		select '1'
	END
	ELSE
	BEGIN
		SELECT '0'
	END


END


GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getCSVSeperator]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getCSVSeperator]
@linkid nvarchar(MAX)='',
@username nvarchar(MAX)=''
AS
BEGIN

select CSVSeperator from obps_toplinks where id=@linkid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetDashboardbyId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetDashboardbyId]
@id nvarchar(MAX)=''
AS
BEGIN

select D.id 'id',M.DisplayName 'mainmenu',LinkName 'sublink',caption 
		from obps_Dashboards D 
		inner join obps_TopLinks T
		on T.id=D.LinkId 
		left join obps_MenuName M
		on M.MenuId=T.MenuId where D.id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetDashboardDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GetDashboardDetails]        
AS        
BEGIN        
select D.id 'id',M.DisplayName 'mainmenu',LinkName 'sublink',caption 
		from obps_Dashboards D 
		inner join obps_TopLinks T
		on T.id=D.LinkId 
		left join obps_MenuName M
		on M.MenuId=T.MenuId
END      
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDashboardRecords]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_getDashboardRecords]          
AS          
BEGIN   

select D.id 'id',Caption,displayname,linkname 
	from obps_Dashboards D
	left join obps_toplinks T on T.id=D.linkid
	left join obps_MenuName M on M.menuid=T.menuid
	

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetDashboardViewerId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[obps_sp_GetDashboardViewerId]
@usrname nvarchar(MAX)='',
@linkid nvarchar(MAX)=''
AS
BEGIN

Select top 1  id from obps_Dashboards where LinkId=@linkid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getData_Grid1]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getData_Grid1]
AS
BEGIN
select * from OBP_PRJ_011
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getData_Grid2]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getData_Grid2]
AS
BEGIN
select * from OBP_PRJ_012
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getData_Grid3]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getData_Grid3]
AS
BEGIN
select * from OBP_PRJ_014
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getData_Link2Grid1]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getData_Link2Grid1]
AS
BEGIN
select  top 10 * from OBP_PRJ_012 p1 inner join OBP_PRJ_013 p2 on p1.classification=p2.classification
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDataTypes]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getDataTypes]
@id nvarchar(MAX)=''
AS
BEGIN
	if @id<>''
		select id,DataType from [dbo].[obps_TableDataTypes] where id=@id
	else
		select id,DataType from [dbo].[obps_TableDataTypes]
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDDDataClassification]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getDDDataClassification]
AS
BEGIN
	select distinct ClientName,Id from obp_ClientMaster
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDDLClientname]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getDDLClientname]
@usrname NVARCHAR(MAX)=''
AS
BEGIN
	DECLARE @SearchLetter nvarchar(100)
	SET @SearchLetter ='%'+ @usrname + '%'
	select distinct ClientName,Id from obp_ClientMaster where AccessToUser like  @SearchLetter
	order by ClientName

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetDDLColName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetDDLColName]      
@tabname nvarchar(MAX)=''  ,    
@checkforddl nvarchar(MAX)='',    
@linkid nvarchar(MAX)=''    
AS      
BEGIN      
IF @checkforddl='' and @linkid<>''    
BEGIN    
 if @tabname<>''  
 BEGIN  
  SELECT ORDINAL_POSITION 'id',lower(COLUMN_NAME) 'ColName'    
  FROM INFORMATION_SCHEMA.COLUMNS    
  WHERE TABLE_NAME = @tabname    
  and COLUMN_NAME not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')    
  ORDER BY ORDINAL_POSITION  
 END  
 ELSE  
 BEGIN  
   select id,lower(ColName) from obps_ColAttrib       
   where ColName not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')      
   and IsActive=1 and LOWER(ColControlType)='dropdownlist' and TableName=@tabname  and LinkId=@linkid    
  END  
END    
ELSE    
BEGIN    
SELECT ORDINAL_POSITION 'id',lower(COLUMN_NAME) 'ColName'    
FROM INFORMATION_SCHEMA.COLUMNS    
WHERE TABLE_NAME = @tabname    
and COLUMN_NAME not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')    
ORDER BY ORDINAL_POSITION     
END    
      
END      

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDDLcount]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_getDDLcount]      
@username nvarchar(MAX)='',      
@linkid nvarchar(MAX)=''      
AS      
BEGIN      
DECLARE @ddl1sp nvarchar(MAX)=''      
DECLARE @ddl2sp nvarchar(MAX)=''      
DECLARE @ddl3sp nvarchar(MAX)=''      
      
select Ddl1Sp,Ddl2Sp,ddl3sp,ddl1text,ddl2text,ddl3text from obps_MobileConfig where Linkid=@linkid      
      
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetDDLDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetDDLDetails]  
AS  
BEGIN  
select D.id as 'id',M.DisplayName as 'menuname',LinkName,linkid,TableName,ColName,ColumnToInsert,ColumnToSelect,TableToSelect,case when IsId=1 then 1 else 0 end as'IsId'   
 from obps_DropDownTable D inner join obps_ColAttrib C  
 on D.ColumnId=C.ID  inner join obps_TopLinks T on T.id=C.LinkId
 inner join obps_MenuName M on M.menuid=T.menuid 
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDDLValues]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [dbo].[obps_sp_getDDLValues]                  
@colname nvarchar(MAX)='',                  
@gridid nvarchar(MAX)='',                  
@usrname NVARCHAR(MAX)='',                  
@linkid int='',        
@ddlSelectedValue nvarchar(MAX)=''  ,      
@ddlSelectedidValue nvarchar(MAX)=''        
AS                  
BEGIN                  
                   
 DECLARE @sp nvarchar(MAX)='',                  
 @colnew nvarchar(MAX)='',                  
 @tabname nvarchar(MAX)='',                  
 @indx int,                  
 @gid int,        
 @dependentcolname nvarchar(50)='',        
 @dependentcoltable int='',        
 @dependentddlValue nvarchar(100),        
 @col varchar(MAX),                          
 @val varchar(MAX)='',        
 @depddl int=0,@refreshddl int=0 ,       
 @ddlval nvarchar(100)=''        
                
 SET @indx=(select CHARINDEX ('__',@colname,0 ))                  
 SET @gid=(SELECT SUBSTRING(@gridid,5,1))                  
 SET @colnew=(SELECT SUBSTRING(@colname, 1,@indx-1))                  
 SET @tabname=(SELECT SUBSTRING(@colname, @indx+2, LEN(@colname)))                  
 SET @sp=(SELECT dropdownlink from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid                 
 and LinkId=@linkid)            
         
 if((SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid                 
 and LinkId=@linkid)!=null)        
 BEGIN        
  SET @depddl=1        
  SET @dependentcolname=(select colname from obps_colattrib where id=(SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid                 
  and LinkId=@linkid))        
  SET @dependentcoltable=(select TableName from obps_colattrib where id=(SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid                 
  and LinkId=@linkid))        
                            
  DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                          
  SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval                          
  FROM [dbo].[Split_UpdateSp] (@ddlSelectedValue, '^') ;                          
                           
  OPEN CUR_TEST                          
  FETCH NEXT FROM CUR_TEST INTO @col,@val                          
                           
   WHILE @@FETCH_STATUS = 0                          
   BEGIN         
    if(@col=(select (@dependentcolname+'__'+@dependentcoltable)))        
     SET @ddlval=@val        
   FETCH NEXT FROM CUR_TEST INTO @col,@val                          
   END                         
  CLOSE CUR_TEST                          
  DEALLOCATE CUR_TEST         
 END        
 if((SELECT IsRefreshDDL from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid                 
 and LinkId=@linkid)=1)        
 BEGIN        
  SET @refreshddl=1    
 END    
    
 --SELECT dropdownlink from obps_ColAttrib where COLNAME='Stage' and TableName='obp_Leaddetails' and dropdownlink is not null and gridid=@gid and LinkId=@linkid                  
 print @sp
 if len(rtrim(ltrim(@sp)))>0              
 BEGIN        
 if(@depddl=1)        
 begin 
 print '1'
  exec @sp @usrname,@linkid,@gridid,@ddlval       
 end  
 else if(@refreshddl=1)       
 begin  
 print '2'
 exec @sp @usrname,@linkid,@gridid,@ddlSelectedidValue     
 end  
 else       
 begin  
 print '3'
 exec @sp @usrname,@linkid,@gridid            
 end  
 END        
 --exec @sp @usrname            
END   
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDDLValues_new]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getDDLValues_new]          
@colname nvarchar(MAX)='',          
@gridid nvarchar(MAX)='',          
@usrname NVARCHAR(MAX)='',          
@linkid int='',
@ddlSelectedValue nvarchar(MAX)=''
AS          
BEGIN          
           
 DECLARE @sp nvarchar(MAX)='',          
 @colnew nvarchar(MAX)='',          
 @tabname nvarchar(MAX)='',          
 @indx int,          
 @gid int,
 @dependentcolname nvarchar(50)='',
 @dependentcoltable int='',
 @dependentddlValue nvarchar(100),
 @col varchar(MAX),                  
 @val varchar(MAX)='',
 @depddl int=0,
 @ddlval nvarchar(100)=''
        
 SET @indx=(select CHARINDEX ('__',@colname,0 ))          
 SET @gid=(SELECT SUBSTRING(@gridid,5,1))          
 SET @colnew=(SELECT SUBSTRING(@colname, 1,@indx-1))          
 SET @tabname=(SELECT SUBSTRING(@colname, @indx+2, LEN(@colname)))          
 SET @sp=(SELECT dropdownlink from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid         
 and LinkId=@linkid)    
 
 if((SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid         
 and LinkId=@linkid)!=null)
 BEGIN
	 SET @depddl=1
	 SET @dependentcolname=(select colname from obps_colattrib where id=(SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid         
	 and LinkId=@linkid))
	 SET @dependentcoltable=(select TableName from obps_colattrib where id=(SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid         
	 and LinkId=@linkid))
	                   
		DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                  
		SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval                  
		FROM [dbo].[Split_UpdateSp] (@ddlSelectedValue, '^') ;                  
                   
		OPEN CUR_TEST                  
		FETCH NEXT FROM CUR_TEST INTO @col,@val                  
                   
			WHILE @@FETCH_STATUS = 0                  
			BEGIN 
				if(@col=(select (@dependentcolname+'__'+@dependentcoltable)))
					SET @ddlval=@val
			FETCH NEXT FROM CUR_TEST INTO @col,@val                  
			END		               
		CLOSE CUR_TEST                  
		DEALLOCATE CUR_TEST 
 END

 --SELECT dropdownlink from obps_ColAttrib where COLNAME='Stage' and TableName='obp_Leaddetails' and dropdownlink is not null and gridid=@gid and LinkId=@linkid          
 if len(rtrim(ltrim(@sp)))>0      
 BEGIN
 if(@depddl=1)
	exec @sp @usrname,@linkid,@gridid,@ddlval  
 else
	exec @sp @usrname,@linkid,@gridid    
 END
 --exec @sp @usrname    
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDefaultLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getDefaultLink]
@Username  NVARCHAR(MAX)=NULL
AS
BEGIN
DECLARE @default_Linkid int=NULL;

SET @default_Linkid=(select defaultlinkid from obps_users where UserName=@Username)

IF @default_Linkid is NULL
BEGIN
select top 1 Id from Obps_topLinks where IsAfterLogin=1
END
ELSE
BEGIN
select @default_Linkid
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getFileUploadPath]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getFileUploadPath]  
@LinkId nvarchar(MAX)=''
AS  
BEGIN  
----Folder Name should be '~/Upload/TestFolderName/' 
select Uploadpath from obps_TopLinks where id=@LinkId  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getGanttDependency]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getGanttDependency]          
@lnkId nvarchar(MAX)='',      
@usrname nvarchar(MAX)='',    
@gridid nvarchar(MAX)=''    
AS          
BEGIN          
      
 select id,PredecessorId as 'PredecessorId',SuccessorId as 'SuccessorId',2 as 'Type'  from obp_TaskHeader  
 where ShareToUser like '%'+@usrname+'%'
 union  
 select id,PredecessorId as 'PredecessorId',SuccessorId as 'SuccessorId',3 as 'Type'  from obp_TaskDetails  
  where ShareToUser like '%'+@usrname+'%'
    
END   
  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getGanttRecords]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getGanttRecords]
AS
BEGIN


select G.id 'id',displayname,linkname,T.linkid 'sublinkid'
,tablename,SubjectColName,  
StartColName,EndColName,PredecessorIdColName,SuccessorIdColName   
from obps_ganttconfig G   
right join obps_TopLinkExtended T on G.Linkid=T.Linkid  
right join obps_toplinks TS on T.linkid=TS.id  
right join obps_MenuName M on M.MenuId=TS.MenuId  
where TS.Type in(3,4) and T.GridId=1

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getGridCount]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getGridCount]  
@TypeId INT  
AS  
BEGIN  
select Gridcount from obps_PageType where PageTypeId=@TypeId
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getGridDDLValues]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getGridDDLValues]  
@usrname NVARCHAR(MAX)='',        
@linkid int=''        
AS        
BEGIN        
         
 DECLARE @sp nvarchar(MAX)=''  
        
 SET @sp=(SELECT DdlSp from obps_toplinks where id=@linkid)          
 if len(rtrim(ltrim(@sp)))>0    
 exec @sp @usrname,@linkid  
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getGridId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getGridId]        
@Username  NVARCHAR(MAX)='' ,      
@linkid int='' 
AS        
BEGIN        
 select  Id,gridid from obps_TopLinkExtended 
 where Linkid=@linkid  order by GridId   
END     
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getgridProperties]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getgridProperties]  
@linkid int='',
@gid int=''
AS  
BEGIN  
 if(@linkid<>'' and @gid<>'')  
 BEGIN  
   select TE.ID,M.DisplayName,T.linkname,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp  
  ,AfterSaveSp,IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled  
  ,RefreshSp,IsYellowBtn,YellowBtnSp,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit  
  ,DependentGrid,AllowHScrollBar,CustomContextMenuLinkId1,t1.LinkName 'm1linkname',m1.DisplayName 'm1menuname', CustomContextMenuLinkId2,  
  t2.LinkName 'm2linkname',m2.DisplayName 'm2menuname',CustomContextMenuLinkId3,t3.LinkName 'm3linkname',  
  m3.DisplayName 'm3menuname',CustomContextMenuTxt1 'm1txt',CustomContextMenuTxt2 'm2txt',CustomContextMenuTxt3 'm3txt'  
  from obps_TopLinkExtended TE   
   inner join obps_TopLinks T on T.id=TE.Linkid  
   inner join obps_MenuName M on M.MenuId=T.MenuId  
   left join  obps_TopLinks T1 on T1.id=TE.CustomContextMenuLinkId1  
   left join obps_MenuName M1 on M1.MenuId=T1.MenuId  
   left join  obps_TopLinks T2 on T2.id=TE.CustomContextMenuLinkId2  
   left join obps_MenuName M2 on M2.MenuId=T1.MenuId  
   left join  obps_TopLinks T3 on T3.id=TE.CustomContextMenuLinkId3  
   left join obps_MenuName M3 on M3.MenuId=T3.MenuId   
   where linkid=@linkid  and GridId=@gid
  
 END  
 ELSE if(@linkid<>'')  
 BEGIN  
   select TE.ID,M.DisplayName,T.linkname,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp  
  ,AfterSaveSp,IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled  
  ,RefreshSp,IsYellowBtn,YellowBtnSp,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit  
  ,DependentGrid,AllowHScrollBar,CustomContextMenuLinkId1,t1.LinkName 'm1linkname',m1.DisplayName 'm1menuname', CustomContextMenuLinkId2,  
  t2.LinkName 'm2linkname',m2.DisplayName 'm2menuname',CustomContextMenuLinkId3,t3.LinkName 'm3linkname',  
  m3.DisplayName 'm3menuname',CustomContextMenuTxt1 'm1txt',CustomContextMenuTxt2 'm2txt',CustomContextMenuTxt3 'm3txt'  
  from obps_TopLinkExtended TE   
   inner join obps_TopLinks T on T.id=TE.Linkid  
   inner join obps_MenuName M on M.MenuId=T.MenuId  
   left join  obps_TopLinks T1 on T1.id=TE.CustomContextMenuLinkId1  
   left join obps_MenuName M1 on M1.MenuId=T1.MenuId  
   left join  obps_TopLinks T2 on T2.id=TE.CustomContextMenuLinkId2  
   left join obps_MenuName M2 on M2.MenuId=T1.MenuId  
   left join  obps_TopLinks T3 on T3.id=TE.CustomContextMenuLinkId3  
   left join obps_MenuName M3 on M3.MenuId=T3.MenuId   
   where linkid=@linkid  
  
 END  
 ELSE  
 BEGIN  
   select TE.ID,M.DisplayName,T.linkname,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp  
  ,AfterSaveSp,IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled  
  ,RefreshSp,IsYellowBtn,YellowBtnSp,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit  
  ,DependentGrid,AllowHScrollBar,CustomContextMenuLinkId1,t1.LinkName 'm1linkname',m1.DisplayName 'm1menuname', CustomContextMenuLinkId2,  
  t2.LinkName 'm2linkname',m2.DisplayName 'm2menuname',CustomContextMenuLinkId3,t3.LinkName 'm3linkname',  
  m3.DisplayName 'm3menuname',CustomContextMenuTxt1 'm1txt',CustomContextMenuTxt2 'm2txt',CustomContextMenuTxt3 'm3txt'  
  from obps_TopLinkExtended TE   
   inner join obps_TopLinks T on T.id=TE.Linkid  
   inner join obps_MenuName M on M.MenuId=T.MenuId  
   left join  obps_TopLinks T1 on T1.id=TE.CustomContextMenuLinkId1  
   left join obps_MenuName M1 on M1.MenuId=T1.MenuId  
   left join  obps_TopLinks T2 on T2.id=TE.CustomContextMenuLinkId2  
   left join obps_MenuName M2 on M2.MenuId=T1.MenuId  
   left join  obps_TopLinks T3 on T3.id=TE.CustomContextMenuLinkId3  
   left join obps_MenuName M3 on M3.MenuId=T3.MenuId  
 END  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getGridViewRowBtn]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getGridViewRowBtn]          
@LinkId nvarchar(MAX)='' ,  
@GridId nvarchar(MAX)='' ,  
@username nvarchar(MAX)=''  
AS          
BEGIN       
	declare @count int=0
	set @count=(select len(ltrim(rtrim(GridRowButtonText))) from obps_TopLinkExtended where Linkid=@LinkId  and GridId=@GridId )
	if(@count>0)
		select GridRowButtonText,GridRowButtonColWidth from obps_TopLinkExtended where Linkid=@LinkId  and GridId=@GridId       
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getImportRecords]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getImportRecords]            
AS            
BEGIN            
    
select T.id 'toplinkid',I.id 'importconfigid',DisplayName,LinkName,    
TableName,TempTableName,InsertSp,GenFileSp,deletesp,ImportErrorOutSp,    
ImportSavedOutSp from obps_toplinks T    
left join obps_excelimportconfig I on T.id=I.linkid    
inner join obps_MenuName M on T.MenuId=M.MenuId    
where T.IsImportEnabled=1    
    
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getIsGridDDL]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getIsGridDDL]  
@LinkId nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @IsDdlSp nvarchar(MAX)  
  
SET @IsDdlSp= (select DdlSp from obps_TopLinks where id=@LinkId)  
  
if(ltrim(rtrim(len(@IsDdlSp)))>0)  
 select '1'  
else  
 select '0'  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getIsImport]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getIsImport]  
@LinkId nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @IsEnable int=0  
SET @IsEnable= (select IsImportEnabled from obps_TopLinks where id=@LinkId)  
select @IsEnable  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getIsUpload]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getIsUpload]
@LinkId nvarchar(MAX)=''
AS
BEGIN
DECLARE @IsEnable int=0
SET @IsEnable= (select IsUploadEnabled from obps_TopLinks where id=@LinkId)
select @IsEnable
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getLeftLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getLeftLink]
@Username  NVARCHAR(MAX)=NULL
AS
BEGIN
select LinkId,LinkName,Type from Obps_LFLinks where LinkId in(
select LinkId from Obps_UserLinks where userid =
(select Id from Obps_Users where UserName=@Username))
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getLink]
@id nvarchar(MAX)=''
AS
BEGIN
	if @id<>''
		select id,LinkName from obps_TopLinks where id=@id
	else
		select id,LinkName from obps_TopLinks
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getLinkDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[obps_sp_getLinkDetailsDisplay]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getLinkDetailsDisplay]    
@Id int    
AS    
BEGIN    
select LinkName,Type,T.MenuId,SortOrder,IsAfterLogin,IsImportEnabled,IsMobile
		,EnableUniversalSearch,IsLocation,IsSamePage,ConditionalCRUDBtn,CondCRUDBtnAddSp,
		CondCRUDBtnEditSp ,CondCRUDBtnDeleteSp,CSVSeperator

--select Grid1Sp ,Grid2Sp,Grid3Sp,Grid4Sp,Grid5Sp,LinkName,Type,Grid1Table,    
--Grid2Table,Grid3Table,Grid4Table,Grid5Table,M.DisplayName,SortOrder,IsAfterLogin,    
--Grid1AllowAdd,Grid2AllowAdd,Grid3AllowAdd,Grid4AllowAdd,Grid5AllowAdd,    
--Grid1AllowEdit,Grid2AllowEdit,Grid3AllowEdit,Grid4AllowEdit,Grid5AllowEdit,    
--Grid1AllowDelete,Grid2AllowDelete,Grid3AllowDelete,Grid4AllowDelete,Grid5AllowDelete,  
--IsImportEnabled, ImportErrorOutSp,ImportSavedOutSp,ImportHelp,--(30,31,32,33)  
--case when tid.ForeignKey is null then  ''  else tid.ForeignKey end as 'ForeignKey',Type  as'Pagetype'  
from obps_TopLinks T    
inner join obps_MenuName M on T.MenuId=M.Id left join obps_TableId tid on tid.LinkId=T.id    
where T.id=@Id    
END    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getLinkDetailsMob]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getLinkDetailsMob]                
@Id int=''                
AS                
BEGIN                
   select Id,Type,case when IsSamePage is null then 0 else IsSamePage end     
   from obps_TopLinks where id=@Id              
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getLinkName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getLinkName]    
@id nvarchar(MAX)=''
AS    
BEGIN    
	IF @id=''
		select Id,LinkName from obps_TopLinks
	ELSE
		select Id,LinkName from obps_TopLinks where MenuId=@id
END   
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetLocationDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetLocationDetails] 
@linkId nvarchar(2)=''  
AS  
BEGIN
DECLARE @IsLocation nvarchar(2) =0
SET @IsLocation=(select IsLocation from obps_TopLinks where id=@linkId)
if @IsLocation is null  
	set @IsLocation=0;  

select @IsLocation

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getMaxBatchid]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec obps_sp_getMaxBatchid @tablename=N'26'  
  
CREATE PROCEDURE [dbo].[obps_sp_getMaxBatchid]    
@tablename nvarchar(MAX)=''   ,
@linkid nvarchar(MAX)=''
AS    
BEGIN    
DECLARE @str nvarchar(MAX)    
DECLARE @sout int=0    
set @tablename=(select TempTableName from obps_ExcelImportConfig where LinkId=@linkid)
set @str=('SELECT isnull(MAX(batchid),0) from '+@tablename)  
--select @str    
EXEC Sp_executesql  @str,N'@sout int output',  @sout output    
--if @sout is null  
--BEGIN  
-- SET @sout= 0  
--END  
--ELSE  
--BEGIN  
-- SELECT @sout  
--END  
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getMenuName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getMenuName]     
@id nvarchar(MAX)=''  ,
@populateddl nvarchar(MAX)=''
AS      
BEGIN  
if @populateddl=''
BEGIN
	 if @id=''  
	 BEGIN  
		select Id,DisplayName from obps_MenuName where IsVisible=1  
	 END  
	 ELSE  
	 BEGIN  
		select Id,DisplayName,IsVisible from obps_MenuName where id=@id  
	 END  
END
ELSE
BEGIN
	if @populateddl='yes'
		select Id,DisplayName from obps_MenuName
	ELSE
		select Id,DisplayName from obps_MenuName where IsVisible=1 
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getMenuNameByCond]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_getMenuNameByCond]                 
@PageType nvarchar(MAX)=''            
AS                  
BEGIN              
 if @PageType='gantt'            
 BEGIN            
  select Id,DisplayName from obps_MenuName where IsVisible=1 and  id in(select menuid from obps_TopLinks where Type in(4,3))            
 END            
 ELSE  if @PageType='import'            
 BEGIN          
   select Id,DisplayName from obps_MenuName where IsVisible=1 and     
 id in(select menuid from obps_TopLinks where IsImportEnabled=1)         
 END    
 ELSE  if @PageType='dashboard'            
 BEGIN          
   select Id,DisplayName from obps_MenuName where IsVisible=1 and     
 id in(select menuid from obps_TopLinks where type=55)         
 END    
 ELSE  if @PageType='chart'            
 BEGIN          
   select Id,DisplayName from obps_MenuName where IsVisible=1 and  id in(select menuid from obps_TopLinks where Type in(21,22,23,24,2526,27))            
 END          
 ELSE          
 BEGIN          
 if @PageType='attach'            
   select Id,DisplayName from obps_MenuName where IsVisible=1 and  (id in(select menuid from obps_TopLinks where Type =19)          
   or id in(select menuid from obps_TopLinks where IsUploadEnabled=1) )          
 END            
END         
        
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getMenuNameByUserName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getMenuNameByUserName]
@userid int
AS
BEGIN

select distinct LinkId,LinkName from obps_UserLinks 
where UserId=@userid and  IsActive=1 and TRIM(LinkName)<>''

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getMenuNameDashboard]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getMenuNameDashboard]
AS
BEGIN

select T.Id 'Id',DisplayName from obps_toplinks T
inner join obps_MenuName M on T.MenuId=M.MenuId
where T.Type=55

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getMenuNameEdit]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getMenuNameEdit]   
@id nvarchar(MAX)=''
AS    
BEGIN    
 if @id=''
 BEGIN
	select Id,DisplayName from obps_MenuName --where IsVisible=1
 END
 ELSE
 BEGIN
	select Id,DisplayName,IsVisible from obps_MenuName where id=@id
 END
END   
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getNonWorkingDays]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getNonWorkingDays] 
@ClientId nvarchar(MAX)='', 
@username nvarchar(MAX)='', 
@year nvarchar(MAX)='', 
@month nvarchar(MAX)='' 
AS BEGIN  
DECLARE @SearchLetter nvarchar(MAX)=''  
SET @SearchLetter ='%'+ @username + '%'   

if(@ClientId=null or @ClientId='')  
begin   
	select DAY(NonWorkingDays),FORMAT(NonWorkingDays,'MM/dd/yyyy') from obps_NonWorkingDays where ClientId=   ( select top 1 id from obp_ClientMaster where AccessToUser like  @SearchLetter      
	 order by id asc)   --(select top 1 ID from obp_ClientMaster where AccessToUser like  @SearchLetter)    and year(NonWorkingDays)=@year and month(NonWorkingDays)=@month  
 end  
 else  
 begin   
	 select DAY(NonWorkingDays),FORMAT(NonWorkingDays,'MM/dd/yyyy') from
	 obps_NonWorkingDays where ClientId=@ClientId   and year(NonWorkingDays)=@year and month(NonWorkingDays)=@month  
 end 
 END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetPageLayoutImport]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetPageLayoutImport]  
@LinkId int=''  
AS  
BEGIN  
 select Type from obps_TopLinks where id=@linkid
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getPageType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getPageType]    
@Id int=''   
AS    
BEGIN    
 if @id=''  
 begin  
  select PageTypeId,PageType from obps_PageType order by PageType asc 
 end  
 else  
 begin  
  select id,PageType from obps_PageType where id=@Id  
 end  
END   
    
  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getPaymentClient]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[obps_sp_getPivotData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getPivotData]
AS
BEGIN
select classification,Start_Date,demand from OBP_PRJ_011
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getPivotFieldChooser]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getPivotFieldChooser]
@linkid int=''
AS
BEGIN

select AllowPivotFieldChooser from obps_TopLinks where id=@linkid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetPivotViewData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetPivotViewData]
@Gridname NVARCHAR(MAX)=NULL,
@lId nvarchar(MAX) = ''
AS
BEGIN

	DECLARE @spname NVARCHAR(MAX),
	@spquery nvarchar(MAX)

	SET @spquery=('(SELECT @spname='+@Gridname+' FROM obps_TopLinks where '+@Gridname+'  is not null and Id='''+@lId+''')')
	EXEC Sp_executesql  @spquery,  N'@spname NVARCHAR(MAX) output',  @spname output
	if(len(ltrim(rtrim(@spname)))>1)
	Exec @spname
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getReadOnly]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getReadOnly]
@clientid NVARCHAR(MAX)=NULL,
@RoleId NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL,
@GridId nvarchar(5)=''
AS
BEGIN
 
		DECLARE @query NVARCHAR(MAX),
	   @query_colorid NVARCHAR(MAX),
	   @tabname NVARCHAR(MAX),
	   @cid NVARCHAR(MAX),
	   @sptablequery NVARCHAR(MAX) ,
	   @spname NVARCHAR(MAX),
	   @query_color NVARCHAR(MAX),
	   @colorname NVARCHAR(MAX),
	   @iRoleId int,
	   @GridTabName nvarchar(max)='',
	   @Gridname nvarchar(MAX),
	   @GridTableName nvarchar(MAX),
	   @tasktype nvarchar(MAX)

    SET NOCOUNT ON;
 
	set @GridTabName='Grid'+@GridId+'Table'
	SET @sptablequery=('(SELECT @GridTableName='+@GridTabName+' FROM Obps_TopLinks where Id='''+@LinkId+''')')
	EXEC Sp_executesql  @sptablequery,  N'@GridTableName NVARCHAR(MAX) output',  @GridTableName output

	SET @sptablequery=('(SELECT @tasktype=th_tasktype FROM '+@GridTableName+' where clientid='''+@clientid+''')')
	EXEC Sp_executesql  @sptablequery,  N'@tasktype NVARCHAR(MAX) output',  @tasktype output
	--select @tasktype
	IF @tasktype='Demo Task'
	BEGIN
		Select '1'
	END
	ELSE
	BEGIN
		Select '0'
	END

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetReportViewerId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GetReportViewerId]  
@usrname nvarchar(MAX)='',  
@linkid nvarchar(MAX)=''  
AS  
BEGIN  
  
Select top 1  id from obps_ReportLayout where LinkId=@linkid  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetRoleDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetRoleDetails]
@sublink int=0,
@roleid int=0,
@gid int=0
AS
BEGIN

select R.ID,RoleId 'role',M.DisplayName 'mainmenu',T.LinkName 'sublink',Tid.TableID,ColName 'colname',IsEditable,
R.TableName 'tabname',R.gridid 'gid',R.IsMobile,R.LinkId,COALESCE(R.IsVisible,0) 'IsVisible',VisibilityIndex 
from obps_RoleMap R
inner join obps_TopLinks T on T.id=R.LinkId
inner join obps_MenuName M on M.MenuId=T.MenuId
inner join obps_TableId Tid on Tid.TableID=R.tableid
where R.LinkId=@sublink and R.gridid=@gid and R.RoleId=@roleid

END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetRoleMapDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetRoleMapDetails]  
 @tablename nvarchar(MAX)=''  
AS  
BEGIN  
 SELECT [RoleId], [ColName],data_type as 'datatype', 1, [IsEditable], [TableName], [Displayorder], [gridid]   
 FROM [obps_RoleMap] r inner join INFORMATION_SCHEMA.COLUMNS  i  
 on r.TableName=i.TABLE_NAME  
 WHERE [TableName]=@tablename  
END  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getRowAttrib]
--declare
@Gridname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
	   DECLARE @tabquery NVARCHAR(MAX),
	   @gridid VARCHAR(MAX),
	   @query NVARCHAR(MAX)


    SET NOCOUNT ON;

	--SET @tabquery=('(SELECT @tabname='+@Gridname+' FROM Obps_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
	--EXEC Sp_executesql  @tabquery,  N'@tabname NVARCHAR(MAX) output',  @tabname output

	SET @gridid=SUBSTRING(@Gridname,5,1)
	
	set  @query=('select LOWER(colname)+''__''+LOWER(TableName),LOWER(MappedCol),LOWER(IsBackground) 
	from obps_RowAttrib where GridId='+@gridid+' and (colname is not null and colname<>''''and LinkId='''+@LinkId+''')
	UNION
	select colname,LOWER(MappedCol),LOWER(IsBackground) 
	from obps_calculatedRowAttrib where GridId='+@gridid+' and (colname is not null and colname<>''''and LinkId='''+@LinkId+''')')
	EXEC Sp_executesql @query

	--select @query

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttrib_bgcolor]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getRowAttrib_bgcolor]
--declare
@Gridname NVARCHAR(MAX)=NULL,
@colname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL,
@Id NVARCHAR(MAX) =NULL
AS
BEGIN
	   DECLARE @query NVARCHAR(MAX),
	   @query_colorid NVARCHAR(MAX),
	   @tabname NVARCHAR(MAX),
	   @cid NVARCHAR(MAX),
	   @spquery NVARCHAR(MAX) ,
	   @spname NVARCHAR(MAX),
	   @query_color NVARCHAR(MAX),
	   @colorname NVARCHAR(MAX),
	   @MappedColmn nvarchar(MAX),
	   @colname_new nvarchar(MAX),
	   @indx int

    SET NOCOUNT ON;
 
	SET @indx=(select CHARINDEX ('__',@colname,0 ))
	SET @colname_new=(SELECT SUBSTRING(@colname, 1, @indx-1))
	set @tabname=(SELECT SUBSTRING(@colname, @indx+2,LEN(@colname)))

	set @MappedColmn=(select MappedCol from obps_RowAttrib where TableName=@tabname and colname=@colname_new and MappedCol like '%_color')

	--SET @query_colorid=('select id,'+@MappedColmn+' from '+@tabname+' where '+@MappedColmn+' is not null and '+@MappedColmn+'!='' ''')
	--EXEC Sp_executesql @query_colorid

	set  @query_colorid=('select th.id,Hexcode from '+@tabname+' th inner join obps_colorpicker clr on '+@MappedColmn+'=clr.ColorID  where th.id='+@Id+' and '+@MappedColmn+' is not null and ColorID is not null and '+@MappedColmn+'!='' ''')
	EXEC Sp_executesql @query_colorid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttrib_color]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getRowAttrib_color]
@Gridname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
SET NOCOUNT ON;

DECLARE @col NVARCHAR(MAX)='',
		@query_colorid NVARCHAR(MAX)='',
		@columnname NVARCHAR(MAX)='',
		@spquery NVARCHAR(MAX)='',
		@tabname NVARCHAR(MAX)=''

IF OBJECT_ID('tempdb..#temp1') IS NOT NULL 
BEGIN 
    DROP TABLE #temp1 
END
CREATE TABLE #temp1
(
	Id INT,
	columns NVARCHAR(MAX),
	hexacode NVARCHAR(MAX),
	columnname NVARCHAR(MAX)

)
SET @spquery=('(SELECT @tabname='+@Gridname+' FROM Obps_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
EXEC Sp_executesql  @spquery,  N'@tabname NVARCHAR(MAX) output',  @tabname output

DECLARE CUR_TEST CURSOR FAST_FORWARD FOR
SELECT MappedCol,colname+'__'+@tabname FROM obps_RowAttrib where TableName=@tabname and MappedCol like '%_color'
 
OPEN CUR_TEST
FETCH NEXT FROM CUR_TEST INTO @col,@columnname
 
WHILE @@FETCH_STATUS = 0
BEGIN

		SET @query_colorid=('insert into #temp1 select th.id,'+@col+',Hexcode,'''+@columnname+'''
		 from obp_TaskHeader th inner join obps_colorpicker clr on '+@col+'=clr.ColorID  where '+@col+' is not null and '+@col+'!='' ''')
		EXEC Sp_executesql @query_colorid

	   FETCH NEXT FROM CUR_TEST INTO @col,@columnname
	 
END
CLOSE CUR_TEST
DEALLOCATE CUR_TEST
SELECT * FROM #temp1
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttrib_fontcolor]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getRowAttrib_fontcolor]
@Gridname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
SET NOCOUNT ON;

DECLARE @col NVARCHAR(MAX)='',
		@query_colorid NVARCHAR(MAX)='',
		@columnname NVARCHAR(MAX)='',
		@spquery NVARCHAR(MAX)='',
		@tabname NVARCHAR(MAX)=''

IF OBJECT_ID('tempdb..#temp1') IS NOT NULL 
BEGIN 
    DROP TABLE #temp1 
END
CREATE TABLE #temp1
(
	Id INT,
	columns NVARCHAR(MAX),
	hexacode NVARCHAR(MAX),
	columnname NVARCHAR(MAX)

)
SET @spquery=('(SELECT @tabname='+@Gridname+' FROM Obps_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
EXEC Sp_executesql  @spquery,  N'@tabname NVARCHAR(MAX) output',  @tabname output

DECLARE CUR_TEST CURSOR FAST_FORWARD FOR
SELECT MappedCol,colname+'__'+@tabname FROM obps_RowAttrib where TableName=@tabname and MappedCol like '%_color'
 
OPEN CUR_TEST
FETCH NEXT FROM CUR_TEST INTO @col,@columnname
 
WHILE @@FETCH_STATUS = 0
BEGIN
		SET @query_colorid=('insert into #temp1 select th.id,'+@col+',Hexcode,'''+@columnname+'''
		 from '+@tabname+' th inner join obps_colorpicker clr on '+@col+'=clr.ColorID  where '+@col+' is not null and '+@col+'!='' ''')
		EXEC Sp_executesql @query_colorid

	   FETCH NEXT FROM CUR_TEST INTO @col,@columnname
	 
END
CLOSE CUR_TEST
DEALLOCATE CUR_TEST
SELECT * FROM #temp1  order by Id asc
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttrib_old]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getRowAttrib_old]
--declare
@Gridname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
	   DECLARE @tabquery NVARCHAR(MAX),
	   @gridid VARCHAR(MAX),
	   @query NVARCHAR(MAX)


    SET NOCOUNT ON;

	--SET @tabquery=('(SELECT @tabname='+@Gridname+' FROM Obps_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
	--EXEC Sp_executesql  @tabquery,  N'@tabname NVARCHAR(MAX) output',  @tabname output

	SET @gridid=SUBSTRING(@Gridname,5,1)

	set  @query=('select LOWER(colname)+''__''+LOWER(TableName),LOWER(MappedCol),LOWER(IsBackground) 
	from obps_RowAttrib where GridId='+@gridid+' and (colname is not null or colname<>'''')') -- colname<>''''and  colname is not null)
	EXEC Sp_executesql @query
	--select @query

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttribCellEdit]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obps_sp_getRowAttribCellEdit]            
--declare            
@Gridname NVARCHAR(MAX)=NULL,            
@LinkId NVARCHAR(MAX)=NULL            
AS            
BEGIN            
    DECLARE @tabquery NVARCHAR(MAX),            
    @gridid VARCHAR(MAX),            
    @query NVARCHAR(MAX)            
            
            
    SET NOCOUNT ON;            
            
 SET @gridid=SUBSTRING(@Gridname,5,1)            
   select LOWER(CellEditColName)+'__'+LOWER(tablename),LOWER(MappedCol)             
 from obps_RowAttrib where GridId=@gridid and len(CellEditColName)>0 and LinkId=@LinkId         
        
 --set  @query=('select LOWER(CellEditColName),LOWER(ColName)+''__''+LOWER(tablename),LOWER(IsBackground)             
 --from obps_RowAttrib where GridId='+@gridid+' and (CellEditColName is not null or CellEditColName<>''''and LinkId='''+@LinkId+''')')            
 --EXEC Sp_executesql @query            
 --select @query            
            
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttribControlType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[obps_sp_getRowAttribControlType]    
--declare    
@Gridname NVARCHAR(MAX)=NULL,    
@LinkId NVARCHAR(MAX)=NULL    
AS    
BEGIN    
    DECLARE @tabquery NVARCHAR(MAX),    
    @gridid VARCHAR(MAX),    
    @query NVARCHAR(MAX)    
    
    
    SET NOCOUNT ON;    
    
 --SET @tabquery=('(SELECT @tabname='+@Gridname+' FROM Obps_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')    
 --EXEC Sp_executesql  @tabquery,  N'@tabname NVARCHAR(MAX) output',  @tabname output    
    
 SET @gridid=SUBSTRING(@Gridname,5,1)    
     
 set  @query=('select LOWER(CellCtrlTypeColName)+''__''+LOWER(TableName),LOWER(MappedCol),LOWER(DdlCtrlSpColName)     
 from obps_RowAttrib where GridId='+@gridid+' and   
 (CellCtrlTypeColName is not null and CellCtrlTypeColName<>''''and LinkId='''+@LinkId+''')    
  
 UNION    
  
 select CellCtrlTypeColName,LOWER(MappedCol),LOWER(DdlCtrlSpColName)     
 from obps_calculatedRowAttrib where GridId='+@gridid+' and   
 (CellCtrlTypeColName is not null and CellCtrlTypeColName<>''''and LinkId='''+@LinkId+''')')    
 EXEC Sp_executesql @query    
    
 --select @query    
    
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getStoredProcedureName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getStoredProcedureName]
AS
BEGIN
	Select [NAME] as 'spname' from sysobjects where type = 'P' and category = 0 and name like '%obp_sp%'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getSubLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getSubLink]      
@Username  NVARCHAR(MAX)='' ,    
@linkid int='',
@IsMob NVARCHAR(MAX)=''
AS      
BEGIN      
 if @Username<>'' and @linkid<>'' and @IsMob=''
 BEGIN    
 select Id,linkname from obps_toplinks where Id in(    
 select sublinkid from Obps_UserLinks where userid =      
 (select Id from Obps_Users where UserName=@Username) 
 and IsDeleted=0 and linkid=@linkid)  order by SortOrder    
END    
else if @Username<>'' and @linkid='' and @IsMob='' 
BEGIN    
 select Id,linkname from obps_toplinks where Id in(    
 select sublinkid from Obps_UserLinks where userid =      
 (select Id from Obps_Users where UserName=@Username)and IsDeleted=0 )  order by SortOrder    
END    
else if @Username<>'' and @linkid='' and @IsMob='yes' 
BEGIN    
 select Id,linkname from obps_toplinks where Id in(    
 select sublinkid from Obps_UserLinks where userid =      
 (select Id from Obps_Users where UserName=@Username)and IsDeleted=0 )
 and IsMobile=1 order by SortOrder    
END 
ELSE    
BEGIN    
 select  Id,linkname from obps_toplinks where MenuId=@linkid  order by SortOrder  
END    
END   
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getSubLinkDashboard]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getSubLinkDashboard]
@linkid nvarchar(MAX)=''
AS
BEGIN

select Id,LinkName from obps_TopLinks where MenuId=@linkid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getSublinkName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getSublinkName]
@linkid nvarchar(MAX)=''
AS
BEGIN
	select LinkName from obps_TopLinks where id=@linkid
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getSubMenu]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getSubMenu]
@linkid int=''  
AS  
BEGIN

 select  id,linkname from obps_TopLinks where MenuId=@linkid  order by SortOrder    
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getTabDDLCount]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getTabDDLCount]
@linkid int='',
@gridid int='',
@username nvarchar(MAX)=''
AS
BEGIN
declare @count int=0;

SET @count=@count+(select case when len(ToolBarDDLTxt1)>0 then 1 else 0 end from obps_toplinkextended where linkid=@linkid and gridid=@gridid)
SET @count=@count+(select case when len(ToolBarDDLTxt2)>0 then 1 else 0 end from obps_toplinkextended where linkid=@linkid and gridid=@gridid)
SET @count=@count+(select case when len(ToolBarDDLTxt3)>0 then 1 else 0 end from obps_toplinkextended where linkid=@linkid and gridid=@gridid)

SELECT @count

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getTabDDLValues]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getTabDDLValues]
@linkid int='',
@gridid int='',
@ddlno int='',
@username nvarchar(MAX)=''
AS
BEGIN

DECLARE @spname nvarchar(MAX)=''

if @ddlno=1
	SET @spname=(select ToolBarDDLSp1 from obps_TopLinkExtended where Linkid=@linkid and GridId=@gridid)
else if @ddlno=2
	SET @spname=(select ToolBarDDLSp2 from obps_TopLinkExtended where Linkid=@linkid and GridId=@gridid)
else
	SET @spname=(select ToolBarDDLSp3 from obps_TopLinkExtended where Linkid=@linkid and GridId=@gridid)

if len(rtrim(ltrim(@spname)))>0      
 exec @spname @username,@linkid,@gridid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetTableDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetTableDetails]
@tabname nvarchar(MAX)=''
AS
BEGIN
if @tabname<>''
	SELECT COLUMN_NAME,data_type,COLUMN_DEFAULT,case when IS_NULLABLE='YES' then 1 else 0 end as'IS_NULLABLE',case when TableUserCol is null then 0 else 1 end 'isusercol'
	FROM INFORMATION_SCHEMA.COLUMNS Left join obps_TableId on TABLE_NAME=TableName 
	and COLUMN_NAME=TableUserCol
	WHERE TABLE_NAME = @tabname and 
	COLUMN_NAME not in('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')
	ORDER BY ORDINAL_POSITION
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetTableName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GetTableName]        
@dropdowntableddl nvarchar(MAX)='',      
@ddlTables nvarchar(MAX)='',      
@tempTables nvarchar(MAX)=''      
AS        
BEGIN        
if @dropdowntableddl=''      
BEGIN      
 if @ddlTables='' and @tempTables=''      
 BEGIN      
  select id,tableid,lower(t.name) as table_name from sys.tables t         
   inner join obps_TableId on t.name=TableName        
   where t.name like 'obp_%' and  t.name not like 'obps_%'       
         
 END      
 else      
 BEGIN      
  if @tempTables=''      
  BEGIN      
   select name as table_name from sys.tables         
   where name like '%_DDL%' and  name not like 'obps_%'      
  END      
  ELSE      
  BEGIN      
   select name as table_name from sys.tables         
   where name like 'obp_%_temp' and  name not like 'obps_%'      
  END      
  END      
END      
ELSE      
BEGIN      
 select name as table_name from sys.tables         
 where name like 'obp_%' and  name not like 'obps_%' and  name not like 'obp_%_temp'      
END      
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetTableNameDDLConfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GetTableNameDDLConfig]    
@linkid NVARCHAR(MAX)=''--,    
--@menuid NVARCHAR(MAX)=4    
AS    
BEGIN    
    
DECLARE @sp NVARCHAR(MAX)=''   
    
if object_id('TableNameTab','U') is not null    
 DROP TABLE TableNameTab    
    
CREATE TABLE TableNameTab(table_name nvarchar(MAX))    
    
DECLARE cursor_gridsp CURSOR
FOR select gridsp from obps_toplinkextended where Linkid=@linkid;

OPEN cursor_gridsp;

FETCH NEXT FROM cursor_gridsp INTO @sp;

WHILE @@FETCH_STATUS = 0
    BEGIN

	INSERT INTO TableNameTab    
	 SELECT NAME FROM SYSOBJECTS WHERE ID IN (SELECT SD.DEPID  FROM SYSOBJECTS SO,     
	 SYSDEPENDS SD WHERE SO.NAME = @sp AND SD.ID = SO.ID)


	FETCH NEXT FROM cursor_gridsp INTO @sp;
    END;

CLOSE cursor_gridsp;

DEALLOCATE cursor_gridsp;
    
select distinct table_name from TableNameTab    
    
END    

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetTableNameImport]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetTableNameImport]      
@LinkId int=''      
AS      
BEGIN      
 select TempTableName from obps_ExcelImportConfig where linkid=@linkid  
 /*select  replace(TempTableName,'_temp','') TableName from obps_ExcelImportConfig where linkid=@linkid  */
  

END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getTableValues]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getTableValues]    
AS    
BEGIN    
 select Columnname,DataType,AllowNulls as 'Allow Null',DefaultValue,UserColumn from obps_CreateTableTemp
END   
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getToolBarBtn]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getToolBarBtn]        
@LinkId nvarchar(MAX)=''        
AS        
BEGIN        
select IsSpreadSheet,IsPivot  from obps_TopLinks where id=@LinkId        
END    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetToolBarButton]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetToolBarButton]                      
@GridId nvarchar(2)='',                      
@LinkId nvarchar(3)=''                      
AS                      
BEGIN                      
DECLARE @IsAdd nvarchar(MAX),                      
@IsEdit nvarchar(MAX),                      
@IsDelete nvarchar(MAX),                      
@IsExport nvarchar(MAX),                      
@IsFilterRow nvarchar(MAX),                      
@IsHeaderFilter nvarchar(MAX),                      
@IsColumnChooser nvarchar(MAX),                      
@IsPaging nvarchar(MAX),                      
@GridAddName nvarchar(MAX),                      
@GridEditName nvarchar(MAX),                      
@GridDeleteName nvarchar(MAX),                      
@GridExportName nvarchar(MAX),                      
@GridFilterRowName nvarchar(MAX),                      
@GridheaderFilterName nvarchar(MAX),                      
@GridColumnChooserName nvarchar(MAX),                      
@GridPagingName nvarchar(MAX),                      
@GridGroupPanelName nvarchar(MAX),                      
@IsUploadEnabled nvarchar(MAX),                      
@IssearchPanel nvarchar(MAX),                      
@IsGroupPanel nvarchar(MAX),                      
@IsDependentTab nvarchar(MAX) ,      
@IsHScrollbar nvarchar(MAX),                
@IsFormEdit int=0,@IsRefresh int=0,@IsRed int=0,@IsYellow int=0,@IsGreen int=0,              
@IsImportFromExcel int=0  ,      
@CustomContextMenuTxt1 nvarchar(MAX),         
@CustomContxtMenuLId1 nvarchar(MAX),         
@CustomContextMenuTxt2 nvarchar(MAX),         
@CustomContxtMenuLId2 nvarchar(MAX),       
@CustomContextMenuTxt3 nvarchar(MAX),         
@CustomContxtMenuLId3 nvarchar(MAX),                                                                                                                                                                                                                                                              
@ToolbarDDLTxt1 nvarchar(MAX),@ToolbarDDLSp1 nvarchar(MAX),                                                                                                                                                                                    
@ToolbarDDLTxt2 nvarchar(MAX),@ToolbarDDLSp2 nvarchar(MAX),
@ToolbarDDLTxt3 nvarchar(MAX),@ToolbarDDLSp3 nvarchar(MAX)
                    
SET @IsAdd=(select AllowAdd from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsEdit=(select AllowEdit from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsDelete=(select AllowDelete from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsExport=(select IsExport from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsFilterRow=(select AllowFilterRow from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsHeaderFilter=(select AllowheaderFilter from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsColumnChooser=(select AllowColumnChooser from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsPaging=(select AllowPaging from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                    
SET @IsGroupPanel=(select AllowGroupPanel from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                 
SET @IsImportFromExcel=(select IsImportEnabled from obps_TopLinks where id=@LinkId)               
                      
if @IsExport is null                      
set @IsExport=0;                      
                     
if @IsFilterRow is null                      
set @IsFilterRow=0;                      
                      
if @IsHeaderFilter is null                      
set @IsHeaderFilter=0;                      
                      
if @IsColumnChooser is null                      
set @IsColumnChooser=0;                      
                    
if @IsPaging is null                      
set @IsPaging=0;                 
              
if @IsImportFromExcel is null                      
set @IsImportFromExcel=0;               
                      
SET @IsUploadEnabled=(select IsUploadEnabled from obps_TopLinks where id=@LinkId)                      
if @IsUploadEnabled is null                      
set @IsUploadEnabled=0;                      
                      
if @IsGroupPanel is null                      
set @IsGroupPanel=0;                      
                      
SET @IssearchPanel=(select EnableUniversalSearch from obps_TopLinks where id=@LinkId)                      
if @IssearchPanel is null                      
set @IssearchPanel=0;                      
          
--SET @IsDependentTab=(select IsDependentTab from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
--if @IsDependentTab is null                      
--set @IsDependentTab=0;                      
                      
SET @IsFormEdit=(select IsFormEdit from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)         
if @IsFormEdit is null                      
set @IsFormEdit=0;                  
                
SET @IsRefresh=(select RefreshEnabled from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @IsRefresh is null                     
set @IsRefresh=0;                 
                
SET @IsRed=(select IsRedBtn from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @IsRed is null                 
set @IsRed=0;                 
                
SET @IsYellow=(select IsYellowBtn from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                   
if @IsYellow is null                      
set @IsYellow=0;                 
                
SET @IsGreen=(select IsGreenBtn from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @IsGreen is null                      
set @IsGreen=0;                 
      
SET @IsHScrollbar=(select AllowHScrollBar from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @IsHScrollbar is null                      
set @IsHScrollbar=0;      
                
SET @CustomContextMenuTxt1=(select CustomContextMenuTxt1 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContextMenuTxt1 is null                      
set @CustomContextMenuTxt1='';      
      
SET @CustomContxtMenuLId1=(select CustomContextMenuLinkId1 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContxtMenuLId1 is null                      
set @CustomContxtMenuLId1='';      
      
SET @CustomContextMenuTxt2=(select CustomContextMenuTxt2 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContextMenuTxt2 is null                      
set @CustomContextMenuTxt2='';      
      
SET @CustomContxtMenuLId2=(select CustomContextMenuLinkId2 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContxtMenuLId2 is null                      
set @CustomContxtMenuLId2='';     
    SET @CustomContextMenuTxt3=(select CustomContextMenuTxt3 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContextMenuTxt3 is null                      
set @CustomContextMenuTxt3='';      
      
SET @CustomContxtMenuLId3=(select CustomContextMenuLinkId3 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @CustomContxtMenuLId3 is null                      
set @CustomContxtMenuLId3='';     

SET @ToolbarDDLTxt1=(select ToolBarDDLTxt1 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLTxt1 is null                      
set @ToolbarDDLTxt1='';     
    
SET @ToolbarDDLTxt2=(select ToolBarDDLTxt2 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLTxt2 is null                      
set @ToolbarDDLTxt2='';      
      
SET @ToolbarDDLTxt3=(select ToolBarDDLTxt3 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLTxt3 is null                      
set @ToolbarDDLTxt3=''; 

SET @ToolbarDDLSp1=(select ToolBarDDLSp1 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLSp1 is null                      
set @ToolbarDDLSp1='';     
    
SET @ToolbarDDLSp2=(select ToolBarDDLSp2 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLSp2 is null                      
set @ToolbarDDLSp2='';      
      
SET @ToolbarDDLSp3=(select ToolBarDDLSp3 from obps_TopLinkextended where GridId=@GridId and linkid=@LinkId)                      
if @ToolbarDDLSp3 is null                      
set @ToolBarDDLSp3='';

SELECT @IsAdd,@IsEdit,@IsDelete,@IsExport,@IsFilterRow,@IsHeaderFilter,@IsColumnChooser,@IsPaging,                      
    @IsUploadEnabled,@IsGroupPanel,@IssearchPanel,@IsFormEdit,@IsRefresh,@IsRed,@IsYellow,@IsGreen               
 ,@IsImportFromExcel  ,@IsHScrollbar  ,@CustomContextMenuTxt1,  @CustomContxtMenuLId1,@CustomContextMenuTxt2,    
 @CustomContxtMenuLId2,@CustomContextMenuTxt3,@CustomContxtMenuLId3,@ToolbarDDLTxt1,@ToolbarDDLTxt2,@ToolbarDDLTxt3    
 ,@ToolbarDDLSp1,@ToolbarDDLSp2,@ToolbarDDLSp3   

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getToolbarDDLValues]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getToolbarDDLValues] 
@usrname nvarchar(MAX)='',          
@linkid int='' ,
@gridid int='',
@spname nvarchar(MAX)=''
AS
BEGIN

if len(rtrim(ltrim(@spname)))>0      
 exec @spname @usrname,@linkid,@gridid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetToolbarOption]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetToolbarOption]
@GridId nvarchar(2)='',
@LinkId nvarchar(2)=''
AS
BEGIN
	DECLARE @IsAdd nvarchar(MAX),
	@IsEdit nvarchar(MAX),
	@IsToolbar nvarchar(MAX),
	@GridAddName nvarchar(MAX),
	@GridEditName nvarchar(MAX),
	@GridToolbarName nvarchar(MAX),
	@colnamequery1 nvarchar(MAX),
	@colnamequery2 nvarchar(MAX),
	@colnamequery3 nvarchar(MAX)

	SET @GridAddName='Grid'+@GridId+'AllowAdd'
	SET @GridEditName='Grid'+@GridId+'AllowEdit'
	SET @GridToolbarName='Grid'+@GridId+'AllowToolbar'

	SET @colnamequery1=('(select @IsAdd='+@GridAddName+' from obps_TopLinks where ID='''+@LinkId +''')')
	EXEC Sp_executesql  @colnamequery1,  N'@IsAdd NVARCHAR(MAX) output',  @IsAdd output

	SET @colnamequery2=('(select @IsEdit='+@GridEditName+' from obps_TopLinks where ID='''+@LinkId +''')')
	EXEC Sp_executesql  @colnamequery2,  N'@IsEdit NVARCHAR(MAX) output',  @IsEdit output

	SET @colnamequery3=('(select @IsToolbar='+@GridToolbarName+' from obps_TopLinks where ID='''+@LinkId +''')')
	EXEC Sp_executesql  @colnamequery3,  N'@IsToolbar NVARCHAR(MAX) output',  @IsToolbar output

	SELECT @IsToolbar,@IsAdd,@IsEdit
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetToolBarText]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[obps_sp_GetToolBarText]  
@gridid int=''  
,@linkid nvarchar(3)=''  
,@id int  
AS  
BEGIN  
  
 select ''  
 --select top 1 plant from obp_custdist_header where id=@id  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getTopLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getTopLink]      
@Username  NVARCHAR(MAX)=NULL      
AS      
BEGIN      
select MenuId,DisplayName from obps_menuname where MenuId in(      
select LinkId from Obps_UserLinks where userid =      
(select Id from Obps_Users where UserName=@Username) and isdeleted=0)      
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetTriggerRefresh]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetTriggerRefresh]   
@linkId nvarchar(2)=''    
AS    
BEGIN  

select TriggerGrid,RefreshGrid from obps_TopLinks where id=@linkId  
  
  
END  

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getTypeId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getTypeId]  
@Id INT  
AS  
BEGIN  
if @Id=99999
select 50
else if @Id=99998
select 50
else
select Type from Obps_TopLinks where Id=@Id  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUploadFileMaxBatchid]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getUploadFileMaxBatchid]
AS
BEGIN

	DECLARE @batchid nvarchar(MAX)=''

	SET @batchid=(select max(batchid) from obps_FileUploadedHistory)

	if @batchid is null
		select 0
	else
		select @batchid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUploadPath]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getUploadPath]
@LinkId nvarchar(MAX)='',
@id nvarchar(MAX)=''
AS
BEGIN
DECLARE @clientname nvarchar(MAX)
DECLARE @Uploadpath nvarchar(MAX)
SET @clientname=(select ClientName from obp_clientmaster where id in(select ClientID from obp_TaskHeader where id=@id))
SET @Uploadpath='~/Upload/'+UPPER(@clientname)+'/'
--select Uploadpath from obps_TopLinks where id=@LinkId
select @Uploadpath
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUsercopies]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_getUsercopies]      
AS      
BEGIN      
      
select T.ID      
,UserName      
,RoleId      
,Company      
,Division      
,Department      
,SubDept      
,T.UserTypeId
,UserType 'usertype' 
,M.DisplayName    
,L.LinkName  'submenu'    
,PrefLang      
,AfterLoginSP      
,Permission      
,ReportingManager      
,EmailId     
from obps_Users_temp  T    
left join obps_TopLinks L on T.DefaultLinkId=L.ID     
left join obps_MenuName M on M.MenuId=L.MenuId  
left join obps_usertype U on U.usertypeid=T.UserTypeId
      
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUserId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getUserId]
@User_Name nvarchar(MAX)
AS
BEGIN
SELECT UserId FROM Obp_Users WHERE UserName='hanusha'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetUserLinkbyId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetUserLinkbyId]  
@id nvarchar(MAX)=''
AS  
BEGIN  
 select L.id,linkid,sublinkid,L.LinkName,T.LinkName
  from obps_UserLinks L inner join obps_TopLinks T  
 on L.LinkId=T.MenuId and T.ID=L.sublinkid
 where LOWER(UserName)<>'admin'  and IsDeleted=0 and L.id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetUserLinkDataGrid]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetUserLinkDataGrid]          
@usrname nvarchar(MAX)='',      
@mainmenu nvarchar(MAX)='',      
@submenu nvarchar(MAX)=''      
AS          
BEGIN         
if(@usrname<>'')
	select L.id,userid,username,linkid,L.linkname as 'mainmenu',createddate,        
 createdby,modifiedby,isactive,isdeleted,roleid,T.LinkName as 'sublink',L.IsRoleAttached 'isrole'        
 from obps_UserLinks L inner join obps_TopLinks T          
 on L.LinkId=T.MenuId and T.ID=L.sublinkid        
 where LOWER(UserName)<>'admin'  and IsDeleted=0 
 and username=@usrname order by L.LinkName 
ELSE
select L.id,userid,username,linkid,L.linkname as 'mainmenu',createddate,        
 createdby,modifiedby,isactive,isdeleted,roleid,T.LinkName as 'sublink',L.IsRoleAttached 'isrole'        
 from obps_UserLinks L inner join obps_TopLinks T          
 on L.LinkId=T.MenuId and T.ID=L.sublinkid        
 where LOWER(UserName)<>'admin'  and IsDeleted=0 order by username       
 --and LOWER(UserName)=@usrname and L.LinkId=@mainmenu      
 --and T.ID=@submenu      
 --select L.id,userid,username,linkid,L.linkname as 'mainmenu',createddate,        
 --createdby,modifiedby,isactive,isdeleted,roleid,T.LinkName as 'sublink'        
 --from obps_UserLinks L inner join obps_TopLinks T          
 --on L.LinkId=T.MenuId and T.ID=L.sublinkid        
 --where LOWER(UserName)<>'admin'  and IsDeleted=0        
 --and LOWER(UserName)=@usrname and L.LinkId=@mainmenu      
 --and T.ID=@submenu      
END        
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUserRole]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getUserRole]      
AS      
BEGIN      
 select id,RoleId from obps_RoleMaster order by  roleid asc
 --select ID,clientname as name from obp_ClientMaster      
END     
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUserRoleId]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getUserRoleId]
@User_Name nvarchar(MAX)
AS
BEGIN
SELECT 'Role'+RoleId FROM Obps_Users WHERE UserName=@User_Name
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUserRoles]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getUserRoles]  
@id nvarchar(MAX)=''  
AS  
BEGIN  
 if @id<>''  
  select id,RoleId,RoleDescription from obps_RoleMaster where id=@id  
 else  
  select id,RoleId,RoleDescription from obps_RoleMaster  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUsers]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obps_sp_getUsers]          
@id  nvarchar(MAX)='',          
@populateddl nvarchar(50)='',          
@bindGrid nvarchar(50)=''          
AS          
BEGIN          
if @bindGrid=''          
begin          
 if @id<>'' and @populateddl='no'           
  select U.ID,UserId,UserName,RoleId,Company,Division,Department,SubDept,Password,U.UserTypeId,DefaultLinkId,AfterLoginSP           
  from obps_Users U          
  inner join obps_usertype T on U.UserTypeId=T.UserTypeId          
  where U.id=@id and UserName<>'admin'          
 else           
 begin          
  if @populateddl='yes'          
   select id,username from obps_Users where UserName<>'admin'          
  else          
   select * from obps_Users where UserName<>'admin'          
 end          
end          
else          
begin          
select U.id 'id',UserId,UserName    
  ,R.RoleId 'roleid',    
  emailId,    
  Company,Division,    
  Department,SubDept,    
  U.UserTypeId,UserType,    
  t.MenuId,DisplayName,    
  DefaultLinkId,T.LinkName 'submenu',    
  AfterLoginSP ,ReportingManager          
  from obps_Users U      
  inner join obps_RoleMaster R on  U.RoleId=R.ID     
  inner join obps_usertype UT on U.UserTypeId=UT.UserTypeId    
  left join obps_TopLinks T on t.id=DefaultLinkId    
  left join obps_MenuName M on M.id=T.MenuId    
   where UserName<>'admin'          
end          
END   

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUserTypes]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getUserTypes]  
@id nvarchar(MAX)=''  
AS  
BEGIN  
 if @id<>''  
  select id,UserType,UserTypeDesc from obps_UserType where id=@id   
 else  
  select id,Usertypeid,UserType,UserTypeDesc from obps_UserType where UserType!='admin'  
END  


GO
/****** Object:  StoredProcedure [dbo].[obps_sp_gms_UpdateCalendarDates]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_gms_UpdateCalendarDates]
@linkid nvarchar(MAX)='',
@username nvarchar(MAX)='',
@dateval nvarchar(MAX)='',
@loc nvarchar(25)=''
AS
BEGIN

DECLARE @tablename nvarchar(MAX),@count int=0,
@month nvarchar(20)='',@newday nvarchar(20)=''
set @tablename=(select top 1 gridtable from obps_TopLinkExtended where Linkid=@linkid)
	WHILE LEN(@dateval) > 0
	BEGIN
		DECLARE @TDay VARCHAR(100)
		IF CHARINDEX(',',@dateval) > 0
		--BEGIN
			SET  @TDay = SUBSTRING(@dateval,0,CHARINDEX(',',@dateval))
			--delete from obp_gms_HolidayList
		--END
		ELSE
		BEGIN
			SET  @TDay = @dateval
			SET @dateval = ''
		 END
		 SET @month=(select SUBSTRING(@TDay, CHARINDEX('/', @TDay)+1, LEN(@TDay) -CHARINDEX('/', @TDay)-5))

		if(@month=0)
		BEGIN
			SET @newday=(select SUBSTRING(@TDay, 0,CHARINDEX('/', @TDay))+'/12/'+
						(select SUBSTRING(@TDay, CHARINDEX('/', @TDay)+3, LEN(@TDay) -CHARINDEX('/', @TDay))))
			SET @TDay=@newday
		END

		 set @count =(select count(*) from obp_gms_HolidayList where date=CONVERT(NVARCHAR(255),CONVERT(date, @TDay,105)))
		 if(@count<=0)
		 BEGIN
			
			INSERT INTO obp_gms_HolidayList
			(date) values(CONVERT(NVARCHAR(255),CONVERT(date, @TDay,105)))
		 end
			SET @dateval = REPLACE(@dateval,@TDay + ',' , '')
	END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_insert_record]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_insert_record]                  
@str VARCHAR(MAX)='',                  
@Gridid NVARCHAR(MAX)='',                  
@LinkId NVARCHAR(MAX)='',                   
@forgkey nvarchar(MAX)='',                  
@usr nvarchar(MAX)='',                  
@loc nvarchar(MAX)=''                  
AS                  
BEGIN                  
DECLARE  @Rule_ID int,                  
  @ListType_ID int,                  
  @Values VARCHAR(MAX)=NULL,                  
  @col_name_strings varchar(MAX)='',                  
  @col_val_strings varchar(MAX)='',                  
  @insert_strings nvarchar(MAX)='',                  
  @tabname nvarchar(500)='',                  
  @tabnamequery nvarchar(MAX),                  
  @tab_name nvarchar(500),                  
  @query_Key nvarchar(MAX),                  
  @pkey NVARCHAR(MAX),                  
  @sout NVARCHAR(MAX),                  
  @forkey nvarchar(MAX),                  
  @aftersavespname nvarchar(MAX)='',                  
  @isLocation nvarchar(2)='',                  
  @locationColName nvarchar(max)=''                  
                    
                  
DECLARE @col varchar(MAX)                  
DECLARE @colnew varchar(MAX)=''                  
DECLARE @val varchar(MAX),                  
@indx int,@ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),                  
@controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int                
        
SET @tab_name=(SELECT gridtable FROM Obps_topLinkExtended where Gridid=@Gridid and linkid=@LinkId)                  
                  
--SET @forkeystr=('(select @forkey=ForeignKey from obps_TableId where ForeignKey is not null and tablename='''+@tab_name+''' and Gridid='''+@gridid+'''and linkid='''+@LinkId+''')')                 
--EXEC Sp_executesql  @forkeystr,  N'@forkey NVARCHAR(MAX) output',  @forkey output                  
        
SET @forkey=(select ForeignKey from obps_TableId where ForeignKey is not null and tablename=@tab_name and Gridid=@gridid and linkid=@LinkId)                 
        
IF EXISTS(                  
SELECT TOP 1 * FROM INFORMATION_SCHEMA.COLUMNS                  
WHERE [TABLE_NAME] = @tab_name AND [COLUMN_NAME] = @forkey)                  
BEGIN                 
 IF @forkey<>''                  
 BEGIN                  
  if @col_name_strings<>''                   
  begin                  
    set @col_name_strings=@col_name_strings+ ','                  
    SET @col_name_strings=@col_name_strings+''+@forkey                  
    SET @col_val_strings=@col_val_strings+''','''+@forgkey                  
  END                  
  else                  
  begin                  
    SET @col_name_strings=@col_name_strings+''+@forkey                  
    SET @col_val_strings=''''+@forgkey                  
  END                  
 END                  
END                  
                  
                  
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                  
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval                  
FROM [dbo].[Split] (@str, '^') ;                  
                   
OPEN CUR_TEST                  
FETCH NEXT FROM CUR_TEST INTO @col,@val                  
 --if @val<> 'null'            
 --begin            
            
  WHILE @@FETCH_STATUS = 0                  
  BEGIN                 
  if @val<> 'null'            
  begin            
   if @col <> 'Id' and @col <> 'id1' and @col <> 'CreatedDate'                  
   begin                  
    SET @indx=(select CHARINDEX ('__',@col,0 ))                  
    SET @colnew=(SELECT SUBSTRING(@col, 1,@indx-1))                  
    SET @tabname=(SELECT SUBSTRING(@col, @indx+2, LEN(@col)))                  
   end                  
   if @col <> 'Id' and @col <> 'id1' and @col <> 'CreatedDate'                  
   begin                  
   select '1.0'              
   set @controltype=(select ColControlType from obps_ColAttrib                   
   where ColName=@colnew and TABLENAME = @tabname and linkid=@LinkId)                
   select @controltype 'controltype',@colnew 'colname'              
   if LOWER(@controltype)='dropdownlist'                  
   begin
     print 'Test 1'                  
	 print @colnew
	 print @tabname
	 print @linkid

     SET @colid=(SELECT id from obps_ColAttrib where colname=@colnew AND TABLENAME = @tabname AND linkid=@linkid)                  
     SET @ddlcoltosel=(SELECT columntoselect from obps_dropdowntable where columnid=@colid)                   
     SET @ddlcoltoinsert=(SELECT columntoinsert from obps_dropdowntable where columnid=@colid)                  
     SET @ddltabletosel=(SELECT tabletoselect from obps_dropdowntable where columnid=@colid)                  
     SET @IsId=(SELECT IsId from obps_dropdowntable where columnid=@colid)                  
     select 'Dropdown',@colid,@ddlcoltosel,@ddlcoltoinsert,@ddltabletosel,@IsId                  
     IF @IsId=1                  
     BEGIN                  
   set @queryvalstr='select @ddlid=id from '+@ddltabletosel+' where '+@ddlcoltosel+'='''+@val+''''                  
   select @queryvalstr                  
   EXEC Sp_executesql  @queryvalstr,  N'@ddlid NVARCHAR(MAX) output',  @ddlid output                  
   --select @ddlid                  
   SET @val=@ddlid                  
   --set @colnew='Clientid'                    
     END                  
                  
     if @col_name_strings=''                   
     begin                  
                         
   set @col_name_strings=  RTRIM(LTRIM(@ddlcoltoinsert))                   
   set @col_val_strings= ''''+@val                  
     end                  
     else                   
     begin                  
   set @col_name_strings=@col_name_strings+ ','+  RTRIM(LTRIM(@ddlcoltoinsert))                  
   set @col_val_strings=@col_val_strings+''','''+ @val                  
    end                  
    end                  
   else if @tab_name=@tabname                  
   begin                  
     IF EXISTS(                  
     SELECT TOP 1 *                  
     FROM INFORMATION_SCHEMA.COLUMNS                  
     WHERE [TABLE_NAME] = @tab_name                  
     AND [COLUMN_NAME] = @colnew)                  
     BEGIN                  
                  
   if @col_name_strings=''                   
   begin                  
    select @col_name_strings                  
    set @col_name_strings=  RTRIM(LTRIM(@colnew))                   
    set @col_val_strings= ''''+@val                  
   end                  
   else                   
   begin                  
    set @col_name_strings=@col_name_strings+ ','+  RTRIM(LTRIM(@colnew))                  
    set @col_val_strings=@col_val_strings+''','''+ @val                  
   end                  
     END                  
    end                  
   END                  
                  
    IF @col = 'id1'                  
    BEGIN                  
  IF EXISTS(SELECT TOP 1 * FROM INFORMATION_SCHEMA.COLUMNS                  
  WHERE [TABLE_NAME] = @tab_name AND [COLUMN_NAME] = 'id1')                  
  BEGIN                  
                  
    if @col_name_strings=''                   
    begin                  
     select @col_name_strings                  
     set @col_name_strings=  RTRIM(LTRIM(@col))                   
     set @col_val_strings= ''''+@val                  
    end                  
    else                   
    begin                  
     set @col_name_strings=@col_name_strings+ ','+  RTRIM(LTRIM(@col))                  
     set @col_val_strings=@col_val_strings+''','''+ @val                  
    end                  
  END                  
    END                  
    IF @col = 'CreatedDate'                  
    BEGIN                  
  IF EXISTS(SELECT TOP 1 * FROM INFORMATION_SCHEMA.COLUMNS                  
  WHERE [TABLE_NAME] = @tab_name AND [COLUMN_NAME] = 'CreatedDate')                  
  BEGIN                  
                  
    if @col_name_strings=''                 
    begin                  
     select @col_name_strings                  
     set @col_name_strings=  RTRIM(LTRIM(@col))                   
     set @col_val_strings= ''''+@val                  
    end                  
    else                   
    begin                  
     set @col_name_strings=@col_name_strings+ ','+  RTRIM(LTRIM(@col))                  
     set @col_val_strings=@col_val_strings+''','''+ @val                  
    end                  
  END                  
    END              
    END            
        FETCH NEXT FROM CUR_TEST INTO @col,@val                  
  END                  
  -- END               
  set @col_val_strings=@col_val_strings+''''                
CLOSE CUR_TEST           
DEALLOCATE CUR_TEST                  
if @col_name_strings<>''                   
begin                  
set @col_name_strings=@col_name_strings+ ','                  
--SET @col_name_strings=@col_name_strings+'IsDeleted,IsActive,CreatedDate,Createdby'                  
--SET @col_val_strings=@col_val_strings+',0,1,'''+CONVERT(CHAR(24),  GETDATE(), 121)+''','''+@usr+''''                  
SET @col_name_strings=@col_name_strings+'Createdby'                  
SET @col_val_strings=@col_val_strings+','''+@usr+''''                  
select @col_name_strings as 'colstr',@col_val_strings as 'val'              
END                  
                   
SET @pkey=(SELECT TableKey FROM Obps_TableId WHERE TableName=@tabname)                  
                  
SET @isLocation=(select IsLocation from obps_TopLinks where id=@LinkId)                  
if(@isLocation='1')                  
BEGIN                  
                   
 SET @locationColName=(select locationcolname from obps_locationconfig where linkid=@LinkId)                  
 SET @col_name_strings=@col_name_strings+','+@locationColName                  
 SET @col_val_strings=@col_val_strings+','''+@loc+''''                  
                  
END                  
                  
set @insert_strings='insert into '+@tab_name+'('+@col_name_strings+')values('+@col_val_strings+')'                  
select @tab_name,@insert_strings,@col_name_strings,@col_val_strings                  
EXEC Sp_executesql  @insert_strings--,N'@sout NVARCHAR(MAX) output',  @sout output                  
   declare @lastid int='';                
   SET @lastid=@@IDENTITY                
                
      select * from obps_TopLinkExtended        
        
SET @aftersavespname=(SELECT AfterSaveSp  from obps_TopLinkExtended where GridId=@Gridid and Linkid=@LinkId)                  
                  
 IF len(@aftersavespname)>0                   
 BEGIN                    
 select @aftersavespname,@lastid                
 EXEC @aftersavespname @lastid                   
 END                   
                  
END     
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertColAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertColAttrib]  
@tabname nvarchar(MAX)='',  
@tabid nvarchar(MAX)='',  
@colname nvarchar(MAX)='',  
@usrname nvarchar(MAX)=''  
AS  
BEGIN  
 INSERT INTO [dbo].[obps_ColAttrib]  
      ([TableID],[TableName],[ColName],[DisplayName],[ColControlType]
      ,[IsEditable],[ColColor],[FontColor],[FontAttrib],[CreatedDate],[CreatedBY]  
      ,[ModifiedBy],[IsActive],[IsDeleted],[DropDownLink],[GridId],[ColumnWidth],[LinkId])  
   VALUES  
      (@tabid,@tabname,@colname,@colname,'textbox',1,  
      NULL,NULL,NULL,getdate(),@usrname,  
      '',1,0,NULL,NULL,NULL,NULL)  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertDDLTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertDDLTable]
@colid nvarchar(MAX)='',
@coltoins nvarchar(MAX)='',
@coltosel nvarchar(MAX)='',
@tabtosel nvarchar(MAX)='',
@isid nvarchar(MAX)=''
AS
BEGIN

	insert into obps_DropDownTable values(@colid,@coltoins,@coltosel,@tabtosel,@isid)
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertGanttDataDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertGanttDataDetails]
@LinkId int,
@usr nvarchar(MAX)='',
@predecessorid  nvarchar(10)='',
@successorid nvarchar(10)=''
AS
BEGIN

DECLARE @succid nvarchar(MAX)='',@predeid nvarchar(MAX)=''
,@tabname nvarchar(MAX)='',@string1 nvarchar(MAX)=''
,@string2 nvarchar(MAX)=''

SET @succid=(SELECT successoridColName from obps_GanttConfig where linkid=@LinkId)
SET @predeid=(SELECT PredecessorIdColName from obps_GanttConfig where linkid=@LinkId)
SET @tabname=(SELECT Tablename from obps_GanttConfig where linkid=@LinkId)

SET @string1='update '+@tabname+' set '+@succid+'='+@successorid+' where id='+@predecessorid
SET @string2='update '+@tabname+' set '+@predeid+'='+@predecessorid+' where id='+@successorid 
--update obp_taskheader set SuccessorId=@successorid where id=@predecessorid
--update obp_taskheader set PredecessorId=@predecessorid where id=@successorid
exec (@string1)
exec (@string2)

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertGanttDependency]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertGanttDependency]    
@str nvarchar(MAX)=NULL,        
@LinkId int='',        
@usr nvarchar(MAX)=''       
AS    
BEGIN    
DECLARE @preid nvarchar(MAX),@sid nvarchar(MAX),    
  @string1 nvarchar(MAX),@string2 nvarchar(MAX),    
  @col nvarchar(MAX),@val nvarchar(MAX),@tabname nvarchar(MAX)=''    
    
SET @tabname=(select DependencyTable from Obps_GanttConfiguration where LinkId=@LinkId)    
select @tabname  
    
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR        
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval        
FROM [dbo].[Split] (@str, ',') ;        
         
OPEN CUR_TEST        
FETCH NEXT FROM CUR_TEST INTO @col,@val        
        
 WHILE @@FETCH_STATUS = 0        
 BEGIN     
   if @col = 'predecessorid'        
   begin       
    SET @preid=@val        
   end        
   else if @col = 'successorid'        
   begin        
    SET @sid=@val        
   end      
      
    FETCH NEXT FROM CUR_TEST INTO @col,@val        
 END        
            
CLOSE CUR_TEST        
DEALLOCATE CUR_TEST     
    
    
SET @string1='update '+@tabname +' set predecessorid='+@preid+',successorid='+@sid+' where id='+@preid    
--update obp_GanttData set predecessorid=null,successorid=null where id=@key    
select @string1    
EXEC Sp_executesql  @string1    
    
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertGlobalConfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertGlobalConfig]  
@logo int,
@helpfilepath nvarchar(MAX)=''
AS  
BEGIN  
begin try  
 DECLARE @count int=0;  
 SET @count=(select count(*) from obps_GlobalConfig where Variables='logorequired')  
 if @count=0  
  insert into obps_GlobalConfig(Variables,Value)  
  values('LogoRequired',@logo)  
 else  
  update obps_GlobalConfig set Value=@logo where Variables='logorequired'  

  SET @count=(select count(*) from obps_GlobalConfig where Variables='helpfilepath')  
 if @count=0  
  insert into obps_GlobalConfig(Variables,Value)  
  values('helpfilepath',@helpfilepath)  
 else  
  update obps_GlobalConfig set Value=@helpfilepath where Variables='helpfilepath'  

end try  
begin catch  
 select ERROR_MESSAGE()  
end catch  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertGridProperty]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertGridProperty]  
@id int='',
@operation nvarchar(MAX)='',  
@tabid int='',
@tabtext nvarchar(MAX)='',
@TabType nvarchar(3)='',
@gridno int='',  
@linkid int='',    
@gridsp nvarchar(MAX)='',  
@tablename nvarchar(MAX)='',  
@IsAdd int='',   
@IsEdit int='',  
@IsDelete int='',   
@aftersavesp nvarchar(MAX)='',  
@refreshsp nvarchar(MAX)='',            
@deleteSp nvarchar(MAX)='',
@isredbtn int='',
@redbtnsp nvarchar(MAX)='', 
@isyellowbtn int='',
@yellowbtnsp nvarchar(MAX)='',  
@isgreenbtn int='',
@greenbtnsp nvarchar(MAX)='',
@dependentgrid nvarchar(MAX)='' ,  
@export int='',  
@filterrow int='', 
@headerfilter int='', 
@columnchooser int='',
@grouppanel int='',
@paging int='',
@formedit int='',
@Hscrollbar int='',
@menu1txt nvarchar(MAX)='' ,
@menu1linkid int='',
@menu2txt nvarchar(MAX)='' ,
@menu2linkid int='',
@menu3txt nvarchar(MAX)='' ,
@menu3linkid int=''
AS            
BEGIN            
 DECLARE @ins_id int=0  
 BEGIN TRY
	IF @operation = 'add'            
	BEGIN          
		  INSERT INTO obps_TopLinkextended            
			  (gridid,Linkid,TabId,TabText,TabType,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete
				,DeleteSp,AfterSaveSp,IsExport,AllowFilterRow,AllowheaderFilter
				,AllowColumnChooser,AllowGroupPanel,RefreshEnabled,RefreshSp,IsYellowBtn,YellowBtnSp
				,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit,DependentGrid,AllowHScrollBar
				,CustomContextMenuTxt1,CustomContextMenuLinkId1,CustomContextMenuTxt2,CustomContextMenuLinkId2
				,CustomContextMenuTxt3,CustomContextMenuLinkId3)  
		  values            
			  (@gridno,@linkid,@tabid,@tabtext,@tabtype,@gridsp,@tablename,@IsAdd,@IsEdit,@IsDelete,
			    @deleteSp,@aftersavesp,@export,@filterrow,@headerfilter,
				@columnchooser,@grouppanel,case when len(trim(@refreshsp))>0 then 1 else 0 end,@refreshsp,@isyellowbtn,@yellowbtnsp,
				@isgreenbtn,@greenbtnsp,@isredbtn,@redbtnsp,@paging,@formedit,@dependentgrid,@Hscrollbar,
				@menu1txt,@menu1linkid,@menu2txt,@menu2linkid,@menu3txt,@menu3linkid)  
		  select 'Grid Details Added'            
		  --SET @ins_id=(SELECT SCOPE_IDENTITY())            
		  --exec obps_sp_ColAttribMapping @ins_id     
		  --exec obps_sp_InsertRoleMapping @ins_id    
	END       
	ELSE            
	BEGIN            
		update obps_TopLinkextended set GridId=@gridno,Linkid=@linkid,TabId=@tabid,TabText=@tabtext,
				TabType=@TabType,GridSp=@gridsp,GridTable=@tablename,AllowAdd=@IsAdd,AllowEdit=@IsEdit,AllowDelete=@IsDelete
				,DeleteSp=@deleteSp,AfterSaveSp=@aftersavesp,IsExport=@export,AllowFilterRow=@filterrow,AllowheaderFilter=@headerfilter
				,AllowColumnChooser=@columnchooser,AllowGroupPanel=@grouppanel,RefreshEnabled=case when len(trim(@refreshsp))>0 then 1 else 0 end,
				RefreshSp=@refreshsp,IsYellowBtn=@isyellowbtn,YellowBtnSp=@yellowbtnsp
				,IsGreenBtn=@isgreenbtn,GreenBtnSp=@greenbtnsp,IsRedBtn=@isredbtn,RedBtnSp=@redbtnsp,
				AllowPaging=@paging,IsFormEdit=@formedit,DependentGrid=@dependentgrid,AllowHScrollBar=@Hscrollbar
				,CustomContextMenuTxt1=@menu1txt,CustomContextMenuLinkId1=@menu1linkid,CustomContextMenuTxt2=@menu2txt,CustomContextMenuLinkId2=@menu2linkid
				,CustomContextMenuTxt3=@menu3txt,CustomContextMenuLinkId3=@menu3linkid where id=@id
			select 'Grid Details Updated'
	END    
END TRY  
BEGIN CATCH  
    SELECT  ERROR_NUMBER()  +'  :  '+ERROR_MESSAGE()   
END CATCH  	
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertHelpDoc]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertHelpDoc]    
@FileName nvarchar(MAX)='',    
@usertype nvarchar(MAX)='',    
@GpName nvarchar(MAX)=''    
AS    
BEGIN    
DECLARE @gpid int,@newid int=0    
 BEGIN TRY    
  if((select count(*) from obps_helpdoc where GroupName=@GpName)>0)    
   SET @gpid=(select max(groupid) from  obps_helpdoc where GroupName=@GpName)    
  ELSE    
   SET @gpid=(select max(groupid) from  obps_helpdoc)+1    
    
   INSERT INTO obps_helpdoc    
   (Groupid,GroupName,DisplayName,FileName,IsActive,UserType)    
   values    
   (@gpid,@GpName,@FileName,@FileName,1,@usertype)    
    
  SET @newid=(SELECT @@IDENTITY)     
    
  if(@newid>0)    
   select 'Data Saved'    
  else    
   select 'Not able to save the data'    
 END TRY      
 BEGIN CATCH      
  SELECT  ERROR_MESSAGE()       
 END CATCH     
    
END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertImportRecord]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertImportRecord]              
@linkid nvarchar(MAX)='',     
@Username nvarchar(max)     
AS              
BEGIN              

print 'validity check start'        

Exec obps_sp_GenDataValidityCheck_DataType   @linkid,   @Username    
print 'validity check end'    
/*Execute the Implementer's SP*/    
    
DECLARE @InsertSp nvarchar(MAX)='',@var_ValidRecCount int        
      
set @InsertSp=(select ltrim(rtrim(InsertSp)) from obps_ExcelImportConfig where LinkId=@linkid)        
    
if len(ltrim(rtrim(@InsertSp)))>1      
begin      
/*Implementer SP will have userid as parameter*/    
exec @InsertSp   @Username     
end      
    
/*End - Execute the Implementer's SP*/    
END   
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertLink]              
@operation nvarchar(MAX)='',    
@mainmenu int='',    
@linkid nvarchar(MAX)='',              
@LinkName nvarchar(MAX)='',    
@Type nvarchar(MAX)='',     
@SortOrder int='',    
@UniversalSearch int='',     
@IsLocation int='',    
@IsAfterLogin int='',              
@IsImportEnabled int='',    
@IsMobile int='',    
@IsSamePage int='',    
@CsvSeperator nvarchar(MAX)='' ,    
@ContBtnEnable int='',    
@AddBtnSp nvarchar(MAX)='' ,    
@EditBtnSp nvarchar(MAX)='' ,    
@DeleteBtnSp nvarchar(MAX)=''     
AS              
BEGIN              
 DECLARE @ins_id int=0  
 BEGIN TRY
	 IF @operation = 'add'              
	 BEGIN            
		INSERT INTO obps_TopLinks              
		 (LinkName,Type,MenuId,SortOrder,IsAfterLogin,IsImportEnabled,IsMobile    
		 ,EnableUniversalSearch,IsLocation,IsSamePage,ConditionalCRUDBtn,CondCRUDBtnAddSp,    
		 CondCRUDBtnEditSp ,CondCRUDBtnDeleteSp,CSVSeperator)    
		values              
		 (@LinkName,@Type,@mainmenu,@SortOrder,@IsAfterLogin,@IsImportEnabled,@IsMobile,    
		 @UniversalSearch,@IsLocation,@IsSamePage,@ContBtnEnable,@AddBtnSp,    
		 @EditBtnSp,@DeleteBtnSp,@CsvSeperator)    
		select 'Link Added'              
		--SET @ins_id=(SELECT SCOPE_IDENTITY())              
		--exec obps_sp_ColAttribMapping @ins_id       
		--exec obps_sp_InsertRoleMapping @ins_id      
	 END         
	 ELSE              
	 BEGIN              
	  update obps_TopLinks set LinkName=@LinkName,Type=@Type,MenuId=@mainmenu,  
	   SortOrder=@SortOrder,IsAfterLogin=@IsAfterLogin,IsImportEnabled=@IsImportEnabled,IsMobile=@IsMobile,    
	   EnableUniversalSearch=@UniversalSearch,IsLocation=@IsLocation,IsSamePage=@IsSamePage,  
	   ConditionalCRUDBtn=@ContBtnEnable,CondCRUDBtnAddSp=@AddBtnSp,CondCRUDBtnEditSp=@EditBtnSp ,  
	   CondCRUDBtnDeleteSp=@DeleteBtnSp,CSVSeperator=@CsvSeperator where id=@linkid  
	   select 'Data Updated'  
	 END
END TRY  
BEGIN CATCH  
    SELECT  ERROR_NUMBER()  +'  :  '+ERROR_MESSAGE()   
END CATCH 
END 

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertMainMenu]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertMainMenu]
@MenuId NVARCHAR(MAX)='',
@MenuName NVARCHAR(MAX)='',
@IsVisible NVARCHAR(MAX)=''
AS
BEGIN
	INSERT INTO obps_MenuName(DisplayName,IsVisible)
	values
	(@MenuName,@IsVisible)
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertMultipleUploadFile]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertMultipleUploadFile]  
@LinkId nvarchar(MAX)='',  
@username nvarchar(MAX)='',  
@filename nvarchar(MAX)='',  
@size float='',  
@createdtime nvarchar(MAX)='',  
@ext nvarchar(MAX)='',  
@filePath nvarchar(MAX)='',  
@batchid int=''  
AS  
BEGIN  
DECLARE @dt date='' ,@dtnew datetime=''   
DECLARE @count int=0  
set @dt=CONVERT(VARCHAR(10), getdate(), 111)  
set @dtnew=(SELECT CONVERT(VARCHAR(24), CONVERT(DATETIME, @createdtime, 103), 121) Date)
SET @size=(select convert(decimal(10, 2), @size))

INSERT INTO obps_FileUploadedHistory(UserName,FileName,Size,CreatedDate,Type,FilePath,LinkId,UploadedDate,batchid)   
values(@username,@filename,@size,@dtnew,@ext,@filePath,@LinkId,@dt,@batchid) 
  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertRoleMap]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertRoleMap]        
@tabname nvarchar(MAX)='',        
@tabid nvarchar(MAX)='',        
@colname nvarchar(MAX)='',        
@i nvarchar(MAX)='',        
@roleid int='',        
@gridid int='' ,    
@linkid int=''    
AS        
BEGIN        
	DECLARE @count int

	SET @count=(select count(*) from obps_RoleMap where LinkId=@linkid and RoleId=@roleid
				and gridid=@gridid and TableID=@tabid and TableName=@tabname and ColName=@colname)

	IF @count=0
	BEGIN
		if @roleid=''        
		BEGIN        
		INSERT INTO [dbo].[obps_RoleMap]        
				   ([RoleId],[TableID],[ColName],[IsEditable]        
				   ,[CreatedDate],[TableName],[gridid],[linkid],[isvisible],VisibilityIndex)        
			 VALUES        
				   (1,@tabid,@colname,1,getdate(),@tabname,@gridid,@linkid,1,NULL)        
		END        
		ELSE        
		BEGIN        
		 IF @gridid=''        
		 BEGIN        
		  INSERT INTO [dbo].[obps_RoleMap]        
			  ([RoleId],[TableID],[ColName],[IsEditable]        
			  ,[CreatedDate],[TableName],[gridid],[linkid],[isvisible],VisibilityIndex)        
		   VALUES        
			  (@roleid,@tabid,@colname,1,getdate(),@tabname,NULL,@linkid,1,NULL)       
		 END        
		 ELSE        
		 BEGIN        
		  INSERT INTO [dbo].[obps_RoleMap]        
			  ([RoleId],[TableID],[ColName],[IsEditable]        
			  ,[CreatedDate],[TableName],[gridid],[linkid],[isvisible],VisibilityIndex)        
		   VALUES        
			  (@roleid,@tabid,@colname,1,getdate(),@tabname,@gridid,@linkid,1,NULL)        
		 END        
		END        
	END
END        
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertRoleMapping]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[obps_sp_InsertRoleMapping]                  
@id int=0   
AS                  
BEGIN                   
DECLARE @tab nvarchar(MAX)='', @spname nvarchar(MAX)=''                  
DECLARE @col nvarchar(MAX)=''                  
DECLARE @tabid nvarchar(MAX)=''                
DECLARE @roleid nvarchar(MAX)='' ,@sublinkid nvarchar(MAX)=''                 
DECLARE @count int=0,@gcount int =0 ,@i int=1             
              
SET @roleid=(select roleid from obps_userlinks where id=@id)             
SET @sublinkid=(select sublinkid from obps_userlinks where id=@id)   
 
SET @gcount=(select count(*) from obps_TopLinkExtended where Linkid=@sublinkid and GridId is not null and gridid<>'')  

while @i<=@gcount  
BEGIN  
  SET @spname= (select gridsp from obps_TopLinkExtended where Linkid=@sublinkid and GridId=@i) 
  
  DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                  
  SELECT   NAME as tabname FROM SYSOBJECTS WHERE ID IN (SELECT SD.DEPID  FROM SYSOBJECTS SO,                     
      SYSDEPENDS SD   WHERE SO.NAME in( @spname)AND SD.ID = SO.ID)                   
  OPEN CUR_TEST                  
  FETCH NEXT FROM CUR_TEST INTO @tab                  
    WHILE @@FETCH_STATUS = 0                  
    BEGIN                 
      set @tabid=(select isnull(TableId,0) from obps_TableId where tablename=@tab)      
      if  @tabid<>0                  
      begin             
        DECLARE CUR_TEST1 CURSOR FAST_FORWARD FOR                  
        SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tab ORDER BY ORDINAL_POSITION                  
        OPEN CUR_TEST1                  
        FETCH NEXT FROM CUR_TEST1 INTO @col                  
         WHILE @@FETCH_STATUS = 0                  
         BEGIN                  
          SET @count=(select count(*) from obps_rolemap where tablename=@tab and RoleId=@roleid and ColName=@col and gridid=@i)              
          if(@count=0)     
           exec obps_sp_InsertRoleMap @tab,@tabid,@col,'',@roleid,@i,@sublinkid    
    
         FETCH NEXT FROM CUR_TEST1 INTO @col                  
         END                  
                  
        CLOSE CUR_TEST1                  
        DEALLOCATE CUR_TEST1                  
      END          
      FETCH NEXT FROM CUR_TEST INTO @tab                  
    END                  
                  
  CLOSE CUR_TEST                  
  DEALLOCATE CUR_TEST    
 SET @i=@i+1  
END                  
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertSchedulerData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertSchedulerData]    
@str VARCHAR(MAX)='',    
@Gridname NVARCHAR(MAX)='',    
@LinkId NVARCHAR(MAX)='',    
@usr nvarchar(MAX)=''    
AS    
BEGIN    
DECLARE  @Rule_ID int,    
  @ListType_ID int,    
  @Values VARCHAR(MAX)=NULL,    
  @col_name_strings varchar(MAX)='',    
  @col_val_strings varchar(MAX)='',    
  @insert_strings nvarchar(MAX)='',    
  @usrid nvarchar(500)='',    
  @tabnamequery nvarchar(MAX),    
  @tab_name nvarchar(500),    
  @query_Key nvarchar(MAX),    
  @pkey NVARCHAR(MAX),    
  @sout NVARCHAR(MAX),    
  @forkey nvarchar(MAX),    
  @forkeystr nvarchar(MAX) ,    
  @aftersavesp nvarchar(MAX)='',    
  @aftersavespname nvarchar(MAX)='',    
  @aftersavespnamequery nvarchar(MAX)=''    
    
DECLARE @col varchar(MAX)    
DECLARE @colnew varchar(MAX)=''    
DECLARE @val varchar(MAX),    
@indx int,    
 @gridid nvarchar(MAX),@ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),    
@controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int 
DECLARE @Start nvarchar(MAX)='', @End nvarchar(MAX)='', @Text nvarchar(MAX)='', @SchedulerType nvarchar(MAX)='',@include int=0
    
  
SET @Start=(select StartdateCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)  
SET @End=(select EnddateCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)     
SET @Text=(select TextCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)  
SET @SchedulerType=(select SchedulerTypeCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)
  
SET @gridid=(select substring(@Gridname, 5, 1))    
SET @tabnamequery=('(SELECT @tbname='+@Gridname+' FROM Obps_topLinks where '+@Gridname+'  is not null and Id='''+@LinkId+''')')    
EXEC Sp_executesql  @tabnamequery,  N'@tbname NVARCHAR(MAX) output',  @tab_name output    
  select @tab_name  
    
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR    
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval    
FROM [dbo].[Split] (@str, ',') ;    
     
OPEN CUR_TEST    
FETCH NEXT FROM CUR_TEST INTO @col,@val    
 select @col,@val    
  WHILE @@FETCH_STATUS = 0    
  BEGIN    
 
     set @include=0
	if @col='id'or @col='allDay' 
		set @include=0
	if(@col='Startdate')
	begin
		if (trim(@Start)<>'' or @Start is not null)
		begin
			set @include=1
			set @col=@Start
			set @val=dateadd(MINUTE,30,dateadd(hour,5,CONVERT(datetime,@val)))
		end
	end
	if(@col='Enddate')
	begin
		if (trim(@End)<>'' or @End is not null)
		begin
		select 'inside'
		select @End
			set @include=1
			set @col=@End
			set @val=dateadd(MINUTE,30,dateadd(hour,5,CONVERT(datetime,@val)))
		end
	end
	if(@col='Text')
	begin
		if (trim(@Text)<>'' or @Text is not null)
		begin
			set @include=1
			set @col=@Text
		end
	end
	if(@col='ScheduleType')
	begin
		if (trim(@SchedulerType)<>'' or @SchedulerType is not null)
		begin
			set @include=1
			set @col=@SchedulerType
		end
	end
    
  
  if @include=1
  begin

	if @col_name_strings=''      
	   begin      
	   set @col_name_strings=  RTRIM(LTRIM(@col))     
       set @col_val_strings= ''''+@val  
		--set @col_name_strings=@col_name_strings+@col+'='''+@val+''''      
	   end      
	   else      
	   begin      
	   set @col_name_strings=@col_name_strings+ ','+  RTRIM(LTRIM(@col))    
       set @col_val_strings=@col_val_strings+''','''+ @val    
		--set @col_name_strings=@col_name_strings+','+@col+'='''+@val+''''      
	   end

  end  
      
   IF @col = 'CreatedDate'    
   BEGIN    
    IF EXISTS(SELECT TOP 1 * FROM INFORMATION_SCHEMA.COLUMNS    
    WHERE [TABLE_NAME] = @tab_name AND [COLUMN_NAME] = 'CreatedDate')    
    BEGIN    
    
      if @col_name_strings=''     
      begin    
       select @col_name_strings    
       set @col_name_strings=  RTRIM(LTRIM(@col))     
       set @col_val_strings= ''''+@val    
      end    
      else     
      begin    
       set @col_name_strings=@col_name_strings+ ','+  RTRIM(LTRIM(@col))    
       set @col_val_strings=@col_val_strings+''','''+ @val    
      end    
    END    
   END    
        FETCH NEXT FROM CUR_TEST INTO @col,@val    
  END    
    
  set @col_val_strings=@col_val_strings+''''    
CLOSE CUR_TEST    
DEALLOCATE CUR_TEST    
  
if @col_name_strings<>''     
begin    
 set @col_name_strings=@col_name_strings+ ','    
 SET @col_name_strings=@col_name_strings+'Createdby'    
 SET @col_val_strings=@col_val_strings+','''+@usr+''''    
END    
  
    
set @insert_strings='insert into '+@tab_name+'('+@col_name_strings+')values('+@col_val_strings+')'    
select @insert_strings,@col_name_strings,@col_val_strings    
EXEC Sp_executesql  @insert_strings--,N'@sout NVARCHAR(MAX) output',  @sout output    
    
SET @aftersavesp=(SELECT SUBSTRING(@Gridname, 1,5)+'AfterSaveSp')    
    
 SET @aftersavespnamequery=('(SELECT @aftersavespname='+@aftersavesp+' FROM Obps_TopLinks where '+@aftersavesp+'  is not null and Id='''+@LinkId+''')')      
 EXEC Sp_executesql  @aftersavespnamequery,  N'@aftersavespname NVARCHAR(MAX) output', @aftersavespname output      
      
 IF len(@aftersavespname)>0     
 BEGIN    
 EXEC @aftersavespname     
 END     
    
END    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_insertTempLinks]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_insertTempLinks]  
@sublinkid nvarchar(MAX)='',      
@noofcopies nvarchar(MAX)=''      
AS      
BEGIN  
declare @count int=1 ,@newid int     
declare @newlinkname nvarchar(MAX)=''      
      
truncate table obps_toplinks_temp   
truncate table obps_toplinkextended_temp   
      
while @count<=@noofcopies      
begin      
      
 SET @newlinkname='link'+convert(nvarchar,@count)     
 insert into obps_toplinks_temp      
 (LinkName,Type,MenuId,SortOrder,IsAfterLogin,IsImportEnabled,ImportErrorOutSp  
 ,ImportSavedOutSp,IsMobile,EnableUniversalSearch,ImportHelp,AllowedExtension,IsLocation  
 ,DdlSp,IsSamePage,TriggerGrid,RefreshGrid,ConditionalCRUDBtn,CondCRUDBtnAddSp,CondCRUDBtnEditSp  
 ,CondCRUDBtnDeleteSp,IsSpreadSheet,IsPivot,SchedulerTypeSP,IsExportToCsv,CSVSeperator,originallinkid )      
 (select @newlinkname,Type,MenuId,SortOrder,IsAfterLogin,IsImportEnabled,ImportErrorOutSp  
 ,ImportSavedOutSp,IsMobile,EnableUniversalSearch,ImportHelp,AllowedExtension,IsLocation  
 ,DdlSp,IsSamePage,TriggerGrid,RefreshGrid,ConditionalCRUDBtn,CondCRUDBtnAddSp,CondCRUDBtnEditSp  
 ,CondCRUDBtnDeleteSp,IsSpreadSheet,IsPivot,SchedulerTypeSP,IsExportToCsv,CSVSeperator,id   
 from obps_toplinks where id=@sublinkid)      
      
  set @newid=(SELECT @@IDENTITY)  
  
  insert into obps_toplinkextended_temp(  
Linkid,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp,AfterSaveSp,AllowToolbar  
,IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled,RefreshSp,IsYellowBtn,YellowBtnSp  
,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit,DependentGrid,AllowHScrollBar,CustomContextMenuLinkId1  
,CustomContextMenuLinkId2,CustomContextMenuLinkId3,CustomContextMenuTxt1,CustomContextMenuTxt2,CustomContextMenuTxt3)  
(select @newid,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp,AfterSaveSp,AllowToolbar  
,IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled,RefreshSp,IsYellowBtn,YellowBtnSp  
,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit,DependentGrid,AllowHScrollBar,CustomContextMenuLinkId1  
,CustomContextMenuLinkId2,CustomContextMenuLinkId3,CustomContextMenuTxt1,CustomContextMenuTxt2,CustomContextMenuTxt3   
from obps_TopLinkExtended where Linkid=@sublinkid)   
 SET @count=@count+1      
end      
END  

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_insertTempUsers]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_insertTempUsers]  
@username nvarchar(MAX)='',  
@noofcopies nvarchar(MAX)=''  
AS  
BEGIN  
declare @count int=1  
declare @newusername nvarchar(MAX)=''  
  
truncate table obps_users_temp  
  
while @count<=@noofcopies  
begin  
  
 SET @newusername='user'+convert(nvarchar,@count)  
 insert into obps_Users_temp  
 (UserName,RoleId,Company,Division,Department,SubDept,UserTypeId,  
 DefaultLinkId,PrefLang,AfterLoginSP,Permission,ReportingManager,EmailId,originaluser)  
 (select @newusername,RoleId,Company,Division,Department,SubDept,UserTypeId,  
 DefaultLinkId,PrefLang,AfterLoginSP,Permission,ReportingManager,EmailId,@username   
 from obps_Users where UserName=@username)  
  
 SET @count=@count+1  
end  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUpdateRoleMapping]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[obps_sp_InsertUpdateRoleMapping]    
@tabname nvarchar(MAX)='',    
@roleid nvarchar(MAX),    
@ColName nvarchar(MAX),    
@IsVisible nvarchar(MAX),    
@Ismobile nvarchar(MAX),    
@VisibilityIndex nvarchar(MAX) ,
@linkid int=0,
@gridid nvarchar(MAX)    
AS    
BEGIN    
    
DECLARE @count nvarchar(MAX)    
 SET @count=(select count(*) from obps_rolemap where tablename=@tabname and RoleId=@roleid)    
 IF @count>0     
 BEGIN    
  update obps_rolemap set    
  IsMobile=@Ismobile,IsVisible=@IsVisible,VisibilityIndex=@VisibilityIndex  
  where tablename=@tabname and RoleId=@roleid and ColName=@ColName
		and LinkId=@linkid and gridid=@gridid
 END    
END    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUpdatetable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_InsertUpdatetable]
@tabname nvarchar(MAX)='',
@ColName nvarchar(MAX),
@datatype nvarchar(MAX),
@default nvarchar(MAX),
@allownull nvarchar(MAX)
AS
BEGIN

DECLARE @count nvarchar(MAX)

DECLARE @colstr nvarchar(MAX)=''
set @colstr='ALTER TABLE '+@tabname+' CHANGE '+@ColName+'  '+@ColName+'  '+ @datatype;
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUploadFile]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[obps_sp_InsertUploadFile]  
@LinkId nvarchar(MAX)='',  
@username nvarchar(MAX)='',  
@id nvarchar(MAX)='',  
@filePath nvarchar(MAX)='',
@filename nvarchar(MAX)='',
@newfilename nvarchar(MAX)=''
AS  
BEGIN  
 insert into obps_FileUpload(AutoId,Username,FilePath,Linkid,filename,filenamedesc)  
 values  
 (@id,@username,@filePath,@LinkId,@newfilename,@filename)  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUser]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[obps_sp_InsertUser]    
@UserName nvarchar(MAX)='',    
@RoleId nvarchar(MAX)='',    
@companyName  nvarchar(MAX)='',    
@Division nvarchar(MAX)='',    
@Department nvarchar(MAX)='',    
@SubDept nvarchar(MAX)='',    
@Password nvarchar(MAX)='',    
@UserTypeId nvarchar(MAX)='',    
@DefaultLinkId nvarchar(MAX)='' ,  
@AfterLoginSp nvarchar(MAX)='',
@emailid nvarchar(MAX)=''  ,
@Reportingmgr nvarchar(MAX)=''

AS    
BEGIN    
 DECLARE @UserExist int=0;    
 set @UserExist=(select count(*) from obps_Users where UserName=@UserName)    
 if @UserExist>0    
  select 'User already exist'    
 else    
 BEGIN    
  INSERT INTO obps_Users(UserId,UserName,RoleId,Company,Division,Department,SubDept,Password,UserTypeId,DefaultLinkId,AfterLoginSP,EmailId,ReportingManager,IsResetPassword )    
  values    
  (1,@UserName,@RoleId,@companyName ,@Division,@Department,@SubDept,@Password,@UserTypeId,@DefaultLinkId,@AfterLoginSp,@emailid,@Reportingmgr,1 )    
  select 'User Added'    
 END    
END    

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUserLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[obps_sp_InsertUserLink]              
@usr nvarchar(MAX)='',              
@userid nvarchar(MAX)='',              
@username nvarchar(MAX)='',              
@linkid nvarchar(MAX)='',              
@linkname nvarchar(MAX)='',              
@sublinkid nvarchar(MAX)='',            
@isRole nvarchar(MAX)=''            
AS              
BEGIN              
BEGIN TRY  
 DECLARE @XML AS XML,@DELIMITER AS VARCHAR(10)   
 DECLARE @rol int=0,@sub int,@roleid int,@id int  
  
 SET @roleid=(select RoleId from obps_Users where UserId=@userid)              
  
 IF OBJECT_ID(N'tempdb..#temp1') IS NOT NULL      
 BEGIN      
  DROP TABLE #temp1     
 END     
  
  IF OBJECT_ID(N'tempdb..#temp2') IS NOT NULL      
 BEGIN      
  DROP TABLE #temp2      
 END     
  
  CREATE TABLE #temp1(id int,sublink int,rolemap int)--for adding splitted sublink and rolemap  
  CREATE TABLE #temp2(id int,rolemap int)--for adding splitted rolemap  
  
 SET @DELIMITER =','   
 SET @XML = CAST(( '<LINKID>'   
       + REPLACE(@sublinkid, ',', '</LINKID><LINKID>')   
       + '</LINKID>' ) AS XML)   
  
 INSERT INTO #temp1(id,sublink)  
 SELECT row_number() over (order by (select NULL)) 'id',N.value('.', 'VARCHAR(10)') AS VALUE  
 FROM   @XML.nodes('LINKID') AS T(N)  
  
 SET @XML = CAST(( '<ROLEID>'   
       + REPLACE(@isRole, ',', '</ROLEID><ROLEID>')   
       + '</ROLEID>' ) AS XML)   
  
 INSERT INTO #temp2(id,rolemap)  
 SELECT row_number() over (order by (select NULL)) 'id', N.value('.', 'VARCHAR(10)') AS VALUE  
 FROM   @XML.nodes('ROLEID') AS T(N)  
  
 --For adding rolemap to the temp1 table by joining with the sublink data table   
 update T1 set T1.rolemap=T2.rolemap  
  from #temp1 T1 inner join #temp2 T2   
  on T1.id=T2.id  
   
 --removing the sublinks of the main link where there is no change or insert is not required  
 delete from #temp1 where sublink=0  
  
 --inserting records to the obps_UserLinks table by taking data from #temp1 row by row  
 DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                  
 SELECT sublink,rolemap FROM #temp1;                  
                   
   OPEN CUR_TEST                  
   FETCH NEXT FROM CUR_TEST INTO @sub,@rol                  
                   
   WHILE @@FETCH_STATUS = 0                  
   BEGIN      
     if @rol=1  
     BEGIN  
      insert into obps_UserLinks(UserId,UserName,LinkId,LinkName,CreatedDate,CreatedBy,ModifiedBy,IsActive,IsDeleted,RoleId,sublinkid,IsRoleAttached)  
      select @userid,@username,@linkid,@linkname,GETDATE(),@usr,'',1,0,@roleid,@sub,@rol  
      SET @id = SCOPE_IDENTITY()              
      exec obps_sp_InsertRoleMapping @id              
     END  
     ELSE  
      insert into obps_UserLinks(UserId,UserName,LinkId,LinkName,CreatedDate,CreatedBy,ModifiedBy,IsActive,IsDeleted,RoleId,sublinkid,IsRoleAttached)  
      select @userid,@username,@linkid,@linkname,GETDATE(),@usr,'',1,0,@roleid,@sub,0  
  
      FETCH NEXT FROM CUR_TEST INTO @sub,@rol                  
   END        
     
   CLOSE CUR_TEST                  
 DEALLOCATE CUR_TEST    
END TRY  
BEGIN CATCH  
 SELECT ERROR_MESSAGE() AS ErrorMessage;  
END CATCH  
END  

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUserRole]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertUserRole]
@roleId NVARCHAR(MAX)='',
@groupName NVARCHAR(MAX)=''
AS
BEGIN
	DECLARE @RoleExist int=0;
	set @RoleExist=(select count(*) from obps_rolemaster where roleid=@roleId)
	if @RoleExist>0
		select 'Role already exist'
	else
	BEGIN
		INSERT INTO obps_RoleMaster(RoleId)
		values
		(@roleId)
		select 'Role Added'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUserType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[obps_sp_InsertUserType]  
@type nvarchar(MAX),
@typeDesc nvarchar(MAX)
AS    
BEGIN    
DECLARE @UserTypeExist int=0,@UserTypeId int=0;
set @UserTypeExist=(select count(*) from obps_UserType where UserType=@type)
set @UserTypeId=(select max(usertypeid) from obps_UserType)+1
if @UserTypeExist>0
select 'User Type already exist'
else
BEGIN
insert into  obps_UserType(UserTypeId,UserType,UserTypeDesc)
values
(@UserTypeId,@type,@typeDesc)
select 'User Type Added'
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_IsJobHistoryRequired]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_IsJobHistoryRequired]
@linkid nvarchar(4)='',
@username nvarchar(MAX)=''
AS
BEGIN

select ShowJobHistory from obps_TopLinkExtended
	where linkid=@linkid and gridid=1

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_JobHistoryData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_JobHistoryData]          
@lId nvarchar(MAX) = '',          
@usrname NVARCHAR(MAX)= NULL         
AS          
BEGIN          
 select id,Jobname,Startdate,Enddate from obps_JobExecutionHistory         
END   
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_LinkMapping]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_LinkMapping]                  
@tabname nvarchar(MAX)='',                  
@linkid nvarchar(MAX)=''                  
AS                  
BEGIN                  
                  
DECLARE @count nvarchar(MAX)                  
DECLARE @col nvarchar(MAX)                  
                  
DECLARE @tabid int                  
set @tabid=(select isnull(tableid,0) from obps_TableId where tablename=@tabname)                                 
if  @tabid<>0                
begin                
                
	 DECLARE CUR_TESTCol CURSOR FAST_FORWARD FOR                  
	 SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tabname ORDER BY ORDINAL_POSITION                  
	 OPEN CUR_TESTCol                  
	 FETCH NEXT FROM CUR_TESTCol INTO @col                  
	 WHILE @@FETCH_STATUS = 0                  
	 BEGIN                  
                  
	 SET @count=(select count(*) from obps_ColAttrib where tablename=@tabname and LinkId=@linkid and ColName=@col)                  
	 IF @count<=0                  
	 BEGIN                  
		 insert into obps_ColAttrib (TableID,TableName,ColName,DisplayName,ColControlType,IsEditable,ColColor,
		 FontColor,FontAttrib,CreatedDate,CreatedBY,ModifiedBy,IsActive,IsDeleted,DropDownLink,GridId,ColumnWidth,LinkId)                  
		 SELECT @tabid,@tabname,@col,@col,'textbox',1,NULL,NULL,NULL,getdate(),'','',1,0,NULL,NULL,NULL,@linkid           
	 END                  
	 FETCH NEXT FROM CUR_TESTCol INTO @col                  
	 END                  
                  
	 CLOSE CUR_TESTCol                  
	 DEALLOCATE CUR_TESTCol                  
	 exec obps_sp_InsertRoleMapping @linkid                
                    
	 select TableName,ColName,data_type as 'datatype',DisplayName,ColControlType,IsEditable,DropDownLink,
	 ColColor,IsActive,GridId as 'GridId',ColumnWidth,SortIndex,SortOrder,ToolTip,SummaryType,
	 case when IsMobile=1 then 'True' else'False' end IsMobile,
	 case when IsRequired=1 then 'True' else'False' end IsRequired, 
	 F.Icon,MinVal,MaxVal from obps_ColAttrib C          
	 left join obps_FormatCondIcon F on F.id=C.FormatCondIconId
	 inner join INFORMATION_SCHEMA.COLUMNS  i      
	 on TableName=i.TABLE_NAME and ColName=COLUMN_NAME                  
	 where LinkId=@linkid and TableName=@tabname                 
 end           
              
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_MergeInsert]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_MergeInsert]           
@var_id int,  
@maintablename nvarchar(MAX)='',  
@linkid nvarchar(MAX)=''  
AS                           
BEGIN    

 DECLARE @InsertSp nvarchar(MAX)=''  
 exec [obps_sp_GenDataValidityCheck_DataType] @var_id,@maintablename,@linkid  
 set @InsertSp=(select ltrim(rtrim(InsertSp)) from obps_ExcelImportConfig where LinkId=@linkid)  

 if len(ltrim(rtrim(@InsertSp)))>1
 begin
  exec @InsertSp  
  end
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_MobAfterLogin]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_MobAfterLogin]
@username nvarchar(MAX)=''
AS
BEGIN
	DECLARE @spname nvarchar(MAX)='',
	@roleid int='',@count int=0

	set @roleid=(select roleid from obps_Users where UserName=@username)
	SET @count=(select count(AfterLoginSp) from obps_MobAfterLogin where Roleid=@roleid)

	if(@count>0)
		SET @spname=(select AfterLoginSp from obps_MobAfterLogin where Roleid=@roleid)
	else
		SET @spname=(select top 1 AfterLoginSp from obps_MobAfterLogin where Roleid is null or roleid='')
	if(len(LTRIM(rtrim(@spname)))>1)
	exec @spname
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_printresulttofile]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_printresulttofile]
AS
BEGIN
    DECLARE @var NVARCHAR(MAX) = ''
    SET @var = 'print this data in txt file'
    PRINT 'Data is : ' + @var   

    declare @fn varchar(200) = 'c:\out.txt';

    declare @cmd varchar(8000) = concat('echo ', @var, ' > "', @fn, '"');

    print @cmd 
    exec xp_cmdshell @cmd,  no_output

    set @cmd  = concat('type "', @fn, '"');

    print @cmd 
    exec xp_cmdshell @cmd;


END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadAdminHelpDoc]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadAdminHelpDoc]  
AS   
BEGIN  
  
DECLARE   
  @id int,   
  @usertype nvarchar(MAX),  
  @currusertype nvarchar(MAX)='',  
  @counter int;  
  
 IF OBJECT_ID(N'tempdb..#temp') IS NOT NULL      
 BEGIN      
  DROP TABLE #temp      
 END      
      
 select * into #temp from obps_HelpDoc  

 DECLARE cursor_help_doc CURSOR  
 FOR SELECT id,usertype FROM obps_HelpDoc  
 where UserType is not null and len(UserType)>0;  
  
 OPEN cursor_help_doc;  
  
 FETCH NEXT FROM cursor_help_doc INTO   
  @id,@usertype;  
  
 WHILE @@FETCH_STATUS = 0  
  BEGIN  
    
   IF OBJECT_ID(N'tempdb..#temp2') IS NOT NULL      
   BEGIN      
    DROP TABLE #temp2      
   END      
  set @usertype=','+@usertype
   SELECT row_number()over (order by items)id,items  into #temp2                
   FROM [dbo].[Split] (@usertype, ',') ;  
   

   update T set T.items=U.UserType  
   from #temp2 T inner join obps_UserType U  
   on T.items=U.UserTypeId --where U.id=T.items  

   set @counter=1  
    
   while(@counter<=(select count(*) from #temp2))  
   begin  
    if(@currusertype='')  
     set @currusertype=(select items from #temp2 where id=@counter)  
    else  
     set @currusertype=@currusertype+','+(select items from #temp2 where id=@counter)  
    set @counter=@counter+1  
   end  
   update #temp set UserType=@currusertype where id=@id  
   set @currusertype=''  
   FETCH NEXT FROM cursor_help_doc INTO @id,@usertype;  
  END;  
  
 CLOSE cursor_help_doc;  
  
 DEALLOCATE cursor_help_doc;  
  
 --select * from #temp where FileName!='' and DisplayName!=''  
  select  id ,groupname,DisplayName, filename,usertype 'UserTypeDesc',isactive from #temp order by id    
  

  
END  

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadCalendarDates]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadCalendarDates]
@linkid nvarchar(MAX)='',
@username nvarchar(MAX)='',
@dateval nvarchar(MAX)='',
@loc nvarchar(25)=''
AS
BEGIN
DECLARE @tablename nvarchar(MAX)
SET @tablename=(select top 1 gridtable from obps_TopLinkExtended where Linkid=@linkid)

select date from obp_gms_HolidayList

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadChartData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadChartData]         
@usrname nvarchar(MAX)='',  
@id nvarchar(MAX)='',        
@filterval1 nvarchar(MAX)='',        
@filterval2 nvarchar(MAX)='',        
@filterval3 nvarchar(MAX)='' ,      
@chartid nvarchar(MAX)=''       
AS          
BEGIN          
          
DECLARE @sp nvarchar(MAX)=''; 
DECLARE @spaftersplit nvarchar(MAX)=''
DECLARE @divspname nvarchar(MAX)=''
 
set @sp=(SELECT DivSp FROM obps_charts where linkid=@id)

if len(RTRIM(LTRIM(@sp)))>0          
begin          

	;WITH   cte
			  AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@sp,';')
				 )
		SELECT  @spaftersplit=value
		FROM    cte
		WHERE   ROW_NUM =@chartid

 SET @divspname=(SELECT SUBSTRING(@spaftersplit,CHARINDEX ('__', @spaftersplit)+2,len(@spaftersplit)) )

 IF len(RTRIM(LTRIM(@divspname)))>0
 exec @divspname @filterval1,@filterval2,@filterval3          
end          
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadChartDataDDL]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadChartDataDDL]     
@usrname nvarchar(MAX)='',  
@id nvarchar(MAX)='',            
@ddlid int='',      
@chartid nvarchar(MAX)='',
@filter1 nvarchar(MAX)='', 
@filter2 nvarchar(MAX)='', 
@filter3 nvarchar(MAX)='' 
AS            
BEGIN            
            
DECLARE @count int=0;            
DECLARE @ddlsp nvarchar(MAX)='',@spname nvarchar(MAX)='';           
DECLARE @length int=0;          
DECLARE @spaftersplit nvarchar(MAX)='',@chartname nvarchar(MAX)=''    

if @chartid=1
	SET @ddlsp=(select Div1FilterSp from obps_charts where linkid=@id)
if @chartid=2
	SET @ddlsp=(select Div2FilterSp from obps_charts where linkid=@id)
if @chartid=3
	SET @ddlsp=(select Div3FilterSp from obps_charts where linkid=@id)
if @chartid=4
	SET @ddlsp=(select Div4FilterSp from obps_charts where linkid=@id)       
if @chartid=5
	SET @ddlsp=(select Div5FilterSp from obps_charts where linkid=@id)
if @chartid=6
	SET @ddlsp=(select Div6FilterSp from obps_charts where linkid=@id)

  
if len(rtrim(ltrim(@ddlsp)))>0  
BEGIN
	;WITH   cte
			  AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@ddlsp,';')
				 )
		SELECT  @spaftersplit=value
		FROM    cte
		WHERE   ROW_NUM =@ddlid

 --SET @spname=(SELECT SUBSTRING(@spaftersplit,CHARINDEX ('__', @spaftersplit)+2,len(@spaftersplit)) )

if len(RTRIM(LTRIM(@spaftersplit)))>0
 exec @spaftersplit @filter1,@filter2,@filter3,@usrname  
else        
  select ''  
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadChartDDLText]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[obps_sp_ReadChartDDLText]  
@usrname nvarchar(MAX)='',  
@id nvarchar(MAX)='',          
@ddlid int='',      
@chartid nvarchar(MAX)=''          
AS           
BEGIN          
  
             
DECLARE @count int=0;              
DECLARE @ddlText nvarchar(MAX)='',@spname nvarchar(MAX)='';             
DECLARE @length int=0;            
DECLARE @ddlTextaftersplit nvarchar(MAX)='',@chartname nvarchar(MAX)=''      
  
if @chartid=1  
 SET @ddlText=(select Div1FilterText from obps_charts where linkid=@id)  
if @chartid=2  
 SET @ddlText=(select Div2FilterText from obps_charts where linkid=@id)  
if @chartid=3  
 SET @ddlText=(select Div3FilterText from obps_charts where linkid=@id)  
if @chartid=4  
 SET @ddlText=(select Div4FilterText from obps_charts where linkid=@id)         
if @chartid=5  
 SET @ddlText=(select Div5FilterText from obps_charts where linkid=@id)  
if @chartid=6  
 SET @ddlText=(select Div6FilterText from obps_charts where linkid=@id)  
  
    
if len(rtrim(ltrim(@ddlText)))>0    
BEGIN  
 ;WITH   cte  
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@ddlText,';')  
     )  
  SELECT  @ddlTextaftersplit=value  
  FROM    cte  
  WHERE   ROW_NUM =@ddlid  
  
 --SET @spname=(SELECT SUBSTRING(@spaftersplit,CHARINDEX ('__', @spaftersplit)+2,len(@spaftersplit)) )  
  
if len(RTRIM(LTRIM(@ddlTextaftersplit)))>0  
 select @ddlTextaftersplit   
else          
  select ''    
END  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadChartTypes]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_ReadChartTypes]  
@LinkId nvarchar(MAX)='',   
@divid nvarchar(MAX)=''  
AS  
BEGIN  
  
DECLARE @Divname nvarchar(MAX)='', @divquery nvarchar(MAX)='',@Divcharttype nvarchar(MAX)=''  
  
SET @Divname='Div'+@divid+'charttype'  
  
SET @divquery=('(SELECT @Divcharttype='+@Divname+' FROM obps_charts where linkid='''+@LinkId+''')')  
EXEC Sp_executesql  @divquery,  N'@Divcharttype NVARCHAR(MAX) output',  @Divcharttype output  
  
select ROW_NUMBER() OVER(ORDER BY charttypes ASC) AS ID,charttypes as 'NAME' FROM obps_ChartTypeMaster where Chart=(select chart from obps_ChartTypeMaster where ChartTypes=@Divcharttype)  
  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_readcopylinkdata]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[obps_sp_readcopylinkdata]
AS
BEGIN
	select T.id 'toplinkid', TE.id 'toplinkextendedid', DisplayName, 
	LinkName 'submenu',gridid,Gridsp,lower(Gridtable) 'Gridtable'
	from obps_TopLinks_temp T
	inner join obps_TopLinkExtended_temp TE on T.id=TE.Linkid
	inner join obps_MenuName M on M.MenuId=T.MenuId
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadDataToolBarBtnClick]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[obps_sp_ReadDataToolBarBtnClick]  
@gid nvarchar(5)='',  
@linkid nvarchar(5)='',  
@usrname nvarchar(MAX)='',  
@btnname nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @spname nvarchar(MAX)=''  
  
if(LOWER(@btnname)='redbtn')  
 SET @spname=(SELECT redbtnsp from obps_TopLinkExtended where Linkid=@linkid and GridId=@gid )  
else if(LOWER(@btnname)='yellowbtn')  
 SET @spname=(SELECT YellowBtnSp from obps_TopLinkExtended where Linkid=@linkid and GridId=@gid )  
else if(LOWER(@btnname)='greenbtn')  
 SET @spname=(SELECT GreenBtnSp from obps_TopLinkExtended where Linkid=@linkid and GridId=@gid )  
else if(LOWER(@btnname)='refreshbtn')  
 SET @spname=(SELECT RefreshSp from obps_TopLinkExtended where Linkid=@linkid and GridId=@gid )  
  
select @spname  
 IF len(RTRIM(LTRIM(@spname)))>0  
 exec @spname @gid,@usrname            
  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadDDLCount]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadDDLCount]            
@username nvarchar(MAX)='' ,          
@linkid nvarchar(3)=''       
AS            
BEGIN  
DECLARE @count int=0;
SET @count=(select count(*) from obps_mobileConfig where linkid=@linkid)
select @count
          
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadDDLDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
CREATE PROCEDURE [dbo].[obps_sp_ReadDDLDetails]            
@username nvarchar(MAX)='' ,          
@ddlid nvarchar(MAX)='' ,          
@linkid nvarchar(3)='',          
@selectedvalue nvarchar(MAX)=''          
AS            
BEGIN          
DECLARE @spname nvarchar(MAX),          
@spnamequery nvarchar(MAX),          
@ddlcolname nvarchar(MAX),          
@colnamequery nvarchar(MAX)          
          
SET @ddlcolname='ddl'+@ddlid+'sp'          
SET @spnamequery=('(select @spname='+@ddlcolname+' from obps_mobileConfig where linkid='''+@LinkId +''')')          
EXEC Sp_executesql  @spnamequery,  N'@spname NVARCHAR(MAX) output',  @spname output          
if(trim(@spname)<>''or trim(@spname)<>null)          
begin        
exec @spname @linkid,@selectedvalue ,@username         
end        
          
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadDivTypes]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_ReadDivTypes]    
@usrname nvarchar(MAX)='',    
@linkid nvarchar(MAX)=''    
AS    
BEGIN    
    
DECLARE @i int = 1    
    
DECLARE @div1Type nvarchar(MAX)='',@div2Type nvarchar(MAX)='',@div3Type nvarchar(MAX)='',    
  @div4Type nvarchar(MAX)='',@div5Type nvarchar(MAX)='',@div6Type nvarchar(MAX)=''    
DECLARE @div1ChartType nvarchar(MAX)='',@div2ChartType nvarchar(MAX)='',@div3ChartType nvarchar(MAX)='',    
  @div4ChartType nvarchar(MAX)='',@div5ChartType nvarchar(MAX)='',@div6ChartType nvarchar(MAX)=''     


DECLARE @divType nvarchar(MAX)='',@divTypeAfterSplit nvarchar(MAX)='',@type nvarchar(MAX)=''    
    
SET @divType=(SELECT DivSp from obps_charts where linkid=@linkid)    
    
if len(rtrim(ltrim(@divType)))>0      
BEGIN    
    
    
 WHILE @i <7    
 BEGIN    
  ;WITH   cte    
      AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@divType,';')    
      )    
   SELECT  @divTypeAfterSplit=value    
   FROM    cte    
   WHERE   ROW_NUM =@i    
    
  SET @type=(SELECT SUBSTRING(@divTypeAfterSplit,0,CHARINDEX ('__',@divTypeAfterSplit)))    
    
  if @i=1    
   SET @div1Type=@type    
  else if @i=2    
   SET @div2Type=@type    
  else if @i=3    
   SET @div3Type=@type    
  else if @i=4    
   SET @div4Type=@type    
  else if @i=5    
   SET @div5Type=@type    
  else if @i=6    
   SET @div6Type=@type    
    
  SET @i  = @i  + 1    
    
 END      
END    

 SELECT @div1Type,@div2Type,@div3Type,@div4Type,@div5Type,@div6Type    
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadErrorData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_ReadErrorData]        
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
        
SET @spname=(SELECT ImportErrorOutSp FROM obps_TopLinks where id=@lId)           
           
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
 EXEC @spname   @usrname      
END        
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadFilePath]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadFilePath]
@id nvarchar(MAX)=''
AS
BEGIN
select FileNameDesc,FilePath from obps_FileUpload where id=@id
 --select FilePath from obps_FileUpload where id=@id  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadGanttData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadGanttData]        
@lnkId nvarchar(MAX)='', 
@gridname nvarchar(MAX)='',
@usrname nvarchar(MAX)=''
AS        
BEGIN        
    
DECLARE @spquery nvarchar(MAX)='',@ganttsp nvarchar(MAX)='',@ganttsp1  nvarchar(MAX)=''

SET @spquery=('(SELECT @ganttsp1='+@Gridname+' FROM obps_TopLinks where '+@Gridname+'  is not null and Id='''+@lnkId+''')')          
EXEC Sp_executesql  @spquery,  N'@ganttsp1 NVARCHAR(MAX) output',  @ganttsp output 
   
if(LEN(@ganttsp)>0)
BEGIN      
 EXEC @ganttsp @usrname        
END

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadGlobalData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadGlobalData]  
AS  
BEGIN  
DECLARE @count int=0,@logo int=0,@hepfilepath nvarchar(MAX)='';  
 SET @count=(select count(*) from obps_GlobalConfig where Variables='logorequired')  
 if @count=0  
 BEGIN  
  insert into obps_GlobalConfig(Variables,Value)  
  values('LogoRequired',0)  
 END  
 set @logo=(select Value from obps_GlobalConfig where Variables='logorequired')

 if((select count(Value) from obps_GlobalConfig where Variables='helpfilepath')>0)
	SET @hepfilepath=(select Value from obps_GlobalConfig where Variables='helpfilepath')
 else
	SET @hepfilepath=''

 select @logo,@hepfilepath
  
END

GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadGridButtonData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obps_sp_ReadGridButtonData]        
@Gridid NVARCHAR(MAX)='',        
@LinkId nvarchar(MAX) = '',        
@UserName NVARCHAR(MAX)= '',
@selectedid nvarchar(MAX)=''
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
        
SET @spname=(SELECT GridRowButtonSp FROM obps_toplinkextended where linkid=@LinkId and GridId=@Gridid)        
        
     
IF (len(ltrim(rtrim(@spname)))>0)        
BEGIN        
 EXEC @spname @UserName,@selectedid         
END        
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadGridData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadGridData]                                
@gid NVARCHAR(MAX)=NULL,                                
@lId nvarchar(MAX) = '',                                
@usrname NVARCHAR(MAX)= NULL,                                
@Id nvarchar(MAX)= '',                                
@clientid NVARCHAR(MAX)='',                                
@ddlvalue NVARCHAR(MAX)='',    
@selectedgridval NVARCHAR(MAX)=''    
AS                                
BEGIN                                
 DECLARE @usrname_col NVARCHAR(MAX),        
    @depGrid int ,    
    @query NVARCHAR(MAX),                                
    @query_Key NVARCHAR(MAX),                                
    @pkey NVARCHAR(MAX),                                
    @tabname NVARCHAR(MAX),                                
    @spquery NVARCHAR(MAX) ,                                
    @count int,@par1 nvarchar(MAX)='',                          
 @par2 nvarchar(MAX)='' ,@par3 nvarchar(MAX)='' ,                          
 @par4 nvarchar(MAX)='' ,@par5 nvarchar(MAX)='',@ddlcount nvarchar(MAX)=''      
     
 DECLARE @spname NVARCHAR(MAX),@pagetype  int,@gridcount int,@selectedgridvalue nvarchar(MAX)    
    
  SET @pagetype=(select type from obps_TopLinks where id=@lId)    
  SET @gridcount=(select max(gridid) from obps_TopLinkExtended where Linkid=@lId)     
  SET @spname=(SELECT gridsp FROM obps_TopLinkExtended where gridid=@gid and Linkid=@lId)     
  set @depGrid=(SELECT DependentGrid FROM obps_TopLinkExtended where gridid=@gid and Linkid=@lId)    
    
    
  IF OBJECT_ID('tempdb..#gridid_Temp') IS NOT NULL DROP TABLE #gridid_Temp    
  create table #gridid_Temp(value nvarchar(MAX),RowNum int)    
  insert into #gridid_Temp(value,RowNum) SELECT value,    
     ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS RowNum     
  FROM STRING_SPLIT(@selectedgridval,',');    
    
    SET @selectedgridvalue=(select value from #gridid_Temp where RowNum=@depGrid)    
       
  SET @count=(SELECT count(DISTINCT t.name)                                 
     FROM sys.sql_dependencies d                                 
     INNER JOIN sys.procedures p ON p.object_id = d.object_id                                
     INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id                                
     where p.name=@spname)                                
                          
                          
 (select @par1=isnull(par1,''),@par2=isnull(par2,''),@par3=isnull(par3,''),@par4=isnull(par4,''),@par5=isnull(par5,'')                           
   from obps_spPermissions where                           
   Gridid=@gid and Linkid=@lId and                           
   UserId=(select id from obps_Users where UserName=@usrname))                          
                          
 set @ddlcount=(select isnull(DdlSp,'') from obps_TopLinks where id=@lId)       
    
--------for tab pages-----------------    
if(@pagetype=2)    
BEGIN    
                    
  IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))<=0)                  
  and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                                
  BEGIN                            
  print '1.1'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@selectedgridvalue                              
  END                            
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                  
  and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                   
  BEGIN                      
  print '1.2'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2,@selectedgridvalue                              
  END                           
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0)               
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))           
  BEGIN                        
  print '1.3'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@selectedgridvalue                             
  END                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0 )                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                        
  print '1.4'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@par4,@selectedgridvalue                             
  END                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))>0))                               
  BEGIN                       
  print '1.5'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@par4,@par5,@selectedgridvalue                             
  END                          
                          
  --------------------when @ddl is not there--------------------------                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0) and (len(ltrim(rtrim(@par2)))<=0)                          
    and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                           
  BEGIN                       
  print '1.6'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@selectedgridvalue                              
  END                             
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 )and (len(ltrim(rtrim(@par1)))>0)and                   
  (len(ltrim(rtrim(@par2)))>0)   and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                            
  BEGIN                         
  print '1.7'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2,@selectedgridvalue                              
  END                           
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and  (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                            
  print '1.8'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@selectedgridvalue                             
  END                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0 )                          
    and (len(ltrim(rtrim(@par3)))>0 )and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                      
  print '1.9'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@par4,@selectedgridvalue                             
  END                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))>0))                               
  BEGIN                      
  print '1.10'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@par4,@par5,@selectedgridvalue                             
  END                    
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0)and (len(ltrim(rtrim(@par1)))<=0)and (len(ltrim(rtrim(@par2)))<=0)                          
    and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                     
  BEGIN                      
  print '1.11'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@selectedgridvalue                   
  END                   
  else                     
  begin             
  print @selectedgridvalue    
   print '1.12'                    
   --select @spname,@usrname,@Id,@clientid  
   if LEN(@selectedgridvalue)>0
	   BEGIN
			print '1.12.1'   
		   EXEC @spname @usrname,@Id,@clientid,@selectedgridvalue 
	   END
   else
		BEGIN
			print '1.12.1'   
		   EXEC @spname @usrname,@Id,@clientid 
	   END
  end                  
END    
--------for non tab pages-----------------    
ELSE    
BEGIN             
  IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))<=0)                  
  and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                                
  BEGIN                            
  print '1'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1                              
  END                            
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                  
  and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                   
  BEGIN                      
  print '2'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2                              
  END                           
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                        
  print '3'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3                             
  END                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0 )                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                        
  print '4'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@par4                             
  END                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))>0))                               
  BEGIN                       
  print '5'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@par4,@par5                             
  END                          
                          
  --------------------when @ddl is not there--------------------------                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0) and (len(ltrim(rtrim(@par2)))<=0)                          
    and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                           
  BEGIN                       
  print '6'                    
   EXEC @spname @usrname,@Id,@clientid,@par1                              
  END                             
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 )and (len(ltrim(rtrim(@par1)))>0)and                   
  (len(ltrim(rtrim(@par2)))>0)   and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                            
  BEGIN                         
  print '7'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2                              
  END                           
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and  (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                            
  print '8'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3                             
  END                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0 )                          
    and (len(ltrim(rtrim(@par3)))>0 )and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                      
  print '9'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@par4                             
  END                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))>0))                               
  BEGIN                      
  print '10'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@par4,@par5                             
  END                    
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0)and (len(ltrim(rtrim(@par1)))<=0)and (len(ltrim(rtrim(@par2)))<=0)                          
    and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                      
  print '11'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue                   
  END                   
  else                     
  begin                  
   print '12'                    
   --select @spname,@usrname,@Id,@clientid                
   EXEC @spname @usrname,@Id,@clientid                      
  end       
END      
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadGridDataForChartPage]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadGridDataForChartPage]    
@usrname NVARCHAR(MAX)= NULL,    
@Id NVARCHAR(MAX)= NULL,    
@clientid NVARCHAR(MAX)='',    
@filterval1 nvarchar(MAX)='',          
@filterval2 nvarchar(MAX)='',          
@filterval3 nvarchar(MAX)='' ,        
@chartid nvarchar(MAX)=''     
AS    
BEGIN    
DECLARE @spname NVARCHAR(MAX)    
    
DECLARE @sp nvarchar(MAX)='';   
DECLARE @spaftersplit nvarchar(MAX)=''  
DECLARE @divspname nvarchar(MAX)=''  
   
set @sp=(SELECT DivSp FROM obps_charts where linkid=@id)  
  
if len(RTRIM(LTRIM(@sp)))>0            
begin            
  
 ;WITH   cte  
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@sp,';')  
     )  
  SELECT  @spaftersplit=value  
  FROM    cte  
  WHERE   ROW_NUM =@chartid  
  
  SET @divspname=(SELECT SUBSTRING(@spaftersplit,CHARINDEX ('__', @spaftersplit)+2,len(@spaftersplit)) )  
  
  IF len(RTRIM(LTRIM(@divspname)))>0  
  BEGIN  
   IF (@Id='' and @clientid='')    
   BEGIN    
    EXEC @divspname @usrname,@filterval1,@filterval2,@filterval3       
   END     
   ELSE IF (@Id<>'' and @clientid='')    
   BEGIN    
    EXEC @divspname @usrname,@Id ,@filterval1,@filterval2,@filterval3       
   END    
   ELSE    
   BEGIN    
    EXEC @divspname @usrname,@Id, @clientid ,@filterval1,@filterval2,@filterval3      
   END    
  END  
END  
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadHelpContent]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadHelpContent]      
@UserName nvarchar(MAX)=''      
AS      
BEGIN     
DECLARE @usertype nvarchar(MAX)=''

SET @usertype=(select UserTypeId from obps_users where UserName=@UserName)
  
select id,Displayname,GroupId,GroupName from obps_helpdoc 
where isactive=1  
and (userType='' 
or (CHARINDEX(@usertype,userType, 0)!=0)
or (UserType is null)
)
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadHelpFileName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadHelpFileName]        
@UserName nvarchar(MAX)='',    
@id nvarchar(10)=''    
AS        
BEGIN       
 DECLARE @path nvarchar(MAX)=''  
 SET @path=(select value from obps_GlobalConfig where Variables='helpfilepath')  
select Filename,@path from obps_helpdoc where id=@id and isactive=1    
    
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadHelpFilePath]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadHelpFilePath]
AS
BEGIN

select value from obps_GlobalConfig where Variables='helpfilepath'

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadIsSameChartFilters]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadIsSameChartFilters]  
@usrname nvarchar(MAX)='',  
@linkid nvarchar(MAX)=''  
AS  
BEGIN  
  
 select IsSameFilter,DepenedentFilterDivs from obps_charts where Linkid=@linkid  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadIsSameChartTypes]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadIsSameChartTypes]    
@usrname nvarchar(MAX)='',    
@linkid nvarchar(MAX)=''    
AS    
BEGIN    
    
 select IsSameChartType,DepenedentChartTypeDivs from obps_charts where Linkid=@linkid    
    
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadJobName]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadJobName]  
@linkid nvarchar(5)=''  
,@username nvarchar(MAX)=''  
AS  
BEGIN  
  
select gridsp from obps_TopLinkExtended   
where gridid=1 and Linkid=@linkid  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadJobStatus]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadJobStatus]
@linkid nvarchar(10)=''
,@username nvarchar(MAX)=''
AS
BEGIN

	DECLARE @jname nvarchar(MAX)=''

	SET @jname=(select gridsp from obps_TopLinkExtended where linkid=@linkid)

	SELECT j.name AS job_name, 
		   ja.start_execution_date AS StartTime,
		   COALESCE(CONVERT(VARCHAR(5),ABS(DATEDIFF(DAY,(GETDATE()-ja.start_execution_date),'1900-01-01'))) + ' '
				   +CONVERT(VARCHAR(10),(GETDATE()-ja.start_execution_date),108),'00 00:00:00') AS [Duration] 
	FROM msdb.dbo.sysjobactivity ja 
	LEFT JOIN msdb.dbo.sysjobhistory jh ON ja.job_history_id = jh.instance_id
	JOIN msdb.dbo.sysjobs j ON ja.job_id = j.job_id
	WHERE ja.session_id = (SELECT TOP 1 session_id FROM msdb.dbo.syssessions ORDER BY session_id DESC)
	  AND start_execution_date is not null
	  AND stop_execution_date is null
	  and j.name=@jname

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadMainMenu]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[obps_sp_ReadMainMenu]      
@username nvarchar(MAX)=''      
AS      
BEGIN      
  
 DECLARE @count int=0;  
  
 set @count=(select count(*) from obps_MenuName  where MenuId in(        
 select LinkId from Obps_UserLinks where userid =        
 (select Id from Obps_Users where UserName=@username) and isdeleted=0))+100    
  
   select mainmenu.MenuItemId,mainmenu.ParentId,mainmenu.Text,mainmenu.NavigateURL from
 (select  top 1000 id*500
 'MenuItemId',0 'ParentId',DisplayName 'Text','' 'NavigateURL' from obps_MenuName  where MenuId in(        
 select LinkId from Obps_UserLinks where userid =        
 (select Id from Obps_Users where UserName=@username) and isdeleted=0) order by DisplayOrder asc)mainmenu 
 
 union      all
 select sublink.MenuItemId,sublink.ParentId,sublink.Text,sublink.NavigateURL from
 (select  top 1000 id  'MenuItemId',MenuId*500 'ParentId',LinkName 'Text','' 'NavigateURL' from obps_TopLinks      
 where id in(        
 select sublinkid from Obps_UserLinks where userid =        
 (select Id from Obps_Users where UserName=@username) and isdeleted=0)       
 order by SortOrder asc)sublink
     
END      
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadMultipleUploadFile]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadMultipleUploadFile]
@LinkId nvarchar(MAX)=''
AS
BEGIN

	DECLARE @batchid nvarchar(MAX)=''

	SET @batchid=(select max(batchid) from obps_FileUploadedHistory)

	select UserName,FileName,Size+'KB',CreatedDate,Type,FilePath from  obps_FileUploadedHistory 
	where linkid=@LinkId and uploadedDate=CONVERT(VARCHAR(10), getdate(), 111) and batchid=@batchid


END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadRecalculateSp]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadRecalculateSp]      
@usrname nvarchar(MAX)=''      
AS      
BEGIN      
DECLARE @spname nvarchar(MAX)=''      
      
set @spname=(select value from obps_globalconfig where variables='RecalculateSp')      
      
if(len(@spname)>0)      
 exec @spname @usrname      
      
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_readRoleMap]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_readRoleMap]
AS
BEGIN

select R.id,R.RoleId,M.DisplayName,R.LinkId,T.LinkName,R.TableID,
TableName,ColName,IsEditable,
R.Displayorder,R.gridid,R.IsMobile,R.IsVisible,VisibilityIndex 
from obps_RoleMap R
inner join obps_TopLinks T on T.id=R.LinkId 
inner join obps_MenuName M on M.MenuId=T.MenuId
--inner join obps_UserLinks U on T.id=U.sublinkid and R.RoleId=U.RoleId
where R.RoleId in(select distinct RoleId from obps_UserLinks where IsRoleAttached=1)
and R.LinkId in(select distinct sublinkid from obps_UserLinks where IsRoleAttached=1)

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadSavedGridData]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[obps_Sp_ReadSchedulerData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obps_Sp_ReadSchedulerData]      
@linkid nvarchar(3)='',      
@username nvarchar(MAX)=''      
AS      
BEGIN      
      
DECLARE @spname nvarchar(MAX)=''      
      
set @spname=(select gridsp from obps_TopLinkExtended where id=@linkid)       
      
if len(@spname)>0      
begin      
--select @spname,@username         
exec @spname @username      
      
end      
      
      
END
GO
/****** Object:  StoredProcedure [dbo].[obps_Sp_ReadSchedulerType]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_Sp_ReadSchedulerType]  
@linkid nvarchar(3)='',  
@username nvarchar(MAX)=''  
AS  
BEGIN  
  
DECLARE @spname nvarchar(MAX)=''  
  
set @spname=(select SchedulerTypeSP from obps_toplinks where id=@linkid)   
  
if len(@spname)>0  
begin  
  
exec @spname @username,@linkid  
  
end  
  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_readSpPermission]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_readSpPermission]
@userid int=''
AS
BEGIN
if @userid=''
	select P.id 'id',P.UserId,U.UserName 'username',
	displayname,Linkid,LinkName,Gridid,Par1,Par2
	,Par3,Par4,Par5 
	from obps_SpPermissions P
	inner join obps_Users U on U.id=P.UserId
	inner join obps_TopLinks T on T.id=P.Linkid
	inner join obps_MenuName M on M.id=T.MenuId
else
	select P.id 'id',P.UserId,U.UserName 'username',
	displayname,Linkid,LinkName,Gridid,Par1,Par2
	,Par3,Par4,Par5 
	from obps_SpPermissions P
	inner join obps_Users U on U.id=P.UserId
	inner join obps_TopLinks T on T.id=P.Linkid
	inner join obps_MenuName M on M.id=T.MenuId
	
	where U.UserId=@userid

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadUploadFile]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_ReadUploadFile]  
@LinkId nvarchar(MAX)='',  
@username nvarchar(MAX)='',  
@id nvarchar(MAX)=''  
AS  
BEGIN  
select id,FileNameDesc from obps_FileUpload where autoid=@id--  and Linkid=@LinkId --and Username=@username  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadUserAuthorization]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadUserAuthorization]  
@linkid nvarchar(4)='',  
@username nvarchar(MAX)=''  
AS  
BEGIN  
  
DECLARE @isvalid int  
SET @isvalid=(select count(*) from obps_UserLinks where sublinkid=@linkid  
    and userid in(select id from obps_Users where UserName=@username))  
  
if(@isvalid>=1)
select 1  
else
select 0
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_recalculate]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[obps_sp_recalculate]
@username nvarchar(MAX)=''
as
begin

select ''
	--exec [onebeat_VSL].dbo.[SP_After_LoadAndReCalculate]

end
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_RefreshGrid]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_RefreshGrid]  
   @Gridname NVARCHAR(MAX)=NULL,  
   @Linkid NVARCHAR(MAX)=NULL,  
   @usr nvarchar(MAX)=''  
AS  
BEGIN  
  
    DECLARE @refreshspname NVARCHAR(MAX), 
    @spnamequery NVARCHAR(MAX)
  
    SET NOCOUNT ON;  

	SET @spnamequery=('(SELECT @refreshspname='+@Gridname+' FROM Obps_TopLinks where '+@Gridname+'  is not null and Id='''+@Linkid+''')')  
	EXEC Sp_executesql  @spnamequery,  N'@refreshspname NVARCHAR(MAX) output', @refreshspname output  
  
	IF len(rtrim(ltrim(@refreshspname)))>0 
	BEGIN  
		EXEC @refreshspname @usr
	END  
   
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_RemoveDate]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_RemoveDate]  
@date NVARCHAR(MAX)='',
@clientid NVARCHAR(MAX)
--@lId int=''
AS  
BEGIN  
delete from  obps_NonWorkingDays where clientid= @clientid and nonworkingdays=@date
 --select ID,clientname as name from obp_ClientMaster  
END  
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ResetPassword]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[obps_sp_ResetPassword]
@userid int=''
,@password nvarchar(MAX)=''
AS
BEGIN

update obps_Users set IsResetPassword=1,Password=@password where id=@userid
select 'Data Updated'


END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_RoleClassGrid1]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_RoleClassGrid1]
@RoleName nvarchar(MAX)
AS
BEGIN

DECLARE @Data_Type nvarchar(150)
DECLARE @Column_Name nvarchar(150)

DECLARE @RoleId int
SET @RoleId=(select SUBSTRING(@RoleName, PATINDEX('%[0-9]%', @RoleName), LEN(@RoleName)))
print 'using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Onebeat_PL.Models
{
    public class '+@RoleName+'
    {'
DECLARE cur CURSOR FOR
select 

case 
	when Data_Type like 'nvarchar%' then
	'string'
	when Data_Type like '%datetime%' or  Data_Type like '%date%' then
	'DateTime'
	when Data_Type like 'bit%' then
	'int'
	else
	Data_Type
	end ,Column_Name
--into #inpclass
FROM INFORMATION_SCHEMA.COLUMNS
inner join Obp_RoleMap RM on Column_Name=RM.ColName
WHERE  RM.IsVisible=1 and TABLE_NAME in 
(SELECT DISTINCT t.name 
FROM sys.sql_dependencies d 
INNER JOIN sys.procedures p ON p.object_id = d.object_id
INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
where p.name='sp_ReadData_FirstGrid' ) and RoleId=@RoleId
OPEN cur

FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
WHILE @@FETCH_STATUS = 0
BEGIN   

PRINT 'public '+@Data_Type+ ' '+@Column_Name+' { get; set;}'
FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
END

CLOSE cur;
DEALLOCATE cur;
print '} }'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_RoleClassGrid2]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_RoleClassGrid2]
@RoleName nvarchar(MAX)
AS
BEGIN

DECLARE @Data_Type nvarchar(150)
DECLARE @Column_Name nvarchar(150)

DECLARE @RoleId int
SET @RoleId=(select SUBSTRING(@RoleName, PATINDEX('%[0-9]%', @RoleName), LEN(@RoleName)))

print 'using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Onebeat_PL.Models
{
    public class '+@RoleName+'SecondGrid
    {'
DECLARE cur CURSOR FOR
select 

case 
	when Data_Type like 'nvarchar%' then
	'string'
	when Data_Type like '%datetime%' or  Data_Type like '%date%' then
	'DateTime'
	when Data_Type like 'bit%' then
	'int'
	else
	Data_Type
	end ,Column_Name
--into #inpclass
FROM INFORMATION_SCHEMA.COLUMNS
inner join Obp_RoleMap RM on Column_Name=RM.ColName
WHERE  RM.IsVisible=1 and TABLE_NAME in 
(SELECT DISTINCT t.name 
FROM sys.sql_dependencies d 
INNER JOIN sys.procedures p ON p.object_id = d.object_id
INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
where p.name='sp_ReadData_SecondGrid' ) and RoleId=@RoleId
OPEN cur

FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
WHILE @@FETCH_STATUS = 0
BEGIN   

PRINT 'public '+@Data_Type+ ' '+@Column_Name+' { get; set;}'
FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
END

CLOSE cur;
DEALLOCATE cur;
print '} }'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_RoleClassOneGrid]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_RoleClassOneGrid]
@RoleName nvarchar(MAX)
AS
BEGIN

DECLARE @Data_Type nvarchar(150)
DECLARE @Column_Name nvarchar(150)

DECLARE @RoleId int
SET @RoleId=(select SUBSTRING(@RoleName, PATINDEX('%[0-9]%', @RoleName), LEN(@RoleName)))
print 'using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Onebeat_PL.Models
{
    public class '+@RoleName+'
    {'
DECLARE cur CURSOR FOR
select 

case 
	when Data_Type like 'nvarchar%' then
	'string'
	when Data_Type like '%datetime%' or  Data_Type like '%date%' then
	'DateTime'
	when Data_Type like 'bit%' then
	'int'
	else
	Data_Type
	end ,Column_Name
--into #inpclass
FROM INFORMATION_SCHEMA.COLUMNS
inner join Obp_RoleMap RM on Column_Name=RM.ColName
WHERE  RM.IsVisible=1 and TABLE_NAME in 
(SELECT DISTINCT t.name 
FROM sys.sql_dependencies d 
INNER JOIN sys.procedures p ON p.object_id = d.object_id
INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
where p.name='sp_getData_Link2Grid1' ) and RoleId=@RoleId
OPEN cur

FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
WHILE @@FETCH_STATUS = 0
BEGIN   

PRINT 'public '+@Data_Type+ ' '+@Column_Name+' { get; set;}'
FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
END

CLOSE cur;
DEALLOCATE cur;
print '} }'
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_SaveLinkCopies]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_SaveLinkCopies]      
AS      
BEGIN      
      
declare @userid int,@newlinkid int      
declare @linkname nvarchar(MAX)='',@originallinkid  nvarchar(MAX)=''      
      
insert into obps_TopLinks     
(LinkName,Type,MenuId,SortOrder,IsAfterLogin,IsImportEnabled,ImportErrorOutSp,ImportSavedOutSp  
,IsMobile,EnableUniversalSearch,ImportHelp,AllowedExtension,IsLocation,DdlSp,IsSamePage,TriggerGrid,RefreshGrid  
,ConditionalCRUDBtn,CondCRUDBtnAddSp,CondCRUDBtnEditSp,CondCRUDBtnDeleteSp,IsSpreadSheet,IsPivot  
,SchedulerTypeSP,IsExportToCsv,CSVSeperator)      
select LinkName,Type,MenuId,SortOrder,IsAfterLogin,IsImportEnabled,ImportErrorOutSp,ImportSavedOutSp  
,IsMobile,EnableUniversalSearch,ImportHelp,AllowedExtension,IsLocation,DdlSp,IsSamePage,TriggerGrid,RefreshGrid  
,ConditionalCRUDBtn,CondCRUDBtnAddSp,CondCRUDBtnEditSp,CondCRUDBtnDeleteSp,IsSpreadSheet,IsPivot  
,SchedulerTypeSP,IsExportToCsv,CSVSeperator from obps_TopLinks_temp      
      
 SET @originallinkid=(select max(originallinkid) from obps_TopLinks_temp)     
      
DECLARE link_cursor CURSOR      
FOR SELECT linkname FROM obps_toplinks_temp;      
      
OPEN link_cursor;      
      
FETCH NEXT FROM link_cursor INTO       
    @linkname;      
      
 WHILE @@FETCH_STATUS = 0      
    BEGIN      
       
  SET @newlinkid=(select id from obps_TopLinks where LinkName=@linkname)      

  insert into obps_TopLinkExtended
  (Linkid,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp,AfterSaveSp,AllowToolbar,
  IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled,RefreshSp,IsYellowBtn,YellowBtnSp,
  IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit,DependentGrid,AllowHScrollBar,CustomContextMenuLinkId1,
  CustomContextMenuLinkId2,CustomContextMenuLinkId3,CustomContextMenuTxt1,CustomContextMenuTxt2,CustomContextMenuTxt3)  
  select @newlinkid,TabId,TabText,TabType,GridId,GridSp,GridTable,AllowAdd,AllowEdit,AllowDelete,DeleteSp,AfterSaveSp
,AllowToolbar,IsExport,AllowFilterRow,AllowheaderFilter,AllowColumnChooser,AllowGroupPanel,RefreshEnabled,RefreshSp
,IsYellowBtn,YellowBtnSp,IsGreenBtn,GreenBtnSp,IsRedBtn,RedBtnSp,AllowPaging,IsFormEdit,DependentGrid,AllowHScrollBar
,CustomContextMenuLinkId1,CustomContextMenuLinkId2,CustomContextMenuLinkId3,CustomContextMenuTxt1,CustomContextMenuTxt2,CustomContextMenuTxt3  
from obps_TopLinkExtended_temp where Linkid=(select id from obps_toplinks_temp where LinkName=@linkname)

  insert into obps_ColAttrib(TableID,TableName,ColName,DisplayName,ColControlType,IsEditable,ColColor,FontColor,FontAttrib  
  ,CreatedDate,CreatedBY,ModifiedBy,IsActive,IsDeleted,DropDownLink,GridId,ColumnWidth,LinkId  
  ,SortIndex,SortOrder,ToolTip,SummaryType,IsMobile,IsRequired,FormatCondIconId,MinVal,MaxVal)      
  select TableID,TableName,ColName,DisplayName,ColControlType,IsEditable,ColColor,FontColor,FontAttrib  
  ,getdate(),'admin',ModifiedBy,IsActive,IsDeleted,DropDownLink,GridId,ColumnWidth,@newlinkid  
  ,SortIndex,SortOrder,ToolTip,SummaryType,IsMobile,IsRequired,FormatCondIconId,MinVal,MaxVal   
  from obps_ColAttrib where LinkId=@originallinkid    
    
  insert into obps_CalculatedColAttrib(ColName,DisplayName,ColColor,GridId,ColumnWidth,  
  LinkId,SortIndex,SortOrder,CreatedDate,CreatedBY,ModifiedBy,IsActive,IsDeleted,IsMobile,  
  ToolTip,SummaryType,FormatCondIconId,MinVal,MaxVal)  
  select ColName,DisplayName,ColColor,GridId,ColumnWidth,  
  @newlinkid,SortIndex,SortOrder,getdate(),'admin',NULL,IsActive,IsDeleted,IsMobile,  
  ToolTip,SummaryType,FormatCondIconId,MinVal,MaxVal   
  from obps_CalculatedColAttrib where LinkId=@originallinkid  
  
  insert into obps_RowAttrib(TableID,TableName,ColName,MappedCol,GridId,  
 IsBackground,CellEditColName,LinkId,CellCtrlTypeColName,DdlCtrlSpColName)  
 select TableID,TableName,ColName,MappedCol,GridId,  
 IsBackground,CellEditColName,@newlinkid,CellCtrlTypeColName,DdlCtrlSpColName  
 from obps_RowAttrib where linkId=@originallinkid  
          
 insert into obps_CalculatedRowAttrib(ColName,MappedCol,GridId,IsBackground,  
 CellEditColName,LinkId,CellCtrlTypeColName,DdlCtrlSpColName)  
 select ColName,MappedCol,GridId,IsBackground,  
 CellEditColName,@newlinkid,CellCtrlTypeColName,DdlCtrlSpColName   
 from obps_CalculatedRowAttrib where linkId=@originallinkid  
      
        FETCH NEXT FROM link_cursor INTO @linkname;      
    END;      
      
CLOSE link_cursor;      
      
DEALLOCATE link_cursor;      
      
truncate table obps_toplinks_temp    
truncate table obps_toplinkextended_temp    
    
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_SaveUserCopies]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_SaveUserCopies]  
AS  
BEGIN  
  
declare @userid int,@newuserid int  
declare @usrname nvarchar(MAX)='',@originalusername  nvarchar(MAX)=''  
  
insert into obps_Users  
(UserName,Userid,RoleId,Company,Division,Department,SubDept,Password,UserTypeId,DefaultLinkId,  
PrefLang,AfterLoginSP,Permission,ReportingManager,EmailId,isresetpassword)  
select UserName,1,RoleId,Company,Division,Department,SubDept,Password,UserTypeId  
,DefaultLinkId,PrefLang,AfterLoginSP,Permission,ReportingManager,EmailId,1  
from obps_Users_temp  
  
  
SET @userid=(select id from obps_Users where UserName=@originalusername)  
  
DECLARE user_cursor CURSOR  
FOR SELECT UserName FROM obps_Users_temp;  
  
OPEN user_cursor;  
  
FETCH NEXT FROM user_cursor INTO   
    @usrname;  
  
 WHILE @@FETCH_STATUS = 0  
    BEGIN  
   
  SET @newuserid=(select id from obps_Users where username=@usrname)  
  insert into obps_UserLinks(UserId,UserName,LinkId,LinkName,CreatedDate,CreatedBy,ModifiedBy,IsActive  
        ,IsDeleted,RoleId,sublinkid,IsRoleAttached)  
  select @newuserid,UserName,LinkId,LinkName,CreatedDate,CreatedBy,ModifiedBy,IsActive  
        ,IsDeleted,RoleId,sublinkid,IsRoleAttached from obps_UserLinks where UserId=@userid  
      
  
        FETCH NEXT FROM user_cursor INTO @usrname;  
    END;  
  
CLOSE user_cursor;  
  
DEALLOCATE user_cursor;  
  
truncate table obps_Users_temp

END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_SetGlobalValues]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_SetGlobalValues]        
@usrname nvarchar(MAX)=''        
AS        
BEGIN        
  
select value from obps_GlobalConfig where variables='LogoRequired'
        
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateCalendarDates]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateColAttrib]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[obps_sp_UpdateColAttrib]     
@linkid nvarchar(MAX)='',    
@tabname nvarchar(MAX)='',      
@ColName nvarchar(MAX)='',      
@DisplayName nvarchar(MAX)='',      
@ColControlType nvarchar(MAX)='',      
@ColColor nvarchar(MAX)='',      
@DropDownLink nvarchar(MAX)='',      
@ColumnWidth nvarchar(MAX),  
@iseditable nvarchar(MAX)='',  
@sortindex nvarchar(MAX)='',  
@sortorder nvarchar(MAX)='',
@summarytype nvarchar(MAX)='',
@formaticon nvarchar(MAX)='',
@ismobile nvarchar(MAX)='',
@isrequired nvarchar(MAX)='',
@minval nvarchar(MAX)='',
@maxval nvarchar(MAX)=''
AS      
BEGIN      
      
DECLARE @count nvarchar(MAX)      
 SET @count=(select count(*) from obps_ColAttrib where tablename=@tabname and ColName=@ColName)      
 IF @count>0       
 BEGIN      
  update obps_ColAttrib set DisplayName=@DisplayName,ColControlType=@ColControlType,DropDownLink=@DropDownLink,ColColor=@ColColor ,      
  ColumnWidth= case when (@ColumnWidth='' or @ColumnWidth='0') then NULL else @ColumnWidth end, IsEditable=@iseditable,   
  SortIndex=@sortindex,SortOrder=@sortorder, SummaryType=@summarytype,FormatCondIconId=@formaticon,IsMobile=@ismobile,
  IsRequired=@isrequired,MinVal=@minval,MaxVal=@maxval
  where tablename=@tabname and ColName=@ColName     
  and LinkId=@linkid    
 END      
END       
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateDashboard]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_UpdateDashboard]
@sublinkid nvarchar(MAX)='',
@id  nvarchar(MAX)=''
AS
BEGIN

update obps_Dashboards set LinkId=@sublinkid where id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateDashboardConfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_UpdateDashboardConfig]  
@sublinkid nvarchar(MAX)='',  
@id nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @count nvarchar(MAX)  
 SET @count=(select count(*) from obps_Dashboards where id=@id)  
 IF @count>0   
 BEGIN  
  update obps_Dashboards set LinkId=@sublinkid where id=@id  
 END  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateDataDetails_FirstGrid]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_UpdateDataDetails_FirstGrid]
      @Field NVARCHAR(MAX),
      @value NVARCHAR(MAX),
	  @key nvarchar(50)
AS
BEGIN

	  DECLARE @query NVARCHAR(MAX)
	  DECLARE @query_Key NVARCHAR(MAX)
	  DECLARE @tabname NVARCHAR(MAX)
	  DECLARE @pkey NVARCHAR(MAX)
      SET NOCOUNT ON;
 
	SET @tabname=(SELECT DISTINCT t.name 
	FROM sys.sql_dependencies d 
	INNER JOIN sys.procedures p ON p.object_id = d.object_id
	INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
	where p.name='sp_getData_Grid1' )
	--SET @query_Key='SELECT TableKey FROM Obp_TableId WHERE TableName='+@tabname
	--SET @pkey=(SELECT @query_Key)
	
	SET @query_Key=('SELECT @key = TableKey FROM Obp_TableId WHERE TableName='''+@tabname+'''')
	--print @query_Key
	EXEC Sp_executesql  @query_Key,  N'@key NVARCHAR(MAX) output',  @pkey output
	--select @pkey
	 set @query='UPDATE '+@tabname+' set '+@Field+'='''+@value+''' where pid='+@key+''
	 print @query
	 EXEC (@query)
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateDataDetails_SecondGrid]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_UpdateDataDetails_SecondGrid]
      @Field NVARCHAR(MAX),
      @value NVARCHAR(MAX),
	  @key nvarchar(50)
AS
BEGIN

	  DECLARE @query NVARCHAR(MAX)
	  DECLARE @query_Key NVARCHAR(MAX)
	  DECLARE @tabname NVARCHAR(MAX)
	  DECLARE @pkey NVARCHAR(MAX)
      SET NOCOUNT ON;
 
	SET @tabname=(SELECT DISTINCT t.name 
	FROM sys.sql_dependencies d 
	INNER JOIN sys.procedures p ON p.object_id = d.object_id
	INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
	where p.name='sp_ReadData_SecondGrid' )
	SET @query_Key='SELECT TableKey FROM Obp_TableId WHERE TableName='+@tabname
	SET @pkey=(SELECT @query_Key)
	 set @query='UPDATE '+@tabname+' set '+@Field+'='''+@value+''' where pid='+@key+''
	 print @query
	 EXEC (@query)
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateDefaultValue]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_UpdateDefaultValue]
@TableName	  nvarchar(MAX)='',
@ColumnName		  nvarchar(MAX)='',
@default nvarchar(MAX)=''
AS
BEGIN

DECLARE @var_datatype int
DECLARE @Command nvarchar(max), @ConstraintName nvarchar(max)
set @var_datatype=(SELECT case when (DATA_TYPE='int' or DATA_TYPE='float' or DATA_TYPE='decimal') then 1 when  (DATA_TYPE='nvarchar' or DATA_TYPE='varchar') then 1 when DATA_TYPE='datetime' then 2 end 'Val'  FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME=@TableName and COLUMN_NAME=@ColumnName
)

SELECT @ConstraintName = name
    FROM sys.default_constraints
    WHERE parent_object_id = object_id(@TableName)
        AND parent_column_id = columnproperty(object_id(@TableName), @ColumnName, 'ColumnId')

SELECT @Command = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + @ConstraintName  
EXECUTE sp_executeSQL @Command

SELECT @Command = 'ALTER TABLE ' + @TableName + ' ADD CONSTRAINT ' + @ConstraintName + ' DEFAULT '+@default+' FOR ' + @ColumnName 
select @Command,@TableName,@ConstraintName,@default,@ColumnName
EXECUTE sp_executeSQL @Command

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateDropDownListTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_UpdateDropDownListTable]
@colid nvarchar(MAX)='',
@coltoins nvarchar(MAX)='',
@coltosel nvarchar(MAX)='',
@tabtosel nvarchar(MAX)='',
@isid nvarchar(MAX)='',
@id int
AS
BEGIN
select @isid
		update obps_DropDownTable set ColumnId=@colid,ColumnToInsert=@coltoins,ColumnToSelect=@coltosel,TableToSelect=@tabtosel,isId=@isid where id=@id
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateGanttDataDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_UpdateGanttDataDetails]
@key nvarchar(10)='',
@LinkId int='',
@usr nvarchar(MAX)='',
@start nvarchar(MAX)='',
@end nvarchar(MAX)='',
@subject nvarchar(MAX)=''
AS
BEGIN

DECLARE @startcol nvarchar(MAX)='',@endcol nvarchar(MAX)=''
,@tabname nvarchar(MAX)='',@subjectcol nvarchar(MAX)=''
,@string1 nvarchar(MAX)=''

SET @startcol=(SELECT StartColName from obps_GanttConfig where linkid=@LinkId)
SET @endcol=(SELECT EndColName from obps_GanttConfig where linkid=@LinkId)
SET @subjectcol=(SELECT SubjectColName from obps_GanttConfig where linkid=@LinkId)
SET @tabname=(SELECT Tablename from obps_GanttConfig where linkid=@LinkId)

SET @string1='update '+@tabname+' set '+@startcol+'='''+@start+''','+@endcol+'='''+@end+''','+@subjectcol+'='''+@subject+''' where id='+@key
exec (@string1)

END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateGridDataDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_UpdateGridDataDetails]                            
 @gridid NVARCHAR(MAX)=NULL,                            
 @str nvarchar(MAX),                            
 @key nvarchar(50)=NULL,                            
 @LinkId NVARCHAR(MAX)=NULL,                            
 @usr nvarchar(MAX)='' ,                        
 @loc nvarchar(MAX)=''                        
AS                            
BEGIN                            
  DECLARE @query NVARCHAR(MAX),                            
  @tabname NVARCHAR(MAX),                            
  @pkey NVARCHAR(MAX),                            
  @indx int,                            
  @colname_new NVARCHAR(MAX),                            
  @count int,                            
  @datatype nvarchar(MAX),                            
  @col varchar(MAX),                            
  @colnew varchar(MAX)='',                            
  @val nvarchar(MAX)='',                            
  @querystr nvarchar(MAX)=''  ,                          
  @aftersavespname nvarchar(MAX)='',                          
  @isLocation nvarchar(2)='',                        
  @locationColName nvarchar(max)=''                        
                          
  DECLARE @ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),                            
@controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int                            
                            
    SET NOCOUNT ON;                            
SET @tabname=(select GridTable from obps_TopLinkExtended where Linkid=@LinkId and GridId=@gridid)                         


IF @tabname is not null                            
BEGIN                            
                            
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                            
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval                            
FROM [dbo].[Split_UpdateSp] (@str, '^') ;                            
                             
OPEN CUR_TEST                            
FETCH NEXT FROM CUR_TEST INTO @col,@val                            
                             
WHILE @@FETCH_STATUS = 0                            
BEGIN                            
--select @col,@val                        
if CHARINDEX('__',@col) > 0                        
begin                        
SET @indx=(select CHARINDEX ('__',@col,0 ))                            
  --select 'value is '+@val                          
SET @colnew=(SELECT SUBSTRING(@col, 1,@indx-1))                            
SET @tabname=(SELECT SUBSTRING(@col, @indx+2, LEN(@col)))                            
SET @datatype=(SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE                             
TABLE_NAME = @tabname AND                             
COLUMN_NAME = @colnew)                            
--select @datatype                            
                    
set @controltype=(select ColControlType from obps_ColAttrib  where ColName=@colnew and TABLENAME = @tabname AND  linkid=@LinkId)                            
--if @datatype is not null                        
--begin                        
 if (CHARINDEX(@colnew,@querystr) <= 0  and lower(@colnew)<>'modifieddate'and lower(@colnew)<>'createddate')                      
 begin                        
  if LOWER(@controltype)='dropdownlist'                            
  begin                            
   --select 'inside'                            
   SET @colid=(SELECT id from obps_ColAttrib where colname=@colnew AND TABLENAME = @tabname and linkid=@linkid)                            
   SET @ddlcoltosel=(SELECT columntoselect from obps_dropdowntable where columnid=@colid)                             
   SET @ddlcoltoinsert=(SELECT columntoinsert from obps_dropdowntable where columnid=@colid)                            
   SET @ddltabletosel=(SELECT tabletoselect from obps_dropdowntable where columnid=@colid)                            
   SET @IsId=(SELECT IsId from obps_dropdowntable where columnid=@colid)                    
   --select @colid,@ddlcoltosel,@ddlcoltoinsert,@ddltabletosel,@IsId                            
IF @IsId=1                            
   BEGIN                            
    set @queryvalstr='select @ddlid=id from '+@ddltabletosel+' where '+@ddlcoltosel+'=N'''+@val+''''                   
    EXEC Sp_executesql  @queryvalstr,  N'@ddlid NVARCHAR(MAX) output',  @ddlid output                            
    SET @val=@ddlid                     
   --select @val,@queryvalstr,@ddltabletosel,@ddlcoltosel,@ddlid                          
   END                         
                         
   if @querystr=''                          
   begin                            
    set @querystr=@querystr+RTRIM(LTRIM(@ddlcoltoinsert)) +'='''+@val+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+RTRIM(LTRIM(@ddlcoltoinsert)) +'='''+@val+''''                            
   end                            
  end                      
  else  if @datatype='int'                            
  begin                            
   if @querystr=''                            
   begin                          
    set @querystr=@querystr+@colnew+'='+case when len(@val)>0 then @val else '''''' end                         
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'='+case when len(@val)>0 then @val else '''''' end                       
   end                            
  end                            
  else if @datatype='datetime' or @datatype='date'                            
  begin                            
   IF @val='null'                          
   BEGIN                            
    SET @val= ' '                            
   END                            
   if @querystr=''                            
   begin          
   set @querystr=@querystr+@colnew+'='''+ convert(CHAR(19),@val,120)+''''         
   -- set @querystr=@querystr+@colnew+'='''+ convert(CHAR(19),PARSE(@val AS datetime USING 'it-IT'),120)+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'='''+ convert(CHAR(19),@val,120)+''''                            
   end                            
  end                            
  else                            
  begin                            
   if @querystr=''                            
   begin                            
    set @querystr=@querystr+@colnew+'=N'''+@val+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'=N'''+@val+''''                            
   end                            
  end                            
                        
 end                        
end                        
--select @querystr                            
--END                            
  FETCH NEXT FROM CUR_TEST INTO @col,@val                            
END                            
CLOSE CUR_TEST                            
DEALLOCATE CUR_TEST                            
                            
                            
SET @isLocation=(select IsLocation from obps_TopLinks where id=@LinkId)                        
if(@isLocation='1')                        
BEGIN                        
                         
 SET @locationColName=(select locationcolname from obps_locationconfig where linkid=@LinkId)                        
 SET @querystr=@querystr+','+@locationColName+'='''+@loc+''''                        
                        
END                        
if(len(@querystr)>0)                      
BEGIN                      
                  
 SET @pkey=(SELECT TableKey FROM Obps_TableId WHERE TableName=@tabname )--and Linkid=@LinkId)                  
            
 set @querystr='update '+@tabname+' set '+@querystr+',ModifiedDate='''+CONVERT(VARCHAR,GETDATE(),121)+''',ModifiedBy='''+@usr+''' where '+@pkey+'='+@key+''                 
 select (@querystr)                            
 EXEC (@querystr)                            
                          
  SET @aftersavespname=(SELECT AfterSaveSp FROM Obps_TopLinkextended where GridId=@gridid and Linkid=@LinkId)             
                            
  IF len(Ltrim(rtrim(@aftersavespname)))>1                         
  BEGIN                            
  EXEC @aftersavespname @key
  Select @aftersavespname 'AfterSaveSP', @key 'Key'
  END                            
 END                         
END                            
END   
  
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateLinktemp]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[obps_sp_UpdateLinktemp]  
@menuid int='',  
@linkname nvarchar(MAX)='',  
@gid int='',  
@gridsp nvarchar(MAX)='',  
@gridtable nvarchar(MAX)='',  
@topid int='',  
@topExtndid int=''  
AS  
BEGIN  
  
update obps_TopLinks_temp set MenuId=@menuid,LinkName=@linkname where id=@topid  
  
update obps_TopLinkExtended_temp set GridId=@gid,GridSp=@gridsp,GridTable=@gridtable  
where id=@topExtndid  
  
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateRoleMapping]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_UpdateRoleMapping]
@id int='',
@index int=''
AS
BEGIN
BEGIN TRY
	update obps_RoleMap set VisibilityIndex=@index where id=@id
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateSchedulerDetails]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_UpdateSchedulerDetails]        
 @Gridname NVARCHAR(MAX)='',        
 @str nvarchar(MAX)='',     
 @key nvarchar(50)='',        
 @LinkId NVARCHAR(MAX)='',        
 @usr nvarchar(MAX)=''        
AS        
BEGIN        
        
  DECLARE @query NVARCHAR(MAX),        
  @query_Key NVARCHAR(MAX),        
  @tabname NVARCHAR(MAX),        
  @pkey NVARCHAR(MAX),        
  @tkey NVARCHAR(MAX),        
  @indx int,        
  @colname_new NVARCHAR(MAX),        
  @count int,        
  @datatype nvarchar(MAX),        
  @tabnamestr nvarchar(MAX),        
  @col varchar(MAX),        
  @colnew varchar(MAX)='',        
  @val nvarchar(MAX),        
  @querystr nvarchar(MAX)=''  ,      
  @aftersavesp nvarchar(MAX)='',      
  @aftersavespname nvarchar(MAX)='',      
  @aftersavespnamequery nvarchar(MAX)=''      
      
  DECLARE @gridid nvarchar(MAX),@ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),        
  @controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int    
  DECLARE @Start nvarchar(MAX)='', @End nvarchar(MAX)='', @Text nvarchar(MAX)='', @SchedulerType nvarchar(MAX)='',@include int=0  
        
    SET NOCOUNT ON;        
        
--SET @indx=(select CHARINDEX ('__',@Field,0 ))        
--SET @colname_new=(SELECT SUBSTRING(@Field, 1, @indx-1))        
SET @tabnamestr=('select @tabname='+@Gridname+' from obps_toplinks where ID='+@LinkId)        
EXEC Sp_executesql  @tabnamestr,  N'@tabname NVARCHAR(MAX) output',  @tabname output     
   
  
  SET @Start=(select StartdateCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)    
  SET @End=(select EnddateCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)       
  SET @Text=(select TextCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)    
  SET @SchedulerType=(select SchedulerTypeCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)    
  
IF @tabname is not null        
BEGIN        
        
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR        
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval        
FROM [dbo].[Split_UpdateSp] (@str, ',') ;        
         
OPEN CUR_TEST        
FETCH NEXT FROM CUR_TEST INTO @col,@val        
 WHILE @@FETCH_STATUS = 0        
 BEGIN        
 select @col,@val  
 set @include=0  
 if @col='id'or @col='allDay'   
  set @include=0  
 if(@col='Startdate')  
 begin  
  if (trim(@Start)<>'' or @Start is not null)  
  begin  
   set @include=1  
   set @col=@Start  
   set @val=dateadd(MINUTE,30,dateadd(hour,5,CONVERT(datetime,@val)))  
  end  
 end  
 if(@col='Enddate')  
 begin  
  if (trim(@End)<>'' or @End is not null)  
  begin  
  select 'inside'  
  select @End  
   set @include=1  
   set @col=@End  
   set @val=dateadd(MINUTE,30,dateadd(hour,5,CONVERT(datetime,@val)))  
  end  
 end  
 if(@col='Text')  
 begin  
  if (trim(@Text)<>'' or @Text is not null)  
  begin  
   set @include=1  
   set @col=@Text  
  end  
 end  
 if(@col='ScheduleType')  
 begin  
  if (trim(@SchedulerType)<>'' or @SchedulerType is not null)  
  begin  
   set @include=1  
   set @col=@SchedulerType  
  end  
 end  
      
    
  if @include=1  
  begin  
  
 if @querystr=''        
    begin        
  set @querystr=@querystr+@col+'='''+@val+''''        
    end        
    else        
    begin        
  set @querystr=@querystr+','+@col+'='''+@val+''''        
    end  
  
  end  
  
   FETCH NEXT FROM CUR_TEST INTO @col,@val        
 END        
CLOSE CUR_TEST        
DEALLOCATE CUR_TEST        
        
 END       
        
set @querystr='update '+@tabname+' set '+@querystr++',ModifiedDate='''+CONVERT(CHAR(10),  GETDATE(), 120)+''',ModifiedBy='''+@usr+''' where id='+@key+''       
select @querystr      
EXEC (@querystr)        
      
      
 SET @aftersavesp=(SELECT SUBSTRING(@Gridname, 1,5)+'AfterSaveSp')      
      
 SET @aftersavespnamequery=('(SELECT @aftersavespname='+@aftersavesp+' FROM Obps_TopLinks where '+@aftersavesp+'  is not null and Id='''+@LinkId+''')')        
 EXEC Sp_executesql  @aftersavespnamequery,  N'@aftersavespname NVARCHAR(MAX) output', @aftersavespname output        
        
 IF len(Ltrim(rtrim(@aftersavespname)))>1     
 BEGIN        
  select 'aftersave'      
 EXEC @aftersavespname @key      
 END        
      
END        
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateTable]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[obps_sp_UpdateTable]
@tabname nvarchar(MAX)='',
@ColName nvarchar(MAX)='',
--@OldColName nvarchar(MAX)='',
@datatype nvarchar(MAX)='',
@Olddatatype nvarchar(MAX)='',
@default nvarchar(MAX)='',
@Olddefault nvarchar(MAX)='',
@allownull nvarchar(MAX)='',
@isusercol nvarchar(MAX)=''
AS
BEGIN
DECLARE @str nvarchar(MAX)=''
DECLARE @allownullstr nvarchar(MAX)=''

if @allownull='1'
BEGIN
SET @allownullstr='ALTER TABLE '+@tabname+' ALTER COLUMN '+@ColName+ ' '+ @datatype+'  NULL;'
END
else
SET @allownullstr='ALTER TABLE '+@tabname+' ALTER COLUMN '+@ColName+ ' '+ @datatype+'  NOT NULL;'
if(@allownullstr <>'' or @allownullstr is not null)
begin
select @allownullstr
exec (@allownullstr)
end

if @isusercol<>0
update obps_TableId set TableUserCol=@ColName where TableName=@tabname

if(@datatype='nvarchar')
set @datatype='nvarchar(MAX)'

if @datatype<>@Olddatatype
BEGIN
set @str='ALTER TABLE '+@tabname+' ALTER COLUMN '+@ColName+' ' +@datatype
END
if(@str <>'' or @str is not null)
BEGIN
exec (@str)
END



if @default<>''
BEGIN
exec obps_sp_UpdateDefaultValue @tabname,@ColName,@default
END
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateUser]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_UpdateUser]    
@UserName nvarchar(MAX)='',    
@RoleId nvarchar(MAX)='',    
@Company nvarchar(MAX)='', 
@email  nvarchar(MAX)='', 
@Division nvarchar(MAX)='',    
@Department nvarchar(MAX)='',    
@SubDept nvarchar(MAX)='',    
@UserTypeId nvarchar(MAX)='',    
@DefaultLinkId nvarchar(MAX)='',    
@id nvarchar(MAX)=''  ,  
@AfterLoginSp nvarchar(MAX)='' ,
@reportingmanager nvarchar(MAX)='' 
AS    
BEGIN    
    
DECLARE @count nvarchar(MAX)    
DECLARE @userselcount nvarchar(MAX)    
DECLARE @userlinkid nvarchar(MAX)=''    
    
 SET @count=(select count(*) from obps_Users where id=@id)    
 IF @count>0     
 BEGIN    
  update obps_Users set UserName=@UserName,RoleId=@RoleId,Company=@Company,Division=@Division,    
  Department=@Department,SubDept=@SubDept,emailid=@email,UserTypeId=@UserTypeId,DefaultLinkId=@DefaultLinkId,  
  AfterLoginSP=@AfterLoginSp,reportingmanager=@reportingmanager where ID=@id    
    
  SET @userselcount=(select count(*) from obps_UserLinks where UserId=@id and RoleId=@RoleId)    
  IF @userselcount=0    
  BEGIN    
   update obps_UserLinks set RoleId=@RoleId where UserId=@id    
       
   DECLARE CUR_TESTRoleMap CURSOR FAST_FORWARD FOR    
   select id from obps_UserLinks where UserId=@id and IsDeleted=0    
   OPEN CUR_TESTRoleMap    
   FETCH NEXT FROM CUR_TESTRoleMap INTO @userlinkid    
   WHILE @@FETCH_STATUS = 0    
   BEGIN    
    select @userlinkid    
    exec obps_sp_InsertRoleMapping @userlinkid    
    FETCH NEXT FROM CUR_TESTRoleMap INTO @userlinkid    
   END    
   CLOSE CUR_TESTRoleMap    
   DEALLOCATE CUR_TESTRoleMap    
   END    
 END    
END    
    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateUserLink]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_UpdateUserLink]    
@mainmenu nvarchar(MAX)='',    
@sublink nvarchar(MAX)='',    
@mainmenuid nvarchar(MAX)='',    
@sublinkid nvarchar(MAX)='',    
@isactive nvarchar(MAX)='',    
@id nvarchar(MAX)=''  ,  
@isrole nvarchar(MAX)=''  
AS    
BEGIN    
DECLARE @count nvarchar(MAX)    
 SET @count=(select count(*) from obps_UserLinks where id=@id)    
 IF @count>0     
 BEGIN    
  update obps_UserLinks set LinkName=@mainmenu,LinkId=@mainmenuid,     
  sublinkid=@sublinkid,IsActive=@isactive,isroleattached=@isrole where id=@id    
  if(@isrole=1)
	exec obps_sp_InsertRoleMapping @id    
 END    
END    
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateUserPermission]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_UpdateUserPermission]
@id int=0,
@userid nvarchar(MAX)='',
@linkid nvarchar(MAX)='',
@gid nvarchar(MAX)='',
@par1 nvarchar(MAX)='',
@par2 nvarchar(MAX)='',
@par3 nvarchar(MAX)='',
@par4 nvarchar(MAX)='',
@par5 nvarchar(MAX)=''
AS
BEGIN
BEGIN TRY

	update obps_SpPermissions set userid=@userid,Linkid=@linkid,
		   gridid=@gid,Par1=@par1,Par2=@par2,Par3=@par3,
		   par4=@par4,par5=@par5 where id=@id

END TRY
BEGIN CATCH
	select ERROR_MESSAGE()
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateUsertemp]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_UpdateUsertemp]        
@UserName nvarchar(MAX)='',        
@RoleId nvarchar(MAX)='',        
@Company nvarchar(MAX)='',     
@email  nvarchar(MAX)='',     
@Division nvarchar(MAX)='',        
@Department nvarchar(MAX)='',        
@SubDept nvarchar(MAX)='',        
@UserTypeId nvarchar(MAX)='',        
@DefaultLinkId nvarchar(MAX)='',        
@id nvarchar(MAX)=''  ,      
@AfterLoginSp nvarchar(MAX)='' ,    
@reportingmanager nvarchar(MAX)=''     
AS        
BEGIN        
        
DECLARE @count nvarchar(MAX)        
DECLARE @userselcount nvarchar(MAX)        
DECLARE @userlinkid nvarchar(MAX)=''        
        
 SET @count=(select count(*) from obps_Users where id=@id)        
 --IF @count>0         
 BEGIN        
  update obps_Users_temp set UserName=@UserName,RoleId=@RoleId,Company=@Company,Division=@Division,        
  Department=@Department,SubDept=@SubDept,emailid=@email,UserTypeId=@UserTypeId,DefaultLinkId=@DefaultLinkId,      
  AfterLoginSP=@AfterLoginSp,reportingmanager=@reportingmanager where ID=@id        
        
 END        
END 
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ValidateLogin]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ValidateLogin]  
 @usrname nvarchar(MAX),  
 @pass nvarchar(MAX),  
 @usrtype nvarchar(MAX)=''  
AS  
BEGIN  
 IF @usrtype=''  
 BEGIN  
  select Password from [dbo].[obps_Users] U inner join [dbo].[obps_UserType] UT   
  on U.UserTypeId=UT.UserTypeId  
  where UserName=@usrname COLLATE Latin1_General_CS_AS   
 END  
 ELSE  
 BEGIN  
  select Password from [dbo].[obps_Users] U inner join [dbo].[obps_UserType] UT   
  on U.UserTypeId=UT.UserTypeId and UT.UserType=@usrtype  
  where UserName=@usrname COLLATE Latin1_General_CS_AS 
 END  
END  
GO
/****** Object:  StoredProcedure [dbo].[obps_SpRowConditioning]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obps_SpRowConditioning]                
(@var_tableid int,@var_id int)                
as                
begin                
if @var_tableid=301                
begin                
update obp_TaskHeader set Color1=case when priority='H' then 'Red' when priority='M' then 'Yellow' else 'White' end where id=@var_id                
update obp_TaskHeader set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end                 
where                 
id=@var_id and th_TaskHeader<>'Click + Sign to Add Records'                
/*              
update obp_TaskHeader set TimeBuffer=case when datediff(dd, CreatedDate,getdate()-1)  between 0 and (datediff(dd, CreatedDate,EstDueDate)/3) then 'Green'                
when datediff(dd, CreatedDate,getdate()-1)  between ((datediff(dd, CreatedDate,EstDueDate)/3)+1) and ((datediff(dd, CreatedDate,EstDueDate)*2)/3) then 'Yellow'               
when datediff(dd, CreatedDate,getdate()-1)  between (((datediff(dd, CreatedDate,EstDueDate)*2)/3)+1) and datediff(dd, CreatedDate,EstDueDate) then 'Red'               
when datediff(dd, CreatedDate,getdate()-1) > datediff(dd, CreatedDate,EstDueDate) then 'Black' end              
where                 
id=@var_id and                 
TaskStatus in ('IP','NS') and EstDueDate is not null and th_TaskHeader <> 'Click + Sign to Add Records'              
*/            
update obp_TaskHeader set TimeBuffer=case   
when datediff(dd, PlannedStartDt,getdate())  < 0  then 'Cyan'  
when datediff(dd, PlannedStartDt,getdate())  between 0 and (datediff(dd, PlannedStartDt,TaskActEstDt)/3) then 'Green'                
when datediff(dd, PlannedStartDt,getdate())  between ((datediff(dd, PlannedStartDt,TaskActEstDt)/3)+1) and ((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3) then 'Yellow'               
when datediff(dd, PlannedStartDt,getdate())  between (((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3)+1) and datediff(dd, PlannedStartDt,TaskActEstDt) then 'Red'               
when datediff(dd, PlannedStartDt,getdate()) > datediff(dd, PlannedStartDt,TaskActEstDt) then 'Black' end              
where                 
id=@var_id and                 
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'              
            
            
update obp_TaskHeader set TimeBuffer='Black' where id=@var_id and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<=0            
and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'              
              
update obp_TaskHeader set color3=TimeBuffer where id=@var_id and                 
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'              
              
update obp_TaskHeader set BlackExcedDays=case when datediff(dd,TaskActEstDt,getdate()) > 0 then datediff(dd,TaskActEstDt,getdate()) else 0 end              
where id=@var_id and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'               
--and timebuffer ='Black'          
      
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where TaskDuration<=2 and isnull(BlackExcedDays,0)<1      
              
end                
                
if @var_tableid=302                
begin    
    
/*Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                
Declare @var_headerticketid int,@var_PlannedStartDt datetime,@var_TaskActEstDt datetime,@var_TaskDuration int,@var_TaskActStartDt datetime    
    
Set @var_headerticketid =(Select top 1 TaskHeaderID from obp_TaskHeader where id=@var_id)    
Set @var_PlannedStartDt =(Select min(isnull(PlannedStartDt,'1900-01-01')) from obp_TaskHeader where TaskHeaderID=@var_headerticketid  and th_TaskHeader<>'Click + Sign to Add Records')    
Set @var_TaskActEstDt =(Select max(isnull(TaskActEstDt,'1900-01-01')) from obp_TaskHeader where TaskHeaderID=@var_headerticketid and th_TaskHeader<>'Click + Sign to Add Records')    
Set @var_TaskActStartDt =(Select max(isnull(TaskActStartDt,'1900-01-01')) from obp_TaskHeader where TaskHeaderID=@var_headerticketid and th_TaskHeader<>'Click + Sign to Add Records')    
    
Select @var_headerticketid ,@var_PlannedStartDt ,@var_TaskActEstDt ,@var_TaskDuration,@var_TaskActStartDt    
    
if @var_PlannedStartDt<>'1900-01-01'    
Begin    
Update obp_TaskHeader set PlannedStartDt=@var_PlannedStartDt where id=@var_headerticketid    
End    
Else    
Begin    
Update obp_TaskHeader set PlannedStartDt=null where id=@var_headerticketid    
End    
    
if @var_TaskActEstDt<>'1900-01-01'    
Begin    
Update obp_TaskHeader set TaskActEstDt=@var_TaskActEstDt where id=@var_headerticketid    
End    
Else    
Begin    
Update obp_TaskHeader set TaskActEstDt=null where id=@var_headerticketid    
End    
    
if @var_TaskActStartDt<>'1900-01-01'    
Begin    
Update obp_TaskHeader set TaskActStartDt=@var_TaskActStartDt where id=@var_headerticketid    
End    
Else    
Begin    
Update obp_TaskHeader set TaskActStartDt=null where id=@var_headerticketid    
End    
    
update obp_TaskHeader set TaskDuration= case when (isnull(@var_PlannedStartDt,'1900-01-01')<>'1900-01-01' and isnull(@var_TaskActEstDt,'1900-01-01')<>'1900-01-01') then     
datediff(dd,@var_PlannedStartDt,@var_TaskActEstDt) else null end     
where id=@var_headerticketid    
  
/*TimeBuffer*/  
update obp_TaskHeader set TimeBuffer=case   
when datediff(dd, PlannedStartDt,getdate())  < 0  then 'Cyan'  
when datediff(dd, PlannedStartDt,getdate())  between 0 and (datediff(dd, PlannedStartDt,TaskActEstDt)/3) then 'Green'                
when datediff(dd, PlannedStartDt,getdate())  between ((datediff(dd, PlannedStartDt,TaskActEstDt)/3)+1) and ((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3) then 'Yellow'               
when datediff(dd, PlannedStartDt,getdate())  between (((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3)+1) and datediff(dd, PlannedStartDt,TaskActEstDt) then 'Red'               
when datediff(dd, PlannedStartDt,getdate()) > datediff(dd, PlannedStartDt,TaskActEstDt) then 'Black' end              
where                 
(id=@var_id or id=@var_headerticketid  ) and                 
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'              
            
            
update obp_TaskHeader set TimeBuffer='Black' where (id=@var_id or id=@var_headerticketid ) and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<=0            
and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'              
              
update obp_TaskHeader set color3=TimeBuffer where (id=@var_id or id=@var_headerticketid) and                 
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'              
              
update obp_TaskHeader set BlackExcedDays=case when datediff(dd,TaskActEstDt,getdate()) > 0 then datediff(dd,TaskActEstDt,getdate()) else 0 end              
where (id=@var_id or id=@var_headerticketid) and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'               
--and timebuffer ='Black'          
      
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where TaskDuration<=2 and isnull(BlackExcedDays,0)<1  
/*End - TimeBuffer*/  
    
--update obp_TaskHeader set PlannedStartDt= TaskHeaderID    
/*End - Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                
--update obp_TaskDetails set Color1=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='NS' then 'Red' else 'White' end where id=@var_id                
update obp_TaskHeader set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end                 
where                 
id=@var_id         
/*         
and                 
TaskDetail<>'Click + Sign to Add Records'                
*/        
end                
                
end       
GO
/****** Object:  StoredProcedure [dbo].[obps_SpRowConditioning_old]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[obps_SpRowConditioning_old]  
(@var_tableid int,@var_id int)  
as  
begin  
if @var_tableid=301  
begin  
update obp_TaskHeader set Color1=case when priority='H' then 'Red' when priority='M' then 'Yellow' else 'White' end where id=@var_id  
update obp_TaskHeader set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end   
where   
id=@var_id and   
th_TaskHeader<>'Click + Sign to Add Records'  
end  
  
if @var_tableid=302  
begin  
--update obp_TaskDetails set Color1=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='NS' then 'Red' else 'White' end where id=@var_id  
update obp_TaskDetails set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end   
where   
id=@var_id and   
TaskDetail<>'Click + Sign to Add Records'  
end  
  
end  
GO
/****** Object:  StoredProcedure [dbo].[obps_updatedashboardconfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_updatedashboardconfig]
@id int='',
@caption nvarchar(MAX)='',
@linkid nvarchar(5)=''
AS
BEGIN

update obps_Dashboards set Caption=@caption,LinkId=@linkid where id=@id

END
GO
/****** Object:  StoredProcedure [dbo].[obps_updateganttconfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_updateganttconfig]
@id int='',
@linkid nvarchar(10)='',
@tablename nvarchar(MAX)='',
@subject nvarchar(MAX)='',
@start nvarchar(MAX)='',
@end nvarchar(MAX)='',
@pred nvarchar(MAX)='',
@succ nvarchar(MAX)=''
AS
BEGIN

select '1'

END
GO
/****** Object:  StoredProcedure [dbo].[obps_updateimportconfig]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_updateimportconfig]  
@id nvarchar(MAX)='',  
@toplinkid nvarchar(MAX)='',  
@tablename nvarchar(MAX)='',  
@temptablename nvarchar(MAX)='',  
@insertsp nvarchar(MAX)='',  
@genfilesp nvarchar(MAX)='',  
@deletesp nvarchar(MAX)='',  
@importerroroutsp nvarchar(MAX)='',  
@importsavedoutsp nvarchar(MAX)=''   
AS  
BEGIN  
if(@id='')  
 insert into obps_ExcelImportConfig(TableName,TempTableName,InsertSp,GenFileSp,DeleteSp,LinkId)  
 values(@tablename,@temptablename,@insertsp,@genfilesp,@deletesp,@toplinkid)  
ELSE   
 update obps_ExcelImportConfig set TableName=@tablename, TempTableName=@temptablename,  
   InsertSp=@insertsp,GenFileSp=@genfilesp,deletesp=@deletesp  
   where id=@id  
update obps_TopLinks set importerroroutsp=@importerroroutsp,importsavedoutsp=@importsavedoutsp, IsImportEnabled=1  
  where id=@toplinkid  
  
END 
GO
/****** Object:  StoredProcedure [dbo].[opb_sp_TruckAvailablity]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE proc [dbo].[opb_sp_TruckAvailablity] -- 'GC',100,'',''               
   (          
@var_user nvarchar(100)=''                                                       
,@var_pid int=''                                                       
,@var_clientid int=''          
,@par1 nvarchar(MAX)=''           
          
)          
   as          
   begin          
        
        
  --  if exists(select 1 from obp_avltruckcapacity where mainid=@var_pid  )        
  --  begin        
           
  --   select id,          
  --   sentfrom as sentfrom__obp_avltruckcapacity,          
  --   tolocation as tolocation__obp_avltruckcapacity,          
  --   truckno as truckno__obp_avltruckcapacity,          
  --   truckcap as truckcap__obp_avltruckcapacity,          
  --   percentagefill as percentagefill__obp_avltruckcapacity from obp_avltruckcapacity where mainid=@var_pid     
	 --and convert(nvarchar(10),CreatedDate,103)=convert(nvarchar(10),GETDATE(),103)  
  -- end     
  --  else        
  --  begin 
		declare @plant nvarchar(200),@branch nvarchar(200)
	     select @plant=SentFrom,@branch=ToLocation from obp_TotalLoad where id= @var_pid
		 and convert(nvarchar(10),CreatedDate,103)=convert(nvarchar(10),GETDATE(),103) 
         if not exists(select 1 from obp_avltruckcapacity where SentFrom=@plant and ToLocation=@branch and 
		 convert(nvarchar(10),CreatedDate,103)=convert(nvarchar(10),GETDATE(),103) )
		 begin
		   print 'i am in'
			insert into  obp_avltruckcapacity(SentFrom,ToLocation) values(@plant,@branch)    
		 end
		 select id,    
		 sentfrom as sentfrom__obp_avltruckcapacity,          
		 tolocation as tolocation__obp_avltruckcapacity,          
		 truckno as truckno__obp_avltruckcapacity,          
		 truckcap as truckcap__obp_avltruckcapacity,          
		 percentagefill as percentagefill__obp_avltruckcapacity from obp_avltruckcapacity where SentFrom=@plant and ToLocation=@branch
		 and convert(nvarchar(10),CreatedDate,103)=convert(nvarchar(10),GETDATE(),103) 
  --  end        
   end 
GO
/****** Object:  StoredProcedure [dbo].[ReadRemarks]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ReadRemarks]     
@UserName NVARCHAR(MAX)= '',      
@selectedid nvarchar(MAX)=''     
AS     
BEGIN     
Declare @var_MID nvarchar(max)     
declare @rem nvarchar(max)=''
    
Set @var_MID=@selectedid       
    
set @rem='Select CONVERT(Char(16), min(RecordDate) ,20) ''Update Date'',isnull(th_Remarks,'''') ''RemarksHistory for #'+@var_MID+''' from obp_TaskHeader_Trace where th_Remarks is not null  and id='+@var_MID+'   
group by th_Remarks  order by  [Update Date] desc '
exec (@rem)
    
--Select Concat('[',CONVERT(VARCHAR, min(RecordDate), 120),'] - ',isnull(th_Remarks,'')) 'RemarksHistory' from obp_TaskHeader_Trace where th_Remarks is not null  and id=@var_MID    
--group by th_Remarks  order by RemarksHistory desc     
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Dash_ColorStatCombined]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[SP_Dash_ColorStatCombined] as

Select 'Site' Type,* 
from obp_finolex.dbo.CH_ColorStatSite a

union all

Select 'Pipe' Type,* 
from obp_finolex.dbo.CH_ColorStatSite a
order by updatedate, branch
GO
/****** Object:  StoredProcedure [dbo].[SP_ImportData]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[SP_ImportData] as
BEGIN

truncate table [obp_Finolex].[dbo].[obp_OB_VY41]

IF (OBJECT_ID('allfilenames') IS NOT NULL)
drop table allfilenames;
 
IF (OBJECT_ID('bulkact') IS NOT NULL)
drop table bulkact;
 
CREATE TABLE ALLFILENAMES(WHICHPATH VARCHAR(255),WHICHFILE varchar(255))
CREATE TABLE BULKACT(RAWDATA VARCHAR (8000))
declare @filename varchar(255),
        @path     varchar(255),
        @sql      varchar(8000),
        @cmd      varchar(1000)
 
SET @path = 'E:\ImportYE41\'
SET @cmd = 'dir "' + @path + '" *.csv /b'
INSERT INTO  ALLFILENAMES(WHICHFILE)
EXEC Master..xp_cmdShell @cmd
UPDATE ALLFILENAMES SET WHICHPATH = @path where WHICHPATH is null

--cursor loop
    declare c1 cursor for SELECT WHICHPATH,WHICHFILE FROM ALLFILENAMES where WHICHFILE like 'OB_YV41%.csv%'
    open c1
    fetch next from c1 into @path,@filename
    While @@fetch_status <> -1
      begin
      --bulk insert won't take a variable name, so make a sql and execute it instead:
       set @sql = 'BULK INSERT OB_YV41 FROM ''' + @path + @filename + ''' '
           + '     WITH ( 
                   FIELDTERMINATOR = '','', 
                   ROWTERMINATOR = ''\n'', 
                   FIRSTROW = 2 
                ) '
   -- print @sql
    exec (@sql)
 
      fetch next from c1 into @path,@filename
      end
    close c1
    deallocate c1
end
GO
/****** Object:  StoredProcedure [dbo].[SP_InitialBufferCal]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[SP_InitialBufferCal]
as
Begin

Begin

truncate table InitBufferCal_SKU_01

Declare @var_dateto date,@var_datefrom date

set @var_datefrom='2021-06-01'
set @var_dateto='2022-06-14'

While @var_datefrom<>@var_dateto
begin

insert into InitBufferCal_SKU_01
Select distinct @var_datefrom,sku_id,style_id,clusters,0,0 from InitBufferCal_SKU where order_created_date between '2021-06-01' and '2022-06-13'

set @var_datefrom=DATEADD(dd,1,@var_datefrom)
end

update a set a.quantity=b.quantity from InitBufferCal_SKU_01 a,(Select order_created_date,sku_id,style_id,clusters,sum(isnull(quantity,0)) 'quantity' from InitBufferCal_SKU where order_created_date between '2021-06-01' and '2022-06-13' group by order_created_date,sku_id,style_id,clusters)  b where a.order_created_date=b.order_created_date and a.sku_id=b.sku_id and a.style_id=b.style_id and a.clusters=b.clusters

End

/***************/

Begin

If OBJECT_ID('tempdb..#tb_InitBufferOutput') is not null 
drop table #tb_InitBufferOutput

If OBJECT_ID('tempdb..#tb_InitBufferBuckets') is not null 
drop table #tb_InitBufferBuckets

If OBJECT_ID('tempdb..#tb_InitBufferBucketsInRows') is not null 
drop table #tb_InitBufferBucketsInRows

If OBJECT_ID('tempdb..#tb_InitBufferBucketsOtherCal') is not null 
drop table #tb_InitBufferBucketsOtherCal

If OBJECT_ID('tempdb..#tb_FinalOutput') is not null 
drop table #tb_FinalOutput



Create table #tb_InitBufferOutput
(
Id int identity(1,1)
,SKU nvarchar(max)
,Style nvarchar(max)
,Cluster nvarchar(max)
,TotalSaleForSeason float
,MaxBucketSize float
,MaxBucketSize_61st float
,MaxBucketSize_121st float
,AvgOfAllBuckets float
,StdDev float
,AvgOfAllBuckets_05 float
,AvgOfAllBuckets_1 float
,AvgOfAllBuckets_15 float
,AvgOfAllBuckets_2 float
,ReportedDate datetime
)

Create table #tb_InitBufferBuckets
(
Id int identity(1,1)
,SKU nvarchar(max)
,Style nvarchar(max)
,Cluster nvarchar(max)
,[Bucket-1] float
,[Bucket-2] float
,[Bucket-3] float
,[Bucket-4] float
,[Bucket-5] float
,[Bucket-6] float
,[Bucket-7] float
,[Bucket-8] float
,[Bucket-9] float
,[Bucket-10] float
,[Bucket-11] float
,[Bucket-12] float
,[Bucket-13] float
,[Bucket-14] float
,[Bucket-15] float
,[Bucket-16] float
,[Bucket-17] float
,[Bucket-18] float
,[Bucket-19] float
,[Bucket-20] float
,[Bucket-21] float
,[Bucket-22] float
,[Bucket-23] float
,[Bucket-24] float
,[Bucket-25] float
,[Bucket-26] float
,[Bucket-27] float
,[Bucket-28] float
,[Bucket-29] float
,[Bucket-30] float
,[Bucket-31] float
,[Bucket-32] float
,[Bucket-33] float
,[Bucket-34] float
,[Bucket-35] float
,[Bucket-36] float
,[Bucket-37] float
,[Bucket-38] float
,[Bucket-39] float
,[Bucket-40] float
,[Bucket-41] float
,[Bucket-42] float
,[Bucket-43] float
,[Bucket-44] float
,[Bucket-45] float
,[Bucket-46] float
,[Bucket-47] float
,[Bucket-48] float
,[Bucket-49] float
,[Bucket-50] float
,[Bucket-51] float
,[Bucket-52] float
,[Bucket-53] float
,[Bucket-54] float
,[Bucket-55] float
,[Bucket-56] float
,[Bucket-57] float
,[Bucket-58] float
,[Bucket-59] float
,[Bucket-60] float
,[Bucket-61] float
,[Bucket-62] float
,[Bucket-63] float
,[Bucket-64] float
,[Bucket-65] float
,[Bucket-66] float
,[Bucket-67] float
,[Bucket-68] float
,[Bucket-69] float
,[Bucket-70] float
,[Bucket-71] float
,[Bucket-72] float
,[Bucket-73] float
,[Bucket-74] float
,[Bucket-75] float
,[Bucket-76] float
,[Bucket-77] float
,[Bucket-78] float
,[Bucket-79] float
,[Bucket-80] float
,[Bucket-81] float
,[Bucket-82] float
,[Bucket-83] float
,[Bucket-84] float
,[Bucket-85] float
,[Bucket-86] float
,[Bucket-87] float
,[Bucket-88] float
,[Bucket-89] float
,[Bucket-90] float
,[Bucket-91] float
,[Bucket-92] float
,[Bucket-93] float
,[Bucket-94] float
,[Bucket-95] float
,[Bucket-96] float
,[Bucket-97] float
,[Bucket-98] float
,[Bucket-99] float
,[Bucket-100] float
,[Bucket-101] float
,[Bucket-102] float
,[Bucket-103] float
,[Bucket-104] float
,[Bucket-105] float
,[Bucket-106] float
,[Bucket-107] float
,[Bucket-108] float
,[Bucket-109] float
,[Bucket-110] float
,[Bucket-111] float
,[Bucket-112] float
,[Bucket-113] float
,[Bucket-114] float
,[Bucket-115] float
,[Bucket-116] float
,[Bucket-117] float
,[Bucket-118] float
,[Bucket-119] float
,[Bucket-120] float
,[Bucket-121] float
,[Bucket-122] float
,AvgOfAllBuckets float
,StdDevForAllBuckets float
,[Avg+0.5StdDev] float
,[Avg+1StdDev] float
,[Avg+1.5StdDev] float
,[Avg+2.0StdDev] float
,[1stMax] float
,[2ndMax] float
,[3rdMax] float

)


Create table #tb_InitBufferBucketsInRows
(
Id int identity(1,1)
,SKU nvarchar(max)
,Style nvarchar(max)
,Cluster nvarchar(max)
,BucketNo int
,BucketValue float
)

Create table #tb_InitBufferBucketsOtherCal
(
Id int identity(1,1)
,SKU nvarchar(max)
,Style nvarchar(max)
,Cluster nvarchar(max)
,AvgOfAllBuckets float
,StdDevForAllBuckets float
,[Avg+0.5StdDev] float
,[Avg+1StdDev] float
,[Avg+1.5StdDev] float
,[Avg+2.0StdDev] float
,[1stMax] float
,[2ndMax] float
,[3rdMax] float
)

Insert into #tb_InitBufferOutput(SKU,Style,Cluster)
Select distinct sku_id,style_id,clusters from InitBufferCal_SKU_01

/*
Select sum(quantity) 'TtlSales',datediff(dd,'2021-02-01','2021-08-01') 'Days',convert(float,((sum(quantity)/datediff(dd,'2021-02-01','2021-08-01')))) 'MeanVal' from InitBufferCal_SKU_01 where sku_id='46335787' and	style_id='13611338' and clusters='Delhi-NCR'
*/

update a set a.TotalSaleForSeason=b.TtlSales from #tb_InitBufferOutput a,(Select sku_id,style_id,clusters,sum(quantity) 'TtlSales' from InitBufferCal_SKU_01 group by sku_id,style_id,clusters) b 
where a.SKU collate database_default=b.sku_id and a.Style collate database_default=b.style_id and a.Cluster collate database_default=b.clusters


Insert into #tb_InitBufferBuckets(SKU,Style,Cluster)
Select distinct sku_id,style_id,clusters from InitBufferCal_SKU_01

Insert into #tb_InitBufferBucketsOtherCal(SKU,Style,Cluster)
Select distinct sku_id,style_id,clusters from InitBufferCal_SKU_01

Declare @var_BucketDateFrom date,@var_BucketDateTo date,@var_BucketSize int
Declare @var_BucketCount int, @var_BucketNo int
Declare @var_sql varchar(8000)


set @var_BucketNo=1
set @var_BucketSize=60
set @var_BucketDateFrom='2021-06-01'
set @var_BucketDateTo='2022-06-13'
set @var_BucketCount=(Select datediff(dd,@var_BucketDateFrom,@var_BucketDateTo)-(@var_BucketSize-1))
--Select datediff(dd,'2021-02-01','2021-07-31')-(59)

set @var_BucketDateTo=DATEADD(dd,59,@var_BucketDateFrom)

While @var_BucketNo<=@var_BucketCount
--While @var_BucketNo<=2
begin

If OBJECT_ID('tempdb..#tb_BucketData_Temp') is not null
drop table #tb_BucketData_Temp

Insert into #tb_InitBufferBucketsInRows(sku,style,cluster,BucketNo,BucketValue)
Select sku_id,style_id,clusters,@var_BucketNo,sum(quantity) 'TtlSale' 
from InitBufferCal_SKU_01 
where order_created_date between @var_BucketDateFrom and @var_BucketDateTo
group by sku_id,style_id,clusters

--print @var_BucketDateFrom
--print @var_BucketDateTo


/*
set @var_sql='update a set a.[Bucket-'+convert(nvarchar(10),@var_BucketNo)+']=b.TtlSale from #tb_InitBufferBuckets a, #tb_BucketData_Temp b where a.SKU=b.sku_id and a.Style=b.style_id and a.Cluster=b.clusters'

exec (@var_sql)          
      
print @var_sql 

set @var_sql='update a set a.[Bucket-'+convert(nvarchar(10),@var_BucketCount+1)+']=isnull(a.[Bucket-'+convert(nvarchar(10),@var_BucketCount+1)+'],0)+isnull(b.TtlSale,0) from #tb_InitBufferBuckets a, #tb_BucketData_Temp b where a.SKU=b.sku_id and a.Style=b.style_id and a.Cluster=b.clusters'

exec (@var_sql) 
print @var_sql 
*/

set @var_BucketDateFrom=DATEADD(dd,1,@var_BucketDateFrom)
set @var_BucketDateTo=DATEADD(dd,59,@var_BucketDateFrom)
set @var_BucketNo=@var_BucketNo+1

end

/*update #tb_InitBufferBuckets set AvgOfAllBuckets=[Bucket-122]/@var_BucketCount */
-- Select * from #tb_InitBufferBucketsInRows
-- Select * from #tb_InitBufferBucketsOtherCal
update a set a.AvgOfAllBuckets =b.AvgVal from #tb_InitBufferBucketsOtherCal a , (Select SKU,Style,Cluster,AVG(BucketValue) 'AvgVal' from #tb_InitBufferBucketsInRows group by SKU,Style,Cluster) b
where a.SKU=b.SKU and a.Style=b.Style and a.Cluster=b.cluster

update a set a.StdDevForAllBuckets =b.StDevVal from #tb_InitBufferBucketsOtherCal a , (Select SKU,Style,Cluster,Stdev(BucketValue) 'StDevVal' from #tb_InitBufferBucketsInRows group by SKU,Style,Cluster) b
where a.SKU=b.SKU and a.Style=b.Style and a.Cluster=b.cluster

update a set a.[1stMax] =b.MaxVal from #tb_InitBufferBucketsOtherCal a , (Select SKU,Style,Cluster,Max(BucketValue) 'MaxVal' from #tb_InitBufferBucketsInRows group by SKU,Style,Cluster) b
where a.SKU=b.SKU and a.Style=b.Style and a.Cluster=b.cluster

update #tb_InitBufferBucketsOtherCal set [Avg+0.5StdDev]=(AvgOfAllBuckets+0.5*StdDevForAllBuckets)
update #tb_InitBufferBucketsOtherCal set [Avg+1StdDev]=(AvgOfAllBuckets+1*StdDevForAllBuckets)
update #tb_InitBufferBucketsOtherCal set [Avg+1.5StdDev]=(AvgOfAllBuckets+1.5*StdDevForAllBuckets)
update #tb_InitBufferBucketsOtherCal set [Avg+2.0StdDev]=(AvgOfAllBuckets+2*StdDevForAllBuckets)

update a set a.[2ndMax] =b.BucketValue from #tb_InitBufferBucketsOtherCal a ,(Select  SKU,Style,Cluster,BucketValue,RankValDesc from
 (Select SKU,Style,Cluster,BucketValue,Row_Number() over(partition by sku,style,cluster order by BucketValue desc) 'RankValDesc' from #tb_InitBufferBucketsInRows ) b1
 where RankValDesc=61) b
where a.SKU=b.SKU and a.Style=b.Style and a.Cluster=b.cluster

update a set a.[3rdMax] =b.BucketValue from #tb_InitBufferBucketsOtherCal a ,(Select  SKU,Style,Cluster,BucketValue,RankValDesc from
 (Select SKU,Style,Cluster,BucketValue,Row_Number() over(partition by sku,style,cluster order by BucketValue desc) 'RankValDesc' from #tb_InitBufferBucketsInRows ) b1
 where RankValDesc=121) b
where a.SKU=b.SKU and a.Style=b.Style and a.Cluster=b.cluster

--Select * from #tb_InitBufferBuckets
select a.SKU,a.Style,a.Cluster,a.TotalSaleForSeason
,b.AvgOfAllBuckets,b.StdDevForAllBuckets,b.[Avg+0.5StdDev],b.[Avg+1StdDev],b.[Avg+1.5StdDev]
,b.[Avg+2.0StdDev],b.[1stMax],b.[2ndMax],b.[3rdMax]
into #tb_FinalOutput
 from 
#tb_InitBufferOutput a
left join 
#tb_InitBufferBucketsOtherCal b
on a.SKU=b.SKU and a.Style=b.Style and a.Cluster=b.Cluster

 Select SKU,Style,Cluster,TotalSaleForSeason
      ,ceiling(AvgOfAllBuckets) 'AvgOfAllBuckets'
      ,ceiling(StdDevForAllBuckets) 'StdDevForAllBuckets'
      ,ceiling([Avg+0.5StdDev]) 'Avg+0.5StdDev'
      ,ceiling([Avg+1StdDev]) 'Avg+1StdDev'
      ,ceiling([Avg+1.5StdDev]) 'Avg+1.5StdDev'
      ,ceiling([Avg+2.0StdDev]) 'Avg+2.0StdDev'
      ,[1stMax],	[2ndMax],	[3rdMax]
 from #tb_FinalOutput

Select * from #tb_InitBufferBucketsInRows
--Select * from #tb_InitBufferBucketsOtherCal


End

/*Above Procedure Ends*/

End
GO
/****** Object:  StoredProcedure [dbo].[sp_postLNR]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_postLNR]
as
insert into Onebeat_Finolex.[dbo].[oba_error_log] values('Post LNR ',getdate(),'Post LNR')
  drop table if exists #prodhistroyNew                
 select  h.Plant,Sku,SkuDesc ,[Black(Kms)],[Red(Kms)] ,updatedate                
  as updatedate,CableType ,QtyKms as [Actual Production]               
   into #prodhistroyNew                
  from obp_ProdReplHistory as h 
  left join 
  (Select sl.stockLocationName Plant,s.locationskuname Sku        
  ,convert(float,sum(t.quantity)) QtyKms        
  ,sum(case when s.Custom_num1>0 then t.quantity*1000/(convert(float,s.custom_num1)) end) Qtycoils        
  ,convert(date,getdate()-1) ReportedDate  
  from [Onebeat_Finolex].dbo.Symphony_transactions t        
  join [Onebeat_Finolex].dbo.Symphony_StockLocations sl on sl.stocklocationid=t.receiver        
  join [Onebeat_Finolex].dbo.Symphony_stocklocationskus s on s.stockLocationID=t.receiver and t.skuid=s.skuid        
  where reportedDate = convert(date,getdate()-1) and transactionType=1 and receiver in (22,26,30,31)        
  group by sl.stockLocationName,s.locationSkuName        
  )        
  as t on t.Sku=h.Material and t.Plant=h.Plant        
   where  convert(date,h.Updatedate)=convert(date,getdate()-1)
 
    
  drop table if exists #prodhistroy                
  select  m.Plant, sum([Black(Kms)] ) as Black,sum([Red(Kms)]) as Red ,m.updatedate                
  as updatedate,m.CableType ,sum([Actual Production])  as [Actual Production]  
  ,l.BlackCount,R.RedCount  
  into #prodhistroy              
  from #prodhistroyNew as m  
  left  join   
  (select Plant,CableType,Updatedate,count([Black(Kms)]) as BlackCount
  from  #prodhistroyNew   where  [Black(Kms)]!=0  and  
  convert(nvarchar(10),updatedate,103)=convert(nvarchar(10),(GETDATE()-1),103)                
  group by plant,CableType,Updatedate)
  as l  
  on m.Plant=l.Plant and m.CableType=l.CableType and m.updatedate=l.updatedate  
  left join   
  (select Plant,CableType,Updatedate ,Count([Red(Kms)]) as RedCount from  #prodhistroyNew   where     
  [Red(Kms)]!=0    and   
  convert(nvarchar(10),updatedate,103)=convert(nvarchar(10),(GETDATE()-1),103)                
  group by plant,CableType,Updatedate) 
  as R  
  on R.Plant=m.Plant and r.CableType=m.CableType and r.updatedate=m.updatedate  
  where convert(nvarchar(10),m.updatedate,103)=convert(nvarchar(10),(GETDATE()-1),103)                
  group by m.plant,m.CableType,m.Updatedate,BlackCount,RedCount                   
  order by CableType  
     
 --select plant,Cabletype,Black,Red,UpdateDate,cast([Actual Production] as float),BlackCount,RedCount   from #prodhistroy   
 INSERT into obp_ProdReplPlantwiseHistory(plant,Cabletype,Black,Red,UpdateDate,[ActualProduction] ,[Sku's Black Count] ,[Sku's Count])               
 select  plant,Cabletype,Black,Red,UpdateDate,cast([Actual Production] as float),BlackCount,RedCount    from #prodhistroy   
   
              
   insert into obp_productionreplpoogihistory(Cabletype,Plant,Sku,updateddate,isActive,color,SkuDescription,ActualProduction,skurepl)     
  select CableType,Plant,Sku,updatedate,1,'Black',SkuDesc,[Actual Production],[Black(Kms)] from #prodhistroyNew where    [Black(Kms)]!=0  and  
  convert(nvarchar(10),updatedate,103)=convert(nvarchar(10),(GETDATE()-1),103)  
    insert into obp_productionreplpoogihistory(Cabletype,Plant,Sku,updateddate,isActive,color,SkuDescription,ActualProduction,skurepl)     
  select CableType,Plant,Sku,updatedate,1,'Red',SkuDesc,[Actual Production],[Red(Kms)] from #prodhistroyNew where    [Red(Kms)]!=0  and  
  convert(nvarchar(10),updatedate,103)=convert(nvarchar(10),(GETDATE()-1),103)                
 insert into obp_productionreplpoogihistory(Cabletype,Plant,Sku,updateddate,isActive,color,SkuDescription,ActualProduction,skurepl) 
 select CableType,Plant,Sku,(GETDATE()-1),1,'Cyan',skudesc,QtyKms,0 from [obp_Finolex].[dbo].[obp_PrdnReplCyan]  



 
GO
/****** Object:  StoredProcedure [dbo].[SP_SendNewOrderEmail]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_SendNewOrderEmail]      
as      
Begin     
/*    
truncate table tb_NewOrdersEmail      
    
    
/*Populate the tb_NewOrdersEmail with valid records*/      
insert into tb_NewOrdersEmail       
Select Distributor,DealerName,DemandNo,MaterialDescription,Quantity      
,case when ModifiedDate is null then cast(createddate as date) else cast(ModifiedDate as date) end      
--,'bharat.sharma@goldrattgroup.com,punit.mulley@goldrattgroup.com'    
,''    
,0    
,WhetherApproved    
from obp_DemandEntry     
where WhetherApproved is not null     
--and DemandNo in ('10012','D-502446-3')      
*/    
    
/*Distibutor EMail*/    
;With Cte_01 as    
(    
Select DistributorName,max(isnull(EmailID,'bharat.sharma@goldrattgroup.com')) 'Email' from obp_ddlDistributors group by   DistributorName    
)    
update a set a.Email=b.Email   
from tb_NewOrdersEmail a,Cte_01 b where a.Distributor=b.DistributorName     
    
/*Dealer EMail*/    
;With Cte_02 as    
(    
Select CustomerName,max(isnull(EmailID,'punit.mulley@goldrattgroup.com')) 'Email' from obp_ddlCustomerMaster group by   CustomerName    
)    
update a set a.Email=a.Email+case when len(ltrim(rtrim(a.Email)))>1 then (';'+b.Email) else b.Email end    
from tb_NewOrdersEmail a,Cte_02 b where a.DealerName=b.CustomerName     
    
/*Accounts EMail*/    
update tb_NewOrdersEmail set email=email+case when len(ltrim(rtrim(Email)))>1 then (';hemant.kalia@goldrattgroup.com') else 'hemant.kalia@goldrattgroup.com' end    
    
/*Count No of Distributors*/      
Declare @var_cntdist int,@var_dist nvarchar(200),@var_email nvarchar(200)      
      
set @var_cntdist=(select count(distinct DealerName+'_'+Distributor) from tb_NewOrdersEmail)      
      
While @var_cntdist<>0      
 Begin      
 set @var_dist=(select top 1 (DealerName+'_'+Distributor) from tb_NewOrdersEmail where ind01=0)      
 set @var_email=(select top 1 Email from tb_NewOrdersEmail where (DealerName+'_'+Distributor)=@var_dist and ind01=0)      
      
 exec obp_NewOrdersEmail @var_email,@var_dist      
      
 update tb_NewOrdersEmail set ind01=1 where (DealerName+'_'+Distributor)=@var_dist      
 set @var_cntdist=@var_cntdist-1      
 End      
      
  
End 
GO
/****** Object:  StoredProcedure [dbo].[SP_SendNewOrderEmail_v1]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_SendNewOrderEmail_v1]  
as  
Begin  
--truncate table tb_NewOrdersEmail  
  
--/*Populate the tb_NewOrdersEmail with valid records*/  
--insert into tb_NewOrdersEmail   
--Select Distributor,DealerName,DemandNo,MaterialDescription,Quantity  
--,case when ModifiedDate is null then cast(createddate as date) else cast(ModifiedDate as date) end  
--,'bharat.sharma@goldrattgroup.com',0  
--from obp_DemandEntry where DemandNo in ('10012','D-502446-3')  
  
/*Count No of Distributors*/  
Declare @var_cntdist int,@var_dist nvarchar(200),@var_email nvarchar(200)  
  
set @var_cntdist=(select count(distinct DealerName) from tb_NewOrdersEmail)  
  
While @var_cntdist<>0  
 Begin  
 set @var_dist=(select top 1 Distributor from tb_NewOrdersEmail where ind01=0)  
 set @var_email=(select top 1 Email from tb_NewOrdersEmail where Distributor=@var_dist and ind01=0)  
  
 exec obp_NewOrdersEmail @var_email,@var_dist  
  
 update tb_NewOrdersEmail set ind01=1 where Distributor=@var_dist  
 set @var_cntdist=@var_cntdist-1  
 End  
  
End  
GO
/****** Object:  StoredProcedure [dbo].[TEST]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TEST] @Gridname1 NVARCHAR(MAX)=NULL, @str1 nvarchar(MAX)=NULL, @key1 nvarchar(50)=NULL, @LinkId1 NVARCHAR(MAX)=NULL, @usr1 nvarchar(MAX)='' AS BEGIN exec obps_sp_UpdateGridDataDetails @Gridname=@Gridname1,@str=@str1,@key=@key1,@LinkId=@LinkId1,@usr=@usr1 END
GO
/****** Object:  StoredProcedure [dbo].[ValidateInput_AutocableDemand]    Script Date: 2024-04-27 7:59:35 AM ******/
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
/****** Object:  StoredProcedure [dbo].[ValidateInput_OFC]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ValidateInput_OFC] 
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
	@d int 
	,@l int=0

	while(@count>=@i)
	begin
	    declare @remark nvarchar(max)='Please Correct ',@k int =0
		if(@l=0)
		begin
		    set @d=100
			set @l=@l+2
        end
		select @Year=Due_YYYY,@Month=Due_MM,@Day=Due_DD,@Plant=Plant,@SKU=SKUCode,@rn=ID from [dbo].[obp_OFC_Demand_temp]
		where ID=@d+@i

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
			IF @Plant <> 'GOFC' 
			BEGIN
				set @remark=@remark+' Plant should be GOFC.'
				set @k=1;
			END
         
		 if(@k=1)
		 begin
		     update obp_OFC_Demand_temp set IsValid=0,remark=@remark where ID=@rn
			 set @k=0
		 end
			
			set @i=@i+1
		  end  
END
GO
/****** Object:  Trigger [dbo].[obp_tr_DelClientMaster]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create trigger [dbo].[obp_tr_DelClientMaster]  
on [dbo].[obp_ClientMaster]  
After delete  
as  
begin  
declare @i_Id INT,@var_ThID int,@var_maxseqno int,@var_task nvarchar(50),@var_user nvarchar(1000)  
select @i_Id = deleted.id from deleted  
  
delete from obp_TaskHeader where ClientID =@i_Id  
  
  
end  
GO
ALTER TABLE [dbo].[obp_ClientMaster] ENABLE TRIGGER [obp_tr_DelClientMaster]
GO
/****** Object:  Trigger [dbo].[obp_tr_GenThSeqNo]    Script Date: 2024-04-27 7:59:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE trigger [dbo].[obp_tr_GenThSeqNo]          
on [dbo].[obp_Taskheader]          
After Insert          
as          
begin          
declare @i_Id INT,@var_ClientID int,@var_maxseqno int,@var_task nvarchar(50),@var_user nvarchar(1000),@var_rec_cnt int,@var_clientname nvarchar(100),@var_createdby nvarchar(100)          
declare @var_taskduration float, @var_taskplandt datetime,@var_TaskStartDt datetime,@var_currentTaskStatus nvarchar(100)          
declare @var_TaskHeaderId int          
          
select @i_Id = INSERTED.id from inserted          
select @var_ClientID = INSERTED.ClientID from inserted          
select @var_task = INSERTED.th_TaskHeader from inserted          
          
select @var_createdby=INSERTED.Createdby from inserted          
set @var_rec_cnt=0          
set @var_clientname=(select top 1 clientname from obp_ClientMaster where id=@var_ClientID)          
          
select @var_taskduration = inserted.TaskDuration from inserted          
select @var_taskplandt = inserted.PlannedStartDt from inserted          
select @var_TaskStartDt = deleted.TaskActStartDt from deleted          
select @var_currentTaskStatus = inserted.TaskStatus from inserted          
         
select @var_TaskHeaderId = inserted.ParentId from inserted          
          
        
/*Main Task*/          
If isnull(@var_TaskHeaderId,0)=0          
Begin          
          
 /*Trace Record*/          
 update obp_TaskHeader set ShareToUser=@var_createdby,ParentId=0,isEdit=1 where id=@i_Id          

          
 Insert into obp_TaskHeader_Trace          
 Select 
 id,
ClientID,
th_TaskHeader,
TaskStatus,
EstDueDate,
th_Remarks,
TimeBuffer,
BlackExcedDays,
Color1,
Color2,
Color3,
isActive,
AccessToUser,
ShareToUser,
ScheduleType,
TaskDuration,
TaskActStartDt,
TaskActEstDt,
PlannedStartDt,
Reason,
ParentId,
ActualFinishDate,
OnHoldReason,
TicketCatg1,
ActualDuration,
CreatedDate,
ModifiedDate,
Createdby,
Modifiedby,
'M-I',
getdate(),
td_SeqNo,
ActFinishDate,
FKBy,
th_SeqNo
 from obp_TaskHeader where id in (@i_Id)          
 
 /*
 /*Insert First Sub Task for Main Task*/          
 insert into obp_TaskHeader(ClientID,th_TaskHeader,CreatedDate,ModifiedDate,Createdby,isActive,ShareToUser,ScheduleType          
 ,ParentId)           
 values(1,@var_task,getdate(),getdate(),@var_createdby,1,@var_createdby,1,@i_Id);          
 */
 

End          
          
        
/*Sub Task*/          
If isnull(@var_TaskHeaderId,0)<>0          
Begin          
          
 Update obp_TaskHeader set     
 --TaskStatus='NS',          
 ShareToUser=case when ShareToUser is null then Createdby else ShareToUser end           
 where id=@i_Id 
 
 /*Make Main Task non Editable*/
 update obp_TaskHeader set isEdit=0 where id=@var_TaskHeaderId
/*          
/*Trace Record*/          
Insert into obp_TaskHeader_Trace          
Select *,'S-I',getdate() from obp_TaskHeader where id in (@i_Id)          
 */     
          
End          
      
--select * from obp_TaskHeader_Trace order by id desc      
          
          
end          


GO
ALTER TABLE [dbo].[obp_Taskheader] ENABLE TRIGGER [obp_tr_GenThSeqNo]
GO
USE [master]
GO
ALTER DATABASE [obp_dtms] SET  READ_WRITE 
GO
