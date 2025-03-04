//
//  BookTimeSlotsViewController.swift
//  LayersSpa
//
//  Created by 2B on 31/07/2024.
//

import UIKit
import UILayerSpa

class BookTimeSlotsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    @IBOutlet weak var timeSlotsCollectionView: UICollectionView!
    @IBOutlet weak var timingLabel: UILabel!
    
    // MARK: Properties
    private var viewModel: BookTimeSlotsViewModelType
    var isPerService = false
    var times = [String]()
    var selectedServiceId: String?
   // weak var delegate: (SelectNewTimeDelegate)?
    var completionHandler: ((String) -> Void)?
    // weak var cellDelgate: ApplyNewTimeDelegate?
    // MARK: Init
    
    init(viewModel: BookTimeSlotsViewModelType) {
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
        timingLabel.text = String(localized: "timing")
        setupView()
        collectionViewSetup()
        bindContinueButton()
        selectStoredTime()
        // print(times)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAvailableSlotsNotification(_:)),
            name: Notification.Name("AvailableSlotsNotification"),
            object: nil
        )
    }
    
    @objc func handleAvailableSlotsNotification(_ notification: Notification) {
        if let slots = notification.userInfo?["slots"] as? [String] {
            print("Received Available Slots: \(slots)")
            times = slots
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AvailableSlotsNotification"), object: nil)
    }
}

// MARK: - Actions

extension BookTimeSlotsViewController {
    func setupView() {
        navBar.delegate = self
        navBar.updateTitle(String(localized: "booking"))
        progressStackView.roundCorners(radius: 6)
        stepLabel.roundCorners(radius: 16)
        timeSlotsCollectionView.roundCorners(radius: 16)
    }
    private func selectStoredTime() {
        if let storedTime = UserDefaults.standard.string(forKey: "selectedTime") {
            for index in 0..<times.count {
                let time = "Time \(index + 1)"
                if time == storedTime {
                    let indexPath = IndexPath(row: index, section: 0)
                    timeSlotsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                    if let cell = timeSlotsCollectionView.cellForItem(at: indexPath) as? TimeSlotsCollectionViewCell {
                        cell.applySelectedStyle()
                    }
                    break
                }
            }
        }
    }

    // bind perservice cell
    func didSelectTimeSlot(time: String) {
        completionHandler!(time)
    }
}

// MARK: - Configurations

extension BookTimeSlotsViewController {
    
    func collectionViewSetup() {
        timeSlotsCollectionView.register(TimeSlotsCollectionViewCell.self)
        timeSlotsCollectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.reuseIdentifier)
        timeSlotsCollectionView.delegate = self
        timeSlotsCollectionView.dataSource = self
        collectionViewLayout()
    }
    
    func collectionViewLayout() {
        var x = 2.3
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 52)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        timeSlotsCollectionView.contentInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        if UIScreen.main.bounds.size.width < 400 {
            x = 2.4
        }
        layout.itemSize = CGSize(width: timeSlotsCollectionView.frame.width / x, height: 44)
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        timeSlotsCollectionView.collectionViewLayout = layout
    }
    
}

// MARK: - CollectionView

extension BookTimeSlotsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TimeSlotsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.timeLable.text = times[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeSlotsCollectionViewCell else {
//            return
//        }
//        cell.applySelectedStyle()
//        
//        let selectedTime = cell.timeLable.text ?? ""
//       
//                var allTimeSlots = [String]()
//                let userSettings = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] ?? [:]
//        
//                for (_, timeRange) in userSettings {
//                    allTimeSlots.append(timeRange)
//                }
//        
//            
////        if !isTimeSlotAvailable(selectedTime, existingSlots: allTimeSlots) {
////                showNoTimeSelectedAlert(msg: "You have already booked a service at this time,Please choose different time", btnTitle: "Ok")
////                return
////            }
////        
//        
//        
//        let serviceKey = selectedServiceId ?? "defaultService"
//        
//        var savedTimes = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] ?? [:]
//        savedTimes[serviceKey] = selectedTime
//        UserDefaults.standard.set(userSettings, forKey: "selectedServiceTime")
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeSlotsCollectionViewCell else {
            return
        }
        cell.applySelectedStyle()
        
        let selectedTime = cell.timeLable.text ?? ""
        
        var allTimeSlots = [String]()
        var savedTimes = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] ?? [:]
        
        for (_, timeRange) in savedTimes {
            allTimeSlots.append(timeRange)
        }
        
        
        if !isTimeSlotAvailable(selectedTime, existingSlots: allTimeSlots) {
            showNoTimeSelectedAlert(msg: "You have already booked a service at this time,Please choose different time", btnTitle: "Ok")
            return
        }
        // التأكد من أن serviceId ليس nil
        let serviceKey = selectedServiceId ?? "defaultService"
        
        
        savedTimes[serviceKey] = selectedTime
        
        // تخزين القيم في UserDefaults بشكل صحيح
        UserDefaults.standard.set(savedTimes, forKey: "selectedServiceTime")
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeSlotsCollectionViewCell else {
            return
        }
        cell.applyUnselectedStyle()
        
        let serviceKey = selectedServiceId ?? "defaultService"
        
        var userSettings = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] ?? [:]
        userSettings.removeValue(forKey: serviceKey)
        UserDefaults.standard.set(userSettings, forKey: "selectedServiceTime")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.reuseIdentifier, for: indexPath) as! CustomHeaderView
            headerView.label.text = String(localized: "selectFromTimeSlots")
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 52)
    }
    
}

// MARK: - Private Handlers

private extension BookTimeSlotsViewController {
    func bindContinueButton() {
        continueButton.setTitle(String(localized: "continue"), for: .normal)
        continueButton.applyButtonStyle(.filled)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    @objc func continueTapped() {
        guard let selectedIndexPath = timeSlotsCollectionView.indexPathsForSelectedItems?.first else {
            showNoTimeSelectedAlert(msg: "Please select a time for service before continuing", btnTitle: "Select Time")
            return
        }
        let selectedTime = times[selectedIndexPath.row]
        
        didSelectTimeSlot(time: selectedTime)
        self.dismiss(animated: true)
        
    }
}

extension BookTimeSlotsViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

// Mark:- check Time

extension BookTimeSlotsViewController{
    func isTimeSlotAvailable(_ newTimeSlot: String, existingSlots: [String]) -> Bool {
        func timeToMinutes(_ time: String) -> Int {
            let components = time.split(separator: ":").map { Int($0) ?? 0 }
            return components[0] * 60 + components[1]
        }

        func parseTimeSlot(_ timeSlot: String) -> (Int, Int)? {
            let times = timeSlot.split(separator: "-").map { String($0) }
            guard times.count == 2 else { return nil }
            return (timeToMinutes(times[0]), timeToMinutes(times[1]))
        }

        guard let newSlot = parseTimeSlot(newTimeSlot) else { return false }

        print("New Slot: \(newSlot)")

        for slot in existingSlots {
            if let existingSlot = parseTimeSlot(slot) {
                let (startNew, endNew) = newSlot
                let (startExisting, endExisting) = existingSlot

                print("Existing Slot: \(existingSlot)")
                print("Checking overlap: startNew = \(startNew), endNew = \(endNew), startExisting = \(startExisting), endExisting = \(endExisting)")

                if (startNew < endExisting && endNew > startExisting) {
                    print("Overlap detected")
                    return false // هناك تداخل
                }
            }
        }
        return true // لا يوجد تداخل
    }

    
    func showNoTimeSelectedAlert(msg:String, btnTitle: String) {
        let alertVC = CustomAlertViewController()
        alertVC.show("Warning", msg, buttonTitle: btnTitle,navigateButtonTitle: "", .redColor, .warning, flag: true)
        present(alertVC, animated: true, completion: nil)
    }
}




