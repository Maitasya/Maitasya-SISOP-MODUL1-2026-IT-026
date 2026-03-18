#!/bin/bash

DATA="data/penghuni.csv"
LOG="log/tagihan.log"
REKAP="rekap/laporan_bulanan.txt"
HISTORY="sampah/history_hapus.csv"

mkdir -p data log rekap sampah
touch $DATA $LOG $REKAP $HISTORY

# ================== MODE CRON ==================
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

# ================== MENU ==================
while true
do
clear
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

case $opsi in

# ================== 1 TAMBAH ==================
1)
clear
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

# ================== 2 HAPUS ==================
2)
clear
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

# ================== 3 TAMPIL ==================
3)
clear
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

# ================== 4 UPDATE ==================
4)
clear
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

# ================== 5 LAPORAN ==================
5)
clear
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

# ================== 6 CRON ==================
6)
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

(crontab -l 2>/dev/null | grep -v kost_slebew.sh; echo "$menit $jam * * * $(pwd)/kost_slebew.sh --check-tagihan") | crontab -

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

# ================== EXIT ==================
7)
exit
;;

*)
echo "Pilihan tidak valid"
read
;;

esac
done
