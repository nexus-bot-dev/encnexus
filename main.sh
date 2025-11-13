#!/bin/bash
# ======================================================
#        AUTO INSTALLER – SUPER ENCRYPTER PRO
#            Developer: Nexus (@AutoVPN_VIP)
#            RAMA x NEXUS Premium Edition
# ======================================================

RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[36m"; NC="\e[0m"

# URL FILE TOOLS
ENC_URL="https://raw.githubusercontent.com/nexus-bot-dev/encnexus/main/enc-pro.sh"

# ======================================================
# HACKER LOGO
# ======================================================
hacker_logo() {
clear
echo -e "${GREEN}"
cat << "EOF"
        ██████╗ ██╗  ██╗███████╗██╗  ██╗███████╗
        ██╔══██╗██║  ██║██╔════╝██║  ██║██╔════╝
        ██████╔╝███████║█████╗  ███████║█████╗  
        ██╔══██╗██╔══██║██╔══╝  ██╔══██║██╔══╝  
        ██║  ██║██║  ██║███████╗██║  ██║███████╗
        ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝

        ★ NEXUS DEVELOPMENT TEAM ★
            Telegram: @AutoVPN_VIP
EOF
echo -e "${NC}"
}

# ======================================================
# INSTALL DEPENDENCIES
# ======================================================
install_dep() {
    hacker_logo
    echo -e "${YELLOW}>>> Menginstall dependensi wajib...${NC}"
    sleep 1

    apt update -y
    apt install -y curl wget git make gcc binutils e2fsprogs

    if ! command -v shc &>/dev/null; then
        echo -e "${BLUE}SHC tidak ditemukan, menginstall dari source...${NC}"
        git clone https://github.com/neurobin/shc.git
        cd shc
        ./configure
        make
        make install
        cd ..
        rm -rf shc
    else
        echo -e "${GREEN}SHC sudah terpasang.${NC}"
    fi

    echo -e "${GREEN}>>> Semua dependensi terinstall!${NC}"
    sleep 1
}

# ======================================================
# DOWNLOAD TOOLS ENCRYPTOR
# ======================================================
install_tool() {
    hacker_logo
    echo -e "${BLUE}>>> Mendownload tools ENCRYPTOR PRO...${NC}"

    wget -q -O enc-pro.sh "$ENC_URL"

    if [[ ! -f enc-pro.sh ]]; then
        echo -e "${RED}GAGAL: Tidak dapat mendownload enc-pro.sh${NC}"
        exit 1
    fi

    chmod +x enc-pro.sh

    echo -e "${GREEN}>>> Tools berhasil diinstall!${NC}"
    sleep 1
}

# ======================================================
# MENU UTAMA INSTALLER
# ======================================================
main_menu() {
    while true; do
        hacker_logo
        echo -e "${YELLOW}============== INSTALLER MENU ==============${NC}"
        echo -e "${GREEN}[1] Install Dependensi"
        echo -e "[2] Install Encryptor Tools"
        echo -e "[3] Jalankan Encryptor"
        echo -e "[4] Info Developer"
        echo -e "[0] Exit${NC}"
        echo ""
        read -p "Pilih menu: " m

        case $m in
            1) install_dep ;;
            2) install_tool ;;
            3) ./enc-pro.sh ;;
            4) show_dev ;;
            0) exit ;;
            *) echo -e "${RED}Pilihan salah!${NC}" ; sleep 1 ;;
        esac
    done
}

# ======================================================
# INFO DEVELOPER
# ======================================================
show_dev() {
    hacker_logo
    echo -e "${GREEN}Developer: Nexus"
    echo -e "Telegram: @AutoVPN_VIP"
    echo -e "Tools: Super Encrypter Pro (RAMA x Nexus Edition)"
    echo -e "${NC}"
    read -p "ENTER untuk kembali..."
}

main_menu
