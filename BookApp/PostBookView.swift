//
//  PostBookView.swift
//  BookApp
//
//  Created by Pradyut Fogla on 18/01/24.
//

import SwiftUI


import PhotosUI

struct PostBookView: View {
    @State private var bookName = ""
    @State private var bookAuthor = ""
    @State private var bookGenre = ""
    @State private var bookCover = ""
    @State private var borrowPeriod = ""
    @State private var showAlert = false
    @State private var showConfirmation = false
    @State private var redirectToHome = false
    
  
    
    var onPost: (Book) -> Void
    @Binding var books: [Book]
    
    var body: some View {
        VStack {
            
            Spacer()
            TextField("Book Name", text: $bookName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Author", text: $bookAuthor)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Genre", text: $bookGenre)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Borrow Period", text: $borrowPeriod)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
                .keyboardType(.numberPad)
            
            Button("Post Book") {
                if fieldsAreFilled() {
                    
                    guard let period = Int(borrowPeriod) else {
                                // Handle invalid input (non-integer value)
                                showAlert = true
                                return
                            }
                    let newBook = Book(name: bookName, author: bookAuthor, lender: [bookGenre], cover: "book6", borrowPeriod: period)
                    onPost(newBook)
                    
                    // Reset fields after posting
                    bookName = ""
                    bookAuthor = ""
                    bookGenre = ""
                    bookCover = ""
                    borrowPeriod = ""
                    
                    
                    
                    showConfirmation = true
                } else {
                    showAlert = true
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            
            .cornerRadius(10)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Warning"), message: Text("Please fill in all fields or provide valid integer for borrow period"), dismissButton: .default(Text("OK")))
            }
            
            
            Spacer()
            NavigationLink(
                            destination: HomeView(books: $books), // You can adjust searchText if needed
                            isActive: $redirectToHome
                        ) {
                            EmptyView()
                        }
        }
       
        .padding()
        .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                )
        .navigationBarTitle("Post Book", displayMode: .inline)
        .sheet(isPresented: $showConfirmation) {
                    Text("Book Posted Successfully!")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                showConfirmation = false
                                redirectToHome = true
                            }
                        }
                }
    }
    
    
    
    private func fieldsAreFilled() -> Bool {
        return !bookName.isEmpty && !bookAuthor.isEmpty && !bookGenre.isEmpty && !borrowPeriod.isEmpty
    }
    
}
