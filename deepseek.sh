#!/system/bin/sh
# ============================================================
# deepseek.sh - Terminal Asistanı v4.0
# ============================================================

VERSION="4.0"
AUTHOR="DeepSeek"

# ========== RENKLER ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# ========== DİZİNLER ==========
CONFIG_DIR="$HOME/.deepseek"
CONFIG_FILE="$CONFIG_DIR/config"

# ========== VARSYILAN AYARLAR ==========
USER_NAME="kullanici"
CURRENT_LANG="tr"

# ========== YARDIMCI FONKSİYONLAR ==========
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
    fi
}

save_config() {
    mkdir -p "$CONFIG_DIR"
    echo "USER_NAME=$USER_NAME" > "$CONFIG_FILE"
    echo "CURRENT_LANG=$CURRENT_LANG" >> "$CONFIG_FILE"
}

# ========== DİL ALGILAMA ==========
detect_lang() {
    echo "$1" | grep -q "[ğüşıöçĞÜŞİÖÇ]" && echo "tr" || echo "en"
}

# ========== KOMUT YAKALAMA ==========
get_action() {
    case "$1" in
        merhaba|selam|hello|hi) echo "greeting" ;;
        nasılsın|how*are*you) echo "how" ;;
        adın*ne|your*name) echo "ask_name" ;;
        benim*adım|my*name*is) echo "set_name" ;;
        teşekkür*|thanks) echo "thanks" ;;
        yardım|help) echo "help" ;;
        çalıştır|run) echo "cmd" ;;
        çık|exit|quit) echo "exit" ;;
        *) echo "unknown" ;;
    esac
}

extract_name() {
    echo "$1" | sed -E 's/^(benim adım|my name is)[[:space:]]+//i' | head -1
}

extract_cmd() {
    echo "$1" | sed -E 's/^(çalıştır|run)[[:space:]]+//i'
}

# ========== CEVAP ÜRET (REİS YOK) ==========
get_response() {
    lang="$1"
    action="$2"
    input="$3"
    
    case "$action" in
        greeting)
            if [ "$lang" = "tr" ]; then
                echo "Merhaba $USER_NAME! Ben DeepSeek. Sana nasıl yardımcı olabilirim?"
            else
                echo "Hello $USER_NAME! I'm DeepSeek. How can I help you?"
            fi
            ;;
        how)
            if [ "$lang" = "tr" ]; then
                echo "İyiyim, teşekkür ederim. Sen nasılsın?"
            else
                echo "I'm good, thank you. How are you?"
            fi
            ;;
        ask_name)
            if [ "$lang" = "tr" ]; then
                echo "Ben DeepSeek, terminal asistanın. Senin adın ne?"
            else
                echo "I'm DeepSeek, your terminal assistant. What's your name?"
            fi
            ;;
        set_name)
            new_name=$(extract_name "$input")
            if [ -n "$new_name" ]; then
                USER_NAME="$new_name"
                save_config
                if [ "$lang" = "tr" ]; then
                    echo "Tamam $USER_NAME! Adını hatırlayacağım."
                else
                    echo "Okay $USER_NAME! I'll remember your name."
                fi
            else
                if [ "$lang" = "tr" ]; then
                    echo "Adını 'benim adım X' diyerek söyleyebilirsin."
                else
                    echo "You can tell me your name by saying 'my name is X'."
                fi
            fi
            ;;
        thanks)
            if [ "$lang" = "tr" ]; then
                echo "Rica ederim $USER_NAME! Ne zaman ihtiyacın olursa buradayım."
            else
                echo "You're welcome $USER_NAME! I'm always here for you."
            fi
            ;;
        help)
            if [ "$lang" = "tr" ]; then
                echo "
${YELLOW}══════════════════════════════════════════════════════${NC}
${GREEN}DeepSeek Komutları${NC}
${YELLOW}══════════════════════════════════════════════════════${NC}
${CYAN}• merhaba / selam${NC}      - Selamlaşma
${CYAN}• nasılsın${NC}             - Durum sorma
${CYAN}• adın ne${NC}              - Beni tanı
${CYAN}• benim adım X${NC}         - Adını söyle
${CYAN}• çalıştır X${NC}           - Komut çalıştır
${CYAN}• teşekkürler${NC}          - Teşekkür et
${CYAN}• yardım${NC}               - Bu menü
${CYAN}• çık / exit${NC}           - Çıkış
${YELLOW}══════════════════════════════════════════════════════${NC}"
            else
                echo "
${YELLOW}══════════════════════════════════════════════════════${NC}
${GREEN}DeepSeek Commands${NC}
${YELLOW}══════════════════════════════════════════════════════${NC}
${CYAN}• hello / hi${NC}           - Greeting
${CYAN}• how are you${NC}          - Ask status
${CYAN}• your name${NC}            - Who am I
${CYAN}• my name is X${NC}         - Tell your name
${CYAN}• run X${NC}                - Run command
${CYAN}• thanks${NC}               - Show gratitude
${CYAN}• help${NC}                 - This menu
${CYAN}• exit / quit${NC}          - Exit
${YELLOW}══════════════════════════════════════════════════════${NC}"
            fi
            ;;
        cmd)
            cmd=$(extract_cmd "$input")
            if [ -n "$cmd" ]; then
                if [ "$lang" = "tr" ]; then
                    echo "Komut çalıştırılıyor: $cmd"
                else
                    echo "Running command: $cmd"
                fi
                echo ""
                eval "$cmd" 2>&1
            else
                if [ "$lang" = "tr" ]; then
                    echo "Ne çalıştırmamı istersin? Örnek: çalıştır ls -la"
                else
                    echo "What command should I run? Example: run ls -la"
                fi
            fi
            ;;
        exit)
            if [ "$lang" = "tr" ]; then
                echo "Görüşürüz $USER_NAME! Yine beklerim. 👋"
            else
                echo "Goodbye $USER_NAME! See you later. 👋"
            fi
            exit 0
            ;;
        unknown)
            if [ "$lang" = "tr" ]; then
                echo "Anlamadım $USER_NAME. Biraz daha açar mısın?"
            else
                echo "I didn't understand $USER_NAME. Can you explain?"
            fi
            ;;
    esac
}

# ========== BAŞLANGIÇ EKRANI ==========
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                    DEEPSEEK - TERMINAL                    ║"
    echo "║                           v$VERSION                          ║"
    echo "║                 Terminal Yapay Zeka Asistanı              ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${GREEN}DeepSeek${NC} - Sana yardım etmek için buradayım $USER_NAME!"
    echo -e "${YELLOW}Türkçe, English${NC}"
    echo -e "${GRAY}İpucu: 'yardım' yazarak komutları görebilirsin${NC}"
    echo -e "${GRAY}İpucu: 'çık' yazarak programdan çıkabilirsin${NC}"
    echo ""
}

# ========== ANA DÖNGÜ ==========
main() {
    load_config
    show_banner
    
    # İlk selam
    first_greeting=$(get_response "tr" "greeting" "")
    echo -e "${GREEN}DeepSeek${NC}: $first_greeting"
    echo ""
    
    while true; do
        echo -n -e "${CYAN}deepseek@ai${NC}:${YELLOW}~${NC}${WHITE}$ ${NC}"
        read -r user_input
        
        [ -z "$user_input" ] && continue
        
        lang=$(detect_lang "$user_input")
        action=$(get_action "$user_input")
        response=$(get_response "$lang" "$action" "$user_input")
        
        echo -e "${GREEN}DeepSeek${NC}: $response"
        echo ""
    done
}

main "$@"
