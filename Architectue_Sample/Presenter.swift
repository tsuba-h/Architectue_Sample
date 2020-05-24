//
//  Presenter.swift
//  MVP
//
//  Created by 服部　翼 on 2020/05/22.
//  Copyright © 2020 服部　翼. All rights reserved.
//

import Foundation

final class Presenter {
    let model = QiitaRepository()
    var item = [QiitaItem]()
    
    func fetch(query: String, completion: @escaping () -> Void) {
        model.jsonQiita(query: query, success: { [weak self] items in
            self?.item = items
            completion()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func numberOfRowas() -> Int {
        return item.count
    }
}
