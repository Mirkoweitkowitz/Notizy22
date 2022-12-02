//
//  PageViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 07.11.22.
//

import SwiftUI
import UIKit

struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [UIHostingController(rootView: pages[0])], direction: .forward, animated: true)
    }
}

//struct PageViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        PageViewController(pages: [0])
//    }
//}
