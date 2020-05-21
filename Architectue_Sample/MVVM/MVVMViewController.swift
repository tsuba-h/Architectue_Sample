//
//  MVVMViewController.swift
//  MVVM
//
//  Created by 服部　翼 on 2020/05/22.
//  Copyright © 2020 服部　翼. All rights reserved.
//

import UIKit
import Parchment
import Instantiate
import InstantiateStandard

protocol PagingDelegate {
    func openPage(title: String)
}


class MVVMViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    let paging = PagingMenuOptinons()
    static var delegate: PagingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MVVM")
        setUpPaging()
    }
    
    
    func setUpPaging() {
        let pagingViewController = PagingViewController(viewControllers: paging.pagingControllers)
        pagingViewController.delegate = self
        addChild(pagingViewController)
        view.insertSubview(pagingViewController.view, at: 1)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        pagingViewController.view.heightAnchor.constraint(equalToConstant: self.contentView.bounds.height).isActive = true
        pagingViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension MVVMViewController: PagingViewControllerDelegate {
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        guard let indexItem = pagingViewController.state.currentPagingItem as? PagingIndexItem else {return}
        print("pagingDelegate:発火",indexItem.title)
        MVVMViewController.self.delegate?.openPage(title: indexItem.title)
    }
}

struct PagingMenuOptinons {
    let storyboard = UIStoryboard(name: "MVVM", bundle: nil)
    
    var pagingControllers: [UIViewController] {
        
        var controllers: [UIViewController] = []
        let items = ["swift", "kotlin", "php", "Python", "C#", "Unity"]
        items.forEach { (tag) in
            let controller = storyboard.instantiateViewController(identifier: "MVVMContentsViewController") as! MVVMContentsViewController
            controller.title = tag
            controller.query = tag
            controllers.append(controller)
        }
        return controllers
    }
}
