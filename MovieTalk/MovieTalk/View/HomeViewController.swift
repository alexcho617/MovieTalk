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
        button.addTarget(self, action: #selector(reloadCollectionView), for: .touchUpInside)
        return button
    }()
    @objc
    func reloadCollectionView(){
        self.contentsTableView.reloadData()
    }
    //view
    let contentsTableView = {
        let view = UITableView()
        view.estimatedRowHeight = 500
        view.rowHeight = UITableView.automaticDimension
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
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(contentsTableView)
        view.addSubview(reloadButton)
        contentsTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func bind(){
        
//        Observable.zip(contentsTableView.rx.modelSelected(Post.self), contentsTableView.rx.itemSelected)
//            .bind { [weak self] (post, indexPath) in
//                self?.contentsTableView.deselectRow(at: indexPath, animated: true)
//                print(post.movieID)
//            }
//            .disposed(by: disposeBag)
        
        
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        //contents = relay
        output.contents
            .asDriver(onErrorJustReturn: [])
//            .debug()
            .drive(contentsTableView.rx.items(cellIdentifier: HomeViewCell.identifier, cellType: HomeViewCell.self)){
                row, element, cell in
                //configure cell
                cell.configureCellData(element)
                cell.navigationHandler = {
                    let vc = MovieViewController()
                    vc.movieID = element.movieID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.moreButton.rx.tap
                    .bind(with: self) { owner, _ in
                        print("more tap")
//                        let index = IndexPath(row: row, section: 0)
                        cell.contentLabel.numberOfLines = 0
                        //TODO: 더보기 버튼 버그
//                        cell.moreButton.isHidden = true
//                        self.contentsTableView.reloadRows(at: [index], with: .automatic)
//                        self.contentsTableView.reloadData()
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
