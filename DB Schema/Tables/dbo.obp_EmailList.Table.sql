USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_EmailList]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_EmailList](
	[id] [int] NOT NULL,
	[ClientName] [nvarchar](500) NULL,
	[UserName] [nvarchar](100) NULL,
	[LicenseDate] [date] NULL,
	[DaysLeft] [int] NULL,
	[Ind] [int] NOT NULL,
	[FeesPendingAmount] [int] NULL,
	[ExpensePendingAmount] [int] NULL
) ON [PRIMARY]
GO
