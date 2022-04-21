//
//  CustomizableActionSheet.swift
//  tfe
//
//  Created by martin d'hoedt on 4/21/22.
//

import SwiftUI

struct CustomizableActionSheet<Content:View, ButtonContent:View>: View {
    
    @Binding var showActionSheet: Bool
    let buttonContent: Content
    let actionSheetButtons: [CustomizableActionSheetButton<ButtonContent>]
    
    init(
        showActionSheet: Binding<Bool>,
        @ViewBuilder buttonContent: () -> Content,
        actionSheetButtons: [CustomizableActionSheetButton<ButtonContent>]
    ) {
        self._showActionSheet = showActionSheet
        self.buttonContent = buttonContent()
        self.actionSheetButtons = actionSheetButtons
    }
    
    var body: some View {
        ZStack {
            buttonContent
            if showActionSheet {
                VStack {
                    VStack {
                        Button {
                            withAnimation {
                                showActionSheet = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 5)
                        ForEach(self.actionSheetButtons, id: \.id) { item in
                            Button {
                                if (item.autoCollapse) {
                                    withAnimation {
                                        showActionSheet = false
                                    }
                                }
                                item.action()
                            } label: {
                                item.content
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .zIndex(1)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .shadow(radius: 25)
                }
                .animation(.spring())
                .padding(.horizontal)
                .transition(.move(edge: .bottom))
            }
        }
    }
}

struct CustomizableActionSheetButton<ButtonContent:View>: Identifiable, Hashable {
    let id = UUID()
    let content: ButtonContent
    let action: () -> ()
    let autoCollapse: Bool
    
    init(
        action: @escaping () -> (),
        @ViewBuilder content: () -> ButtonContent,
        autoCollapse: Bool
    ) {
        self.action = action
        self.content = content()
        self.autoCollapse = autoCollapse
    }
    
    static func == (
        lhs: CustomizableActionSheetButton<ButtonContent>,
        rhs: CustomizableActionSheetButton<ButtonContent>
    ) -> Bool {
        lhs.id == lhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
    }
}

struct CustomizableActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomizableActionSheet(
            showActionSheet: .constant(true),
            buttonContent: {
                HStack {
                    Image(systemName: "ellipsis")
                    Spacer()
                    Text("options")
                    Spacer()
                }
            },
            actionSheetButtons: [
                CustomizableActionSheetButton(
                    action: { print("action 1") },
                    content: { Text("action 1") },
                    autoCollapse: true
                ),
                CustomizableActionSheetButton(
                    action: { print("action 2") },
                    content: { Text("action 2") },
                    autoCollapse: true
                )
            ]
        )
    }
}
