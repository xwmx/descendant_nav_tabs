# ActiveNavTabs
module ActiveNavTabs
  module ClassMethods
    
    # Use ad a before_filter to define the the tab list.
    # Options:
    #   :tabs => takes an array in this format:
    #     [{:id => 'id', :path => '/path', :text => 'Text'}, ...]
    #     * if :path is ommitted, it is derived from the id by adding a leading '/'
    #     * if :text is ommitted, the id is capitalized and used
    #   :active_tab_background => takes a hex color value
    def active_nav_tabs(options = {})
      proc = lambda do |c|
          c.instance_variable_set(:@tab_list, (options.delete(:tabs) || nil))
          c.instance_variable_set(:@active_tab_background, (options.delete(:active_tab_background) || nil))
          c.instance_variable_set(:@reset_to_horizontal, (options.delete(:reset_to_horizontal) || false))
      end
      before_filter(proc, options)
    end
    
  end

  module InstanceMethods
    
    def render_with_tabs(*args)
      set_current_tab
      render_without_tabs(*args)
    end
    
  protected
    
    # Override in controller to customize when a tab is displayed.
    def current_tab
      controller_name
    end

    def set_current_tab
      @current_tab ||= current_tab
    end
  end
  
  
  def self.included(base)
    base.extend ClassMethods
    base.helper ActiveNavTabsHelper
    base.class_eval do
      include InstanceMethods
      alias_method_chain :render, :tabs
    end
  end
  
end 