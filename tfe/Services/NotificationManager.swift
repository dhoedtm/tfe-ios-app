//
//  NotificationManager.swift
//  tfe
//
//  Created by martin d'hoedt on 4/8/22.
//

import Foundation

class NotificationManager : ObservableObject {
    
    static let shared : NotificationManager = NotificationManager()
    
    @Published var notification : Notification? = nil {
        didSet {
            self.isShowingToast = self.notification != nil
        }
    }
    @Published var isShowingToast : Bool = false
    
    private init() { }
}
