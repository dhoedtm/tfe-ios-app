//
//  Badge.swift
//  tfe
//
//  Created by martin d'hoedt on 4/6/22.
//

import SwiftUI

struct Badge: View {
    let type : NotificationType
    let text : String
    var body: some View {
        makeBadge(type: type, text: text)
    }
}

func makeBadge(type: NotificationType, text: String) -> some View {
    var color : Color
    switch (type) {
    case .info :
        color = Color.blue.opacity(0.5)
    break
    case .warning :
        color = Color.yellow.opacity(0.5)
    break
    case .success :
        color = Color.blue.opacity(0.5)
    break
    case .error :
        color = Color.red.opacity(0.5)
    }
    
    return Text(text)
        .frame(maxWidth: .infinity)
        .padding()
        .background(color)
        .cornerRadius(10)
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Badge(type: .info, text: "this is an info")
            Badge(type: .warning, text: "this is a warning")
            Badge(type: .error, text: "this is an error")
        }
    }
}
