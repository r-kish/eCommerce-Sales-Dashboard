-- e-Commerce Sales Report SQL Analysis and Dashboard
-- By: Richard Kish
-- Finished March 2024
------------------------------------------------------------------------------------------------------------

-- POSHMARK-ONLY DATA
-- This will have Poshmark-specific data regarding item category, size, and color
SELECT [Order Date], [Listing Title], Category, Color, Size, [Net Earnings], [Buyer State]
FROM ShopSales.dbo.file$
ORDER BY 1

------------------------------------------------------------------------------------------------------------

-- DATA CLEANING AND TRANSFORMATION
-- Poshmark
EXEC sp_rename 'ShopSales.dbo.file$.[Listing Title]',  'Item Title', 'COLUMN'
EXEC sp_rename 'ShopSales.dbo.file$.[Buyer State]',  'Shipped to State', 'COLUMN'
EXEC sp_rename 'ShopSales.dbo.file$.[Net Earnings]',  'Net Seller Proceeds', 'COLUMN'
ALTER TABLE ShopSales.dbo.file$ ADD Store varchar(255)
UPDATE ShopSales.dbo.file$ SET Store = 'Poshmark'
DELETE FROM ShopSales.dbo.file$ WHERE [Net Seller Proceeds]= 3441.31
DELETE FROM ShopSales.dbo.file$ WHERE [Net Seller Proceeds] IS NULL

SELECT *
FROM ShopSales.dbo.file$
ORDER BY 1

-- Mercari
SELECT *
FROM ShopSales.dbo.MercariSalesReport$
ORDER BY 1

ALTER TABLE ShopSales.dbo.MercariSalesReport$ ADD Store varchar(255)
UPDATE ShopSales.dbo.MercariSalesReport$ SET Store = 'Mercari'

-- eBay
SELECT *
FROM ShopSales.dbo.eBaySalesReport$
ORDER BY 1

EXEC sp_rename 'ShopSales.dbo.eBaySalesReport$.[Net sales (Net of taxes and selling costs)]',  'Net Seller Proceeds', 'COLUMN'
EXEC sp_rename 'ShopSales.dbo.eBaySalesReport$.[Listing title]',  'Item Title', 'COLUMN'
ALTER TABLE ShopSales.dbo.eBaySalesReport$ ADD Store varchar(255)
UPDATE ShopSales.dbo.eBaySalesReport$ SET [Store] = 'eBay'
ALTER TABLE ShopSales.dbo.eBaySalesReport$ ADD [Shipped to State] varchar(255)

------------------------------------------------------------------------------------------------------------

-- JOIN CLEANED DATA
-- This will be used for geographic data and overall profits data
SELECT [Item Title], [Shipped to State], [Net Seller Proceeds], [Store] 
FROM ShopSales.dbo.eBaySalesReport$
UNION ALL
SELECT [Item Title], [Shipped to State], [Net Seller Proceeds], [Store] 
FROM ShopSales.dbo.MercariSalesReport$
UNION ALL
SELECT [Item Title], [Shipped to State], [Net Seller Proceeds], [Store] 
FROM ShopSales.dbo.file$