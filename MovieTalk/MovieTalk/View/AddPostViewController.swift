//
//  AddPostViewController.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/25/23.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AddPostViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = AddPostViewModel()
    
    let postButton = {
        let view = UIButton()
        view.backgroundColor = .systemGray.withAlphaComponent(0.5)
        view.setTitle("게시하기", for: .normal)
        view.tintColor = .white
        view.titleLabel?.font = Design.fontAccentDefault
        view.setTitleColor(Design.colorTextTitle, for: .normal)
        view.layer.cornerRadius = Design.paddingDefault
        view.layer.borderWidth = 2
        view.layer.borderColor = Design.colorTextTitle.cgColor
        return view
    }()
    
    let mainImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    let titleTextField = {
        let view = UITextField()
        view.backgroundColor = Design.debugBlue
        view.placeholder = "  제목입력하세요"
        view.layer.cornerRadius = Design.paddingDefault
        view.layer.borderWidth = 1
        return view
    }()
    
    let contentsTextView = {
        var view = UITextView()
        view.backgroundColor = Design.debugPink
        view.font = Design.fontDefault
        view.isEditable = true
        view.isSelectable = true
        view.isScrollEnabled = true
        view.layer.cornerRadius = Design.paddingDefault
        view.layer.borderWidth = 1
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bind()
    }
    
    //메인사진 뷰 위에 선택한 영화 제목이랑 조그만한 포스터 보여주고
    //메인 사진은 사용자가 선택 할 수 있게 해야함. 카메라나 갤러리에서 선택하게 해줌. 디폴트로 tmdb에서 백드롭 사진을 줌
    //게시글 자체는 포스터 다운받은걸 새싹서버에 올리게 해야함. 그래야 홈에서 가져올 수 있음
    
    func setView(){
        view.backgroundColor = .systemBackground
        view.addSubview(mainImageView)
        view.addSubview(postButton)
        view.addSubview(titleTextField)
        view.addSubview(contentsTextView)

    }
    
    func bind(){
        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        postButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Design.paddingDefault)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
            make.height.equalTo(40)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
            make.height.equalTo(150)
            
        }
    }
    
    func setMovieData(_ movieData: MovieResponseDTO){
        print(movieData)
        
        mainImageView.kf.setImage(with: Secret.getEndPointImageURL(movieData.backdropPath ?? ""))
    }

}
