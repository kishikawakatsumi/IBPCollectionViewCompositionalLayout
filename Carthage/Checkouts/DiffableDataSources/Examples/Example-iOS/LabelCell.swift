import UIKit

final class LabelCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
    }
}
