//
//  ViewController.swift
//  MVC
//
//  Created by 服部　翼 on 2020/05/19.
//  Copyright © 2020 服部　翼. All rights reserved.
//

import UIKit

class MVVMContentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var refControl = UIRefreshControl()
    private var firstGetRepository = false
    var viewModel = QiitaViewModel()
    var query: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MVVMViewController.delegate = self
        
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        refControl.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refControl
        
        viewModel.stateDidUpdate =  { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .loading:break
            case .finish:
                self.tableView.reloadData()
                self.refControl.endRefreshing()
            case .error(let error):
                print(error.localizedDescription)
                self.refControl.endRefreshing()
            }
        }
    }
    
    @objc func valueChange(sender: UIRefreshControl) {
        viewModel.getRepository(query: self.query)
    }
}

extension MVVMContentsViewController: PagingDelegate {
    func openPage(title: String) {
        print(title)
        if !firstGetRepository && title == self.title {
            firstGetRepository = true
            viewModel.getRepository(query: query)
        }
    }
}


extension MVVMContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.label.text = viewModel.item[indexPath.row].title
        return cell
    }
    
    
}
