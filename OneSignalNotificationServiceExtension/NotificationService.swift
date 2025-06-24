


class NotificationService: UNNotificationServiceExtension {override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    if let bestAttemptContent = bestAttemptContent {
        
        contentHandler(bestAttemptContent)
    }
}

override func serviceExtensionTimeWillExpire() {
    if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
        contentHandler(bestAttemptContent)
    }
}

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    

}
import UserNotifications
