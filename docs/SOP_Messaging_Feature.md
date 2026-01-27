# SOP for Messaging and Patient Portal Access Feature

## Overview
This feature introduces a messaging system within the Care Organization portal, allowing providers to communicate with patients and other providers. Additionally, it provides a direct link from the message list to the patient's full portal view, enabling providers to review and edit patient data (Vitals, Medications, Family History, etc.).

## 1. Feature Components

### 1.1 Messaging Entry Point
- **Location:** `CareRootScreen` (`lib/features/org_dashboard/view/care_root_screen.dart`)
- **UI Element:** Message Icon in the AppBar.
- **Action:** Navigates to `MessagingScreen`.

### 1.2 Messaging Screen
- **File:** `lib/features/org_dashboard/view/messaging_screen.dart`
- **Tabs:** 
  - **Patients:** Lists patient conversations.
  - **Providers:** Lists provider conversations.
- **Data:** Currently uses mock data for demonstration.
- **Interaction:**
  - Tapping a user opens an Action Sheet.
  - Options: "Open Chat" and "View Patient Portal (Edit Mode)" (for patients).

### 1.3 Chat Screen
- **File:** `lib/features/org_dashboard/view/messaging_screen.dart` (class `ChatScreen`)
- **functionality:** Basic chat interface with bubble messages and mock input.

### 1.4 Patient Portal Access (Edit Mode)
- **Target:** `DashboardScreen` (`lib/features/dashboard/view/dashboard_screen.dart`)
- **Navigation:** From `MessagingScreen`, selecting "View Patient Portal" pushes `DashboardScreen` onto the stack.
- **Edit Capability:** 
  - The `DashboardScreen` allows navigation to sub-screens (e.g., `BloodPressureScreen`, `HealthJourneyScreen`).
  - These sub-screens have been verified to contain "Save" or "Add" functionality, allowing providers to enter data.
  - **Note:** In this PoC, the `DashboardScreen` uses the global `vitalsProvider`. Editing data here updates the global state. In a production multi-user environment, this provider must be scoped to the specific `patientId`.

## 2. Implementation Details

### 2.1 Code Changes
- **Modified `CareRootScreen`:** Added `IconButton` with `Icons.message` to AppBar actions.
- **Created `MessagingScreen`:** Implemented standard `ListView` with `ListTile` for messages. Added `showModalBottomSheet` for actions.
- **Integration:** Imported `DashboardScreen` into `MessagingScreen` to enable the portal view link.

### 2.2 Reused Components
- `DashboardScreen`: Reused as-is to provide the comprehensive patient view.
- `BloodPressureScreen`, `FamilyHistoryScreen`, `HealthJourneyScreen`: Existing screens used for data entry.

## 3. Potential Errors & Mitigations

| Error Category | Specific Issue | Mitigation / Solution |
| :--- | :--- | :--- |
| **State Management** | `vitalsProvider` is a singleton. Viewing Patient A, then Patient B might show Patient A's data if not reset. | **PoC Scope:** Acceptable for single-session demo. <br> **Production:** Refactor `vitalsProvider` to `vitalsProvider(patientId)` (Riverpod Family) or reset state on entry. |
| **Role Clarity** | `DashboardScreen` says "My Health Journeys". Confusing for Provider. | **Future Enhancement:** Pass `isProviderView` flag to `DashboardScreen` to change titles (e.g., "Patient's Health Journeys"). |
| **Navigation** | Deep navigation into Patient Portal might confuse stack history. | **Verified:** Standard `Navigator.push` ensures "Back" button returns to Messaging. |
| **Data Persistence** | Data edited in `DashboardScreen` is in-memory only. | **Production:** Connect `Save` buttons to Backend API. |

## 4. Verification Steps

1.  **Launch App:** Run `flutter run`.
2.  **Login:** Select "Care Organization" -> Login (e.g., `alice@migenesys.com`).
3.  **Access Messages:** Tap the **Message Icon** in the top-right AppBar.
4.  **Select Patient:** Tap on "James T. Kirk" in the Patients tab.
5.  **Open Portal:** Select "View Patient Portal (Edit Mode)" from the bottom sheet.
6.  **Verify View:** Confirm the Patient Dashboard loads.
7.  **Edit Data:** 
    - Tap "BP" orbiting icon or "All Vitals".
    - Enter new values and tap "Save".
    - Verify confirmation snackbar.
8.  **Return:** Tap "Back" to return to Messaging.

## 5. Future Roadmap
- Implement proper backend integration for messaging (WebSockets/FCM).
- Refactor `PatientProvider` / `VitalsProvider` to handle multi-patient caching.
- Add "Compose New Message" float action button.
