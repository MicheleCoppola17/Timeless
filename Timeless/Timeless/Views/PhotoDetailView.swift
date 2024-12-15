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
            VStack {
                AsyncImage(url: URL(string: photo.edmPreview[0]), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 350)
                
                HStack {
                    Text(photo.dcCreator?.first ?? "Unknown Author")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(10)
                        .foregroundStyle(.white)
                        .background(.gray)
                        .clipShape(.capsule)
                    
                    Text(photo.edmTimespanLabelLangAware?.zxx?.first ?? "Unknown Date")
                }
                
                Text((photo.dcDescriptionLangAware?.en?.first ?? photo.dcDescription?.first) ?? "No Description")
                    .padding()
                
                Spacer()
            }
            .navigationTitle((photo.dcTitleLangAware.en?.first ?? photo.title?.first) ?? "Untitled")
        }
    }
}

#Preview {
    PhotoDetailView(photo: .example)
}
