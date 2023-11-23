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
    //view
    let contentsCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout() )
        collectionView.backgroundColor = .systemYellow
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.idenifier)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home VDL")
        setView()
        bind()
    }
    
    func setView(){
        view.backgroundColor = .systemBackground
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(contentsCollectionView)
        contentsCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func bind(){
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        //contents = relay
        output.contents
            .asDriver(onErrorJustReturn: [])
            .drive(contentsCollectionView.rx.items(cellIdentifier: HomeViewCell.idenifier, cellType: HomeViewCell.self)){
                row, element, cell in
                cell.cellData = element
                //configure cell
                cell.configureCell()
            }
            .disposed(by: disposeBag)
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        layout.scrollDirection = .horizontal
        return layout
    }
}
