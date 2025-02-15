USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[SP_InitialBufferCal]    Script Date: 2024-04-27 8:03:17 AM ******/
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
