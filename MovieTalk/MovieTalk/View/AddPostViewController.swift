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
    
    let posterImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.layer.cornerRadius = Design.paddingDefault
        view.clipsToBounds = true
        return view
    }()
    
    let movieTitleLabel = {
        let view = UILabel()
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextTitle
        view.numberOfLines = 0
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "제목"
        view.font = Design.fontSmall
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    
    let titleTextField = {
        let view = UITextField()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        view.layer.cornerRadius = Design.paddingDefault
        return view
    }()
    
    let contentsLabel = {
        let view = UILabel()
        view.text = "내용"
        view.font = Design.fontSmall
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    
    let contentsTextView = {
        var view = UITextView()
        view.font = Design.fontDefault
        view.isEditable = true
        view.isSelectable = true
        view.isScrollEnabled = true
        view.layer.cornerRadius = Design.paddingDefault
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        view.keyboardDismissMode = .onDrag
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
        view.addSubview(posterImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(contentsLabel)
        view.addSubview(contentsTextView)

    }
    
    func bind(){
        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        postButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Design.paddingDefault)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.bottom.equalTo(mainImageView.snp.bottom).offset(2*Design.paddingDefault)
            make.leading.equalToSuperview().offset(Design.paddingDefault)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(mainImageView.snp.bottom).offset(-Design.paddingDefault)
            make.leading.equalTo(posterImageView.snp.trailing).offset(Design.paddingDefault)
            make.trailing.lessThanOrEqualToSuperview().inset(Design.paddingDefault)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
            make.height.equalTo(40)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            
        }
    }
    
    func setMovieData(_ movieData: MovieResponseDTO){
        print(movieData)
        
        mainImageView.kf.setImage(with: Secret.getEndPointImageURL(movieData.backdropPath ?? movieData.posterPath ?? ""))
        
        posterImageView.kf.setImage(with: Secret.getEndPointImageURL(movieData.posterPath ?? ""))
        movieTitleLabel.text = movieData.title ?? ""
    }

}
