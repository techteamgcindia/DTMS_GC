USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_gms_UOM]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_gms_UOM](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[UOM] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[obp_gms_UOM] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
