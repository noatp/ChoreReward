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
    private let fcm: Messaging
    private let unc: UNUserNotificationCenter
    private var currentUserSubscription: AnyCancellable?
    private var currentUserId: String?

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.fcm = Messaging.messaging()
        self.unc = UNUserNotificationCenter.current()
        super.init()
        fcm.delegate = self
        unc.delegate = self
        addSubscription()
    }

    private func requestNotificationAuthorization() {
        unc.requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            guard success else {
                return
            }
            print("Successfully requested notification authorization")
        }
    }

    private func fetchFCMToken(afterSuccess: @escaping (_ token: String) -> Void) {
        fcm.token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                return
            } else if let token = token {
                print("FCM registration token: \(token)")
                afterSuccess(token)
            }
        }
    }

    private func deleteFCMToken() {
        fcm.deleteToken { error in
            if let error = error {
                print("\(#fileID) \(#function): \(error)")
            }
        }
    }

    private func addSubscription() {
        currentUserSubscription = userRepository.userPublisher
            .sink(receiveValue: { [weak self] receivedUser in
                guard let strongSelf = self else {
                    return
                }
                if let receivedUser = receivedUser,
                   let receivedUserId = receivedUser.id {
                    print("\(#fileID) \(#function): received a non-nil user, request authorization and fetching FCMToken")
                    strongSelf.currentUserId = receivedUserId
                    strongSelf.requestNotificationAuthorization()
                    strongSelf.fetchFCMToken(afterSuccess: { token in
                        Task {
                            await strongSelf.userRepository.updateUserFCMToken(for: receivedUserId, with: token)
                        }
                    })
                } else {
                    guard let currentUserId = strongSelf.currentUserId else {
                        return
                    }
                    print("\(#fileID) \(#function): received reset signal from UserRepository, reset notification service")
                    strongSelf.deleteFCMToken()
                }
            })
    }
}

extension NotificationService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

    }

}

extension NotificationService: UNUserNotificationCenterDelegate {

}
