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
CREATE TABLE Places (
    PlaceId            INT IDENTITY(1,1) NOT NULL,                                    --景點ID
    PlaceName      NVARCHAR(100) NOT NULL,                                      -- 景點名稱
    ImageUrl               NVARCHAR(2000) NULL,                                        -- 景點圖片
    Description            NVARCHAR(MAX) NULL,                                       --景點介紹  
    PlaceTypeId          INT NOT NULL,                                                     --景點分類
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
    ParkingInfo             NVARCHAR(500) NULL,                                        --停車資訊

    CONSTRAINT PK_Places PRIMARY KEY (PlaceId),
    -- 經緯度合理值檢查
    CONSTRAINT CHK_Latitude CHECK (Latitude BETWEEN -90.0 AND 90.0),
    CONSTRAINT CHK_Longitude CHECK (Longitude BETWEEN -180.0 AND 180.0)
);

-- 厚竣
CREATE TABLE Trips(
	TripId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL, 
	ImageUrl NVARCHAR(2000) NULL,
	TripName NVARCHAR(100)NOT NULL,
	Description NVARCHAR(500)NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Trips_CreatedAt DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Trips_UpdatedAt DEFAULT SYSUTCDATETIME()

    CONSTRAINT PK_Trips PRIMARY KEY (TripId),
);

CREATE TABLE TripItems(
	TripItemId INT IDENTITY(1,1) NOT NULL,
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
	CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripItems_CreatedAt DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripItems_UpdatedAt DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_TripItems PRIMARY KEY (TripItemId),
);

CREATE TABLE TripRoutes(
	TripRouteId INT IDENTITY(1,1) NOT NULL,
    TripId INT NOT NULL,
	StartItemId INT NOT NULL,
	EndItemId INT NOT NULL,
	TransportationId INT NOT NULL,
    Distance INT NULL,
    SpendTime TIME(0) NULL,
    Routedata NVARCHAR(2000) NULL,
	CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripRoutes_CreatedAt DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripRoutes_UpdatedAt DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_TripRoutes PRIMARY KEY (TripRouteId),
);

CREATE TABLE TripTransportations(
	TransportationId INT IDENTITY(1,1) NOT NULL,
	ImageUrl NVARCHAR(500) NULL,
	Name NVARCHAR(100)NOT NULL,
	CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripTransportations_CreatedAt DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripTransportations_UpdatedAt DEFAULT SYSUTCDATETIME(),
	IsActive bit NOT NULL CONSTRAINT DF_TripTransportations_IsActive DEFAULT 1,

    CONSTRAINT PK_TripTransportations PRIMARY KEY (TransportationId),
);

CREATE TABLE PlaceTypes(
	PlaceTypeId INT IDENTITY(1,1) NOT NULL,
	TypeName NVARCHAR(100) NOT NULL,
	ImageUrl NVARCHAR(2000) NULL,
    SortOrder INT NOT NULL CONSTRAINT DF_PlaceTypes_SortOrder DEFAULT 0,
	IsActive BIT NOT NULL CONSTRAINT DF_PlaceTypes_IsActive DEFAULT 1,

    CONSTRAINT PK_PlaceTypes PRIMARY KEY (PlaceTypeId),
);

CREATE TABLE PlacesAndTypes(
    PlaceId INT NOT NULL,
    PlaceTypeId INT NOT NULL,

    CONSTRAINT PK_PlacesAndTypes PRIMARY KEY(PlaceId, PlaceTypeId),
);

-- Daisy
CREATE TABLE TripMemberIcons (
    IconId INT IDENTITY(1,1),
    IconName NVARCHAR(50) NOT NULL,
    ImageUrl NVARCHAR(2000) NULL,
    SortOrder INT NOT NULL DEFAULT 0,
    IsEnabled BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_TripMemberIcons PRIMARY KEY (IconId),
);

-- 行程旅伴表
CREATE TABLE TripMembers (
    MemberId INT IDENTITY(1,1),
    TripId INT NULL,
    UserId INT NULL,
    MemberName NVARCHAR(50) NULL,
    IconId INT NULL,
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripMembers_CreatedAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripMembers_UpdatedAt DEFAULT SYSUTCDATETIME(),
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT PK_TripMembers PRIMARY KEY (MemberId),
    -- 確保同一個會員不會重複加入同一個行程
    CONSTRAINT UQ_TripMembers_Trip_User UNIQUE (TripId, UserId)
);


--  費用分類表 (交通、住宿、用餐...)
CREATE TABLE ExpenseTypes (
    TypeId INT IDENTITY(1,1),
    TypeName NVARCHAR(50) NOT NULL,
    ImageUrl NVARCHAR(2000) NULL,
    SortOrder INT NOT NULL DEFAULT 0,
    IsEnabled BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_ExpenseTypes PRIMARY KEY (TypeId),
);

-- 分帳分類表 (均分、按比例、指定金額...)
CREATE TABLE ExpenseSplitTypes (
    SplitTypeId INT IDENTITY(1,1),
    SplitTypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500) NULL,
    IsEnabled BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_ExpenseSplitTypes PRIMARY KEY (SplitTypeId)
);

-- 費用主資料 
CREATE TABLE Expenses (
    ExpenseId INT IDENTITY(1,1),
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

    CONSTRAINT PK_Expenses PRIMARY KEY (ExpenseId),
);


-- 付款人明細表 (支援多人共同墊款)
CREATE TABLE ExpensePayers (
    PayerId INT IDENTITY(1,1),
    ExpenseId INT NOT NULL,
    MemberId INT NOT NULL,
    PaidAmount DECIMAL(12,2) NOT NULL, 

    CONSTRAINT PK_ExpensePayers PRIMARY KEY (PayerId),
);

-- 分帳人
CREATE TABLE ExpenseSplits (
    SplitId INT IDENTITY(1,1),
    ExpenseId INT NOT NULL,
    MemberId INT NOT NULL,
    Percentage DECIMAL(5,2) NULL,        
    SplitAmount DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_ExpenseSplits PRIMARY KEY (SplitId),
);

-- 小高
--- City 縣市
CREATE TABLE Cities (
    CityId INT IDENTITY(1,1) NOT NULL,
    CityName NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_Cities PRIMARY KEY (CityId),
    CONSTRAINT UQ_Cities_CityName UNIQUE (CityName),
);
GO

--- Education 學歷
CREATE TABLE Educations (
    EducationId INT IDENTITY(1,1) NOT NULL,
    EducationName NVARCHAR(50) NOT NULL,
    SortOrder INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Educations PRIMARY KEY (EducationId),
    CONSTRAINT UQ_Educations_EducationName UNIQUE (EducationName),
);
GO

--- Users 會員基本資料
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
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

    CONSTRAINT PK_Users PRIMARY KEY (UserId),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),
);
GO

--- UserFavorite 使用者最愛資料夾

CREATE TABLE UserFavorites (
    FavoriteFolderId INT IDENTITY(1,1) NOT NULL,
    UserId INT NOT NULL,
    FavoriteFolderName NVARCHAR(100) NOT NULL,
    CreatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    SortOrder INT NOT NULL DEFAULT 0,

    CONSTRAINT PK_UserFavorites PRIMARY KEY (FavoriteFolderId),
);
GO

CREATE INDEX IDX_UserFavorites_UserId_SortOrder ON UserFavorites(UserId, SortOrder)
GO

--- UserFavoriteItems 使用者最愛清單明細
CREATE TABLE UserFavoriteItems (
    FavoriteItemId INT IDENTITY(1,1) NOT NULL,
    FavoriteFolderId INT NOT NULL,
    PlaceId INT NOT NULL,
    CreatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_UserFavoriteItems PRIMARY KEY (FavoriteItemId),
);
GO

 --- AdminUsers 管理者基本資料
 CREATE TABLE AdminUsers (
    AdminId INT IDENTITY(1,1) NOT NULL,
    Account NVARCHAR(50) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    AdminName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(30) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_AdminUsers_CreateAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_AdminUsers_UpdateAt DEFAULT SYSUTCDATETIME(),
    LoginTime DATETIME2(3) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    SortOrder INT NOT NULL DEFAULT 0

    CONSTRAINT PK_AdminUsers PRIMARY KEY (AdminId),
    CONSTRAINT UQ_AdminUsers_Account UNIQUE (Account),
    CONSTRAINT UQ_AdminUsers_Email UNIQUE (Email),
);
GO

-- 外鍵約束
-- 金成
ALTER TABLE Places ADD CONSTRAINT FK_Places_PlaceTypeId FOREIGN KEY(PlaceTypeId) REFERENCES PlaceTypes(PlaceTypeId);

-- 厚竣
ALTER TABLE TripItems ADD CONSTRAINT FK_TripItems_PlaceId FOREIGN KEY(TripId) REFERENCES Places(PlaceId);
ALTER TABLE TripItems ADD CONSTRAINT FK_TripItems_TripId FOREIGN KEY(TripId) REFERENCES Trips(TripId);

ALTER TABLE TripRoutes ADD CONSTRAINT FK_TripRoutes_StartItemId FOREIGN KEY(StartItemId) REFERENCES TripItems(TripItemId);
ALTER TABLE TripRoutes ADD CONSTRAINT FK_TripRoutes_TripId FOREIGN KEY(StartItemId) REFERENCES Trips(TripId);
ALTER TABLE TripRoutes ADD CONSTRAINT FK_TripRoutes_EndItemId FOREIGN KEY (EndItemId) REFERENCES TripItems(TripItemId);
ALTER TABLE TripRoutes ADD CONSTRAINT FK_TripRoutes_TransportationId FOREIGN KEY(TransportationId) REFERENCES TripTransportations(TransportationId)

ALTER TABLE PlacesAndTypes ADD CONSTRAINT FK_PlacesAndTypes_PlaceId FOREIGN KEY (PlaceId) REFERENCES Places(PlaceId);
ALTER TABLE PlacesAndTypes ADD CONSTRAINT FK_PlacesAndTypes_PlaceTypeId FOREIGN KEY (PlaceTypeId) REFERENCES PlaceTypes(PlaceTypeId);

-- Daisy
ALTER TABLE TripMembers ADD CONSTRAINT FK_TripMembers_TripId FOREIGN KEY (TripId) REFERENCES Trips(TripId);
ALTER TABLE TripMembers ADD CONSTRAINT FK_TripMembers_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId);
ALTER TABLE TripMembers ADD CONSTRAINT FK_TripMembers_IconId FOREIGN KEY (IconId) REFERENCES TripMemberIcons(IconId);

ALTER TABLE Expenses ADD CONSTRAINT FK_Expenses_TripId FOREIGN KEY (TripId) REFERENCES Trips(TripId);
ALTER TABLE Expenses ADD CONSTRAINT FK_Expenses_TripItemId FOREIGN KEY (TripItemId) REFERENCES TripItems(TripItemId);
ALTER TABLE Expenses ADD CONSTRAINT FK_Expenses_TypeId FOREIGN KEY (TypeId) REFERENCES ExpenseTypes(TypeId);
ALTER TABLE Expenses ADD CONSTRAINT FK_Expenses_SplitTypeId FOREIGN KEY (SplitTypeId) REFERENCES ExpenseSplitTypes(SplitTypeId);

ALTER TABLE ExpensePayers ADD CONSTRAINT FK_ExpensePayers_ExpenseId FOREIGN KEY (ExpenseId) REFERENCES Expenses(ExpenseId);
ALTER TABLE ExpensePayers ADD CONSTRAINT FK_ExpensePayers_MemberId FOREIGN KEY (MemberId) REFERENCES TripMembers(MemberId);

ALTER TABLE ExpenseSplits ADD CONSTRAINT FK_ExpenseSplits_ExpenseId FOREIGN KEY (ExpenseId) REFERENCES Expenses(ExpenseId);
ALTER TABLE ExpenseSplits ADD CONSTRAINT FK_ExpenseSplits_MemberId FOREIGN KEY (MemberId) REFERENCES TripMembers(MemberId);

-- 小高
ALTER TABLE Users ADD CONSTRAINT FK_Users_CityId FOREIGN KEY (ResidenceCity) REFERENCES Cities(CityId);
ALTER TABLE Users ADD CONSTRAINT FK_Users_EducationId FOREIGN KEY (EducationId) REFERENCES Educations(EducationId);

ALTER TABLE UserFavorites ADD CONSTRAINT FK_UserFavorites_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId);

ALTER TABLE UserFavoriteItems ADD CONSTRAINT FK_UserFavoriteItems_FolderId FOREIGN KEY (FavoriteFolderId) REFERENCES UserFavorites(FavoriteFolderId);
ALTER TABLE UserFavoriteItems ADD CONSTRAINT FK_UserFavoriteItems_PlaceId FOREIGN KEY (PlaceId) REFERENCES Places(PlaceId);