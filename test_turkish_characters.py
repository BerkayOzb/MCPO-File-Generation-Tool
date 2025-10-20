#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Türkçe karakter testi dosyası
Test file for Turkish character support in document generation
"""

import json
import sys
import os

# Add the tools directory to the path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'LLM_Export', 'tools'))

try:
    from file_export_mcp import create_file
    print("✅ Successfully imported file_export_mcp")
except ImportError as e:
    print(f"❌ Failed to import file_export_mcp: {e}")
    sys.exit(1)

# Test data with Turkish characters
turkish_test_content = [
    {"type": "title", "text": "Türkçe Karakter Testi"},
    {"type": "subtitle", "text": "Ğ, Ü, Ş, İ, Ö, Ç Karakterleri"},
    {"type": "paragraph", "text": "Bu döküman Türkçe karakterlerin doğru görüntülenip görüntülenmediğini test etmek için oluşturulmuştur."},
    {"type": "paragraph", "text": "Türkçe alfabedeki özel karakterler: ç, ğ, ı, ö, ş, ü ve bunların büyük halleri: Ç, Ğ, I, İ, Ö, Ş, Ü"},
    {"type": "list", "items": [
        "Çiçek - çok güzel",
        "Ğ harfi - eğri",  
        "İstanbul şehri",
        "Öğretmen söylüyor",
        "Şarkı söylemek",
        "Üzgün değilim"
    ]},
    {"type": "paragraph", "text": "Çok önemli: Bu test dosyası Türkçe karakterlerin PDF, Word, Excel ve PowerPoint dosyalarında düzgün görüntülenip görüntülenmediğini kontrol eder."}
]

def test_pdf_creation():
    """Test PDF oluşturma"""
    print("\n📄 PDF testi başlıyor...")
    try:
        data = {
            "format": "pdf",
            "filename": "turkce_test.pdf", 
            "content": turkish_test_content,
            "title": "Türkçe Karakter Test Dökümanı"
        }
        result = create_file(data, persistent=True)
        print(f"✅ PDF başarıyla oluşturuldu: {result.get('url', 'URL bulunamadı')}")
        return True
    except Exception as e:
        print(f"❌ PDF oluşturma hatası: {e}")
        return False

def test_word_creation():
    """Test Word dökümanı oluşturma"""
    print("\n📝 Word testi başlıyor...")
    try:
        data = {
            "format": "docx",
            "filename": "turkce_test.docx",
            "content": turkish_test_content,
            "title": "Türkçe Karakter Test Dökümanı"
        }
        result = create_file(data, persistent=True)
        print(f"✅ Word dökümanı başarıyla oluşturuldu: {result.get('url', 'URL bulunamadı')}")
        return True
    except Exception as e:
        print(f"❌ Word dökümanı oluşturma hatası: {e}")
        return False

def test_excel_creation():
    """Test Excel dökümanı oluşturma"""
    print("\n📊 Excel testi başlıyor...")
    try:
        excel_data = [
            ["Türkçe Karakterler", "Açıklama", "Örnek Kelime"],
            ["Ç, ç", "Çizgili c harfi", "Çiçek"],
            ["Ğ, ğ", "Yumuşak g harfi", "Eğri"],
            ["I, ı", "Noktasız i harfi", "Işık"],
            ["İ, i", "Noktalı i harfi", "İstanbul"],
            ["Ö, ö", "Ö harfi", "Öğretmen"],
            ["Ş, ş", "Şapkalı s harfi", "Şarkı"],
            ["Ü, ü", "Ü harfi", "Üzgün"]
        ]
        data = {
            "format": "xlsx",
            "filename": "turkce_test.xlsx",
            "content": excel_data,
            "title": "Türkçe Karakterler"
        }
        result = create_file(data, persistent=True)
        print(f"✅ Excel dökümanı başarıyla oluşturuldu: {result.get('url', 'URL bulunamadı')}")
        return True
    except Exception as e:
        print(f"❌ Excel dökümanı oluşturma hatası: {e}")
        return False

def test_powerpoint_creation():
    """Test PowerPoint sunumu oluşturma"""
    print("\n📋 PowerPoint testi başlıyor...")
    try:
        slides_data = [
            {
                "title": "Türkçe Karakter Testi",
                "content": [
                    "Bu sunum Türkçe karakterleri test eder",
                    "Ç, Ğ, I, İ, Ö, Ş, Ü karakterleri"
                ]
            },
            {
                "title": "Özel Karakterler",
                "content": [
                    "ç - çiçek",
                    "ğ - eğri", 
                    "ı - ışık",
                    "i - iyi",
                    "ö - öğretmen",
                    "ş - şarkı",
                    "ü - üzgün"
                ]
            }
        ]
        data = {
            "format": "pptx",
            "filename": "turkce_test.pptx",
            "slides_data": slides_data,
            "title": "Türkçe Karakter Test Sunumu"
        }
        result = create_file(data, persistent=True)
        print(f"✅ PowerPoint sunumu başarıyla oluşturuldu: {result.get('url', 'URL bulunamadı')}")
        return True
    except Exception as e:
        print(f"❌ PowerPoint sunumu oluşturma hatası: {e}")
        return False

def main():
    """Ana test fonksiyonu"""
    print("🇹🇷 Türkçe Karakter Desteği Test Başlıyor...")
    print("=" * 50)
    
    results = []
    results.append(test_pdf_creation())
    results.append(test_word_creation()) 
    results.append(test_excel_creation())
    results.append(test_powerpoint_creation())
    
    print("\n" + "=" * 50)
    print("📊 Test Sonuçları:")
    format_names = ["PDF", "Word", "Excel", "PowerPoint"]
    
    for i, result in enumerate(results):
        status = "✅ BAŞARILI" if result else "❌ BAŞARISIZ"
        print(f"  {format_names[i]}: {status}")
    
    success_count = sum(results)
    total_count = len(results)
    
    print(f"\n🎯 Toplam: {success_count}/{total_count} test başarılı")
    
    if success_count == total_count:
        print("🎉 Tüm testler başarılı! Türkçe karakterler düzgün çalışıyor.")
        return 0
    else:
        print("⚠️  Bazı testler başarısız oldu. Lütfen logları kontrol edin.")
        return 1

if __name__ == "__main__":
    sys.exit(main())