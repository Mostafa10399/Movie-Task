//
//  NavigationAction.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public enum NavigationAction<ViewModelType>: Equatable where ViewModelType: Equatable {
  
  case present(view: ViewModelType)
  case presented(view: ViewModelType)
}
