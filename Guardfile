
guard :bundler do
  watch('Gemfile')
end

guard :shell do
  watch(%r{^(.+)\.(xslt|xml|css)}) do |m|
    `rake`
  end
end

guard :livereload do
  watch(%r{^(.+)\.html})
end
