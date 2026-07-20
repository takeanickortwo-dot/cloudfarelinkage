# Link Hub — One-letter commands
.PHONY: deploy generate dev setup preview status

d: deploy
deploy:
	@bash deploy.sh

g: generate
generate:
	@bash generate.sh

v: dev
dev:
	@npx wrangler dev

s: setup
setup:
	@npm install -g wrangler && wrangler login

p: preview
preview:
	@npx serve dist

st: status
status:
	@wrangler whoami

help:
	@echo "Commands: d (deploy), g (generate), v (dev), s (setup), p (preview), st (status)"
