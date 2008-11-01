# ActiveNavTabs
module ActiveNavTabs
  module ClassMethods
    
    # Use as a before_filter to define the the tab list.
    # Options:
    #   :nav_tabs => takes an array in this format:
    #     [{:id => 'id', :path => '/path', :text => 'Text'}, ...]
    #     * if :path is ommitted, it is derived from the id by adding a leading '/'
    #     * if :text is ommitted, the id is capitalized and used
    #   :active_tab_background => takes a hex color value
    def active_nav_tabs(args, &block)
      if args.is_a?(Symbol)
        before_filter(args, &block)
      else
        block ||= lambda do |c|
            c.nav_tabs              = args[:nav_tabs] || args[:tabs]
            c.active_tab_background = args[:active_tab_background]
            c.reset_to_horizontal   = args[:reset_to_horizontal]
        end
        before_filter(block)
      end
    end
    
  end

  module InstanceMethods
    
    attr_accessor :nav_tabs, :active_tab_background, :reset_to_horizontal
    
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