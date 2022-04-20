//
//  Toast.swift
//  tfe
//
//  Created by martin d'hoedt on 4/8/22.
//
// thanks to : https://swiftuirecipes.com/blog/swiftui-toast

import Foundation
import SwiftUI

struct Toast: ViewModifier {
    static let short: TimeInterval = 2
    static let long: TimeInterval = 3.5
    
    let message: String
    @Binding var isShowing: Bool
    let type: NotificationType
    let config: Config
    
    private let color : Color
    
    init(
        message: String,
        isShowing: Binding<Bool>,
        type: NotificationType,
        config: Config
    ) {
        self.message = message
        self._isShowing = isShowing
        self.type = type
        self.config = config
        self.color = Notification.getColor(type: type)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            toastView
                .padding()
        }
    }
}

extension Toast {
    private var toastView: some View {
        VStack {
            if isShowing {
                toast
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
                            isShowing = false
                        }
                    }
            }
            Spacer()
        }
        .padding()
        .animation(config.animation, value: isShowing)
        .transition(config.transition)
    }
    
    private var toast: some View {
        Group {
            HStack {
                Notification.getIcon(type: self.type)
                    .accentColor(.black)
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .font(config.font)
            }
        }
        .padding(10)
        .background(color)
        .cornerRadius(10)
//        .border(Color.black.opacity(0.9))
        .shadow(color: .black, radius: 5, x: 3.0, y: 3.0)
        .onTapGesture {
            isShowing = false
        }
    }
    
    struct Config {
        let textColor: Color
        let font: Font
        let backgroundColor: Color
        let duration: TimeInterval
        let transition: AnyTransition
        let animation: Animation
        
        init(
            textColor: Color = .white,
            font: Font = .system(size: 14),
            backgroundColor: Color = .black.opacity(0.9),
            duration: TimeInterval = Toast.short,
            transition: AnyTransition = .opacity,
            animation: Animation = .linear(duration: 0.3)
        ) {
            self.textColor = textColor
            self.font = font
            self.backgroundColor = backgroundColor
            self.duration = duration
            self.transition = transition
            self.animation = animation
        }
    }
}

extension View {
    func toast(
        message: String,
        isShowing: Binding<Bool>,
        type: NotificationType,
        config: Toast.Config
    ) -> some View {
        self.modifier(
            Toast(
                message: message,
                isShowing: isShowing,
                type: type,
                config: config
            )
        )
    }
    
    func toast(
        message: String,
        isShowing: Binding<Bool>,
        type: NotificationType = .info,
        duration: TimeInterval
    ) -> some View {
        self.modifier(
            Toast(
                message: message,
                isShowing: isShowing,
                type: type,
                config: .init(duration: duration)
            )
        )
    }
}

//struct Toast_Previews: PreviewProvider {
//    static var notificationManager = NotificationManager.shared
//    static var previews: some View {
//        VStack {
//            ForEach(NotificationType.allCases, id:\.self) { type in
//                Button(
//                    action: {
//                        triggerToast(type: NotificationType.error)
//                    },
//                    label: {
//                        Text("test")
//                    }
//                )
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Notification.getColor(type: type))
//                .accentColor(.black)
//                .cornerRadius(10)
//            }
//        }
//        .toast(
//            message: notificationManager.notification?.message ?? "",
//            isShowing: $notificationManager.isShowingToast,
//            type: notificationManager.notification?.type ?? .info,
//            duration: Toast.short)
//        .padding()
//    }
//    
//    static func triggerToast(type: NotificationType) {
//        notificationManager.notification = Notification(
//            message: type.rawValue.uppercased(),
//            type: type
//        )
//    }
//}
