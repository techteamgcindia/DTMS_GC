USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_JobExecutionHistory]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_JobExecutionHistory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Linkid] [int] NULL,
	[Jobname] [nvarchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
