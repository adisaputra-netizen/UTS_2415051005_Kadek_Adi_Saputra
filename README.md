# dapur_dewata

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Dapur Dewata - Aplikasi Resep Masakan Khas Bali

Aplikasi mobile katalog resep autentik Bali berbasis Flutter yang memadukan integrasi REST API dataset masakan Bali, arsitektur manajemen state Provider, serta persistensi database backend Supabase untuk pencatatan modifikasi resep oleh pengguna.

Proyek ini disusun guna memenuhi evaluasi Ujian Tengah Semester (UTS) mata kuliah Pemrograman Mobile.

---

## 📌 Identitas Pengembang
- **Nama** : Kadek Adi Saputra
- **NIM** : 2415051005
- **Program Studi** : Pendidikan Teknik Informatika
- **Universitas** : Universitas Pendidikan Ganesha
- **Repositori** : [UTS_2415051005_Kadek_Adi_Saputra](https://github.com/adisaputra-netizen/UTS_2415051005_Kadek_Adi_Saputra)

---

## 🚀 Fitur Utama & Spesifikasi Teknis

### 1. Katalog Resep Autentik (REST API Integration)
- Mengonsumsi endpoint REST API publik berbasis file JSON mandiri pada repositori GitHub.
- Parsing respon JSON dinamis ke Dart Model `BalineseRecipe` dengan *null safety*.
- Penanganan 4 kondisi UI: **Loading state** (indikator putar), **Data state** (grid/list resep), **Empty state**, dan **Error state** (dilengkapi tombol coba lagi).
- Fitur penelusuran resep berdasarkan nama dan filter kategori masakan.

### 2. Catatan Kreasi Masak Pribadi (Full CRUD Backend Supabase)
- **Create**: Formulir input catatan resep dengan validasi teks, pilihan kategori, tingkat kesulitan, rating bintang (1–5), dan tips bumbu ke tabel Supabase `user_recipe_notes`.
- **Read**: Pengambilan dan penampilan daftar catatan resep pengguna yang difilter berdasarkan identifier mahasiswa (`nim`).
- **Update**: Pembaruan catatan tips memasak, rating, atau tingkat kesulitan secara langsung ke database.
- **Delete**: Penghapusan baris catatan dari database dengan konfirmasi dialog modal (`AlertDialog`) untuk mencegah penghapusan tidak disengaja.

### 3. State Management Terpusat
- Arsitektur berbasis **Provider** dan `ChangeNotifier`.
- Pemisahan tanggung jawab (*separation of concerns*) melalui:
  - `RecipeProvider`: Mengelola status loading, error, data resep, kategori filter aktif, dan daftar favorit (*shared state*).
  - `UserRecipeProvider`: Mengelola status siklus data dan sinkronisasi CRUD catatan masak.

### 4. Desain UI & Layout Responsif
- **Palet Warna Khas Bali**:
  - Primary: *Terracotta Red* (`#8D3028`)
  - Background: *Warm Cream* (`#F4EBDD`)
  - Accent: *Balinese Gold* (`#D5A34A`)
  - Secondary: *Herbal Green* (`#526B45`)
  - Text: *Dark Espresso* (`#302923`)
- **Adaptif Multi-Perangkat**:
  - Tampilan layar ponsel (*Compact*): Menggunakan `BottomNavigationBar` dan single-column list.
  - Tampilan tablet/layar lebar (*Wide*): Menggunakan `NavigationRail` dan responsive grid adaptif.

---

## 🏗️ Struktur Arsitektur Folder

Aplikasi menerapkan pola arsitektur berlapis:
```text
lib/
├── models/
│   ├── balinese_recipe.dart         # Model JSON API Resep
│   └── user_recipe_note.dart        # Model Data Catatan Supabase
├── providers/
│   ├── recipe_provider.dart         # State Management Katalog Resep
│   └── user_recipe_provider.dart    # State Management Catatan Supabase
├── repositories/
│   ├── recipe_repository.dart       # Abstraksi data katalog resep
│   └── user_recipe_repository.dart  # Abstraksi data catatan resep
├── services/
│   ├── api_service.dart             # HTTP Client untuk REST API
│   └── supabase_service.dart        # Klien Supabase DB & Query CRUD
├── screens/
│   ├── home_screen.dart             # Layar Beranda utama & Hero banner
│   ├── recipe_list_screen.dart      # Layar Katalog & Pencarian Resep
│   ├── recipe_detail_screen.dart    # Layar Detail Bahan & Langkah Masak
│   ├── saved_recipes_screen.dart    # Layar Daftar Catatan Masak Pengguna
│   ├── add_recipe_note_screen.dart  # Layar Tambah Catatan (Create)
│   ├── edit_recipe_note_screen.dart # Layar Ubah Catatan (Update)
│   ├── profile_screen.dart          # Layar Profil Pengembang
│   └── main_navigation_screen.dart  # Shell Navigasi Responsif
├── widgets/
│   ├── responsive_recipe_grid.dart  # Widget grid adaptif Compact vs Wide
│   └── state_feedback_widget.dart   # Reusable feedback Loading/Error/Empty
└── main.dart                        # Entrypoint & Dependency Injection


## 🗄️ Skema Database Supabase

Tabel: `public.user_recipe_notes`

| Nama Kolom | Tipe Data | Deskripsi |
| :--- | :--- | :--- |
| `id` | `BIGINT (PK)` | Identitas unik catatan (Identity auto-increment) |
| `nim` | `VARCHAR(20)` | Nomor Induk Mahasiswa (`2415051005`) |
| `recipe_name` | `VARCHAR(150)` | Nama hidangan resep |
| `category` | `VARCHAR(50)` | Kategori olahan kuliner |
| `cooking_note` | `TEXT` | Catatan modifikasi atau pengalaman masak |
| `difficulty` | `VARCHAR(30)` | Tingkat kesulitan olahan (Mudah / Menengah / Sulit) |
| `personal_rating`| `INT` | Rating kepuasan rasa (1–5 bintang) |
| `created_at` | `TIMESTAMPTZ` | Timestamp pencatatan otomatis di server |