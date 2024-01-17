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


struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .navigationBarTitle("Profile", displayMode: .inline)
    }
}



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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




