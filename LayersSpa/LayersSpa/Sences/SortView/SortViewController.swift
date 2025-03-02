//
//  SortViewController.swift
//  LayersSpa
//
//  Created by marwa on 27/07/2024.
//

import UIKit

class SortViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sortTableView: UITableView!
    
    let listOfSort = ["High to low", "Low to high"]
    var selectedIndexes: [Int: IndexPath] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        setupTableView()
    }
    
    func show() {
        
        guard let window = UIApplication.shared.currentWindow else {
            print("No current window found")
            return
        }
        guard let rootViewController = window.rootViewController else {
            print("No root view controller found")
            return
        }
        rootViewController.present(self, animated: true, completion: nil)
    }
    
    func applyStyle() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.roundCorners(radius: 24)
        clearButton.setTitle("Reset", for: .normal)
        clearButton.applyButtonStyle(.border)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.applyButtonStyle(.filled)
        confirmButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

}

extension SortViewController {
    
    func setupTableView(){
        sortTableView.delegate = self
        sortTableView.dataSource = self
        sortTableView.rowHeight = UITableView.automaticDimension
        sortTableView.estimatedRowHeight = 52
        sortTableView.register(FilterAndSortTableViewCell.self)
    }
    
}

//MARK: - UITableViewDelegate confirmation

extension SortViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        if section == 0 {
            headerLabel.text = "Price"
        } else {
            headerLabel.text = "Rating"
        }
       
        headerLabel.textColor = .darkTextColor
        headerLabel.font = .B3Medium
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedIndexes[indexPath.section] = indexPath
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }

}

//MARK: - UITableViewDelegate confirmation
extension SortViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSort.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FilterAndSortTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configeCell(listOfSort[indexPath.row])
        let isSelected = selectedIndexes[indexPath.section] == indexPath
        if isSelected {
            cell.selectedStyle()
        }else {
            cell.unSelectedStyle()
        }
        cell.selectionStyle = .none
        return cell
    }
}



extension SortViewController {
    
    @objc func clearButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func showButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

protocol SortDelegate {
    func showButtonClicked ()
    func clearButtonClicked ()
}
