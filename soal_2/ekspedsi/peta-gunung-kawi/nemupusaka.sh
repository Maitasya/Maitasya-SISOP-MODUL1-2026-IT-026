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
