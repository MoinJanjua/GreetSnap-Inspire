import UIKit

protocol MessageCellDelegate: AnyObject {
    func didTapShareButton(withText text: String)
    func didTapCopyButton(withText text: String)
}

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var mesgLabel: UILabel!
    @IBOutlet weak var sharebtn: UIButton!
    @IBOutlet weak var CopyTextbtn: UIButton!
    
    weak var delegate: MessageCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        if let text = mesgLabel.text {
            delegate?.didTapShareButton(withText: text)
        }
    }

    @IBAction func copyTextButtonTapped(_ sender: UIButton) {
        if let text = mesgLabel.text {
            delegate?.didTapCopyButton(withText: text)
        }
    }
}
