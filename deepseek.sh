#!/system/bin/sh

# ==========================================
# DeepSeek-iA v5.0
# Bağlantılı, çok dilli terminal asistanı
# ==========================================

VERSION="5.0"
AUTHOR="Reis"

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Klasörler
mkdir -p ~/.deepseek
CONFIG_FILE="$HOME/.deepseek/config"

# ==========================================
# ÖNCE DİL SEÇİMİ
# ==========================================
select_language() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔════════════════════════════════════════════╗"
    echo "║         DeepSeek-iA v$VERSION              ║"
    echo "║     Lütfen bir dil seçin / Choose a language║"
    echo "╚════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "  ${GREEN}1${NC}) Türkçe"
    echo "  ${GREEN}2${NC}) English"
    echo "  ${GREEN}3${NC}) Deutsch"
    echo "  ${GREEN}4${NC}) Français"
    echo "  ${GREEN}5${NC}) Русский"
    echo "  ${GREEN}6${NC}) العربية"
    echo "  ${GREEN}7${NC}) 日本語"
    echo "  ${GREEN}8${NC}) Italiano"
    echo "  ${GREEN}0${NC}) Çıkış / Exit"
    echo ""
    echo -n "Seçiminiz / Your choice: "
    read lang_choice

    case $lang_choice in
        1) CURRENT_LANG="tr"; SAVE_LANG="tr" ;;
        2) CURRENT_LANG="en"; SAVE_LANG="en" ;;
        3) CURRENT_LANG="de"; SAVE_LANG="de" ;;
        4) CURRENT_LANG="fr"; SAVE_LANG="fr" ;;
        5) CURRENT_LANG="ru"; SAVE_LANG="ru" ;;
        6) CURRENT_LANG="ar"; SAVE_LANG="ar" ;;
        7) CURRENT_LANG="ja"; SAVE_LANG="ja" ;;
        8) CURRENT_LANG="it"; SAVE_LANG="it" ;;
        0) clear; echo "Görüşürüz!"; exit 0 ;;
        *) echo "Geçersiz seçim, varsayılan: Türkçe"; CURRENT_LANG="tr"; SAVE_LANG="tr" ;;
    esac

    echo "LANG=$SAVE_LANG" > "$CONFIG_FILE"
    echo "USER_NAME=kullanici" >> "$CONFIG_FILE"
}

# ==========================================
# KONFİGÜRASYONU YÜKLE
# ==========================================
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
    else
        select_language
    fi
}

# ==========================================
# DİL DETAYLARI
# ==========================================
case $CURRENT_LANG in
    tr)
        PROMPT="deepseek@ai:~$"
        WELCOME="Hoş geldin! Ben DeepSeek-iA. İnternete bağlıyım, hava durumu, haber, hesap yapabilirim. Ne istersin?"
        BYE="Görüşürüz! Yine beklerim. 👋"
        HELP="
${YELLOW}════════════════════════════════════════════════${NC}
${GREEN}DeepSeek Komutları${NC}
${YELLOW}════════════════════════════════════════════════${NC}
${CYAN}• hava durumu [şehir]${NC}  - Hava durumu gösterir
${CYAN}• haber${NC}                - Son dakika haberleri
${CYAN}• hesapla [işlem]${NC}      - Matematik işlemi yapar
${CYAN}• ara [kelime]${NC}         - Vikipedi'de araştırma
${CYAN}• benim adım [isim]${NC}    - Adını söyle
${CYAN}• teşekkürler${NC}          - Teşekkür eder
${CYAN}• yardım${NC}               - Bu menü
${CYAN}• çık${NC}                  - Çıkış
${YELLOW}════════════════════════════════════════════════${NC}"
        ;;
    en)
        PROMPT="deepseek@ai:~$"
        WELCOME="Welcome! I'm DeepSeek-iA. I'm connected to the internet. I can do weather, news, math, search. What do you need?"
        BYE="Goodbye! See you later. 👋"
        HELP="
${YELLOW}════════════════════════════════════════════════${NC}
${GREEN}DeepSeek Commands${NC}
${YELLOW}════════════════════════════════════════════════${NC}
${CYAN}• weather [city]${NC}       - Show weather
${CYAN}• news${NC}                 - Latest news
${CYAN}• calculate [math]${NC}     - Do math
${CYAN}• search [query]${NC}       - Search Wikipedia
${CYAN}• my name is [name]${NC}    - Tell your name
${CYAN}• thanks${NC}               - Say thanks
${CYAN}• help${NC}                 - This menu
${CYAN}• exit${NC}                 - Exit
${YELLOW}════════════════════════════════════════════════${NC}"
        ;;
    de)
        PROMPT="deepseek@ai:~$"
        WELCOME="Willkommen! Ich bin DeepSeek-iA. Ich bin mit dem Internet verbunden. Wetter, Nachrichten, Rechnen, Suche. Was brauchen Sie?"
        BYE="Auf Wiedersehen! Bis bald. 👋"
        HELP="
${YELLOW}════════════════════════════════════════════════${NC}
${GREEN}DeepSeek Befehle${NC}
${YELLOW}════════════════════════════════════════════════${NC}
${CYAN}• wetter [Stadt]${NC}       - Wetter anzeigen
${CYAN}• nachrichten${NC}          - Neueste Nachrichten
${CYAN}• berechne [mathe]${NC}     - Mathematik
${CYAN}• suche [begriff]${NC}      - Wikipedia suchen
${CYAN}• ich heiße [name]${NC}     - Namen sagen
${CYAN}• danke${NC}                - Danke sagen
${CYAN}• hilfe${NC}                - Dieses Menü
${CYAN}• beenden${NC}              - Beenden
${YELLOW}════════════════════════════════════════════════${NC}"
        ;;
    fr)
        PROMPT="deepseek@ai:~$"
        WELCOME="Bienvenue ! Je suis DeepSeek-iA. Je suis connecté à Internet. Météo, actualités, calculs, recherche. Que voulez-vous ?"
        BYE="Au revoir ! À bientôt. 👋"
        HELP="
${YELLOW}════════════════════════════════════════════════${NC}
${GREEN}Commandes DeepSeek${NC}
${YELLOW}════════════════════════════════════════════════${NC}
${CYAN}• météo [ville]${NC}        - Afficher la météo
${CYAN}• actualités${NC}           - Dernières nouvelles
${CYAN}• calcule [calcul]${NC}     - Calcul mathématique
${CYAN}• cherche [terme]${NC}      - Chercher sur Wikipedia
${CYAN}• je m'appelle [nom]${NC}   - Donner son nom
${CYAN}• merci${NC}                - Remercier
${CYAN}• aide${NC}                 - Ce menu
${CYAN}• quitter${NC}              - Quitter
${YELLOW}════════════════════════════════════════════════${NC}"
        ;;
    ru)
        PROMPT="deepseek@ai:~$"
        WELCOME="Добро пожаловать! Я DeepSeek-iA. Я подключен к интернету. Погода, новости, вычисления, поиск. Что вам нужно?"
        BYE="До свидания! Увидимся. 👋"
        HELP="
${YELLOW}════════════════════════════════════════════════${NC}
${GREEN}Команды DeepSeek${NC}
${YELLOW}════════════════════════════════════════════════${NC}
${CYAN}• погода [город]${NC}       - Показать погоду
${CYAN}• новости${NC}              - Последние новости
${CYAN}• вычисли [расчет]${NC}     - Математика
${CYAN}• ищи [слово]${NC}          - Поиск в Википедии
${CYAN}• меня зовут [имя]${NC}     - Сказать имя
${CYAN}• спасибо${NC}              - Поблагодарить
${CYAN}• помощь${NC}               - Это меню
${CYAN}• выход${NC}                - Выход
${YELLOW}════════════════════════════════════════════════${NC}"
        ;;
    ar)
        PROMPT="deepseek@ai:~$"
        WELCOME="مرحباً! أنا ديب سيك. أنا متصل بالإنترنت. الطقس، الأخبار، الحسابات، البحث. ماذا تحتاج؟"
        BYE="مع السلامة! أراك لاحقاً. 👋"
        HELP="..."
        ;;
    ja)
        PROMPT="deepseek@ai:~$"
        WELCOME="いらっしゃいませ！私はDeepSeek-iAです。インターネットに接続されています。天気、ニュース、計算、検索できます。何が必要ですか？"
        BYE="さようなら！また会いましょう。👋"
        HELP="..."
        ;;
    it)
        PROMPT="deepseek@ai:~$"
        WELCOME="Benvenuto! Sono DeepSeek-iA. Sono connesso a Internet. Meteo, notizie, calcoli, ricerca. Di cosa hai bisogno?"
        BYE="Arrivederci! Ci vediamo. 👋"
        HELP="..."
        ;;
esac

# ==========================================
# KULLANICI ADI
# ==========================================
if [ -f "$HOME/.deepseek/username" ]; then
    USER_NAME=$(cat "$HOME/.deepseek/username")
else
    USER_NAME="kullanici"
fi

# ==========================================
# BAĞLANTILI FONKSİYONLAR
# ==========================================

# Hava durumu (wttr.in ücretsiz API)
weather() {
    city="$1"
    [ -z "$city" ] && city="Istanbul"
    
    echo -e "${BLUE}🌤️ Hava durumu aranıyor: $city${NC}"
    curl -s "wttr.in/$city?format=3" 2>/dev/null | sed 's/^/   /'
    if [ $? -ne 0 ]; then
        echo "   Bağlantı hatası! İnternetinizi kontrol edin."
    fi
}

# Haberler (rss2json ücretsiz)
news() {
    echo -e "${BLUE}📰 Son dakika haberleri getiriliyor...${NC}"
    curl -s "https://api.rss2json.com/v1/api.json?rss_url=https://www.ntv.com.tr/son-dakika.rss" 2>/dev/null | grep -o '"title":"[^"]*"' | head -5 | sed 's/"title":"/• /; s/"//'
    if [ $? -ne 0 ]; then
        echo "   Haberler alınamadı. İnternet bağlantınızı kontrol edin."
    fi
}

# Matematik hesaplama
calculate() {
    expr="$1"
    result=$(echo "$expr" | bc -l 2>/dev/null)
    if [ -n "$result" ]; then
        echo "   $expr = $result"
    else
        echo "   Hesaplanamadı. Örnek: hesapla 5+3*2"
    fi
}

# Wikipedia arama
search_wiki() {
    query="$1"
    encoded=$(echo "$query" | tr ' ' '_')
    echo -e "${BLUE}🔍 Araştırılıyor: $query${NC}"
    curl -s "https://tr.wikipedia.org/api/rest_v1/page/summary/$encoded" 2>/dev/null | grep -o '"extract":"[^"]*"' | head -1 | sed 's/"extract":"//; s/"//; s/\\n/\n/g'
    if [ $? -ne 0 ]; then
        echo "   Bilgi alınamadı."
    fi
}

# ==========================================
# KOMUT İŞLEYİCİ
# ==========================================
process_command() {
    cmd=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    # Hava durumu
    if echo "$cmd" | grep -qE "^(hava durumu|weather|wetter|météo|погода|الطقس|天気|tempo)"; then
        city=$(echo "$1" | sed -E 's/^(hava durumu|weather|wetter|météo|погода|الطقس|天気|tempo)[[:space:]]+//i')
        weather "$city"
        return
    fi
    
    # Haberler
    if echo "$cmd" | grep -qE "^(haber|news|nachrichten|actualités|новости|أخبار|ニュース|notizie)"; then
        news
        return
    fi
    
    # Hesaplama
    if echo "$cmd" | grep -qE "^(hesapla|calculate|berechne|calcule|вычисли|احسب|計算|calcola)"; then
        expr=$(echo "$1" | sed -E 's/^(hesapla|calculate|berechne|calcule|вычисли|احسب|計算|calcola)[[:space:]]+//i')
        calculate "$expr"
        return
    fi
    
    # Wikipedia arama
    if echo "$cmd" | grep -qE "^(ara|search|suche|cherche|ищи|ابحث|検索|cerca)"; then
        query=$(echo "$1" | sed -E 's/^(ara|search|suche|cherche|ищи|ابحث|検索|cerca)[[:space:]]+//i')
        search_wiki "$query"
        return
    fi
    
    # İsim kaydetme
    if echo "$cmd" | grep -qE "^(benim adım|my name is|ich heiße|je m'appelle|меня зовут|اسمي|私の名前は|mi chiamo)"; then
        new_name=$(echo "$1" | sed -E 's/^(benim adım|my name is|ich heiße|je m'appelle|меня зовут|اسمي|私の名前は|mi chiamo)[[:space:]]+//i')
        echo "$new_name" > "$HOME/.deepseek/username"
        echo "   Tamam $new_name! Adını hatırlayacağım."
        USER_NAME="$new_name"
        return
    fi
    
    # Teşekkür
    if echo "$cmd" | grep -qE "^(teşekkürler|teşekkür|thanks|danke|merci|спасибо|شكرا|ありがとう|grazie)"; then
        if [ "$CURRENT_LANG" = "tr" ]; then
            echo "   Rica ederim $USER_NAME! Ne zaman ihtiyacın olursa buradayım."
        elif [ "$CURRENT_LANG" = "en" ]; then
            echo "   You're welcome $USER_NAME! I'm here whenever you need me."
        else
            echo "   Rica ederim $USER_NAME!"
        fi
        return
    fi
    
    # Yardım
    if echo "$cmd" | grep -qE "^(yardım|help|hilfe|aide|помощь|مساعدة|助けて|aiuto)"; then
        echo "$HELP"
        return
    fi
    
    # Çıkış
    if echo "$cmd" | grep -qE "^(çık|exit|beenden|quitter|выход|خروج|終了|esci)"; then
        echo "$BYE"
        exit 0
    fi
    
    # Anlamadım
    if [ "$CURRENT_LANG" = "tr" ]; then
        echo "   Anlamadım $USER_NAME. 'yardım' yazarak neler yapabileceğimi görebilirsin."
    else
        echo "   I didn't understand $USER_NAME. Type 'help' to see what I can do."
    fi
}

# ==========================================
# BAŞLANGIÇ
# ==========================================
load_config
clear
echo -e "${CYAN}${BOLD}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                 DEEPSEEK-iA v$VERSION                    ║"
echo "║              Bağlantılı Terminal Asistanı              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${GREEN}DeepSeek${NC}: $WELCOME"
echo ""

while true; do
    echo -n -e "${CYAN}$PROMPT${NC} "
    read user_input
    [ -z "$user_input" ] && continue
    echo -n -e "${GREEN}DeepSeek${NC}: "
    process_command "$user_input"
    echo ""
done
