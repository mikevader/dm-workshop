
guard :bundler do
  notification :terminal_notifier
  watch('Gemfile')
end

guard :shell do
  notification :terminal_notifier
  watch(%r{^(.+)\.(xsl|xml|css)}) do |m|
    `rake`
  end
end

guard :livereload do
  watch(%r{^(.+)\.html})
end
