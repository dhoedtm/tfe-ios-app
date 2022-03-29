//
//  LabelledText.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import SwiftUI

struct LabelledText: View {
    
    var label : String = ""
    var value : String = ""
    
    init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.accentColor)
            Text(value)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LabelledText_Previews: PreviewProvider {
    static var previews: some View {
        LabelledText(
            "a very long label",
            "my value ;)"
        )
    }
}
