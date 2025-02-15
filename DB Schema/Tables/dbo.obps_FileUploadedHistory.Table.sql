USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obps_FileUploadedHistory]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obps_FileUploadedHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[FileName] [nvarchar](max) NOT NULL,
	[Size] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[FilePath] [nvarchar](max) NOT NULL,
	[LinkId] [nvarchar](max) NOT NULL,
	[UploadedDate] [date] NULL,
	[BatchId] [int] NULL,
 CONSTRAINT [PK_obps_FileUploadedHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[obps_FileUploadedHistory] ADD  DEFAULT ((0)) FOR [BatchId]
GO
