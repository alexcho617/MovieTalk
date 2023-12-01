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
    var postID: String = ""
    var comments: [Comment] = [] //local변수 for view
    var disposeBag = DisposeBag()
    lazy var commentsSubject = BehaviorSubject<[Comment]>(value: comments)
    //views
    let titleLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "댓글"
        view.font = Design.fontAccentDefault
        view.textColor = .black
        return view
    }()
    
    let commentsTableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.estimatedRowHeight = 100
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        view.keyboardDismissMode = .onDrag
        view.register(CommentsTableViewCell.self, forCellReuseIdentifier:CommentsTableViewCell.identifier )
        return view
    }()
    
    let textField = {
        let view = UITextField()
        view.placeholder = "댓글 달기..."
        view.font = Design.fontDefault
        return view
    }()
    
    lazy var placeholderLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Design.fontDefault
        view.text = "댓글이 없습니다"
        return view
    }()
    
    let postButton = {
        let view = UIButton()
        view.setTitle("게시", for: .normal)
        view.titleLabel?.font = Design.fontDefault
        view.setTitleColor(.systemBlue, for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Comments VC", #function)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Reload HomeVC")
    }
    
    func bind(){
        print(#function)
        commentsSubject
            .bind(to: commentsTableView.rx.items(cellIdentifier: CommentsTableViewCell.identifier , cellType: CommentsTableViewCell.self)){ row, element, cell in
//            cell.profileImageView.image = UIImage from element.creator.profile
            cell.selectionStyle = .none
            cell.profileImageView.image = UIImage(systemName: "person")?.withTintColor(UIColor.blue.withAlphaComponent(CGFloat.random(in: 0...1)))
            cell.nameLabel.text = element.creator.nick
            cell.timeLabel.text = element.time
            cell.commentLabel.text = element.content
            
            //내가 쓴 댓글인지 확인
            if element.creator._id == UserDefaultsManager.shared.currentUserID{
                cell.backgroundColor = Design.debugPink
            }else{
                cell.backgroundColor = .white
            }
        }
        .disposed(by: disposeBag)
        
        postButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .flatMapLatest{ textFieldContent in
                return ContentsManager.shared.addComment(CommentCreateRequestDTO(content: textFieldContent), self.postID)
            }
            .subscribe(with: self, onNext: { owner, comment in
                if comment._id != ""{
                    print("Comment Added")
                    owner.comments.insert(comment, at: 0)
                    //TODO: 들어왔는데 뷰에 보여지지 않음
                    owner.commentsSubject.onNext(owner.comments)
                }else{
                    print("Invalid Empty Comment")
                }
            })
            .disposed(by: disposeBag)
        
        Observable.just(comments.isEmpty) //if comments empty, return false so
            .bind(with: self, onNext: { [self] owner, commentIsEmpty in
                if commentIsEmpty{
                    //show placeholder
                    placeholderLabel.isHidden = false
                }else{
                    //hide placeholder
                    placeholderLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func setView(){
        commentsTableView.delegate = self
        view.addSubview(commentsTableView)
        view.addSubview(titleLabel)
        view.addSubview(placeholderLabel)
        view.addSubview(textField)
        view.addSubview(postButton)
        view.backgroundColor = .white
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview()
        }
        
        placeholderLabel
            .snp.makeConstraints { make in
                make.center.equalTo(commentsTableView.snp.center)
                make.height.equalTo(50)
                make.width.equalTo(commentsTableView.snp.width).inset(Design.paddingDefault)
            }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(commentsTableView.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalToSuperview().offset(2 * Design.paddingDefault)
            make.height.equalTo(40)
            make.bottom.greaterThanOrEqualTo(view.keyboardLayoutGuide.snp.top).offset(-Design.paddingDefault) // 키보드로부터 위로 여백
        }
        
        postButton.snp.makeConstraints { make in
            make.top.equalTo(textField)
            make.height.equalTo(40)
            make.leading.equalTo(textField.snp.trailing).offset(Design.paddingDefault)
            make.width.equalTo(60)
            make.trailing.equalToSuperview().inset(Design.paddingDefault)
        }
        
    }

}


extension CommentsViewController: UITableViewDelegate{
    
}
