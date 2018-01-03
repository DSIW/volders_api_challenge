# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb') { "spec" }

  watch(%r{^apps/(.+)\.rb$}) do |m|
    [
      "spec/unit/apps/#{m[1]}_spec.rb",
      "spec/integration/apps/#{m[1]}_spec.rb"
    ]
  end

  watch(%r{^lib/(.+)\.rb$}) do |m|
    [
      "spec/unit/lib/#{m[1]}_spec.rb",
      "spec/integration/lib/#{m[1]}_spec.rb"
    ]
  end

  # shared examples
  watch(
    %r{^(#{Regexp.escape(rspec.spec_dir)}/.+)/shared_examples/.+\.rb$}
  ) { |m| m[1] }
end

cucumber_options = {
  # Below are examples overriding defaults

  # cmd: 'bin/cucumber',
  # cmd_additional_args: '--profile guard',

  # all_after_pass: false,
  # all_on_start: false,
  # keep_failed: false,
  # feature_sets: ['features/frontend', 'features/experimental'],

  # run_all: { cmd_additional_args: '--profile guard_all' },
  # focus_on: { 'wip' }, # @wip
  notification: false
}

guard "cucumber", cucumber_options do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$}) { "features" }

  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || "features"
  end
end
