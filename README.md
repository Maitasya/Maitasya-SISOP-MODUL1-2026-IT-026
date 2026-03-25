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
Langkah seelanjutnya yaitu membuka file menggunakan text editor, dengan  perintah  berikut:

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
Bagian ini berfungsi untuk menyiapkan dan membersihkan data awal sebelum diproses. Di mana di bagian ini program akan  menetapkan pemisah kolom CSV, mengambil nama file dan kode soal dari argumen, serta menghapus argumen yang tidak perlu agar data siap dianalisis. Dengan kata lain, bagian ini berperan sebagai proses cleaning data awal sehingga data penumpang siap digunakan untuk analisis berikutnya.

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
Bagian ini digunakan untuk menghitung jumlah seluruh penumpang KANJ. Script melewati baris pertama (yang biasanya berisi header) dan menghitung setiap baris data yang ada di file CSV. Setelah seluruh data dibaca, script menampilkan total jumlah penumpang ke layar output.

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
Bagian ini digunakan untuk menghitung jumlah gerbong unik tempat penumpang KANJ berada. Script melewati baris pertama, lalu membersihkan spasi atau karakter yang tidak perlu pada kolom gerbong agar data konsisten. Setiap gerbong yang muncul dicatat dalam array khusus, sehingga setiap gerbong hanya dihitung sekali. Setelah semua baris dibaca, script menghitung jumlah total gerbong unik dan menampilkannya ke output.

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
Lalu bagian ini digunakan untuk menemukan penumpang tertua di KANJ. Script melewati baris pertama, lalu membersihkan spasi pada kolom usia dan mengubahnya menjadi angka. Selama membaca data, script selalu membandingkan usia penumpang saat ini dengan usia tertinggi yang telah tercatat. Jika lebih tua, nama dan usia penumpang tersebut disimpan sebagai penumpang tertua. Setelah seluruh data dibaca, script menampilkan nama penumpang tertua beserta usianya ke layar output.

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
Kemudian di bagian ini digunakan untuk menghitung rata-rata usia penumpang KANJ. Script melewati baris pertama, kemudian membersihkan spasi pada kolom usia dan menambahkan setiap nilai usia ke total kumulatif. Selain itu, script juga menghitung jumlah penumpang yang valid. Setelah semua data dibaca, script menghitung rata-rata usia dengan membagi total usia dengan jumlah penumpang, membulatkannya, lalu menampilkan hasilnya ke layar output.

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
selanjutnya di bagian ini digunakan untuk menghitung jumlah penumpang kelas Business. Script melewati baris pertama, lalu memeriksa kolom kelas untuk menentukan apakah penumpang termasuk Business. Setiap penumpang yang sesuai dihitung dan disimpan ke variabel khusus. Setelah seluruh data dibaca, script menampilkan total jumlah penumpang Business Class ke layar output.

#### Jika tidak sesuai inputanya
```bash 
    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passenger.csv a"
    }
```
Dan yang bagian terakhir ini digunakan untuk menangani kondisi ketika kode yang dimasukkan tidak valid. Jika pengguna menjalankan script dengan mengetikkan argumen selain a, b, c, d, atau e, script akan menampilkan pesan peringatan beserta contoh cara penggunaan yang benar. Dengan kata lain, bagian ini berfungsi sebagai validasi input, agar pengguna tahu cara menjalankan script dengan tepat dan mencegah error saat proses analisis data.

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

Selama mengerjakan praktikum ini, saya juga memanfaatkan bantuan AI untuk membantu memahami konsep yang begitu saya belum pahami  serta menemukan letak kesalahan (error) pada program yang menyebabkan kode tidak dapat berjalan dengan lancar. Linknya sebagai berikut : https://chatgpt.com/share/69c35a6f-2f88-8324-b8bd-f5b850b8f8d2

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
Pertama membuat struktur direktori untuk menyimpan file-file ekspedisi:
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
selanjutnya membuat virtual environment Python, mengaktifkannya, dan menginstall tools `gdown` untuk mengunduh file dari Google Drive:

```bash 
sudo apt update
sudo apt install python3-pip python3-venv
python3 -m venv env
source env/bin/activate
pip install gdown
```
#### 3. Mengunduh File Peta Ekspedisi
Langkah selanjutnya mengunduh file PDF peta ekspedisi dan menyimpannya ke folder `ekspedisi` yang natinya akan digunakan pada proses eksekusi:

```bash 
gdown https://drive.google.com/uc?id=1q10pHSC3KFfvEiCN3V6PTroPR7YGHF6Q
```

#### 4. Menginstall Git dan Clone Repository Tautan Tersembunyi
Lanjut menginstall Git dan meng-clone repository untuk mendapatkan data JSON titik lokasi:

```bash 
sudo apt install git
git clone https://github.com/pocongcyber77/peta-gunung-kawi.git
cd peta-gunung-kawi
```

#### 5. Membuat Script Parser Koordinat
Langkah berikutnya yaitu membuat dan menjalankan shell script `parserkoordinat.sh` untuk mengekstrak data `id`, `site_name`, `latitude`, dan `longitude` dari file `gsxtrack.json` dan menyimpannya ke `titik-penting.txt`:

```bash 
nano parserkoordinat.sh
```
scriptnya :
```bash
#!/bin/bash

INPUT_FILE="gsxtrack.json"
OUTPUT_FILE="titik-penting.txt"

# Hapus file lama
> $OUTPUT_FILE

# Parsing data
awk '
BEGIN { FS="[:,]"; OFS=", " }
/"id"/ { gsub(/[ ]/,"",$2); id=$2 }
/site_name/ { gsub(/^[ ]+|[ ]+$/,"",$2); site_name=$2 }
/latitude/ { gsub(/[ ]/,"",$2); lat=$2 }
/longitude/ { gsub(/[ ]/,"",$2); lon=$2; print id, site_name, lat, lon >> "'">
' $INPUT_FILE

# Konfirmasi selesai
echo "Parsing selesai. Data disimpan di $OUTPUT_FILE"
```
Script ini membaca data dari file `gsxtrack.json` kemudian melakukan parsing menggunakan `awk` untuk mengambil informasi penting berupa id, site_name, latitude, dan longitude. Data yang diperoleh dibersihkan dari spasi yang tidak diperlukan agar formatnya rapi dan mudah diolah. Hasil parsing kemudian disimpan ke dalam file `titik-penting.txt` sebagai daftar titik koordinat penting.

```bash
chmod +x parserkoordinat.sh
./parserkoordinat.sh
cat titik-penting.txt
```
#### 6. Membuat dan Menjalankan Script Menentukan Titik Pusaka
Lanjutan dari proses diatas yaitu menulis shell script `nemupusaka.sh` untuk menghitung titik tengah diagonal dari koordinat dan menyimpannya ke `posisipusaka.txt`:

```bash 
nano nemupusaka.sh
```
scriptnya:
 ``` bash
#!/bin/bash

# baca koordinat dari titik-penting.txt
lat1=$(awk -F"," 'NR==1 {gsub(/ /,"",$3); print $3}' titik-penting.txt)
lon1=$(awk -F"," 'NR==1 {gsub(/ /,"",$4); print $4}' titik-penting.txt)

lat2=$(awk -F"," 'NR==3 {gsub(/ /,"",$3); print $3}' titik-penting.txt)
lon2=$(awk -F"," 'NR==3 {gsub(/ /,"",$4); print $4}' titik-penting.txt)

# hitung titik tengah menggunakan bc
mid_lat=$(echo "scale=6; ($lat1 + $lat2)/2" | bc -l)
mid_lon=$(echo "scale=6; ($lon1 + $lon2)/2" | bc -l)

# simpan ke posisipusaka.txt dengan format yang diminta
echo "Koordinat Pusaka Ditemukan:" > posisipusaka.txt
echo "Latitude: $mid_lat" >> posisipusaka.txt
echo "Longitude: $mid_lon" >> posisipusaka.txt

echo "Lokasi pusaka tersimpan di posisipusaka.txt"
```
Pada script ini dilakukan pembacaan koordinat dari file `titik-penting.txt` menggunakan `awk`, kemudian dihitung titik tengah dari dua koordinat diagonal menggunakan rumus yang telah diberikan, dan hasilnya disimpan ke dalam file `posisipusaka.txt` sebagai posisi pusaka.

```bash
chmod +x nemupusaka.sh
./nemupusaka.sh
cat posisipusaka.txt
```

### Output / Screenshot
1. File `titik-penting.txt`
<img width="1916" height="278" alt="Screenshot 2026-03-19 082809" src="https://github.com/user-attachments/assets/da7d4e05-039e-42e2-8d20-417a4209c9c6" />
   
2. File `posisipusaka.txt`
<img width="1899" height="259" alt="Screenshot 2026-03-19 082921" src="https://github.com/user-attachments/assets/c750e15f-a32e-495c-afac-d9a4f1903bca" />

   ### Kendala
- Kesulitan dalam memahami instruksi soal sehingga membutuhkan waktu lebih lama untuk menentukan langkah pengerjaan.
- Banyak terjadi error pada logika script sehingga program tidak langsung menghasilkan output yang sesuai.
- Sering terjadi typo saat menuliskan perintah di terminal yang menyebabkan command tidak dapat dijalankan.
- Pada awal pengerjaan belum memahami cara mengunduh file dari Google Drive menggunakan gdown serta cara membuat virtual environment Python.
- Parsing file JSON secara manual cukup sulit karena harus menyesuaikan format data agar dapat diolah menggunakan shell script.

Selama mengerjakan praktikum ini, saya juga memanfaatkan bantuan AI untuk membantu memahami konsep yang begitu saya belum pahami serta menemukan letak kesalahan (error) pada program yang menyebabkan kode tidak dapat berjalan dengan lancar. Linknya sebagai berikut : https://chatgpt.com/share/69c37207-c668-839e-bade-a90f7d681bc1

---
## SOAL 3 
### Deskripsi
Pada soal ini di minta untuk membuat sistem manajemen kost berbasis CLI menggunakan Bash dan AWK. Program memungkinkan pengguna menambahkan penghuni dengan validasi input, menghapus dan mengarsipkan data penghuni, menampilkan daftar penghuni rapi, memperbarui status, mencetak laporan keuangan otomatis, serta mengatur cron job pengingat tagihan. Seluruh data tersimpan terstruktur di folder data, rekap, sampah, dan log, sementara menu interaktif terus looping hingga pengguna memilih keluar, sehingga manajemen kost dapat dilakukan efisien melalui terminal.

### Struktur Repository
```bash
soal_3/
├── kost_slebew.sh          
├── data
│   └── penghuni.csv
├── log
│   └── tagihan.log
├── rekap
│   └── laporan_bulanan.txt
└── sampah
    └── history_hapus.csv
```   
### Langkah Pengerjaan
#### 1. Membuat Struktur Folder

Membuat struktur direktori untuk sistem manajemen kost:

```bash
mkdir soal_3
cd soal_3
touch kost_slebew.sh
mkdir data
touch data/penghuni.csv
mkdir log
touch log/tagihan.log
mkdir rekap
touch rekap/laporan_bulanan.txt
mkdir sampah
touch sampah/history_hapus.csv
```

Struktur ini digunakan untuk memisahkan fungsi penyimpanan data, yaitu `data` sebagai database utama, `log` untuk hasil cron job, `rekap` untuk laporan keuangan, dan `sampah` sebagai arsip data yang dihapus.

#### 2. Membuat Template Program Utama (Menu Loop)

Membuat file utama program dengan menu interaktif menggunakan looping agar program terus berjalan hingga pengguna memilih keluar.

```bash
nano kost_slebew.sh
```

Kemudian diisi dengan struktur dasar menggunakan while true dan case untuk menangani setiap pilihan menu seperti tambah penghuni, hapus, tampilkan data, update status, laporan, dan cron job.

script keseluruhan sebagai berikut:
A. Inisialisasi Variabel dan File

```bash
DATA="data/penghuni.csv"
LOG="log/tagihan.log"
REKAP="rekap/laporan_bulanan.txt"
HISTORY="sampah/history_hapus.csv"

mkdir -p data log rekap sampah
touch $DATA $LOG $REKAP $HISTORY
```
Pada bagian ini program menentukan lokasi file yang akan digunakan untuk menyimpan data penghuni, log, laporan, dan arsip. Setelah itu, program memastikan semua folder dan file tersedia agar tidak terjadi error saat pertama kali dijalankan.

B. Mode Cron (Pengecekan Tagihan)

``bash 
if [[ "$1" == "--check-tagihan" ]]; then
awk -F',' '
function rupiah(x){
    return "Rp" sprintf("%'\''d", x)
}
$5=="Menunggak" {
    printf "[%s] TAGIHAN: %s (Kamar %s Menunggak %s)\n",
    strftime("%Y-%m-%d %H:%M:%S"), $1, $2, rupiah($3)
}
' $DATA >> $LOG
exit
fi
```
Bagian ini dijalankan ketika script dipanggil oleh cron dengan parameter khusus untuk mengecek tagihan. Program akan mencari penghuni yang menunggak lalu mencatatnya ke dalam file log dengan format waktu dan nominal dalam rupiah.

C. Perulangan Menu Utama, Tampilan Header dan Menu

```bash
while true
do
clear

echo "██╗  ██╗ ██████╗ ███████╗████████╗    ███████╗██╗     ███████╗██████╗ ███████╗██╗    ██╗"
echo "██║ ██╔╝██╔═══██╗██╔════╝╚══██╔══╝    ██╔════╝██║     ██╔════╝██╔══██╗██╔════╝██║    ██║"
echo "█████╔╝ ██║   ██║███████╗   ██║       ███████╗██║     █████╗  ██████╔╝█████╗  ██║ █╗ ██║"
echo "██╔═██╗ ██║   ██║╚════██║   ██║       ╚════██║██║     ██╔══╝  ██╔══██╗██╔══╝  ██║███╗██║"
echo "██║  ██╗╚██████╔╝███████║   ██║       ███████║███████╗███████╗██████╔╝███████╗╚███╔███╔╝"
echo "╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝       ╚══════╝╚══════╝╚══════╝╚═════╝ ╚══════╝ ╚══╝╚══╝ "

echo "=================================="
echo "     SISTEM MANAJEMEN KOST SLEBEW"
echo "=================================="
echo "ID | OPTION"
echo "----------------------------------"
echo "1  | Tambah Penghuni Baru"
echo "2  | Hapus Penghuni"
echo "3  | Tampilkan Daftar Penghuni"
echo "4  | Update Status Penghuni"
echo "5  | Cetak Laporan Keuangan"
echo "6  | Kelola Cron"
echo "7  | Exit Program"
echo "=================================="
read -p "Enter option [1-7]: " opsi
```
Bagian ini digunakan untuk membuat program berjalan terus menerus menggunakan perulangan tanpa batas. Setiap kali menu selesai dijalankan, layar akan dibersihkan dan menu akan ditampilkan kembali. Program menampilkan tampilan menu utama lengkap dengan pilihan fitur yang tersedia untuk pengguna. Setelah itu, program membaca input pilihan user untuk menentukan aksi selanjutnya.

D. Percabangan Menu

```bash
case $opsi in
    1) ;;
    2) ;;
    3) ;;
    4) ;;
    5) ;;
    6) ;;
    7) exit ;;
    *) echo "Pilihan tidak valid" ;;
esac
```
Percabangan ini digunakan untuk menentukan alur program berdasarkan input yang dipilih oleh pengguna pada menu utama. Setiap angka akan menjalankan fitur tertentu seperti tambah, hapus, tampilkan data, hingga cron, sedangkan input yang tidak sesuai akan dianggap tidak valid.

E.Fitur Tambah Penghuni

```bash
echo "=================================="
echo "        TAMBAH PENGHUNI"
echo "=================================="

read -p "Masukkan nama: " nama
read -p "Masukkan kamar: " kamar
read -p "Masukkan harga sewa: " harga
read -p "Masukkan tanggal masuk (YYYY-MM-DD): " tanggal
read -p "Masukkan status awal (Aktif/Menunggak): " status

# Validasi harga
if ! [[ $harga =~ ^[0-9]+$ ]]; then
    echo "Harga harus angka!"
    read -p "Tekan ENTER..."
    continue
fi

# Validasi kamar unik
if grep -q ",$kamar," $DATA; then
    echo "Kamar sudah terisi!"
    read -p "Tekan ENTER..."
    continue
fi
# Validasi tanggal format
if ! date -d "$tanggal" "+%Y-%m-%d" >/dev/null 2>&1; then
    echo "Format tanggal salah!"
    read -p "Tekan ENTER..."
    continue
fi

# Validasi tanggal masa depan
today=$(date +%F)
if [[ "$tanggal" > "$today" ]]; then
    echo "Tanggal tidak boleh di masa depan!"
    read -p "Tekan ENTER..."
    continue
fi

# Validasi status
status=$(echo "$status" | tr '[:upper:]' '[:lower:]')
if [[ "$status" != "aktif" && "$status" != "menunggak" ]]; then
    echo "Status harus Aktif/Menunggak"
    read -p "Tekan ENTER..."
    continue
fi

status=$(echo "$status" | sed 's/.*/\u&/')
echo "$nama,$kamar,$harga,$tanggal,$status" >> $DATA

echo "[✓] penghuni \"$nama\" berhasil ditambahkan ke kamar \"$kamar\" dengan status \"$status\""
read -p "Tekan [ENTER] untuk kembali..."
;;
```
Fitur ini digunakan untuk menambahkan penghuni baru dengan meminta input berupa nama, kamar, harga sewa, tanggal masuk, dan status awal. Program kemudian melakukan berbagai validasi seperti memastikan harga berupa angka, kamar tidak duplikat, tanggal valid dan tidak di masa depan, serta status sesuai aturan sebelum akhirnya menyimpan data ke dalam file CSV.

F. Fitur Hapus Penghuni

```bash
echo "=================================="
echo "        HAPUS PENGHUNI"
echo "=================================="

read -p "Masukkan nama penghuni yang akan dihapus: " nama

data=$(grep "^$nama," $DATA)

if [ -z "$data" ]; then
    echo "Data tidak ditemukan!"
    read -p "Tekan ENTER..."
    continue
fi

tanggal=$(date +%F)

echo "$data,$tanggal" >> $HISTORY

grep -v "^$nama," $DATA > temp.csv
mv temp.csv $DATA

echo "[✔] Data penghuni \"$nama\" berhasil diarsipkan ke sampah/history_hapus.csv dan dihapus dari sistem."
read -p "Tekan [ENTER] untuk kembali..."
;;
```
Fitur ini digunakan untuk menghapus data penghuni berdasarkan nama yang diinputkan oleh pengguna. Sebelum dihapus dari database utama, data tersebut terlebih dahulu dipindahkan ke file arsip dengan tambahan tanggal penghapusan agar riwayat tetap tersimpan.

G. Fitur Tampilkan Data

```bash
echo "=================================="
echo "DAFTAR PENGHUNI KOST SLEBEW"
echo "=================================="

awk -F',' '
function rupiah(x){
    return "Rp" sprintf("%'\''d", x)
}
BEGIN {
    printf "No | Nama | Kamar | Harga Sewa | Status\n"
    print "----------------------------------------------------------------"
}
{
    printf "%d | %s | %s | %s | %s\n", NR, $1, $2, rupiah($3), $5
    if ($5=="Aktif") aktif++
    else menunggak++
}
END {
    print "----------------------------------------------------------------"
    printf "Total: %d penghuni | Aktif: %d | Menunggak: %d\n", NR, aktif, menunggak
}
' $DATA

echo "=================================="
read -p "Tekan [ENTER] untuk kembali..."
;;
```
Fitur ini digunakan untuk menampilkan seluruh data penghuni dalam bentuk tabel yang rapi dan mudah dibaca di terminal. Selain menampilkan data, program juga menghitung jumlah penghuni berdasarkan status Aktif dan Menunggak serta menampilkan totalnya di bagian akhir.

H. Fitur Update Status

```bash
echo "=================================="
echo "        UPDATE STATUS"
echo "=================================="

read -p "Masukkan Nama Penghuni: " nama
read -p "Masukkan Status Baru (Aktif/Menunggak): " status

status=$(echo "$status" | tr '[:upper:]' '[:lower:]')

if [[ "$status" != "aktif" && "$status" != "menunggak" ]]; then
    echo "Status tidak valid!"
    read -p "Tekan ENTER..."
    continue
fi

status=$(echo "$status" | sed 's/.*/\u&/')

awk -F',' -v nama="$nama" -v status="$status" '
BEGIN{OFS=","}
{
    if ($1==nama) $5=status
    print
}
' $DATA > temp.csv

mv temp.csv $DATA
echo "[✓] Status $nama berhasil diubah menjadi: $status"
read -p "Tekan [ENTER] untuk kembali..."
;;
```

Fitur ini digunakan untuk memperbarui status penghuni berdasarkan nama yang dimasukkan oleh pengguna. Program akan memvalidasi input status agar sesuai aturan, kemudian mengubah data langsung di file menggunakan AWK sehingga perubahan tersimpan dengan rapi.

I. Fitur Laporan Keuangan

```bash
echo "=================================="
echo "LAPORAN KEUANGAN KOST SLEBEW"
echo "=================================="

awk -F',' '
function rupiah(x){
    return "Rp" sprintf("%'\''d", x)
}
{
    if ($5=="Aktif") aktif+=$3
    else {
        menunggak+=$3
        list=list sprintf("- %s (Kamar %s)\n", $1, $2)
    }
    total++
}
END {
    printf "Total pemasukan (Aktif) : %s\n", rupiah(aktif)
    printf "Total tunggakan        : %s\n", rupiah(menunggak)
    printf "Jumlah kamar terisi    : %d\n", total
    print "--------------------------------------------------------------"
    if (list=="")
        print "Daftar penghuni menunggak: Tidak ada tunggakan."
    else {
        print "Daftar penghuni menunggak:"
        printf "%s", list
 }
}
' $DATA | tee $REKAP

echo "=================================="
echo "[✔] Laporan berhasil disimpan ke rekap/laporan_bulanan.txt"
read -p "Tekan [ENTER] untuk kembali..."
;;
```
Fitur ini digunakan untuk menghitung kondisi keuangan kost berdasarkan data penghuni yang tersimpan di sistem. Program akan memisahkan pemasukan dari penghuni aktif dan tunggakan dari penghuni menunggak, lalu menampilkan serta menyimpan hasil laporan ke dalam file rekap.

J. Fitur Kelola Cron

```bash
while true
do
clear
echo "=================================="
echo "MENU KELOLA CRON"
echo "=================================="
echo "1. Lihat Cron Job Aktif"
echo "2. Daftarkan Cron Job Pengingat"
echo "3. Hapus Cron Job Pengingat"
echo "4. Kembali"
echo "=================================="
read -p "Pilih [1-4]: " c

case $c in
1)
echo "___Daftar Cron Job Pengingat Tagihan___"
crontab -l 2>/dev/null | grep kost_slebew.sh
read -p "Tekan [ENTER]..."
;;

2)
read -p "Masukkan Jam (0-23): " jam
read -p "Masukkan Menit (0-59): " menit

(crontab -l 2>/dev/null | grep -v kost_slebew.sh; echo "$menit $jam * * * $(pwd)/kost_slebew.sh --check-tagihan") | cro>

echo "[✔] Cron job berhasil ditambahkan (auto replace jika ada)."
read -p "Tekan ENTER..."
;;

3)
crontab -l 2>/dev/null | grep -v kost_slebew.sh | crontab -
echo "[✔] Cron job pengingat tagihan berhasil dihapus."
read -p "Tekan ENTER..."
;;

4) break;;
*)
echo "Pilihan tidak valid"
read
;;
esac
done
;;
```
Fitur ini digunakan untuk mengelola cron job sebagai pengingat otomatis tagihan penghuni kost. Pengguna dapat melihat, menambahkan, atau menghapus jadwal cron, dan sistem akan memastikan hanya satu cron aktif dengan cara mengganti yang lama jika ditambahkan yang baru.

#### 3. Menjalankan Program

Memberikan izin eksekusi pada file dan menjalankan program:

```bash
chmod +x kost_slebew.sh
./kost_slebew.sh
```
Program kemudian akan menampilkan menu interaktif yang dapat digunakan untuk mengelola data kost secara keseluruhan.

### Output / Screenshot
1. Output Menu Utama
2. Output Tambah Penghuni
3. Output Hapus Penghuni
4. Output Tampilkan Data
5. Output Update Status
6. Output Laporan Keuangan
7. Output Kelola Cron

### Kendala
- kurang paham dalam pembuat header
- pemakaian cron job yang masih terbalik balik kodenya
- pemilihan percabangan dan looping

Selama mengerjakan praktikum ini, saya juga memanfaatkan bantuan AI hampir 60%  untuk membantu memahami konsep yang begitu belum saya pahami  serta menemukan letak kesalahan (error) pada program yang menyebabkan kode tidak dapat berjalan dengan lancar. Linknya sebagai berikut :
