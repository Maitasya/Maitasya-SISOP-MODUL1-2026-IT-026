#!/usr/bin/awk -f
# Program untuk menganalisis data penumpang KANJ

BEGIN {
    FS = ","
    file = ARGV[1]
    soal = ARGV[2]
    delete ARGV[2]
}

# soal a Hitung jumlah penumpang
soal == "a" {
    if (NR > 1) count_passenger++
}

# soal b Hitung jumlah gerbong unik
soal == "b" {
    if (NR>1) {
        gsub(/[ \r]/,"",$4)
        gerbong[$4]++
    }
}

# soal c Hitung Penumpang tertua
soal == "c" {
    if (NR > 1) {
        gsub(/ /,"",$2)
        age = $2 + 0
        if (age > max_age || NR==2) {
            max_age = age
            oldest = $1
        }
    }
}

# soal d Rata-rata usia
soal == "d" {
    if (NR > 1) {
        gsub(/ /,"",$2)
        total_usia += $2
        total_passenger++
    }
}

# soal e Jumlah penumpang Business Class
soal == "e" {
    if (NR > 1) {
        if ($3 == "Business") business_passenger++
    }
}

END { 
    if (soal == "a") {
        print "Jumlah seluruh penumpang KANJ adalah " count_passenger " orang"
    }
    else if (soal == "b") {
        carriage = 0
        for (g in gerbong) carriage++
        print "Jumlah gerbong penumpang KANJ adalah " carriage
    }
    else if (soal == "c") {
        print oldest " adalah penumpang kereta tertua dengan usia " max_age " tahun"
    }
    else if (soal == "d") {
        average_age = int(total_usia / total_passenger + 0,5) #dibulatin aja ke atas
        printf "Rata-rata usia penumpang adalah" average_age "tahun"
    }
    else if (soal == "e") {
        print "Jumlah penumpang business class ada " business_passenger " orang"
    }
    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f KANJ.sh passenger.csv a"
    }
}
