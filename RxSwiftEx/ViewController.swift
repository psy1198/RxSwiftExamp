//
//  ViewController.swift
//  RxSwiftEx
//
//  Created by 김성남 on 2020/04/15.
//  Copyright © 2020 김성남. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ViewController: UIViewController {
    @IBOutlet weak var citiTableview: UITableView!
    @IBOutlet weak var citiSearchBar: UISearchBar!
    
    var showCities = [String]()
    var allCities = ["New york", "New york", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // 고정된 API 데이터
    
    let disposebag = DisposeBag() // 뷰가 할당 해제될 때 놓아줄 수 있는 일회용품의 가방
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.observes()
    }
    
    
    func setupUI() {
        self.citiTableview.delegate = self
        self.citiTableview.dataSource = self
        //self.citiTableview.register(CitiCell.self, forCellReuseIdentifier: "CitiCell")
        self.citiTableview.register(CitiCell.self, forCellReuseIdentifier: "CitiCell")
    }
    
    func observes() {
        self.citiSearchBar
            .rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(1), scheduler: MainScheduler.instance) // 1초 기다립니다.
            .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인합니다.
            .filter({!$0.isEmpty}) // 새로운 값이 정말 새롭다면, 비어있지 않은 쿼리를 위해 필터링합니다.
            .subscribe(onNext: { [unowned self] query in
                self.showCities = self.allCities.filter({$0.hasPrefix(query)})
                self.citiTableview.reloadData()
            }).disposed(by: self.disposebag)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showCities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiCell", for: indexPath)
        //cell.citiLabel.text = self.showCities[indexPath.row]
        cell.textLabel?.text = self.showCities[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
