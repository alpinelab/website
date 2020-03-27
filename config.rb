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
    "https://www.gravatar.com/avatar/#{hash}?size=128"
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

# FIXME:
# Tried to activate old-style extension: rouge_syntax. They are no longer
# supported. (RuntimeError)
# activate :rouge_syntax

# Use relative URLs
# activate :relative_assets

# Add asset fingerprinting to avoid cache issues
activate :asset_hash

# Enable Autoprefixer for large browser support of CSS
activate :autoprefixer

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

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Create a whole bunch of favicons for various devices and OSes
  activate :favicon_maker, icons: {
    "images/logo-alpinelab-500.png" => [
      { icon: "apple-touch-icon-180x180-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for iPhone 6 Plus with @3× display
      { icon: "apple-touch-icon-152x152-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS7.
      { icon: "apple-touch-icon-144x144-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS6 or prior.
      { icon: "apple-touch-icon-120x120-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS7.
      { icon: "apple-touch-icon-114x114-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS6 or prior.
      { icon: "apple-touch-icon-76x76-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS7.
      { icon: "apple-touch-icon-72x72-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS6 or prior.
      { icon: "apple-touch-icon-60x60-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPhone with iOS7.
      { icon: "apple-touch-icon-57x57-precomposed.png" },               # iPhone and iPad users can turn web pages into icons on their home screen. Such link appears as a regular iOS native application. When this happens, the device looks for a specific picture. The 57x57 resolution is convenient for non-retina iPhone with iOS6 or prior. Learn more in Apple docs.
      { icon: "apple-touch-icon-precomposed.png", size: "57x57" },      # Same as apple-touch-icon.png, expect that is already have rounded corners (but neither drop shadow nor gloss effect).
      { icon: "apple-touch-icon.png", size: "57x57" },                  # Same as apple-touch-icon-57x57.png, for "default" requests, as some devices may look for this specific file. This picture may save some 404 errors in your HTTP logs. See Apple docs
      { icon: "favicon-196x196.png" },                                  # For Android Chrome M31+.
      { icon: "favicon-160x160.png" },                                  # For Opera Speed Dial (up to Opera 12; this icon is deprecated starting from Opera 15), although the optimal icon is not square but rather 256x160. If Opera is a major platform for you, you should create this icon yourself.
      { icon: "favicon-96x96.png" },                                    # For Google TV.
      { icon: "favicon-32x32.png" },                                    # For Safari on Mac OS.
      { icon: "favicon-16x16.png" },                                    # The classic favicon, displayed in the tabs.
      { icon: "favicon.png", size: "16x16" },                           # The classic favicon, displayed in the tabs.
      { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },         # Used by IE, and also by some other browsers if we are not careful.
      { icon: "mstile-70x70.png", size: "70x70" },                      # For Windows 8 / IE11.
      { icon: "mstile-144x144.png", size: "144x144" },
      { icon: "mstile-150x150.png", size: "150x150" },
      { icon: "mstile-310x310.png", size: "310x310" },
      { icon: "mstile-310x150.png", size: "310x150" },
    ]
  }

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

activate :i18n, mount_at_root: :fr

require '.localeapp/config'
