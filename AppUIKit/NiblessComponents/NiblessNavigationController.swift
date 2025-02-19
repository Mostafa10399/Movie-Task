//
//  NiblessNavigationController.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import UIKit

open class NiblessNavigationController: UINavigationController {

    // MARK: - Methods
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }
}