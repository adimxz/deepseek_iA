#!/system/bin/sh

# ==========================================
# DeepSeek-iA v5.1
# Terminal Asistanı - Hatasız Versiyon
# ==========================================

VERSION="5.1"

# Renkler
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

# Klasör
mkdir -p ~/.deepseek

# Kullanıcı adı
if [ -f ~/.deepseek/user ]; then
    USER_NAME=$(cat ~/.deepseek/user)
else
    USER_NAME="kullanici"
fi

# ==========================================
# DİL SEÇİMİ
# ==========================================
clear
echo -e "${CYAN}${BOLD}"
echo "==================================="
echo "     DEEPSEEK $VERSION"
echo "==================================="
echo -e "${NC}"
echo "1) Türkçe"
echo "2) English"
echo "3) Deutsch"
echo "4) Français"
echo "5) Русский"
echo "6) العربية"
echo "7) 日本語"
echo "0) Cikis"
echo ""
echo -n "Seciminiz: "
read lang_choice

case $lang_choice in
    1) LANG="tr" ;;
    2) LANG="en" ;;
    3) LANG="de" ;;
    4) LANG="fr" ;;
    5) LANG="ru" ;;
    6) LANG="ar" ;;
    7) LANG="ja" ;;
    0) echo "Gorusuruz!"; exit 0 ;;
    *) LANG="tr" ;;
esac

echo "LANG=$LANG" > ~/.deepseek/config

# ==========================================
# DİL MESAJLARI
# ==========================================
if [ "$LANG" = "tr" ]; then
    PROMPT="${CYAN}deepseek@ai:~${NC}${WHITE}\$${NC} "
    WELCOME="Merhaba $USER_NAME! Ben DeepSeek. Hava durumu, haber, hesap yapabilirim. Ne istersin?"
    BYE="Gorusuruz $USER_NAME! Yine beklerim."
    CMD_HELP="yardim"
    HELP_TEXT="
${YELLOW}Komutlar:${NC}
  hava [sehir]     - Hava durumu
  haber            - Son dakika haberleri
  hesap [islem]    - Matematik (ornek: hesap 5+3*2)
  ara [kelime]     - Wikipedia arastirmasi
  benim adim X     - Adini soyle
  tesekkur         - Tesekkur et
  yardim           - Bu menu
  cik              - Cikis"
elif [ "$LANG" = "en" ]; then
    PROMPT="${CYAN}deepseek@ai:~${NC}${WHITE}\$${NC} "
    WELCOME="Hello $USER_NAME! I'm DeepSeek. Weather, news, math. What do you need?"
    BYE="Goodbye $USER_NAME! See you later."
    CMD_HELP="help"
    HELP_TEXT="
${YELLOW}Commands:${NC}
  weather [city]   - Weather info
  news             - Latest news
  calc [formula]   - Math (ex: calc 5+3*2)
  search [query]   - Wikipedia search
  my name is X     - Tell your name
  thanks           - Say thanks
  help             - This menu
  exit             - Exit"
elif [ "$LANG" = "de" ]; then
    PROMPT="${CYAN}deepseek@ai:~${NC}${WHITE}\$${NC} "
    WELCOME="Hallo $USER_NAME! Ich bin DeepSeek. Wetter, Nachrichten, Rechnen. Was brauchst du?"
    BYE="Auf Wiedersehen $USER_NAME!"
    CMD_HELP="hilfe"
    HELP_TEXT="
${YELLOW}Befehle:${NC}
  wetter [stadt]   - Wetter
  nachrichten      - Nachrichten
  rechne [formel]  - Mathematik
  suche [begriff]  - Wikipedia suche
  ich heisse X     - Sag deinen Namen
  danke            - Danke sagen
  hilfe            - Dieses Menü
  beenden          - Beenden"
elif [ "$LANG" = "fr" ]; then
    PROMPT="${CYAN}deepseek@ai:~${NC}${WHITE}\$${NC} "
    WELCOME="Bonjour $USER_NAME! Je suis DeepSeek. Météo, actualités, calculs. Que veux-tu?"
    BYE="Au revoir $USER_NAME!"
    CMD_HELP="aide"
    HELP_TEXT="
${YELLOW}Commandes:${NC}
  meteo [ville]    - Météo
  actualites       - Actualités
  calcule [formule]- Calcul
  cherche [terme]  - Wikipedia
  j'appelle X      - Donner ton nom
  merci            - Remercier
  aide             - Ce menu
  quitter          - Quitter"
elif [ "$LANG" = "ru" ]; then
    PROMPT="${CYAN}deepseek@ai:~${NC}${WHITE}\$${NC} "
    WELCOME="Здравствуй $USER_NAME! Я DeepSeek. Погода, новости, расчёты. Что нужно?"
    BYE="До свидания $USER_NAME!"
    CMD_HELP="помощь"
    HELP_TEXT="
${YELLOW}Команды:${NC}
  погода [город]   - Погода
  новости          - Новости
  вычисли [формула]- Математика
  ищи [слово]      - Поиск
  меня зовут X     - Назвать имя
  спасибо          - Поблагодарить
  помощь           - Это меню
  выход            - Выход"
else
    # varsayilan Turkce
    PROMPT="${CYAN}deepseek@ai:~${NC}${WHITE}\$${NC} "
    WELCOME="Merhaba $USER_NAME! Ben DeepSeek. Hava durumu, haber, hesap yapabilirim."
    BYE="Gorusuruz $USER_NAME!"
    CMD_HELP="yardim"
    HELP_TEXT="Komutlar: hava [sehir], haber, hesap [islem], ara [kelime], cik"
fi

# ==========================================
# FONKSIYONLAR
# ==========================================
get_weather() {
    city="$1"
    [ -z "$city" ] && city="Istanbul"
    echo -e "${CYAN}Hava durumu: $city${NC}"
    curl -s "wttr.in/$city?format=3" 2>/dev/null || echo "Baglanti hatasi!"
}

get_news() {
    echo -e "${CYAN}Son haberler:${NC}"
    curl -s "https://api.rss2json.com/v1/api.json?rss_url=https://www.ntv.com.tr/son-dakika.rss" 2>/dev/null | grep -o '"title":"[^"]*"' | head -3 | sed 's/"title":"/• /; s/"//' || echo "Haber alinamadi."
}

calculate() {
    result=$(echo "$1" | bc -l 2>/dev/null)
    if [ -n "$result" ]; then
        echo "   = $result"
    else
        echo "   Hesaplanamadi. Ornek: 5+3*2"
    fi
}

search_wiki() {
    query=$(echo "$1" | sed 's/ /_/g')
    echo -e "${CYAN}Araştırılıyor: $1${NC}"
    curl -s "https://tr.wikipedia.org/api/rest_v1/page/summary/$query" 2>/dev/null | grep -o '"extract":"[^"]*"' | head -1 | sed 's/"extract":"//; s/"//' | cut -c1-200 || echo "Sonuc bulunamadi."
}

# ==========================================
# KOMUT ISLEYICI
# ==========================================
process() {
    input=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    # hava durumu
    if echo "$input" | grep -q "^hava"; then
        sehir=$(echo "$input" | sed 's/^hava //')
        get_weather "$sehir"
        return
    fi
    
    # haber
    if [ "$input" = "haber" ]; then
        get_news
        return
    fi
    
    # hesap
    if echo "$input" | grep -q "^hesap "; then
        islem=$(echo "$input" | sed 's/^hesap //')
        calculate "$islem"
        return
    fi
    
    # ara (wikipedia)
    if echo "$input" | grep -q "^ara "; then
        kelime=$(echo "$input" | sed 's/^ara //')
        search_wiki "$kelime"
        return
    fi
    
    # benim adim
    if echo "$input" | grep -q "^benim adim "; then
        yeni_ad=$(echo "$input" | sed 's/^benim adim //')
        echo "$yeni_ad" > ~/.deepseek/user
        echo "   Tamam $yeni_ad! Adini hatirlayacagim."
        USER_NAME="$yeni_ad"
        return
    fi
    
    # tesekkur
    if [ "$input" = "tesekkur" ] || [ "$input" = "tesekkurler" ]; then
        echo "   Rica ederim $USER_NAME!"
        return
    fi
    
    # yardim
    if [ "$input" = "yardim" ] || [ "$input" = "help" ]; then
        echo "$HELP_TEXT"
        return
    fi
    
    # cikis
    if [ "$input" = "cik" ] || [ "$input" = "exit" ]; then
        echo "$BYE"
        exit 0
    fi
    
    # anlamadi
    echo "   Anlamadim $USER_NAME. '$CMD_HELP' yazarak komutlari gorebilirsin."
}

# ==========================================
# ANA DÖNGÜ
# ==========================================
clear
echo -e "${CYAN}${BOLD}"
echo "==================================="
echo "     DEEPSEEK-iA v$VERSION"
echo "     Baglantili Terminal Asistani"
echo "==================================="
echo -e "${NC}"
echo -e "${GREEN}DeepSeek${NC}: $WELCOME"
echo ""

while true; do
    printf "%s" "$PROMPT"
    read user_input || break
    [ -z "$user_input" ] && continue
    echo -n -e "${GREEN}DeepSeek${NC}: "
    process "$user_input"
    echo ""
done
