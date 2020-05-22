//
//  MVPModel.swift
//  MVP
//
//  Created by 服部　翼 on 2020/05/22.
//  Copyright © 2020 服部　翼. All rights reserved.
//

import Moya

final class QiitaRepository {
    private let qiitaAPIProvider = MoyaProvider<Qiita>()
    
    func jsonQiita(query: String,
                   success: @escaping ([QiitaItem]) -> Void,
                   failure: @escaping (Error) -> Void) {
        
        qiitaAPIProvider.request(.getQiita(query: query)) { (response) in
            switch response {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode([QiitaItem].self, from: response.data)
                    success(response)
                } catch (let error) {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}

struct  QiitaItem: Codable {
    let title: String
    let url: String
}

enum Qiita {
    case getQiita(query: String)
}

extension Qiita: TargetType {
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
    
    var path: String {
        return "/api/v2/items"
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getQiita(let query):
            return .requestParameters(parameters: ["per_page": "10", "query": query],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
