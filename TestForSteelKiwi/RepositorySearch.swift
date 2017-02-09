//
//  RepositorySearch.swift
//  TestForSteelKiwi
//
//  Created by Mac on 08.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

import UIKit
import SwiftyJSON


class RepositorySearch: NSObject {
    
    var nameRepository: String? = nil
    var descriptionRepository: String? = nil
    var authorRepository: String? = nil
    
    init(nameRepo: String?, descriptionRepo: String? , authorRepo:String?) {
        self.nameRepository = nameRepo
        self.descriptionRepository = descriptionRepo
        self.authorRepository = authorRepo
    }
    
}
