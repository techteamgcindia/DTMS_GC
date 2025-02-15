USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_tb_DailyTaskEmails_SummaryToEmail]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_tb_DailyTaskEmails_SummaryToEmail](
	[Ticket] [int] NOT NULL,
	[Client] [nvarchar](max) NULL,
	[TaskName] [nvarchar](max) NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[ColorPriority] [nvarchar](max) NULL,
	[Owner] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Status] [int] NOT NULL,
	[Type] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
