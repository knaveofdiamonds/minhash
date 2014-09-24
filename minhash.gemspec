Gem::Specification.new do |s|
  s.name = "minhash"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Roland Swingler"]
  s.date = "2014-09-24"
  s.description = "Minhash algorithm implementation"
  s.email = "roland.swingler@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "lib/minhash.rb",
    "spec/minhash_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/knaveofdiamonds/minhash"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Minhash algorithm implementation in ruby"

  s.add_runtime_dependency(%q<murmurhash3>, ["~> 0"])
  s.add_development_dependency(%q<bundler>, ["~> 1"])
end

