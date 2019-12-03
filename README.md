![](https://img.shields.io/github/license/srea/RIBsTreeViewerClient.svg) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
# RIBsTreeViewer

Real Time viewing attached RIBs Tree on Browser

# Carthage

## Cartfile

```shell
github "srea/RIBsTreeViewerClient"
```

## Build Phase

![](./docs/Carthage_BuildPhase.png)  
![](./docs/Carthage_Embedded.png)

Carthage CopyFrameworks (ONLY DEBUG)

```shell
 if [ ${CONFIGURATION%%-*} == "Debug" ]; then
    /usr/local/bin/carthage copy-frameworks
 fi
```

## Implementation

```swift
#if DEBUG
import RIBsTreeViewerClient
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    #if DEBUG
    private var ribsTreeViewer: RIBsTreeViewer?
    #endif

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        ... 

        launchRouter.launch(from: window)
        #if DEBUG
        startRIBsTreeViewer(launchRouter: launchRouter)
        #endif
        return true
    }

}

#if DEBUG
extension AppDelegate {
    private func startRIBsTreeViewer(launchRouter: Routing) {
        ribsTreeViewer = RIBsTreeViewer.init(router: launchRouter)
        ribsTreeViewer?.start()
    }
}
#endif
```

# WebSocket Server

```shell
$ yarn install
$ node index.js
```

# Browser

```shell
$ yarn install
$ npx webpack
$ open ./public/index.html
```

# Options

## .webSocketURL

```swift
        #if DEBUG
        if #available(iOS 13.0, *) {
            ribsTreeViewer = RIBsTreeViewerImpl.init(router: launchRouter,
                                                     option: [.webSocketURL: "ws://0.0.0.0:8080"])
            ribsTreeViewer?.start()
        }
        #endif
```
