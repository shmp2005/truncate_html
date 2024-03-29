require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe TruncateHtml::HtmlString do

  def html_string(original_string)
    TruncateHtml::HtmlString.new(original_string)
  end

  describe '#html_tokens' do
    it 'returns each token in the string as an array element removing any consecutive whitespace from the string' do
      html = '<h1>Hi there</h1> <p>This          is sweet!</p>'
      html_string(html).html_tokens.should == ['<h1>', 'Hi', ' ', 'there', '</h1>', ' ', '<p>', 'This', ' ', 'is', ' ', 'sweet!', '</p>']
    end
  end

  describe '#html_tag?' do
    it 'returns false when the string parameter is not an html tag' do
      html_string('no tags').should_not be_html_tag
    end

    it 'returns true when the string parameter is an html tag' do
      html_string('<img src="foo">').should be_html_tag
      html_string('</img>').should be_html_tag
    end
  end

  describe '#open_tag?' do
    it 'returns true if the tag is an open tag' do
      html_string('<a>').should be_open_tag
    end

    context 'the tag is an open tag, and has whitespace and html properties' do
      it 'returns true if it has single quotes' do
        html_string(" <a href='http://awesomeful.net' >").should be_open_tag
      end

      it 'returns true if it has double quotes' do
        html_string(' <a href="http://awesomeful.net">').should be_open_tag
      end
    end

    it 'returns false if the tag is a close tag' do
      html_string('</a>').should_not be_open_tag
    end

    it 'returns false if the string is not an html tag' do
      html_string('foo bar').should_not be_open_tag
    end

    it 'returns false if it is a <script> tag' do
      html_string('<script>').should_not be_open_tag
    end
  end

  describe '#matching_close_tag' do
    tag_pairs = { '<a>'            => '</a>',
                  ' <div>'         => '</div>',
                  '<h1>'           => '</h1>',
                  '<a href="foo">' => '</a>' }

    tag_pairs.each do |open_tag, close_tag|
      it "closes a #{open_tag} and returns #{close_tag}" do
        html_string(open_tag).matching_close_tag.should == close_tag
      end
    end
  end

  describe '#pure_html_tag?' do
    it 'returns false if it is <ol>i am content</ol>' do
      html_string('<ol>i am content</ol>').pure_html_tag?.should be_false
    end

    it 'return true if it is <html />' do
      html_string('<html />').pure_html_tag?.should be_true
    end

    it 'return true if it is <ul></ul>' do
      html_string('<ul></ul>').pure_html_tag?.should be_true
    end

    it 'return true if it is <ul>\r\n<li></li>\r\n</ul>' do
      html_string("<ul>\r\n<li></li>\r\n</ul>").pure_html_tag?.should be_true
    end
  end
end
