module ActiveNavTabsHelper
  def current_tab
    @current_tab || controller.controller_name
  end
  
  def stylesheet_include_css_nav_tabs
    unless @active_tab_background.nil?
tabs = %Q{<style type=\"text/css\" media=\"screen\">
  #{@tab_list.map {|t| "##{t[:id].to_s} ##{t[:id].to_s}Nav" }.join(', ')} {
    background-color: ##{@active_tab_background.gsub(/#/, '').to_s};
  }
</style>
}
    end
    if @reset_to_horizontal
style = %Q{<style type=\"text/css\" media=\"screen\">
  ul.nav-bar {
    margin: 0;
    padding: 0;
    list-style-type: none; }
    ul.nav-bar li {
      margin: 0;
      padding: 0;
      display: inline; }
</style>}
    end
    "#{tabs}#{style}"
  end
  
  # expects @tab_list as an array of hashes:
  #   [{:id => 'id', :path => '/path', :text => 'Text'}, ...]
  # * if :path is ommitted, it is derived from the id by adding a leading '/'
  # * if :text is ommitted, the id is capitalized and used
  def nav_bar(opts = {})
    return unless @tab_list && @tab_list.is_a?(Array) && @tab_list.first.is_a?(Hash)
    opts = {:class => "nav-bar"}.merge(opts)
    "<ul class=\"#{opts[:class]}\">" +
      @tab_list.map do |t|
        "<li>
          <a id=\"#{t[:id].to_s}Nav\" href=\"#{t[:path].to_s.blank? ? ('/' + t[:id].to_s) : t[:path].to_s}\">#{(t[:text] || t[:id]).to_s.capitalize}</a>
        </li>"
      end.join('') +
    '</ul>'
  end
end
