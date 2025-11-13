#!/bin/bash

# ================================================
#   SHC SUPER ENCRYPTION PRO v2 (By Rama Version)
#   SHC + STRIP + CHMOD + IMMUTABLE + AUTOUPDATE
#   Premium UI + Telegram Notification
# ================================================

# Warna
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
MAGENTA="\e[35m"
NC="\e[0m"

# Versi lokal tools
LOCAL_VERSION="2.0"

# ==== TELEGRAM NOTIFICATION ====
TG_TOKEN="8178123942:AAGZaNxo-8HajTk7LIM3rVn_N_0zTq7LNBM"
TG_CHATID="6403937911"

send_tele() {
    TEXT="$1"
    curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
        -d chat_id="${TG_CHATID}" \
        -d text="${TEXT}" \
        -d parse_mode="HTML" >/dev/null 2>&1
}

# Ganti dengan repo kamu sendiri
UPDATE_URL="https://raw.githubusercontent.com/nexus-bot-dev/encnexus/main/enc-pro.sh"
CHECKSUM_URL="https://raw.githubusercontent.com/nexus-bot-dev/encnexus/main/enc-pro.sha256"
VERSION_URL="https://raw.githubusercontent.com/nexus-bot-dev/encnexus/main/version.txt"

# ================================================
# HEADER
# ================================================
header() {
    clear
    echo -e "${BLUE}======================================================="
    echo -e "       SHC SUPER ENCRYPTION TOOLS PRO v${LOCAL_VERSION}"
    echo -e "            Premium Style by RAMA Edition"
    echo -e "=======================================================${NC}"
    echo ""
}

# ================================================
# LOADING ANIMATION
# ================================================
loading() {
    echo -ne "${MAGENTA}"
    for i in {1..30}; do
        echo -ne "▉"
        sleep 0.03
    done
    echo -e "${NC}"
}

# ================================================
# BEAUTIFUL SUCCESS VIEW
# ================================================
rama_view() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║                     \e[92mENCRYPT SUCCESS\e[36m                    ║"
    echo "╠══════════════════════════════════════════════════════╣"
    echo -e "║ Script berhasil diamankan dengan teknologi premium:   ║"
    echo -e "║   \e[92m✔\e[36m SHC Encryption                                      ║"
    echo -e "║   \e[92m✔\e[36m Binary Stripped (Anti Reverse Engineering)           ║"
    echo -e "║   \e[92m✔\e[36m Permission Locked (Mode 700)                          ║"
    echo -e "║   \e[92m✔\e[36m Immutable ON (Anti Delete / Anti Modify)              ║"
    echo "╠══════════════════════════════════════════════════════╣"
    echo -e "║ Nama Asli     : \e[93m$1\e[36m"
    echo -e "║ Output Binary : \e[93m$2\e[36m"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ================================================
# AUTO UPDATE SYSTEM
# ================================================
update_tools() {
    header
    echo -e "${YELLOW}[+] Mengecek versi terbaru...${NC}"

    LATEST_VERSION=$(curl -s "$VERSION_URL")

    if [[ -z "$LATEST_VERSION" ]]; then
        echo -e "${RED}Gagal mengecek update.${NC}"
        sleep 2
        menu
        return
    fi

    if [[ "$LATEST_VERSION" == "$LOCAL_VERSION" ]]; then
        echo -e "${GREEN}Tools sudah versi terbaru.${NC}"
        sleep 2
        menu
        return
    fi

    echo -e "${BLUE}[+] Ditemukan update versi $LATEST_VERSION${NC}"
    echo -e "${YELLOW}[+] Mengunduh update...${NC}"

    wget -q -O enc-pro.sh.new "$UPDATE_URL"
    wget -q -O enc-pro.sha256 "$CHECKSUM_URL"

    if [[ ! -f enc-pro.sh.new ]]; then
        echo -e "${RED}Gagal mendownload update.${NC}"
        sleep 2
        menu
        return
    fi

    echo -e "${YELLOW}[+] Verifikasi checksum...${NC}"

    sha256sum -c enc-pro.sha256 &>/dev/null
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Checksum tidak valid! Update dibatalkan.${NC}"
        rm -f enc-pro.sh.new enc-pro.sha256
        sleep 2
        menu
        return
    fi

    mv enc-pro.sh.new enc-pro.sh
    chmod +x enc-pro.sh

    echo -e "${GREEN}Update berhasil! Restart tools...${NC}"
    sleep 1
    ./enc-pro.sh
    exit
}

# ================================================
# ENCRYPT FILE (.sh)
# ================================================
encrypt_file() {
    header
    echo -e "${YELLOW}Masukkan nama file script (.sh) yang ingin dienkripsi:${NC}"
    read -p "File: " FILE

    if [[ ! -f "$FILE" ]]; then
        echo -e "${RED}File tidak ditemukan!${NC}"
        sleep 2
        encrypt_file
        return
    fi

    if ! command -v shc >/dev/null; then
        echo -e "${YELLOW}SHC belum terinstall. Menginstall...${NC}"
        apt update && apt install shc -y
    fi

    NAME=$(basename "$FILE" .sh)
    OUTPUT="$NAME"

    echo -e "${BLUE}[1] Enkripsi SHC...${NC}"
    shc -f "$FILE" -o "$OUTPUT"

    echo -e "${BLUE}[2] Strip binary...${NC}"
    strip "$OUTPUT"

    echo -e "${BLUE}[3] Set permission 700...${NC}"
    chmod 700 "$OUTPUT"

    echo -e "${BLUE}[4] Mengaktifkan immutable...${NC}"
    chattr +i "$OUTPUT"

    # =============== SEND TELEGRAM NOTIFICATION ================
    send_tele "<b>🔥 ENCRYPT BERHASIL</b>%0AFile Asli: <code>$FILE</code>%0AOutput: <code>$OUTPUT</code>%0AWaktu: <b>$(date '+%Y-%m-%d %H:%M:%S')</b>"

    loading
    rama_view "$FILE" "$OUTPUT"

    echo ""
    read -p "Tekan ENTER untuk kembali..."
    menu
}

# ================================================
# LIST FILE
# ================================================
list_files() {
    header
    echo -e "${GREEN}Daftar file .sh di folder ini:${NC}"
    echo ""

    ls -1 *.sh 2>/dev/null || echo -e "${RED}Tidak ada file .sh ditemukan.${NC}"

    echo ""
    read -p "Tekan ENTER untuk kembali..."
    menu
}

# ================================================
# HELP GUIDE
# ================================================
how_to_use() {
    header
    echo -e "${YELLOW}Cara Menggunakan Encryptor PRO:${NC}"
    echo ""
    echo -e "1. Simpan file script kamu, contoh: ${GREEN}setup.sh${NC}"
    echo -e "2. Jalankan tools: ${GREEN}./enc-pro.sh${NC}"
    echo -e "3. Pilih menu: ${GREEN}Encrypt file (.sh)${NC}"
    echo -e "4. Tools akan melakukan:"
    echo -e "   - SHC Encryption"
    echo -e "   - Strip binary"
    echo -e "   - chmod 700"
    echo -e "   - Immutable ON"
    echo ""
    echo -e "${YELLOW}Menjalankan file terenkripsi:${NC}"
    echo -e "  ${GREEN}./nama_file${NC}"
    echo ""
    echo -e "${RED}Unlock immutable (jika mau edit/hapus):${NC}"
    echo -e "  ${GREEN}chattr -i nama_file${NC}"
    echo ""

    read -p "Tekan ENTER untuk kembali..."
    menu
}

# ================================================
# MENU UTAMA
# ================================================
menu() {
    header
    echo -e "${YELLOW}Pilih menu:${NC}"
    echo ""
    echo "1) Encrypt file (.sh)"
    echo "2) Lihat semua file .sh"
    echo "3) Cara menggunakan"
    echo "4) Update tools"
    echo "0) Exit"
    echo ""
    read -p "Pilih: " opt

    case $opt in
        1) encrypt_file ;;
        2) list_files ;;
        3) how_to_use ;;
        4) update_tools ;;
        0) exit ;;
        *) echo -e "${RED}Pilihan salah!${NC}"; sleep 1; menu ;;
    esac
}

menu
