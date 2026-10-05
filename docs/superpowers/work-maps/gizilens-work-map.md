# GiziLens Mobile App

Scaffold shell and onboarding first, then daily dashboard, camera capture, analysis results, and history.

## Work Map (feature → subfeature → task)
Summary: Scaffold shell and onboarding first, then daily dashboard, camera capture, analysis results, and history.
- [feature] Foundation & App Shell: Design tokens, navigation shell, optional auth, onboarding, and user profile
  - [subfeature] App Shell & Auth Scaffolding: Global design tokens, bottom navigation bar, splash screen, and optional auth UI
    - [task] Setup Theme & Tokens: Configure typography, spacing, radius, and color palette with emerald accent
    - [task] Build App Shell Navigation: Bottom navigation with central floating capture button and tab state preservation
    - [task] Build Splash & Auth Screens: Splash screen, login, registration, and forgot password with toggleable bypass
  - [subfeature] Onboarding & User Profile: 3-slide onboarding with ompreng illustration, profile setup form, and validation
    - [task] Build Onboarding Carousel: Three-slide carousel featuring ompreng artwork, slide indicators, and start CTA
    - [task] Build Profile Setup & Edit Form: Profile input form with numeric keyboard, unit suffix, inline validation, and submit
- [feature] Daily Nutrition Monitoring: Home dashboard with energy summary, macronutrients, feedback cards, and daily food list
  - [subfeature] Nutrition Summary & Feedback: Daily energy card, macronutrient progress indicators, and contextual feedback
    - [task] Build Dashboard Header & Date Bar: Personalized greeting, subtitle, and current date context display
    - [task] Build Energy & Macro Cards: Daily energy progress card and horizontal macro cards with target comparisons
    - [task] Build Feedback & Status Chips: Prioritized feedback card and non-color-exclusive status chips for nutrients
  - [subfeature] Today Consumption & Empty States: Chronological food consumption cards and zero-intake dashboard empty states
    - [task] Build Today Food Record Cards: Consumption cards showing food name, timestamp, portion, calories, and chevron
    - [task] Build Dashboard Empty & Skeletons: Zero-intake empty state with capture CTA and shimmer loading skeletons
- [feature] Food Media Capture & Preview: Camera viewfinder with ompreng framing guide, photo/video modes, and media preview
  - [subfeature] Camera View & Ompreng Guide: Viewfinder layout, multi-compartment ompreng overlay, and mode toggles
    - [task] Build Camera View & Ompreng Guide: Full-screen viewfinder with transparent ompreng multi-compartment silhouette guide
    - [task] Build Shutter & Mode Switcher: Photo shutter, video recording timer with auto-stop, and mode selector toggle
    - [task] Build Permission Denied Screen: Camera and microphone permission explanation with recoverable settings CTA
  - [subfeature] Media Preview & Gallery Entry: Media confirmation screen, retake controls, and gallery picker integration
    - [task] Build Media Preview Screen: Image/video preview card with analyze CTA, retake action, and double-tap prevention
    - [task] Build Gallery Media Picker: Gallery selection trigger with file format and size constraint validation
- [feature] Food Analysis & Portion Edit: Staged processing screen, multi-food detection result, and portion edit bottom sheet
  - [subfeature] Analysis Loading & Results: Processing progress indicator and detected food items cards layout
    - [task] Build Analysis Processing Screen: Dedicated progress animation with staged status copy and long wait messaging
    - [task] Build Multi-Food Result Screen: Detected food cards with portion, energy, macros, and dynamic nutrient summary
    - [task] Build Analysis Failure State: Unrecognized food error state with helpful copy, retake CTA, and gallery fallback
  - [subfeature] Portion Edit & Save Flow: Bottom sheet portion adjuster, timestamp confirmation, and save feedback
    - [task] Build Portion Edit Bottom Sheet: Portion modal with numeric stepper, unit dropdown, and recalculated nutrient mockup
    - [task] Build Consumption Confirmation Bar: Timestamp adjustment control, sticky Save CTA, and double-tap submission lock
    - [task] Build Save Success & Failure UI: Lightweight success toast returning to Home and recoverable save failure modal
- [feature] Nutrition Detail & History: Complete dynamic nutrient breakdown, horizontal date navigation, and calendar picker
  - [subfeature] Dynamic Nutrient Details: Full macro/micronutrient breakdown page and food record item details modal
    - [task] Build Dynamic Nutrient Detail Page: Nutrient breakdown with sorting, progress bars, missing target states, and feedback
    - [task] Build Food Record Detail Screen: Detailed record view showing media thumbnail, time, portions, and complete nutrients
  - [subfeature] History & Global Error States: Horizontal date selector, calendar modal, historical summary, and network error views
    - [task] Build Horizontal Date Selector: Scrollable date strip with day/date chips, active state styling, and calendar trigger
    - [task] Build Calendar Picker Sheet: Monthly calendar modal bottom sheet allowing quick jump to historical dates
    - [task] Build History Summary & Empty View: Historical daily nutrient summary card, recorded food list, and empty date screen
    - [task] Build Global Error & Offline UI: Network offline view, server error state with retry, and safe user-friendly copy
