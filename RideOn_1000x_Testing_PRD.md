# RideOn: TestSprite Automation PRD

**App Details:**
- **Name:** RideOn
- **Platform:** Flutter-based carpooling app
- **Backend:** Supabase
- **Mapping Service:** OpenStreetMap

**Core User Features to Test:**
- Signup/Login via OTP
- Search rides
- Book seats
- Cancel bookings
- Chat
- Trigger SOS alerts

---

## 1. Test Scenarios (Flows)
The automation robot must independently execute and track the following flows:

1. **Authentication:**
   - Signup, login, logout, wrong OTP handling.
2. **Ride Search:**
   - Location search, GPS autofill, date selection.
3. **Booking:**
   - Open ride, select seats, confirm booking.
4. **Cancel:**
   - Cancel booking and provide cancellation reason.
5. **Publish Ride:**
   - Create and publish a ride from driver side.
6. **Chat:**
   - Send/receive messages in real-time.
7. **SOS:**
   - Trigger and cancel SOS emergency alerts.

*⚠️ **Execution Constraint:** Repeat EACH flow 100–500 times using random inputs to ensure variety and robustness.*

---

## 2. Stress Testing Parameters
The system must be heavily stressed using the following conditions:
- **Rapid Tap Buttons:** Execute 1,000 rapid clicks/taps on key action buttons to test throttle/debounce logic.
- **Race Conditions:** Simulate multiple users booking the exact same ride/seat simultaneously.
- **Network Interruptions:** Perform Network ON/OFF switching mid-interaction.
- **Lifecycle Interruptions:** Perform Background/Foreground switching dynamically during API calls.

---

## 3. Fail Conditions (Test Halt Constraints)
If any of the following occur, the test must immediately fail and generate an exception report:
- **App crash**
- **Duplicate booking** (Overbooking allowed seats)
- **API/data mismatch**
- **UI freeze > 3 seconds**
- **SOS failure**

---

## 4. Logging & Tracking Rules
- **Track API response time** for all major Supabase queries and Navigation transitions.
- **Log all failed requests** and runtime errors explicitly into a `.json` or `.md` crash report upon completion.
