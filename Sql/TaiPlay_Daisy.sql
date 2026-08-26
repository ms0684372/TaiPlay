if DB_ID('TaiPlay') is null
	create database TaiPlay;
go

use TaiPlay;
go

--  行程旅伴代表圖示表
CREATE TABLE TripMemberIcon (
    IconId INT IDENTITY(1,1) PRIMARY KEY,
    IconName NVARCHAR(50) NOT NULL,
    ImageUrl NVARCHAR(2000) NOT NULL,
    SortOrder INT NOT NULL DEFAULT 0,
    IsEnabled BIT NOT NULL DEFAULT 1
);

-- 行程旅伴表
CREATE TABLE TripMember (
    MemberId INT IDENTITY(1,1) PRIMARY KEY,
    TripId INT NOT NULL,
    UserId INT NULL,
    MemberName NVARCHAR(50) NULL,
    IconId INT NULL,
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripMember_CreatedAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_TripMember_UpdatedAt DEFAULT SYSUTCDATETIME(),
    IsDeleted BIT NOT NULL DEFAULT 0,
    --FOREIGN KEY (TripId) REFERENCES Trip(TripId),
    --FOREIGN KEY (UserId) REFERENCES Users(UserId),
    --FOREIGN KEY (IconId) REFERENCES TripMemberIcon(IconId),
    -- 確保同一個會員不會重複加入同一個行程
    --CONSTRAINT UQ_TripMember_Trip_User UNIQUE (TripId, UserId)
);

--  費用分類表 (交通、住宿、用餐...)
CREATE TABLE ExpenseType (
    TypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL,
    ImageUrl NVARCHAR(2000) NOT NULL,
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
    --FOREIGN KEY (TripId) REFERENCES Trip(TripId),
    --FOREIGN KEY (TripItemId) REFERENCES TripItem(TripItemId),
    --FOREIGN KEY (TypeId) REFERENCES ExpenseType(TypeId),
    --FOREIGN KEY (SplitTypeId) REFERENCES ExpenseSplitType(SplitTypeId)
);


-- 付款人明細表 (支援多人共同墊款)
CREATE TABLE ExpensePayer (
    PayerId INT IDENTITY(1,1) PRIMARY KEY,
    ExpenseId INT NOT NULL,
    MemberId INT NOT NULL,
    PaidAmount DECIMAL(12,2) NOT NULL, 
    --FOREIGN KEY (ExpenseId) REFERENCES Expenses(ExpenseId),
    --FOREIGN KEY (MemberId) REFERENCES TripMember(MemberId)
);

-- 分帳人
CREATE TABLE ExpenseSplit (
    SplitId INT IDENTITY(1,1) PRIMARY KEY,
    ExpenseId INT NOT NULL,
    MemberId INT NOT NULL,
    Percentage DECIMAL(5,2) NULL,        
    SplitAmount DECIMAL(12,2) NOT NULL,  
    FOREIGN KEY (ExpenseId) REFERENCES Expenses(ExpenseId),
    FOREIGN KEY (MemberId) REFERENCES TripMember(MemberId)
);

-- 預設分帳模式
--INSERT INTO ExpenseSplitType (SplitTypeName, Description) VALUES
--(N'均分', N'由所有人平均分擔金額'),
--(N'按比例', N'依照每人設定的百分比(%)分擔金額'),
--(N'指定金額', N'直接指定每個人應付的確切金額');

---- 預設費用分類
--INSERT INTO ExpenseType (TypeName, ImageUrl, SortOrder) VALUES
--(N'餐飲', N'https://example.com/icons/food.png', 1),
--(N'交通', N'https://example.com/icons/transport.png', 2),
--(N'住宿', N'https://example.com/icons/lodging.png', 3),
--(N'娛樂', N'https://example.com/icons/entertainment.png', 4),
--(N'購物', N'https://example.com/icons/shopping.png', 5);