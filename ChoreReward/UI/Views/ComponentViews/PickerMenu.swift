//
//  PickerMenu.swift
//  ChoreReward
//
//  Created by Toan Pham on 7/1/22.
//

import SwiftUI

struct PickerMenu: View {
    @State private var pickerButtonLabelWidth: CGFloat = .infinity

    var body: some View {
        PickerMenuRepresentable(labelContentWidth: $pickerButtonLabelWidth)
            .frame(width: pickerButtonLabelWidth, height: StylingSize.tappableHeight, alignment: .center)

    }
}

struct PickerMenu_Previews: PreviewProvider {
    static var previews: some View {
        PickerMenu()
            .previewLayout(.sizeThatFits)
    }
}

struct PickerMenuRepresentable: UIViewRepresentable {
    @Binding private var labelContentWidth: CGFloat

    init(
        labelContentWidth: Binding<CGFloat>
    ) {
        self._labelContentWidth = labelContentWidth
    }

    var menuItems: [UIAction] {
        return [
            UIAction(title: "Standard item", image: UIImage(systemName: "sun.max"), handler: { (_) in
            }),
            UIAction(title: "Disabled item", image: UIImage(systemName: "moon"), attributes: .disabled, handler: { (_) in
            }),
            UIAction(title: "Delete..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
            })
        ]
    }

    func updateUIView(_ uiView: UIButton, context: Context) {}

    func makeUIView(context: Context) -> UIButton {
        let menuButton = UIButton()
        menuButton.setTitle("Filter", for: .normal)
        menuButton.setTitleColor(UIColor(.fg), for: .normal)
        menuButton.setImage(UIImage(systemName: "tray"), for: .normal)
        menuButton.tintColor = UIColor(.fg)
        menuButton.menu = UIMenu(title: "Filter", children: menuItems)
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.backgroundColor = UIColor(.bg)
        DispatchQueue.main.async {
            self.labelContentWidth = menuButton.intrinsicContentSize.width
        }
        return menuButton
    }
}
