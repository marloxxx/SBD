/*
	Nama	: Horas Marolop Amsal Siregar
	NIM		: 11321051
	Kelas	: 32TI2
*/

-- Soal 1:
-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'MiniPerpustakaan')
BEGIN
    CREATE DATABASE MiniPerpustakaan
END
GO

USE MiniPerpustakaan
GO

-- Create Table
CREATE TABLE Mahasiswa(
    NIM CHAR(10) PRIMARY KEY,
    Nama VARCHAR(30),
)

CREATE TABLE Buku(
    Id_Buku CHAR(10) PRIMARY KEY,
    Penerbit VARCHAR(20),
    Deskrpsi VARCHAR(50),
    StockAvailable INT
)
CREATE TABLE Transaksi(
    NIM CHAR(10) NOT NULL,
    Id_Buku CHAR(10) NOT NULL,
    Waktu_Pinjam DATETIME NOT NULL,
    Waktu_Kembali DATETIME,
    Denda MONEY,
    FOREIGN KEY (NIM) REFERENCES Mahasiswa(NIM),
    FOREIGN KEY (Id_Buku) REFERENCES Buku(Id_Buku)
)
-- SET PRIMARY KEY (NIM, Id_Buku, Waktu_Pinjam)
ALTER TABLE Transaksi ADD CONSTRAINT PK_Transaksi PRIMARY KEY (NIM, Id_Buku, Waktu_Pinjam)

-- CREATE DUMMY DATA
INSERT INTO
    Mahasiswa
VALUES
    (
        '11321051',
        'Horas Marolop Amsal Siregar'
    ),
    (
        '11321052',
        'Theofil Nainggolan'
    ),
    (
        '11321050',
        'Frayogi Sitorus'
    )

    INSERT INTO
    Buku
VALUES
    (
        'B001',
        'Erlangga',
        'Buku tentang pemrograman',
        0
    ),
    (
        'B002',
        'Erlangga',
        'Buku tentang pemrograman',
        10
    ),
    (
        'B003',
        'Erlangga',
        'Buku tentang pemrograman',
        10
    )

-- Physical Data Model tersebut terdiri atas tiga buah tabel, yaitu:
-- - tabel yang menyimpan data mahasiswa (Mahasiswa),
-- - tabel yang menyimpan data buku di perpustakaan (Buku), dan
-- - tabel yang merekam semua transaksi peminjaman dan pengembalian buku oleh mahasiswa (Transaksi).
-- Proses yang terjadi pada perpustakaan:
-- - Jika seorang mahasiswa melakukan peminjaman buku maka kolom StockAvailable untuk buku
-- yang dipinjam tersebut harus lebih dari 0.

-- Tugas Anda
-- a. Buatlah sebuah trigger untuk aksi after insert pada tabel transaksi untuk memvalidasi apakah
-- seorang mahasiswa dapat melakukan peminjaman buku atau tidak dengan memperhatikan jumlah buku
-- yang available (kolom StockAvailable untuk buku yang dipinjam harus lebih dari 0. Jika StockAvailable = 0
-- maka transaksi peminjaman tidak berhasil atau terjadi rollback). Jika mahasiswa boleh meminjam buku
-- maka prosesinserting berhasil dan kolom StockAvailable akan dikurangi dengan 1.
CREATE TRIGGER trgInsertTransaksi ON Transaksi
AFTER INSERT
AS
IF (SELECT StockAvailable FROM Buku WHERE Id_Buku = (SELECT Id_Buku FROM Inserted)) > 0
BEGIN
    -- Update StockAvailable
    UPDATE Buku SET StockAvailable = StockAvailable - 1 WHERE Id_Buku = (SELECT Id_Buku FROM Inserted)
END
ELSE
BEGIN
    -- Rollback
    PRINT 'StockAvailable = 0'
    ROLLBACK TRANSACTION
END
GO

INSERT INTO Transaksi VALUES('11321051', 'B001', GETDATE(), NULL, 0)
INSERT INTO Transaksi VALUES('11321051', 'B002', GETDATE(), NULL, 0)
GO

SELECT * FROM Buku
GO

-- b. Buatlah sebuah trigger untuk aksi AFTER UPDATE pada tabel transaksi untuk proses pengembalian
-- buku. Jika buku sudah dikembalikan, maka kolom StockAvailable untuk buku yang dipinjam harus
-- ditambah 1.
CREATE TRIGGER trgUpdateTransaksi ON Transaksi
AFTER UPDATE
AS
IF (SELECT Waktu_Kembali FROM Inserted) IS NOT NULL
BEGIN
    -- Update StockAvailable
    UPDATE Buku SET StockAvailable = StockAvailable + 1 WHERE Id_Buku = (SELECT Id_Buku FROM Inserted)
END
GO

UPDATE Transaksi SET Waktu_Kembali = GETDATE() WHERE NIM = '11321051' AND Id_Buku = 'B002'
GO

SELECT * FROM Buku

-- Soal 2:
-- CREATE DATABASE
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'MiniTabungan')
BEGIN
    CREATE DATABASE MiniTabungan
END
GO
USE MiniTabungan
-- CREATE TABLE
CREATE TABLE T_Tabungan(
    TabID CHAR(10) PRIMARY KEY,
    Saldo MONEY
)

CREATE TABLE T_Transaksi(
    TransID CHAR(10) PRIMARY KEY,
    TabID CHAR(10),
    TransDateTime DATETIME,
    Amount MONEY,
    Tipe CHAR(9),
    FOREIGN KEY (TabID) REFERENCES T_Tabungan(TabID)
)

-- CREATE DUMMY DATA
INSERT INTO
    T_Tabungan
VALUES
    (
        'T001',
        100000
    ),
    (
        'T002',
        200000
    ),
    (
        'T003',
        300000
    )

-- Tabel T_Tabungan dan T_Transaksi mempunyai relasi one to many pada T_Tabungan.TabID= T_Transaksi.TabID,
-- seperti yang ditunjukkan pada gambar. Terdapat domain integrity pada T_Transaksi, yakni kolom Tipe. Hanya
-- ada dua tipe transaksi yang diijinkan, yaitu Withdraw(penarikan) dan Transfer(setoran). Lakukan validasi
-- untuk jenis transaksi. TransDateTime merupakan representasi dari waktu dan tanggal transaksi dan Amount
--  adalah representasi jumlah Withdraw atau Transfer.
-- Pada T_Tabungan, Saldo merupakan representasi dari jumlah uang saat ini yang dimiliki oleh TabID tertentu di Bank.
-- Perhatikan dua tabel tersebut, anda harus menambahkan sebuah kolom TabID_To pada tabel T_Transaksi diatas.
ALTER TABLE T_Transaksi ADD TabID_To CHAR(10)
ALTER TABLE T_Transaksi ADD CONSTRAINT FK_T_Transaksi_T_Tabungan FOREIGN KEY (TabID_To) REFERENCES T_Tabungan(TabID)
GO

-- Tugas Anda
-- Buatlah sebuah trigger dengan nama trg_SaldoTabungan untuk aksi insert dan update pada tabel T_Transaksi
-- untuk mengkalkulasi atribut saldo pada T_Tabungan. Misalnya, terdapat sebuah transaksi dengan tipe Withdraw
-- maka jumlah saldo pada T_Tabungan harus berkurang sebanyak jumlah Withdraw yang dilakukan. Sebaliknya,
-- jika terdapat transaksi dengan tipe Transfer, maka jumlah saldo pada T_Tabungan harus bertambah sebanyak
-- jumlah Transfer yang dilakukan. Proses yang sama anda gunakan untuk apabila terdapat transaksi update.
-- Anda harus memastikan bahwa untuk transaksi dengan tipe Withdraw, jumlah yang ditarik harus sama atau
-- lebih kecil dari jumlah saldo. 
CREATE TRIGGER trg_SaldoTabungan ON T_Transaksi
AFTER INSERT, UPDATE
AS
IF (SELECT Tipe FROM Inserted) = 'Withdraw'
BEGIN
    IF (SELECT Amount FROM Inserted) <= (SELECT Saldo FROM T_Tabungan WHERE TabID = (SELECT TabID FROM Inserted))
    BEGIN
        UPDATE T_Tabungan SET Saldo = Saldo - (SELECT Amount FROM Inserted) WHERE TabID = (SELECT TabID FROM Inserted)
    END
    ELSE
    BEGIN
        PRINT 'Saldo tidak mencukupi'
        ROLLBACK TRANSACTION
    END
END
ELSE IF (SELECT Tipe FROM Inserted) = 'Transfer'
BEGIN
    UPDATE T_Tabungan SET Saldo = Saldo + (SELECT Amount FROM Inserted) WHERE TabID = (SELECT TabID FROM Inserted)
    UPDATE T_Tabungan SET Saldo = Saldo - (SELECT Amount FROM Inserted) WHERE TabID = (SELECT TabID_To FROM Inserted)
END
GO

INSERT INTO T_Transaksi VALUES('TR001', 'T001', GETDATE(), 50000, 'Withdraw', NULL)
INSERT INTO T_Transaksi VALUES('TR002', 'T001', GETDATE(), 50000, 'Transfer', 'T002')
