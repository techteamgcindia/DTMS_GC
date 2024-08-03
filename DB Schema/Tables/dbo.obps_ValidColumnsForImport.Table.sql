USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_ValidColumnsForImport]    Script Date: 2024-04-27 8:02:34 AM ******/
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
