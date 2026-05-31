.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

verify: ## Run full usability checks (./scripts/verify.sh).
	@./scripts/verify.sh

generate_xcframeworks: ## Regenerate Products/RIBsTreeViewerClient.xcframework (SPM deps).
	@./scripts/generate_xcframeworks.sh

websocket-server: ## Start the WebSocket relay (port 8080).
	@cd WebSocketServer && npm install && npm start

browser-build: ## Build the browser viewer bundle.
	@cd Browser && yarn install && yarn build
