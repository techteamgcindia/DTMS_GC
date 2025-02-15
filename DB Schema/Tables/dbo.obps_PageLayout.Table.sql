USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_PageLayout]    Script Date: 2024-04-27 8:02:34 AM ******/
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
