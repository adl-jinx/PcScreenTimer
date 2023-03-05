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
    
        
        
        let content = UNMutableNotificationContent()
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
                self.showingAlert = true
                // Schedule a local notification
                    let content = UNMutableNotificationContent()
                    content.title = "Timer Done"
                    content.body = "Your timer has completed"
                    content.sound = UNNotificationSound.defaul
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.showingAlert, repeats: false)
                    
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                    
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