//
//  NiblessView.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import UIKit

open class NiblessView: UIView {

    // MARK: - Methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable,
    message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
}