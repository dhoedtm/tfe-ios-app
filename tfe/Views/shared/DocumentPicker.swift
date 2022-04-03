//
//  DocumentPicker.swift
//  TFE
//
//  Created by user on 02/03/2022.
//

import Foundation
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var filePaths : [URL]
    
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<DocumentPicker>
    ) -> some UIDocumentPickerViewController
    {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(
        _
        uiViewController: DocumentPicker.UIViewControllerType,
        context: UIViewControllerRepresentableContext<DocumentPicker>)
    {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(parent1: DocumentPicker) {
            parent = parent1
        }
        
        func documentPicker (
            _
            controller: UIDocumentPickerViewController,
            didPickDocumentsAt urls : [URL]
        ) {
            parent.filePaths = urls
            
            for url in urls {
                print("[documentPicker] selected file : \(url.absoluteString)")
            }
        }
    }
}
