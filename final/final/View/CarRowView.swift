//
//  CarRowView.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import SwiftUI

struct CarRowView: View {
    let car: Car
    let tapFavorite: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // фото 4:3
            AsyncImage(url: URL(string: car.photos.first ?? "")) { phase in
                if let img = phase.image {
                    img.resizable().scaledToFill()
                } else { Color.gray.opacity(2) }
            }
            .frame(width: 128, height: 96)
            .clipped()
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {
                
                Text(car.title)
                    .font(.montserrat(.medium, size: 16))
                    .foregroundColor(.text)
                    .lineLimit(2)
                Text("\(car.price.formatted(.number.grouping(.automatic))) \(car.currency)")
                    .font(.montserrat(.medium, size: 14))
                    .foregroundColor(.accent)

                // Год • пробег
                Text("\(car.year) г.  •  \(car.mileage.formatted(.number)) км")
                    .font(.montserrat(.light, size: 13))
                    .foregroundColor(.gray)

                // Город
                Text(car.city)
                    .font(.montserrat(.light, size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: tapFavorite) {
                            Image(systemName: "heart")
                                .font(.system(size: 20))
                        }
        }
        .padding(.vertical, 6)
    }
}
