/****** Object:  Table [paynet].[Tb_Transaction_AmbankJompay]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [paynet].[Tb_Transaction_AmbankJompay](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MsgID] [int] NOT NULL,
	[sig] [nvarchar](100) NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[payerbanknum] [varchar](10) NOT NULL,
	[payerbankname] [varchar](20) NOT NULL,
	[billerbanknum] [varchar](10) NOT NULL,
	[billerbankname] [varchar](20) NOT NULL,
	[accounttype] [varchar](5) NOT NULL,
	[billercode] [varchar](10) NOT NULL,
	[billercodename] [varchar](50) NOT NULL,
	[nbpsref] [varchar](20) NOT NULL,
	[channel] [varchar](5) NOT NULL,
	[debittimestamp] [datetime] NOT NULL,
	[repeatmsg] [varchar](1) NULL,
	[rrn] [nvarchar](50) NOT NULL,
	[rrn2] [nvarchar](50) NULL,
	[currencycode] [varchar](10) NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[extdata] [nvarchar](250) NULL,
	[successMsgID] [int] NULL,
	[status] [nvarchar](5) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_AmbankJompay_Transaction] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IDX_Tb_Transaction_AmbankJompay_rrn] ON [paynet].[Tb_Transaction_AmbankJompay]
(
	[rrn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [paynet].[Tb_Transaction_AmbankJompay]  WITH CHECK ADD  CONSTRAINT [FK_AmbankJompay_Message] FOREIGN KEY([MsgID])
REFERENCES [paynet].[Tb_Transaction_AmbankJompayMsg] ([ID])
ALTER TABLE [paynet].[Tb_Transaction_AmbankJompay] CHECK CONSTRAINT [FK_AmbankJompay_Message]
ALTER TABLE [paynet].[Tb_Transaction_AmbankJompay]  WITH CHECK ADD  CONSTRAINT [FK_AmbankJompay_Status] FOREIGN KEY([status])
REFERENCES [paynet].[Tb_Transaction_AmbankJompayStatus] ([StatusCode])
ALTER TABLE [paynet].[Tb_Transaction_AmbankJompay] CHECK CONSTRAINT [FK_AmbankJompay_Status]