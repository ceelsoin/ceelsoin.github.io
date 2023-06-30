clean: 
	rm -rf dist
	rm -rf _site
	rm -rf .sass-cache
	rm -f .jekyll-cache
	rm -f .jekyll-metadata
setup: clean
	bundle install
build: clean
	bundle exec jekyll build --source ./src --destination ./dist
run: clean
	bundle exec jekyll serve --source ./src --watch --incremental --config ./src/_config.yml --host 0.0.0.0