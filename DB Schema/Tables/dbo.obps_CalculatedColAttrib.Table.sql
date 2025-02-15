USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_CalculatedColAttrib]    Script Date: 2024-04-27 8:02:34 AM ******/
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
