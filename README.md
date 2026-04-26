```markdown
# 🧠 DeepSeek iA

### Terminalinde yaşayan, çok dilli yapay zeka asistanı

> *"Merhaba reis! Sana nasıl yardımcı olabilirim?"*

---

## ⚡ Hızlı Başlangıç

```bash
git clone https://github.com/adimxz/deepseek_iA.git
cd deepseek_iA
chmod +x install.sh
./install.sh
./deepseek.sh
```

---

✨ Özellikler

Özellik Açıklama
🗣️ 7 Dil Türkçe, English, Deutsch, Français, Русский, العربية, 日本語
🧠 Hafıza Konuşmaları hatırlar, bağlamı anlar
😊 Duygu Analizi Üzgün mü, mutlu mu anlar, ona göre cevap verir
💻 Komut Çalıştırma Terminal komutlarını güvenle çalıştırır
🔍 Otomatik Dil Algılama Hangi dili konuştuğunu anında anlar
📝 Konuşma Geçmişi Önceki konuşmaları kaydeder

---

🌍 Desteklenen Diller

Dil Kodu Çalışır mı?
Türkçe tr ✅ Tam destek
English en ✅ Full support
Deutsch de ✅ Vollständige Unterstützung
Français fr ✅ Support complet
Русский ru ✅ Полная поддержка
العربية ar ✅ دعم كامل
日本語 ja ✅ 完全サポート

---

💬 Örnek Kullanım

```bash
$ ./deepseek.sh

╔════════════════════════════════════════════════════════╗
║                    DeepSeek iA v2.0                    ║
║              Terminal Yapay Zeka Asistanı              ║
╚════════════════════════════════════════════════════════╝

deepseek@iA:~$ Merhaba
DeepSeek: Merhaba reis! Sana nasıl yardımcı olabilirim?

deepseek@iA:~$ Nasılsın?
DeepSeek: İyiyim reis, sağ ol! Sen nasılsın?

deepseek@iA:~$ Benim adım Ahmet
DeepSeek: Memnun oldum Ahmet! Adını hatırlayacağım.

deepseek@iA:~$ Çalıştır ls -la
DeepSeek: Komut çalıştırılıyor: ls -la
[çıktı burada gösterilir]

deepseek@iA:~$ Hello
DeepSeek: Hello reis! How can I help you today?

deepseek@iA:~$ こんにちは
DeepSeek: こんにちは、友人！お元気ですか？
```

---

📁 Dosya Yapısı

```
deepseek_iA/
├── deepseek.sh          🧠 Ana script (500+ satır)
├── install.sh           ⚙️ Kurulum scripti
├── README.md            📖 Bu dosya
├── languages/           🌍 Dil dosyaları
│   ├── tr.sh            🇹🇷 Türkçe
│   ├── en.sh            🇬🇧 English
│   ├── de.sh            🇩🇪 Deutsch
│   ├── fr.sh            🇫🇷 Français
│   ├── ru.sh            🇷🇺 Русский
│   ├── ar.sh            🇸🇦 العربية
│   └── ja.sh            🇯🇵 日本語
└── data/                📦 Veri dosyaları
    ├── config.cfg       ⚙️ Konfigürasyon
    ├── memory.db        🧠 Hafıza veritabanı
    └── knowledge.txt    📚 Bilgi havuzu
```

---

🛠️ Kurulum Detayları

Gereksinimler

· Bash 4.0+
· Termux veya herhangi bir Linux terminali
· Temel komutlar: grep, sed, awk, cat

Termux için özel kurulum

```bash
pkg update && pkg upgrade
pkg install bash grep sed awk
git clone https://github.com/adimxz/deepseek_iA.git
cd deepseek_iA
chmod +x *.sh
./install.sh
```

Linux için

```bash
sudo apt update
sudo apt install bash
git clone https://github.com/adimxz/deepseek_iA.git
cd deepseek_iA
chmod +x *.sh
./install.sh
```

---

🎯 Komutlar

Komut Ne işe yarar
Merhaba / Selam Selamlaşma
Nasılsın? Durum sorma
Adın ne? Asistanı tanıma
Benim adım X Kendini tanıtma
Çalıştır X Terminal komutu çalıştırma
Teşekkürler Teşekkür etme
Yardım Bu menüyü gösterme
Çık / Exit Programdan çıkma

---

🔧 Yapılandırma

data/config.cfg dosyasını düzenleyerek:

```ini
# Varsayılan dil
LANG=tr

# Kullanıcı adı
USER_NAME=reis

# Duygu durumu
EMOTION=neutral

# Hafıza boyutu (satır)
MEMORY_SIZE=100
```

---

❓ Sık Sorulan Sorular

S: Root gerekiyor mu?
Hayır, root gerektirmez. Normal kullanıcı ile çalışır.

S: İnternet gerekli mi?
Hayır, tamamen çevrimdışı çalışır.

S: Yeni dil eklenebilir mi?
Evet! languages/ klasörüne yeni bir .sh dosyası ekleyerek.

S: Gerçek yapay zeka mı?
Hayır, bu bir eğlence projesidir. Gelişmiş bir şablon eşleştirme ve mantık motorudur.

---

🤝 Katkıda Bulunma

1. Fork'la
2. Yeni branch oluştur (git checkout -b feature/amazing)
3. Değişiklikleri commit et (git commit -m 'Harika özellik eklendi')
4. Push yap (git push origin feature/amazing)
5. Pull Request aç

---

📜 Lisans

MIT License - İstediğin gibi kullan, paylaş, geliştir!

---

⭐ Destek

Beğendiysen yıldız vermeyi unutma! 🌟

---

Yapımcı: @adimxz
Esin kaynağı: DeepSeek AI
Sürüm: 2.0

---

"Bilgi paylaştıkça çoğalır. Açık kaynak ruhuyla..."

```

---

## ✅ **Bu README'nin farkı ne?**

| Özellik | Eski | Yeni |
|---------|------|------|
| Tablolar | ❌ | ✅ |
| Emojiler | Az | Çok |
| Örnek kullanım | Kısa | Detaylı |
| Kurulum adımları | Basit | Termux+Linux ayrı |
| SSŞ (FAQ) | ❌ | ✅ |
| Katkıda bulunma | ❌ | ✅ |
| Lisans | ❌ | ✅ |
| Görsel şema | ❌ | ✅ |

---
