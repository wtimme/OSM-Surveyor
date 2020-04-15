//
//  UploadViewModel.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 13.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import UIKit

final class UploadViewModel {
    // MARK: Public properties
    
    weak var delegate: TableViewModelDelegate?
    
    // MARK: Private properties
    
    private let questId: Int
    
    private var sections = [Table.Section]()
    
    // MARK: Initializer
    
    init(questId: Int) {
        self.questId = questId
    }
    
    // MARK: Private methods
    
    private func section(at index: Int) -> Table.Section? {
        guard index >= 0, index < numberOfSections() else { return nil }
        
        return sections[index]
    }
}

extension UploadViewModel: TableViewModelProtocol {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.section(at: section)?.rows.count ?? 0
    }
    
    func row(at indexPath: IndexPath) -> Table.Row? {
        guard
            let section = self.section(at: indexPath.section),
            indexPath.row >= 0,
            indexPath.row < section.rows.count
        else {
            /// Invalid index path.
            return nil
        }
        
        return section.rows[indexPath.row]
    }
    
    func headerTitleOfSection(_ section: Int) -> String? {
        return self.section(at: section)?.headerTitle
    }
    
    func footerTitleOfSection(_ section: Int) -> String? {
        return self.section(at: section)?.footerTitle
    }
    
    func selectRow(at indexPath: IndexPath) {
        /// TODO: Implement me.
    }
}
