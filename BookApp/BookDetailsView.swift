//
//  BookDetailsView.swift
//  BookApp
//
//  Created by Pradyut Fogla on 18/01/24.
//

import SwiftUI


struct BookDetailsView: View {
    
    let book: Book
       @State private var isBorrowing = false
       @State private var selectedBook: Book
       @Binding var books: [Book]

       init(book: Book, books: Binding<[Book]>) {
           self.book = book
           _selectedBook = State(initialValue: book)
           _books = books
       }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                // Book cover image
                Image("\(book.cover)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, maxHeight: 300)

                VStack(alignment: .leading, spacing: 8) {
                    Text(book.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)

                    Text("By \(book.author)")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text("Genre: \(book.lender.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()
                    
                    if !book.isBorrowed{
                        
                        HStack {
                            Spacer()
                            
                            Text("Days Available:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("\(book.borrowPeriod)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        
                        
                        HStack {
                            Spacer()
                            
                            Button("Borrow Book") {
                                isBorrowing = true
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            .padding(.bottom, UIApplication.shared.connectedScenes
                                .compactMap { $0 as? UIWindowScene }
                                .first?.windows.first?.safeAreaInsets.bottom ?? 0)
                            
                            .sheet(isPresented: $isBorrowing) {
                                BorrowingPopupView(books: $books, book: $selectedBook, isBorrowing: $isBorrowing)
                            }
                            
                        }
                    }else{
                        HStack {
                            Spacer()
                            
                            Text("Available after:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("\(book.borrowedDays) days")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 5)
            }
            .padding()
        }
        
        
        .navigationBarTitle("Book Details", displayMode: .inline)
    }
}

