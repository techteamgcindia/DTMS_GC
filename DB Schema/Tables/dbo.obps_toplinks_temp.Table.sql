USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_toplinks_temp]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_toplinks_temp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LinkName] [nvarchar](max) NOT NULL,
	[Type] [int] NULL,
	[MenuId] [int] NULL,
	[SortOrder] [int] NULL,
	[IsAfterLogin] [int] NULL,
	[IsImportEnabled] [int] NULL,
	[ImportErrorOutSp] [nvarchar](max) NULL,
	[ImportSavedOutSp] [nvarchar](max) NULL,
	[IsMobile] [int] NULL,
	[EnableUniversalSearch] [int] NULL,
	[ImportHelp] [nvarchar](max) NULL,
	[AllowedExtension] [nvarchar](max) NULL,
	[IsLocation] [int] NULL,
	[DdlSp] [nvarchar](max) NULL,
	[IsSamePage] [int] NULL,
	[TriggerGrid] [nvarchar](max) NULL,
	[RefreshGrid] [nvarchar](max) NULL,
	[ConditionalCRUDBtn] [nvarchar](max) NULL,
	[CondCRUDBtnAddSp] [nvarchar](max) NULL,
	[CondCRUDBtnEditSp] [nvarchar](max) NULL,
	[CondCRUDBtnDeleteSp] [nvarchar](max) NULL,
	[IsSpreadSheet] [int] NULL,
	[IsPivot] [int] NULL,
	[SchedulerTypeSP] [nvarchar](max) NULL,
	[IsExportToCsv] [int] NULL,
	[CSVSeperator] [nvarchar](5) NULL,
	[originallinkid] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
