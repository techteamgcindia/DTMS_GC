USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_SpPermissions]    Script Date: 2024-04-27 8:02:34 AM ******/
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
