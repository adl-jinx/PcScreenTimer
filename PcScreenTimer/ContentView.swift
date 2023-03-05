//
//  ContentView.swift
//  PcScreenTimer
//
//  Created by Antonio De Luca on 04/03/23.

import SwiftUI
import UserNotifications

struct ContentView: View {
    // Declare a @State variable to store whether the timer is running
    @State private var isTimerRunning = false
    
    // Declare a @State variable to store the time remaining on the timer
    @State private var timeRemaining = 7 // 20 minutes in seconds

    var body: some View {
        VStack {
            
            VStack {
                
                
                Button("Request Permission") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                } .padding(24)
                
                
                
                
                Button("Start Timer") {
                    // Start the timer when the button is tapped
                    isTimerRunning = true
                    
                    let content = UNMutableNotificationContent()
                    content.title = "20 minutes gone"
                    content.subtitle = "look away 20 seconds"
                    content.sound = UNNotificationSound.default
                    
                    // show this notification five seconds from now
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeRemaining), repeats: false)
                    
                    // choose a random identifier
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    // add our notification request
                    
                    UNUserNotificationCenter.current().add(request)
                }.padding(24)
            }
            
            
            
            Text(isTimerRunning ? "Timer On" : "Timer off")
            
            Button("Reset Timer") {
                timeRemaining = 7
                isTimerRunning = false
                
            } .padding(24)
            
        }
        
        // Add an onReceive modifier to update the timer every second
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
            // Only update the timer if it's running
            guard isTimerRunning else { return }
            
            // Decrement the time remaining by 1 second
            timeRemaining -= 1
            
            // Stop the timer and show a notification when the time runs out
            if timeRemaining == 0 {
                isTimerRunning = false
            }
        })
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
