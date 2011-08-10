def init
  super
  sections.last.place(:drop).before(:return)
  sections.last.place(:format).before(:return)
  sections.last.place(:url_param).before(:param)
  sections.last.place(:query_string).before(:param)
end

def drop
  tag :drop
end

def url_param
  return unless object.has_tag?('url_param')
  @name = 'url_param'
  erb('url_param')
end

def format
  tag :format
end

def query_string
  tag :query_string
end