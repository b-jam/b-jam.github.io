run-docs: ## Run in development mode
	cd docs && hugo serve -D

docs: ## Build the site
	cd docs && hugo -t learn -d public --gc --minify --cleanDestinationDir
