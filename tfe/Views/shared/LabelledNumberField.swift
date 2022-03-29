//
//  LabelledNumberField.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import SwiftUI
import Combine

struct LabelledNumberField: View {
    
    var label : String
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
                .keyboardType(.numberPad)
                .onReceive(Just(value)) { newValue in
                    let filtered = newValue.filter { Set("0123456789").contains($0) }
                    if filtered != newValue {
                        self.value = filtered
                    }
                }
                .disabled(isDisabled)
                .foregroundColor(isDisabled ? .gray : .black)
            }
        }
    }

struct LabelledNumberField_Previews: PreviewProvider {
    @State static var value = "1337"
    static var previews: some View {
        LabelledNumberField(
            "a very long label",
            $value,
            isDisabled: false
        )
    }
}
