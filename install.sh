#!/system/bin/sh
# ============================================================
# DeepSeek-Terminal Kurulum Scripti
# ============================================================

echo -e "\033[0;36m"
echo "╔══════════════════════════════════════════════════════╗"
echo "║         DeepSeek-Terminal Kurulumu Başlıyor        ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "\033[0m"

# Dizinleri oluştur
mkdir -p languages 2>/dev/null
mkdir -p data 2>/dev/null

# Çalıştırma izni ver
chmod +x deepseek.sh 2>/dev/null

# Dil dosyalarını kontrol et
for lang in tr en de fr ru ar ja; do
    if [ -f "languages/$lang.sh" ]; then
        echo "✅ $lang.sh bulundu"
    else
        echo "❌ $lang.sh eksik!"
    fi
done

echo ""
echo -e "\033[0;32m✅ Kurulum tamamlandı!\033[0m"
echo ""
echo "Çalıştırmak için: ./deepseek.sh"
echo ""
