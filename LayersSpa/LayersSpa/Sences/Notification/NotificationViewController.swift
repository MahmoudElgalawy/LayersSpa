//  
//  NotificationViewController.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import UIKit

class NotificationViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var emptyAlertView: EmptyStateView!
    @IBOutlet private weak var notificationTableView: UITableView!
    @IBOutlet private weak var navBar: NavigationBarWithBack!
    
    // MARK: Properties

    private let viewModel: NotificationViewModelType
    var isEmptyState = false
    
    let notifications: [NotificationVM] = [
        NotificationVM(notifImage: .notif1, notifTitle: "Happy Eid", notifDesc: "Earn %15 discount on any of our services or products, Use promo-code: EID15"),
        NotificationVM(notifImage: .notif2, notifTitle: "Appointment Reminder", notifDesc: "You have an appointment tomorrow at 03:00 PM. Please arrive 10 minutes early You have an appointment tomorrow at 03:00 PM. Please arrive 10 minutes early."),
        NotificationVM(notifImage: .notif3, notifTitle: "Booking Cancelled", notifDesc: "Your appointment on 15th July has been cancelled. Contact us for rescheduling.")
    ]

    // MARK: Init

    init(viewModel: NotificationViewModelType) {
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
        
        if isEmptyState {
           notificationTableView.isHidden = true
            emptyAlertView.isHidden = false
        } else {
            notificationTableView.isHidden = false
            emptyAlertView.isHidden = true
        }
        
        bindEmptyView()
        navBarSetup()
        tableViewSetup()
       
    }
}

// MARK: - Actions

extension NotificationViewController {}

extension NotificationViewController  {
    
    func navBarSetup() {
        navBar.delegate = self
        navBar.updateTitle("Notifications")
    }
    
    func bindEmptyView() {
        emptyAlertView.configeView(.emptyNotification, "No Notifications yet", "Check out our services ")
    }
    
    func tableViewSetup() {
        notificationTableView.register(notificationTableViewCell.self)
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension NotificationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension NotificationViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell: notificationTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configeCell(notifications[indexPath.row])
        return cell
    }
    
}




// MARK: - Private Handlers

private extension NotificationViewController {}

extension NotificationViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

