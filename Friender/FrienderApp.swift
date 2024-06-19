//
//  FrienderApp.swift
//  Friender
//
//  Created by Mehmet Alp Sönmez on 18/06/2024.
//

import SwiftData
import SwiftUI

@main
struct FrienderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Friends.self])
    }
}
