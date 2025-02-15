USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_CreateTableTemp]    Script Date: 2024-04-27 8:02:34 AM ******/
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
ALTER TABLE [dbo].[obps_CreateTableTemp] ADD  DEFAULT ((0)) FOR [UserColumn]
GO
