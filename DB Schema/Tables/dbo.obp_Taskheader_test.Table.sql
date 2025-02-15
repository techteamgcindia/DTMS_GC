USE [obp_dtms]
GO
/****** Object:  Table [dbo].[obp_Taskheader_test]    Script Date: 2024-04-27 8:02:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[obp_Taskheader_test](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[ClientID] [int] NULL,
	[th_TaskHeader] [nvarchar](max) NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[EstDueDate] [datetime] NULL,
	[th_Remarks] [nvarchar](max) NULL,
	[TimeBuffer] [nvarchar](max) NULL,
	[BlackExcedDays] [int] NULL,
	[Color1] [nvarchar](max) NULL,
	[Color2] [nvarchar](max) NULL,
	[Color3] [nvarchar](max) NULL,
	[isActive] [int] NULL,
	[AccessToUser] [nvarchar](max) NULL,
	[ShareToUser] [nvarchar](max) NULL,
	[ScheduleType] [int] NULL,
	[TaskDuration] [float] NULL,
	[TaskActStartDt] [datetime] NULL,
	[TaskActEstDt] [datetime] NULL,
	[PlannedStartDt] [datetime] NULL,
	[Reason] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[ActualFinishDate] [datetime] NULL,
	[OnHoldReason] [nvarchar](max) NULL,
	[TicketCatg1] [nvarchar](max) NULL,
	[ActualDuration] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Createdby] [nvarchar](100) NULL,
	[Modifiedby] [nvarchar](100) NULL,
	[td_SeqNo] [float] NULL,
	[ActFinishDate] [datetime] NULL,
	[FKBy] [nvarchar](max) NULL,
	[th_SeqNo] [int] NULL,
	[isEdit] [int] NULL,
	[Sprint] [nvarchar](max) NULL,
	[CommittedDate] [datetime] NULL,
	[AssignTo] [nvarchar](max) NULL,
	[Assigntoemail] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
