USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_UserLinks]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_UserLinks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[UserName] [nvarchar](max) NULL,
	[LinkId] [int] NOT NULL,
	[LinkName] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[ModifiedBy] [nvarchar](max) NULL,
	[IsActive] [int] NOT NULL,
	[IsDeleted] [int] NOT NULL,
	[RoleId] [int] NULL,
	[sublinkid] [int] NULL,
	[IsRoleAttached] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[obps_UserLinks] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
