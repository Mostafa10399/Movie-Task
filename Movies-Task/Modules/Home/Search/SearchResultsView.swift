//
//  SearchResultsView.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import UIKit
import SnapKit
import AppUIKit

class SearchResultsView: NiblessView {

    // MARK: - Properties

    let tableView = UITableView().with {
        $0.register(UINib(nibName: "MovieCell", bundle: Bundle(for: MovieCell.self)), forCellReuseIdentifier: "MovieCell")
        $0.backgroundColor = .clear
        $0.backgroundView = nil
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 600
        $0.separatorStyle = .none
        $0.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            $0.automaticallyAdjustsScrollIndicatorInsets = false
        }
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 10) + 10, right: 0)
        $0.tableFooterView = UIView()
    }
    
    // MARK: - Methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        constructHierarchy()
        activateConstraints()
        styleView()
    }

    private func constructHierarchy() {
        addSubview(tableView)
    }

    private func activateConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    private func styleView() {
        backgroundColor = .white
    }
}
