import AppKit

final class LabelItem: NSCollectionViewItem {
    static var itemIdentifier: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier(String(describing: self))
    }

    let label = NSTextField()

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.isEditable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        let constraints = [
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
