//
//  PhotoDetailView.swift
//  Timeless
//
//  Created by Michele Coppola on 15/12/24.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text((photo.dcTitleLangAware.en?.first ?? photo.title?.first) ?? "Untitled")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        
                    AsyncImage(url: URL(string: photo.edmPreview[0]), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(photo.dcCreator?.first ?? "Unknown Author")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(10)
                                .foregroundStyle(.white)
                                .background(.gray.opacity(0.75))
                                .clipShape(.capsule)
                            
                            Text(photo.edmTimespanLabelLangAware?.zxx?.first ?? "Unknown Date")
                        }
                        
                        Text((photo.dcDescriptionLangAware?.en?.first ?? photo.dcDescription?.first) ?? "No Description")
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    PhotoDetailView(photo: .example)
}
