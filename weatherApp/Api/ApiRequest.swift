import Foundation
import UIKit

typealias Parameters = [String:Any]
var dataTask: URLSessionDataTask?

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum AppError: Error {
    case generic
    case noInternet
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .generic: return Localizable.InAppError.generic.localized
        case .noInternet: return Localizable.InAppError.noInternet.localized
        }
    }
}

protocol APIRequestProtocol {
    func request<T>(
        urlString: String,
        method: HTTPMethod,
        parameters: Parameters?,
        success: @escaping (T)->Void,
        failure: @escaping (AppError) -> Void
    ) where T : Decodable
}

final class APIRequest: APIRequestProtocol {
    
    private let logger = ApiLogger()
    
    func request<T>(
        urlString: String,
        method: HTTPMethod,
        parameters: Parameters?,
        success: @escaping (T)->Void,
        failure: @escaping (AppError) -> Void
    ) where T : Decodable
    {
        guard let url = URL(string: urlString) else { return failure(.generic) }
        
        let request = makeURLRequest(
            url: url,
            httpMethod: method,
            parameters: parameters
        )
        
        logger.logRequest(request)
        dataTask = nil
        dataTask = URLSession.shared.dataTask(with: request) { [logger] (data, response, error) in
            guard let response = response else { return failure(.generic) }
            logger.logResponse((data,response,error))
            if response.isValid, let object:T = try? data?.decode(logger: logger) {
                success(object)
            } else {
                failure(.generic)
            }
        }
        dataTask?.resume()
    }
    
    private func makeURLRequest(
        url: URL,
        httpMethod: HTTPMethod,
        parameters: Parameters?
    ) -> URLRequest {
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 30
        )
        
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        }
        
        return request
    }
}

private extension URLResponse {
    var isValid: Bool {
        guard let httpResposne = self as? HTTPURLResponse else { return false }
        switch httpResposne.statusCode {
        case 400..<600:
            return false
        default:
            return true
        }
    }
}

private extension Data {
    func decode<T: Decodable>(logger: ApiLogger) throws -> T {
        let formatterDateJSON = DateFormatter()
        formatterDateJSON.dateFormat = "yyyy-mm-dd"
        
        do {
            let jsonDecoderSnake = JSONDecoder()
            jsonDecoderSnake.keyDecodingStrategy = .convertFromSnakeCase
            jsonDecoderSnake.dateDecodingStrategy = .formatted(formatterDateJSON)
            let decodedData = try jsonDecoderSnake.decode(T.self, from: self)
            return decodedData
        } catch let error {
            logger.logError(error)
            throw AppError.generic
        }
    }
}
