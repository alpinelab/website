###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

page '/sitemap.xml', :layout => false, :format => :xhtml

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

activate :blog do |blog|
  blog.prefix = 'blog'
  blog.permalink = ':title'
  blog.default_extension = '.md'
  blog.layout = 'blogpost.html.haml'
  blog.paginate = true
  blog.tag_template = 'blog/tag.html'
  blog.taglink = '/tags/:tag.html'
end

# Directory Indexes
activate :directory_indexes

Time.zone = 'Paris'

# Methods defined in the helpers block are available in templates
helpers do
  def gravatar_for(email)
    hash = Digest::MD5.hexdigest(email.chomp.downcase)
    "http://www.gravatar.com/avatar/#{hash}?size=128"
  end

  def get_menu_labels(labels)
    labels.map do |label|
      [label, I18n.t("corporate.#{label}.title")]
    end.to_h
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :markdown_engine, :redcarpet
set :markdown,
  fenced_code_blocks: true,
  autolink: true,
  smartypants: true,
  gh_blockcode: true,
  lax_spacing: true,
  with_toc_data: true

activate :rouge_syntax

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Minify HTML
  activate :minify_html

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  activate :relative_assets

  # Add asset fingerprinting to avoid cache issues
  activate :asset_hash

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Create a whole bunch of favicons for various devices and OSes
  activate :favicon_maker, icons: {
    'img/logo-alpinelab-500.png' => [
      { icon: 'apple-touch-icon-152x152-precomposed.png' },
      { icon: 'apple-touch-icon-144x144-precomposed.png' },
      { icon: 'apple-touch-icon-120x120-precomposed.png' },
      { icon: 'apple-touch-icon-114x114-precomposed.png' },
      { icon: 'apple-touch-icon-76x76-precomposed.png' },
      { icon: 'apple-touch-icon-72x72-precomposed.png' },
      { icon: 'apple-touch-icon-60x60-precomposed.png' },
      { icon: 'apple-touch-icon-57x57-precomposed.png' },
      { icon: 'apple-touch-icon-precomposed.png', size: '57x57' },
      { icon: 'apple-touch-icon.png', size: '57x57' },
      { icon: 'favicon-196x196.png' },
      { icon: 'favicon-160x160.png' },
      { icon: 'favicon-96x96.png' },
      { icon: 'favicon-32x32.png' },
      { icon: 'favicon-16x16.png' },
      { icon: 'favicon.png', size: '16x16' },
      { icon: 'favicon.ico', size: '64x64,32x32,24x24,16x16' },
      { icon: 'mstile-144x144', format: 'png' }
    ]
  }

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

configure :development do
 activate :livereload
end

activate :i18n, mount_at_root: :fr

require '.localeapp/config'
