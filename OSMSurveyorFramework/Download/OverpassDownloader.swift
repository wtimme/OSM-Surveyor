//
//  OverpassDownloader.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 31.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SwiftOverpassAPI

protocol OverpassDownloading {
    func fetchElements(query: String, _ completion: @escaping (Result<[Int: OPElement], Error>) -> Void)
}
