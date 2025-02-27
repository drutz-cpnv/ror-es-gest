json.extract! status, :id, :title, :slug, :created_at, :updated_at
json.url status_url(status, format: :json)
