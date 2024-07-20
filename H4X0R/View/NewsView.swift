//
//  ContentView.swift
//  H4X0R
//
//  Created by berat on 20.07.2024.
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationStack {
            List(networkManager.stories) { story in
                NavigationLink(destination: DetailView(url: story.url as? String)) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.yellow)
                        Text(String(story.score))
                        Text(story.title)
                    }
                }
            }
            .navigationTitle("H4X0R NEWS")
        }
        .onAppear(perform: networkManager.fetchData)
    }
}

#Preview {
    NewsView()
}
