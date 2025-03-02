//
//  PaymentTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import UIKit
import UILayerSpa

class PaymentTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet  weak var paymentTableView: UITableView!
    
    var selectedIndexes: [Int: IndexPath] = [:]
    var viewModel: CheckOutViewModelType?
    
    var branches: [BookingSummerySectionsVM] = [ BookingSummerySectionsVM(sectionIcon: .wallet, sectionTitle: "Cash"),BookingSummerySectionsVM(sectionIcon:.visamaster, sectionTitle: "Visa")]
    
    var creditCard: [BookingSummerySectionsVM] = []
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadSavedCreditCards()
        tableViewSetup()
        selectFirstRow()
        DispatchQueue.main.async {
            self.paymentTableView.reloadData()
            self.updateTableViewHeight()
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        branches = [] // إعادة تعيين branches
//    }
    
    func selectFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        paymentTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        if let cell: PaymentOptionsTableViewCell = paymentTableView.cellForRow(at: indexPath) as? PaymentOptionsTableViewCell {
            cell.selectedStyle()
        }
    }
    
    
    func tableViewSetup() {
        paymentTableView.register(PaymentOptionsTableViewCell.self)
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        updateTableViewHeight()
    }
    
    func updateTableViewHeight() {
        let branchesHeight = branches.count * 60
        let creditCardHeight = creditCard.count * 60
        tableViewHeightConstraint.constant = CGFloat(branchesHeight + creditCardHeight + 88)
        print("Updated tableViewHeightConstraint: \(tableViewHeightConstraint.constant)")
    }

}

// MARK: - UITableViewDelegate

extension PaymentTableViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = PaymentHeaderView()
        if section == 0 {
            headerView.configureView("Select One Of Payment Methods", false)
        } else {
            headerView.configureView("Choose credit card", true)
            headerView.bindAddNewButton()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexes[indexPath.section] = indexPath
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        
        if indexPath.section == 0 {
            // إذا اختار طريقة دفع (كاش أو فيزا عادية)
            let selectedMethod = branches[indexPath.row].sectionTitle
            viewModel?.selectedPaymentMethod = selectedMethod
            viewModel?.visa = nil // مسح أي بطاقة فيزا قديمة
        } else {
            // إذا اختار بطاقة ائتمان
            let selectedCardTitle = creditCard[indexPath.row].sectionTitle
            let lastFourDigits = selectedCardTitle.components(separatedBy: " - **** ").last ?? ""

            // استرجاع بيانات البطاقات المخزنة ومقارنتها
            if let savedCards = UserDefaults.standard.array(forKey: "savedCreditCards") as? [[String: String]] {
                for card in savedCards {
                    if let cardHolder = card["cardHolder"],
                       let cardNumber = card["cardNumber"],
                       let cvv = card["cvv"],
                       let month = card["month"],
                       let year = card["year"] {
                        
                        // استخراج آخر 4 أرقام من رقم البطاقة
                        let storedLastFourDigits = String(cardNumber.suffix(4))
                        
                        if storedLastFourDigits == lastFourDigits {
                            // إنشاء كائن `Visa` وإرساله إلى `viewModel`
                            let selectedVisa = Visa(
                                cardHolder: cardHolder,
                                cardNumber: cardNumber,
                                cvv: cvv,
                                month: month,
                                year: year
                            )
                            
                            viewModel?.visa = selectedVisa
                            print("Selected Visa: \(selectedVisa)")
                            break
                        }
                    }
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension PaymentTableViewCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return branches.count
        }else {
            print("Returning creditCard.count: \(creditCard.count)")
            return creditCard.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentOptionsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let isSelected = selectedIndexes[indexPath.section] == indexPath
        if isSelected {
            cell.selectedStyle()
        } else {
            cell.unSelectedStyle()
        }
        
        if indexPath.section == 0 {
            print("Configuring cell for section 0: \(branches[indexPath.row].sectionTitle)")
            cell.configureCell(branches[indexPath.row])
        } else {
            print("Configuring cell for section 1: \(creditCard[indexPath.row].sectionTitle)")
            cell.configureCell(creditCard[indexPath.row])
        }
        
        cell.selectionStyle = .none
        
        return cell
    }

    
    func loadSavedCreditCards() {
        creditCard.removeAll() // مسح أي بيانات قديمة

        if let savedCards = UserDefaults.standard.array(forKey: "savedCreditCards") as? [[String: String]] {
            for card in savedCards {
                if let cardHolder = card["cardHolder"], let cardNumber = card["cardNumber"] {
                    let lastFourDigits = String(cardNumber.suffix(4)) // استخراج آخر 4 أرقام
                    let formattedTitle = "\(cardHolder) - **** \(lastFourDigits)" // تنسيق البيانات
                    
                    creditCard.append(BookingSummerySectionsVM(sectionIcon: .visa, sectionTitle: formattedTitle))
                }
            }
        }
    }

    
}



