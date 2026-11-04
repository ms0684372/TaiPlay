-- =============================================
-- 展示用：小編評分假資料
-- 僅供測試／展示使用，正式資料請由後台手動填寫
-- =============================================
USE TaiPlay;
GO

-- 替尚未評分的啟用地點填入 3.0～4.9 的隨機分數
UPDATE Places
SET EditorRating = ROUND(3.0 + (ABS(CHECKSUM(NEWID())) % 20) / 10.0, 1)
WHERE IsActive = 1 AND EditorRating IS NULL;
GO

-- 清除所有小編評分（需要時取消註解執行）
-- UPDATE Places SET EditorRating = NULL;
-- GO