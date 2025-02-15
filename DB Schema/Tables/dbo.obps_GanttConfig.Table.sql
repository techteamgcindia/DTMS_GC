USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_GanttConfig]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_GanttConfig](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Linkid] [int] NOT NULL,
	[Tablename] [nvarchar](max) NOT NULL,
	[SubjectColName] [nvarchar](max) NOT NULL,
	[StartColName] [nvarchar](max) NOT NULL,
	[EndColName] [nvarchar](max) NOT NULL,
	[PredecessorIdColName] [nvarchar](max) NULL,
	[SuccessorIdColName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
