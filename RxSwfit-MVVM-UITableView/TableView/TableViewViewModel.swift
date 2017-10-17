//
//  TableViewViewModel.swift
//  RxSwfit-MVVM-UITableView
//
//  Created by JungMoon-Mac on 2017. 10. 17..
//  Copyright © 2017년 JungMoon-Mac. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TableViewViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    // INPUT
    let reload = PublishSubject<Void>().asObserver()
    
    // OUTPUT
    var tableData:Observable<[ColorData]>?
    
    override init() {
        super.init()
        
        tableData = reload.flatMap({ [unowned self]() -> Observable<[ColorData]> in
            return Observable<[ColorData]>.create({ (subscribe) -> Disposable in
                subscribe.onNext(self.loadData())
                return Disposables.create()
            })
        })

    }
    
    func loadData() -> [ColorData]{
        let jsonString = try! String(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "color", ofType: "json")!), encoding: .utf8)
        let json = try! JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
        
        var colorDataList:[ColorData] = []
        if let dic = json as? [String:String]{
            dic.forEach({ (key, value) in
                var data = ColorData()
                data.name = key
                data.hexString = value
                colorDataList.append(data)
            })
        }
        
        colorDataList.shuffle()
        return colorDataList
    }
}




