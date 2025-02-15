USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_Dashboards]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_Dashboards](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Dashboard] [varbinary](max) NULL,
	[Caption] [nvarchar](255) NULL,
	[LinkId] [int] NULL,
 CONSTRAINT [PK_Dashboards] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[obps_Dashboards] ADD  DEFAULT ((0)) FOR [LinkId]
GO
