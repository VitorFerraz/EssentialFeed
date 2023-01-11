//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit

public final class ErrorView: UIButton {

    public var message: String? {
        get { return isVisible ? title(for: .normal) : nil }
        set { setMessageAnimated(newValue) }
    }
    
    public var onHide: (() -> Void)?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        backgroundColor = #colorLiteral(red: 0.9991759658, green: 0.4186978042, blue: 0.4158208966, alpha: 1)
        hideMessage()
        addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
    }
    
    private func configureLabel() {
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        titleLabel?.font = .systemFont(ofSize: 17)
        configuration?.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        hideMessage()
    }
    
    private var isVisible: Bool {
        return alpha > 0
    }
    
    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        setTitle(message, for: .normal)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    private func hideMessage() {
        setTitle(nil, for: .normal)
        alpha = 0
        configuration?.contentInsets = .init(top: -2.5, leading: 0, bottom: -2.5, trailing: 0)
        onHide?()

    }
    
    @objc private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.hideMessage() }
            })
    }
}
