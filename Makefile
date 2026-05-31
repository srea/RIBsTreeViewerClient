.PHONY: help
.DEFAULT_GOAL := help
 
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

CARTHAGE_BUILD_FLAGS = --platform iOS --no-use-binaries --use-xcframeworks

setup: ## Fetch and build Carthage dependencies (RIBs, RxSwift).
	carthage update --platform iOS --no-build
	@./scripts/patch_carthage_checkouts.sh
	carthage build $(CARTHAGE_BUILD_FLAGS) RxSwift RxRelay
	carthage build $(CARTHAGE_BUILD_FLAGS) RIBs

setup-ci: ## Carthage bootstrap for CI (uses Cartfile.resolved).
	carthage bootstrap --platform iOS --no-build --cache-builds
	@./scripts/patch_carthage_checkouts.sh
	carthage build $(CARTHAGE_BUILD_FLAGS) --cache-builds RxSwift RxRelay
	carthage build $(CARTHAGE_BUILD_FLAGS) --cache-builds RIBs

generate_xcframeworks: ## Generate XCFrameworks.
	@./scripts/generate_xcframeworks.sh

websocket-server: ## Start the WebSocket relay (port 8080).
	@cd WebSocketServer && npm install && npm start

browser-build: ## Build the browser viewer bundle.
	@cd Browser && yarn install && yarn build
