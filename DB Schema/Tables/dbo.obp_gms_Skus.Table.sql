USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_gms_Skus]    Script Date: 2024-04-27 8:02:34 AM ******/
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
