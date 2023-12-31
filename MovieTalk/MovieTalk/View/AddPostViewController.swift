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

final class AddPostViewController: UIViewController {
    
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
    let gradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    //TODO: ImagePicker
    
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
        let view = PaddedTextField()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        view.layer.cornerRadius = Design.paddingDefault
        view.font = Design.fontDefault
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
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = mainImageView.frame
    }
    
    
    func setView(){
        view.backgroundColor = .systemBackground
        view.addSubview(mainImageView)
        mainImageView.layer.addSublayer(gradientLayer)
        view.addSubview(postButton)
        view.addSubview(posterImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(contentsLabel)
        view.addSubview(contentsTextView)
        
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
    
    func bind(_ movieData: MovieResponseDTO, _ backdropImage: UIImage){

        mainImageView.image = backdropImage
        posterImageView.kf.setImage(with: Secret.getEndPointImageURL(movieData.posterPath ?? ""))
        movieTitleLabel.text = "\(movieData.title ?? "") (\(DateFormatter.movieYear(fromReleaseDateString: movieData.releaseDate ?? "9999-99-99") ?? ""))"

        
        lazy var input = AddPostViewModel.Input(postClicked: postButton.rx.tap, movieID: "\(movieData.id ?? 0)" , movieTitle: movieData.title ?? "", postImageData: posterImageView.image?.pngData() ?? Data())
       
        let output = viewModel.transform(input: input)
        
        output.postResult
            .bind(with: self) { owner, result in
                if result{
                    print("Post Success")
                    owner.dismiss(animated: true)                    
                }else{
                    print("Post Failed")
                }
            }.disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .bind { title in
                self.viewModel.titleString = title
            }
            .disposed(by: disposeBag)
        
        contentsTextView.rx.text.orEmpty
            .bind { contents in
                self.viewModel.contentsString = contents
            }
            .disposed(by: disposeBag)
    }
}
