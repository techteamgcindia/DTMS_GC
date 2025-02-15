USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_eod]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_eod](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Project] [nvarchar](max) NULL,
	[TaskCategory] [nvarchar](max) NULL,
	[TaskType] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[EOD_Date] [datetime] NULL,
	[isActive] [int] NULL,
	[Hours] [int] NULL,
	[Minutes] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[obp_eod] ADD  CONSTRAINT [DF__obp_eod__EOD_Dat__297722B6]  DEFAULT (getdate()) FOR [EOD_Date]
GO
ALTER TABLE [dbo].[obp_eod] ADD  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[obp_eod] ADD  DEFAULT ((0)) FOR [Hours]
GO
ALTER TABLE [dbo].[obp_eod] ADD  DEFAULT ((0)) FOR [Minutes]
GO
ALTER TABLE [dbo].[obp_eod] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
