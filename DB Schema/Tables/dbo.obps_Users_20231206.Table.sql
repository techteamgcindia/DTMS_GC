USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_Users_20231206]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_Users_20231206](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[RoleId] [nvarchar](max) NOT NULL,
	[Company] [nvarchar](max) NULL,
	[Division] [nvarchar](max) NULL,
	[Department] [nvarchar](max) NULL,
	[SubDept] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[UserTypeId] [int] NULL,
	[DefaultLinkId] [int] NULL,
	[PrefLang] [bit] NULL,
	[AfterLoginSP] [nvarchar](max) NULL,
	[Permission] [nvarchar](max) NULL,
	[ReportingManager] [nvarchar](max) NULL,
	[IsResetPassword] [int] NULL,
	[EmailId] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
