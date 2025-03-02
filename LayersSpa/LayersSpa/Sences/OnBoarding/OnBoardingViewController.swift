//
//  OnBoardingViewController.swift
//  LayersSpa
//
//  Created by marwa on 12/07/2024.
//

import UIKit
import UILayerSpa

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var stepView2: UIView!
    @IBOutlet weak var stepView1: UIView!
    @IBOutlet weak var welcomeDetailsLabel: UILabel!
    @IBOutlet weak var layersLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeStackView: UIStackView!
    @IBOutlet weak var haveAccountButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var onboardingStackView: UIStackView!
    @IBOutlet weak var nextStackView: UIStackView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var ttleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var upperImageView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let hasSeenOnBoardingKey = "hasSeenOnBoarding"
    
    let onboardingTitle = ["Unique Beauty", "Effortlessly", "Rewards"]
    
    let onboardingSubTitle = ["Discover Your ", "Book Appointments", "Enjoy Our Exclusive"]
    
    let onboardingDetails = [
        "At Layers Beauty Salon, we celebrate the diverse layers of beauty within each individual, offering personalized treatments that bring your best self.",
        
        "Enjoy the convenience of scheduling your beauty treatments with ease, ensuring you find the perfect time that fits your busy lifestyle.",
        
        "Join our loyalty program to earn points with every visit and unlock exclusive offers and discounts designed to enhance your beauty experience."
    ]
    
    let onboardingBackgroundImage: [UIImage] = [.backgroundOnBoarding1, .backgroundOnBoarding2, .backgroundOnBoarding3]
    let onboardingUpperImage: [UIImage] = [.onboarding1Image, .onboarding2Image, .onboarding3Image]
    
    var stepCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: hasSeenOnBoardingKey) {
            let vc = LoginViewController(viewModel: LoginViewModel())
                    self.navigationController?.setViewControllers([vc], animated: false)
               } else {
                   setupViwe()
                   applyImageGradient()
                   bindNextButton()
                   bindGetStarted()
                   bindHaveAccountButton()
                   bindSkipButton()
                   bindLabels()
                   setupLabels()
               }
    }
    
    func setupViwe() {
        upperImageView.layer.borderWidth = 1.0
        upperImageView.layer.borderColor = UIColor.secondaryColor.cgColor
        upperImageView.layer.cornerRadius = 90
    }
    
    func setupLabels() {
        ttleLabel.applyLabelStyle(.onboardingTitle)
        detailsLabel.applyLabelStyle(.onboardingDetails)
        subTitleLabel.applyLabelStyle(.onboardingSubTitle)
    }
    
    func applyImageGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.g1.cgColor,
            UIColor.g2.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]

        // تأكد من وضع الطبقة في الخلف
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    func bindLabels() {
        welcomeLabel.font = .h3Regular
        welcomeDetailsLabel.font = .B3Regular
        layersLabel.font = .h2Bold
    }
    
    func bindNextButton() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    func bindGetStarted() {
        getStartedButton.applyButtonStyle(.filled)
        getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
    }
    
    func bindHaveAccountButton() {
        haveAccountButton.addTarget(self, action: #selector(haveAccountTapped), for: .touchUpInside)
    }
    
    func bindSkipButton() {
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    @objc func skipButtonTapped() {
        welcomeStackView.isHidden = false
        onboardingStackView.isHidden = true
        nextStackView.isHidden = true
        backgroundImage.image = .welcome
        UserDefaults.standard.set(true, forKey: hasSeenOnBoardingKey)
    }
    
    @objc func nextButtonTapped() {
        
        if stepCount < 2 {
            stepCount += 1
            backgroundImage.image = onboardingBackgroundImage[stepCount]
            detailsLabel.text = onboardingDetails[stepCount]
            ttleLabel.text = onboardingTitle[stepCount]
            subTitleLabel.text = onboardingSubTitle[stepCount]
            self.setImageWithAnimation(newImage: onboardingUpperImage[stepCount])
            if stepCount == 1 {
                stepView1.backgroundColor = .whiteColor
            }else if stepCount == 2 {
                stepView2.backgroundColor = .whiteColor
            }
        } else {
            welcomeStackView.isHidden = false
            onboardingStackView.isHidden = true
            nextStackView.isHidden = true
            backgroundImage.image = .welcome
        }
       
    }
    
    @objc func getStartedTapped() {
        UserDefaults.standard.set(true, forKey: hasSeenOnBoardingKey)
        let vc = SignupViewController(viewModel: SignupViewModel())
        self.navigationController?.setViewControllers([vc], animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func haveAccountTapped() {
        UserDefaults.standard.set(true, forKey: hasSeenOnBoardingKey)
        let vc = LoginViewController(viewModel: LoginViewModel())
        self.navigationController?.setViewControllers([vc], animated: true)
      //  self.navigationController?.pushViewController(vc, animated: true)
    }

    func setImageWithAnimation(newImage: UIImage) {
        
        let tempImageView = UIImageView(image: newImage)
        tempImageView.frame = CGRect(x: self.view.frame.width + 400, y: self.onboardingImage.frame.origin.y + 1700, width: self.onboardingImage.frame.width, height: self.onboardingImage.frame.height)
        self.view.addSubview(tempImageView)
    
        UIView.animate(withDuration: 1,delay: 0,
                       options: [.curveEaseInOut],animations: {
            tempImageView.frame = self.onboardingImage.frame
        }) { _ in
            self.onboardingImage.image = newImage
            tempImageView.removeFromSuperview()
        }
        
    }
}

