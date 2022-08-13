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
import SwiftUI

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
                    print(
                        "\(#fileID) \(#function): received a non-nil user, request authorization and fetching FCMToken"
                    )
                    strongSelf.currentUserId = receivedUserId
                    strongSelf.requestNotificationAuthorization()
                    strongSelf.fetchFCMToken(afterSuccess: { token in
                        Task {
                            await strongSelf.userRepository.updateUserFCMToken(for: receivedUserId, with: token)
                        }
                    })
                }
            })
    }
}

extension NotificationService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("\(#fileID) \(#function): received a refreshed fcmToken, updating user record")
        guard let currentUserId = currentUserId else {
            return
        }
        Task {
            await userRepository.updateUserFCMToken(for: currentUserId, with: fcmToken)
        }
    }

}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // handles background notification launching app

        var components = URLComponents()
        components.scheme = "chorereward"
        components.host = "com.noatp.chorereward"

        if let choreId = response.notification.request.content.userInfo["choreId"] as? String {
            print("\(#fileID) \(#function): got choreId: \(choreId) from notification")

            components.path = "/detail"
            components.query = choreId
        } else {
            completionHandler()
            return
        }

        guard let url = components.url else {
            return
        }

        print("\(#fileID) \(#function): opening url \(url)")

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // handles foreground notification
    }

}
