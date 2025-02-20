require 'test_helper'

class SimpleBuilderTest < ActionView::TestCase

  Template = Class.new do
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
  end

  def setup
    @template = Template.new
  end

  def test_render_should_be_implemented
    assert_nothing_raised { simplebuilder(@template, []).render }
  end


  def test_render_with_0_elements
    assert_equal("", simplebuilder(@template, []).render)
  end

  def test_render_with_0_elements_and_separator
    assert_equal("", simplebuilder(@template, [], :separator => "-").render)
  end


  def test_render_with_1_element
    @template.expects(:current_page?).times(1).returns(false)
    assert_dom_equal("<a href=\"/element/1\">Element 1</a>",
                     simplebuilder(@template, generate_elements(1)).render)
  end

  def test_render_with_1_element_and_separator
    @template.expects(:current_page?).times(1).returns(false)
    assert_dom_equal("<a href=\"/element/1\">Element 1</a>",
                     simplebuilder(@template, generate_elements(1), :separator => "-").render)
  end

  def test_render_with_1_element_without_path
    elements = [BreadcrumbsOnRails::Breadcrumbs::Element.new("Element 1", nil)]
    @template.expects(:current_page?).times(0).returns(false)
    assert_dom_equal("Element 1",
                     simplebuilder(@template, elements).render)
  end

  def test_render
    @template.expects(:current_page?).times(2).returns(false)
    assert_dom_equal("<a href=\"/element/1\">Element 1</a> &raquo; <a href=\"/element/2\">Element 2</a>",
                     simplebuilder(@template, generate_elements(2)).render)
  end

  def test_render_with_separator
    @template.expects(:current_page?).times(2).returns(false)
    assert_dom_equal("<a href=\"/element/1\">Element 1</a> - <a href=\"/element/2\">Element 2</a>",
                     simplebuilder(@template, generate_elements(2), :separator => " - ").render)
  end

  def test_render_with_current_page
    @template.expects(:current_page?).times(2).returns(false, true)
    assert_dom_equal("<a href=\"/element/1\">Element 1</a> &raquo; Element 2",
                     simplebuilder(@template, generate_elements(2)).render)
  end

  def test_render_without_path
    elements = [
      BreadcrumbsOnRails::Breadcrumbs::Element.new("Element 1", "/element/1"),
      BreadcrumbsOnRails::Breadcrumbs::Element.new("Element 2", nil),
      BreadcrumbsOnRails::Breadcrumbs::Element.new("Element 3", nil)
    ]
    @template.expects(:current_page?).times(1).returns(false, true)
    assert_dom_equal("<a href=\"/element/1\">Element 1</a> &raquo; Element 2 &raquo; Element 3",
                     simplebuilder(@template, elements).render)
  end

  protected

    def simplebuilder(*args)
      BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder.new(*args)
    end

    def generate_elements(number)
      (1..number).collect do |index|
        BreadcrumbsOnRails::Breadcrumbs::Element.new("Element #{index}", "/element/#{index}")
      end
    end

end
