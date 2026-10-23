CREATE DATABASE ECommerceDW;
GO

USE ECommerceDW;
GO

CREATE TABLE DimCustomer (
    CustomerId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CustomerName NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Segment NVARCHAR(30) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE DimProduct (
    ProductId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProductName NVARCHAR(150) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL
);
GO

CREATE TABLE FactSales (
    SaleId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CustomerId UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES DimCustomer(CustomerId),
    ProductId UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES DimProduct(ProductId),
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL,
    SaleDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

INSERT INTO DimCustomer (CustomerName, City, Segment) VALUES
('John Doe', 'New York', 'Corporate'),
('Jane Smith', 'Los Angeles', 'Individual'),
('Alice Johnson', 'Chicago', 'Corporate'),
('Bob Brown', 'Houston', 'Individual');
GO

INSERT INTO DimProduct (ProductName, Category, UnitPrice) VALUES
('Laptop Pro', 'Electronics', 1200.00),
('Wireless Mouse', 'Electronics', 25.00),
('Ergonomic Chair', 'Furniture', 250.00),
('Standing Desk', 'Furniture', 500.00);
GO

CREATE NONCLUSTERED INDEX IX_FactSales_CustomerId 
ON FactSales (CustomerId);
GO

CREATE NONCLUSTERED INDEX IX_FactSales_ProductId 
ON FactSales (ProductId);
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX IX_FactSales_Columnstore 
ON FactSales (CustomerId, ProductId, Quantity, TotalAmount, SaleDate);
GO

CREATE PROCEDURE GenerateBulkSales
    @BatchCount INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Counter INT = 0;

    WHILE @Counter < @BatchCount
    BEGIN
        INSERT INTO FactSales (CustomerId, ProductId, Quantity, TotalAmount, SaleDate)
        SELECT TOP 1000
            c.CustomerId,
            p.ProductId,
            ABS(CHECKSUM(NEWID())) % 5 + 1,
            p.UnitPrice * (ABS(CHECKSUM(NEWID())) % 5 + 1),
            DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 365), GETDATE())
        FROM DimCustomer c
        CROSS JOIN DimProduct p
        ORDER BY NEWID();

        SET @Counter = @Counter + 1;
    END
END;
GO
