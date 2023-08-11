//
//  ImagePicker.swift
//  WeddApp
//
//  Created by Erkam Karaca on 31.07.2023.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPickerShowing: Bool
    @Binding var selectedImage: UIImage?
    @Binding var selectedImages: [UIImage]?
    var forSingleImage: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if parent.forSingleImage {
                DispatchQueue.main.async {
                    self.parent.selectedImage = image
                    // Success
                }
            } else {
                parent.selectedImages!.append(image)
                picker.dismiss(animated: true) {
                    self.parent.isPickerShowing = false
                }
            }
        }
        parent.isPickerShowing = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.isPickerShowing = false
    }
}
