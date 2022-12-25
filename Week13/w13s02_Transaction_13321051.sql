/*
	Nama	: Horas Marolop Amsal Siregar
	NIM		: 11321051
	Kelas	: 32TI2
*/

-- Excercise 1
CREATE TABLE test (
	col INT CONSTRAINT PK_TEST PRIMARY KEY
)
GO
BEGIN TRAN
	INSERT test (col) VALUES (1)
	INSERT test (col) VALUES (1)
	INSERT test (col) VALUES (2)
COMMIT TRAN

SELECT * FROM test
-- Analisis
-- Pada proses ini, terjadi error karena terdapat duplikasi data pada kolom col. Pada insert pertama, data yang dimasukkan adalah 1, pada insert kedua, data yang dimasukkan juga 1, sehingga terjadi duplikasi data. Oleh karena itu, proses insert kedua tidak dapat dilakukan.
-- Excercise 2
DELETE TEST
GO
BEGIN TRAN
	DECLARE @err int
		INSERT test (col) VALUES (1)
			SET @err = @@ERROR
			IF @err <> 0 ROLLBACK TRAN
		INSERT test (col) VALUES (1)
			SET @err = @@ERROR
			IF @err <> 0 ROLLBACK TRAN
		INSERT test (col) VALUES (2)
			SET @err = @@ERROR
			IF @err <> 0 ROLLBACK TRAN
COMMIT TRAN

-- Excercise 3
BEGIN TRY
	BEGIN TRAN
		INSERT test (col) VALUES (1)
		INSERT test (col) VALUES (1)
		INSERT test (col) VALUES (2)
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH

BEGIN TRY
	BEGIN TRAN
		print 'before insertion'
		INSERT test (col) VALUES (1)
		print '1st insertion'
		INSERT test (col) VALUES (1) --error/rollback
		print '2nd insertion' -- was not executed
		INSERT test (col) VALUES (2) -- was not executed
		print '3rd insertion'
	COMMIT TRAN
END TRY
BEGIN CATCH
	print 'before rb'
	ROLLBACK TRAN
	print 'after rb'
END CATCH

-- Excercise 4
BEGIN TRAN
	BEGIN TRY
		BEGIN TRAN
			INSERT test (col) VALUES (1)
			INSERT test (col) VALUES (1) --rollback
			INSERT test (col) VALUES (2)
		COMMIT TRAN
	END TRY
BEGIN CATCH
	ROLLBACK TRAN --@trancount = 0
END CATCH
COMMIT TRAN 

-- Excercise 5
CREATE PROC tranTest
	AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT test (col) VALUES (1)
				INSERT test (col) VALUES (1)
				INSERT test (col) VALUES (2)
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
	END
GO
-- procedure call inside a transaction:
BEGIN TRAN
	EXEC tranTest
COMMIT TRAN

CREATE PROC tranTest
	AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				print '1st insertion'
				INSERT test (col) VALUES (1)
				print '2nd insertion'
				INSERT test (col) VALUES (1)
				print '3rd insertion'
				INSERT test (col) VALUES (2)
			COMMIT TRAN
		END TRY
	BEGIN CATCH
		print 'before rb'
		ROLLBACK TRAN
		print 'after rb'
	END CATCH
END
GO
-- procedure call inside a transaction:
BEGIN TRAN
	Print 'before exec sp'
	EXEC tranTest
	Print 'after exec sp'
COMMIT TRAN

-- Tugas
-- Studi Kasus menggunakan Transaction referensi dalam checkout

-- CREATE TABLE
CREATE TABLE CUSTOMER (
    id_customer INT PRIMARY KEY,
    nama_customer VARCHAR(50),
    alamat VARCHAR(50),
    no_telp VARCHAR(50)
)

CREATE TABLE PRODUK (
    id_produk INT PRIMARY KEY,
    nama_produk VARCHAR(50),
    harga INT,
    stok INT
)

CREATE TABLE CART(
    id_customer INT,
    id_barang INT,
    jumlah INT,
    FOREIGN KEY (id_customer) REFERENCES customer(id_customer),
    FOREIGN KEY (id_barang) REFERENCES produk(id_produk)
)
GO

-- Tambahkan constraint untuk memastikan bahwa jumlah barang yang dibeli tidak boleh melebihi stok yang ada
-- SQL Server 2014
CREATE FUNCTION [dbo].[fn_cekStok] (@id_produk INT, @jumlah INT)
RETURNS INT
AS
BEGIN
	DECLARE @stok INT
	SELECT @stok = stok FROM produk WHERE id_produk = @id_produk
	IF @stok < @jumlah
		RETURN 0
	RETURN 1
END
GO

ALTER TABLE CART ADD CONSTRAINT cekStok CHECK (fn_cekStok(id_barang, jumlah) = 1)
GO

-- INSERT DUMMY DATA
INSERT INTO customer VALUES (1, 'Horas Marolop', 'Jl. Kebon Jeruk', '08123456789')
INSERT INTO customer VALUES (2, 'Boy Tri', 'Jl. Kebon Jeruk', '08123456789')

INSERT INTO produk VALUES (1, 'Buku Tulis', 5000, 10)
INSERT INTO produk VALUES (2, 'Penghapus', 3000, 10)
INSERT INTO produk VALUES (3, 'Pensil', 2000, 10)
INSERT INTO produk VALUES (4, 'Penggaris', 1000, 10)
GO

-- SYNTAX TRANSACTION
CREATE PROCEDURE tambah_keranjang
	@id_customer INT,
	@id_barang INT,
	@jumlah INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			-- 1. cek apakah barang ada di keranjang
			IF (SELECT COUNT(*) FROM cart WHERE id_customer = @id_customer AND id_barang = @id_barang) > 0
			BEGIN
				-- 2. jika ada, update jumlah barang
				UPDATE cart SET jumlah = jumlah + @jumlah WHERE id_customer = @id_customer AND id_barang = @id_barang
				PRINT 'Barang sudah ada di keranjang, jumlah barang di keranjang diperbarui'
			END
			ELSE
			BEGIN
				-- 3. jika tidak ada, tambahkan barang ke keranjang
				INSERT INTO cart VALUES (@id_customer, @id_barang, @jumlah)
				PRINT 'Barang berhasil ditambahkan ke keranjang'
			END
			-- 4. kurangi stok barang
			UPDATE produk SET stok = stok - @jumlah WHERE id_produk = @id_barang
			PRINT 'Stok barang berhasil diperbarui'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
END
GO

-- Jika kita ingin memanggil procedure di dalam transaction, kita harus menggunakan BEGIN TRAN dan COMMIT TRAN
BEGIN TRAN
	EXEC tambah_keranjang 1, 1, 1
	EXEC tambah_keranjang 1, 1, 1
	EXEC tambah_keranjang 1, 3, 11
	EXEC tambah_keranjang 1, 4, 1
COMMIT TRAN
GO