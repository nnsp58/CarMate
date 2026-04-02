# 🚗 RideOn — Saath Chalein, Saath Bachayein

A **carpooling / ride-sharing** mobile app built with Flutter & Supabase.

## ✨ Features

- **Ride Publishing** — Drivers offer empty seats on their route
- **Ride Search** — Passengers find rides by location, date & time
- **Real-time Chat** — In-app messaging between driver & passenger
- **Seat Booking** — Race-condition-safe booking via Supabase RPC
- **SOS Alerts** — Emergency button with real-time admin monitoring
- **Road Reports** — Community-reported traffic, accidents, hazards
- **Document Verification** — DL & RC upload with admin approval
- **Push Notifications** — OneSignal-powered alerts
- **Admin Panel** — Flutter Web dashboard for user/ride/SOS management
- **Hindi-English UI** — Localized for Indian users (Hinglish)

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.x (Dart) |
| Backend | Supabase (PostgreSQL + Auth + Storage + Realtime) |
| Maps | OpenStreetMap + Photon + OSRM |
| State Management | Riverpod |
| Navigation | GoRouter (ShellRoute) |
| Push Notifications | OneSignal |
| Code Generation | Freezed + json_serializable |

## 📂 Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart               # MaterialApp, theme
├── core/                  # Constants, theme, router, utils
├── models/                # Freezed data models
├── services/              # Supabase integration layer
├── providers/             # Riverpod state management
├── screens/               # UI screens by feature
├── widgets/               # Reusable components
└── l10n/                  # Hindi + English localization
```

## 🚀 Setup

1. **Clone & install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Create `.env` file** in project root:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_anon_key
   ONESIGNAL_APP_ID=your_onesignal_id
   ```

3. **Run the database schema** in Supabase SQL Editor:
   ```bash
   # Use database_schema.sql
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📱 Screens

- Splash → Welcome → Login/Signup → OTP
- Profile Setup → Vehicle Setup
- Home (Map) → Search Rides → Ride Details → Book
- Publish Ride → My Rides → Ride Passengers
- My Bookings → Booking Detail
- Inbox → Chat
- Profile → Edit Profile → Documents
- Notifications → Reports
- Admin: Dashboard, Users, Documents, SOS, Rides

## 📄 License

Private project — All rights reserved.
