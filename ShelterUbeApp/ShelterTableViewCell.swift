
import UIKit
import MapKit

class ShelterTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.accessoryType = .disclosureIndicator
    }
    
}
