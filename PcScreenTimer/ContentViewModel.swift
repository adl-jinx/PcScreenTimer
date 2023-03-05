//
//  ContentViewModel.swift
//  PcScreenTimer
//
//  Created by Antonio De Luca on 04/03/23.
//

import Foundation
import UserNotifications


extension ContentView2 {
    final class ViewModel: ObservableObject {
        
        @Published var isActive = false
        @Published var showingAlert = false
        @Published var time: String = "5:00"
        @Published var minutes: Float = 5.0 {
            didSet {
                self.time = "\(Int(minutes)):00"
            }
        }
        
        private var initialTime = 0
        private var endDate = Date()
        
        func start(minutes: Float) {
            self.initialTime = Int(minutes)
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
            
        }
        
        func reset() {
            self.minutes = Float(initialTime)
            self.isActive = false
            self.time = "\(Int(minutes)):00"
        }
        
        func updateCountdown() {
            guard isActive else { return }
            
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            
            
            if diff <= 0 {
                self.isActive = false
                self.time = "0:00"
                self.showingAlert = false
                
                
                // Create a notification content
                       let content = UNMutableNotificationContent()
                       content.title = "20 Minuti"
                       content.body = "20 Secondi di pausa"
                       content.sound = UNNotificationSound.default
                       
                       // Create a notification trigger
                       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                       
                       // Create a notification request with the content and trigger
                       let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                       
                       // Add the notification request to the notification center
                       UNUserNotificationCenter.current().add(request) { error in
                           if let error = error {
                               print("Error adding notification request: \(error.localizedDescription)")
                           } else {
                               print("Notification request added successfully.")
                           }
                       }
                
                    
                return
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            self.minutes = Float(minutes)
            self.time = String(format: "%d:%02d", minutes, seconds)
            
        }
        
    }
}
