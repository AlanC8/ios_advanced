//
//  ImageDownloadError.swift
//  FiveImages
//
//  Created by Алан Абзалханулы on 03.04.2025.
//
import SwiftUI

enum ImageDownloadError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case dataConversionError
    case unexpectedResponse(statusCode: Int)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The image URL was invalid."
        case .networkError(let underlyingError):
            return "Network request failed: \(underlyingError.localizedDescription)"
        case .dataConversionError:
            return "Failed to convert downloaded data into an image."
        case .unexpectedResponse(let statusCode):
            return "Received an unexpected status code: \(statusCode)."
        case .noData:
            return "No data was received from the server."
        }
    }
}
