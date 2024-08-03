USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_GlobalConfig]    Script Date: 2024-04-27 8:02:34 AM ******/
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
