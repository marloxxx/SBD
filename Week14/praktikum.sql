-- SQL Server 2014

-- Generating XML from Database
use northwind

-- demo 1
SELECT
    OrderID AS "@OrderID",
    CustomerID AS "CustomerID",
    EmployeeID AS "EmployeeID",
    OrderDate AS "OrderDate"
FROM Orders
-- FOR XML PATH              --1
-- FOR XML PATH('Orders')    --2
-- FOR XML PATH('Orders'), ROOT('Customer_Orders')   --3
-- analisis
-- query diatas akan menghasilkan output seluruh data dari tabel Orders

-- demo 2
SELECT
    (SELECT OrderID AS "@OrderID",
            CustomerID AS "CustomerID",
            EmployeeID AS "EmployeeID",
            OrderDate AS "OrderDate"
            FROM Orders
            FOR XML PATH('Order'), TYPE, ELEMENTS)
FOR XML PATH('Customer_Orders')
-- analisis
-- query tersebut akan menghasilkan output seluruh data dari tabel Orders yang kemudian dijadikan XML
-- di dalam XML tersebut terdapat tag Customer_Orders yang menjadi root dari XML tersebut
-- di dalam tag Customer_Orders terdapat tag Order yang berisi data dari tabel Orders dan memiliki atribut @OrderID
-- tag Order akan diulang sebanyak jumlah data yang ada di tabel Orders

-- demo 3
SELECT
    (SELECT OrderID AS "@OrderID",
            CustomerID AS "CustomerID",
            EmployeeID AS "EmployeeID",
            OrderDate AS "OrderDate",
            (SELECT 
                ProductID AS "@ProductID",
                UnitPrice AS "UnitPrice",
                Quantity AS "Quantity",
                Discount AS "Discount"
                FROM [Order Details] OD
                WHERE OD.OrderID = O.OrderID
                FOR XML PATH('OrderDetails'), TYPE
            )
            FROM Orders O
            FOR XML PATH('Order'), TYPE, ELEMENTS)
FOR XML PATH('Customer_Orders')
-- analisis
-- query tersebut akan menghasilkan output seluruh data dari tabel Orders yang kemudian dijadikan XML
-- di dalam XML tersebut terdapat tag Customer_Orders yang menjadi root dari XML tersebut
-- di dalam tag Customer_Orders terdapat tag Order yang berisi data dari tabel Orders dan memiliki atribut @OrderID
-- tag Order akan diulang sebanyak jumlah data yang ada di tabel Orders
-- di dalam tag Order terdapat tag OrderDetails yang berisi data dari tabel Order Details dan memiliki atribut @ProductID
-- tag OrderDetails akan diulang sebanyak jumlah data yang ada di tabel Order Details
