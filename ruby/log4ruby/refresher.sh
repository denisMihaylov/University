gem build log4ruby.gemspec
gem install ./Log4Ruby-0.0.0.gem
find . -name '*.rb' | xargs wc -l
