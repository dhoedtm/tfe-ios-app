//
//  BackButton.swift
//  tfe
//
//  Created by martin d'hoedt on 4/6/22.
//

import SwiftUI

struct BackButton<Content:View>: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let content : Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            content
        })
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton() {
            Image(systemName: "arrowshape.turn.up.backward.circle")
                .scaledToFit()
                .scaleEffect(1.5)
                .foregroundColor(.black)
        }
    }
}
