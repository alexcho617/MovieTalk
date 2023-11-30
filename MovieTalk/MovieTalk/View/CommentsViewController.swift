//
//  CommentsViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/25/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CommentsViewController: UIViewController {
    
    //mock data
    var postID: String = "6566e42deb795c17d870af1c"
    var comments: [Comment] = [
        Comment(_id: "6566f01beb795c17d870b221", content: "\(Int.random(in: 1...100))예시 댓글", time: "2023-11-29T08:02:35.549Z", creator: Creator(_id: "655c6cb35b34e559bca097eb", nick: "alex1")),
        Comment(_id: "6566f01beb795c17d870b222", content: "\(Int.random(in: 1...100))예시 댓글", time: "2023-11-29T08:02:35.549Z", creator: Creator(_id: "655c6cb35b34e559bca097eb", nick: "alex2")),
        Comment(_id: "6566f01beb795c17d870b223", content: "\(Int.random(in: 1...100))예시 댓글", time: "2023-11-29T08:02:35.549Z", creator: Creator(_id: "655c6cb35b34e559bca097eb", nick: "alex3")),
        Comment(_id: "6566f01beb795c17d870b224", content: "\(Int.random(in: 1...100))예시 댓글", time: "2023-11-29T08:02:35.549Z", creator: Creator(_id: "655c6cb35b34e559bca097eb", nick: "alex4")),
        Comment(_id: "6566f01beb795c17d870b225", content: "\(Int.random(in: 1...100))예시 댓글", time: "2023-11-29T08:02:35.549Z", creator: Creator(_id: "655c6cb35b34e559bca097eb", nick: "alex5"))
        
    ]
    
    let commentsTableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = Design.debugBlue
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Comments VC", #function)
        
        view.backgroundColor = .white
    }
    
    func bind(){
        
    }
    
    func setView(){
        commentsTableView.delegate = self
        view.addSubview(commentsTableView)
        commentsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}


extension CommentsViewController: UITableViewDelegate{
    
}
