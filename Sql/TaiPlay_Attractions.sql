IF DB_ID('TaiPlay') IS NULL
	CREATE DATABASE TaiPlay;
go

USE TaiPlay;
go

-- 1. 地點類型主表 (Categories/Types)
CREATE TABLE dbo.Attractions (
    AttractionId            INT IDENTITY(1,1) NOT NULL,                              --景點ID
    AttractionName      NVARCHAR(100) NOT NULL,                                 -- 景點名稱
    ImageUrl               NVARCHAR(2000) NULL,                                       -- 景點圖片
    Description            NVARCHAR(MAX) NULL,                                       --景點介紹  
    MapType               INT NOT NULL,                                                     --景點分類
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
    CreatedAt              DATETIME2(3) NOT NULL CONSTRAINT DF_Attractions_CreatedAt DEFAULT SYSUTCDATETIME(),     --建立時間
    UpdatedAt              DATETIME2(3) NOT NULL CONSTRAINT DF_Attractions_UpdatedAt DEFAULT SYSUTCDATETIME(),   --修改時間
    ParkingInfo             NVARCHAR(500) NULL                                         --停車資訊

    -- 主鍵設定
    CONSTRAINT PK_Attractions PRIMARY KEY CLUSTERED (AttractionId),

    -- 經緯度合理值檢查
    CONSTRAINT CHK_Latitude CHECK (Latitude BETWEEN -90.0 AND 90.0),
    CONSTRAINT CHK_Longitude CHECK (Longitude BETWEEN -180.0 AND 180.0)
);

