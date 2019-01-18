//
//  RIBsTreeViewer.swift
//  RIBsTreeViewerClient
//
//  Created by yuki tamazawa on 2019/01/16.
//  Copyright © 2019 minipro. All rights reserved.
//

import Foundation
import RxSwift
import RIBs
import SocketIO

final class RIBsTreeViewer {

    private let router: Routing
    private let socketClient = SocketClient()
    private let disposeBag = DisposeBag()

    init(router: Routing) {
        self.router = router
    }

    func start() {
        Observable<Int>.interval(0.2, scheduler: MainScheduler.instance)
            .map { [unowned self] _ in
                self.tree(router: self.router)
            }
            .distinctUntilChanged { a, b in
                NSDictionary(dictionary: a).isEqual(to: b)
            }
            .subscribe(onNext: { [unowned self] in
                self.socketClient.send(tree: $0)
            })
            .disposed(by: disposeBag)

        socketClient.socket.on("take capture rib") { [unowned self] data, _ in
            guard let routerName = data[0] as? String else { return }
            print("take capture")
            if let base64Image = self.takeBase64Capture(targetRouter: routerName) {
                self.socketClient.socket.emit("capture image", base64Image)
            }
        }
    }

    private func tree(router: Routing, appendImage: Bool = false) -> [String: Any] {
        var currentRouter = String(describing: type(of: router))
        if router is ViewableRouting {
            currentRouter += " (View) "
        }
        if router.children.isEmpty {
            return ["name": currentRouter, "children": []]
        } else {
            return ["name": currentRouter, "children": router.children.map { tree(router: $0, appendImage: appendImage) }]
        }
    }

    private func takeBase64Capture(targetRouter: String) -> String? {
        guard let router = findRouter(target: targetRouter, router: router) as? ViewableRouting,
            let view = router.viewControllable.uiviewController.view,
            let captureImage = image(with: view) else {
                return nil
        }
        return captureImage.pngData()?.base64EncodedString()
    }

    private func findRouter(target: String, router: Routing) -> Routing? {
        let currentRouter = String(describing: type(of: router))
        if target == currentRouter {
            return router
        } else if !router.children.isEmpty {
            return router.children.compactMap { findRouter(target: target, router: $0) }.first
        } else {
            return nil
        }
    }

    private func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}

final class SocketClient {

    static let `default` = SocketClient()

    let manager: SocketManager
    let socket: SocketIOClient
    private var isConnected: Bool = false

    init() {
        self.manager = SocketManager(socketURL: URL(string: "http://localhost:8000")!, config: [.log(false), .compress])
        self.socket = manager.socket(forNamespace: "/ribs")
        self.socket.on(clientEvent: .connect) {_, _ in
            print("socket connected")
            self.isConnected = true
        }
        self.socket.connect()
    }

    func send(tree: [String: Any]) {
        guard isConnected else {
            return
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tree)
            let jsonString = String(bytes: jsonData, encoding: .utf8)!
            socket.emit("tree_update", jsonString)
        } catch {
            print(error)
        }
    }
}
