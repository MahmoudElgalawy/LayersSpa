//  
//  AllReviewsViewController.swift
//  LayersSpa
//
//  Created by marwa on 12/08/2024.
//

import UIKit

class AllReviewsViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var writeReviewButton: UIButton!
    @IBOutlet weak var navBarTitleLabel: UILabel!
    @IBOutlet weak var cloaseBtn: UIButton!
    // MARK: Properties

    private let viewModel: AllReviewsViewModelType

    // MARK: Init

    init(viewModel: AllReviewsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        bindCloseButton()
        bindWriteReviewButton()
    }
}

extension AllReviewsViewController {
    
    func tableViewSetup() {
        reviewsTableView.register(ReviewTableViewCell.self)
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
    }
    
}

// MARK: - UITableViewDelegate

extension AllReviewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

// MARK: - UITableViewDataSource

extension AllReviewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ReviewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
}


// MARK: - Configurations

extension AllReviewsViewController {
    
    func bindCloseButton() {
        cloaseBtn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true)
    }
    
    func bindWriteReviewButton() {
        writeReviewButton.applyButtonStyle(.filled)
        writeReviewButton.setTitle("Write Review", for: .normal)
        writeReviewButton.addTarget(self, action: #selector(writeReviewButtonTapped), for: .touchUpInside)
    }
    
    @objc func writeReviewButtonTapped() {
        
    }
}

// MARK: - Private Handlers

private extension AllReviewsViewController {}
