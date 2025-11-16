//
//  NotificationManager.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/16.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let instance: NotificationManager = NotificationManager()
    
    // 権限リクエスト
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if let error = error {
                    print("Permission error: \(error.localizedDescription)")
                }
            }
    }
    
    // notificationの登録
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Local Notification Test"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification01", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // 毎日指定した時間に通知を送る（繰り返し）
    func scheduleRepeatingNotification(title: String, body: String, hour: Int, minute: Int, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            } else {
                print("Repeating notification scheduled for \(hour):\(minute)")
            }
        }
    }
    
    // 登録されている通知を確認（デバッグ用）
    func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Pending notifications: \(requests.count)")
            requests.forEach { request in
                print("ID: \(request.identifier), Title: \(request.content.title)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    print("Trigger: \(trigger.dateComponents)")
                }
            }
        }
    }
    
    // 通知をキャンセル
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // すべての通知をキャンセル
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
