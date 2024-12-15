//
//  PhotoCollectionView.swift
//  Timeless
//
//  Created by Michele Coppola on 15/12/24.
//

import MapKit
import SwiftUI

struct PhotoCollectionView: View {
    let photos: [Photo]
    
    @Binding var searchedCity: String
    @Binding var position: MapCameraPosition
    @Binding var photoCoordinates: CLLocationCoordinate2D
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    if searchedCity.isEmpty == false {
                        ForEach(photos) { photo in
                            NavigationLink {
                                PhotoDetailView(photo: photo)
                            } label: {
                                VStack {
                                    AsyncImage(url: URL(string: photo.edmPreview[0]), scale: 3) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    Text(photo.title?.first ?? "Untitled")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding(.vertical)
                                        .frame(maxWidth: .infinity)
                                        .background(Color(red: 0.2, green: 0.2, blue: 0.3))
                                }
                            }
                        }
                    }
                }
                .padding([.horizontal, .bottom])
                .searchable(text: $searchedCity)
                .onSubmit(of: .search) {
                    Task {
                        if let mapItem = await searchCity(for: searchedCity) {
                            position = .region(
                                MKCoordinateRegion(
                                    center: mapItem.placemark.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                )
                            )
                            
                            photoCoordinates = CLLocationCoordinate2D(
                                latitude: mapItem.placemark.coordinate.latitude,
                                longitude: mapItem.placemark.coordinate.longitude
                            )
                        }
                    }
                }
            }
            .navigationTitle("Timeless")
        }
    }
    
    func searchCity(for query: String) async -> MKMapItem? {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.addressFilter = MKAddressFilter(including: .locality)
        let search = MKLocalSearch(request: request)
        let response = try? await search.start()
        return response?.mapItems.first
    }
}

#Preview {
    PhotoCollectionView(photos: [.example, .example2], searchedCity: .constant("Naples"), position: .constant(.automatic), photoCoordinates: .constant(CLLocationCoordinate2D(latitude: 40.8518, longitude: 14.2681)))
}
