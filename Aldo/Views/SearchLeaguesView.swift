//
//  SearchLeaguesView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//

import SwiftUI

struct SearchLeaguesView: View {
    @State private var leagueIdString: String = "" // The league ID as String
    @State private var leagueId: UUID? // The league ID as UUID
    
    var body: some View {
        VStack {
            TextField("Enter League ID", text: $leagueIdString)
                .padding()
            
            Button("Search League") {
                if let uuid = UUID(uuidString: leagueIdString) {
                    leagueId = uuid
                    // Proceed with the logic using the UUID
                } else {
                    print("Invalid UUID format")
                }
            }
        }
    }
}
