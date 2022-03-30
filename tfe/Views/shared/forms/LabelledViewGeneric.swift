//
//  LabelledViewGeneric.swift
//  tfe
//
//  Created by martin d'hoedt on 3/30/22.
//

import SwiftUI

struct LabelledViewGeneric<Content:View>: View {
    
    var label : String = ""
    let content: Content
    
    init(_ label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.accentColor)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LabelledViewGeneric_Previews: PreviewProvider {
    static var previews: some View {
        LabelledViewGeneric("a very long label") {
            Text("custom view")
        }
    }
}
