import UserNotifications

@Observable
final class NotificationService {
    var isAuthorized = false

    func requestAuthorization() async {
        do {
            isAuthorized = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("Notification authorization failed: \(error)")
        }
    }

    func scheduleBillingReminder(for sub: Subscription) {
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        content.title = "Upcoming Bill"
        content.body = "\(sub.name) will charge \(sub.price) \(sub.currency) on \(sub.nextBillingDate.formatted(date: .abbreviated, time: .omitted))"
        content.sound = .default

        let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: sub.nextBillingDate) ?? sub.nextBillingDate
        let components = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: sub.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(for sub: Subscription) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [sub.id.uuidString])
    }
}
