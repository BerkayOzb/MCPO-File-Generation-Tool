# Ubuntu Sunucu Kurulum Rehberi 🇹🇷

Bu rehber, MCPO File Generation Tool'u Ubuntu sunucusunda Türkçe karakter desteğiyle kurmak için hazırlanmıştır.

## 🚀 Hızlı Kurulum

### 1. Sistem Hazırlığı
```bash
# Sistem güncelleme
sudo apt-get update && sudo apt-get upgrade -y

# Git yükleme (eğer yoksa)
sudo apt-get install -y git python3 python3-pip

# Proje indirme
git clone https://github.com/your-repo/MCPO-File-Generation-Tool.git
cd MCPO-File-Generation-Tool
```

### 2. Font Kurulumu (KRİTİK!)
```bash
# Otomatik font kurulum scripti çalıştırma
chmod +x install_fonts.sh
sudo ./install_fonts.sh

# Manuel font kurulum (alternatif)
sudo apt-get install -y fonts-dejavu fonts-liberation fonts-noto fontconfig
sudo fc-cache -fv
```

### 3. Python Bağımlılıkları
```bash
# requirements.txt kullanarak
pip install -r LLM_Export/requirements.txt

# Manuel kurulum
pip install openpyxl reportlab py7zr fastapi uvicorn python-multipart mcp \
            python-pptx python-docx emoji markdown2 beautifulsoup4 requests
```

### 4. Test ve Doğrulama
```bash
# Türkçe karakter testini çalıştır
python3 test_turkish_characters.py

# Beklenen çıktı:
# 🎯 Toplam: 4/4 test başarılı
# 🎉 Tüm testler başarılı! Türkçe karakterler düzgün çalışıyor.
```

## 🐋 Docker ile Kurulum

### Basit Docker Çalıştırma
```bash
# MCPO Docker versiyonu
cd LLM_Export/docker/mcpo
docker build -t mcpo-turkish .
docker run -p 8000:8000 mcpo-turkish

# SSE HTTP versiyonu
cd ../sse_http
docker build -t sse-turkish .
docker run -p 9004:9004 sse-turkish
```

### Docker Compose ile Tam Sistem
```bash
# Ana dizinde
docker-compose up -d

# Log kontrolü
docker-compose logs -f
```

## 🔧 Sorun Giderme

### Problem: "No Unicode fonts could be registered"

**Çözüm 1 - Font Kurulumu:**
```bash
sudo apt-get install fonts-dejavu fonts-liberation fonts-noto
sudo fc-cache -fv
```

**Çözüm 2 - Font Test:**
```bash
# Font varlığı kontrolü
fc-list | grep -i dejavu
fc-list | grep -i liberation
fc-list | grep -i noto

# Eğer boş çıktı alıyorsanız fontlar yüklü değil
sudo ./install_fonts.sh
```

**Çözüm 3 - Manuel Font İndirme:**
```bash
# DejaVu fontları manuel indirme
cd /tmp
wget https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-2.37.tar.bz2
tar -xjf dejavu-fonts-ttf-2.37.tar.bz2
sudo mkdir -p /usr/local/share/fonts/dejavu
sudo cp dejavu-fonts-ttf-2.37/ttf/*.ttf /usr/local/share/fonts/dejavu/
sudo fc-cache -fv
```

### Problem: Permission Denied

**Çözüm:**
```bash
# Uygulama dizini için yetki verme
sudo chown -R $USER:$USER /path/to/MCPO-File-Generation-Tool

# Font dizinleri için yetki kontrolü
ls -la /usr/share/fonts/
ls -la /usr/local/share/fonts/
```

### Problem: PDF'lerde Türkçe Karakterler Görünmüyor

**Kontrol Adımları:**
```bash
# 1. Font kurulumu kontrolü
python3 -c "
import sys
sys.path.insert(0, 'LLM_Export/tools')
from file_export_mcp import find_system_fonts, register_unicode_fonts
fonts = find_system_fonts()
print(f'Bulunan fontlar: {len(fonts)}')
registered = register_unicode_fonts()
print(f'Kayıtlı fontlar: {list(registered.keys())}')
"

# 2. Test dosyası çalıştırma
python3 test_turkish_characters.py

# 3. Log kontrolü
tail -f /var/log/syslog | grep font
```

## 📋 Sistem Gereksinimleri

### Minimum Gereksinimler
- **OS**: Ubuntu 18.04+ / Debian 10+
- **RAM**: 1GB
- **Disk**: 2GB boş alan
- **Python**: 3.8+

### Önerilen Gereksinimler
- **OS**: Ubuntu 22.04 LTS
- **RAM**: 4GB
- **Disk**: 10GB boş alan
- **Python**: 3.11+

## 🔐 Güvenlik Yapılandırması

### Firewall Ayarları
```bash
# Gerekli portları açma
sudo ufw allow 8000/tcp  # MCPO
sudo ufw allow 9003/tcp  # File Server
sudo ufw allow 9004/tcp  # SSE HTTP
sudo ufw enable
```

### SSL/TLS (Üretim için)
```bash
# Certbot ile Let's Encrypt
sudo apt-get install certbot
sudo certbot certonly --standalone -d your-domain.com

# Nginx proxy konfigürasyonu
sudo apt-get install nginx
# nginx.conf düzenle...
```

## 📊 Performans Optimizasyonu

### Sistem Ayarları
```bash
# Python cache temizleme
find . -type d -name __pycache__ -exec rm -rf {} +

# Font cache optimizasyonu
sudo fc-cache -fv

# Disk temizliği
sudo apt-get autoremove
sudo apt-get autoclean
```

### Bellek Yönetimi
```bash
# Swap dosyası oluşturma (2GB)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Kalıcı hale getirme
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

## 🔄 Güncellemeler

### Uygulama Güncelleme
```bash
cd MCPO-File-Generation-Tool
git pull origin main

# Bağımlılık güncellemesi
pip install -r LLM_Export/requirements.txt --upgrade

# Font güncellemesi
sudo ./install_fonts.sh

# Test çalıştırma
python3 test_turkish_characters.py
```

### Sistem Güncellemesi
```bash
# Sistem paketleri
sudo apt-get update && sudo apt-get upgrade -y

# Font paketleri
sudo apt-get install --reinstall fonts-dejavu fonts-liberation fonts-noto
sudo fc-cache -fv
```

## 📞 Destek ve İletişim

### Log Dosyaları
```bash
# Uygulama logları
tail -f output/logs/file_export.log

# Sistem logları
sudo journalctl -f -u your-service-name

# Font debug logları
export LOG_LEVEL=DEBUG
python3 test_turkish_characters.py
```

### Hata Bildirimi
Sorun yaşadığınızda lütfen aşağıdaki bilgileri ekleyin:

1. **Sistem Bilgisi:**
```bash
lsb_release -a
python3 --version
fc-list | wc -l
```

2. **Font Durumu:**
```bash
fc-list | grep -i dejavu
fc-list | grep -i liberation
fc-list | grep -i noto
```

3. **Test Sonucu:**
```bash
python3 test_turkish_characters.py
```

## ✅ Kurulum Doğrulama Listesi

- [ ] Ubuntu sunucu hazır
- [ ] Git ve Python yüklü
- [ ] Proje indirildi
- [ ] Font kurulum scripti çalıştırıldı
- [ ] Python bağımlılıkları yüklendi
- [ ] Türkçe test başarılı (4/4)
- [ ] Portlar açık ve erişilebilir
- [ ] Güvenlik ayarları yapıldı

**Kurulum başarılı olduğunda:**
```
🎉 Tüm testler başarılı! Türkçe karakterler düzgün çalışıyor.
✅ MCPO File Generation Tool kullanıma hazır!
```