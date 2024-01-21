//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//


import SwiftUI
import ComposableArchitecture
import Models
import SharedViews
import Extensions

public struct CategoryRowView: View {
    let category: CategoryModel
    
    public init(
        category: CategoryModel
    ) {
        self.category = category
    }
    
    public var body: some View {
        ZStack {
            HStack(alignment: .top, spacing: .zero) {
                AsyncImageView(url: URL(string: category.image)!)
                    .frame(width: 121, height: 90)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .clipped()
                
                
                VStack(alignment : .leading) {
                    VStack(alignment: .leading) {
                        Text(category.title)
                            .font(.callout.weight(.semibold))
                        
                        Text(category.description)
                            .font(.caption.weight(.regular))
                            .foregroundStyle(.black.opacity(0.5))
                    }
                    .lineLimit(2)
                    
                    Spacer()
                    
                    if category.status == .paid {
                        HStack(alignment: .lastTextBaseline, spacing: 3){
                            Image(systemName: "lock.fill")
                                .resizable()
                                .frame(width: 10, height: 12)
                            
                            Text("Premium")
                                .font(.body)
                           
                        }
                        .foregroundStyle(Color.premium)
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding([.top, .leading, .bottom], 5)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            category.status == .comingSoon ? .black.opacity(0.6) : .white
        )
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        .overlay(alignment: .trailing) {
            if category.status == .comingSoon {
                Image("coming-soon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

#if DEBUG
struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRowView(category: .mock1)
    }
}
#endif
