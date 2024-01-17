//
//  HomeView.swift
//  BookApp
//
//  Created by Pradyut Fogla on 18/01/24.
//

import SwiftUI


struct HomeView: View {
    @Binding var books: [Book]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading,  spacing: 16) {
                
                Text("Read")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    
                    
                
                
                ForEach(books) { book in
                    NavigationLink(destination: BookDetailsView(book: book, books: $books)) {
                        BookRow(book: book, books: $books)  // Pass the binding to BookRow
                    }
                }


            }
            .padding()
        }
        .navigationTitle("Home")
    }
}
