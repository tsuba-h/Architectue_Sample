//
//  MVPViewController.swift
//  MVP
//
//  Created by 服部　翼 on 2020/05/22.
//  Copyright © 2020 服部　翼. All rights reserved.
//

import UIKit

class MVPViewController: UIViewController {
    
    private var presenter = Presenter()
    private var refControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MVP")
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        refControl.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refControl
        
        presenter.fetch(query: "swift") {
            self.tableView.reloadData()
        }
    }
    
    @objc func valueChange(sender: UIRefreshControl) {
        presenter.fetch(query: "kotlin") {
            self.tableView.reloadData()
            self.refControl.endRefreshing()
        }
    }
}

extension MVPViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowas()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.label.text = presenter.item[indexPath.row].title
        return cell
    }
    
    
}
