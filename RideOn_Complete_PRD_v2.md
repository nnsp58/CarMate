# RideOn — Complete Project PRD & MCP Prompt
### Fresh Flutter + Supabase Project | Car Pooling App

> **Yeh ek naya project hai — pehle wale broken code se koi connection nahi.**
> Is PRD ko apne MCP server (Cursor / Windsurf / Claude Code) mein paste karo.
> Ek baar mein poora project banana hai — clean, working, production-ready.

---

## CONTEXT & BACKGROUND

Pehla project TestSprite MCP ne barbad kar diya tha — usne ek hi screen ki
4-5 duplicate files bana di thi aur state management puri tarah tooti hui thi.
Isliye ab ek bilkul naya Flutter project banana hai. Backend ke liye Firebase
nahi balki **Supabase** use karenge kyunki yeh completely free hai aur
Flutter ke saath bahut achha kaam karta hai.

**Free Tier Limits (Supabase):**
- 500 MB PostgreSQL database
- 1 GB file storage
- 50,000 active users per month
- Unlimited API requests
- Realtime subscriptions included
- Auth (email, phone, OTP) included

---

## APP SUMMARY

**App Name:** RideOn
**Tagline:** Saath chalein, saath bachayein
**Type:** Car Pooling / Ride Sharing
**Platforms:** Android + iOS (Flutter Mobile)
**Admin Panel:** Flutter Web (same codebase, alag entry point)
**Backend:** Supabase (free tier)
**Language:** Hindi-English mixed UI (Hinglish)

**Core Idea:**
- **Driver** apni car mein khali seats offer karta hai ek route par
- **Passenger** apne route par available rides dhundhta hai aur seat book karta hai
- Dono log paise bachate hain, traffic kam hota hai, environment better hota hai

---

## TECH STACK — SAB KUCH FREE

```
Frontend (Mobile):    Flutter 3.x (Dart)
Frontend (Admin Web): Flutter Web (same project, /admin route)
Backend:              Supabase (supabase.com — free tier)
Database:             PostgreSQL (Supabase ke andar)
Auth:                 Supabase Auth (email + OTP)
File Storage:         Supabase Storage
Realtime:             Supabase Realtime (WebSocket)
Maps:                 Google Maps Flutter (free quota)
Push Notifications:   OneSignal (free tier — 10,000 subscribers)
State Management:     Riverpod (flutter_riverpod)
```

---

## PROJECT STRUCTURE — EK BAAR MEIN BANAO

```
rideon/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── app.dart                     # MaterialApp, routes, theme
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart      # Brand colors
│   │   │   ├── app_strings.dart     # Text strings
│   │   │   └── supabase_constants.dart  # Table names, bucket names
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Light theme
│   │   ├── router/
│   │   │   └── app_router.dart      # GoRouter routes
│   │   └── utils/
│   │       ├── validators.dart      # Form validators
│   │       └── date_formatter.dart  # Date/time helpers
│   │
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── ride_model.dart
│   │   ├── booking_model.dart
│   │   ├── message_model.dart
│   │   ├── sos_alert_model.dart
│   │   └── road_report_model.dart
│   │
│   ├── services/
│   │   ├── supabase_service.dart    # Supabase client singleton
│   │   ├── auth_service.dart        # Login, Signup, OTP
│   │   ├── ride_service.dart        # Ride CRUD
│   │   ├── booking_service.dart     # Booking logic
│   │   ├── storage_service.dart     # File upload/download
│   │   ├── chat_service.dart        # Real-time messaging
│   │   ├── sos_service.dart         # SOS alerts
│   │   ├── report_service.dart      # Road reports
│   │   └── notification_service.dart # OneSignal
│   │
│   ├── providers/                   # Riverpod providers
│   │   ├── auth_provider.dart
│   │   ├── ride_provider.dart
│   │   ├── booking_provider.dart
│   │   └── chat_provider.dart
│   │
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── auth/
│   │   │   ├── welcome_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   └── otp_screen.dart
│   │   ├── onboarding/
│   │   │   ├── profile_setup_screen.dart
│   │   │   └── vehicle_setup_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── search/
│   │   │   ├── search_rides_screen.dart
│   │   │   └── ride_details_screen.dart
│   │   ├── publish/
│   │   │   └── publish_ride_screen.dart
│   │   ├── bookings/
│   │   │   ├── my_bookings_screen.dart
│   │   │   └── booking_detail_screen.dart
│   │   ├── rides/
│   │   │   ├── my_rides_screen.dart
│   │   │   └── ride_passengers_screen.dart
│   │   ├── chat/
│   │   │   ├── inbox_screen.dart
│   │   │   └── chat_screen.dart
│   │   ├── profile/
│   │   │   ├── profile_screen.dart
│   │   │   ├── edit_profile_screen.dart
│   │   │   └── documents_screen.dart
│   │   ├── notifications/
│   │   │   └── notifications_screen.dart
│   │   ├── reports/
│   │   │   └── report_history_screen.dart
│   │   └── admin/
│   │       ├── admin_shell.dart
│   │       ├── admin_dashboard_screen.dart
│   │       ├── admin_users_screen.dart
│   │       ├── admin_documents_screen.dart
│   │       ├── admin_sos_screen.dart
│   │       └── admin_rides_screen.dart
│   │
│   └── widgets/                     # Reusable widgets
│       ├── ride_card.dart
│       ├── booking_card.dart
│       ├── user_avatar.dart
│       ├── sos_button.dart
│       ├── loading_overlay.dart
│       └── empty_state.dart
│
├── supabase/
│   └── schema.sql                   # Poora database schema
│
└── pubspec.yaml
```

---

## SUPABASE DATABASE SCHEMA

### `pubspec.yaml` packages pehle:

```yaml
name: rideon
description: RideOn - Car Pooling App

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter

  # Backend
  supabase_flutter: ^2.5.0

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Maps & Location
  google_maps_flutter: ^2.9.0
  geolocator: ^13.0.2
  geocoding: ^3.0.0

  # UI
  cached_network_image: ^3.4.1
  image_picker: ^1.1.2
  timeago: ^3.7.0
  intl: ^0.19.0
  lottie: ^3.1.2

  # Notifications
  onesignal_flutter: ^5.2.5

  # Utils
  uuid: ^4.5.1
  shared_preferences: ^2.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.9
  flutter_lints: ^3.0.0
```

---

## SUPABASE SETUP INSTRUCTIONS

### Step 1: Project Banao
1. `supabase.com` pe jaao
2. "New Project" click karo
3. Project name: `rideon`
4. Database password note karo
5. Region: `Southeast Asia (Singapore)` — India ke liye closest free region

### Step 2: `supabase_constants.dart` mein credentials:
```dart
class SupabaseConstants {
  static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Table names
  static const String usersTable = 'users';
  static const String ridesTable = 'rides';
  static const String bookingsTable = 'bookings';
  static const String messagesTable = 'messages';
  static const String chatsTable = 'chats';
  static const String sosAlertsTable = 'sos_alerts';
  static const String roadReportsTable = 'road_reports';
  static const String notificationsTable = 'notifications';

  // Storage buckets
  static const String profilePhotosBucket = 'profile-photos';
  static const String documentsBucket = 'user-documents';
}
```

---

## SUPABASE SQL SCHEMA — POORA BANAO

Supabase Dashboard → SQL Editor mein yeh run karo:

```sql
-- =============================================
-- RIDEON DATABASE SCHEMA
-- =============================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- USERS TABLE
-- =============================================
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  phone TEXT,
  email TEXT,
  photo_url TEXT,
  bio TEXT,
  rating DECIMAL(2,1) DEFAULT 5.0,
  total_rides_given INT DEFAULT 0,
  total_rides_taken INT DEFAULT 0,
  is_admin BOOLEAN DEFAULT FALSE,
  is_banned BOOLEAN DEFAULT FALSE,
  setup_complete BOOLEAN DEFAULT FALSE,
  fcm_token TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Vehicle info
  vehicle_model TEXT,
  vehicle_license_plate TEXT,
  vehicle_color TEXT,
  vehicle_type TEXT, -- Car, Bike, Van

  -- Document verification
  doc_driving_license_front TEXT, -- storage URL
  doc_driving_license_back TEXT,
  doc_vehicle_rc TEXT,
  doc_verification_status TEXT DEFAULT 'not_submitted',
  -- values: not_submitted / pending / approved / rejected
  doc_rejection_reason TEXT,
  doc_reviewed_at TIMESTAMPTZ,
  doc_reviewed_by UUID REFERENCES users(id)
);

-- =============================================
-- RIDES TABLE
-- =============================================
CREATE TABLE rides (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  driver_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  driver_name TEXT NOT NULL,
  driver_photo_url TEXT,
  driver_rating DECIMAL(2,1) DEFAULT 5.0,
  from_location TEXT NOT NULL,
  to_location TEXT NOT NULL,
  from_lat DECIMAL(10,8),
  from_lng DECIMAL(11,8),
  to_lat DECIMAL(10,8),
  to_lng DECIMAL(11,8),
  departure_datetime TIMESTAMPTZ NOT NULL,
  available_seats INT NOT NULL,
  total_seats INT NOT NULL,
  price_per_seat DECIMAL(10,2) NOT NULL,
  vehicle_info TEXT,
  vehicle_type TEXT,
  description TEXT,
  status TEXT DEFAULT 'active',
  -- values: active / full / completed / cancelled
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- BOOKINGS TABLE
-- =============================================
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ride_id UUID NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
  passenger_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  driver_id UUID NOT NULL REFERENCES users(id),
  passenger_name TEXT NOT NULL,
  passenger_phone TEXT,
  seats_booked INT NOT NULL DEFAULT 1,
  total_price DECIMAL(10,2) NOT NULL,
  status TEXT DEFAULT 'confirmed',
  -- values: confirmed / cancelled / completed
  booked_at TIMESTAMPTZ DEFAULT NOW(),
  cancelled_at TIMESTAMPTZ,
  cancel_reason TEXT
);

-- =============================================
-- CHATS TABLE
-- =============================================
CREATE TABLE chats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  participant_1 UUID NOT NULL REFERENCES users(id),
  participant_2 UUID NOT NULL REFERENCES users(id),
  ride_id UUID REFERENCES rides(id),
  booking_id UUID REFERENCES bookings(id),
  last_message TEXT,
  last_message_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- MESSAGES TABLE
-- =============================================
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES users(id),
  text TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- NOTIFICATIONS TABLE
-- =============================================
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL,
  -- types: booking_confirmed, booking_cancelled, ride_cancelled,
  --        document_approved, document_rejected, sos_alert,
  --        new_message, booking_request
  is_read BOOLEAN DEFAULT FALSE,
  ride_id UUID REFERENCES rides(id),
  booking_id UUID REFERENCES bookings(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- SOS ALERTS TABLE
-- =============================================
CREATE TABLE sos_alerts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id),
  user_name TEXT NOT NULL,
  latitude DECIMAL(10,8) NOT NULL,
  longitude DECIMAL(11,8) NOT NULL,
  location_name TEXT,
  emergency_type TEXT,
  -- types: accident, breakdown, harassment, medical, other
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ,
  resolved_by UUID REFERENCES users(id)
);

-- =============================================
-- ROAD REPORTS TABLE
-- =============================================
CREATE TABLE road_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  report_type TEXT NOT NULL,
  -- types: traffic, accident, police, roadblock, hazard
  description TEXT DEFAULT '',
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  reported_by UUID NOT NULL REFERENCES users(id),
  cleared_votes INT DEFAULT 0,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- INDEXES (Performance ke liye)
-- =============================================
CREATE INDEX idx_rides_status ON rides(status);
CREATE INDEX idx_rides_departure ON rides(departure_datetime);
CREATE INDEX idx_rides_driver ON rides(driver_id);
CREATE INDEX idx_rides_from_to ON rides(from_location, to_location);
CREATE INDEX idx_bookings_passenger ON bookings(passenger_id);
CREATE INDEX idx_bookings_driver ON bookings(driver_id);
CREATE INDEX idx_bookings_ride ON bookings(ride_id);
CREATE INDEX idx_notifications_user ON notifications(user_id, is_read);
CREATE INDEX idx_messages_chat ON messages(chat_id, created_at);
CREATE INDEX idx_sos_active ON sos_alerts(is_active);

-- =============================================
-- UPDATED_AT AUTO-UPDATE
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER rides_updated_at
  BEFORE UPDATE ON rides
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- SEAT BOOKING TRANSACTION FUNCTION
-- (Race condition se bachne ke liye)
-- =============================================
CREATE OR REPLACE FUNCTION book_ride_seat(
  p_ride_id UUID,
  p_passenger_id UUID,
  p_passenger_name TEXT,
  p_passenger_phone TEXT,
  p_seats_booked INT,
  p_total_price DECIMAL
)
RETURNS JSON AS $$
DECLARE
  v_ride rides%ROWTYPE;
  v_booking_id UUID;
  v_driver_id UUID;
BEGIN
  -- Ride lock karo (FOR UPDATE)
  SELECT * INTO v_ride FROM rides
  WHERE id = p_ride_id FOR UPDATE;

  -- Check karo ride exist karti hai
  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Ride not found');
  END IF;

  -- Check karo ride active hai
  IF v_ride.status != 'active' THEN
    RETURN json_build_object('success', false, 'error', 'Ride is not available');
  END IF;

  -- Check karo seats available hain
  IF v_ride.available_seats < p_seats_booked THEN
    RETURN json_build_object('success', false, 'error', 'Not enough seats available');
  END IF;

  -- Booking banao
  INSERT INTO bookings (
    ride_id, passenger_id, driver_id,
    passenger_name, passenger_phone,
    seats_booked, total_price, status
  ) VALUES (
    p_ride_id, p_passenger_id, v_ride.driver_id,
    p_passenger_name, p_passenger_phone,
    p_seats_booked, p_total_price, 'confirmed'
  ) RETURNING id INTO v_booking_id;

  -- Seats update karo
  UPDATE rides SET
    available_seats = available_seats - p_seats_booked,
    status = CASE
      WHEN (available_seats - p_seats_booked) = 0 THEN 'full'
      ELSE 'active'
    END
  WHERE id = p_ride_id;

  -- Driver ko notification bhejo
  INSERT INTO notifications (user_id, title, message, type, ride_id, booking_id)
  VALUES (
    v_ride.driver_id,
    'Naya Booking!',
    p_passenger_name || ' ne ' || p_seats_booked::TEXT || ' seat book ki hai.',
    'booking_request',
    p_ride_id,
    v_booking_id
  );

  RETURN json_build_object(
    'success', true,
    'booking_id', v_booking_id
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- CANCEL BOOKING FUNCTION
-- =============================================
CREATE OR REPLACE FUNCTION cancel_booking(
  p_booking_id UUID,
  p_user_id UUID,
  p_reason TEXT DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
  v_booking bookings%ROWTYPE;
BEGIN
  SELECT * INTO v_booking FROM bookings
  WHERE id = p_booking_id FOR UPDATE;

  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Booking not found');
  END IF;

  IF v_booking.passenger_id != p_user_id THEN
    RETURN json_build_object('success', false, 'error', 'Not authorized');
  END IF;

  IF v_booking.status != 'confirmed' THEN
    RETURN json_build_object('success', false, 'error', 'Booking already cancelled');
  END IF;

  -- Booking cancel karo
  UPDATE bookings SET
    status = 'cancelled',
    cancelled_at = NOW(),
    cancel_reason = p_reason
  WHERE id = p_booking_id;

  -- Seats wapas karo
  UPDATE rides SET
    available_seats = available_seats + v_booking.seats_booked,
    status = 'active'
  WHERE id = v_booking.ride_id;

  -- Driver ko notify karo
  INSERT INTO notifications (user_id, title, message, type, ride_id, booking_id)
  SELECT
    v_booking.driver_id,
    'Booking Cancel Hui',
    v_booking.passenger_name || ' ne booking cancel kar di.',
    'booking_cancelled',
    v_booking.ride_id,
    p_booking_id;

  RETURN json_build_object('success', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## ROW LEVEL SECURITY (RLS) POLICIES

Supabase Dashboard → Authentication → Policies mein enable karo:

```sql
-- RLS enable karo
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE rides ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE sos_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE road_reports ENABLE ROW LEVEL SECURITY;

-- USERS
CREATE POLICY "Users: apna profile dekh sakta hai" ON users
  FOR SELECT USING (auth.uid() = id OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = TRUE));

CREATE POLICY "Users: apna profile update kar sakta hai" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users: signup pe insert" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- RIDES
CREATE POLICY "Rides: sabhi authenticated users dekh sakte hain" ON rides
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Rides: driver hi bana sakta hai" ON rides
  FOR INSERT WITH CHECK (auth.uid() = driver_id);

CREATE POLICY "Rides: driver hi update kar sakta hai" ON rides
  FOR UPDATE USING (auth.uid() = driver_id OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = TRUE));

-- BOOKINGS
CREATE POLICY "Bookings: passenger aur driver dekh sakte hain" ON bookings
  FOR SELECT USING (
    auth.uid() = passenger_id OR
    auth.uid() = driver_id OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = TRUE)
  );

CREATE POLICY "Bookings: authenticated user bana sakta hai" ON bookings
  FOR INSERT WITH CHECK (auth.uid() = passenger_id);

-- NOTIFICATIONS: sirf apni
CREATE POLICY "Notifications: sirf apni" ON notifications
  FOR ALL USING (auth.uid() = user_id);

-- CHATS: sirf participants
CREATE POLICY "Chats: sirf participants" ON chats
  FOR ALL USING (auth.uid() = participant_1 OR auth.uid() = participant_2);

CREATE POLICY "Messages: sirf chat participants" ON messages
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM chats
      WHERE id = chat_id
      AND (participant_1 = auth.uid() OR participant_2 = auth.uid())
    )
  );

-- SOS
CREATE POLICY "SOS: create karo" ON sos_alerts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "SOS: apna dekho ya admin" ON sos_alerts
  FOR SELECT USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = TRUE)
  );

CREATE POLICY "SOS: update apna ya admin" ON sos_alerts
  FOR UPDATE USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = TRUE)
  );

-- ROAD REPORTS
CREATE POLICY "Road Reports: sabhi dekh sakte hain" ON road_reports
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Road Reports: create" ON road_reports
  FOR INSERT WITH CHECK (auth.uid() = reported_by);

CREATE POLICY "Road Reports: vote/delete" ON road_reports
  FOR UPDATE USING (auth.role() = 'authenticated');
```

---

## STORAGE BUCKETS SETUP

Supabase Dashboard → Storage mein:

```
Bucket 1: profile-photos
  - Public: YES
  - File size limit: 5 MB
  - Allowed MIME types: image/jpeg, image/png, image/webp

Bucket 2: user-documents
  - Public: NO (private)
  - File size limit: 10 MB
  - Allowed MIME types: image/jpeg, image/png, application/pdf
```

Storage Policies:
```sql
-- Profile photos: sabhi dekh sakte hain, sirf apni upload kar sakte hain
CREATE POLICY "Profile photos public" ON storage.objects
  FOR SELECT USING (bucket_id = 'profile-photos');

CREATE POLICY "Profile photos upload" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'profile-photos' AND
    auth.uid()::TEXT = (storage.foldername(name))[1]
  );

-- Documents: sirf khud ya admin
CREATE POLICY "Documents private" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'user-documents' AND (
      auth.uid()::TEXT = (storage.foldername(name))[1] OR
      EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND is_admin = TRUE)
    )
  );

CREATE POLICY "Documents upload" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'user-documents' AND
    auth.uid()::TEXT = (storage.foldername(name))[1]
  );
```

---

## MODELS — DART CODE

### `lib/models/user_model.dart`
```
Fields:
  id: String
  fullName: String?
  phone: String?
  email: String?
  photoUrl: String?
  rating: double (default 5.0)
  totalRidesGiven: int
  totalRidesTaken: int
  isAdmin: bool
  isBanned: bool
  setupComplete: bool
  vehicleModel: String?
  vehicleLicensePlate: String?
  vehicleColor: String?
  vehicleType: String?
  docVerificationStatus: String (not_submitted/pending/approved/rejected)
  createdAt: DateTime

Methods:
  fromJson(Map), toJson(), copyWith()
  bool get isVerified => docVerificationStatus == 'approved'
  bool get hasVehicle => vehicleModel != null && vehicleModel!.isNotEmpty
```

### `lib/models/ride_model.dart`
```
Fields:
  id: String
  driverId: String
  driverName: String
  driverPhotoUrl: String?
  driverRating: double
  fromLocation: String
  toLocation: String
  fromLat: double?
  fromLng: double?
  toLat: double?
  toLng: double?
  departureDatetime: DateTime
  availableSeats: int
  totalSeats: int
  pricePerSeat: double
  vehicleInfo: String?
  vehicleType: String?
  description: String?
  status: String (active/full/completed/cancelled)
  createdAt: DateTime

Methods:
  fromJson(Map), toJson()
  bool get isActive => status == 'active'
  bool get isFull => status == 'full'
  String get formattedPrice => '₹${pricePerSeat.toStringAsFixed(0)}'
  String get formattedDate => ... (intl se)
```

### `lib/models/booking_model.dart`
```
Fields:
  id: String
  rideId: String
  passengerId: String
  driverId: String
  passengerName: String
  passengerPhone: String?
  seatsBooked: int
  totalPrice: double
  status: String (confirmed/cancelled/completed)
  bookedAt: DateTime
  cancelledAt: DateTime?

Methods: fromJson(Map), toJson()
bool get isActive => status == 'confirmed'
```

---

## SERVICES — SUPABASE INTEGRATION

### `lib/services/supabase_service.dart`
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
  static User? get currentUser => client.auth.currentUser;
  static String? get currentUserId => currentUser?.id;
  static Session? get currentSession => client.auth.currentSession;
  static bool get isLoggedIn => currentUser != null;
}
```

### `lib/services/auth_service.dart` — methods:
```
signUpWithEmail(email, password) → Future<AuthResponse>
  - Auth signup
  - users table mein row insert karo: { id: user.id, email: email }

signInWithEmail(email, password) → Future<AuthResponse>

sendOTP(phone) → Future<void>
  - Supabase phone OTP

verifyOTP(phone, token) → Future<AuthResponse>

signOut() → Future<void>

resetPassword(email) → Future<void>

onAuthStateChange → Stream<AuthState>
  - App mein listen karo login/logout ke liye
```

### `lib/services/ride_service.dart` — methods:
```
searchRides({required String from, required String to, required DateTime date})
  → Future<List<RideModel>>
  Query:
    SELECT * FROM rides
    WHERE LOWER(from_location) LIKE LOWER('%$from%')
    AND LOWER(to_location) LIKE LOWER('%$to%')
    AND status = 'active'
    AND departure_datetime >= [start_of_date]
    AND departure_datetime <= [end_of_date]
    ORDER BY departure_datetime ASC

publishRide(RideModel ride) → Future<RideModel>
  - rides table mein insert karo
  - status: 'active'

getMyPublishedRides(String driverId) → Future<List<RideModel>>

cancelRide(String rideId, String driverId) → Future<void>
  - rides status = 'cancelled'
  - Saare passengers ko notification bhejo
  - Unke bookings status = 'cancelled'

getRideById(String rideId) → Future<RideModel?>

getRecentRidesNearMe(double lat, double lng) → Future<List<RideModel>>
  - Nearby rides (future feature — abhi sirf latest 10)
```

### `lib/services/booking_service.dart` — methods:
```
bookRide({rideId, passengerId, passengerName, passengerPhone, seatsBooked, totalPrice})
  → Future<Map<String, dynamic>>
  Supabase RPC call: client.rpc('book_ride_seat', params: {...})
  Returns: { success: bool, booking_id: string?, error: string? }

cancelBooking(String bookingId, String userId, {String? reason})
  → Future<Map<String, dynamic>>
  Supabase RPC call: client.rpc('cancel_booking', params: {...})

getMyBookings(String passengerId) → Stream<List<BookingModel>>
  Realtime subscription:
  client.from('bookings')
    .stream(primaryKey: ['id'])
    .eq('passenger_id', passengerId)
    .order('booked_at', ascending: false)

getBookingsForRide(String rideId) → Future<List<BookingModel>>
  - Driver passengers list ke liye
```

### `lib/services/chat_service.dart` — methods:
```
getOrCreateChat(String otherUserId, String rideId, String bookingId)
  → Future<String> (chatId)
  - Check karo existing chat hai ya nahi
  - Nahi hai toh create karo

sendMessage(String chatId, String text) → Future<void>

getMessages(String chatId) → Stream<List<MessageModel>>
  Realtime:
  client.from('messages')
    .stream(primaryKey: ['id'])
    .eq('chat_id', chatId)
    .order('created_at', ascending: true)

getMyChats(String userId) → Stream<List<Map>>
  Join: chats + users (other participant info)

markAsRead(String chatId, String userId) → Future<void>
```

### `lib/services/storage_service.dart` — methods:
```
uploadProfilePhoto(String uid, File imageFile) → Future<String>
  Path: profile-photos/{uid}/avatar.jpg
  Returns: public URL

uploadDocument(String uid, File imageFile, String docType) → Future<String>
  Path: user-documents/{uid}/{docType}.jpg
  docType: driving_license_front / driving_license_back / vehicle_rc
  Returns: signed URL (24 hours valid — admin review ke liye)

getDocumentUrl(String uid, String docType) → Future<String?>
  Signed URL generate karo (1 hour validity)
```

### `lib/services/sos_service.dart` — methods:
```
triggerSOS({userId, userName, lat, lng, locationName, emergencyType})
  → Future<String> (alertId)
  - sos_alerts mein insert karo
  - Admin ko notification bhejo

cancelSOS(String alertId) → Future<void>
  - is_active = false

watchActiveAlerts() → Stream<List<SosAlertModel>>
  - Admin ke liye real-time
```

---

## PROVIDERS — RIVERPOD

### `lib/providers/auth_provider.dart`
```
authStateProvider: StreamProvider<AuthState>
  SupabaseService.client.auth.onAuthStateChange

currentUserProvider: FutureProvider<UserModel?>
  users table se current user fetch karo

userProfileProvider: StateNotifierProvider<UserProfileNotifier, UserModel?>
  Methods:
    loadProfile() — Supabase se fetch
    updateProfile(Map data) — update karo
    uploadAndUpdatePhoto(File) — storage + profile update
```

### `lib/providers/ride_provider.dart`
```
searchResultsProvider: StateNotifierProvider<RideSearchNotifier, AsyncValue<List<RideModel>>>
  Methods:
    search(from, to, date)
    clear()

myPublishedRidesProvider: FutureProvider<List<RideModel>>

publishRideProvider: StateNotifierProvider<PublishRideNotifier, AsyncValue<void>>
  Methods:
    publish(RideModel ride)
```

### `lib/providers/booking_provider.dart`
```
myBookingsProvider: StreamProvider<List<BookingModel>>
  Real-time stream from Supabase

bookRideProvider: StateNotifierProvider<BookingNotifier, AsyncValue<void>>
  Methods:
    book(...)
    cancel(bookingId, reason)
```

---

## SCREENS — DETAIL SPEC

### SCREEN 1: SplashScreen
```
Kya dikhao:
  - RideOn logo (car + pooling icon)
  - Brand color background #3700B3
  - Loading animation (Lottie ya CircularProgressIndicator)
  - Version number (bottom mein)

Logic (2 second delay ke baad):
  if (SupabaseService.isLoggedIn) {
    currentUser = await fetch from users table
    if (currentUser.setupComplete) → navigate to /home
    else → navigate to /profile-setup
  } else {
    navigate to /welcome
  }
```

### SCREEN 2: WelcomeScreen
```
Kya dikhao:
  - App logo aur naam "RideOn"
  - Tagline: "Saath chalein, saath bachayein"
  - Illustration (car pooling graphic — use a colored Container with Icons)
  - "Shuru Karein" button (filled, #3700B3)
  - "Login Karein" button (outlined)
  - Language: Hindi-English mixed
  - Terms & Privacy text (bottom)
```

### SCREEN 3: SignupScreen
```
Fields:
  - Full Name (TextFormField, required)
  - Email (TextFormField, email keyboard, required)
  - Password (TextFormField, obscure, min 6 chars)
  - Confirm Password

Flow:
  1. Form validate karo
  2. AuthService.signUpWithEmail() call karo
  3. Success → users table mein row banao (Supabase trigger se auto ho sakta hai)
  4. Navigate to /profile-setup

Error handling:
  - "Email already registered" → Login ka link dikhao
  - Network error → Retry option
```

### SCREEN 4: LoginScreen
```
Fields:
  - Email
  - Password
  - "Forgot Password?" link

Social Login: NA (free tier mein baad mein add karein)

Flow:
  1. AuthService.signInWithEmail()
  2. Check setupComplete
  3. Navigate accordingly

Error: "Invalid credentials" message clear dikhao
```

### SCREEN 5: ProfileSetupScreen (ONBOARDING)
```
2-step stepper:

Step 1 — Personal Info:
  - Full Name
  - Phone Number (Indian format +91)
  - Profile Photo (optional — image_picker se, Firebase Storage pe upload)

Step 2 — Vehicle Info:
  - Vehicle Type (dropdown: Car / Bike / Van)
  - Vehicle Model (e.g., Maruti Swift)
  - License Plate Number
  - Color

Save Button:
  - DatabaseService.saveUserProfile(uid, data)
  - setupComplete: true set karo
  - Navigate to /home
  
Note: Vehicle info optional hai — agar skip kare toh
bhi /home pe jaane do, lekin ride publish karne se pehle
warning dikhao ki vehicle info required hai.
```

### SCREEN 6: HomeScreen (Main Screen)
```
AppBar:
  - "RideOn" title
  - Notification bell (badge with unread count)
  
Body:
  - Google Maps (full screen background)
  - User ki current location show karo
  - Available rides nearby show karo (map markers)
  
Overlaid UI:
  - Top: Search bar ("Kahan jaana hai?")
    → tap karne pe SearchRidesScreen
  
  - Bottom sheet (peek height 200px):
    - "Ride Dhundhein" button (Passenger)
    - "Ride Publish Karein" button (Driver)
    - Recent activity / Quick stats
  
  - FAB (bottom right):
    SOS Button (red, emergency icon)
    → Long press activate karo (accidental press prevent karne ke liye)
    → Confirm dialog: "SOS Alert bhejein?"
    → SOSService.triggerSOS() call karo
    → Active hone ke baad countdown + Cancel button

  - Road Report button (top right):
    → Bottom sheet with icons:
       🚗 Traffic | 💥 Accident | 🚓 Police | 🚧 Roadblock | ⚠️ Hazard
    → Tap karne pe report create ho aur "Report submit ho gaya" snackbar

Maps setup:
  - AndroidManifest.xml mein Google Maps API key
  - LocationService se current position lo
  - Map controller se camera move karo user location par
```

### SCREEN 7: SearchRidesScreen
```
Top section:
  - "Kahan se?" text field (with GPS button — auto-fill current location)
  - "Kahan tak?" text field
  - Date picker
  - "Dhundho" button

Results list:
  - RideCard widget use karo (driver info, route, time, price, seats)
  - Filter chips: Price ↑↓, Time ↑↓, Seats available
  - "Koi ride nahi mili" empty state with illustration

RideCard widget:
  - Driver photo (CircleAvatar with CachedNetworkImage)
  - Driver name + rating stars
  - From → To with arrow
  - Departure time (formatted: "Kal, 10 baje")
  - Price per seat: "₹150/seat"
  - Available seats: "3 seats bacha hain"
  - Verified badge (agar documents approved hain)
  - "Dekho" button → RideDetailsScreen
```

### SCREEN 8: RideDetailsScreen
```
Top: Driver card
  - Driver photo (large CircleAvatar)
  - Driver name, rating (5 stars), total rides count
  - Verified badge if documents approved
  - Vehicle info

Route card:
  - From location (with pickup icon)
  - To location (with destination icon)
  - Date & Time (formatted)
  - Duration estimate (optional)

Pricing:
  - Price per seat: "₹150"
  - Seats selector (DropdownButton 1 to availableSeats)
  - Total: "₹450" (auto calculate)

Vehicle card:
  - Type, Model, Color
  - License plate (partial — only last 4 digits for privacy)

Notes (if any)

Bottom bar:
  - "Book Karo" button
  - "Driver se Baat Karo" → Chat screen

Book flow:
  1. Check karo user logged in hai
  2. Check karo driver apni hi ride book nahi kar raha
  3. BookingService.bookRide() call karo (RPC function)
  4. Success → MyBookingsScreen pe navigate karo
  5. Error (not enough seats) → message dikhao
```

### SCREEN 9: PublishRideScreen
```
Warning banner (agar documents not approved):
  - "Documents verify nahi hain — abhi upload karo" → DocumentsScreen

Form fields:
  - Kahan se? (GPS auto-fill button ke saath)
  - Kahan tak?
  - Tarikh (DatePicker — aaj se aage ki dates only)
  - Samay (TimePicker)
  - Seats available (1-6 spinner)
  - Price per seat (₹ prefix, number keyboard)
  - Vehicle info (auto-fill from profile, editable)
  - Notes/Description (optional, max 200 chars)

Publish button:
  1. Form validate karo
  2. RideService.publishRide() call karo
  3. Success → MyRidesScreen pe navigate karo
  4. "Ride publish ho gayi!" success snackbar
```

### SCREEN 10: MyBookingsScreen
```
Tab bar:
  - "Upcoming" (confirmed bookings, future dates)
  - "Past" (completed/cancelled bookings)

BookingCard widget:
  - Route: "Delhi → Agra"
  - Date & time
  - Driver name + photo
  - Seats booked + Total price
  - Status chip (Confirmed/Cancelled green/red)
  - "Driver se Baat Karo" → Chat
  - "Cancel Karo" button (sirf upcoming ke liye, departure se 2 ghante pehle tak)

Cancel flow:
  1. Confirm dialog: "Kya aap sure hain?"
  2. Optional reason field
  3. BookingService.cancelBooking() RPC call
  4. List refresh ho jaaye (real-time stream se automatic)
```

### SCREEN 11: MyRidesScreen
```
Tab bar:
  - "Active Rides" (status = active/full, future)
  - "Past Rides" (status = completed/cancelled)

RideManageCard widget:
  - Route, Date/time
  - Seats: "3/4 booked"
  - Status chip
  - "Passengers dekho" → bottom sheet with list
  - "Cancel Karo" button (sirf future active rides ke liye)

Cancel ride flow:
  1. Confirm dialog with warning: "Saare passengers ko cancel notification jaayegi"
  2. RideService.cancelRide() call karo
  3. Internally: ride status cancelled, saare bookings cancelled, notifications send
```

### SCREEN 12: InboxScreen
```
Chat list (real-time from Supabase):
  - User avatar + name
  - Last message preview
  - Time (timeago format)
  - Unread count badge (blue circle)
  - Ride route context: "Re: Delhi → Agra"

Empty state: "Abhi koi chat nahi hai"

Tap → ChatScreen
```

### SCREEN 13: ChatScreen
```
AppBar:
  - Other user name + photo
  - "Active" status indicator
  - Ride info subtitle: "Delhi → Agra • 15 March"

Messages (StreamBuilder, real-time):
  - Apne messages: right side, blue bubble
  - Unke messages: left side, grey bubble
  - Time stamp (HH:mm)
  - Date separator (aaj, kal, date)

Input bar:
  - Text field
  - Send button

On send:
  ChatService.sendMessage(chatId, text)
  Scroll to bottom automatically
```

### SCREEN 14: ProfileScreen
```
Header:
  - Profile photo (large, tapable for edit)
  - Name, phone
  - Rating: 4.8 ★ (stars)
  - Stats row: "12 diye | 8 liye | 4.8 ★"
  - Verified badge (agar documents approved)

Vehicle card (agar hai):
  - Type icon, Model, Color, Plate

Menu items (ListTile):
  - ✏️ Profile Edit Karo → EditProfileScreen
  - 🚗 Meri Rides → MyRidesScreen
  - 📄 Documents → DocumentsScreen
  - 🔔 Notifications → NotificationsScreen
  - 📊 Report History → ReportHistoryScreen
  - ❓ Help & Support (bottom sheet with FAQs)
  - 🚪 Logout (confirm dialog → AuthService.signOut() → WelcomeScreen)
```

### SCREEN 15: EditProfileScreen
```
Fields:
  - Profile Photo (image_picker → StorageService.uploadProfilePhoto)
  - Full Name
  - Phone
  - Bio (optional, 150 chars)
  - Vehicle Model
  - Vehicle Color
  - Vehicle Type (dropdown)
  - License Plate

Save → UserDataService.updateUserProfile()
```

### SCREEN 16: DocumentsScreen
```
Title: "Documents Verify Karao"
Subtitle: "Verify hone ke baad aap rides publish kar sakte hain"

Status banner:
  - not_submitted: "Documents abhi upload nahi hue"
  - pending: "Review pending hai ⏳"  (yellow)
  - approved: "Verified ✅" (green)
  - rejected: "Reject hua ❌ — Reason: [reason]" (red)

Document cards (3):
  1. Driving License (Front)
  2. Driving License (Back)
  3. Vehicle RC Book

Har card pe:
  - Document name + icon
  - Upload button (image_picker)
  - Preview thumbnail agar already uploaded
  - Replace option

"Submit for Verification" button:
  - Sirf active ho jab teeno documents upload ho jayein
  - StorageService.uploadDocument() → URL Firestore mein save
  - users table mein doc_verification_status = 'pending' set karo
  - Admin ko notification bhejo
```

### SCREEN 17: NotificationsScreen
```
Real-time list from Supabase notifications table:
  - Notification icon (type ke hisaab se emoji/icon)
  - Title (bold agar unread)
  - Message
  - Time (timeago)
  - Unread dot (blue)

Actions:
  - Tap → Mark as read
  - Swipe to delete
  - "Sab clear karo" button (top right)

Empty state: "Koi notification nahi"
```

### SCREEN 18: ReportHistoryScreen
```
Meri road reports ki list (real-time stream):
  - Type emoji + Type name
  - Reported time
  - Status: Active (green) / Expired (grey)
```

---

## ADMIN PANEL — FLUTTER WEB

**Entry Point:** `lib/main_web.dart` ya conditional entry in `main.dart`

Admin check: `currentUser.isAdmin == true`
Agar admin nahi: redirect to `/home`

### Admin Shell (Left Sidebar layout):
```
lib/screens/admin/admin_shell.dart

Sidebar items:
  🏠 Dashboard
  👥 Users
  📄 Documents
  🚨 SOS Alerts
  🚗 Rides
  🚪 Logout
```

### Admin Screen 1: Dashboard
```
Stats cards (4 boxes):
  - Total Users: [count from users table]
  - Active Rides Today: [count]
  - Active SOS Alerts: [real-time count — RED agar > 0]
  - Pending Verifications: [count]

Recent Activity feed:
  - Last 10 notifications (all types, all users)
  - Auto-refresh every 30 seconds ya Supabase realtime

Charts (optional, recharts ya fl_chart):
  - Rides per day (last 7 days)
  - New users per day
```

### Admin Screen 2: User Management
```
DataTable / ListView with columns:
  Name | Email | Phone | Joined | Status | Actions

Search bar (name/email se filter)

Row actions:
  - "Dekho" → User detail dialog
  - "Ban" / "Unban" toggle
  - "Admin banaao" / "Admin hatao" toggle

User detail dialog:
  - Profile info
  - Booking history (last 5)
  - Ride history (last 5)
  - Document status
```

### Admin Screen 3: Document Verification
```
Tabs: Pending | Approved | Rejected

Pending card:
  - User name + photo
  - Submit date (timeago)
  - Documents preview:
    * Driving License Front (Image, zoomable)
    * Driving License Back (Image, zoomable)
    * Vehicle RC (Image, zoomable)
  - "APPROVE" button (green)
  - "REJECT" button (red → reason input field dikhao)

On Approve:
  - users table: doc_verification_status = 'approved', doc_reviewed_at, doc_reviewed_by
  - User ko notification: "Documents Approved ✅"

On Reject:
  - users table: doc_verification_status = 'rejected', doc_rejection_reason = reason
  - User ko notification: "Documents Reject Hue ❌ — [reason]"
```

### Admin Screen 4: SOS Alerts
```
Real-time stream (Supabase realtime subscription):

Active alerts list (RED background):
  - User name + phone
  - Time elapsed (timeago, auto-updating)
  - Emergency type
  - Location name
  - "Map mein dekho" link (Google Maps URL)
  
Alert card actions:
  - "Resolve Karo" button
    → resolved_at = now(), resolved_by = admin_uid
    → is_active = false

Alert history (resolved):
  - Same list lekin grey, with resolved time
```

### Admin Screen 5: Ride Management
```
Rides table with columns:
  Driver | From → To | Date | Seats | Status | Actions

Filters:
  - Status dropdown (active/completed/cancelled/full)
  - Date range picker

Row actions:
  - "Force Cancel" → ride cancel + passengers notify
  - "Passengers dekho" → dialog with passenger list
```

---

## NAVIGATION — GOROUTER SETUP

```dart
// lib/core/router/app_router.dart

final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final isLoggedIn = SupabaseService.isLoggedIn;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    
    if (!isLoggedIn && !isAuthRoute && state.matchedLocation != '/splash') {
      return '/auth/welcome';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (ctx, state) => const SplashScreen()),
    
    // Auth routes
    ShellRoute(
      builder: (ctx, state, child) => child,
      routes: [
        GoRoute(path: '/auth/welcome', builder: (ctx, state) => const WelcomeScreen()),
        GoRoute(path: '/auth/login', builder: (ctx, state) => const LoginScreen()),
        GoRoute(path: '/auth/signup', builder: (ctx, state) => const SignupScreen()),
        GoRoute(path: '/auth/otp', builder: (ctx, state) => const OtpScreen()),
      ],
    ),
    
    // Onboarding
    GoRoute(path: '/onboarding/profile', builder: (ctx, state) => const ProfileSetupScreen()),
    
    // Main app (Bottom Navigation Shell)
    ShellRoute(
      builder: (ctx, state, child) => MainNavShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (ctx, state) => const HomeScreen()),
        GoRoute(path: '/search', builder: (ctx, state) => const SearchRidesScreen()),
        GoRoute(
          path: '/ride/:id',
          builder: (ctx, state) => RideDetailsScreen(rideId: state.pathParameters['id']!),
        ),
        GoRoute(path: '/publish', builder: (ctx, state) => const PublishRideScreen()),
        GoRoute(path: '/bookings', builder: (ctx, state) => const MyBookingsScreen()),
        GoRoute(path: '/my-rides', builder: (ctx, state) => const MyRidesScreen()),
        GoRoute(
          path: '/chat/:chatId',
          builder: (ctx, state) => ChatScreen(chatId: state.pathParameters['chatId']!),
        ),
        GoRoute(path: '/inbox', builder: (ctx, state) => const InboxScreen()),
        GoRoute(path: '/profile', builder: (ctx, state) => const ProfileScreen()),
        GoRoute(path: '/profile/edit', builder: (ctx, state) => const EditProfileScreen()),
        GoRoute(path: '/profile/documents', builder: (ctx, state) => const DocumentsScreen()),
        GoRoute(path: '/notifications', builder: (ctx, state) => const NotificationsScreen()),
        GoRoute(path: '/reports', builder: (ctx, state) => const ReportHistoryScreen()),
      ],
    ),
    
    // Admin (Web only, admin check inside)
    ShellRoute(
      builder: (ctx, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(path: '/admin', builder: (ctx, state) => const AdminDashboardScreen()),
        GoRoute(path: '/admin/users', builder: (ctx, state) => const AdminUsersScreen()),
        GoRoute(path: '/admin/documents', builder: (ctx, state) => const AdminDocumentsScreen()),
        GoRoute(path: '/admin/sos', builder: (ctx, state) => const AdminSosScreen()),
        GoRoute(path: '/admin/rides', builder: (ctx, state) => const AdminRidesScreen()),
      ],
    ),
  ],
);
```

### Bottom Navigation:
```
Tab 1: Home (Icons.home_rounded)
Tab 2: Search (Icons.search_rounded)
Tab 3: + Publish (center FAB, #FF6B00 orange)
Tab 4: Inbox (Icons.chat_bubble_rounded)
Tab 5: Profile (Icons.person_rounded)
```

---

## DESIGN SYSTEM

### Colors:
```dart
class AppColors {
  static const primary = Color(0xFF3700B3);         // Deep Purple
  static const primaryDark = Color(0xFF2800A0);
  static const primaryLight = Color(0xFFEDE7F6);
  static const secondary = Color(0xFFFF6B00);        // Orange (FAB, accents)
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFF44336);
  static const warning = Color(0xFFFF9800);
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF5F5F5);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const divider = Color(0xFFE0E0E0);
  static const sosRed = Color(0xFFD32F2F);           // SOS button
}
```

### Typography:
```dart
// Google Fonts Poppins use karo (free)
// Headings: Poppins Bold
// Body: Poppins Regular
// Caption: Poppins Light
```

### Common Widgets:
```
PrimaryButton → ElevatedButton with brand color, rounded corners (12px)
SecondaryButton → OutlinedButton with brand color border
RideCard → Card with driver info, route, price
BookingCard → Card with booking status, route, price
UserAvatar → CircleAvatar with CachedNetworkImage + fallback initials
EmptyState → Illustration + title + subtitle + optional action button
LoadingOverlay → Modal barrier with CircularProgressIndicator
```

---

## main.dart — INITIALIZATION

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase initialize karo
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  // OneSignal initialize karo
  OneSignal.initialize('YOUR_ONESIGNAL_APP_ID');
  OneSignal.Notifications.requestPermission(true);

  runApp(
    const ProviderScope(   // Riverpod ke liye
      child: RideOnApp(),
    ),
  );
}

class RideOnApp extends ConsumerWidget {
  const RideOnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'RideOn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
```

---

## ONESIGNAL SETUP (Free Push Notifications)

1. `onesignal.com` pe account banao (free)
2. New App banao: "RideOn"
3. Android setup: Firebase credentials daal do (OneSignal khud handle karta hai)
4. App ID copy karo → `main.dart` mein use karo

Notification send karne ka function:
```dart
// lib/services/notification_service.dart

class NotificationService {
  // User ke FCM token pe direct notification (Supabase Edge Function se)
  // Ya simply notifications table mein insert karo — app mein
  // Supabase realtime se automatically show ho jaayegi
  
  static Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? rideId,
    String? bookingId,
  }) async {
    // notifications table mein insert karo
    // Supabase realtime subscription app mein notification show karega
    await SupabaseService.client.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'ride_id': rideId,
      'booking_id': bookingId,
    });
  }
}
```

---

## CRITICAL IMPLEMENTATION RULES

### Rule 1 — Ek screen, ek file
Pichli baar TestSprite ne ek screen ki 4 files bana di thi.
**STRICT RULE:** Har screen ki sirf ek file hogi. Koi duplicate nahi.

### Rule 2 — Service layer separate rakho
Business logic screens mein mat likhna.
Screens sirf UI dikhayein aur providers call karein.
Providers services call karein.
Services Supabase se interact karein.

### Rule 3 — Realtime subscriptions cleanup
Har StreamBuilder/Provider ka subscription `dispose()` mein cancel karo.
Supabase channels ko properly remove karo.

### Rule 4 — Error handling har jagah
```dart
try {
  final result = await someService.doSomething();
  // success
} on PostgrestException catch (e) {
  // Supabase DB error
  showSnackBar(context, 'Database error: ${e.message}', isError: true);
} on StorageException catch (e) {
  // Storage error
  showSnackBar(context, 'Upload failed: ${e.message}', isError: true);
} catch (e) {
  // General error
  showSnackBar(context, 'Kuch galat hua. Dobara try karein.', isError: true);
}
```

### Rule 5 — Loading states
Har async operation ke liye loading indicator dikhao.
Buttons disable karo jab loading ho (double tap prevent karne ke liye).

### Rule 6 — Null safety
Sabhi nullable fields ko `?` ke saath declare karo.
Koi bhi `!` (force unwrap) sirf tab use karo jab 100% sure ho.

### Rule 7 — Android Manifest
```xml
<!-- Internet permission -->
<uses-permission android:name="android.permission.INTERNET" />
<!-- Location -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<!-- Camera & Storage (documents ke liye) -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

<!-- Google Maps API Key -->
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_GOOGLE_MAPS_KEY" />
```

### Rule 8 — iOS Info.plist
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>RideOn ko aapki location chahiye rides dhundhne ke liye</string>
<key>NSCameraUsageDescription</key>
<string>Documents upload karne ke liye camera chahiye</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Profile photo aur documents ke liye gallery access chahiye</string>
```

---

## TESTING CHECKLIST — BUILD COMPLETE HONE KE BAAD

Har feature manually verify karo:

**Auth Flow:**
- [ ] Signup → Profile Setup → Home (correct flow)
- [ ] Login → Home (direct, agar setup complete)
- [ ] Login nahi → Welcome Screen
- [ ] Logout → Welcome Screen
- [ ] Splash ne sahi screen pe redirect kiya

**Ride Flow:**
- [ ] Ride publish hui → Supabase mein entry hai
- [ ] Search karo → results aaye (same from/to)
- [ ] Ride book karo → booking confirm, seats kam hue
- [ ] Cancel booking → seats wapas aaye
- [ ] Driver ko booking notification aayi

**Chat:**
- [ ] Book karne ke baad driver se chat ho sake
- [ ] Real-time message deliver ho

**Documents:**
- [ ] Photo upload ho — Storage mein jaaye
- [ ] URL Supabase mein save ho
- [ ] Admin ko notification jaaye

**SOS:**
- [ ] Long press confirm → alert create ho → Supabase mein entry

**Admin:**
- [ ] Sirf admin login kar sake /admin route pe
- [ ] Document approve/reject kaam kare + user notification aye
- [ ] Active SOS alerts real-time dikhein

---

## FREE TIER LIMITS — DHYAN RAKHO

```
Supabase Free Tier:
  - Database: 500 MB (kafi hai starting ke liye)
  - Storage: 1 GB
  - Auth: 50,000 MAU
  - API: Unlimited
  - Realtime: 200 concurrent connections
  - Project pause: 1 week inactivity ke baad (paid pe nahi hota)
  ⚠️ Note: Weekly ek baar login karo ya cron job set karo project pause na ho

Google Maps Free:
  - $200/month credit (~28,000 map loads free)
  - Startup ke liye kafi hai

OneSignal Free:
  - 10,000 subscribers
  - Unlimited push notifications
```

---

*PRD Version: 2.0 (Fresh Project)*
*App: RideOn | Flutter + Supabase*
*Sabse pehle: `flutter create rideon` — phir yeh PRD follow karo*
