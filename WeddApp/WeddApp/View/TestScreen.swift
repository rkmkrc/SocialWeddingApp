
//
//  PinKeyboardAndField.swift
//  WeddApp
//
//  Created by Erkam Karaca on 22.07.2023.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

/*
 struct xCircleTextFieldStyle: TextFieldStyle {
 func _body(configuration: TextField<Self._Label>) -> some View {
 configuration
 .font(.largeTitle)
 .foregroundColor(.black)
 .padding(5)
 .background(
 Circle()
 .fill(Color.gray.opacity(0.5))
 )
 }
 }
 
 struct xPINDisplay: View {
 let pin: String
 let numberOfCircles: Int = 4
 
 var body: some View {
 HStack(spacing: 10) {
 ForEach(Array(0..<numberOfCircles), id: \.self) { index in
 Circle()
 .fill(Color.white.opacity(0.5))
 .frame(width: 75, height: 75)
 .overlay(
 Circle()
 .stroke(Color.black.opacity(getDigit(at: index) == "" ? 0.3: 0.9), lineWidth: 1) // Border
 )
 .overlay(
 Text(getDigit(at: index))
 .font(.largeTitle)
 .foregroundColor(.black)
 )
 .scaleEffect(getScale(at: index))
 .onChange(of: pin) { _ in
 withAnimation(.easeIn) {}
 }
 }
 }
 }
 
 private func getDigit(at index: Int) -> String {
 guard index < pin.count else {
 return ""
 }
 let digitIndex = pin.index(pin.startIndex, offsetBy: index)
 return String(pin[digitIndex])
 }
 private func getScale(at index: Int) -> CGFloat {
 let isSelected = index < pin.count
 return isSelected ? 1.07 : 1.0
 }
 }
 
 
 
 struct xCallKeyboard: View {
 @Binding var text: String
 
 let rows: [[String]] = [
 ["1", "2", "3"],
 ["4", "5", "6"],
 ["7", "8", "9"],
 ["\u{2665}", "0", "\u{232B}"]
 ]
 
 var body: some View {
 VStack(spacing: 10) {
 ForEach(rows, id: \.self) { row in
 HStack(spacing: 10) {
 ForEach(row, id: \.self) { key in
 CallKeyboardButton(text: $text, key: key)
 }
 }
 }
 }
 .padding()
 }
 }
 
 struct xCallKeyboardButton: View {
 @Binding var text: String
 let key: String
 
 var body: some View {
 Button(action: {
 if key == "\u{232B}" {
 text = String(text.dropLast())
 } else {
 text += key
 }
 }) {
 Text(key)
 .font(.title)
 .frame(width: 75, height: 75)
 .foregroundColor(.black)
 .background(Color.white.opacity(0.5))
 .cornerRadius(40)
 }
 }
 }
 
 struct xPinKeyboardAndField: View {
 @State private var pin: String = ""
 @State private var correctPIN: String = "1234"
 @State private var isCorrectPIN: Bool = false
 
 var body: some View {
 VStack {
 PINDisplay(pin: pin)
 CallKeyboard(text: $pin)
 Text(isCorrectPIN ?"Correct PIN" : "Incorrect PIN")
 
 }
 .onChange(of: pin) { newValue in
 if newValue.count == 4 && !checkPIN() {
 DispatchQueue.main.asyncAfter (deadline: .now() + 0.5) {
 self.pin = ""
 }
 
 } else if newValue.count == 4 && checkPIN() {
 self.isCorrectPIN = true
 }
 }
 }
 
 // Function to check if the entered PIN is correct
 private func checkPIN() -> Bool {
 return pin == correctPIN
 }
 }
 
 struct xPinKeyboardAndField_Previews: PreviewProvider {
 static var previews: some View {
 xPinKeyboardAndField().background(AnimatedBackground())
 }
 }
 /*
  struct test: View {
  @ObservedObject var model = ViewModel()
  var wedd: Wedding?
  var body: some View {
  Button(wedd?.location ?? "ooo") {
  }
  
  }
  init() {
  model.getWedding()
  model.createWedding(id: "1111")
  }
  }
  
  struct sddsf: PreviewProvider {
  static var previews: some View {
  test()
  }
  }
  */
 */

struct test: View {
    @State var image: UIImage? = UIImage(named: "groom")
    @State var retrievedImages = [UIImage]()
    var body: some View {
        VStack {
            Image(uiImage: image ?? UIImage())
            Button("Upload") {
                print("TAP")
                uploadPhoto()
            }
            Divider()
            HStack {
                ForEach(retrievedImages, id: \.self) { image in
                    Image(uiImage: image).resizable().frame(width: 100, height: 100)
                }
            }
        }.onAppear {
            retrieveImages()
        }
    }
    
    func uploadPhoto() {
        print("UPLOAD PHOTO ()")
        guard image != nil else {
            print("UPLOAD PHOTO () 2")
            return
        }
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn image to data
        let imageData = image!.pngData()
        
        guard imageData != nil else {
            print("UPLOAD PHOTO () 3")
            return
        }
        
        // Specify the file path
        let path = "images/\(UUID().uuidString).png"
        let fileRef = storageRef.child(path)
        
        // Upload data
        let uploadTask = fileRef.putData(imageData!) { metadata, error in
            
            if error == nil && metadata != nil {
                // Save a referace to Firestore DB
                print("----------")
                let db = Firestore.firestore()
                db.collection("Images").document().setData(["url": path])
                
            }
        }
    }
    
    func retrieveImages() {
        // Get data from Firebase
        let db = Firestore.firestore()
        
        db.collection("Images").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var paths = [String]()
                
                for doc in snapshot!.documents {
                    paths.append(doc["url"] as! String)
                }
                
                for path in paths {
                    
                    let storageReference = Storage.storage().reference()
                    let fileRef = storageReference.child(path)
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        
                        if error == nil && data != nil {
                            
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
}

struct sddsf: PreviewProvider {
    static var previews: some View {
        test()
    }
}
