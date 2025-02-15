USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_ExcelImportConfig]    Script Date: 2024-04-27 8:02:34 AM ******/
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
ALTER TABLE [dbo].[obps_ExcelImportConfig] ADD  DEFAULT ('') FOR [GenFileSp]
GO
