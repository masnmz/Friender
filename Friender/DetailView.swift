//
//  DetailView.swift
//  Friender
//
//  Created by Mehmet Alp Sönmez on 18/06/2024.
//

import SwiftUI

struct DetailView: View {
    var user: User
    
    var body: some View {
        ScrollView {
            HStack {
                Text(user.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("\(user.age)")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            Text(user.isActive ? "Active" : "Inactive")
                .foregroundStyle(user.isActive ? .green : .red)
            Text(user.about)
                .padding(20)
            Text("Join Date: \(user.registered, format: .dateTime.year().month().day())")
            Text("Friends")
                .font(.headline)
            
            
            ForEach(user.friends) { friend in
                Text(friend.name)
            }
        }
    }
}


#Preview {
    let sampleFriend = Friends(id: "2", name: "Jane Doe")
    let sampleUser = User(
        id: "1",
        name: "John Doe",
        email: "john.doe@example.com",
        age: 30,
        isActive: true,
        about: "A software developer from New York.", 
        friends: [sampleFriend], 
        registered: .now
    )
    return DetailView(user: sampleUser)
}
