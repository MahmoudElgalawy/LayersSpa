//
//  ProfessionalPerServiceTableViewCell.swift
//  LayersSpa
//
//  Created by 2B on 30/07/2024.
//

import UIKit
import UILayerSpa
import UILayerSpa

class ProfessionalPerServiceTableViewCell: UITableViewCell,IdentifiableView{

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profNameLabel: UILabel!
    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var selectedProfInfoStackView: UIStackView!
    @IBOutlet weak var selectProfessionalView: UIView!
    @IBOutlet weak var ServiceTitle: UILabel!
    @IBOutlet weak var serviceImg: UIImageView?
    @IBOutlet weak var selectTimeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lblSelectedTime: UILabel!
    @IBOutlet weak var showSelectedStack: UIStackView!
    @IBOutlet weak var stackViewSelectTime: UIStackView!
    @IBOutlet weak var timeImg: UIImageView!
    @IBOutlet weak var selectProfessionalLabel: UILabel!
    @IBOutlet weak var selectTimeLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var arrowImage2: UIImageView!
    @IBOutlet weak var prfessionalLabel: UILabel!
    @IBOutlet weak var itemsCountLabel: UILabel!
    
    weak var delegate: ProfessionalPerServiceTableViewCellDelegation?
    var selectedServiceId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        selectTimeLabel.text = String(localized: "selectTime")
        selectProfessionalLabel.text = String(localized: "selectProfessional")
        prfessionalLabel.text = String(localized: "professional")
        containerView.roundCorners(radius: 16)
        profImage.roundCorners(radius: 14)
        bindSelectProfessionalAndTimeViews()
        bindSelectTimeView()
        stackViewSelectTime.isHidden = false
        selectedProfInfoStackView.isHidden = true
        lblSelectedTime.isHidden = true
        selectTimeView.isUserInteractionEnabled = true
        selectProfessionalView.isUserInteractionEnabled = true
        showSelectedStack.isHidden = false
        selectedProfInfoStackView.isHidden = true
        rotateImageBasedOnLanguage()
                }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedProfInfoStackView.isHidden = true
       // editButton.isHidden = true
        showSelectedStack.isHidden = false
        selectProfessionalView.isUserInteractionEnabled = true
        profNameLabel.text = ""
        profImage.image = nil
//        stackViewSelectTime.isHidden = false
//        selectTimeView.isUserInteractionEnabled = true
//        lblSelectedTime.text = ""
    }
    
    private func rotateImageBasedOnLanguage() {
        let currentLanguage = Locale.preferredLanguages.first ?? "en"
        let rotationAngle: CGFloat = currentLanguage == "ar" ? .pi : 0
        arrowImage.transform = CGAffineTransform(rotationAngle: rotationAngle)
        arrowImage2.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    func resetSelections() {
        selectedProfInfoStackView.isHidden = true
       // editButton.isHidden = true
        showSelectedStack.isHidden = false
        selectProfessionalView.isUserInteractionEnabled = true
        profNameLabel.text = ""
        profImage.image = nil
        resetTimeSelection()
    }
    
    func resetTimeSelection() {
        stackViewSelectTime.isHidden = false
        selectTimeView.isUserInteractionEnabled = true
        lblSelectedTime.text = ""
        lblSelectedTime.isHidden = true
    }
    
    func applySelectedProfessional(_ professionalInfo: Employee) {
        if professionalInfo.empData.name != ""{
            selectedProfInfoStackView.isHidden = false
          //  editButton.isHidden = false
            showSelectedStack.isHidden = true
           // selectProfessionalView.isUserInteractionEnabled = false
            let proImageUel = URL(string: "\(professionalInfo.empData.profileInfo.profileImage)")
            profImage.kf.setImage(with: proImageUel)
            profNameLabel.text = professionalInfo.empData.name
            print("employee name -> -> -> -> -> -> -> -> -> -> -> -> -> -> -> -> -> -> -> -> -> \((professionalInfo.empData.name))")
        }
    }
    
    
    func applySelectedTime(time:String){
        stackViewSelectTime.isHidden = true
        //selectTimeView.isUserInteractionEnabled = false
        lblSelectedTime.text = time
        lblSelectedTime.isHidden = false
    }
    
    func configureService(_ service: ProductVM) {
        if service.type != "service" {
                timeImg.image = UIImage(named: "notif1")
                timeLabel.text = "\(service.productCount)"
                selectTimeView.isHidden = true
                selectProfessionalView.isHidden = true
                lblSelectedTime.isHidden = true
                stackViewSelectTime.isHidden = true
                itemsCountLabel.isHidden = true
        } else {
            timeImg.image = UIImage(named: "time")
            timeLabel.text = "\((service.unit)! * service.productCount) m"
            selectTimeView.isHidden = false
            selectProfessionalView.isHidden = false
            lblSelectedTime.isHidden = true
            stackViewSelectTime.isHidden = false
            itemsCountLabel.isHidden = false
        }
        
        if service.productCount > 1 {
            itemsCountLabel.text = "\(service.productCount) \(String(localized: "items"))"
        }else {
            itemsCountLabel.text = "\(service.productCount) \(String(localized: "item"))"
        }
            
            let imgUrl = URL(string: "\(service.productImage)")
            serviceImg?.kf.setImage(with: imgUrl) { result in
                switch result {
                case .success(let value):
                    self.serviceImg?.image = value.image.circleMasked
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
            selectedServiceId = service.productId
            ServiceTitle.text = service.productName
            //editButton.setTitle("\(service.productCount) items", for: .normal)
            
            // Reset professional info
            selectedProfInfoStackView.isHidden = true
           // editButton.isHidden = true
            showSelectedStack.isHidden = false
            selectProfessionalView.isUserInteractionEnabled = true
            profNameLabel.text = ""
            profImage.image = nil
            lblSelectedTime.text = ""
            lblSelectedTime.isHidden = true
            selectTimeView.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
               self.superview?.superview?.setNeedsLayout()
               self.superview?.superview?.layoutIfNeeded()
           }
    
    }
    
    
    func bindSelectProfessionalAndTimeViews() {
        selectProfessionalView.roundCorners(radius: 16)
        selectProfessionalView.backgroundColor = UIColor.grayLight
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectProfessionalViewTapped(_:)))
        selectProfessionalView.addGestureRecognizer(tapGestureRecognizer)
       // selectProfessionalView.isUserInteractionEnabled = true
        showSelectedStack.roundCorners(radius: 16)
    }
    
    func bindSelectTimeView(){
        selectTimeView.roundCorners(radius: 16)
        let tapGestureRecognizerTime = UITapGestureRecognizer(target: self, action: #selector(selectTimeViewTapped(_:)))
        selectTimeView.addGestureRecognizer(tapGestureRecognizerTime)
        selectTimeView.isUserInteractionEnabled = true
    }
    
    
    @objc func selectProfessionalViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.selectProfessional(self) {  employee in
             
        }
    }
    
    @objc func selectTimeViewTapped(_ sender: UITapGestureRecognizer) {
            if profNameLabel.text?.isEmpty == true || profImage.image == nil {
                CustomAlertViewController().show(String(localized: "warning") + "!", String(localized: "pleaseSelectProfessionalFirst"), buttonTitle: String(localized: "ok"),navigateButtonTitle: "", .redColor, .warning, flag: true)
                return
            }
            
            delegate?.selectTime(self) { [weak self] time in
                self?.applySelectedTime(time: time)
            }
        }
    
    @IBAction func editButtonTapped(_ sender: Any) {
//        delegate?.selectProfessional(self) { [weak self] employee in
//               if employee.empData.profileInfo.name != "" {
//                   self?.selectedProfInfoStackView.isHidden = false
//                   self?.editButton.isHidden = false
//                   self?.showSelectedStack.isHidden = true
//                   self?.selectProfessionalView.isUserInteractionEnabled = false
//                   let proImageUrl = URL(string: "\(employee.empData.profileInfo.profileImage)")
//                   self?.profImage.kf.setImage(with: proImageUrl)
//                   self?.profNameLabel.text = employee.empData.profileInfo.name
//                   
//                   self?.lblSelectedTime.text = ""
//                   self?.lblSelectedTime.isHidden = true
//                   self?.stackViewSelectTime.isHidden = false
//                   self?.selectTimeView.isUserInteractionEnabled = true
//                   
//                   guard let serviceId = self?.selectedServiceId else { return }
//                   var userSettings = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] ?? [:]
//                   userSettings[serviceId] = nil
//                   UserDefaults.standard.set(userSettings, forKey: "selectedServiceTime")
//               }
//           }
    }
    
}

struct selectedProfessionalVM {
    let profImage: String
    let profName: String
}

protocol ProfessionalPerServiceTableViewCellDelegation: AnyObject {
    func selectProfessional(_ cell: UITableViewCell,Completion:@escaping (Employee)->())
//    func editProfessional(_ cell: UITableViewCell)
    func selectTime(_ cell: UITableViewCell,Completion:@escaping (String)->())
}


protocol SelectNewTimeDelegate: AnyObject {
    func didSelectNewTime(_ time: String)
}

