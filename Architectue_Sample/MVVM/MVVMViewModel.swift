//
//  MVVMViewModel.swift
//  MVVM
//
//  Created by 服部　翼 on 2020/05/22.
//  Copyright © 2020 服部　翼. All rights reserved.
//

import Foundation

enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

class QiitaViewModel {
    
    var stateDidUpdate: ((ViewModelState) -> Void)?
    var item = [QiitaItem]()
    
    func getRepository(query: String) {
        self.stateDidUpdate?(.loading)
        
        QiitaRepository.jsonQiita(query: query, success: { [weak self] (items) in
            guard let self = self else {return}
            self.item = items
            self.stateDidUpdate?(.finish)
        }) { (error) in
            self.stateDidUpdate?(.error(error))
        }
    }
}
