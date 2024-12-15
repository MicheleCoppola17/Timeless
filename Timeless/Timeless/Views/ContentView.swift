//
//  ContentView.swift
//  Timeless
//
//  Created by Michele Coppola on 15/12/24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let apiKey = "ageingorepie"
    
    var randomIndexStart = Int.random(in: 0..<50)
    
    @State private var showSheet: Bool = true
    
    @State private var photos = [Photo]()
    @State private var searchedCity: String = ""
    
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position) {
            if searchedCity.isEmpty == false {
                
            }
        }
        .task {
            photos = await loadData() ?? []
        }
        .onChange(of: searchedCity) {
            Task {
                await loadData()
            }
        }
        .sheet(isPresented: $showSheet) {
            PhotoCollectionView()
                .presentationDetents([.fraction(0.1), .medium, .large])
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
    }
    
    func loadData() async -> [Photo]? {
        guard let url = URL(string: "https://api.europeana.eu/record/v2/search.json?query=\(searchedCity)+AND+European Library of Information and Culture&rows=12&start=\(String(randomIndexStart))&media=true&reusability=open&qf=TYPE:IMAGE&wskey=\(apiKey)") else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            photos = decodedResponse.items
        } catch {
            print("Error loading data: \(error)")
        }
        
        return photos
    }
}

#Preview {
    ContentView()
}
