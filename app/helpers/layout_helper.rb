# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  # Set the html title tag as well as the page-header section.
  # This should be used on as many pages as possible.
  # If you want to use HTML, it is recommended that pass in the page_title
  # as well as the block. The page_title should be free of HTML (see example 3)
  #
  # page_title - The string to put in the title and page-header.
  # show_title - Specify whether to render the page-header or not.
  # &block     - When you have HTML you'd like in the page-header,
  #              you can specify it in the block just like Rails'
  #              link_to helper.
  #
  # Example 1
  #
  #   title 'Bugs'
  #   # => <title>Bugs</title>
  #        <div class="page-header">
  #          <h1>Bugs</h1>
  #        </div>
  #
  # Example 2
  #
  #   title 'Bugs', false
  #   # => <title>Bugs</title>
  #
  # Example 3
  #
  #   title 'Bugs' do
  #     Bugs
  #     <div id="complicated-html">
  #       <a href="#">url somewhere</a>
  #       ... lots of content/html
  #     </div>
  #   end
  #   # => <title>Bugs</title>
  #        <div class="page-header">
  #          <h1>
  #            Bugs
  #            <div id="complicated-html">
  #              <a href="#">url somewhere</a>
  #             ... lots of content/html
  #            </div>
  #          </h1>
  #        </div>
  def title(page_title, show_title = true, &block)
    if block_given?
      content_for(:page_header) { capture(&block).html_safe }
    else
      content_for(:page_header) { page_title.html_safe }
    end

    content_for(:page_title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def subtitle(title)
    content_for(:subtitle) { h(title.to_s) }
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end

