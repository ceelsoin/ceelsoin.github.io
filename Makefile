clean: 
	rm -rf dist
	rm -rf _site
	rm -rf .sass-cache
setup: clean
	bundle install
build: clean
	bundle exec jekyll build --source . --destination ./dist
run: clean
	bundle exec jekyll serve --source . --watch --incremental --config ./_config.yml --host 0.0.0.0