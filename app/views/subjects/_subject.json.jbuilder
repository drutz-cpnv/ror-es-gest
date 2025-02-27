json.extract! subject, :id, :slug, :name, :created_at, :updated_at
json.url subject_url(subject, format: :json)
