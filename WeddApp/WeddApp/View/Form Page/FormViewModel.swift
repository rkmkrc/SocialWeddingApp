//
//  FormViewModel.swift
//  WeddApp
//
//  Created by Erkam Karaca on 30.07.2023.
//

import Foundation
import SwiftUI
import PhotosUI

struct FormScreen: View {
    @ObservedObject var model = ViewModel(id: "")
    @State private var groomName = ""
    @State private var groomSurname = ""
    @State private var groomBirthdate = Date()
    @State var groomImage: UIImage?
    
    @State private var brideName = ""
    @State private var brideSurname = ""
    @State private var brideBirthdate = Date()
    @State var brideImage: UIImage?
    
    @State private var weddingDate = Date()
    @State private var location = ""
    @State private var welcomeMessage = ""
    
    @ObservedObject var groomImagePickerManager = ImagePickerManager()
    @ObservedObject var brideImagePickerManager = ImagePickerManager()
    
    var body: some View {
        NavigationStack {
            Form {
                PersonInfoSection(parent: self, sectionTitle: "Groom Information", personName: $groomName, personSurname: $groomSurname, birthdate: $groomBirthdate, image: $groomImage, imagePickerManager: groomImagePickerManager)
                PersonInfoSection(parent: self, sectionTitle: "Bride Information", personName: $brideName, personSurname: $brideSurname, birthdate: $brideBirthdate, image: $brideImage, imagePickerManager: brideImagePickerManager)
                WeddingInfoSection(sectionTitle: "Wedding Information", location: $location, welcomeMessage: $welcomeMessage, weddingDate: $weddingDate)
            }.navigationTitle("Information")
                .onTapGesture {
                    hideKeyboard()
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Save") {
                            tapOnSave()
                        }
                    }
                }
        }
    }
    
    private func tapOnSave() {
        // Check fields
        
        let groom = Groom(name: groomName, surname: groomSurname, image: "groom")
        let bride = Bride(name: brideName, surname: brideSurname, image: "bride")
        let wedding = Wedding(id: "0003",
                              groom: groom,
                              bride: bride,
                              date: formatDateToString(date: weddingDate),
                              location: location,
                              welcomeMessage: welcomeMessage,
                              album: [])
        // Upload request
        
        model.uploadWedding(groom: groom, bride: bride, wedding: wedding)
        uploadPhoto(image: groomImage)
        uploadPhoto(image: brideImage)
    }
}

struct Form_Previews: PreviewProvider {
    static var previews: some View {
        FormScreen()
    }
}

extension View {
    func hideKeyboard() {
        // Dismiss the keyboard when tapped outside the text field
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PersonInfoSection: View {
    
    var parent: FormScreen?
    var sectionTitle: String
    var personName: Binding<String>
    var personSurname: Binding<String>
    var birthdate: Binding<Date>
    @State var isPickerShowing = false
    @Binding var image: UIImage?
    @ObservedObject var imagePickerManager: ImagePickerManager
    
    var body: some View {
        Section(header: Text(sectionTitle)) {
            HStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(10)
                } else {
                    Image(systemName: "person.fill") // Placeholder image if no image is selected
                        .resizable()
                        .scaleEffect(0.5)
                        .frame(width: 120, height: 120)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            TextField("First Name",text: personName)
            TextField("Last Name",text: personSurname)
            DatePicker("Birthdate", selection: birthdate, displayedComponents: .date)
            Button("Select a Photo") {
                isPickerShowing = true
            }
            .sheet(isPresented: $isPickerShowing) {
                ImagePicker(isPickerShowing: $isPickerShowing, selectedImage: $image)
            }
        }
    }
}

struct WeddingInfoSection: View {
    
    var sectionTitle: String
    var location: Binding<String>
    var welcomeMessage: Binding<String>
    var weddingDate: Binding<Date>
    
    var body: some View {
        Section(header: Text(sectionTitle)) {
            TextField("Location",text: location)
            TextField("Welcome Message",text: welcomeMessage).lineLimit(4)
            DatePicker("Wedding Date", selection: weddingDate, displayedComponents: .date)
        }
    }
}

class ImagePickerManager: ObservableObject {
    @Published var selectedImage: UIImage?

    func clearImage() {
        selectedImage = nil
    }
}
