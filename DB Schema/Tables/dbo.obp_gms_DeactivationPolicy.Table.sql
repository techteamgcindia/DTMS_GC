USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_gms_DeactivationPolicy]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_DeactivationPolicy](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[EventName] [nvarchar](100) NULL,
	[LocationId] [int] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[IsDeactivated] [bit] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [datetime] NULL,
	[isrowedit1] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[obp_gms_DeactivationPolicy] ADD  DEFAULT ((1)) FOR [isrowedit1]
GO
