//
//  HomeViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/23/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class HomeViewController: UIViewController{
    let disposeBag = DisposeBag()
    let viewModel = HomeViewModel()
    
    //debug
    lazy var reloadButton = {
        let button = UIButton()
        button.setTitle("Reload", for: .normal)
        button.addTarget(self, action: #selector(reloadTableView), for: .touchUpInside)
        return button
    }()
    @objc
    func reloadTableView(){
        self.contentsTableView.reloadData()
    }
    //view
    let contentsTableView = {
        let view = UITableView()
        view.estimatedRowHeight = 500
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        view.register(HomeViewCell.self, forCellReuseIdentifier: HomeViewCell.identifier)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bind()
    }
    
    func setView(){
        view.backgroundColor = .systemBackground
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        
        view.addSubview(contentsTableView)
        view.addSubview(reloadButton)
        
        contentsTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func bind(){
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.contents
            .asDriver(onErrorJustReturn: [])
        
        //TODO: CRUD를 위해서 지역변수에 저장 후 바인드 해야함
        //TODO: Rxdatasource를 쓰면?
            .drive(contentsTableView.rx.items(cellIdentifier: HomeViewCell.identifier, cellType: HomeViewCell.self)){
                row, element, cell in
                //configure cell
                cell.configureCellData(element)
                cell.selectionStyle = .none
                cell.navigationHandler = {
                    let vc = MovieViewController() //Rx 사용 안했기 때문에 구독이 끊길 일이 없음
                    vc.bind(element.movieID ?? "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                //더보기 버튼
                //TODO: 두번 클릭해야 실행되는 문제 있음
                cell.moreButton.rx.tap
                    .asDriver()
                    .debug("MOREBUTTON TAP")
                    .drive { _ in
                        cell.contentLabel.numberOfLines = 0
                        cell.moreButton.isHidden = true
                        self.contentsTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
