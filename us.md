# SubQuit - iOS Development Guide

## Executive Summary

SubQuit is a privacy-first subscription cancellation assistant that goes beyond tracking — it helps users take action. Unlike competitors that only list subscriptions or require bank account access, SubQuit provides step-by-step cancellation guides with difficulty ratings, estimated time, and actionable tips for 100+ popular services.

**Target Audience**: US consumers (primary), UK, Canada, Australia — anyone paying for subscriptions who wants to cancel unwanted ones and save money.

**Key Differentiators**:
- Step-by-step cancellation guides with difficulty ratings (Easy/Medium/Hard/Very Hard)
- Privacy-first: no bank account access required
- Apple subscription auto-detection via StoreKit 2
- Savings dashboard showing money saved from cancellations
- ADHD-friendly design with clear, anxiety-reducing UI

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Bobby (4.7 stars) | Clean UI, manual tracking, bill reminders, $2.99 IAP | No cancellation guides, tracking only, no action | We provide cancellation guides + tracking |
| Rocket Money (4.5 stars) | Auto-detect via bank, cancel on your behalf, bill negotiation | Requires bank access (privacy concern), $6-12/month expensive | Privacy-first, no bank access needed, affordable |
| Subee (~3.5 stars) | Cancellation assistance, refund guidance | Low rating, unstable, core features behind paywall | Better UX, stable, comprehensive guide library |

**Market Gap**: No app combines subscription tracking + step-by-step cancellation guides + savings tracking + privacy-first design + ADHD-friendly UX.

## Apple Design Guidelines Compliance

- **Clarity**: Clean typography, intuitive icons, no visual clutter; cancellation steps use numbered cards with clear instructions
- **Deference**: Content-first design; subscription cards show essential info at a glance
- **Depth**: Subtle shadows on cards, smooth navigation transitions, tab-based hierarchy
- **HIG Navigation**: TabView with 4 tabs (Home, Cancel Guide, Savings, Settings)
- **HIG Controls**: Standard SwiftUI components, SF Symbols for icons
- **HIG Color**: System colors with semantic meaning (green=easy, orange=medium, red=hard)
- **Accessibility**: Dynamic Type support, VoiceOver labels, high contrast colors
- **iPad**: Adaptive layout with `.frame(maxWidth: 720)` for content width

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary)
- **Data**: SwiftData with @Model classes
- **Sync**: CloudKit (optional, toggle in Settings)
- **Notifications**: UserNotifications framework for billing reminders
- **IAP**: StoreKit 2 for Apple subscription detection
- **Charts**: Swift Charts for savings visualization
- **Widgets**: WidgetKit for home screen subscription overview

## Module Structure

```
SubQuit/
├── SubQuitApp.swift
├── Views/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   └── SubscriptionCard.swift
│   ├── CancelGuide/
│   │   ├── CancelGuideListView.swift
│   │   ├── CancelGuideDetailView.swift
│   │   ├── CancelStepView.swift
│   │   └── StepCard.swift
│   ├── Savings/
│   │   ├── SavingsView.swift
│   │   └── SavingsChart.swift
│   ├── AddSubscription/
│   │   └── AddSubscriptionView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── ContactSupportView.swift
│   └── Components/
│       ├── CategoryBadge.swift
│       ├── DifficultyBadge.swift
│       └── BillingCyclePicker.swift
├── Models/
│   ├── Subscription.swift
│   ├── CancelGuide.swift
│   ├── CancelStep.swift
│   └── SavingsRecord.swift
├── ViewModels/
│   ├── SubscriptionListVM.swift
│   ├── CancelGuideVM.swift
│   └── SavingsVM.swift
├── Services/
│   ├── NotificationService.swift
│   ├── AppleSubDetector.swift
│   ├── SavingsCalculator.swift
│   └── CancelGuideRepository.swift
├── Resources/
│   └── CancelGuides/
│       ├── cancel_guides_index.json
│       └── (100+ service JSON files bundled)
└── Assets.xcassets/
```

## Implementation Flow

1. Create data models (Subscription, CancelGuide, CancelStep, SavingsRecord) with SwiftData
2. Build CancelGuideRepository to load bundled JSON cancellation guides
3. Build HomeView with subscription list and monthly total
4. Build AddSubscriptionView for manual subscription entry
5. Build CancelGuideListView with search and category filtering
6. Build CancelGuideDetailView with step-by-step cancellation flow
7. Build SavingsView with Swift Charts visualization
8. Build AppleSubDetector using StoreKit 2
9. Build NotificationService for billing reminders
10. Build SettingsView with iCloud sync toggle, contact support, policy links
11. Build ContactSupportView with feedback backend integration
12. Integrate all views in TabView navigation
13. Add SwiftData container with CloudKit option
14. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**: 
  - Primary: #007AFF (system blue)
  - Success/Easy: #34C759 (green)
  - Warning/Medium: #FF9500 (orange)
  - Danger/Hard: #FF3B30 (red)
  - Very Hard: #8E0038 (dark red)
  - Background: System grouped background
  - Card: System secondary grouped background

- **Typography**: 
  - Title: .title (.bold)
  - Headline: .headline
  - Body: .body
  - Caption: .caption (.secondary)
  - All support Dynamic Type

- **Layout**:
  - TabView with 4 tabs: Home, Guides, Savings, Settings
  - Card-based subscription list with category icons
  - Step-by-step cancellation flow with progress indicator
  - iPad: `.frame(maxWidth: 720).frame(maxWidth: .infinity)` for content

- **Animations**:
  - Card tap: .spring(duration: 0.3)
  - Tab switch: default transition
  - Step completion: checkmark animation with .easeInOut
  - Savings counter: number animation

## Code Generation Rules

- SwiftData @Model for all persistent data
- MVVM pattern with @Observable ViewModels
- No comments in code unless asked
- SF Symbols for all icons
- Swift Charts for data visualization
- StoreKit 2 (not StoreKit 1) for Apple subscription detection
- Bundle cancellation guides as JSON in Resources
- Privacy-first: no network requests for subscription data
- iPad adaptive layout with maxWidth constraint

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.SubQuit
2. Verify Deployment Target: iOS 17.0
3. Build succeeds on iPhone simulator
4. Build succeeds on iPad simulator
5. App launches and displays home view
6. Cancellation guides load from bundled JSON
7. SwiftData persistence works correctly
8. Notifications register and fire correctly
9. StoreKit 2 Apple subscription detection works
10. Settings links to policy pages
11. Contact support form submits successfully
12. Push to GitHub repository
