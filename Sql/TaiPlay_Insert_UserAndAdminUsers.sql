SELECT * FROM City;

SELECT * FROM Education;

-- 插入臺灣 22 個縣市資料
INSERT INTO City (CityName) VALUES
(N'臺北市'), (N'新北市'), (N'桃園市'), (N'臺中市'), (N'臺南市'), (N'高雄市'),
(N'基隆市'), (N'新竹市'), (N'嘉義市'), 
(N'新竹縣'), (N'苗栗縣'), (N'彰化縣'), (N'南投縣'), (N'雲林縣'), 
(N'嘉義縣'), (N'屏東縣'), (N'宜蘭縣'), (N'花蓮縣'), (N'臺東縣'), 
(N'澎湖縣'), (N'金門縣'), (N'連江縣');
GO

-- 插入學歷級別資料
INSERT INTO Education (EducationName, SortOrder, IsActive) VALUES
(N'國小', 1, 1),
(N'國中', 2, 1),
(N'高中/高職', 3, 1),
(N'專科', 4, 1),
(N'大學', 5, 1),
(N'碩士', 6, 1),
(N'博士', 7, 1),
(N'其他', 8, 1);
GO

-- 插入 3 筆會員假資料(密碼無雜湊)
INSERT INTO Users (Email, PasswordHash, UserName, Phone, ImageUrl, Gender, BirthDate, ResidenceCity, ResidenceAddress, EducationId, IsActive) VALUES
(
    N'yating@gmail.com', 
    N'user1', 
    N'林雅婷', 
    N'0912345678', 
    N'user1.jpg', 
    0, -- 女性
    '1995-06-15', 
    1, -- 臺北市
    N'信義區市府路1號', 
    5, -- 大學
    1
),
(
    N'guanyu@gmail.com', 
    N'user2', 
    N'張冠宇', 
    N'0923456789', 
    N'user2.jpg', 
    1, -- 男性
    '1990-11-20', 
    4, -- 臺中市
    N'西屯區臺灣大道三段99號', 
    6, -- 碩士
    1
),
(
    N'yijun@gmail.com', 
    N'user3', 
    N'黃怡君', 
    N'0934567890', 
    N'user3.jpg', 
    0, -- 女性
    '1998-03-08', 
    6, -- 高雄市
    N'前鎮區成功二路39號', 
    5, -- 大學
    1
);
GO

-- 插入1筆管理者帳號
INSERT INTO AdminUsers (Account, PasswordHash, AdminName, Phone, Email, IsActive) VALUES
(
    N'admin', 
    N'admin', -- 實務上請使用雜湊後密碼
    N'系統管理員', 
    N'0900000000', 
    N'admin@gmail.com', 
    1
);
GO

SELECT * FROM AdminUsers;


DELETE FROM Users;
GO

-- 讓UserId數值歸0
DBCC CHECKIDENT ('Users', RESEED, 0);
GO

-- 插入 3 筆會員假資料(密碼有雜湊)
INSERT INTO Users (Email, PasswordHash, UserName, Phone, ImageUrl, Gender, BirthDate, ResidenceCity, ResidenceAddress, EducationId, IsActive) VALUES
(
    N'yating@gmail.com', 
    N'$2a$12$eImiTXuWVxfM37uY4JANjO5h6JjQeW5W1J6V7b5K4L3m2n1o0p9q2', -- 模擬雜湊密碼
    N'林雅婷', 
    N'0912345678', 
    N'user1.jpg', 
    0, -- 女性
    '1995-06-15', 
    1, -- 臺北市
    N'信義區市府路1號', 
    5, -- 大學
    1
),
(
    N'guanyu@gmail.com', 
    N'$2a$12$fJnjUYvXYygN48vZ5KBmKP6i7KkRfX6X2K7W8c6L5M4n3o2p1q0r3', -- 模擬雜湊密碼
    N'張冠宇', 
    N'0923456789', 
    N'user2.jpg', 
    1, -- 男性
    '1990-11-20', 
    4, -- 臺中市
    N'西屯區臺灣大道三段99號', 
    6, -- 碩士
    1
),
(
    N'yijun@gmail.com', 
    N'$2a$12$gKokVZwXZzhO59wA6LCnLQ7j8LlSgY7Y3L8X9d7M6N5o4p3q2r1s4', -- 模擬雜湊密碼
    N'黃怡君', 
    N'0934567890', 
    N'user3.jpg', 
    0, -- 女性
    '1998-03-08', 
    6, -- 高雄市
    N'前鎮區成功二路39號', 
    5, -- 大學
    1
);
GO

SELECT * FROM Users;