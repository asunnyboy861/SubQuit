# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "通知" / "提醒" / "alert" → Push Notifications (billing reminders)
- "同步" / "iCloud" / "CloudKit" → iCloud capability
- "Apple订阅" / "StoreKit" → No special capability needed (StoreKit 2 works without entitlements)

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Push Notifications | ✅ Configured | Xcode UI |
| iCloud (CloudKit) | ✅ Configured | Xcode UI |
| Background Modes (Remote Notifications) | ✅ Configured | Xcode UI |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| iCloud Container | ⏳ Pending | 1. Open Xcode > Signing & Capabilities > iCloud > CloudKit > Add container "iCloud.com.zzoutuo.SubQuit" |

## No Configuration Needed
- StoreKit 2 (no entitlements required for reading subscriptions)
- UserNotifications (framework-only, no capability needed)
- SwiftData (framework-only, no capability needed)
- WidgetKit (framework-only, no capability needed)

## Verification
- Build succeeded after configuration: ⏳ Pending
- All entitlements correct: ⏳ Pending
