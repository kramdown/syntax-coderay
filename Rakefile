# -*- ruby -*-

require 'rubygems/package_task'
require 'fileutils'
require 'rake/clean'
require 'rake/testtask'
require_relative 'lib/kramdown/converter/syntax_highlighter/coderay'

task :default => :test
Rake::TestTask.new do |test|
  test.warning = false
  test.libs << 'test'
  test.test_files = FileList['test/test_*.rb']
end

SUMMARY = 'kramdown-syntax-coderay uses coderay to highlight code blocks/spans'

PKG_FILES = FileList.new(['COPYING', 'VERSION', 'CONTRIBUTERS', 'lib/**/*.rb', 'test/**/*'])

CLOBBER << "VERSION"
file 'VERSION' do
  puts "Generating VERSION file"
  File.open('VERSION', 'w+') {|file| file.write(Kramdown::Converter::SyntaxHighlighter::Coderay::VERSION + "\n")}
end

CLOBBER << 'CONTRIBUTERS'
file 'CONTRIBUTERS' do
  puts "Generating CONTRIBUTERS file"
  `echo "  Count Name" > CONTRIBUTERS`
  `echo "======= ====" >> CONTRIBUTERS`
  `git log | grep ^Author: | sed 's/^Author: //' | sort | uniq -c | sort -nr >> CONTRIBUTERS`
end

spec = Gem::Specification.new do |s|
  s.name = 'kramdown-syntax-coderay'
  s.version = Kramdown::Converter::SyntaxHighlighter::Coderay::VERSION
  s.summary = SUMMARY
  s.license = 'MIT'

  s.files = PKG_FILES.to_a

  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.3'
  s.add_dependency 'kramdown', '~> 2.0'
  s.add_dependency 'coderay', '~> 1.0.0'

  s.has_rdoc = true

  s.author = 'Thomas Leitner'
  s.email = 't_leitner@gmx.at'
  s.homepage = "https://github.com/kramdown/syntax-coderay"
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

task :gemspec => ['CONTRIBUTERS', 'VERSION'] do
  print "Generating Gemspec\n"
  contents = spec.to_ruby
  File.write("kramdown-syntax-coderay.gemspec", contents, mode: 'w+')
end
CLOBBER << 'kramdown-syntax-coderay.gemspec'

desc 'Release version ' + Kramdown::Converter::SyntaxHighlighter::Coderay::VERSION
task :release => [:clobber, :package, :publish_files]

desc "Upload the release to Rubygems"
task :publish_files => [:package] do
  sh "gem push pkg/kramdown-syntax-coderay-#{Kramdown::Converter::SyntaxHighlighter::Coderay::VERSION}.gem"
  puts 'done'
end
