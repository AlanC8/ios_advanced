//
//  NetworkError.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

enum NetworkError: Error {
    case badURL
    case decoding(Error)
    case server(status: Int)
    case unknown(Error)
}
