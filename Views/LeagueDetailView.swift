//
//  LeagueDetailView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//
import SwiftUI

struct LeagueDetailView: View {
    @Binding var rounds: [League.Round] // Use @Binding for two-way binding

    var body: some View {
        VStack {
            Text("League Rounds")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            List(rounds, id: \.id) { round in
                Text("Round \(round.number) - Score: \(round.score)")
            }

            Spacer()
        }
        .padding()
    }
}

struct LeagueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Example with mock data to preview the LeagueDetailView
        LeagueDetailView(rounds: .constant([
            League.Round(id: UUID(), number: 1, score: 75, scores: []),
            League.Round(id: UUID(), number: 2, score: 80, scores: [])
        ]))
    }
}
