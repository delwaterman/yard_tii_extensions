# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{yard_tii_extensions}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Orion Delwaterman}]
  s.date = %q{2011-12-22}
  s.description = %q{    Set of extensions for YARD documentation tool commonly used by Time Inc. This includes routes
    url params, response formats, and modifications that is used to build documentation for 
    other Time Inc Developers to use our standard JSON services.
}
  s.email = %q{orion_delwaterman@timeinc.com}
  s.executables = [%q{time_yardoc_setup}]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/time_yardoc_setup",
    "lib/tasks/yard_tii_extensions.rake",
    "lib/yard_tii_extensions.rb",
    "lib/yard_tii_extensions/active_record_attribute.rb",
    "lib/yard_tii_extensions/doc_config.rb",
    "lib/yard_tii_extensions/extension_loader.rb",
    "lib/yard_tii_extensions/filters.rb",
    "lib/yard_tii_extensions/handlers/accepts_nested_attributes_handler.rb",
    "lib/yard_tii_extensions/handlers/attr_accessible_handler.rb",
    "lib/yard_tii_extensions/handlers/attr_accessor_handler.rb",
    "lib/yard_tii_extensions/handlers/attr_protected_handler.rb",
    "lib/yard_tii_extensions/handlers/before_filter_require_profile_handler.rb",
    "lib/yard_tii_extensions/handlers/class_statements_helper.rb",
    "lib/yard_tii_extensions/handlers/legacy/accepts_nested_attributes_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/attr_accessible_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/attr_accessor_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/attr_protected_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/before_filter_require_profile_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/liquid_handlers.rb",
    "lib/yard_tii_extensions/handlers/legacy/super_serialize_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/validate_acceptance_of_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/validate_confirmation_of_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/validate_presence_of_handler.rb",
    "lib/yard_tii_extensions/handlers/legacy/validator_handler_helper.rb",
    "lib/yard_tii_extensions/handlers/register_filter_handler.rb",
    "lib/yard_tii_extensions/handlers/register_tag_handler.rb",
    "lib/yard_tii_extensions/handlers/super_serialize_handler.rb",
    "lib/yard_tii_extensions/handlers/validate_acceptance_of_handler.rb",
    "lib/yard_tii_extensions/handlers/validate_confirmation_of_handler.rb",
    "lib/yard_tii_extensions/handlers/validate_presence_of_handler.rb",
    "lib/yard_tii_extensions/liquid_customization_md_generator.rb",
    "lib/yard_tii_extensions/match_and_print.rb",
    "lib/yard_tii_extensions/rails_2/route_descriptor_builder.rb",
    "lib/yard_tii_extensions/rails_3/route_descriptor_builder.rb",
    "lib/yard_tii_extensions/railtie.rb",
    "lib/yard_tii_extensions/route_descriptor.rb",
    "lib/yard_tii_extensions/routes_md_generator.rb",
    "lib/yard_tii_extensions/url_parameter_tag.rb",
    "lib/yard_tii_extensions/yard_override.rb",
    "lib/yard_tii_extensions/yard_routes_engine.rb",
    "templates/default/class/html/attr_accessible_summary.erb",
    "templates/default/class/setup.rb",
    "templates/default/fulldoc/html/css/common.css",
    "templates/default/method_details/html/method_signature.erb",
    "templates/default/method_details/setup.rb",
    "templates/default/tags/html/dummy.txt",
    "templates/default/tags/html/url_param.erb",
    "templates/default/tags/setup.rb",
    "templates/json_api/fulldoc/js/setup.rb",
    "templates/json_api/fulldoc/js/whitelabel_api.erb",
    "templates/liquid/LiquidCustomization.md.erb",
    "templates/routes_md_generator/routes.md.erb",
    "test/helper.rb",
    "test/test_yard-tii-extensions.rb",
    "yard_tii_extensions.gemspec"
  ]
  s.homepage = %q{http://github.com/delwaterman/yard_tii_extensions}
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Set of extensions for YARD documentation tool commonly used by Time Inc.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<yard>, ["~> 0.7.4"])
      s.add_runtime_dependency(%q<bluecloth>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<yard>, ["~> 0.7.4"])
      s.add_dependency(%q<bluecloth>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<yard>, ["~> 0.7.4"])
    s.add_dependency(%q<bluecloth>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

