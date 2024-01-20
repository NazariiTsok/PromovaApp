//
//  File.swift
//
//
//  Created by Nazar Tsok on 20.01.2024.
//

import ComposableArchitecture
import Models
import Foundation

extension APIClient {
    public static func live(
        url: URL,
        decoder: JSONDecoder = .init()
    ) -> Self {
        return Self(
            fetchCategories: {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                do {
                    let categories = try decoder.decode([CategoryModel].self, from: data)
                    return categories
                } catch {
                    // Handle or rethrow the decoding error
                    throw error
                }
            }
        )
    }
}
