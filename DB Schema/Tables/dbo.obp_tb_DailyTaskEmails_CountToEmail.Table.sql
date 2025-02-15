USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_tb_DailyTaskEmails_CountToEmail]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_tb_DailyTaskEmails_CountToEmail](
	[Owner] [nvarchar](max) NULL,
	[TaskType] [nvarchar](max) NULL,
	[Nos] [int] NULL,
	[NS] [int] NULL,
	[IP] [int] NULL,
	[Red] [int] NULL,
	[Black] [int] NULL,
	[Non_RB] [int] NULL,
	[Status] [int] NOT NULL,
	[Ttl_Red] [nvarchar](5) NULL,
	[Ttl_Black] [nvarchar](5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
