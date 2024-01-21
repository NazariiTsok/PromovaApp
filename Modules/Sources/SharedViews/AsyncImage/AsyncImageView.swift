//
//  File.swift
//
//
//  Created by Nazar Tsok on 21.01.2024.
//

import SwiftUI
import Models

public struct AsyncImageView : View {
    
    let url: String
    
    public init(url: String) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(
            url: URL(string: url)
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
            case .failure:
                Image(systemName: "photo.artframe")
                    .resizable()
            @unknown default:
                EmptyView()
            }
        }
    }
}



#if DEBUG
struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        
        //TODO: For test async later
        AsyncImageView(url: CategoryModel.mock1.image)
    }
}

#endif
