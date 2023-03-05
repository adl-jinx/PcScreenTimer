//
//  ContentView2.swift
//  PcScreenTimer
//
//  Created by Antonio De Luca on 04/03/23.
//

import SwiftUI
import UserNotifications

struct ContentView2: View {
    
    
    @StateObject private var vm = ViewModel()
    private let timer = Timer.publish(every: 1, on: . main, in: .common).autoconnect()
    private let width: Double = 250
    
    
    var body: some View {
        VStack {
            
            Button("Richiesta Permesso Notifiche") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            
            Text("\(vm.time)")
                .font(.system(size:70, weight: .medium, design: .rounded))
                .padding()
                .frame(width: width)
                .background(.thinMaterial)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 4))
                .alert("Timer done!", isPresented: $vm.showingAlert) {
                    Button("Continue", role: .cancel) {
                        //code
                    }
                }
            
            Slider(value: $vm.minutes, in: 1...20, step: 1)
                .padding()
                .frame(width: width)
                .disabled(vm.isActive)
                .animation(.easeInOut, value: vm.minutes)
            
            HStack(spacing: 50){
                Button("Start") {
                    vm.start(minutes: vm.minutes)
                    
                    // Create a notification content
                           let content = UNMutableNotificationContent()
                    content.title = "\(vm.minutes) Minuti"
                           content.body = "Prenditi una pausa"
                           content.sound = UNNotificationSound.default
                           
                           // Create a notification trigger
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(vm.minutes) * 60, repeats: false)
                           
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
                    
                    
                    
                }
                .disabled(vm.isActive)
                
                Button("Reset", action: vm.reset)
                    .tint(.red)
            }
            .frame(width: width)
            
            
        }
        .onReceive(timer) { _ in
            vm.updateCountdown()
            
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
