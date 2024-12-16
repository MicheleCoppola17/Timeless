//
//  ContentView.swift
//  Timeless
//
//  Created by Michele Coppola on 15/12/24.
//

// The API does not provide useful coordinates for each photo or, if provided, they are not always related to the city the photo was taken. So, for now, I gave each photo the coordinates of the searched city, but with a random little offset.

import MapKit
import SwiftUI

struct ContentView: View {
    let apiKey = "ageingorepie"
    
    var randomIndexStart = Int.random(in: 0..<50)
    
    @State private var showSheet: Bool = true
    
    @State private var photos = [Photo]()
    @State private var searchedCity: String = ""
    
    @State private var position: MapCameraPosition = .automatic
    @State private var photoCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.853294, longitude: 14.305573)
    
    var body: some View {
        Map(position: $position) {
            if searchedCity.isEmpty == false {
                ForEach(photos) { photo in
                    Annotation(LocalizedStringKey(""), coordinate: CLLocationCoordinate2D(
                        latitude: photoCoordinates.latitude + Double.random(in: -0.01...0.01),
                        longitude: photoCoordinates.longitude + Double.random(in: -0.01...0.01))
                    ) {
                        AsyncImage(url: URL(string: photo.edmPreview[0])) { image in
                            image
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
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
            PhotoCollectionView(photos: photos, searchedCity: $searchedCity, position: $position, photoCoordinates: $photoCoordinates)
                .presentationDetents([.fraction(0.2), .medium, .large])
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
    }
    
    // The search is filtered in order to get results from just one provider (in this case the European Library of information and Culture). Doing that I have a more consistent result.
    
    // With those search filters, the API is able to provide many photos of mostly all the main italian cities.
    
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
