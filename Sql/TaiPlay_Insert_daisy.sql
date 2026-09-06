--USE master;
--GO

---- 如果 TaiPlay 已存在，強制中斷連線並刪除資料庫
--IF DB_ID(N'TaiPlay') IS NOT NULL
--BEGIN
--    ALTER DATABASE TaiPlay
--    SET SINGLE_USER
--    WITH ROLLBACK IMMEDIATE;

--    DROP DATABASE TaiPlay;
--END
--GO

---- 重新建立乾淨的 TaiPlay 資料庫
--CREATE DATABASE TaiPlay;
--GO

--USE TaiPlay;
--GO


--  行程旅伴代表圖示表
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