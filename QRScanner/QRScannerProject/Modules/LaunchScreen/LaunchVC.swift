//
//  LaunchVC.swift
//  QRScanner
//
//  Created by George Popkich on 5.08.24.
//

import UIKit
import SnapKit

class LaunchVC: UIViewController {
    
    private var downloadAmount: Float = 0.0
    private var timer: Timer?

    private lazy var  logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Launch.iconImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = .appBlue
        progress.trackTintColor = .appGrey
        return progress
    }()
    
    private var coordinator: LaunchCoordanator
    
    init(coordinator: LaunchCoordanator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstrains()
        startProgress()
    }

    private func setup() {
        view.backgroundColor = .appBackground
        view.addSubview(logoImageView)
        view.addSubview(progressView)
    }
    
    private func setupConstrains() {
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.centerY.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).inset(-56.0)
            make.left.right.equalToSuperview().inset(56.0)
        }
    }

    private func startProgress() {
           timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) 
        { [weak self] _ in
               guard let self = self else { return }
               if self.downloadAmount < 100 {
                   self.downloadAmount += 10
                   self.progressView.setProgress(self.downloadAmount / 100, 
                                                 animated: true)
               } else {
                   self.timer?.invalidate()
                   self.coordinator.finish()
               }
           }
       }

       deinit {
           timer?.invalidate()
       }
    
}
