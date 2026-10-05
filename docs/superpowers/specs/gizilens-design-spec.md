```json
{
  "questions": [
    {
      "id": "state_management",
      "targetSection": "constraints",
      "question": "Pendekatan atau library state management apa yang ingin digunakan pada project Flutter ini untuk mengelola state visual dan alur UI (misal: flutter_riverpod, flutter_bloc, atau provider)?",
      "options": [
        "flutter_riverpod (StateNotifier / AsyncNotifier)",
        "flutter_bloc (Bloc / Cubit)",
        "provider (ChangeNotifier)"
      ]
    },
    {
      "id": "auth_initial_route",
      "targetSection": "user_flows",
      "question": "Karena autentikasi berstatus opsional (toggleable), bagaimana alur navigasi default yang aktif saat prototipe UI pertama kali dijalankan dari Splash?",
      "options": [
        "Auth Aktif: Splash -> Login / Register -> Onboarding -> Profile Setup -> Home",
        "Auth Nonaktif: Splash -> Onboarding -> Profile Setup -> Home (layar Login/Register tetap dapat diakses terpisah via Profil)"
      ]
    },
    {
      "id": "video_timer_duration",
      "targetSection": "constraints",
      "question": "Pada viewfinder kamera saat mode Video aktif, berapa batas durasi maksimal untuk countdown timer dan auto-stop yang ingin ditampilkan pada UI?",
      "options": [
        "15 detik",
        "30 detik",
        "60 detik"
      ]
    },
    {
      "id": "portion_input_interaction",
      "targetSection": "scope UI",
      "question": "Pada bottom sheet Ubah Porsi (PortionEditSheet), bagaimana kontrol interaksi yang diinginkan untuk penyesuaian jumlah porsi makanan?",
      "options": [
        "Input teks numerik langsung + Dropdown satuan",
        "Tombol stepper inkremen/dekremen (+/-) + Dropdown satuan",
        "Kombinasi input teks numerik dan tombol stepper (+/-) + Dropdown satuan"
      ]
    }
  ]
}
```