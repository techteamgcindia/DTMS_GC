USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_TopLinkExtended_temp]    Script Date: 2024-04-27 8:02:34 AM ******/
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
