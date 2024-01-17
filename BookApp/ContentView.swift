import SwiftUI

struct Book: Identifiable {
    let id = UUID()
    let name: String
    let author: String
    let lender: [String]
    let cover: String
    var borrowPeriod: Int
    var isBorrowed: Bool = false
    var borrowedDays: Int = 0
}

struct ContentView: View {
    @State private var books: [Book] = [
        Book(name: "Doglapan", author: "Ashneer Grover", lender: ["Fiction"], cover: "book1", borrowPeriod: 20),
        Book(name: "Harry Potter", author: "J.K. Rowling", lender: ["Fiction"], cover: "book2", borrowPeriod: 10),
        Book(name: "Iron Man", author: "Marvel", lender: ["Mystery"], cover: "book3", borrowPeriod: 14),
        Book(name: "Do Epic Shit", author: "Ankur Warikoo", lender: ["Sci-Fi"], cover: "book4", borrowPeriod: 7),
        Book(name: "Tom Sawyer", author: "Mark Twain", lender: ["Romance"], cover: "book5", borrowPeriod: 10),
        // Add more books as needed
    ]

    var body: some View {
        NavigationView {
            TabView {
                HomeView(books: $books)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                PostBookView(onPost: { newBook in
                                   books.append(newBook)
                }, books: $books)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Post Book")
                    }

                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
            .navigationBarTitle("Happy Reading!!", displayMode: .inline)
                
                
            .navigationBarItems(trailing: Image(systemName: "ellipsis"))
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




