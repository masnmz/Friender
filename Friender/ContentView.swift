//
//  ContentView.swift
//  Friender
//
//  Created by Mehmet Alp Sönmez on 18/06/2024.
//
import SwiftData
import SwiftUI

@Model
class User: Codable, Identifiable{
    var id: String
    var name: String
    var email: String
    var age: Int
    var isActive: Bool
    var about: String
    var friends: [Friends]
    var registered: Date
    
    init(id: String, name: String, email: String, age: Int, isActive: Bool, about: String, friends: [Friends], registered: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.isActive = isActive
        self.about = about
        self.friends = friends
        self.registered = registered
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, age, isActive, about, friends, registered
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.age = try container.decode(Int.self, forKey: .age)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.about = try container.decode(String.self, forKey: .about)
        self.friends = try container.decode([Friends].self, forKey: .friends)
        self.registered = try container.decode(Date.self, forKey: .registered)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.age, forKey: .age)
        try container.encode(self.isActive, forKey: .isActive)
        try container.encode(self.about, forKey: .about)
        try container.encode(self.friends, forKey: .friends)
        try container.encode(self.registered, forKey: .registered)
        
    }
    
    
    
    
}
@Model
class Friends: Codable, Identifiable {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
    
    
}




struct ContentView: View {
    @Environment(\.modelContext) var modelContext
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
                for user in results {
                    modelContext.insert(user)
                }
            }
        } catch {
            print("Invalid Data")
        }
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Friends.self])
}
