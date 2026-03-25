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
/longitude/ { gsub(/[ ]/,"",$2); lon=$2; print id, site_name, lat, lon >> "'"$OUTPUT_FILE"'" }
' $INPUT_FILE

# Konfirmasi selesai
echo "Parsing selesai. Data disimpan di $OUTPUT_FILE"
