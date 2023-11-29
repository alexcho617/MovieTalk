//
//  CommentsViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/25/23.
//

import UIKit

class CommentsViewController: UIViewController {
    
    var postID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Comments VC", #function)
        
        view.backgroundColor = Design.debugBlue
    }

}
