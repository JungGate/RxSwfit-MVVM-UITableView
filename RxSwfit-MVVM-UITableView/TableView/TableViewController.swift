//
//  ViewController.swift
//  RxSwfit-MVVM-UITableView
//
//  Created by JungMoon-Mac on 2017. 10. 17..
//  Copyright © 2017년 JungMoon-Mac. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let viewModel = TableViewViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    func setupUI(){
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func setupBinding(){
        viewModel.tableData?
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })
            .bind(to: tableView.rx.items(cellIdentifier: "cell")){ (index, data, cell) in
                cell.textLabel?.text = "\(data.name!) (\(data.hexString!))"
                cell.backgroundColor = UIColor(string:data.hexString!)
        }.disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
    }

}





