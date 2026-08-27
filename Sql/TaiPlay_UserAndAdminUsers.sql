CREATE DATABASE TaiPlayDB;
GO

USE TaiPlayDB;
GO

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
    
    -- 外鍵約束
    CONSTRAINT FK_Users_City FOREIGN KEY (ResidenceCity) REFERENCES City(CityId),
    CONSTRAINT FK_Users_Education FOREIGN KEY (EducationId) REFERENCES Education(EducationId)
);
GO

--- UserFavorite 使用者最愛資料夾
CREATE TABLE UserFavorite (
    FavoriteFolderId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId INT NOT NULL,
    FavoriteFolderName NVARCHAR(100) NOT NULL,
    CreatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    
    -- 外鍵約束
    CONSTRAINT FK_UserFavorite_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO

--- UserFavoriteItems 使用者最愛清單明細
CREATE TABLE UserFavoriteItems (
    FavoriteItemId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FavoriteFolderId INT NOT NULL,
    AttractionId INT NOT NULL,
    CreatedAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    
    -- 外鍵約束
    CONSTRAINT FK_UserFavoriteItems_Folder FOREIGN KEY (FavoriteFolderId) REFERENCES UserFavorite(FavoriteFolderId),
    CONSTRAINT FK_UserFavoriteItems_Attraction FOREIGN KEY (AttractionId) REFERENCES Attractions(AttractionId)
);
GO

 -- 因Attractions還未建立 故UserFavoriteItems還未建立完成 --

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
    IsActive BIT NOT NULL DEFAULT 1
);
GO
