//
//  AppDelegate.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/16.
//

import Foundation
import NotificationCenter
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // リクエストのメソッド呼び出し
        NotificationManager.instance.requestPermission()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // フォアグラウンドでも banner + sound を表示する
        completionHandler([.banner, .sound])
    }
}
