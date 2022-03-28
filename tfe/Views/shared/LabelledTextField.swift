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
//                .fixedSize(horizontal: true, vertical: true)
            TextField(label, text: $value)
                .disabled(isDisabled)
                .foregroundColor(isDisabled ? .gray : .black)
        }
    }
}

struct LabelledTextField_Previews: PreviewProvider {
    @State static var value = "value"
    static var previews: some View {
        LabelledTextField(
            "ddddddddddddddd",
            $value,
            isDisabled: false
        )
    }
}
