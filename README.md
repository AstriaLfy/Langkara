# 📚 Langkara

**Langkara** adalah aplikasi edukasi berbasis mobile yang memungkinkan pengguna berbagi, membaca, dan berdiskusi tentang berbagai materi pembelajaran. Dibangun sebagai proyek magang Raion Community 2026.

---

## ✨ Fitur-Fitur Aplikasi

### 🏠 Beranda `[MVP]`
- Menampilkan sapaan pengguna dengan avatar
- Fitur **Lanjutkan Membaca** untuk melanjutkan materi terakhir
- Seksi **Berita Terkini** dan **Inspirasi** 
- Navigasi cepat ke pencarian dan chat

### 🔐 Autentikasi `[MVP]`
- Login & Register dengan email dan password
- Login dengan **Google OAuth**
- Fitur **Remember Me** untuk menyimpan sesi
- Fitur **Lupa Password** dengan alur email → OTP → reset password
- Pemilihan avatar saat registrasi

### 📄 Materi `[MVP]`
- Browse dan baca materi dari pengguna lain
- Upload materi baru dengan cover image
- Sistem **Tiket Baca** (2 tiket gratis/hari, bisa tukar 40 XP)
- Detail materi dengan konten lengkap

### 🔍 Pencarian `[MVP]`
- Cari **Teman**, **Berita**, **Materi**, dan **Inspirasi** dalam satu halaman
- Tab-based search results
- Filter dan navigasi langsung ke detail

### 💬 Chat `[MVP]`
- **Chat History** — daftar percakapan dengan preview pesan terakhir, waktu, dan badge unread
- **Room Chat** — percakapan real-time antar pengguna dengan Supabase Realtime
- Indikator pesan dibaca (✓✓)
- Avatar pengguna ditampilkan di setiap percakapan

### 👥 Temanku
- Jelajahi profil pengguna lain dengan tampilan kartu carousel
- Lihat jurusan, universitas, pencapaian, dan kemampuan
- Navigasi ke profil detail dan kirim pesan langsung

### 👤 Profil `[MVP]`
- Tampilan profil lengkap dengan avatar, XP, jurusan, dan universitas
- Edit profil (nama, username, email, jurusan, universitas, gender, kemampuan)
- **Progress bar** kelengkapan profil
- Tab **Materi**, **Pencapaian**, dan **Bookmark**
- Pilih dan ubah avatar dari avatar picker

### 🏆 Pencapaian
- Upload dan tampilkan sertifikat pencapaian
- Detail pencapaian dengan gambar dan deskripsi
- Sistem like dan bookmark pada pencapaian

### 📰 Berita & Inspirasi
- Baca berita terkini seputar pendidikan
- Profil inspirasi dari tokoh-tokoh berprestasi

### ⚙️ Pengaturan
- Edit profil
- Ubah kata sandi
- FAQ & Bantuan
- Logout

### 🎫 Sistem XP & Tiket
- Setiap pengguna mendapat 2 tiket baca gratis per hari (reset otomatis)
- Jika tiket habis, gunakan 40 XP untuk akses materi
- XP ditampilkan pada dialog coin di beranda

---

## 🛠️ Tech Stack

| Teknologi | Keterangan |
|---|---|
| **Flutter** (Dart) | Framework UI cross-platform |
| **Supabase** | Backend-as-a-Service (Auth, Database, Realtime, Storage) |
| **flutter_bloc** | State management berbasis BLoC pattern |
| **supabase_flutter** | Supabase SDK untuk Flutter |
| **google_fonts** | Typography dari Google Fonts |
| **flutter_svg** | Render SVG assets |
| **shared_preferences** | Penyimpanan lokal (Remember Me, sesi) |
| **intl** | Internasionalisasi dan format tanggal |
| **file_picker** & **image_picker** | Upload file dan gambar |
| **flutter_card_swiper** | Carousel kartu di halaman Temanku |
| **url_launcher** | Buka URL eksternal |
| **camera** & **photo_manager** | Akses kamera dan galeri |

---

## 🏗️ Arsitektur Aplikasi

Aplikasi ini menggunakan arsitektur **BLoC (Business Logic Component)** pattern dengan pemisahan layer yang jelas:

```
lib/
├── Bloc/                    # Business Logic Components
│   ├── Auth/                # AuthBloc — Login, Register, Google Sign-In
│   ├── Chat/                # ChatBloc — Percakapan & pesan real-time
│   ├── Ticket/              # TicketBloc — Sistem tiket baca
│   ├── Reading/             # ReadingBloc — Riwayat bacaan
│   ├── search/              # SearchBloc — Pencarian multi-kategori
│   ├── temanku/             # TemankuBloc — Daftar teman
│   ├── Materiku/            # MateriBloc — Materi pengguna
│   └── profile_tab/         # ProfileMateri/Achievement/BookmarkBloc
│
├── Services/                # Data Layer — Interaksi langsung dengan Supabase
│   ├── auth_services.dart
│   ├── chat_service.dart
│   ├── profile_services.dart
│   ├── teman_service.dart
│   ├── ticket_service.dart
│   ├── reading_service.dart
│   ├── berita_service.dart
│   ├── inspirasi_service.dart
│   ├── materi_service.dart
│   └── search_service.dart
│
├── Repository/              # Repository Layer — Abstraksi antara BLoC dan Service
│   ├── auth_repository.dart
│   ├── chat_repository.dart
│   ├── teman_repository.dart
│   └── materi_repository.dart
│
├── Models/                  # Data Models
│   ├── user_model.dart
│   ├── message_model.dart
│   ├── conversation_model.dart
│   ├── materi_model.dart
│   ├── berita_model.dart
│   ├── inspirasi_model.dart
│   ├── achievement_model.dart
│   └── teman_profile_model.dart
│
├── Pages/                   # UI Pages
│   ├── home_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── navigation_menu.dart
│   ├── profile_page.dart
│   ├── profile_detail_page.dart
│   ├── temanku_page.dart
│   ├── chat_history_page.dart
│   ├── room_chat_page.dart
│   ├── search_page.dart
│   ├── upload_page.dart
│   └── Widgets/             # Komponen UI reusable
│
├── const/                   # Konstanta aplikasi
│   ├── colors.dart
│   └── avatars.dart
│
└── main.dart                # Entry point aplikasi
```

### Alur Data

```
UI (Pages) → BLoC (Events/States) → Repository → Service → Supabase
```

1. **Pages** mengirim **Event** ke BLoC
2. **BLoC** memproses logic bisnis dan memanggil **Repository**
3. **Repository** mendelegasikan ke **Service**
4. **Service** berkomunikasi langsung dengan **Supabase** (Auth, Database, Realtime, Storage)
5. Hasil dikembalikan sebagai **State** baru ke UI

---

## 📱 Platform yang Didukung

| Platform | Status |
|---|---|
| **Android** | ✅ Didukung penuh |
| **iOS** | ✅ Didukung (konfigurasi tersedia) |
| **Web** | ⚠️ Belum dioptimasi |

> **Catatan:** Aplikasi ini dikembangkan dan diuji utama pada platform **Android**. Konfigurasi iOS tersedia namun mungkin memerlukan pengaturan tambahan (signing, capabilities). Platform Web belum dioptimasi untuk produksi.

---

## 🚀 Cara Menjalankan

```bash
# Clone repository
git clone <repository-url>
cd Langkara

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

> **Prasyarat:** Flutter SDK ^3.8.1, Dart SDK, dan koneksi ke instance Supabase yang telah dikonfigurasi.

---

## 👥 Tim Pengembang

Mohammad Rozan Hanan
Andrew William Smith
