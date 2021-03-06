USE [QuanLyQuanCafe]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSohoadonByDate]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetSohoadonByDate]
@date nvarchar(100)
AS
BEGIN
	SELECT sohoadon FROM dbo.PhieuTamTinh WHERE ngayban = @date
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetSohoadonByMonth]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetSohoadonByMonth]
@month nvarchar(100),
@year nvarchar(100)
AS
BEGIN
	SELECT sohoadon FROM PhieuTamTinh  WHERE MONTH(ngayban)=@month AND YEAR(ngayban) = @year
END


GO
/****** Object:  StoredProcedure [dbo].[USP_GetSohoadonByYear]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetSohoadonByYear]
@year nvarchar(100)
AS
BEGIN
	SELECT sohoadon FROM PhieuTamTinh  WHERE YEAR(ngayban) = @year
END


GO
/****** Object:  StoredProcedure [dbo].[USP_GetTableList]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetTableList]
AS SELECT * FROM Ban

GO
/****** Object:  StoredProcedure [dbo].[USP_GetTableListMax]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetTableListMax] 
AS Select * From dbo.Ban

SElECT MAX(sohoadon) FROM dbo.PhieuTamTinh

GO
/****** Object:  StoredProcedure [dbo].[USP_ThemChiTietHoaDon]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ThemChiTietHoaDon]

@sohoadon INT, @masp INT, @soluong INT, @thanhtien float
AS
BEGIN

	DECLARE @isExitsChiTietHoaDon INT
	DECLARE @foodCount INT = 1
	
	SELECT @isExitsChiTietHoaDon = id, @foodCount =  c.soluong
	FROM dbo.ChiTietTamTinh AS c
	WHERE sohoadon = @sohoadon AND masp = @masp

	IF (@isExitsChiTietHoaDon > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @soluong
		IF (@newCount > 0)
			UPDATE dbo.ChiTietTamTinh	SET soluong = @foodCount + @soluong WHERE masp = @masp
		ELSE
			DELETE dbo.ChiTietTamTinh WHERE sohoadon = @sohoadon AND masp = @masp
	END
	ELSE
	BEGIN
		INSERT	dbo.ChiTietTamTinh
        ( sohoadon, masp, soluong, thanhtien )
		VALUES  ( @sohoadon, -- idBill - int
          @masp, -- idFood - int
          @soluong, -- count - int
          @thanhtien  
          )
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ThemHoaDon]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ThemHoaDon]
@maban int,
@manv int
AS
BEGIN
	INSERT dbo.PhieuTamTinh( maban,manv,ngayban,ngaythanhtoan,trangthai)
		VALUES ( @maban,@manv,GETDATE(), Null, 0)	        
END

GO
/****** Object:  UserDefinedFunction [dbo].[auto_idhd]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[auto_idhd]()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @id VARCHAR(5)
	IF (SELECT COUNT(sohoadon) FROM PhieuTamTinh) = 0
		SET @id = '0'
	ELSE
		SELECT @id = MAX(RIGHT(sohoadon, 3)) FROM PhieuTamTinh
		SELECT @id = CASE
			WHEN @id >= 0 and @id < 9 THEN 'HD00' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
			WHEN @id >= 9 THEN 'HD0' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
		END
	RETURN @id
END
GO
/****** Object:  UserDefinedFunction [dbo].[auto_idnv]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------
CREATE FUNCTION [dbo].[auto_idnv]()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @id VARCHAR(5)
	IF (SELECT COUNT(manv) FROM NhanVien) = 0
		SET @id = '0'
	ELSE
		SELECT @id = MAX(RIGHT(manv, 3)) FROM NhanVien
		SELECT @id = CASE
			WHEN @id >= 0 and @id < 9 THEN 'NV00' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
			WHEN @id >= 9 THEN 'NV0' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
		END
	RETURN @id
END


GO
/****** Object:  UserDefinedFunction [dbo].[auto_idsp]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[auto_idsp]()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @id VARCHAR(5)
	IF (SELECT COUNT(masp) FROM Menu) = 0
		SET @id = '0'
	ELSE
		SELECT @id = MAX(RIGHT(masp, 3)) FROM Menu
		SELECT @id = CASE
			WHEN @id >= 0 and @id < 9 THEN 'SP00' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
			WHEN @id >= 9 THEN 'SP0' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
		END
	RETURN @id
END




GO
/****** Object:  Table [dbo].[Account]    Script Date: 7/25/2020 3:27:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Account](
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[quyen] [char](5) NOT NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Ban]    Script Date: 7/25/2020 3:27:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ban](
	[maban] [int] IDENTITY(1,1) NOT NULL,
	[tenban] [nchar](10) NOT NULL,
	[trangthai] [nvarchar](10) NOT NULL DEFAULT (N'Trống'),
PRIMARY KEY CLUSTERED 
(
	[maban] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ChiTietTamTinh]    Script Date: 7/25/2020 3:27:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietTamTinh](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sohoadon] [int] NOT NULL,
	[masp] [int] NOT NULL,
	[soluong] [int] NOT NULL,
	[thanhtien] [float] NOT NULL,
 CONSTRAINT [PK__ChiTietT__3213E83FAC9F39C5] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DanhMucSanPham]    Script Date: 7/25/2020 3:27:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DanhMucSanPham](
	[iddanhmuc] [int] IDENTITY(1,1) NOT NULL,
	[danhmuc] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_DanhMucSanPham] PRIMARY KEY CLUSTERED 
(
	[iddanhmuc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Menu]    Script Date: 7/25/2020 3:27:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[masp] [int] IDENTITY(1,1) NOT NULL,
	[tensp] [nvarchar](50) NOT NULL,
	[iddanhmuc] [int] NOT NULL,
	[danhmuc] [nvarchar](100) NOT NULL,
	[donvitinh] [nvarchar](20) NOT NULL,
	[giaban] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[masp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 7/25/2020 3:27:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhanVien](
	[manv] [int] IDENTITY(1,1) NOT NULL,
	[tennv] [nvarchar](25) NOT NULL,
	[ngaysinh] [date] NOT NULL,
	[gioitinh] [nvarchar](3) NOT NULL,
	[chucvu] [nvarchar](20) NOT NULL,
	[diachi] [nvarchar](50) NOT NULL,
	[sdt] [char](10) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK__NhanVien__7A21B37D69905915] PRIMARY KEY CLUSTERED 
(
	[manv] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PhieuTamTinh]    Script Date: 7/25/2020 3:27:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuTamTinh](
	[sohoadon] [int] IDENTITY(1,1) NOT NULL,
	[maban] [int] NOT NULL,
	[manv] [int] NOT NULL,
	[ngayban] [date] NOT NULL DEFAULT (getdate()),
	[ngaythanhtoan] [date] NULL,
	[trangthai] [int] NOT NULL,
	[tongtien] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[sohoadon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ThongKeSP]    Script Date: 7/25/2020 3:27:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThongKeSP](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tensp] [nvarchar](50) NULL,
	[soluong] [int] NULL,
 CONSTRAINT [PK_ThongKeSP] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[Account] ([Username], [Password], [quyen]) VALUES (N'aaa', N'123', N'staff')
INSERT [dbo].[Account] ([Username], [Password], [quyen]) VALUES (N'admin                    ', N'12345     ', N'admin')
INSERT [dbo].[Account] ([Username], [Password], [quyen]) VALUES (N'Lai', N'9999', N'staff')
INSERT [dbo].[Account] ([Username], [Password], [quyen]) VALUES (N'nguyenvana               ', N'123       ', N'staff')
SET IDENTITY_INSERT [dbo].[Ban] ON 

INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (1, N'Bàn 1     ', N'Có Khách')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (2, N'Bàn 2     ', N'Trống')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (3, N'Bàn 3     ', N'Trống')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (4, N'Bàn 4     ', N'Trống')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (5, N'Bàn 5     ', N'Trống')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (6, N'Bàn 6     ', N'Trống')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (7, N'Bàn 7     ', N'Trống')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (8, N'Bàn 8     ', N'Trống')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (9, N'Bàn 9     ', N'Trống')
INSERT [dbo].[Ban] ([maban], [tenban], [trangthai]) VALUES (10, N'Bàn 10    ', N'Trống')
SET IDENTITY_INSERT [dbo].[Ban] OFF
SET IDENTITY_INSERT [dbo].[ChiTietTamTinh] ON 

INSERT [dbo].[ChiTietTamTinh] ([id], [sohoadon], [masp], [soluong], [thanhtien]) VALUES (1, 1, 1, 4, 12000)
INSERT [dbo].[ChiTietTamTinh] ([id], [sohoadon], [masp], [soluong], [thanhtien]) VALUES (2, 2, 2, 4, 12000)
INSERT [dbo].[ChiTietTamTinh] ([id], [sohoadon], [masp], [soluong], [thanhtien]) VALUES (3, 3, 1, 4, 12000)
INSERT [dbo].[ChiTietTamTinh] ([id], [sohoadon], [masp], [soluong], [thanhtien]) VALUES (4, 2, 1, 1, 12000)
INSERT [dbo].[ChiTietTamTinh] ([id], [sohoadon], [masp], [soluong], [thanhtien]) VALUES (5, 5, 1, 1, 12000)
INSERT [dbo].[ChiTietTamTinh] ([id], [sohoadon], [masp], [soluong], [thanhtien]) VALUES (6, 3, 3, 1, 12000)
INSERT [dbo].[ChiTietTamTinh] ([id], [sohoadon], [masp], [soluong], [thanhtien]) VALUES (7, 6, 3, 1, 12000)
SET IDENTITY_INSERT [dbo].[ChiTietTamTinh] OFF
SET IDENTITY_INSERT [dbo].[DanhMucSanPham] ON 

INSERT [dbo].[DanhMucSanPham] ([iddanhmuc], [danhmuc]) VALUES (1, N'Cà phê')
INSERT [dbo].[DanhMucSanPham] ([iddanhmuc], [danhmuc]) VALUES (2, N'Nước ngọt')
INSERT [dbo].[DanhMucSanPham] ([iddanhmuc], [danhmuc]) VALUES (3, N'Sinh tố')
INSERT [dbo].[DanhMucSanPham] ([iddanhmuc], [danhmuc]) VALUES (4, N'Nước ép')
SET IDENTITY_INSERT [dbo].[DanhMucSanPham] OFF
SET IDENTITY_INSERT [dbo].[Menu] ON 

INSERT [dbo].[Menu] ([masp], [tensp], [iddanhmuc], [danhmuc], [donvitinh], [giaban]) VALUES (1, N'Cafe đen', 1, N'Cafe', N'Ly', 12000)
INSERT [dbo].[Menu] ([masp], [tensp], [iddanhmuc], [danhmuc], [donvitinh], [giaban]) VALUES (2, N'Nước ép ổi', 2, N'Nước ép', N'Ly', 15000)
INSERT [dbo].[Menu] ([masp], [tensp], [iddanhmuc], [danhmuc], [donvitinh], [giaban]) VALUES (3, N'Sinh tố bơ', 3, N'Sinh tố', N'Ly', 12000)
INSERT [dbo].[Menu] ([masp], [tensp], [iddanhmuc], [danhmuc], [donvitinh], [giaban]) VALUES (4, N'Coca', 2, N'Nước ngọt', N'Chai', 10000)
SET IDENTITY_INSERT [dbo].[Menu] OFF
SET IDENTITY_INSERT [dbo].[NhanVien] ON 

INSERT [dbo].[NhanVien] ([manv], [tennv], [ngaysinh], [gioitinh], [chucvu], [diachi], [sdt], [Username], [Password]) VALUES (1, N'Nguyễn văn a', CAST(N'1999-10-10' AS Date), N'Nam', N'Nhân viên', N'An Lão', N'0345612345', N'aaa                      ', N'123       ')
INSERT [dbo].[NhanVien] ([manv], [tennv], [ngaysinh], [gioitinh], [chucvu], [diachi], [sdt], [Username], [Password]) VALUES (4, N'Nguyễn Như Lai', CAST(N'1992-07-09' AS Date), N'Nữ', N'Pha chế', N'123 Ngô Mây', N'012345678 ', N'Lai', N'9999')
SET IDENTITY_INSERT [dbo].[NhanVien] OFF
SET IDENTITY_INSERT [dbo].[PhieuTamTinh] ON 

INSERT [dbo].[PhieuTamTinh] ([sohoadon], [maban], [manv], [ngayban], [ngaythanhtoan], [trangthai], [tongtien]) VALUES (1, 1, 1, CAST(N'2020-07-23' AS Date), NULL, 0, NULL)
INSERT [dbo].[PhieuTamTinh] ([sohoadon], [maban], [manv], [ngayban], [ngaythanhtoan], [trangthai], [tongtien]) VALUES (2, 2, 1, CAST(N'2020-07-23' AS Date), CAST(N'2020-07-24' AS Date), 1, 72000)
INSERT [dbo].[PhieuTamTinh] ([sohoadon], [maban], [manv], [ngayban], [ngaythanhtoan], [trangthai], [tongtien]) VALUES (3, 3, 1, CAST(N'2020-07-23' AS Date), CAST(N'2020-07-24' AS Date), 1, 60000)
INSERT [dbo].[PhieuTamTinh] ([sohoadon], [maban], [manv], [ngayban], [ngaythanhtoan], [trangthai], [tongtien]) VALUES (5, 5, 1, CAST(N'2020-07-23' AS Date), CAST(N'2020-07-23' AS Date), 1, 12000)
INSERT [dbo].[PhieuTamTinh] ([sohoadon], [maban], [manv], [ngayban], [ngaythanhtoan], [trangthai], [tongtien]) VALUES (6, 4, 1, CAST(N'2020-07-23' AS Date), CAST(N'2020-07-23' AS Date), 1, 12000)
SET IDENTITY_INSERT [dbo].[PhieuTamTinh] OFF
SET IDENTITY_INSERT [dbo].[ThongKeSP] ON 

INSERT [dbo].[ThongKeSP] ([id], [tensp], [soluong]) VALUES (167, N'Cafe đen', 4)
INSERT [dbo].[ThongKeSP] ([id], [tensp], [soluong]) VALUES (168, N'Nước ép ổi', 4)
INSERT [dbo].[ThongKeSP] ([id], [tensp], [soluong]) VALUES (169, N'Cafe đen', 1)
INSERT [dbo].[ThongKeSP] ([id], [tensp], [soluong]) VALUES (170, N'Cafe đen', 4)
INSERT [dbo].[ThongKeSP] ([id], [tensp], [soluong]) VALUES (171, N'Sinh tố bơ', 1)
INSERT [dbo].[ThongKeSP] ([id], [tensp], [soluong]) VALUES (172, N'Cafe đen', 1)
INSERT [dbo].[ThongKeSP] ([id], [tensp], [soluong]) VALUES (173, N'Sinh tố bơ', 1)
SET IDENTITY_INSERT [dbo].[ThongKeSP] OFF
ALTER TABLE [dbo].[ChiTietTamTinh]  WITH CHECK ADD FOREIGN KEY([sohoadon])
REFERENCES [dbo].[PhieuTamTinh] ([sohoadon])
GO
ALTER TABLE [dbo].[ChiTietTamTinh]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietTamTinh_Menu] FOREIGN KEY([masp])
REFERENCES [dbo].[Menu] ([masp])
GO
ALTER TABLE [dbo].[ChiTietTamTinh] CHECK CONSTRAINT [FK_ChiTietTamTinh_Menu]
GO
ALTER TABLE [dbo].[Menu]  WITH CHECK ADD FOREIGN KEY([iddanhmuc])
REFERENCES [dbo].[DanhMucSanPham] ([iddanhmuc])
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [FK_NhanVien_Account] FOREIGN KEY([Username])
REFERENCES [dbo].[Account] ([Username])
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [FK_NhanVien_Account]
GO
ALTER TABLE [dbo].[PhieuTamTinh]  WITH CHECK ADD FOREIGN KEY([maban])
REFERENCES [dbo].[Ban] ([maban])
GO
ALTER TABLE [dbo].[PhieuTamTinh]  WITH CHECK ADD FOREIGN KEY([manv])
REFERENCES [dbo].[NhanVien] ([manv])
GO
ALTER TABLE [dbo].[Ban]  WITH CHECK ADD CHECK  (([trangthai]=N'Trống' OR [trangthai]=N'Có Khách'))
GO
ALTER TABLE [dbo].[Menu]  WITH CHECK ADD CHECK  (([donvitinh]=N'Ly' OR [donvitinh]=N'Chai'))
GO
