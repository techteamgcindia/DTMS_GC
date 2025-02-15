USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_ClientMaster]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_ClientMaster](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[Country] [nvarchar](max) NULL,
	[ClientName] [nvarchar](max) NULL,
	[LicenseValidityDate] [datetime] NULL,
	[ClientType] [nvarchar](max) NULL,
	[Implementer] [nvarchar](max) NULL,
	[isActive] [int] NULL,
	[isDeleted] [int] NULL,
	[Flg_Dash] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL,
	[OnebeatLicense] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT ((1)) FOR [Flg_Dash]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[obp_ClientMaster] ADD  DEFAULT ((1)) FOR [OnebeatLicense]
GO
