//
//  NotificationService.swift
//  ChoreReward
//
//  Created by Toan Pham on 7/11/22.
//

import Foundation
import Combine
import Firebase
import FirebaseMessaging
import UserNotifications

class NotificationService: NSObject {
    private let userRepository: UserRepository

    private var currentUserSubscription: AnyCancellable?

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        addSubscription()
    }

    private func addSubscription() {
        currentUserSubscription = userRepository.userPublisher
            .sink(receiveValue: { receivedUser in
                if let receivedUser = receivedUser {
                    print("\(#fileID) \(#function): received a non-nil user, checking for FCMToken")
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
                        guard success else {
                            return
                        }
                        print("Successfully register APNS")
                    }
                }
            })
    }
}

extension NotificationService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken ?? "No fcm token")
        messaging.token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {

}
