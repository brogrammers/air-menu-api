module Api
  module V1
    module BaseHelper

      Dir.glob(Rails.root + 'app/models/*.rb') do |rb_file|
        name = rb_file.split('/').last.split('.').first
        eval <<-eos
        def set_#{name}

        end
        eos
      end

    end
  end
end