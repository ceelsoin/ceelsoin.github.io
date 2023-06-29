setup:
	bundle install
run:
	rm -rf _site
	bundle exec jekyll serve --source . --watch --incremental --config ./_config.yml --host 0.0.0.0