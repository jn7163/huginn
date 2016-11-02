class AddTemplatesToResolveUrl < ActiveRecord::Migration[5.0]
  def up
    Agents::WebsiteAgent.find_each do |agent|
      keys = agent.event_keys
      next if keys.nil? || !keys.include?('url') || agent.options.key?('template')
      agent.options['template'] = keys.each_with_object({}) { |key, template|
        case key
        when 'url'
          template[key] = '{{ url | to_uri: _response_.url }}'
        else
          template[key] = "{{ #{key} }}"
        end
      }
      agent.save!(validate: false)
    end
  end

  def down
    # We can't go back before the introduction of `template` anyway.
  end
end
