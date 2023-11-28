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
    
    var contentsData: [Post] = []
    
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
    //
    //    override func viewIsAppearing(_ animated: Bool) {
    //        super.viewIsAppearing(animated)
    //    }
    //    override func viewDidAppear(_ animated: Bool) {
    //        print("Home Appeared")
    //        super.viewDidAppear(animated)
    //        let appearance = UITabBarAppearance()
    //        appearance.selectionIndicatorTintColor = .black
    //        appearance.backgroundColor = .white
    //        tabBarController?.tabBar.standardAppearance = appearance
    //        tabBarController?.tabBar.scrollEdgeAppearance = appearance
    //    }
    
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
        
        let contentsRelay = output.contents.asDriver(onErrorJustReturn: [])
        
        contentsRelay
            .drive(contentsTableView.rx.items(cellIdentifier: HomeViewCell.identifier, cellType: HomeViewCell.self)){
                row, element, cell in
                //configure cell
                cell.configureCellData(element)
                cell.selectionStyle = .none
                cell.navigationHandler = {
                    let vc = MovieViewController()
                    vc.bind(element.movieID ?? "")
                    self.navigationController?.pushViewController(vc, animated: true) //Rx 사용 안했기 때문에 구독이 끊길 일이 없음
                }
                
                cell.moreButton.rx.tap
                    .asDriver()
                    .debug("MOREBUTTON TAP \(row)")
                    .drive { [weak self] _ in
                        //이걸 해줘야 레이블이 늘어나는 기본 애니에이션이 들어감
                        self?.contentsTableView.beginUpdates()
                        cell.contentLabel.numberOfLines = 0
                        cell.moreButton.isHidden = true
                        self?.contentsTableView.endUpdates()
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
    }
    
}
