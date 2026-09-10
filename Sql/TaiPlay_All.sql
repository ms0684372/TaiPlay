USE master;
GO

-- 如果 TaiPlay 已存在，強制中斷連線並刪除資料庫
IF DB_ID(N'TaiPlay') IS NOT NULL
BEGIN
    ALTER DATABASE TaiPlay
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE TaiPlay;
END
GO

-- 重新建立乾淨的 TaiPlay 資料庫
CREATE DATABASE TaiPlay;
GO

USE TaiPlay;
GO

-- 金成
-- 1. 地點類型主表 (Categories/Types)
CREATE TABLE dbo.Places (
    PlaceId            INT IDENTITY(1,1) NOT NULL,                              --景點ID
    PlaceName      NVARCHAR(100) NOT NULL,                                 -- 景點名稱
    ImageUrl               NVARCHAR(2000) NULL,                                       -- 景點圖片
    Description            NVARCHAR(MAX) NULL,                                       --景點介紹  
    MapTypeId               INT NOT NULL,                                                     --景點分類
    GourmetFood        NVARCHAR(MAX) NULL,                                       --美食介紹
    City                       NVARCHAR(20) NOT NULL,                                  --縣市
    District                   NVARCHAR(20) NULL,                                          --鄉鎮市區
    Address                 NVARCHAR(200) NULL,                                        --詳細地址
    Latitude                 DECIMAL(9,6) NULL,                                            --緯度
    Longitude               DECIMAL(10,6) NULL,                                          --經度
    GeoLocation          GEOGRAPHY NULL,                                             --微軟地理空間
    Transportation        NVARCHAR(MAX) NULL,                                       --交通方式
    Phone                    NVARCHAR(30) NULL,                                          --聯絡電話
    WebsiteURL           NVARCHAR(500) NULL,                                        --官方網站
    TicketInfo               NVARCHAR(200) NULL,                                        --票價與收費說明
    BusinessHoursText  NVARCHAR(200) NULL,                                        --營業時間
    AverageRating        DECIMAL(3,2) NULL,                                            --評價
    IsActive                  BIT NOT NULL DEFAULT 1,                                   --狀態
    CreatedAt              DATETIME2(3) NOT NULL CONSTRAINT DF_Places_CreatedAt DEFAULT SYSUTCDATETIME(),     --建立時間
    UpdatedAt              DATETIME2(3) NOT NULL CONSTRAINT DF_Places_UpdatedAt DEFAULT SYSUTCDATETIME(),   --修改時間
    ParkingInfo             NVARCHAR(500) NULL                                         --停車資訊

    -- 主鍵設定
    CONSTRAINT PK_Places PRIMARY KEY CLUSTERED (PlaceId),

    -- 經緯度合理值檢查
    CONSTRAINT CHK_Latitude CHECK (Latitude BETWEEN -90.0 AND 90.0),
    CONSTRAINT CHK_Longitude CHECK (Longitude BETWEEN -180.0 AND 180.0)
);

-- 厚竣
CREATE TABLE Trip(
	TripId INT IDENTITY(1,1) NOT NULL, CONSTRAINT PK_TripId PRIMARY KEY (TripId),
	UserId INT NOT NULL, 
	ImageUrl NVARCHAR(2000) NULL,
	TripName NVARCHAR(100)NOT NULL,
	Description NVARCHAR(500)NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Trip_CreatedAt DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Trip_UpdatedAt DEFAULT SYSUTCDATETIME()
);

CREATE TABLE TripItem(
	TripItemId INT IDENTITY(1,1) NOT NULL, CONSTRAINT PK_TripItemId PRIMARY KEY(TripItemId),
	TripId INT NOT NULL, 
	Title NVARCHAR(100) NULL,
	Description NVARCHAR(500) NULL,
	Day INT NOT NULL,
	PlaceId INT NOT NULL,
	SortOrder INT NOT NULL,
    ArrivalTime TIME(0) NOT NULL,
    ArrivalTimeSource TINYINT NOT NULL DEFAULT 0, -- 0:SYSTEM, 1:MANUAL  
    StayTimeType TINYINT NOT NULL DEFAULT 0, -- 0:STAY, 1:DEPARTURE
    StayDuration TIME(0) NULL,
    DepartureTime TIME(0) NULL,
	TransportationId INT NULL,
	CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripItem_CreatedAt DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripItem_UpdatedAt DEFAULT SYSUTCDATETIME(),
);

CREATE TABLE TripRoute(
	TripRouteId INT IDENTITY(1,1) NOT NULL, CONSTRAINT PK_TripRouteId PRIMARY KEY(TripRouteId),
    TripId INT NOT NULL,
	StartItemId INT NOT NULL,
	EndItemId INT NOT NULL,
	TransportationId INT NOT NULL,
    Distance INT NULL,
    SpendTime INT NULL,
    Routedata NVARCHAR(2000) NULL,
	CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripRoute_CreatedAt DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripRoute_UpdatedAt DEFAULT SYSUTCDATETIME(),
);

CREATE TABLE TripTransportation(
	TransportationId INT IDENTITY(1,1) NOT NULL, CONSTRAINT PK_Transportation PRIMARY KEY(TransportationId),
	ImageUrl NVARCHAR(500) NULL,
	Name NVARCHAR(100)NOT NULL,
	CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripTransportation_CreatedAt DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripTransportation_UpdatedAt DEFAULT SYSUTCDATETIME(),
	IsActive bit NOT NULL CONSTRAINT DF_TripTransportation_IsActive DEFAULT 1
);

CREATE TABLE MapType(
	MapTypeId INT IDENTITY(1,1) NOT NULL, CONSTRAINT PK_MapTypeId PRIMARY KEY(MapTypeId),
	TypeName NVARCHAR(100) NOT NULL,
	ImageUrl NVARCHAR(2000) NULL,
    SortOrder INT NOT NULL,
	IsActive BIT NOT NULL CONSTRAINT DF_MapType_IsActive DEFAULT 1
);

-- Daisy
CREATE TABLE TripMemberIcon (
    IconId INT IDENTITY(1,1) PRIMARY KEY,
    IconName NVARCHAR(50) NOT NULL,
    ImageUrl NVARCHAR(2000) NULL,
    SortOrder INT NOT NULL DEFAULT 0,
    IsEnabled BIT NOT NULL DEFAULT 1
);

-- 行程旅伴表
CREATE TABLE TripMember (
    MemberId INT IDENTITY(1,1) PRIMARY KEY,
    TripId INT NULL,
    UserId INT NULL,
    MemberName NVARCHAR(50) NULL,
    IconId INT NULL,
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripMember_CreatedAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripMember_UpdatedAt DEFAULT SYSUTCDATETIME(),
    IsDeleted BIT NOT NULL DEFAULT 0,
    -- 確保同一個會員不會重複加入同一個行程
    CONSTRAINT UQ_TripMember_Trip_User UNIQUE (TripId, UserId)
);


--  費用分類表 (交通、住宿、用餐...)
CREATE TABLE ExpenseType (
    TypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL,
    ImageUrl NVARCHAR(2000) NULL,
    SortOrder INT NOT NULL DEFAULT 0,
    IsEnabled BIT NOT NULL DEFAULT 1
);

-- 分帳分類表 (均分、按比例、指定金額...)
CREATE TABLE ExpenseSplitType (
    SplitTypeId INT IDENTITY(1,1) PRIMARY KEY,
    SplitTypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500) NULL,
    IsEnabled BIT NOT NULL DEFAULT 1
);

-- 費用主資料 
CREATE TABLE Expenses (
    ExpenseId INT IDENTITY(1,1) PRIMARY KEY,
    TripId INT NOT NULL,
    TripItemId INT NULL,
    TypeId INT NOT NULL,
    ExpenseName NVARCHAR(200) NOT NULL,
    SplitTypeId INT NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL DEFAULT 0.00, 
    ExpenseDate DATETIME2(3) NULL,
    Note NVARCHAR(500) NULL,
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Expenses_CreatedAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Expenses_UpdatedAt DEFAULT SYSUTCDATETIME(),
    IsDeleted BIT NOT NULL DEFAULT 0,
);


-- 付款人明細表 (支援多人共同墊款)
CREATE TABLE ExpensePayer (
    PayerId INT IDENTITY(1,1) PRIMARY KEY,
    ExpenseId INT NOT NULL,
    MemberId INT NOT NULL,
    PaidAmount DECIMAL(12,2) NOT NULL, 
);

-- 分帳人
CREATE TABLE ExpenseSplit (
    SplitId INT IDENTITY(1,1) PRIMARY KEY,
    ExpenseId INT NOT NULL,
    MemberId INT NOT NULL,
    Percentage DECIMAL(5,2) NULL,        
    SplitAmount DECIMAL(12,2) NOT NULL,  
);

-- 小高
--- City 縣市
CREATE TABLE City (
    CityId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CityName NVARCHAR(100) NOT NULL UNIQUE
);
GO

--- Education 學歷
CREATE TABLE Education (
    EducationId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    EducationName NVARCHAR(50) NOT NULL UNIQUE,
    SortOrder INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

--- Users 會員基本資料
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    UserName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(30) NULL,
    ImageUrl NVARCHAR(2000) NULL,
    Gender TINYINT NULL,
    BirthDate DATE NULL,
    ResidenceCity INT NULL,
    ResidenceAddress NVARCHAR(200) NULL,
    EducationId INT NULL,
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Users_CreateAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Users_UpdateAt DEFAULT SYSUTCDATETIME(),
    LoginTime DATETIME2(3) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    
);
GO

--- UserFavorite 使用者最愛資料夾

CREATE TABLE UserFavorite (
    FavoriteFolderId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId INT NOT NULL,
    FavoriteFolderName NVARCHAR(100) NOT NULL,
    CreatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    SortOrder INT NOT NULL DEFAULT 0
);
GO

CREATE INDEX IDX_UserFavorite_SortOrder ON UserFavorite(SortOrder)
GO

--- UserFavoriteItems 使用者最愛清單明細
CREATE TABLE UserFavoriteItems (
    FavoriteItemId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FavoriteFolderId INT NOT NULL,
    PlaceId INT NOT NULL,
    CreatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    
);
GO

 --- AdminUsers 管理者基本資料
 CREATE TABLE AdminUsers (
    AdminId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Account NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    AdminName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(30) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_AdminUsers_CreateAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_AdminUsers_UpdateAt DEFAULT SYSUTCDATETIME(),
    LoginTime DATETIME2(3) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    SortOrder INT NOT NULL DEFAULT 0
);
GO

-- 外鍵約束
-- 金成
ALTER TABLE Places ADD CONSTRAINT FK_Places_MapTypeId FOREIGN KEY(MapTypeId) REFERENCES MapType(MapTypeId);

-- 厚竣
ALTER TABLE TripItem ADD CONSTRAINT FK_TripItem_PlaceId FOREIGN KEY(TripId) REFERENCES Places(PlaceId);
ALTER TABLE TripItem ADD CONSTRAINT FK_TripItem_TripId FOREIGN KEY(TripId) REFERENCES Trip(TripId);

ALTER TABLE TripRoute ADD CONSTRAINT FK_TripRoute_StartItemId FOREIGN KEY(StartItemId) REFERENCES TripItem(TripItemId);
ALTER TABLE TripRoute ADD CONSTRAINT FK_TripRoute_TripId FOREIGN KEY(StartItemId) REFERENCES Trip(TripId);
ALTER TABLE TripRoute ADD CONSTRAINT FK_TripRoute_EndItemId FOREIGN KEY (EndItemId) REFERENCES TripItem(TripItemId);
ALTER TABLE TripRoute ADD CONSTRAINT FK_TripRoute_TransportationId FOREIGN KEY(TransportationId) REFERENCES TripTransportation(TransportationId)

-- Daisy
ALTER TABLE TripMember ADD CONSTRAINT FK_TripMember_TripId FOREIGN KEY (TripId) REFERENCES Trip(TripId);
ALTER TABLE TripMember ADD CONSTRAINT FK_TripMember_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId);
ALTER TABLE TripMember ADD CONSTRAINT FK_TripMember_IconId FOREIGN KEY (IconId) REFERENCES TripMemberIcon(IconId);

ALTER TABLE Expenses ADD CONSTRAINT FK_Expenses_TripId FOREIGN KEY (TripId) REFERENCES Trip(TripId);
ALTER TABLE Expenses ADD CONSTRAINT FK_Expenses_TripItemId FOREIGN KEY (TripItemId) REFERENCES TripItem(TripItemId);
ALTER TABLE Expenses ADD CONSTRAINT FK_Expenses_TypeId FOREIGN KEY (TypeId) REFERENCES ExpenseType(TypeId);
ALTER TABLE Expenses ADD CONSTRAINT FK_Expenses_SplitTypeId FOREIGN KEY (SplitTypeId) REFERENCES ExpenseSplitType(SplitTypeId);

ALTER TABLE ExpensePayer ADD CONSTRAINT FK_ExpensePayer_ExpenseId FOREIGN KEY (ExpenseId) REFERENCES Expenses(ExpenseId);
ALTER TABLE ExpensePayer ADD CONSTRAINT FK_ExpensePayer_MemberId FOREIGN KEY (MemberId) REFERENCES TripMember(MemberId);

ALTER TABLE ExpenseSplit ADD CONSTRAINT FK_ExpenseSplit_ExpenseId FOREIGN KEY (ExpenseId) REFERENCES Expenses(ExpenseId);
ALTER TABLE ExpenseSplit ADD CONSTRAINT FK_ExpenseSplit_MemberId FOREIGN KEY (MemberId) REFERENCES TripMember(MemberId);

-- 小高
ALTER TABLE Users ADD CONSTRAINT FK_Users_CityId FOREIGN KEY (ResidenceCity) REFERENCES City(CityId);
ALTER TABLE Users ADD CONSTRAINT FK_Users_EducationId FOREIGN KEY (EducationId) REFERENCES Education(EducationId);

ALTER TABLE UserFavorite ADD CONSTRAINT FK_UserFavorite_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId);

ALTER TABLE UserFavoriteItems ADD CONSTRAINT FK_UserFavoriteItems_FolderId FOREIGN KEY (FavoriteFolderId) REFERENCES UserFavorite(FavoriteFolderId);
ALTER TABLE UserFavoriteItems ADD CONSTRAINT FK_UserFavoriteItems_PlaceId FOREIGN KEY (PlaceId) REFERENCES Places(PlaceId);