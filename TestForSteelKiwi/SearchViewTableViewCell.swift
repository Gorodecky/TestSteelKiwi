//
//  SearchViewTableViewCell.swift
//  TestForSteelKiwi
//
//  Created by Mac on 08.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

import UIKit

class SearchViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var authorNameLable: UILabel!
    
    
    func initialyCell(repository: RepositorySearch) {
    
        self.nameLable.text = repository.nameRepository
        self.descriptionLable.text = repository.descriptionRepository
        self.authorNameLable.text = repository.authorRepository
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
