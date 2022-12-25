-- SQL Server 2014
-- 1. Topik : Create and Maintain Database
-- a. [10]Anda akan membangun Database HotelDB. Diagram Database 
-- dapat dilihat pada Lampiran 1 dan data dummy dapat dilihat pada 
-- Lampiran 2 (lampiran terdapat pada 2 halaman terakhir soal ini).
-- Buatlah syntax untuk membangun Database HotelDB dengan 
-- parameter sebagai berikut
-- Parameter value
-- Database Name HotelDB
-- Database Logical File Name(Primary) HotelDBPrimary
-- Operating System Data File Name D:UAS\SBD\HotelDB.mdf
-- Data File Maximum Size 200MB
-- Data File Initial Size 30MB
-- Data File Growth Increment 10%
-- Log Logical File Name(Primary) HotelDBLog
-- Operating System Data File Name D:UAS\SBD\HotelDB.ldf
-- Data File Maximum Size 150MB
-- Data File Initial Size 15%
-- (sesuaikan tipe data untuk setiap field berdasarkan data dummy 
-- yang diberikan pada Lampiran 2, dan pastikan setiap tabel
-- dilengkapi dengan Primary Key, dan Foreign Key)
CREATE DATABASE HotelDB
ON PRIMARY
(NAME = HotelDBPrimary,
FILENAME = 'D:UAS\SBD\HotelDB.mdf',
SIZE = 30MB,
MAXSIZE = 200MB,
FILEGROWTH = 10%)
LOG ON
(NAME = HotelDBLog,
FILENAME = 'D:UAS\SBD\HotelDB.ldf',
SIZE = 15%,
MAXSIZE = 150MB,
FILEGROWTH = 10%)
GO

CREATE TABLE HOTEL(
    hotelNo INT NOT NULL PRIMARY KEY,
    hotelName VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
)
CREATE TABLE ROOM(
    hotelNo INT NOT NULL,
    roomNo INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    CONSTRAINT PK_ROOM PRIMARY KEY (hotelNo, roomNo),
    CONSTRAINT FK_ROOM_HOTEL FOREIGN KEY (hotelNo) REFERENCES HOTEL(hotelNo)
)
CREATE TABLE GUEST(
    guestNo CHAR(3) NOT NULL PRIMARY KEY,
    guestName VARCHAR(50) NOT NULL,
    guestAddress VARCHAR(50) NOT NULL
)

CREATE TABLE BOOKING(
    hotelNo INT NOT NULL,
    guestNo CHAR(3) NOT NULL,
    dateFrom DATE NOT NULL,
    dateTo DATE NOT NULL,
    roomNo INT NOT NULL,
    CONSTRAINT PK_BOOKING PRIMARY KEY (hotelNo, dateFrom, roomNo),
    CONSTRAINT FK_BOOKING_ROOM FOREIGN KEY (roomNo) REFERENCES ROOM(roomNo)
)
GO

-- b. [10]Terdapat constraint untuk tabel Room sebagai berikut :
-- a. Type (jenis kamar)harus diisi dengan Single, Double atau
-- Family
ALTER TABLE ROOM
ADD CONSTRAINT CK_ROOM_TYPE CHECK (type IN ('Single', 'Double', 'Family'))
GO
-- b. Price (harga) harus dari rentang 350.000 -1.000.000 (price 
-- adalah harga kamar per hari)
ALTER TABLE ROOM
ADD CONSTRAINT CK_ROOM_PRICE CHECK (price BETWEEN 350000 AND 1000000)
-- c. roomNo (nomor kamar)harus angka antara 1 and 100
ALTER TABLE ROOM
ADD CONSTRAINT CK_ROOM_ROOMNO CHECK (roomNo BETWEEN 1 AND 100)

-- Tuliskan syntax untuk mengimplementasikan ketiga 
-- constraint di atas
-- c. [7.5]Tuliskan syntax untuk melakukan insert semua data dummy
-- sesuai yang diberikan pada Lampiran 2.
INSERT INTO HOTEL VALUES (1, 'Nabasa', 'Balige')
INSERT INTO HOTEL VALUES (2, 'Mutiara', 'Balige')
INSERT INTO HOTEL VALUES (3, 'Serenauli', 'Laguboti')
INSERT INTO HOTEL VALUES (4, 'Ita Hotel', 'Balige')
INSERT INTO HOTEL VALUES (5, 'Op Heri Hotel', 'Balige')
INSERT INTO HOTEL VALUES (6, 'Mareda', 'Balige')
INSERT INTO HOTEL VALUES (7, 'Palapa', 'Tarutung')
INSERT INTO HOTEL VALUES (8, 'Hineni', 'Tarutung')
INSERT INTO HOTEL VALUES (9, 'JTS Hotel', 'Samosir')
INSERT INTO HOTEL VALUES (10, 'Taman Simalem', 'Brastagi')

INSERT INTO GUEST VALUES('G01', 'Rince Septriana', 'Jl. Jambu No. 10, Samosir')
INSERT INTO GUEST VALUES('G02', 'Juan Marihot', 'Jl. Jahe No. 12, Samosir')
INSERT INTO GUEST VALUES('G03', 'Kyrie Cettyara', 'Jl.Pahlawan No.3 , Pematang Siantar')
INSERT INTO GUEST VALUES('G04', 'Diana Octaviana', 'Jl. Kartini No.20,Dolok Sanggul')
INSERT INTO GUEST VALUES('G05', 'Junika Tobing', 'Jl.SM Raja No 1, Laguboti')

INSERT INTO ROOM VALUES(1, 1, 'Single', 350000)
INSERT INTO ROOM VALUES(2, 1, 'Double', 500000)
INSERT INTO ROOM VALUES(3, 2, 'Family', 1000000)
INSERT INTO ROOM VALUES(4, 2, 'Double', 450000)
INSERT INTO ROOM VALUES(5, 3, 'Family', 800000)
INSERT INTO ROOM VALUES(6, 3, 'Single', 550000)
INSERT INTO ROOM VALUES(7, 4, 'Single', 600000)
INSERT INTO ROOM VALUES(8, 4, 'Double', 800000)
INSERT INTO ROOM VALUES(9, 5, 'Single', 550000)
INSERT INTO ROOM VALUES(10, 5, 'Double', 750000)

INSERT INTO BOOKING VALUES(1, 'G01', '12/12/2019', '12/14/2019', 1)
INSERT INTO BOOKING VALUES(1, 'G02', '12/13/2019', '12/16/2019', 2)
INSERT INTO BOOKING VALUES(2, 'G03', '12/13/2019', '12/16/2019', 3)
INSERT INTO BOOKING VALUES(2, 'G04', '12/14/2019', '12/16/2019', 4)
INSERT INTO BOOKING VALUES(3, 'G05', '12/14/2019', '12/16/2019', 5)

-- 2. Topik : Query dan Join
-- a. [2.5] Buatlah query untuk menampilkan nama hotel yang berada 
-- di Samosir ataupun di Tarutung.
SELECT hotelNo, hotelName, city
FROM HOTEL
WHERE city = 'Samosir' OR city = 'Tarutung'

-- b. [5] Buatlah query untuk menampilkan harga kamar tertinggi dan 
-- terendah per type kamar.
SELECT type, MAX(price) AS maxPrice, MIN(price) AS minPrice
FROM ROOM
GROUP BY type

-- c. [5] Buatlah query untuk menampilkan nama hotel yang memiliki 
-- price (harga) tertinggi
SELECT h.hotelName
FROM HOTEL h
JOIN ROOM r ON h.hotelNo = r.hotelNo
WHERE r.price = (SELECT MAX(price) FROM ROOM)

-- d. [5]Tampilkanlah kamar yang belum pernah di-booking oleh 
-- tamu (guest) manapun
SELECT r.*
FROM ROOM r
LEFT JOIN BOOKING b ON r.hotelNo = b.hotelNo AND r.roomNo = b.roomNo
WHERE b.hotelNo IS NULL

-- 3. [10]Topik : View
-- Buatlah view dengan nama vGuestBooking untuk menampilkan 
-- semua nama tamu beserta rincian room yang pernah di-booking
CREATE VIEW vGuestBooking AS
SELECT g.guestNo, g.guestName, r.*
FROM GUEST g
JOIN BOOKING b ON g.guestNo = b.guestNo
JOIN ROOM r ON b.hotelNo = r.hotelNo AND b.roomNo = r.roomNo
GO

-- 4. [15] Function
-- Buatlah 1 fungsi dengan nama fCalculateTotalPrice dimana fungsi ini 
-- akan menghitung jumlah harga yang akan dibayar untuk room yang dibooking. Parameter masukan untuk fungsi ini adalah roomNo,hotelNo, 
-- dateFrom, dateTo.
-- Contoh :
-- Room yang di-booking adalah roomNo :1, hotelNo :1
-- Mulai tanggal (dateFrom) : 12/12/2019 sampai dengan tanggal 
-- (dateTo): 15/12/2019 (3 hari).
-- Hasil yang diharapkan dapat dihitung oleh fungsi adalah total price 
-- =price x jumlah hari di-booking 
-- = 350.000 x 3 
-- = 1.050.000
CREATE FUNCTION fCalculateTotalPrice
(@roomNo INT, @hotelNo INT, @dateFrom DATE, @dateTo DATE)
RETURNS INT
AS
BEGIN
    DECLARE @price INT
    DECLARE @totalPrice INT
    DECLARE @days INT

    SELECT @price = price
    FROM ROOM
    WHERE roomNo = @roomNo AND hotelNo = @hotelNo

    SELECT @days = DATEDIFF(DAY, @dateFrom, @dateTo)

    SELECT @totalPrice = @price * @days

    RETURN @totalPrice
END

-- 5. [15]Store Procedure
-- Buatlah 1 stored procedure dengan nama spDisplayAvailableRoom 
-- yang akan menampilkan room jenis tertentu yang available pada 
-- tanggal tertentu. 
-- Parameter masukan adalah : type room, tanggal
-- Contoh :
-- Typeroom : family
-- Tanggal : 1/1/2020

CREATE PROCEDURE spDisplayAvailableRoom
@type VARCHAR(50), @date DATE
AS
BEGIN
    SELECT r.*
    FROM ROOM r
    LEFT JOIN BOOKING b ON r.hotelNo = b.hotelNo AND r.roomNo = b.roomNo
    WHERE r.type = @type AND (b.dateFrom > @date OR b.dateTo < @date)
END

-- 6. [15]Trigger
-- (Anda perlu membuat tabel baru dengan nama Room_History 
-- untuk soal ini.)
-- Buatlah 1 buah trigger yang akan melakukan penyimpanan sejarah 
-- perubahan data tabel Room. Apabila ada perubahan berupa 
-- penghapusan data di tabel Room maka data yang dihapus akan dicatat 
-- table Room_History.
CREATE TABLE Room_History
(
    roomNo INT,
    hotelNo INT,
    keterangan VARCHAR(100)
)
GO

CREATE TRIGGER trRoomHistory
ON ROOM
AFTER DELETE
AS
BEGIN
    INSERT INTO Room_History
    -- contoh : 1 1 Dihapus tanggal 14/01/2020
    SELECT roomNo, hotelNo, 'Dihapus tanggal ' + CONVERT(VARCHAR(10), GETDATE(), 105)
    FROM DELETED
END
