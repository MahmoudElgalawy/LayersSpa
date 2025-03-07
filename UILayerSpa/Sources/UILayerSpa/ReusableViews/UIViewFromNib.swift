//
//  File.swift
//  
//
//  Created by 2B on 12/06/2024.
//

import Foundation
import UIKit

open class UIViewFromNib: UIView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
    }

    private func commitInit() {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        let nibFile = UINib(nibName: nibName, bundle: bundle)
        guard let contentView = nibFile.instantiate(withOwner: self).first as? UIView else {
            assertionFailure("unable to find the content view")
            return
        }
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}
