USE TaiPlay
GO

INSERT INTO dbo.MapType (TypeName, ImageUrl) VALUES
    (N'景點', NULL),
    (N'美食', NULL),
    (N'購物', NULL)
GO

INSERT INTO dbo.TripTransportation (ImageUrl, Name) VALUES
    (NULL, N'自定義'),
    (NULL, N'汽車'),
    (NULL, N'摩托車'),
    (NULL, N'大眾運輸'),
    (NULL, N'走路')
GO

INSERT INTO dbo.Trip (UserId, ImageUrl, TripName, Description, StartDate, EndDate) VALUES
    (1, null, N'樹林一日遊', N'樹林鳥不生蛋不好玩QQ', '2026-07-31', '2026-07-31'),
    (1, null, N'台北玩兩天', N'地下街真好玩', '2026-08-06', '2026-08-07'),
    (2, null, N'參加網聚', N'來去認親囉', '2026-08-29', '2026-08-30')
GO


INSERT INTO dbo.TripItem (TripId, Title, Description, Day, AttractionId, SortOrder, TransportationId) VALUES
    (1, N'樹林車站', N'來去車站附近走走', 1, 1, 1, 0, '13:00', 0, '01:00', NULL, 1),
    (1, N'樹林夜市', N'夜市吃吃喝喝', 1, 2, 2, 0, '13:00', 0, '01:00', NULL, 1),
    (1, N'樹林秀泰', N'看電影', 1, 3, 3, 0, '13:00', 0, '01:00', NULL, 1)
GO

INSERT INTO dbo.TripRoute (TripId, StartItemId, EndItemId, TransportationId, Distance, SpendTime, Routedata) VALUES
    (1, 1, 2, 1, 300, 300, NULL),
    (1, 1, 2, 1, 300, 300, NULL),
    (1, 1, 2, 1, 300, 300, NULL)
GO