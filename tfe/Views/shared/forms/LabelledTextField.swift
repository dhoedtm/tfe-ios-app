//
//  LabelledTextField.swift
//  fix
//
//  Created by martin d'hoedt on 3/28/22.
//

import SwiftUI

struct LabelledTextField: View {
    
    var label : String = ""
    @Binding var value : String
    var isDisabled : Bool = false
    
    init(_ label: String, _ value: Binding<String>, isDisabled: Bool) {
        self.label = label
        self._value = value
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.accentColor)
                .offset(y: 10)
            TextField(label, text: $value)
                .font(.subheadline)
                .disabled(isDisabled)
                .foregroundColor(isDisabled ? .gray : .black)
        }
    }
}

struct LabelledTextField_Previews: PreviewProvider {
    @State static var value = "value"
    static var previews: some View {
        LabelledTextField(
            "a very long label",
            $value,
            isDisabled: false
        )
    }
}
