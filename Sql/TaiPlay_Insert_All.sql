USE TaiPlay
GO

-- 讓指定表的id歸零
--DBCC CHECKIDENT ('指定表', RESEED, 0);
--GO

INSERT INTO dbo.MapType (TypeName, SortOrder, ImageUrl) VALUES
    (N'景點', 1, NULL),
    (N'美食', 2, NULL),
    (N'購物', 3, NULL)
GO

INSERT INTO dbo.TripTransportation (ImageUrl, Name) VALUES
    (NULL, N'自定義'),
    (NULL, N'汽車'),
    (NULL, N'摩托車'),
    (NULL, N'大眾運輸'),
    (NULL, N'走路')
GO

INSERT INTO dbo.Places
(
    PlaceName,
    ImageUrl,
    Description,
    MapTypeId,
    GourmetFood,
    City,
    District,
    Address,
    Latitude,
    Longitude,
    GeoLocation,
    Transportation,
    Phone,
    WebsiteURL,
    TicketInfo,
    BusinessHoursText,
    AverageRating,
    IsActive,
    ParkingInfo
)
VALUES
-- 1. 台北 101
(
    N'台北101',
    N'https://images.example.com/taipei101.jpg',
    N'台北知名地標，可欣賞城市景觀，並提供購物、美食及觀景台等休閒體驗。',
    3,
    N'台灣小吃、餐廳、咖啡廳及各式美食。',
    N'台北市',
    N'信義區',
    N'台北市信義區信義路五段7號',
    25.033968,
    121.564468,
    geography::Point(25.033968, 121.564468, 4326),
    N'搭乘台北捷運至台北101/世貿站，步行即可抵達。',
    N'02-8101-8800',
    N'https://www.taipei-101.com.tw/',
    N'觀景台依官方公告票價為準。',
    N'每日 11:00-21:00，實際營業時間依官方公告。',
    4.60,
    1,
    N'設有地下停車場，收費依現場公告。'
),

-- 2. 國立故宮博物院
(
    N'國立故宮博物院',
    N'https://images.example.com/ntm.jpg',
    N'收藏大量珍貴中國藝術文物，是台灣重要的文化與藝術景點。',
    2,
    N'故宮周邊提供中式料理、茶飲及特色餐點。',
    N'台北市',
    N'士林區',
    N'台北市士林區至善路二段221號',
    25.102398,
    121.548492,
    geography::Point(25.102398, 121.548492, 4326),
    N'可搭乘台北捷運至士林站，再轉乘公車前往。',
    N'02-2881-2021',
    N'https://www.npm.gov.tw/',
    N'一般參觀票價依官方公告。',
    N'每日 09:00-17:00，休館日依官方公告。',
    4.70,
    1,
    N'設有停車場，收費依現場公告。'
),

-- 3. 日月潭
(
    N'日月潭',
    N'https://images.example.com/sunmoonlake.jpg',
    N'台灣著名湖泊景點，以湖光山色及環湖景觀聞名，適合自行車、遊船及自然旅遊。',
    1,
    N'邵族特色料理、總統魚、香菇及在地特色小吃。',
    N'南投縣',
    N'魚池鄉',
    N'南投縣魚池鄉中山路599號',
    23.864820,
    120.915500,
    geography::Point(23.864820, 120.915500, 4326),
    N'可由台中搭乘客運前往日月潭，或自行開車前往。',
    N'049-2855668',
    N'https://www.sunmoonlake.gov.tw/',
    N'湖區免費參觀，遊船及其他設施另依官方收費。',
    N'全天開放，個別設施依公告時間營業。',
    4.50,
    1,
    N'湖區周邊設有多處停車場，收費依各停車場公告。'
),

-- 4. 阿里山國家森林遊樂區
(
    N'阿里山國家森林遊樂區',
    N'https://images.example.com/alishan.jpg',
    N'以森林鐵路、日出、雲海、神木及高山森林景觀聞名，是台灣代表性的山林旅遊景點。',
    1,
    N'高山茶、愛玉、竹筒飯及山產料理。',
    N'嘉義縣',
    N'阿里山鄉',
    N'嘉義縣阿里山鄉中正村59號',
    23.510800,
    120.803700,
    geography::Point(23.510800, 120.803700, 4326),
    N'可由嘉義搭乘阿里山森林鐵路或客運前往，亦可自行開車。',
    N'05-2679917',
    N'https://www.forest.gov.tw/',
    N'入園及相關設施收費依官方公告。',
    N'每日開放，實際設施營運時間依官方公告。',
    4.60,
    1,
    N'園區及周邊設有停車場，收費依現場公告。'
),

-- 5. 駁二藝術特區
(
    N'駁二藝術特區',
    N'https://images.example.com/pier2.jpg',
    N'高雄港區重要藝文景點，由舊倉庫群改造而成，結合藝術展覽、文創商店及公共藝術。',
    1,
    N'駁二周邊有海鮮料理、咖啡廳、甜點及各式特色餐飲。',
    N'高雄市',
    N'鹽埕區',
    N'高雄市鹽埕區大勇路1號',
    22.620930,
    120.280970,
    geography::Point(22.620930, 120.280970, 4326),
    N'搭乘高雄捷運至鹽埕埔站或駁二大義站，再步行前往。',
    N'07-5214899',
    N'https://pier2.org/',
    N'園區戶外空間免費，部分展覽及活動需購票。',
    N'園區全天開放，各展館及商店依個別公告時間營業。',
    4.40,
    1,
    N'周邊設有公有及私人停車場。'
);
GO

INSERT INTO PlaceAndType (PlaceId, MapTypeId) VALUES
    (1, 1),
    (2, 1),
    (3, 1);
GO

INSERT INTO dbo.Trip (UserId, ImageUrl, TripName, Description, StartDate, EndDate) VALUES
    (1, NULL, N'樹林一日遊', N'樹林鳥不生蛋不好玩QQ', '2026-07-31', '2026-07-31'),
    (1, NULL, N'台北玩兩天', N'地下街真好玩', '2026-08-06', '2026-08-07'),
    (2, NULL, N'參加網聚', N'來去認親囉', '2026-08-29', '2026-08-30')
GO

DECLARE @SortOrder INT;
SELECT @SortOrder = ISNULL(MAX(SortOrder), 0)
FROM TripItem
WHERE TripId=1;

INSERT INTO dbo.TripItem (TripId, Title, Description, Day, PlaceId, SortOrder, ArrivalTime, ArrivalTimeSource, StayTimeType, StayDuration, DepartureTime, TransportationId) VALUES
    (1, N'樹林車站', N'來去車站附近走走', 1, 1, @SortOrder + 1, '13:00:00', 0, 0, '01:00:00', NULL, 1),
    (1, N'樹林夜市', N'夜市吃吃喝喝', 1, 2, @SortOrder + 2, '13:00:00', 0, 0, '01:00:00', NULL, 1),
    (1, N'樹林秀泰', N'看電影', 1, 3, @SortOrder + 3, '13:00:00', 0, 0, '01:00:00', NULL, 1)
GO

INSERT INTO dbo.TripRoute (TripId, StartItemId, EndItemId, TransportationId, Distance, SpendTime, Routedata) VALUES
    (1, 1, 2, 1, 300, 300, NULL),
    (1, 1, 2, 1, 300, 300, NULL),
    (1, 1, 2, 1, 300, 300, NULL)
GO

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

INSERT INTO TripMemberIcon (IconName, ImageUrl, SortOrder, IsEnabled)VALUES 
(N'男人', NULL, 1, 1),
(N'女人', NULL, 2, 1),
(N'男孩', NULL, 3, 1),
(N'女孩', NULL, 4, 1),
(N'長者(男)', NULL, 5, 1),
(N'長者(女)', NULL, 6, 1);


-- 1. 移除舊有的 UNIQUE Constraint
ALTER TABLE TripMember 
DROP CONSTRAINT UQ_TripMember_Trip_User;

-- 2. 建立 Filtered Unique Index（只限制有註冊 UserId 的會員不能重複加入）
CREATE UNIQUE NONCLUSTERED INDEX UX_TripMember_Trip_User
ON TripMember (TripId, UserId)
WHERE UserId IS NOT NULL;

-- 行程旅伴表
INSERT INTO TripMember (TripId, UserId, MemberName, IconId)VALUES 
(1, 1, NULL, 1),
(2, 2, NULL, 2),
(3, 3, NULL, 3),
(1, NULL, N'訪客阿強', 1),
(2, NULL, N'訪客小花', 2),
(1, NULL, N'訪客小美', 2);

-- 預設費用分類
INSERT INTO ExpenseType (TypeName, ImageUrl, SortOrder) VALUES
(N'餐飲', NULL, 1),
(N'交通', NULL, 2),
(N'住宿', NULL, 3),
(N'娛樂', NULL, 4),
(N'購物', NULL, 5),
(N'其他', NULL, 6);

-- 預設分帳模式
INSERT INTO ExpenseSplitType (SplitTypeName, Description) VALUES
(N'均分', N'由所有人平均分擔金額'),
(N'按比例', N'依照每人設定的百分比(%)分擔金額'),
(N'指定金額', N'直接指定每個人應付的確切金額');

-- 費用主資料 
INSERT INTO Expenses (TripId, TripItemId, TypeId, ExpenseName, SplitTypeId, TotalAmount, ExpenseDate, Note) VALUES 
(1, NULL, 1, N'第一天晚餐-燒肉', 1, 3000.00, '2026-09-01 18:30:00', N'均分費用'),
(1, NULL, 2, N'包車一日遊', 1, 4500.00, '2026-09-02 09:00:00', N'含司機小費'),
(1, NULL, 3, N'渡假村住宿費', 2, 12000.00, '2026-09-02 15:00:00', N'雙人房與單人房按比例'),
(1, 2, 4, N'水上活動門票', 3, 2800.00, '2026-09-03 10:00:00', N'依實際參加項目指定金額'),
(2, 1, 1, N'機場咖啡廳', 1, 600.00, '2026-09-04 08:00:00', N'出發前早餐'),
(2, 2, 5, N'伴手禮採購', 3, 1500.00, '2026-09-05 16:20:00', N'代購紀念品');

-- 付款人明細表 (支援多人共同墊款)
INSERT INTO ExpensePayer (ExpenseId, MemberId, PaidAmount) VALUES 
(1, 1, 3000.00), -- 費用1：Member 1 付清 3000
(2, 1, 2000.00), -- 費用2：Member 1 墊 2000
(2, 4, 2500.00), -- 費用2：Member 4 墊 2500 (兩人共墊 4500)
(3, 1, 12000.00),-- 費用3：Member 1 付清 12000
(4, 6, 2800.00), -- 費用4：Member 6 付清 2800
(5, 2, 600.00),  -- 費用5：Member 2 付清 600
(6, 5, 1500.00); -- 費用6：Member 5 付清 1500 (補齊第6筆付款)

-- 分帳人明細表 (補齊平帳資料)
INSERT INTO ExpenseSplit (ExpenseId, MemberId, Percentage, SplitAmount) VALUES 
-- 費用 1（均分 3000）：Member 1, 4, 6 每人 1000
(1, 1, NULL, 1000.00),
(1, 4, NULL, 1000.00),
(1, 6, NULL, 1000.00),

-- 費用 2（均分 4500）：Member 1, 4 每人 2250
(2, 1, NULL, 2250.00),
(2, 4, NULL, 2250.00),

-- 費用 3（按比例 12000）：50% (6000), 25% (3000), 25% (3000)
(3, 1, 50.00, 6000.00),
(3, 4, 25.00, 3000.00),
(3, 6, 25.00, 3000.00), -- 補齊最後 25%

-- 費用 4（指定金額 2800）：Member 6 (1800), Member 1 (1000)
(4, 6, NULL, 1800.00),
(4, 1, NULL, 1000.00), -- 補齊剩餘 1000

-- 費用 5（均分 600，行程 2）：Member 2, 5 每人 300
(5, 2, NULL, 300.00),
(5, 5, NULL, 300.00),

-- 費用 6（指定金額 1500，行程 2）：Member 5 個人獨負 1500
(6, 5, NULL, 1500.00);
GO

