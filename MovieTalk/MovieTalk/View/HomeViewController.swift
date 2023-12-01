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
    let refreshControl = UIRefreshControl()

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
    
    func setView(){
        self.contentsTableView.delegate = self
        self.refreshControl.endRefreshing()
        self.contentsTableView.refreshControl = refreshControl
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
                cell.presentationHandler = {
                    let vc = CommentsViewController()
                    vc.postID = element.id
                    vc.comments = element.comments ?? []
                    vc.setView()
                    vc.bind()
                    
                    if let sheet = vc.sheetPresentationController{
                        sheet.detents = [.custom(resolver: { context in
                            return (self.view.window?.windowScene?.screen.bounds.height ?? 800) * 0.66
                        }), .large()] //화면 2/3 지점, 그리고 전체화면
                        sheet.prefersGrabberVisible = true
                    }
                    self.present(vc, animated: true, completion: nil)
                }
                
                cell.moreButton.rx.tap
                    .asDriver()
                    .drive { [weak self] _ in
                        self?.contentsTableView.beginUpdates() //레이블이 늘어나는 기본 애니메이션
                        cell.contentLabel.numberOfLines = 0
                        cell.moreButton.isHidden = true
                        self?.contentsTableView.endUpdates()
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind { [weak self] _ in
                print("PULL TO REFRESH")
//                self?.viewModel.tempContents = []
//                self?.viewModel.nextCursor = ""
                self?.viewModel.fetch(isRefreshing: true){
                    self?.refreshControl.endRefreshing() //TODO: closure 처리
                }
            }.disposed(by: disposeBag)
    }
    
}


extension HomeViewController: UITableViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //마지막 부분 n픽셀 전 다음 컨텐츠 호출
        if (self.contentsTableView.contentOffset.y + 800) > contentsTableView.contentSize.height - contentsTableView.bounds.size.height {
            viewModel.fetch(completion: {})
        }
    }
}
