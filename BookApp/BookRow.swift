//
//  BookRow.swift
//  BookApp
//
//  Created by Pradyut Fogla on 18/01/24.
//

import SwiftUI


struct BookRow: View {
    let book: Book
    @Binding var books: [Book]

    var body: some View {
        HStack {
            // Book cover image (you can add an actual image or placeholder)
            Image(book.cover)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 120)
//                .cornerRadius(8)

            // Book details
            VStack(alignment: .leading, spacing: 4) {
                Text(book.name)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("by \(book.author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text(book.lender.joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
            
            VStack{
               
                
                if !book.isBorrowed {
                                    Text("Available for \(book.borrowPeriod) days")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("Available in \(book.borrowedDays) days")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                }
                    
                
                
                
                NavigationLink(destination: BookDetailsView(book: book, books: $books)) {
                    Text("About")
                        .foregroundColor(.blue)
                }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

