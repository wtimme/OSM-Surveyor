//
//  TableViewModelProtocol.swift
//  OSMSurveyor
//
//  Created by Wolfgang Timme on 15.04.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation

protocol TableViewModelProtocol {
    func numberOfSections() -> Int
    
    func numberOfRows(in section: Int) -> Int
    
    func row(at indexPath: IndexPath) -> Table.Row?
    
    func headerTitleOfSection(_ section: Int) -> String?
    
    func footerTitleOfSection(_ section: Int) -> String?
    
    func selectRow(at indexPath: IndexPath)
}
