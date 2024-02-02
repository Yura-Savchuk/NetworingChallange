//
//  ApiService.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 01.02.2024.
//

import Foundation
import Combine

final class ApiService: NSObject {
    static let shared = ApiService()
    
    private static let baseUrl = "https://api.github.com"
    private lazy var urlSession: URLSession = {
        .init(configuration: .default, delegate: nil, delegateQueue: nil)
    }()
    
    override init() {
        super.init()
    }
    
    func request<Response: Decodable>(_ request: ApiRequest) -> AnyPublisher<Response, ApiService.ApiError> {
        guard let url = URL(string: Self.baseUrl + request.enpoint.path) else {
            return Fail(error: .incorrectURLFormat)
                .eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        request.setupParams(for: &urlRequest)
        urlRequest.insertHeaders(request.headers)
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                let httpResponse = response as? HTTPURLResponse
                let statusCode = httpResponse?.statusCode ?? 0
                if statusCode < 200 || statusCode >= 300 {
                    throw ApiError.httpFailed(statusCode)
                }
                
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(Response.self, from: data)
                } catch {
                    print("Failed to decode response: \(error)")
                    print("Response: \(data)")
                    throw ApiError.failedToDecodeResponse
                }
            }
            .mapError { $0 as? ApiService.ApiError ?? .httpFailed(0) }
            .eraseToAnyPublisher()
    }
}

extension ApiService: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        if let trust = challenge.protectionSpace.serverTrust,
                SecTrustGetCertificateCount(trust) > 0 {
            if let certificates = SecTrustCopyCertificateChain(trust) {
                let certificatesData = (certificates as? [SecCertificate] ?? [])
                    .map { SecCertificateCopyData($0) as Data }
               
                if trustedCertificates.intersection(Set(certificatesData)).count > 0 {
                   return (.useCredential, URLCredential(trust: trust))
               }
             }

           }
        return (.cancelAuthenticationChallenge, nil)
    }
    
    var trustedCertificates: Set<Data> {
        guard let url = Bundle.main.url(forResource: "mockAPI", withExtension: "der") else {
            print("Unable to locate SSL certificate")
            return []
        }
        do {
            return [try Data(contentsOf: url)]
        } catch {
            print("Unable to read SSL certificate")
            return []
        }
    }
    
    enum SSLCertificateError: Error {
        case unableToLocateCertifcate
    }
}

extension ApiService {
    enum ApiError: Error {
        case incorrectURLFormat
        case httpFailed(_ statusCode: Int)
        case failedToDecodeResponse
    }
}

private extension URLRequest {
    mutating func insertHeaders(_ headers: ApiHeaders) {
        let headersDictionary = headers.asDictionary
        for key in headersDictionary.keys {
            setValue(headersDictionary[key], forHTTPHeaderField: key)
        }
    }
}
