//
//  QuestType.swift
//  OSMSurveyorFramework
//
//  Created by Wolfgang Timme on 31.03.20.
//  Copyright © 2020 Wolfgang Timme. All rights reserved.
//

import Foundation
import SwiftOverpassAPI

protocol QuestTypeProtocol {
    func download(boundingBox: BoundingBox,
                  using downloader: OverpassDownloading,
                  _ completion: @escaping (Result<[Int: OPElement], Error>) -> Void)
    
    var type: String { get }
}

extension QuestTypeProtocol {
    var type: String {
        guard let className = String(describing: self).split(separator: ".").last else { return "" }
        
        return className.replacingOccurrences(of: "Quest", with: "")
    }
}
