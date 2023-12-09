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
import Kingfisher

class CommentsViewController: UIViewController {
    var postID: String = ""
    var comments: [Comment] = [] //local변수 for view
    var disposeBag = DisposeBag()
    var newCommentsHandler: (([Comment]) -> Void)?

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
//        print("Comments VC", #function)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newCommentsHandler?(comments)
    }
    
    func bind(){
//        print(#function)
        commentsSubject
            .bind(to: commentsTableView.rx.items(cellIdentifier: CommentsTableViewCell.identifier , cellType: CommentsTableViewCell.self)){ row, element, cell in
            cell.selectionStyle = .none
                
            if let profileURL = element.creator.profile{
                print("profile image url:", profileURL)
                let imageRequestString = Secret.baseURLString + profileURL + Secret.imageQuery
                cell.profileImageView.kf.setImage(
                    with: URL(string: imageRequestString),
                    placeholder: UIImage(systemName: "star"),
                    options: [.requestModifier(self.getRequestModifier()), .cacheOriginalImage]
                )
            }else{
                cell.profileImageView.image = UIImage(systemName: "person.fill")
                cell.profileImageView.tintColor = .random()
            }
            
            cell.nameLabel.text = element.creator.nick
            
            cell.timeLabel.text = DateFormatter.localizedDateString(fromTimestampString: element.time)

            cell.commentLabel.text = element.content
            
            //내가 쓴 댓글인지 확인
            //TODO: 삭제 trailing action 분기처리 
            if element.creator._id == UserDefaultsManager.shared.currentUserID{
//                cell.backgroundColor = Design.debugPink
            }else{
//                cell.backgroundColor = .white
            }
        }
        .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .bind(with: self) { owner, content in
                owner.postButton.rx.isEnabled.onNext(content.count > 0 ? true : false)
                owner.postButton.setTitleColor(content.count > 0 ? .systemBlue : .systemGray, for: .normal)
            }
            .disposed(by: disposeBag)
        
        postButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance) //3초 제한
            .withLatestFrom(textField.rx.text.orEmpty)
            .flatMapLatest{ textFieldContent in
                return ContentsManager.shared.addComment(CommentCreateRequestDTO(content: textFieldContent), self.postID)
            }
            .subscribe(with: self, onNext: { owner, comment in
                if comment._id != ""{
//                    print("Comment Added")
                    owner.comments.insert(comment, at: 0)
                    owner.commentsSubject.onNext(owner.comments)
                    owner.textField.text = ""
                }else{
                    print("Invalid Empty Comment")
                }
            })
            .disposed(by: disposeBag)
        
        //댓글 placeholder label 처리
        commentsSubject //if comments empty, return false so
            .bind(with: self, onNext: {owner, comments in
                if comments.count == 0{
                    owner.placeholderLabel.isHidden = false
                }else{
                    owner.placeholderLabel.isHidden = true
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
    
    private func getRequestModifier() -> AnyModifier{
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(Secret.key, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.currentToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        return imageDownloadRequest
    }
    deinit {
        print("Comments VC, deinit")
    }
}


extension CommentsViewController: UITableViewDelegate{
    
}
