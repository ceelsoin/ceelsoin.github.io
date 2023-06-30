source "https://rubygems.org"

gem "jekyll"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.6"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.0", :install_if => Gem.win_platform?
gem 'jekyll-dash', '~> 1'

gem "liquid-md5"
gem "jekyll-tagging"
gem "kramdown-parser-gfm"

#new plugins
gem 'jekyll-seo-tag'
gem 'jekyll-sitemap'
gem 'liquid_pluralize'
gem 'liquid_reading_time'
gem 'jekyll-gist'
