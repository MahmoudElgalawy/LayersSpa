//
//  FilterViewController.swift
//  LayersSpa
//
//  Created by marwa on 27/07/2024.
//

import UIKit
import UILayerSpa

class FilterViewController: UIViewController {
    
    
    @IBOutlet private weak var showResultButton: UIButton!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var filterTableView: UITableView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    var listOfLocations: [BrancheVM] = []
       var ishideClear: Bool = false
       var resultButtonTitle = ""
       var delegate: FilterDelegate?
    var indicator : UIActivityIndicatorView?
    private var viewModel = HomeViewModel()
       
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
           titleLabel.text = String(localized: "filterby")
           loadBranches()
           filterTableView.showsVerticalScrollIndicator = false
           applyStyle()
           setupTableView()
           setupIndicator()
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectStoredBranch() // تحديد الفرع المخزن

    }
       
       func show(_ branches: [BrancheVM] = [], _ showResultTitle: String = "Show 16 results", _ isHideClear: Bool = false) {
           listOfLocations = branches
           ishideClear = isHideClear
           resultButtonTitle = showResultTitle
           
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
           clearButton.isHidden = ishideClear
           self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
           containerView.roundCorners(radius: 24)
           clearButton.setTitle("Clear filter", for: .normal)
           clearButton.applyButtonStyle(.border)
           clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
           
           showResultButton.setTitle(resultButtonTitle, for: .normal)
           showResultButton.applyButtonStyle(.filled)
           showResultButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
           
           closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
       }
    
    private func setupIndicator() {
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = view.center
        indicator?.color = .gray
        if let indicator = indicator {
            view.addSubview(indicator)
        }
    }
    
    private func loadBranches() {
        indicator?.startAnimating()
        viewModel.getBranches { [weak self] branches in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.indicator?.stopAnimating()
                self.listOfLocations = branches
                self.filterTableView.reloadData()
                self.selectStoredBranch() // تحديد الفرع المخزن بعد تحميل الفروع
                
            }
        }
    }
   }

   extension FilterViewController {
       
       func selectStoredBranch() {
           if let storedBranch = Defaults.sharedInstance.branchId,
              let selectedIndex = listOfLocations.firstIndex(where: { $0.id == storedBranch.id }) {
               
               let indexPath = IndexPath(row: selectedIndex, section: 0)
               
               DispatchQueue.main.async {
                   // إلغاء تحديد كل الصفوف أولاً
                   for visibleCell in self.filterTableView.visibleCells {
                       if let cell = visibleCell as? FilterAndSortTableViewCell {
                           cell.unSelectedStyle()
                       }
                   }

                   // تحديد الصف الجديد وتحديث الـ UI
                   self.filterTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                   if let cell = self.filterTableView.cellForRow(at: indexPath) as? FilterAndSortTableViewCell {
                       cell.selectedStyle()
                   }
               }
           }
       }

       
       func setupTableView() {
           filterTableView.delegate = self
           filterTableView.dataSource = self
           filterTableView.allowsMultipleSelection = false
           filterTableView.rowHeight = UITableView.automaticDimension
           filterTableView.estimatedRowHeight = 52
           filterTableView.register(FilterAndSortTableViewCell.self)
       }
   }

   // MARK: - UITableViewDelegate confirmation
   extension FilterViewController: UITableViewDelegate {
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 20
       }
       
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = .clear
           
           let headerLabel = UILabel()
           headerLabel.translatesAutoresizingMaskIntoConstraints = false
           headerLabel.text = String(localized: "locations")
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
           guard let cell = tableView.cellForRow(at: indexPath) as? FilterAndSortTableViewCell else {
               return
           }
           cell.selectedStyle()

           let selectedBranch = listOfLocations[indexPath.row]
           Defaults.sharedInstance.branchId = selectedBranch
       }
       
       func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           guard let cell = tableView.cellForRow(at: indexPath) as? FilterAndSortTableViewCell else {
               return
           }
           cell.unSelectedStyle()
       }
       
       func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           if let storedBranch = Defaults.sharedInstance.branchId,
              storedBranch.id == listOfLocations[indexPath.row].id {
               if let cell = cell as? FilterAndSortTableViewCell {
                   cell.selectedStyle()
               }
           }
       }
   }


   // MARK: - UITableViewDataSource confirmation
   extension FilterViewController: UITableViewDataSource {
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return listOfLocations.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell: FilterAndSortTableViewCell = tableView.dequeueReusableCell(for: indexPath)
           
           if ishideClear {
               cell.configeCellForBranches(listOfLocations[indexPath.row])
           } else {
               cell.configeCell(listOfLocations[indexPath.row].name)
           }
           
           return cell
       }
   }

   extension FilterViewController {
       
       @objc func clearButtonTapped() {
           Defaults.sharedInstance.branchId = nil // مسح التحديد عند الضغط على زر Clear
           self.dismiss(animated: true)
       }
       
       @objc func showButtonTapped() {
           guard let selectedBranch = Defaults.sharedInstance.branchId else { return }
           delegate?.showButtonClicked(selectedBranch)
           self.dismiss(animated: true)
       }
       
       @objc func closeButtonTapped() {
           self.dismiss(animated: true)
       }
   }

   protocol FilterDelegate {
       func showButtonClicked(_ branch: BrancheVM)
       func clearButtonClicked()
   }

   extension FilterDelegate {
       func clearButtonClicked() {
           print("Clear")
       }
   }
