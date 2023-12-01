//
//  ProfileViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 12/2/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = ProfileViewModel()
    
    //view
    
    //vdl
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind(){
        
        let input = ProfileViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
            
    }

}
