-- =============================================
-- RIDEON DATABASE SCHEMA
-- =============================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- USERS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS users (
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
  driving_experience TEXT, -- e.g. "5 years"
  address TEXT,
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
  doc_reviewed_by UUID REFERENCES users(id),
  
  -- Details Without Document Upload
  driving_license_number TEXT,
  puc_number TEXT,
  insurance_number TEXT
);

-- =============================================
-- RIDES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS rides (
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
  route_points JSONB, -- To store LatLng points
  
  -- Extra Trip Details
  distance_km DECIMAL(10,2),
  duration_mins INT,
  
  -- Trip Rules / Preferences
  rule_no_smoking BOOLEAN DEFAULT FALSE,
  rule_no_music BOOLEAN DEFAULT FALSE,
  rule_no_heavy_luggage BOOLEAN DEFAULT FALSE,
  rule_no_pets BOOLEAN DEFAULT FALSE,
  rule_negotiation BOOLEAN DEFAULT FALSE,
  
  status TEXT DEFAULT 'active',
  -- values: active / full / completed / cancelled
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- BOOKINGS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ride_id UUID NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
  passenger_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  driver_id UUID NOT NULL REFERENCES users(id),
  passenger_name TEXT NOT NULL,
  passenger_phone TEXT,
  from_location TEXT, -- Pickup
  to_location TEXT,   -- Dropoff
  from_lat DECIMAL(10,8),
  from_lng DECIMAL(11,8),
  to_lat DECIMAL(10,8),
  to_lng DECIMAL(11,8),
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
CREATE TABLE IF NOT EXISTS chats (
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
CREATE TABLE IF NOT EXISTS messages (
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
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  ride_id UUID REFERENCES rides(id),
  booking_id UUID REFERENCES bookings(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- SOS ALERTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS sos_alerts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id),
  user_name TEXT NOT NULL,
  latitude DECIMAL(10,8) NOT NULL,
  longitude DECIMAL(11,8) NOT NULL,
  location_name TEXT,
  emergency_type TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ,
  resolved_by UUID REFERENCES users(id)
);

-- =============================================
-- ROAD REPORTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS road_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  report_type TEXT NOT NULL,
  description TEXT DEFAULT '',
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  reported_by UUID NOT NULL REFERENCES users(id),
  cleared_votes INT DEFAULT 0,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- INDEXES (IF NOT EXISTS to avoid errors on re-run)
-- =============================================
CREATE INDEX IF NOT EXISTS idx_rides_status ON rides(status);
CREATE INDEX IF NOT EXISTS idx_rides_departure ON rides(departure_datetime);
CREATE INDEX IF NOT EXISTS idx_rides_driver ON rides(driver_id);
CREATE INDEX IF NOT EXISTS idx_rides_from_to ON rides(from_location, to_location);
CREATE INDEX IF NOT EXISTS idx_bookings_passenger ON bookings(passenger_id);
CREATE INDEX IF NOT EXISTS idx_bookings_driver ON bookings(driver_id);
CREATE INDEX IF NOT EXISTS idx_bookings_ride ON bookings(ride_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_messages_chat ON messages(chat_id, created_at);
CREATE INDEX IF NOT EXISTS idx_sos_active ON sos_alerts(is_active);

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

-- Drop triggers first to avoid "already exists" errors
DROP TRIGGER IF EXISTS users_updated_at ON users;
CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS rides_updated_at ON rides;
CREATE TRIGGER rides_updated_at
  BEFORE UPDATE ON rides
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- ENABLE RLS (Row Level Security)
-- =============================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE rides ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE sos_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE road_reports ENABLE ROW LEVEL SECURITY;

-- =============================================
-- RLS POLICIES (DROP IF EXISTS + CREATE)
-- =============================================

-- ========== USERS TABLE POLICIES ==========
DROP POLICY IF EXISTS "Users can view all profiles" ON users;
CREATE POLICY "Users can view all profiles" 
  ON users FOR SELECT 
  USING (true);

DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
CREATE POLICY "Users can insert their own profile" 
  ON users FOR INSERT 
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON users;
CREATE POLICY "Users can update their own profile" 
  ON users FOR UPDATE 
  USING (auth.uid() = id);

-- ========== RIDES TABLE POLICIES ==========
DROP POLICY IF EXISTS "Anyone can view active rides" ON rides;
CREATE POLICY "Anyone can view active rides" 
  ON rides FOR SELECT 
  USING (true);

DROP POLICY IF EXISTS "Drivers can insert their own rides" ON rides;
CREATE POLICY "Drivers can insert their own rides" 
  ON rides FOR INSERT 
  WITH CHECK (auth.uid() = driver_id);

DROP POLICY IF EXISTS "Drivers can update their own rides" ON rides;
CREATE POLICY "Drivers can update their own rides" 
  ON rides FOR UPDATE 
  USING (auth.uid() = driver_id);

-- ========== BOOKINGS TABLE POLICIES ==========
DROP POLICY IF EXISTS "Users can view their own bookings" ON bookings;
CREATE POLICY "Users can view their own bookings" 
  ON bookings FOR SELECT 
  USING (auth.uid() = passenger_id OR auth.uid() = driver_id);

DROP POLICY IF EXISTS "Passengers can insert bookings" ON bookings;
CREATE POLICY "Passengers can insert bookings" 
  ON bookings FOR INSERT 
  WITH CHECK (auth.uid() = passenger_id);

DROP POLICY IF EXISTS "Participants can update bookings" ON bookings;
CREATE POLICY "Participants can update bookings" 
  ON bookings FOR UPDATE 
  USING (auth.uid() = passenger_id OR auth.uid() = driver_id);

-- ========== CHATS TABLE POLICIES ==========
DROP POLICY IF EXISTS "Users can view their own chats" ON chats;
CREATE POLICY "Users can view their own chats" 
  ON chats FOR SELECT 
  USING (auth.uid() = participant_1 OR auth.uid() = participant_2);

DROP POLICY IF EXISTS "Users can insert chats they belong to" ON chats;
CREATE POLICY "Users can insert chats they belong to" 
  ON chats FOR INSERT 
  WITH CHECK (auth.uid() = participant_1 OR auth.uid() = participant_2);

DROP POLICY IF EXISTS "Users can update their own chats" ON chats;
CREATE POLICY "Users can update their own chats" 
  ON chats FOR UPDATE 
  USING (auth.uid() = participant_1 OR auth.uid() = participant_2);

-- ========== MESSAGES TABLE POLICIES ==========
DROP POLICY IF EXISTS "Users can view messages in their chats" ON messages;
CREATE POLICY "Users can view messages in their chats" 
  ON messages FOR SELECT 
  USING (
    EXISTS (
      SELECT 1 FROM chats 
      WHERE chats.id = messages.chat_id 
      AND (chats.participant_1 = auth.uid() OR chats.participant_2 = auth.uid())
    )
  );

DROP POLICY IF EXISTS "Users can insert messages in their chats" ON messages;
CREATE POLICY "Users can insert messages in their chats" 
  ON messages FOR INSERT 
  WITH CHECK (auth.uid() = sender_id);

DROP POLICY IF EXISTS "Users can update their own messages" ON messages;
CREATE POLICY "Users can update their own messages" 
  ON messages FOR UPDATE 
  USING (auth.uid() = sender_id);

-- ========== NOTIFICATIONS TABLE POLICIES ==========
DROP POLICY IF EXISTS "Users can view their own notifications" ON notifications;
CREATE POLICY "Users can view their own notifications" 
  ON notifications FOR SELECT 
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "System can insert notifications" ON notifications;
CREATE POLICY "System can insert notifications" 
  ON notifications FOR INSERT 
  WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update their own notifications" ON notifications;
CREATE POLICY "Users can update their own notifications" 
  ON notifications FOR UPDATE 
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own notifications" ON notifications;
CREATE POLICY "Users can delete their own notifications" 
  ON notifications FOR DELETE 
  USING (auth.uid() = user_id);

-- ========== SOS ALERTS TABLE POLICIES ==========
DROP POLICY IF EXISTS "Anyone can view active SOS alerts" ON sos_alerts;
CREATE POLICY "Anyone can view active SOS alerts" 
  ON sos_alerts FOR SELECT 
  USING (true);

DROP POLICY IF EXISTS "Users can insert their own SOS alerts" ON sos_alerts;
CREATE POLICY "Users can insert their own SOS alerts" 
  ON sos_alerts FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own SOS alerts" ON sos_alerts;
CREATE POLICY "Users can update their own SOS alerts" 
  ON sos_alerts FOR UPDATE 
  USING (auth.uid() = user_id);

-- ========== ROAD REPORTS TABLE POLICIES ==========
DROP POLICY IF EXISTS "Anyone can view road reports" ON road_reports;
CREATE POLICY "Anyone can view road reports" 
  ON road_reports FOR SELECT 
  USING (true);

DROP POLICY IF EXISTS "Users can insert road reports" ON road_reports;
CREATE POLICY "Users can insert road reports" 
  ON road_reports FOR INSERT 
  WITH CHECK (auth.uid() = reported_by);

DROP POLICY IF EXISTS "Users can update their own road reports" ON road_reports;
CREATE POLICY "Users can update their own road reports" 
  ON road_reports FOR UPDATE 
  USING (auth.uid() = reported_by);

-- =============================================
-- SEAT BOOKING TRANSACTION FUNCTION
-- =============================================
CREATE OR REPLACE FUNCTION book_ride_seat(
  p_ride_id UUID,
  p_passenger_id UUID,
  p_passenger_name TEXT,
  p_passenger_phone TEXT,
  p_seats_booked INT,
  p_total_price DECIMAL,
  p_from_location TEXT DEFAULT NULL,
  p_to_location TEXT DEFAULT NULL,
  p_from_lat DECIMAL DEFAULT NULL,
  p_from_lng DECIMAL DEFAULT NULL,
  p_to_lat DECIMAL DEFAULT NULL,
  p_to_lng DECIMAL DEFAULT NULL
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

  -- Check karo ride departure time aur booking time ke beech 5 min ka gap hai
  IF v_ride.departure_datetime < (NOW() + INTERVAL '5 minutes') THEN
    RETURN json_build_object('success', false, 'error', 'Booking closes 5 minutes before departure');
  END IF;

  -- Check karo seats available hain
  IF v_ride.available_seats < p_seats_booked THEN
    RETURN json_build_object('success', false, 'error', 'Not enough seats available');
  END IF;

  -- Booking banao
  INSERT INTO bookings (
    ride_id, passenger_id, driver_id,
    passenger_name, passenger_phone,
    from_location, to_location,
    from_lat, from_lng, to_lat, to_lng,
    seats_booked, total_price, status
  ) VALUES (
    p_ride_id, p_passenger_id, v_ride.driver_id,
    p_passenger_name, p_passenger_phone,
    p_from_location, p_to_location,
    p_from_lat, p_from_lng, p_to_lat, p_to_lng,
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

  -- Send notification to driver (English)
  INSERT INTO notifications (user_id, title, message, type, ride_id, booking_id)
  VALUES (
    v_ride.driver_id,
    'New Booking!',
    p_passenger_name || ' booked ' || p_seats_booked::TEXT || ' seat(s) from ' || p_from_location || ' to ' || p_to_location,
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

-- ==========================================
-- SETUP STORAGE BUCKETS, POLICIES & MISSING COLUMNS
-- ==========================================

-- 1. Add missing custom columns to tables
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS from_location TEXT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS to_location TEXT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS from_lat DECIMAL(10,8);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS from_lng DECIMAL(11,8);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS to_lat DECIMAL(10,8);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS to_lng DECIMAL(11,8);

ALTER TABLE users ADD COLUMN IF NOT EXISTS driving_license_number TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS puc_number TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS insurance_number TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_no_smoking BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_no_music BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_no_heavy_luggage BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_no_pets BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_negotiation BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS vehicle_license_plate TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS vehicle_model TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS vehicle_color TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS vehicle_type TEXT DEFAULT 'Car';
ALTER TABLE users ADD COLUMN IF NOT EXISTS pincode TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS state TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS city TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS tehsil TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_type TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_number TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_doc_url TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_doc_type TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_doc_url TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_no_smoking BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_no_music BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_no_heavy_luggage BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_no_pets BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS pref_negotiation BOOLEAN DEFAULT FALSE;

-- 2. Create Buckets
INSERT INTO storage.buckets (id, name, public) VALUES ('profile-photos', 'profile-photos', true) ON CONFLICT DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('user-documents', 'user-documents', false) ON CONFLICT DO NOTHING;

-- 3. Profile Photos Policies
DROP POLICY IF EXISTS "Public Profile Photos" ON storage.objects;
CREATE POLICY "Public Profile Photos" ON storage.objects FOR SELECT USING (bucket_id = 'profile-photos');

DROP POLICY IF EXISTS "Users can upload profile photos" ON storage.objects;
CREATE POLICY "Users can upload profile photos" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'profile-photos' AND auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can update their profile photos" ON storage.objects;
CREATE POLICY "Users can update their profile photos" ON storage.objects FOR UPDATE USING (bucket_id = 'profile-photos' AND auth.uid() = owner);

DROP POLICY IF EXISTS "Users can delete their profile photos" ON storage.objects;
CREATE POLICY "Users can delete their profile photos" ON storage.objects FOR DELETE USING (bucket_id = 'profile-photos' AND auth.uid() = owner);

-- 4. User Documents Policies
DROP POLICY IF EXISTS "Users can upload documents" ON storage.objects;
CREATE POLICY "Users can upload documents" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'user-documents' AND auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can view their documents" ON storage.objects;
CREATE POLICY "Users can view their documents" ON storage.objects FOR SELECT USING (bucket_id = 'user-documents' AND auth.uid() = owner);

DROP POLICY IF EXISTS "Users can update their documents" ON storage.objects;
CREATE POLICY "Users can update their documents" ON storage.objects FOR UPDATE USING (bucket_id = 'user-documents' AND auth.uid() = owner);

DROP POLICY IF EXISTS "Users can delete their documents" ON storage.objects;
CREATE POLICY "Users can delete their documents" ON storage.objects FOR DELETE USING (bucket_id = 'user-documents' AND auth.uid() = owner);

-- =============================================
-- RIDE SEARCH TRACKING (For failed searches)
-- =============================================
CREATE TABLE IF NOT EXISTS ride_searches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  from_location TEXT NOT NULL,
  to_location TEXT NOT NULL,
  from_lat DECIMAL(10,8),
  from_lng DECIMAL(11,8),
  to_lat DECIMAL(10,8),
  to_lng DECIMAL(11,8),
  search_date DATE DEFAULT CURRENT_DATE,
  processed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ride_searches_coords ON ride_searches(from_lat, from_lng, to_lat, to_lng);

-- RLS for ride_searches
ALTER TABLE ride_searches ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can insert their own searches" ON ride_searches;
CREATE POLICY "Users can insert their own searches" ON ride_searches FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can view their own searches" ON ride_searches;
CREATE POLICY "Users can view their own searches" ON ride_searches FOR SELECT USING (auth.uid() = user_id);

-- =============================================
-- NOTIFY MATCHING RIDE FUNCTION
-- =============================================
CREATE OR REPLACE FUNCTION notify_matching_ride_searches()
RETURNS TRIGGER AS $$
BEGIN
  -- 1. Notify passengers who were looking for this route
  INSERT INTO notifications (user_id, title, message, type, ride_id)
  SELECT 
    rs.user_id,
    'Ride Available!',
    'A new ride is available from ' || NEW.from_location || ' to ' || NEW.to_location || '.',
    'ride_alert',
    NEW.id
  FROM ride_searches rs
  WHERE rs.processed = FALSE
    AND rs.search_date >= CURRENT_DATE
    AND (
      (rs.from_lat IS NOT NULL AND NEW.from_lat IS NOT NULL 
       AND abs(rs.from_lat - NEW.from_lat) < 0.05 
       AND abs(rs.from_lng - NEW.from_lng) < 0.05
       AND abs(rs.to_lat - NEW.to_lat) < 0.05
       AND abs(rs.to_lng - NEW.to_lng) < 0.05)
      OR
      (rs.from_location IS NOT NULL AND NEW.from_location IS NOT NULL
       AND NEW.from_location ILIKE '%' || rs.from_location || '%' 
       AND NEW.to_location ILIKE '%' || rs.to_location || '%')
    );

  -- 2. Notify the Driver that passengers are interested in this route
  INSERT INTO notifications (user_id, title, message, type, ride_id)
  SELECT 
    NEW.driver_id,
    'Potential Passengers Found!',
    'Users are looking for rides on your route. Your ride might get booked soon!',
    'passenger_interest',
    NEW.id
  WHERE EXISTS (
    SELECT 1 FROM ride_searches 
    WHERE processed = FALSE 
      AND search_date >= CURRENT_DATE
      AND (
        (from_lat IS NOT NULL AND NEW.from_lat IS NOT NULL 
         AND abs(from_lat - NEW.from_lat) < 0.05 
         AND abs(from_lng - NEW.from_lng) < 0.05
         AND abs(to_lat - NEW.to_lat) < 0.05
         AND abs(to_lng - NEW.to_lng) < 0.05)
        OR
        (from_location IS NOT NULL AND NEW.from_location IS NOT NULL
         AND NEW.from_location ILIKE '%' || from_location || '%' 
         AND NEW.to_location ILIKE '%' || to_location || '%')
      )
  );

  -- Mark searches as processed so they don't get notified multiple times
  UPDATE ride_searches 
  SET processed = TRUE 
  WHERE (from_lat IS NOT NULL AND NEW.from_lat IS NOT NULL 
         AND abs(from_lat - NEW.from_lat) < 0.05 
         AND abs(from_lng - NEW.from_lng) < 0.05
         AND abs(to_lat - NEW.to_lat) < 0.05
         AND abs(to_lng - NEW.to_lng) < 0.05)
     OR (from_location IS NOT NULL AND NEW.from_location IS NOT NULL
         AND NEW.from_location ILIKE '%' || from_location || '%' 
         AND NEW.to_location ILIKE '%' || to_location || '%');

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_notify_matching_ride ON rides;
CREATE TRIGGER trigger_notify_matching_ride
  AFTER INSERT ON rides
  FOR EACH ROW
  EXECUTE FUNCTION notify_matching_ride_searches();

-- 5. Refresh Schema Cache
NOTIFY pgrst, 'reload schema';-- =============================================
-- CANCEL BOOKING FUNCTION (Allows Driver & Passenger)
-- =============================================
CREATE OR REPLACE FUNCTION cancel_booking(
  p_booking_id UUID,
  p_user_id UUID,
  p_reason TEXT DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
  v_booking bookings%ROWTYPE;
  v_is_driver BOOLEAN;
BEGIN
  SELECT * INTO v_booking FROM bookings
  WHERE id = p_booking_id FOR UPDATE;

  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Booking not found');
  END IF;

  v_is_driver := (v_booking.driver_id = p_user_id);

  IF v_booking.passenger_id != p_user_id AND NOT v_is_driver THEN
    RETURN json_build_object('success', false, 'error', 'Not authorized');
  END IF;

  IF v_booking.status != 'confirmed' THEN
    RETURN json_build_object('success', false, 'error', 'Booking already cancelled');
  END IF;

  -- Cancel booking
  UPDATE bookings SET
    status = 'cancelled',
    cancelled_at = NOW(),
    cancel_reason = p_reason
  WHERE id = p_booking_id;

  -- Restore seats
  UPDATE rides SET
    available_seats = available_seats + v_booking.seats_booked,
    status = 'active'
  WHERE id = v_booking.ride_id;

  -- Send notification
  IF v_is_driver THEN
    -- Notify passenger that driver canceled
    INSERT INTO notifications (user_id, title, message, type, ride_id, booking_id)
    VALUES (
      v_booking.passenger_id,
      'Booking Cancelled by Driver',
      'The driver has cancelled your booking for ' || v_booking.seats_booked || ' seat(s).',
      'booking_cancelled',
      v_booking.ride_id,
      p_booking_id
    );
  ELSE
    -- Notify driver that passenger canceled
    INSERT INTO notifications (user_id, title, message, type, ride_id, booking_id)
    VALUES (
      v_booking.driver_id,
      'Booking Cancelled by Passenger',
      v_booking.passenger_name || ' cancelled their booking.',
      'booking_cancelled',
      v_booking.ride_id,
      p_booking_id
    );
  END IF;

  RETURN json_build_object('success', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- =============================================
-- FULL RIDE CANCELLATION BY DRIVER
-- =============================================
CREATE OR REPLACE FUNCTION cancel_full_ride(
  p_ride_id UUID,
  p_driver_id UUID,
  p_reason TEXT DEFAULT 'Driver cancelled the ride'
)
RETURNS JSON AS $$
DECLARE
  v_ride rides%ROWTYPE;
  v_booking RECORD;
BEGIN
  SELECT * INTO v_ride FROM rides WHERE id = p_ride_id FOR UPDATE;

  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Ride not found');
  END IF;

  IF v_ride.driver_id != p_driver_id THEN
    RETURN json_build_object('success', false, 'error', 'Not authorized');
  END IF;

  IF v_ride.status = 'cancelled' THEN
    RETURN json_build_object('success', false, 'error', 'Ride is already cancelled');
  END IF;

  -- 1. Cancel the Ride itself
  UPDATE rides SET 
    status = 'cancelled', 
    updated_at = NOW() 
  WHERE id = p_ride_id;

  -- 2. Loop through all confirmed bookings and cancel them + notify passengers
  FOR v_booking IN SELECT * FROM bookings WHERE ride_id = p_ride_id AND status = 'confirmed'
  LOOP
    -- Update booking
    UPDATE bookings SET
      status = 'cancelled',
      cancelled_at = NOW(),
      cancel_reason = p_reason
    WHERE id = v_booking.id;

    -- Notify passenger
    INSERT INTO notifications (user_id, title, message, type, ride_id, booking_id)
    VALUES (
      v_booking.passenger_id,
      'Ride Cancelled',
      'The driver just cancelled the entire ride from ' || v_ride.from_location || ' to ' || v_ride.to_location || '.',
      'ride_cancelled',
      p_ride_id,
      v_booking.id
    );
  END LOOP;

  RETURN json_build_object('success', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- =============================================
-- REVIEWS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ride_id UUID NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  reviewer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reviewee_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(booking_id, reviewer_id) -- One review per booking per side
);

-- =============================================
-- UPDATE USER RATING FUNCTION
-- =============================================
CREATE OR REPLACE FUNCTION update_user_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users
  SET 
    rating = (SELECT AVG(rating)::DECIMAL(2,1) FROM reviews WHERE reviewee_id = NEW.reviewee_id),
    total_rides_given = CASE 
      WHEN EXISTS (SELECT 1 FROM rides WHERE driver_id = NEW.reviewee_id AND id = NEW.ride_id) 
      THEN total_rides_given + 1 ELSE total_rides_given END,
    total_rides_taken = CASE 
      WHEN EXISTS (SELECT 1 FROM bookings WHERE passenger_id = NEW.reviewee_id AND id = NEW.booking_id) 
      THEN total_rides_taken + 1 ELSE total_rides_taken END
  WHERE id = NEW.reviewee_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_user_rating ON reviews;
CREATE TRIGGER trigger_update_user_rating
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_user_rating();
-- =============================================
-- AUTO-COMPLETE EXPIRED RIDES
-- =============================================
-- Yeh function rides ko update karega jo purani ho chuki hain
CREATE OR REPLACE FUNCTION expire_completed_rides()
RETURNS void AS $$
BEGIN
  -- 1. Jo rides start ho chuki hain (time cross ho gaya), unhe 'ongoing' mark karo 
  -- Taaki naye log use search na kar sakein
  UPDATE rides
  SET status = 'ongoing', updated_at = NOW()
  WHERE status = 'active'
    AND departure_datetime <= NOW();

  -- 2. Jo rides khatam ho chuki hain (departure + duration + buffer), unhe 'completed' mark karo
  UPDATE rides
  SET status = 'completed', updated_at = NOW()
  WHERE status IN ('ongoing', 'full')
    AND departure_datetime + (duration_mins + 60 || ' minutes')::interval < NOW();

  -- 3. Bookings ko bhi update karo
  UPDATE bookings
  SET status = 'completed'
  WHERE status = 'confirmed'
    AND ride_id IN (SELECT id FROM rides WHERE status = 'completed');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: Jab koi naya booking aaye ya ride update ho, ek baar expiration check kar lo
-- Note: Real professional apps ke liye cron job use hoti hai, 
-- par system performance ke liye hum isse frequent events pe hook kar rahe hain.
CREATE OR REPLACE FUNCTION check_expiration_on_activity()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM expire_completed_rides();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_check_expiration_on_ride ON rides;
CREATE TRIGGER trigger_check_expiration_on_ride
  AFTER INSERT ON rides
  FOR EACH STATEMENT EXECUTE FUNCTION check_expiration_on_activity();

DROP TRIGGER IF EXISTS trigger_check_expiration_on_booking ON bookings;
CREATE TRIGGER trigger_check_expiration_on_booking
  AFTER INSERT ON bookings
  FOR EACH STATEMENT EXECUTE FUNCTION check_expiration_on_activity();

-- =============================================
-- 6. ENABLE REALTIME FOR CHATS, MESSAGES & NOTIFICATIONS
-- =============================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'chats') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE chats;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'messages') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE messages;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'notifications') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
  END IF;
END $$;

-- =============================================
-- 7. CHAT MESSAGE NOTIFICATION TRIGGER
-- =============================================
CREATE OR REPLACE FUNCTION notify_chat_message()
RETURNS TRIGGER AS $$
DECLARE
  v_other_user_id UUID;
  v_sender_name TEXT;
  v_ride_id UUID;
BEGIN
  -- Get the other participant in the chat
  SELECT 
    CASE WHEN participant_1 = NEW.sender_id THEN participant_2 ELSE participant_1 END,
    ride_id
  INTO v_other_user_id, v_ride_id
  FROM chats 
  WHERE id = NEW.chat_id;

  -- Get sender name
  SELECT full_name INTO v_sender_name FROM users WHERE id = NEW.sender_id;

  -- Insert notification for the other user
  INSERT INTO notifications (user_id, title, message, type, ride_id)
  VALUES (
    v_other_user_id,
    'New Message from ' || v_sender_name,
    NEW.text,
    'chat_message',
    v_ride_id
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_notify_chat_message ON messages;
CREATE TRIGGER trigger_notify_chat_message
  AFTER INSERT ON messages
  FOR EACH ROW
  EXECUTE FUNCTION notify_chat_message();

-- Final Cache Refresh
NOTIFY pgrst, 'reload schema';

-- =============================================
-- MASTER ADMIN SETUP (khutail1985@gmail.com)
-- =============================================
-- This trigger ensures this specific email is always marked as admin
-- whenever the record is inserted or updated.
CREATE OR REPLACE FUNCTION handle_master_admin()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email = 'khutail1985@gmail.com' THEN
    NEW.is_admin := TRUE;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_master_admin ON users;
CREATE TRIGGER tr_master_admin
  BEFORE INSERT OR UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION handle_master_admin();

-- Force update if the user already exists in the table
UPDATE users 
SET is_admin = true 
WHERE email = 'khutail1985@gmail.com';

-- =============================================
-- AUTH PROFILE AUTOMATION (Master Admin Check)
-- =============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, is_admin)
  VALUES (
    new.id, 
    new.email, 
    COALESCE(new.raw_user_meta_data->>'full_name', 'Admin User'),
    CASE WHEN new.email = 'khutail1985@gmail.com' THEN TRUE ELSE FALSE END
  )
  ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email,
    is_admin = (new.email = 'khutail1985@gmail.com');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Force sync existing users
INSERT INTO public.users (id, email, is_admin)
SELECT id, email, (email = 'khutail1985@gmail.com')
FROM auth.users
ON CONFLICT (id) DO UPDATE SET is_admin = (public.users.email = 'khutail1985@gmail.com');

/* 
  MASTER ADMIN AUTH CREATION (Run this only if you can't use the Dashboard "Add User" button)
  Ensure 'pgcrypto' extension is enabled for crypt() function.
  
  CREATE EXTENSION IF NOT EXISTS pgcrypto;

  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role)
  VALUES (
      uuid_generate_v4(),
      'khutail1985@gmail.com',
      crypt('Admin@123', gen_salt('bf')),
      now(),
      '{"provider":"email","providers":["email"]}',
      '{"full_name":"Master Admin"}',
      now(),
      now(),
      'authenticated'
  ) ON CONFLICT (email) DO UPDATE SET email_confirmed_at = now();
*/
-- =============================================
-- ADMIN OVERRIDE & RLS POLICIES (ADDED BY AG)
-- =============================================

-- 1. Add status column to sos_alerts if missing
ALTER TABLE sos_alerts ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'active';

-- 2. Admin Check Function
CREATE OR REPLACE FUNCTION is_admin_v2() 
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM users 
    WHERE id = auth.uid() AND is_admin = TRUE
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Master Policies for Admin (Select, Insert, Update, Delete)
DROP POLICY IF EXISTS "Admins can do everything on users" ON users;
CREATE POLICY "Admins can do everything on users" ON users FOR ALL USING (is_admin_v2());

DROP POLICY IF EXISTS "Admins can do everything on rides" ON rides;
CREATE POLICY "Admins can do everything on rides" ON rides FOR ALL USING (is_admin_v2());

DROP POLICY IF EXISTS "Admins can do everything on bookings" ON bookings;
CREATE POLICY "Admins can do everything on bookings" ON bookings FOR ALL USING (is_admin_v2());

DROP POLICY IF EXISTS "Admins can do everything on sos_alerts" ON sos_alerts;
CREATE POLICY "Admins can do everything on sos_alerts" ON sos_alerts FOR ALL USING (is_admin_v2());

DROP POLICY IF EXISTS "Admins can do everything on notifications" ON notifications;
CREATE POLICY "Admins can do everything on notifications" ON notifications FOR ALL USING (is_admin_v2());

-- 4. Specific SOS resolve policy (if needed separately)
DROP POLICY IF EXISTS "Admin can update any SOS" ON sos_alerts;
CREATE POLICY "Admin can update any SOS" ON sos_alerts FOR UPDATE USING (is_admin_v2());

-- Schema cache refresh
NOTIFY pgrst, 'reload schema';

