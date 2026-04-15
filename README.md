# 🚐 Servis Yolunda (GPS Tracking & Fleet Management)

**Servis Yolunda**, fabrika personelleri ve servis şoförleri arasındaki iletişimi dijitalleştiren, Arvento GPS verileriyle entegre çalışan bir konum takip ve yönetim platformudur. İlk aşamada Kocaeli bölgesindeki fabrikaların servis ağını optimize etmek ve işçilerin duraklarda bekleme süresini minimize etmek amacıyla geliştirilmiştir.

## 🚀 Temel Özellikler

* **Canlı Takip:** Servislerin anlık konumlarını harita üzerinde görüntüleme.
* **Akıllı Bildirimler:** Servis durağa yaklaşınca (örn: son 500 metre) personele otomatik bildirim.
* **Rota Optimizasyonu:** Mevcut Arvento verilerini kullanarak en verimli güzergah analizi.
* **Sürücü Paneli:** Şoförler için basit ve odaklanmış kullanıcı arayüzü.
* **Yönetim Paneli:** Fabrika İK veya lojistik birimleri için detaylı raporlama ve servis doluluk oranları.

## 🛠️ Teknoloji Yığını

* **Backend:** Python / Django
* **Database:** PostgreSQL / PostGIS (Coğrafi veriler için)
* **Real-time:** Redis / Celery (Anlık veri işleme ve scraping için)
* **Frontend:** Bootstrap / JavaScript (Harita entegrasyonu: Leaflet veya Google Maps)
* **Entegrasyon:** Arvento API (GPS Data)

## 📦 Kurulum

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları izleyin:

1.  **Depoyu klonlayın:**
    ```bash
    git clone [https://github.com/alifurkansagir/Servis-Yolunda.git](https://github.com/alifurkansagir/Servis-Yolunda.git)
    cd Servis-Yolunda
    ```

2.  **Sanal ortam oluşturun ve aktif edin:**
    ```bash
    python3 -m venv venv
    source venv/bin/activate  # MacOS/Linux
    # venv\Scripts\activate  # Windows
    ```

3.  **Bağımlılıkları yükleyin:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Veritabanı migration'larını yapın:**
    ```bash
    python manage.py migrate
    ```

5.  **Geliştirme sunucusunu başlatın:**
    ```bash
    python manage.py runserver
    ```

## ⚠️ Güvenlik Uyarısı

Bu proje Google OAuth ve Arvento API anahtarları gibi hassas veriler kullanmaktadır. Lütfen `client_secret_*.json` veya `.env` dosyalarınızı asla GitHub'a pushlamayın. Gerekli tanımlamaları `.env.example` dosyasından bakarak kendi ortamınıza göre yapın.

## 🛡️ Lisans

Bu proje **Sartech Software** bünyesinde geliştirilmektedir. Tüm hakları saklıdır.

---
**Geliştirici:** [Ali Furkan Sağır](https://github.com/alifurkansagir)
