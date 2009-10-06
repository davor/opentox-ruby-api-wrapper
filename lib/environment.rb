# set default environment
ENV['RACK_ENV'] = 'test' unless ENV['RACK_ENV']

# load configuration
basedir = File.join(ENV['HOME'], ".opentox")
config_dir = File.join(basedir, "config")
@@tmp_dir = File.join(basedir, "tmp")
config_file = File.join(config_dir, "#{ENV['RACK_ENV']}.yaml")

if File.exist?(config_file)
	@@config = YAML.load_file(config_file)
else
	FileUtils.mkdir_p config_dir
	FileUtils.mkdir_p @@tmp_dir
	FileUtils.cp(File.join(File.dirname(__FILE__), 'templates/config.yaml'), config_file)
	puts "Please edit #{config_file} and restart your application."
	exit
end

# configure redis database
begin
	case ENV['RACK_ENV']
	when 'production'
		@@redis = Redis.new :db => 0
	when 'development'
		@@redis = Redis.new :db => 1
	when 'test'
		@@redis = Redis.new :db => 2
		@@redis.flush_db
	end
rescue
	puts "Redis database not running, please start it with 'rake redis:start'."
end