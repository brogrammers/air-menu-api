object @staff_kind => :staff_kind

attributes :id, :name

node :scopes do |staff_kind|
    partial('api/v1/restaurants/staff_kinds/_scope', :object => staff_kind.scopes)
end