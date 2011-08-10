#require 'hammertime'

def init
  super
  sections.place([:attr_accessible_summary, [:item_summary]]).after(:attribute_summary)
end

def accessible_attributes
  return [] unless object['active_record_attributes'].try(:accessible_attributes)
  object['active_record_attributes'].accessible_attributes.collect do |attr|
    [attr, P(object, "##{attr}")]
  end.sort_by{|obj| obj.first.name}
end