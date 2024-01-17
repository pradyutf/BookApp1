//
//  BorrowingPopupView.swift
//  BookApp
//
//  Created by Pradyut Fogla on 18/01/24.
//

import SwiftUI


struct BorrowingPopupView: View {
    @Binding var books: [Book]
    @Binding var book: Book
    @Binding var isBorrowing: Bool
    @State private var selectedBorrowedDays: Int = 1
   

    var body: some View {
        NavigationView {
            VStack {
                // Your existing code...

                Picker(selection: $selectedBorrowedDays, label: Text("Borrow for")) {
                    ForEach(1...book.borrowPeriod, id: \.self) { day in
                                        Text("\(day) days")
                                            .tag(day)
                                            .foregroundColor(selectedBorrowedDays == day ? .blue : .black)
                                            .font(selectedBorrowedDays == day ? .headline : .subheadline)
                                                        .padding()
                                    }
                                }
                
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 150)
                                .padding()

                HStack {
                    Button("Cancel") {
                        isBorrowing = false
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Spacer()

                    Button("Confirm Borrowing") {
                        // Update book attributes
                        book.isBorrowed = true
                        book.borrowedDays = selectedBorrowedDays
                        isBorrowing = false
                        
                        
                        if let index = books.firstIndex(where: { $0.id == book.id }) {
                            books[index].isBorrowed = true
                                    books[index].borrowedDays = selectedBorrowedDays
                                                }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Borrow Book", displayMode: .inline)
        }
    }
}

