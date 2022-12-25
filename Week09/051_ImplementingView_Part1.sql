/*
	Nama	: Horas Marolop Amsal Siregar
	NIM		: 11321051
	Kelas	: 32TI2
*/

CREATE DATABASE Minidatabase
GO

USE Minidatabase

CREATE TABLE Mahasiswa
(
    NIM CHAR(8) NOT NULL,
    Nama VARCHAR(50) NOT NULL,
    JK CHAR(1) NOT NULL,
    PRIMARY KEY (NIM)
)

CREATE TABLE Nilai
(
    NIM CHAR(8) NOT NULL,
    MK CHAR(3) NOT NULL,
    Nilai INT NOT NULL,
    PRIMARY KEY (NIM, MK),
    FOREIGN KEY (NIM) REFERENCES Mahasiswa (NIM)
)

-- 2. Insert 10 baris data dummy ke Tabel Mahasiswa dan Nilai
INSERT INTO Mahasiswa
VALUES
    ('11321051', 'Horas', 'L')
INSERT INTO Mahasiswa
VALUES
    ('11321052', 'Rahmat', 'L')
INSERT INTO Mahasiswa
VALUES
    ('11321053', 'Siti', 'P')
INSERT INTO Mahasiswa
VALUES
    ('11321054', 'Rahayu', 'P')
INSERT INTO Mahasiswa
VALUES
    ('11321055', 'Boy', 'L')
INSERT INTO Mahasiswa
VALUES
    ('11321056', 'Olivia', 'P')
INSERT INTO Mahasiswa
VALUES
    ('11321057', 'Rizky', 'L')
INSERT INTO Mahasiswa
VALUES
    ('11321058', 'Rahma', 'P')
INSERT INTO Mahasiswa
VALUES
    ('11321059', 'Rahmi', 'P')
INSERT INTO Mahasiswa
VALUES
    ('11321060', 'Rahel', 'P')

INSERT INTO Nilai
VALUES
    ('11321051', 'PBD', 80)
INSERT INTO Nilai
VALUES
    ('11321051', 'PAP', 90)
INSERT INTO Nilai
VALUES
    ('11321051', 'PSW', 70)
INSERT INTO Nilai
VALUES
    ('11321052', 'PAM', 80)
INSERT INTO Nilai
VALUES
    ('11321052', 'SBD', 90)
INSERT INTO Nilai
VALUES
    ('11321052', 'PSW', 70)
INSERT INTO Nilai
VALUES
    ('11321053', 'PPL', 80)
INSERT INTO Nilai
VALUES
    ('11321053', 'ENG', 90)
INSERT INTO Nilai
VALUES
    ('11321053', 'RPL', 70)
INSERT INTO Nilai
VALUES
    ('11321054', 'PA', 80)

-- B. Langkah-langkah
-- 1. Langkah 1,
-- Jalankan query berikut, perhatikan resultset yang dihasilkan oleh query tersebut
SELECT *
FROM Mahasiswa
WHERE JK = 'L'

-- 2. Langkah 2,
-- Jalankan syntax berikut untuk membuat 1 objek view di database dengan nama
-- vMahasiswa_Putra yang menampilkan data seperti yang dihasilkan di query yang anda
-- jalankan pada langkah 1
CREATE VIEW vMahasiswa_Putra
AS
    SELECT *
    FROM Mahasiswa
    WHERE JK = 'L'

-- 3. Langkah 3,
-- Tampilkan data dari objek view vMahasiswa_Putra dengan menjalankan syntax berikut,
-- bandingkan hasilnya dengan query yang anda jalankan pada langkah 1? tuliskan komentar dalam laporan anda.
SELECT *
FROM vMahasiswa_Putra
-- hasilnya sama dengan query yang dijalankan pada langkah 1, yaitu menampilkan data mahasiswa yang jenis kelaminnya laki-laki

-- 4. Langkah 4,
-- Jalankan syntax berikut apakah data berhasil ditambahkan ? berikan komentar anda pada aporan anda.
INSERT INTO vMahasiswa_Putra
VALUES
    ('07', 'Tobby', 'L')
INSERT INTO vMahasiswa_Putra
VALUES
    ('08', 'Josua', 'L')
INSERT INTO vMahasiswa_Putra
VALUES
    ('09', 'Nia', 'L')
-- data berhasil ditambahkan ke dalam view vMahasiswa_Putra

-- 5. Langkah 5,
-- Jalankan syntax berikut apakah data berhasil di-update ? berikan komentar anda pada laporan anda.
UPDATE vMahasiswa_Putra
SET JK = 'P'
WHERE NIM = '09'
-- data berhasil di-update pada view vMahasiswa_Putra, sehingga data yang awalnya laki-laki menjadi perempuan

-- 6. Langkah 6,
-- Jalankan syntax berikut.
DELETE FROM vMahasiswa_Putra
WHERE NIM = '09'
-- Apakah mahasiswa dengan jenis kelamin Perempuan (P) dengan NIM ‘09’ dapat dihapus melalui vMahasiswa_Putra? berikan komentar anda pada laporan anda.
-- data mahasiswa dengan jenis kelamin perempuan (P) dengan NIM '09' tidak dapat dihapus melalui vMahasiswa_Putra, hal ini dikarenakan view vMahasiswa_Putra hanya menampilkan data mahasiswa yang jenis kelaminnya laki-laki
-- Apakah mahasiswa dengan jenis kelamin laki-laki (L) dihapus melaluivMahasiswa_Putra? berikan komentar anda pada laporan anda.
-- data mahasiswa dengan jenis kelamin laki-laki (L) tidak dapat dihapus melalui vMahasiswa_Putra

-- 7. Langkah 7,
-- Jalankan syntax berikut untuk membuat 1 objek view di database dengan nama vMahasiswa_Putra_2 dengan menggunakan CONSTRAINT "CHECK OPTION" dan bandingkan perbedaannya dengan vMahasiswa_Putra
CREATE VIEW vMahasiswa_Putra_2
AS
    SELECT *
    FROM Mahasiswa
    WHERE JK='L' with CHECK OPTION
-- Jalankan syntax berikut untuk menampilkan hasilnya:
SELECT *
FROM vMahasiswa_Putra_2

-- 8. Langkah 8,
-- Jalankan syntax berikut untuk melakukan insert, update dan hapus data melalui view yang anda buat dengan “CHECK OPTION”
INSERT INTO vMahasiswa_Putra_2
VALUES
    ('10', 'Dita', 'P')
UPDATE vMahasiswa_Putra_2 SET JK = 'P' WHERE NIM = '07'
DELETE FROM vMahasiswa_Putra_2 WHERE NIM = '02'
-- Apakah mahasiswa dengan jenis kelamin Perempuan (P) berhasil di-insert, dihapus,ataupun di-update melalui vMahasiswa_Putra_2? Tuliskan komentar anda pada laporan anda.
-- Data mahasiswa dengan jenis kelamin perempuan (P) tidak berhasil di-insert, di-update melalui vMahasiswa_Putra_2, karena view vMahasiswa_Putra_2 menggunakan CONSTRAINT "CHECK OPTION", dan tidak dapat dihapus karena tidak ada data mahasiswa dengan NIM '02' pada view vMahasiswa_Putra_2

-- 9. Langkah 9,
-- Jalankan syntax berikut dan analisis hasilnya, apakah kegunaan syntax tersebut?tuliskan dalam laporan anda
sp_helptext vMahasiswa_Putra_2
-- Syntax tersebut digunakan untuk menampilkan definisi dari view vMahasiswa_Putra_2
-- Jalankan syntax berikut dan analisis hasilnya, apakah kegunaansyntax tersebut?tuliskan dalam laporan Anda
sp_depends vMahasiswa_Putra_2
-- Syntax tersebut digunakan untuk menampilkan semua objek yang tergantung pada view vMahasiswa_Putra_2, yaitu view vMahasiswa_Putra_2 tergantung pada tabel Mahasiswa

-- 10. Langkah 10,
-- Jalankan syntax berikut untuk membuat 1 contoh view yang datanya berasal dari 2 base table
CREATE VIEW vNilaiPBD
AS
    SELECT m.nim, m.Nama, mk, nilai
    FROM Mahasiswa m
        INNER JOIN Nilai n
        ON m.nim=m.nim
    WHERE mk='PBD'

-- Buatlah syntax insert, update, delete data melalui view vNilaiPBD. Apakah insert, update
-- dan delete data dapat dilakukan? Berikan komentar anda pada laporan
INSERT INTO vNilaiPBD
VALUES
    ('11321060', 'PBD', 80)
UPDATE vNilaiPBD SET nilai = 90 WHERE nim = '11321060'
DELETE FROM vNilaiPBD WHERE nim = '11321060'
-- Data tidak dapat di-insert, di-update, dan dihapus melalui view vNilaiPBD, karena view vNilaiPBD hanya menampilkan data mahasiswa yang mengambil mata kuliah PBD, jika ingin menambahkan data mahasiswa yang mengambil mata kuliah PBD, maka harus menambahkan data mahasiswa tersebut pada tabel Nilai terlebih dahulu