# Maitasya-SISOP-MODUL1-2026-IT-026
---
#### Nama : Maitasya Rohmatul Ula
#### NRP  : 5027251026
#### SISOP A
---
## SOAL 1
### Deskripsi

Program ini dibuat untuk menganalisis data penumpang kereta KANJ yang tersimpan dalam file passenger.csv menggunakan awk. Program dapat menghitung jumlah penumpang, jumlah gerbong, penumpang tertua, rata-rata usia, dan jumlah penumpang business class.

### Struktur Repository

```bash
soal_1                                  
    ├── KANJ.sh                                
    └── passenger.csv
```

### Langkah Pengerjaan
#### 1. Membuat Struktur Folder

Pertama, membuat struktur direktori sesuai ketentuan soal, dengan  perintah  berikut:

        mkdir soal_1  
        cd soal_1

#### 2. Menyiapkan File

Menambahkan file yang dibutuhkan:
- KANJ.sh → digunakan sebagai file yang menampung script awk
- passenger.csv → digunakan sebagai file yang menampung data penumpang
        
dengan perintah berikut:                         

        touch KANJ.sh  (di sini masih beruba file kosong)    
        touch passenger.csv

#### 3. Mengunduh File Data Penumpang
Pada tahap ini, dilakukan proses pengunduhan file data penumpang yang akan digunakan sebagai bahan pengolahan pada script. 

Perintah yang digunakan adalah sebagai berikut:

    wget -O passenger.csv "https://docs.google.com/spreadsheets/d 1NHmyS6wRO7To7ta-NLOOLHkPS6valvNaX7tawsv1zfE/export?format=csv"

Setelah file passenger.csv berhasil diunduh, langkah selanjutnya adalah memastikan isi file tersebut telah terunduh dengan benar serta melihat struktur data yang terdapat di dalamnya, dengan menggunakan perintah:

    cat passenger.csv 

#### 4. Menulis Script Awk
Membuka file menggunakan text editor, dengan  perintah  berikut:
            nano KANJ.sh 

        Kemudian menuliskan logika program menggunakan awk untuk:
#### Awalan 
---
```bash
    #!/usr/bin/awk -f
    # Program untuk menganalisis data penumpang KANJ

    BEGIN {
    FS = ","
    file = ARGV[1]
    soal = ARGV[2]
    delete ARGV[2]
    }
```
Bagian ini berfungsi untuk menyiapkan dan membersihkan data awal sebelum diproses. Script menetapkan pemisah kolom CSV, mengambil nama file dan kode soal dari argumen, serta menghapus argumen yang tidak perlu agar data siap dianalisis. Dengan kata lain, bagian ini berperan sebagai proses cleaning data awal sehingga data penumpang siap digunakan untuk analisis berikutnya.


#### Berikut full scriptnya:
---
```bash
# soal a: Hitung jumlah penumpang
soal == "a" {
    if (NR > 1) count_passenger++
}

# soal b: Hitung jumlah gerbong unik
soal == "b" {
    if (NR > 1) {
        gsub(/[ \r]/, "", $4)
        gerbong[$4]++
    }
}

# soal c: Hitung penumpang tertua
soal == "c" {
    if (NR > 1) {
        gsub(/ /, "", $2)
        age = $2 + 0
        if (age > max_age || NR == 2) {
            max_age = age
            oldest = $1
        }
    }
}

# soal d: Rata-rata usia penumpang
soal == "d" {
    if (NR > 1) {
        gsub(/ /, "", $2)
        total_usia += $2
        total_passenger++
    }
}

# soal e: Jumlah penumpang Business Class
soal == "e" {
    if (NR > 1 && $3 == "Business") business_passenger++
}

END {
    if (soal == "a") {
        printf "Jumlah seluruh penumpang KANJ adalah %d orang\n", count_passenger
    }
    else if (soal == "b") {
        carriage = 0
        for (g in gerbong) carriage++
        printf "Jumlah gerbong penumpang KANJ adalah %d\n", carriage
    }
    else if (soal == "c") {
        printf "%s adalah penumpang kereta tertua dengan usia %d tahun\n", oldest, max_age
    }
    else if (soal == "d") {
        average_age = int((total_usia / total_passenger) + 0.5)
        printf "Rata-rata usia penumpang adalah %d tahun\n", average_age
    }
    else if (soal == "e") {
        printf "Jumlah penumpang business class ada %d orang\n", business_passenger
    }
    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passenger.csv a"
    }
}
```
ket: 
    
    - BEGIN: Dijalankan sebelum membaca file untuk menyiapkan variabel dan membersihkan argumen agar data siap diproses.

    - END: Dijalankan setelah membaca seluruh file untuk menampilkan hasil akhir analisis, misalnya jumlah penumpang, gerbong unik, atau penumpang tertua.
### Penjelasan
---
#### A. Menghitung jumlah penumpang
```bash
# soal a Hitung jumlah penumpang 
    soal == "a" 
        { if (NR > 1) count_passenger++ } 
     if (soal == "a") 
        { print "Jumlah seluruh penumpang KANJ adalah " count_passenger " orang" }
```
Bagian ini digunakan untuk menghitung jumlah seluruh penumpang KANJ. Script melewati baris pertama (yang biasanya berisi header) dan menghitung setiap baris data yang ada di file CSV. Setelah seluruh data dibaca, script menampilkan total jumlah penumpang ke layar.

#### B. Menghitung jumlah gerbong
```bash
    # soal b: Hitung jumlah gerbong unik
    soal == "b" {
        if (NR > 1) {
            gsub(/[ \r]/, "", $4)
            gerbong[$4]++
        }
    }
     else if (soal == "b") {
        carriage = 0
        for (g in gerbong) carriage++
        printf "Jumlah gerbong penumpang KANJ adalah %d\n", carriage
    }
```
Bagian ini digunakan untuk menghitung jumlah gerbong unik tempat penumpang KANJ berada. Script melewati baris pertama, lalu membersihkan spasi atau karakter yang tidak perlu pada kolom gerbong agar data konsisten. Setiap gerbong yang muncul dicatat dalam array khusus, sehingga setiap gerbong hanya dihitung sekali. Setelah semua baris dibaca, script menghitung jumlah total gerbong unik dan menampilkannya ke layar.

#### C. Mencari nama dan usia penumpang tertua
```bash
# soal c: Hitung penumpang tertua
    soal == "c" {
        if (NR > 1) {
            gsub(/ /, "", $2)
            age = $2 + 0
            if (age > max_age || NR == 2) {
                max_age = age
                oldest = $1
            }
        }
    }
    else if (soal == "c") {
        printf "%s adalah penumpang kereta tertua dengan usia %d tahun\n", oldest, max_age
    }
```
Lalu bagian ini digunakan untuk menemukan penumpang tertua di KANJ. Script melewati baris pertama, lalu membersihkan spasi pada kolom usia dan mengubahnya menjadi angka. Selama membaca data, script selalu membandingkan usia penumpang saat ini dengan usia tertinggi yang telah tercatat. Jika lebih tua, nama dan usia penumpang tersebut disimpan sebagai penumpang tertua. Setelah seluruh data dibaca, script menampilkan nama penumpang tertua beserta usianya.

#### D. Menghitung rata-rata usia penumpang
```bash
# soal d: Rata-rata usia penumpang
    soal == "d" {
        if (NR > 1) {
            gsub(/ /, "", $2)
            total_usia += $2
            total_passenger++
        }
    }
    else if (soal == "d") {
        average_age = int((total_usia / total_passenger) + 0.5)
        printf "Rata-rata usia penumpang adalah %d tahun\n", average_age
    }
```
Kemudian di bagian ini digunakan untuk menghitung rata-rata usia penumpang KANJ. Script melewati baris pertama, kemudian membersihkan spasi pada kolom usia dan menambahkan setiap nilai usia ke total kumulatif. Selain itu, script juga menghitung jumlah penumpang yang valid. Setelah semua data dibaca, script menghitung rata-rata usia dengan membagi total usia dengan jumlah penumpang, membulatkannya, lalu menampilkan hasilnya ke layar.

#### E. Menghitung Jumlah penumpang Business Class
```bash
# soal e: Jumlah penumpang Business Class
    soal == "e" {
        if (NR > 1 && $3 == "Business") business_passenger++
}
    else if (soal == "e") {
        printf "Jumlah penumpang business class ada %d orang\n", business_passenger
    }
```
selanjutnya di bagian ini digunakan untuk menghitung jumlah penumpang kelas Business. Script melewati baris pertama, lalu memeriksa kolom kelas untuk menentukan apakah penumpang termasuk Business. Setiap penumpang yang sesuai dihitung dan disimpan ke variabel khusus. Setelah seluruh data dibaca, script menampilkan total jumlah penumpang Business Class ke layar.

#### Jika tidak sesuai inputanya
```bash 
    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passenger.csv a"
    }
```
Dan yang bagian terakhir ini digunakan untuk menangani kondisi ketika kode yang dimasukkan tidak valid. Jika pengguna menjalankan script dengan argumen selain a, b, c, d, atau e, script akan menampilkan pesan peringatan beserta contoh cara penggunaan yang benar. Dengan kata lain, bagian ini berfungsi sebagai validasi input, agar pengguna tahu cara menjalankan script dengan tepat dan mencegah error saat proses analisis data.

#### Menjalankan script KANJ.sh
dengan perintah berikut:

Hitung jumlah penumpang

```bash 
awk -f KANJ.sh passenger.csv a
```
Hitung jumlah gerbong

```bash
awk -f KANJ.sh passenger.csv b
```
Cari penumpang tertua

```bash 
awk -f KANJ.sh passenger.csv c
```
Hitung rata-rata usia

```bash 
awk -f KANJ.sh passenger.csv d
```
Hitung jumlah penumpang Business Class

```bash 
awk -f KANJ.sh passenger.csv e
```
Dengan cara ini, script akan membaca file data sesuai kode soal yang diberikan dan menampilkan hasil analisis langsung ke terminal.

### Output / Screenshot
1. Total penumpang
<img width="1731" height="229" alt="Screenshot 2026-03-18 193453" src="https://github.com/user-attachments/assets/d33e1682-8f42-444e-9b3a-5530b7b61c93" />

2. Jumlah gerbong
<img width="1700" height="124" alt="Screenshot 2026-03-18 193515" src="https://github.com/user-attachments/assets/26ef94af-87ae-42ba-b1f2-b8d071e43b56" />

3. Penumpang tertua
<img width="1713" height="122" alt="Screenshot 2026-03-18 193536" src="https://github.com/user-attachments/assets/3dc6704f-e627-4904-bc69-a47b59e4f7aa" />

4. Rata-rata usia penumpang
<img width="1733" height="160" alt="Screenshot 2026-03-18 193705" src="https://github.com/user-attachments/assets/6e3b0438-acce-47d0-9faa-1ac26f235dbb" />

5. Jumlah penumpang Business Class
<img width="1723" height="111" alt="Screenshot 2026-03-18 193724" src="https://github.com/user-attachments/assets/0a27bcb7-73ed-44f6-81bd-b27db936ac7b" />

6. Input selain a/b/c/d/e (error handler)
<img width="1710" height="158" alt="Screenshot 2026-03-18 194258" src="https://github.com/user-attachments/assets/2b1c9ab1-a7b8-4f23-ab92-336cf5a74988" />

### Kendala
Banyak sekali error di logika berikut adalah buktinya:
<img width="978" height="633" alt="image" src="https://github.com/user-attachments/assets/4865d733-e5e6-4a83-85af-846c036d0c05" />
- Salah menggunakan struktur percabangan karena kemarin abis baca modul bagian shell scripting (bash).
- Perhitungan gerbong unik tidak akurat karena data belum dibersihkan sepenuhnya (spasi atau karakter tersembunyi masih terbaca sebagai data berbeda).
- Nilai umur tidak terbaca dengan benar akibat kesalahan parsing kolom atau belum dilakukan konversi ke numerik.
- Kesalahan dalam pengambilan field menyebabkan seluruh baris terbaca sebagai satu variabel.
- Perubahan kode belum konsisten atau belum menyentuh bagian inti permasalahan (logika utama masih salah).
---

## SOAL 2
### Deskripsi
Pada soal ini dilakukan proses pencarian lokasi pusaka dengan mengunduh file peta, menemukan tautan tersembunyi, dan melakukan clone repository untuk mendapatkan data koordinat dalam file JSON. Data tersebut kemudian diparsing menggunakan shell script parserkoordinat.sh untuk mengambil informasi penting seperti id, nama lokasi, latitude, dan longitude ke dalam file terstruktur. Selanjutnya, posisi pusaka ditentukan dengan menghitung titik tengah dari dua koordinat diagonal menggunakan script nemupusaka.sh dan hasilnya disimpan dalam file posisipusaka.txt.

### Struktur Repository
```bash 
soal_2
└── ekspedsi
       ├── peta-ekspedisi-amba.pdf
       └── peta-gunung-kawi
           ├── gsxtrack.json
           ├── parserkoordinat.sh 
           ├── nemupusaka.sh
           ├── titik-penting.txt
           └── posisipusaka.txt
```

### Langkah Pengerjaan
#### 1. Membuat Struktur Folder
Membuat struktur direktori untuk menyimpan file-file ekspedisi:
```bash 
mkdir soal_2
cd soal_2
mkdir ekspedsi
cd ekspedsi
mkdir peta-gunung-kawi
cd peta-gunung-kawi
touch gsxtrack.json
touch parserkoordinat.sh
touch nemupusaka.sh
touch titik-penting.txt
touch posisipusaka.txt
```
#### 2. Menyiapkan Environment dan Tools
Membuat virtual environment Python, mengaktifkannya, dan menginstall tools `gdown` untuk mengunduh file dari Google Drive:
```bash 
sudo apt update
sudo apt install python3-pip python3-venv
python3 -m venv env
source env/bin/activate
pip install gdown
```
#### 3. Mengunduh File Peta Ekspedisi
Mengunduh file PDF peta ekspedisi dan menyimpannya ke folder `ekspedisi`:
```bash 
gdown https://drive.google.com/uc?id=1q10pHSC3KFfvEiCN3V6PTroPR7YGHF6Q
```

#### 4. Menginstall Git dan Clone Repository Tautan Tersembunyi
Menginstall Git dan meng-clone repository untuk mendapatkan data JSON titik lokasi:
```bash 
sudo apt install git
git clone https://github.com/pocongcyber77/peta-gunung-kawi.git
cd peta-gunung-kawi
```

#### 5. Membuat Script Parser Koordinat
Membuat dan menjalankan shell script `parserkoordinat.sh` untuk mengekstrak data `id`, `site_name`, `latitude`, dan `longitude` dari file `gsxtrack.json` dan menyimpannya ke `titik-penting.txt`:
```bash 
nano parserkoordinat.sh   # menulis script
chmod +x parserkoordinat.sh
./parserkoordinat.sh
cat titik-penting.txt
```
#### 6. Membuat dan Menjalankan Script Menentukan Titik Pusaka
Menulis shell script `nemupusaka.sh` untuk menghitung titik tengah diagonal dari koordinat dan menyimpannya ke `posisipusaka.txt`:
```bash 
nano nemupusaka.sh        
chmod +x nemupusaka.sh
./nemupusaka.sh
cat posisipusaka.txt
```
