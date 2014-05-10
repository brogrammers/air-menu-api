require 'fileutils'
require 'json'

namespace :apipie do
  desc "Generate example responses"
  task :generate_examples => :environment do
    FileUtils.rm_rf('public/docs')
    Dir.glob('app/views/**/*').each do |file|
      match = file.match(/(create|index|show|update|destroy)/)
      if match
        action = match[0]
        path_nodes = file.split('/')
        2.times { path_nodes.shift }
        path_nodes.pop
        view_path = path_nodes.join '/'
        classified = path_nodes.last.classify
        MAPPER = {'AccessToken' => 'Doorkeeper::AccessToken', 'Application' => 'Doorkeeper::Application', 'Me' => 'User'}
        model_name = MAPPER[classified] ? MAPPER[classified].constantize : classified.constantize
        if action == 'index' && classified != 'Me'
          model = model_name.limit(3).all
        else
          model = model_name.all.first
        end
        FileUtils.mkdir_p(File.dirname("public/docs/#{view_path}/#{action}"))
        [:json, :xml].each do |format|
          view = Rabl::Renderer.send(format, model, "#{view_path}/#{action}", {:view_path => 'app/views', :locals => { :scopes => Doorkeeper::OAuth::Scopes.from_array(['trusted']) }})
          File.open("public/docs/#{view_path}/#{action}.#{format}", "w") { |file| file.write format == :json ? JSON.pretty_generate(JSON.load(view)) : view }
          puts "public/docs/#{view_path}/#{action}.#{format}"
        end
      end
    end
  end
end