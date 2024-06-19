//
//  ContentView.swift
//  Friender
//
//  Created by Mehmet Alp Sönmez on 18/06/2024.
//

import SwiftUI

struct User: Codable, Identifiable{
    var id: String
    var name: String
    var email: String
    var age: Int
    var isActive: Bool
    var about: String
    var friends: [Friends]
    var registered: Date
}

struct Friends: Codable, Identifiable {
    var id: String
    var name: String
}




struct ContentView: View {
    @State private var results = [User]()
    var body: some View {
        NavigationStack {
            List(results) { user in
                NavigationLink(destination: DetailView(user: user)) {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.email)
                        Text(user.isActive ? "Active" : "Inactive")
                            .foregroundStyle(user.isActive ? .green : .red)
                    }
                }
            }
            .task {
                if results.isEmpty {
                    await loadData()
                }
            }
            .navigationTitle("Users")
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json" ) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decodedResponse = try? decoder.decode([User].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid Data")
        }
        
    }
}

#Preview {
    ContentView()
}
