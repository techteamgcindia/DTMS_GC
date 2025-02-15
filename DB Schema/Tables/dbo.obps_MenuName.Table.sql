USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_MenuName]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_MenuName](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MenuId]  AS ([Id]),
	[DisplayName] [nvarchar](max) NOT NULL,
	[IsVisible] [int] NOT NULL,
	[DisplayOrder] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[obps_MenuName] ADD  CONSTRAINT [DF_obps_MenuName_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
GO
