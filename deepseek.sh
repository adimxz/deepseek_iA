#!/system/bin/sh
# ============================================================
# deepseek.sh - Terminal Yapay Zeka Asistanı v1.0
# ============================================================
# Bu script terminalde çalışan, çok dilli, hafızalı,
# duygusal bir yapay zeka asistanıdır.
# ============================================================
# Tasarım: Reis
# İsim: DeepSeek (AI'dan ilham alınmıştır)
# ============================================================

VERSION="1.0"
AUTHOR="Reis"
PROJECT_NAME="DeepSeek-Terminal"

# ========== RENK TANIMLARI ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
LIGHT_CYAN='\033[1;36m'
LIGHT_PURPLE='\033[1;35m'
NC='\033[0m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'

# ========== DİZİN TANIMLARI ==========
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
WORK_DIR="/data/data/com.termux/files/home/.deepseek"
LANG_DIR="$SCRIPT_DIR/languages"
CORE_DIR="$SCRIPT_DIR/core"
DATA_DIR="$SCRIPT_DIR/data"
LOG_FILE="$DATA_DIR/deepseek.log"
MEMORY_FILE="$DATA_DIR/memory.db"
KNOWLEDGE_FILE="$DATA_DIR/knowledge.txt"
CONFIG_FILE="$DATA_DIR/config.cfg"

# ========== GLOBAL DEĞİŞKENLER ==========
CURRENT_LANG="tr"
USER_NAME=""
LAST_QUESTION=""
LAST_ANSWER=""
CONVERSATION_HISTORY=""
EMOTION="neutral"
CONTEXT=""

# ========== DİL ALGILAMA İÇİN KARAKTER SETLERİ ==========
# Türkçe karakterler: ğüşıöçĞÜŞİÖÇ
# İngilizce: abcdefghijklmnopqrstuvwxyz
# Almanca: äöüßÄÖÜ
# Fransızca: éèêëàâçîïôûùÿÉÈÊËÀÂÇÎÏÔÛÙŸ
# Rusça: абвгдеёжзийклмнопрстуфхцчшщъыьэюя
# Arapça: ارب ت س ج ح خ د ذ ر ز ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي
# Japonca: あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん

# ========== YARDIMCI FONKSİYONLAR ==========

# Log yazma
log_write() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    if [ ! -d "$DATA_DIR" ]; then
        mkdir -p "$DATA_DIR" 2>/dev/null
    fi
    
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE" 2>/dev/null
}

# Dizinleri oluştur
setup_directories() {
    mkdir -p "$WORK_DIR" 2>/dev/null
    mkdir -p "$LANG_DIR" 2>/dev/null
    mkdir -p "$CORE_DIR" 2>/dev/null
    mkdir -p "$DATA_DIR" 2>/dev/null
    
    log_write "INFO" "Dizinler oluşturuldu: $WORK_DIR"
}

# Konfigürasyonu yükle
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        CURRENT_LANG=$(grep "^LANG=" "$CONFIG_FILE" | cut -d'=' -f2 2>/dev/null)
        USER_NAME=$(grep "^USER_NAME=" "$CONFIG_FILE" | cut -d'=' -f2 2>/dev/null)
        EMOTION=$(grep "^EMOTION=" "$CONFIG_FILE" | cut -d'=' -f2 2>/dev/null)
    fi
    
    CURRENT_LANG="${CURRENT_LANG:-tr}"
    USER_NAME="${USER_NAME:-reis}"
    EMOTION="${EMOTION:-neutral}"
}

# Konfigürasyonu kaydet
save_config() {
    echo "LANG=$CURRENT_LANG" > "$CONFIG_FILE"
    echo "USER_NAME=$USER_NAME" >> "$CONFIG_FILE"
    echo "EMOTION=$EMOTION" >> "$CONFIG_FILE"
    log_write "INFO" "Konfigürasyon kaydedildi"
}

# ========== DİL ALGILAMA ==========
# Girilen metnin dilini tespit eder
detect_language() {
    local text="$1"
    
    # Boş kontrol
    if [ -z "$text" ]; then
        echo "$CURRENT_LANG"
        return
    fi
    
    # Türkçe karakter kontrolü
    if echo "$text" | grep -q "[ğüşıöçĞÜŞİÖÇ]"; then
        echo "tr"
        return
    fi
    
    # Almanca karakterler
    if echo "$text" | grep -q "[äöüßÄÖÜ]"; then
        echo "de"
        return
    fi
    
    # Fransızca karakterler
    if echo "$text" | grep -q "[éèêëàâçîïôûùÿÉÈÊËÀÂÇÎÏÔÛÙŸ]"; then
        echo "fr"
        return
    fi
    
    # Rusça karakterler (Cyrillic)
    if echo "$text" | grep -q "[абвгдеёжзийклмнопрстуфхцчшщъыьэюя]"; then
        echo "ru"
        return
    fi
    
    # Arapça karakterler
    if echo "$text" | grep -q "[ابتثجحخدذرزسشصضطظعغفقكلمنهوي]"; then
        echo "ar"
        return
    fi
    
    # Japonca karakterler (Hiragana/Katakana/Kanji)
    if echo "$text" | grep -q "[あ-んア-ン一-龯]"; then
        echo "ja"
        return
    fi
    
    # İngilizce ve diğer Latin dilleri
    if echo "$text" | grep -q "[a-zA-Z]"; then
        # Basit İngilizce kelime kontrolü
        if echo "$text" | grep -qi "\b\(the\|and\|for\|you\|are\|what\|how\|why\|when\|where\)\b"; then
            echo "en"
        else
            # Varsayılan olarak mevcut dili kullan
            echo "$CURRENT_LANG"
        fi
        return
    fi
    
    # Varsayılan
    echo "$CURRENT_LANG"
}

# ========== DİL DOSYASINI YÜKLE ==========
# Belirtilen dildeki yanıtları yükler
load_language_file() {
    local lang="$1"
    local lang_file="$LANG_DIR/${lang}.sh"
    
    if [ -f "$lang_file" ]; then
        . "$lang_file"
        log_write "INFO" "Dil dosyası yüklendi: $lang"
        return 0
    else
        log_write "WARN" "Dil dosyası bulunamadı: $lang_file"
        return 1
    fi
}

# ========== HAFIZA İŞLEMLERİ ==========
# Konuşma geçmişini kaydet
save_to_memory() {
    local user_input="$1"
    local ai_response="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "$timestamp | USER: $user_input" >> "$MEMORY_FILE"
    echo "$timestamp | AI: $ai_response" >> "$MEMORY_FILE"
    echo "---" >> "$MEMORY_FILE"
    
    # Son 10 konuşmayı CONVERSATION_HISTORY'de tut
    CONVERSATION_HISTORY="$CONVERSATION_HISTORY\nUser: $user_input\nDeepSeek: $ai_response\n"
    CONVERSATION_HISTORY=$(echo "$CONVERSATION_HISTORY" | tail -20)
    
    log_write "INFO" "Hafızaya kaydedildi: $user_input"
}

# Kullanıcı adını hatırla
remember_user() {
    if [ -z "$USER_NAME" ] || [ "$USER_NAME" = "reis" ]; then
        # Kullanıcı adını öğrenmeye çalış
        if echo "$1" | grep -qi "benim adım\|my name is\|ich heiße\|je m'appelle\|меня зовут\|اسمي\|私の名前は"; then
            # Basit çıkarım - gerçek NLP için daha gelişmiş gerekir
            local possible_name=$(echo "$1" | sed -E 's/.*(adım|name is|heiße|m.appelle|зовут|اسمي|名前は)[[:space:]]*([A-Za-zğüşıöçĞÜŞİÖÇ]+).*/\2/i')
            if [ -n "$possible_name" ] && [ ${#possible_name} -lt 20 ]; then
                USER_NAME="$possible_name"
                save_config
                log_write "INFO" "Kullanıcı adı hatırlandı: $USER_NAME"
                return 0
            fi
        fi
    fi
    return 1
}

# ========== DUYGU ANALİZİ ==========
# Kullanıcının duygu durumunu analiz eder
analyze_emotion() {
    local text="$1"
    
    local happy_keywords="mutlu|sevindim|harika|süper|iyiyim|güzel|teşekkür|happy|great|awesome|good|thanks|danke|merci|спасибо|شكرا|ありがとう"
    local sad_keywords="üzgün|kötü|berbat|moralim bozuk|sad|bad|terrible|schlecht|triste|плохо|حزين|悲しい"
    local angry_keywords="sinirli|kızgın|öfke|sinir|angry|mad|furious|wütend|en colère|злой|غاضب|怒っている"
    
    if echo "$text" | grep -qiE "$happy_keywords"; then
        EMOTION="happy"
    elif echo "$text" | grep -qiE "$sad_keywords"; then
        EMOTION="sad"
    elif echo "$text" | grep -qiE "$angry_keywords"; then
        EMOTION="angry"
    else
        EMOTION="neutral"
    fi
    
    log_write "INFO" "Duygu analizi: $EMOTION"
    echo "$EMOTION"
}

# ========== KOMUT ÇALIŞTIRMA ==========
# Terminal komutlarını güvenli şekilde çalıştırır
execute_command() {
    local cmd="$1"
    
    # Güvenlik kontrolü - tehlikeli komutları engelle
    local dangerous_cmds="rm -rf \|mkfs\|dd if\|format\|shutdown\|reboot\|poweroff"
    
    if echo "$cmd" | grep -qiE "$dangerous_cmds"; then
        echo "⚠️ Güvenlik: Bu komut çalıştırılamaz (tehlikeli işlem)"
        log_write "WARN" "Tehlikeli komut engellendi: $cmd"
        return 1
    fi
    
    log_write "INFO" "Komut çalıştırılıyor: $cmd"
    
    # Komutu çalıştır ve çıktıyı al
    local output
    output=$(eval "$cmd" 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "$output"
        return 0
    else
        echo "Hata: $output"
        return 1
    fi
}

# ========== NLP İŞLEMLERİ ==========
# Basit doğal dil işleme
process_nlp() {
    local input="$1"
    local lang="$2"
    
    # Küçük harfe çevir
    input=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    
    # Selamlaşma kontrolü
    if echo "$input" | grep -qE "merhaba|selam|hello|hallo|bonjour|privet|مرحبا|こんにちは"; then
        return 1  # selamlaşma
    fi
    
    # Nasılsın kontrolü
    if echo "$input" | grep -qE "nasılsın|how are you|wie geht|ça va|как дела|كيف حالك|お元気"; then
        return 2  # nasılsın
    fi
    
    # Komut kontrolü (çalıştır, göster, listele)
    if echo "$input" | grep -qE "çalıştır|run|execute|ausführen|exécuter|запустить|تشغيل|実行"; then
        return 3  # komut çalıştır
    fi
    
    # Adını sorma
    if echo "$input" | grep -qE "adın ne|what.is.your.name|wie heißt du|comment tu t.appelles|как тебя зовут|ما اسمك|あなたの名前は"; then
        return 4  # isim sorma
    fi
    
    # Yardım
    if echo "$input" | grep -qE "yardım|help|hilfe|aide|помощь|مساعدة|助けて"; then
        return 5  # yardım
    fi
    
    # Teşekkür
    if echo "$input" | grep -qE "teşekkür|thanks|danke|merci|спасибо|شكرا|ありがとう"; then
        return 6  # teşekkür
    fi
    
    # Çıkış
    if echo "$input" | grep -qE "çık|exit|quit|beenden|quitter|выход|خروج|終了"; then
        return 0  # çıkış
    fi
    
    return 7  # normal konuşma
}

# ========== CEVAP OLUŞTURMA ==========
# NLP sonucuna göre cevap üretir
generate_response() {
    local nlp_result="$1"
    local lang="$2"
    local user_input="$3"
    
    # Dil dosyasını yükle
    load_language_file "$lang"
    
    case $nlp_result in
        0)  # çıkış
            echo "exit"
            ;;
        1)  # selamlaşma
            echo "$GREETING"
            ;;
        2)  # nasılsın
            case $EMOTION in
                happy) echo "$HOW_ARE_YOU_HAPPY" ;;
                sad) echo "$HOW_ARE_YOU_SAD" ;;
                angry) echo "$HOW_ARE_YOU_ANGRY" ;;
                *) echo "$HOW_ARE_YOU" ;;
            esac
            ;;
        3)  # komut çalıştır
            # Komutu çıkar (çalıştır, run vb.)
            local cmd=$(echo "$user_input" | sed -E 's/^(çalıştır|run|execute|ausführen|exécuter|запустить|تشغيل|実行)[[:space:]]*//i')
            if [ -n "$cmd" ]; then
                local output=$(execute_command "$cmd")
                echo "$COMMAND_RESULT"
                echo "$output"
            else
                echo "$WHAT_COMMAND"
            fi
            ;;
        4)  # isim sorma
            echo "$MY_NAME_IS"
            ;;
        5)  # yardım
            echo "$HELP_TEXT"
            ;;
        6)  # teşekkür
            echo "$THANKS_RESPONSE"
            ;;
        7)  # normal konuşma - basit cevaplar
            # Bilgi havuzunda ara (knowledge.txt)
            local answer=$(grep -i "$user_input" "$KNOWLEDGE_FILE" 2>/dev/null | head -1 | cut -d'|' -f2)
            if [ -n "$answer" ]; then
                echo "$answer"
            else
                # Rastgele genel cevap
                local responses="($UNKNOWN_RESPONSE|$DEFAULT_RESPONSE|$ASK_QUESTION)"
                IFS='|' read -ra RESPONSE_ARRAY <<< "$responses"
                local random_index=$((RANDOM % ${#RESPONSE_ARRAY[@]}))
                echo "${RESPONSE_ARRAY[$random_index]}"
            fi
            ;;
    esac
}

# ========== KULLANICI ADI İLE HİTAP ETME ==========
get_user_greeting() {
    if [ -n "$USER_NAME" ] && [ "$USER_NAME" != "reis" ]; then
        echo "$USER_NAME"
    else
        echo "reis"
    fi
}

# ========== BAŞLANGIÇ MESAJI ==========
show_banner() {
    clear
    echo -e "${LIGHT_CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                  ║"
    echo "║                    D E E P S E E K - T E R M I N A L             ║"
    echo "║                         v$VERSION                                   ║"
    echo "║                                                                  ║"
    echo "║                   Terminal Yapay Zeka Asistanı                   ║"
    echo "║                         By: $AUTHOR                              ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${GRAY}┌─────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GRAY}│ ${CYAN}DeepSeek${GRAY} - ${YELLOW}Sana yardım etmek için buradayım reis!${GRAY}                              │${NC}"
    echo -e "${GRAY}│ ${GREEN}Türkçe, English, Deutsch, Français, Русский, العربية, 日本語${GRAY}                    │${NC}"
    echo -e "${GRAY}│                                                                     │${NC}"
    echo -e "${GRAY}│ ${WHITE}İpucu:${GRAY} 'yardım' yazarak komutları görebilirsin                         │${NC}"
    echo -e "${GRAY}│ ${WHITE}İpucu:${GRAY} 'çık' yazarak programdan çıkabilirsin                          │${NC}"
    echo -e "${GRAY}└─────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# ========== YARDIM MESAJI ==========
show_help() {
    local lang="$1"
    load_language_file "$lang"
    
    echo -e "${YELLOW}${BOLD}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}${BOLD}                         YARDIM / HELP                             ${NC}"
    echo -e "${YELLOW}${BOLD}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Komutlar / Commands:${NC}"
    echo -e "  ${GREEN}•${NC} Merhaba, Selam, Hello   - Selamlaşma / Greeting"
    echo -e "  ${GREEN}•${NC} Nasılsın?               - Durum sorma / How are you"
    echo -e "  ${GREEN}•${NC} Adın ne?                - Beni tanı / Who am I"
    echo -e "  ${GREEN}•${NC} Benim adım [isim]       - Adını söyle / Tell your name"
    echo -e "  ${GREEN}•${NC} Çalıştır [komut]        - Terminal komutu çalıştır / Run command"
    echo -e "  ${GREEN}•${NC} Teşekkürler             - Teşekkür / Thanks"
    echo -e "  ${GREEN}•${NC} Yardım / Help           - Bu mesaj / This message"
    echo -e "  ${GREEN}•${NC} Çık / Exit              - Programdan çık / Exit program"
    echo ""
    echo -e "${CYAN}Örnekler / Examples:${NC}"
    echo -e "  ${GRAY}»${NC} Çalıştır ls -la"
    echo -e "  ${GRAY}»${NC} Benim adım Ahmet"
    echo -e "  ${GRAY}»${NC} Bugün hava nasıl?"
    echo ""
    echo -n -e "${CYAN}Devam etmek için Enter tuşuna bas...${NC}"
    read
}

# ========== ANA DÖNGÜ ==========
main_loop() {
    local detected_lang=""
    local nlp_result=0
    local response=""
    local user_input=""
    
    show_banner
    
    # Hoş geldin mesajı
    load_language_file "$CURRENT_LANG"
    local greeting=$(echo "$GREETING" | sed "s/reis/$(get_user_greeting)/g")
    echo -e "${LIGHT_GREEN}DeepSeek${NC}: ${greeting}"
    echo ""
    
    while true; do
        # Kullanıcıdan girdi al
        echo -n -e "${LIGHT_BLUE}$(get_user_greeting)${NC}${CYAN}@${NC}${LIGHT_PURPLE}deepseek${NC}${WHITE}:${NC}${YELLOW}~${NC}${WHITE}$ ${NC}"
        read -r user_input
        
        # Boş girdi kontrolü
        if [ -z "$user_input" ]; then
            continue
        fi
        
        # Çıkış kontrolü
        if echo "$user_input" | grep -qiE "^(çık|exit|quit|beenden|quitter|выход|خروج|終了)$"; then
            load_language_file "$CURRENT_LANG"
            echo -e "${LIGHT_GREEN}DeepSeek${NC}: $GOODBYE"
            log_write "INFO" "Program sonlandırıldı"
            exit 0
        fi
        
        # Yardım kontrolü
        if echo "$user_input" | grep -qiE "^(yardım|help|hilfe|aide|помощь|مساعدة|助けて)$"; then
            show_help "$CURRENT_LANG"
            continue
        fi
        
        # Dili algıla
        detected_lang=$(detect_language "$user_input")
        if [ "$detected_lang" != "$CURRENT_LANG" ]; then
            CURRENT_LANG="$detected_lang"
            save_config
            load_language_file "$CURRENT_LANG"
            echo -e "${GRAY}[Dil değiştirildi: $detected_lang]${NC}"
        fi
        
        # Duygu analizi yap
        analyze_emotion "$user_input"
        
        # Kullanıcı adını hatırlamaya çalış
        remember_user "$user_input"
        
        # NLP işlemi yap
        nlp_result=$(process_nlp "$user_input" "$CURRENT_LANG")
        
        # Cevap oluştur
        response=$(generate_response "$nlp_result" "$CURRENT_LANG" "$user_input")
        
        # Çıkış kontrolü
        if [ "$response" = "exit" ]; then
            load_language_file "$CURRENT_LANG"
            echo -e "${LIGHT_GREEN}DeepSeek${NC}: $GOODBYE"
            log_write "INFO" "Program sonlandırıldı"
            exit 0
        fi
        
        # Kullanıcı adını cevaba ekle (selamlaşma ve nasılsın için)
        if [ $nlp_result -eq 1 ] || [ $nlp_result -eq 2 ]; then
            response=$(echo "$response" | sed "s/reis/$(get_user_greeting)/g")
        fi
        
        # Cevabı göster
        echo -e "${LIGHT_GREEN}DeepSeek${NC}: $response"
        echo ""
        
        # Hafızaya kaydet
        save_to_memory "$user_input" "$response"
        
        LAST_QUESTION="$user_input"
        LAST_ANSWER="$response"
    done
}

# ========== BAŞLANGIÇ KONTROLLERİ ==========
check_dependencies() {
    # Basic komutların varlığını kontrol et
    local missing=0
    
    for cmd in grep sed awk cat echo printf; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "Eksik: $cmd"
            missing=1
        fi
    done
    
    if [ $missing -eq 1 ]; then
        echo "Gerekli komutlar bulunamadı. Termux kurulu mu?"
        exit 1
    fi
}

# ========== ANA PROGRAM ==========
main() {
    # Bağımlılıkları kontrol et
    check_dependencies
    
    # Dizinleri oluştur
    setup_directories
    
    # Konfigürasyonu yükle
    load_config
    
    # Bilgi havuzu yoksa oluştur
    if [ ! -f "$KNOWLEDGE_FILE" ]; then
        cat > "$KNOWLEDGE_FILE" << EOF
merhaba|Selam reis! Sana nasıl yardımcı olabilirim?
nasılsın|İyiyim reis, sen nasılsın?
ne yapıyorsun|Sana yardım etmeye çalışıyorum reis!
teşekkür|Rica ederim reis, ne zaman ihtiyacın olursa buradayım.
adın ne|Ben DeepSeek, terminal yapay zeka asistanın!
kimsin|Ben DeepSeek, sana yardım etmek için yazılmış bir yapay zekayım.
EOF
        log_write "INFO" "Bilgi havuzu oluşturuldu"
    fi
    
    # Ana döngüyü başlat
    main_loop
}

# Programı başlat
main "$@"
