USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_NonWorkingDays]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_NonWorkingDays](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[NonWorkingDays] [datetime] NULL
) ON [PRIMARY]
GO
