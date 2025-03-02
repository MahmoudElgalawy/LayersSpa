//  
//  SelectLocationAndDateViewModel.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import Foundation

// MARK: SelectLocationAndDateViewModel

class SelectLocationAndDateViewModel {
    // ✅ بيانات الموظفين
    var employeesID: [Int] = []
   
    // ✅ حالة التحميل والخطأ
    var isLoading: Bool = false
    var errorMessage: String?
    var errorAlert: ()->() = {}
  

    private let employeeIdRemote: EmployeeIdRemoteProtocol
    
    // ✅ إغلاق يُستدعى عند تحديث البيانات
    var onDataUpdated: (() -> Void)?
    
    // ✅ التهيئة
    init(employeeIdRemote: EmployeeIdRemoteProtocol = EmployeeIdRemote()) {
        self.employeeIdRemote = employeeIdRemote
    }
    
    // ✅ دالة لجلب بيانات الموظفين باستخدام معرف المهارات
    func fetchEmployeeSkills(skillIDs: [String]) {
        isLoading = true
        errorMessage = nil
        onDataUpdated?() // تحديث الواجهة قبل تحميل البيانات
        
        employeeIdRemote.fetchEmployeeId(skillIDs: skillIDs) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let usersId):
                    self.employeesID = usersId
                    print("Emplyee Ids ================================= \( self.employeesID)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.errorAlert()
                }
                self.onDataUpdated?() // تحديث الواجهة بعد استلام البيانات
            }
        }
    }
}

// MARK: SelectLocationAndDateViewModel

extension SelectLocationAndDateViewModel: SelectLocationAndDateViewModelInput {
   
}

// MARK: SelectLocationAndDateViewModelOutput

extension SelectLocationAndDateViewModel: SelectLocationAndDateViewModelOutput {
   
}

// MARK: Private Handlers

private extension SelectLocationAndDateViewModel {}

