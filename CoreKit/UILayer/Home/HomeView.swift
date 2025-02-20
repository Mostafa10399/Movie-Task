//
//  HomeView.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


public enum HomeView {
    case root
    case details(id: Int, responder: ToggledWatchlistResponder)
}
