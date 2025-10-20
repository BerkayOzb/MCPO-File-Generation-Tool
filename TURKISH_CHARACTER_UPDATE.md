# Türkçe Karakter Desteği - Sürüm Güncelleme Notları

## 🎉 Yeni Özellikler (v0.7.1)

### ✅ Tam Türkçe Karakter Desteği
- **PDF**, **Word**, **Excel** ve **PowerPoint** formatlarında eksiksiz Türkçe karakter desteği
- Tüm Türkçe karakterler: **ç, ğ, ı, i, ö, ş, ü** ve büyük harfleri
- Otomatik font tespit ve yükleme sistemi

### 🔧 Teknik İyileştirmeler

#### Font Yönetimi
- **Akıllı Font Tespit**: Sistem fontlarını otomatik bulma ve kaydetme
- **Multi-Platform Destek**: Windows, macOS ve Linux için optimize edilmiş
- **Fallback Sistemi**: Font bulunamadığında güvenli alternatiflere geçiş
- **Performans Optimizasyonu**: Font aramada derinlik sınırı ve cache sistemi

#### Güncellenen Dosyalar
- `LLM_Export/tools/file_export_mcp.py`
- `LLM_Export/docker/mcpo/tools/file_export_mcp.py`
- `LLM_Export/docker/sse_http/tools/file_export_mcp.py`

#### Yeni Dosyalar
- `install_fonts.sh` - Otomatik font kurulum scripti
- `test_turkish_characters.py` - Türkçe karakter test aracı
- `UBUNTU_DEPLOYMENT_GUIDE.md` - Ubuntu sunucu kurulum rehberi
- `TURKISH_CHARACTER_FIX.md` - Teknik detay dokümantasyonu

### 🐋 Docker İyileştirmeleri
- **Tüm Dockerfile'lar güncellendi** font desteği ile
- DejaVu, Liberation ve Noto fontları otomatik yükleniyor
- Font cache optimizasyonu eklendi

### 📋 Test Sistemi
- **Kapsamlı test suite** tüm formatları doğruluyor
- **Gerçek zamanlı font kontrolü** ve raporlama
- **Başarı metrikleri**: 4/4 format testinden geçiyor

## 🛠️ Kurulum

### Hızlı Kurulum (Ubuntu/Debian)
```bash
# Font kurulumu
sudo ./install_fonts.sh

# Test çalıştırma
python3 test_turkish_characters.py
```

### Docker ile
```bash
# Dockerfile'lar artık fontları otomatik yükler
docker build -t mcpo-turkish .
docker run -p 8000:8000 mcpo-turkish
```

## 📊 Test Sonuçları

### Önceki Durum ❌
```
WARNING: No Unicode fonts could be registered, falling back to default fonts
```

### Yeni Durum ✅
```
INFO: Found 2 unique Turkish-compatible fonts
INFO: ✅ Registered font: DejaVuSans from DejaVuSans.ttf
INFO: ✅ Registered font: DejaVuSans_Bold from DejaVuSans-Bold.ttf
INFO: 🎯 Successfully registered 2 Unicode fonts
🎉 Tüm testler başarılı! Türkçe karakterler düzgün çalışıyor.
```

## 🔄 Mevcut Kurulumları Güncelleme

### 1. Kod Güncelleme
```bash
git pull origin main
```

### 2. Font Kurulumu
```bash
chmod +x install_fonts.sh
sudo ./install_fonts.sh
```

### 3. Python Paketlerini Güncelleme
```bash
pip install -r LLM_Export/requirements.txt --upgrade
```

### 4. Test Çalıştırma
```bash
python3 test_turkish_characters.py
```

### 5. Docker Yeniden Build (Docker kullanıyorsanız)
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 🐛 Bilinen Sorunlar ve Çözümler

### "No Unicode fonts could be registered" Hatası
**Çözüm**:
```bash
sudo apt-get install fonts-dejavu fonts-liberation fonts-noto
sudo fc-cache -fv
# Ardından uygulamayı yeniden başlatın
```

### Font Yolu Erişim Sorunları
**Çözüm**:
```bash
# Font dizinlerinin yetkilerini kontrol edin
ls -la /usr/share/fonts/
sudo chmod 755 /usr/share/fonts/
sudo chmod 644 /usr/share/fonts/**/*.ttf
```

### Docker Container'da Font Eksikliği
**Çözüm**: Güncel Dockerfile'ları kullanın (otomatik font yüklemeli)

## 🔮 Gelecek Güncellemeler

### v0.7.2 (Planlanan)
- [ ] Diğer dil desteği (Arapça, Çince, vb.)
- [ ] Font cache performans iyileştirmesi
- [ ] Custom font yükleme API'si
- [ ] Font preview özelliği

### v0.8.0 (Planlanan)
- [ ] RTL (Right-to-Left) text desteği
- [ ] Advanced typography özellikler
- [ ] Font embedding seçenekleri

## 📞 Destek

### Sorun Bildirimi
Türkçe karakter sorunları için:
1. `python3 test_turkish_characters.py` çıktısını ekleyin
2. `fc-list | grep -i dejavu` sonucunu paylaşın
3. İşletim sistemi ve Python versiyonunu belirtin

### Başarılı Kurulum Kontrolü
```bash
# Bu komutların hepsi başarılı olmalı:
fc-list | grep -i dejavu
python3 test_turkish_characters.py
# Çıktı: 🎉 Tüm testler başarılı!
```

---

**Geliştirici Notu**: Bu güncelleme, kullanıcı feedback'leri doğrultusunda Türkçe karakter desteği eksikliğini tamamen gidermek için geliştirilmiştir. Tüm formatlar kapsamlı olarak test edilmiş ve Ubuntu sunucu ortamlarında stabil çalışması sağlanmıştır.