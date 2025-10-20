#!/bin/bash
# Font Installation Script for Ubuntu/Debian
# Installs necessary fonts for Turkish character support in MCPO File Generation Tool

set -e

echo "🇹🇷 MCPO Türkçe Font Kurulum Scripti"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    SUDO=""
    print_warning "Root kullanıcısı olarak çalışıyorsunuz."
else
    SUDO="sudo"
    print_status "Sudo kullanılacak."
fi

# Detect OS
print_step "İşletim sistemi tespit ediliyor..."

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
    print_status "Tespit edilen OS: $PRETTY_NAME"
else
    print_error "İşletim sistemi tespit edilemedi!"
    exit 1
fi

# Check if it's Ubuntu/Debian based
if [[ ! "$OS" =~ ^(ubuntu|debian)$ ]]; then
    print_warning "Bu script Ubuntu/Debian için optimize edilmiştir. ($OS tespit edildi)"
    read -p "Devam etmek istiyor musunuz? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update package list
print_step "Paket listesi güncelleniyor..."
$SUDO apt-get update -qq

# Install font packages
print_step "Türkçe karakter destekli fontlar yükleniyor..."

FONT_PACKAGES=(
    "fonts-dejavu"
    "fonts-dejavu-core"
    "fonts-dejavu-extra"
    "fonts-liberation"
    "fonts-liberation2"
    "fonts-noto"
    "fonts-noto-core"
    "ttf-mscorefonts-installer"
    "fontconfig"
    "fc-cache"
)

for package in "${FONT_PACKAGES[@]}"; do
    print_status "Yükleniyor: $package"
    if $SUDO apt-get install -y "$package" > /dev/null 2>&1; then
        echo -e "  ${GREEN}✅${NC} $package başarıyla yüklendi"
    else
        echo -e "  ${YELLOW}⚠️${NC} $package yüklenemedi (zaten yüklü olabilir)"
    fi
done

# Accept Microsoft font license automatically
print_step "Microsoft fontları için lisans kabul ediliyor..."
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | $SUDO debconf-set-selections

# Update font cache
print_step "Font önbelleği güncelleniyor..."
$SUDO fc-cache -fv > /dev/null 2>&1
print_status "Font önbelleği güncellendi"

# Check if fonts are available
print_step "Yüklenen fontlar kontrol ediliyor..."

check_font() {
    local font_name="$1"
    if fc-list | grep -i "$font_name" > /dev/null 2>&1; then
        echo -e "  ${GREEN}✅${NC} $font_name bulundu"
        return 0
    else
        echo -e "  ${RED}❌${NC} $font_name bulunamadı"
        return 1
    fi
}

REQUIRED_FONTS=(
    "DejaVu Sans"
    "Liberation Sans"
    "Noto Sans"
)

FONT_CHECK_PASSED=true

for font in "${REQUIRED_FONTS[@]}"; do
    if ! check_font "$font"; then
        FONT_CHECK_PASSED=false
    fi
done

# Install additional fonts if needed
if ! $FONT_CHECK_PASSED; then
    print_step "Eksik fontlar için ek kurulum yapılıyor..."
    
    # Download and install DejaVu fonts manually if not found
    if ! check_font "DejaVu Sans"; then
        print_status "DejaVu fontları manuel olarak yükleniyor..."
        cd /tmp
        wget -q https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-2.37.tar.bz2
        tar -xjf dejavu-fonts-ttf-2.37.tar.bz2
        $SUDO mkdir -p /usr/local/share/fonts/dejavu
        $SUDO cp dejavu-fonts-ttf-2.37/ttf/*.ttf /usr/local/share/fonts/dejavu/
        rm -rf dejavu-fonts-*
    fi
    
    # Update font cache again
    $SUDO fc-cache -fv > /dev/null 2>&1
fi

# Final verification
print_step "Final font kontrolü yapılıyor..."
ALL_FONTS_OK=true

for font in "${REQUIRED_FONTS[@]}"; do
    if ! check_font "$font"; then
        ALL_FONTS_OK=false
    fi
done

# Create font test script
print_step "Font test scripti oluşturuluyor..."
cat > font_test.py << 'EOF'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import os

# Test font availability
def test_fonts():
    try:
        from reportlab.pdfbase import pdfmetrics
        from reportlab.pdfbase.ttfonts import TTFont
        import platform
        
        system = platform.system()
        font_dirs = []
        
        if system == "Linux":
            font_dirs = [
                "/usr/share/fonts",
                "/usr/local/share/fonts",
                "/System/Library/Fonts",
                os.path.expanduser("~/.fonts"),
                os.path.expanduser("~/.local/share/fonts")
            ]
        
        preferred_fonts = [
            "DejaVuSans.ttf", "DejaVuSans-Bold.ttf",
            "LiberationSans-Regular.ttf", "LiberationSans-Bold.ttf",
            "NotoSans-Regular.ttf", "NotoSans-Bold.ttf"
        ]
        
        found_fonts = []
        for font_dir in font_dirs:
            if os.path.exists(font_dir):
                for root, dirs, files in os.walk(font_dir):
                    for font_name in preferred_fonts:
                        if font_name.lower() in [f.lower() for f in files]:
                            font_path = os.path.join(root, font_name)
                            found_fonts.append((font_name, font_path))
        
        print(f"✅ {len(found_fonts)} Türkçe destekli font bulundu:")
        for font_name, font_path in found_fonts[:5]:  # Show first 5
            print(f"   📝 {font_name}")
            
        return len(found_fonts) > 0
        
    except ImportError:
        print("❌ ReportLab yüklü değil. 'pip install reportlab' çalıştırın.")
        return False
    except Exception as e:
        print(f"❌ Font test hatası: {e}")
        return False

if __name__ == "__main__":
    print("🔍 Font Kullanılabilirlik Testi")
    print("=" * 30)
    success = test_fonts()
    sys.exit(0 if success else 1)
EOF

chmod +x font_test.py

# Test if Python and reportlab are available
if command -v python3 > /dev/null && python3 -c "import reportlab" 2> /dev/null; then
    print_step "Python font testi yapılıyor..."
    if python3 font_test.py; then
        print_status "Python font testi başarılı!"
    else
        print_warning "Python font testi başarısız oldu."
    fi
else
    print_warning "Python3 veya ReportLab bulunamadı. Font testi atlanıyor."
fi

# Summary
echo
echo "📋 KURULUM ÖZET"
echo "================"

if $ALL_FONTS_OK; then
    print_status "✅ Tüm gerekli fontlar başarıyla yüklendi!"
    print_status "✅ Türkçe karakterler artık düzgün görüntülenecek."
    print_status "✅ MCPO File Generation Tool kullanıma hazır!"
else
    print_warning "⚠️  Bazı fontlar yüklenemedi, ancak sistem çalışacak."
    print_warning "⚠️  Daha iyi sonuçlar için fontları manuel kontrol edin."
fi

echo
print_status "Kurulum tamamlandı! MCPO servisinizi yeniden başlatabilirsiniz."
print_status "Test için: python3 font_test.py"

# Cleanup
rm -f font_test.py

exit 0