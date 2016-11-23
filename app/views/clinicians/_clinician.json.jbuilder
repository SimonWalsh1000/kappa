json.extract! clinician, :id, :name, :email, :country, :society, :general, :specialty, :created_at, :updated_at
json.url clinician_url(clinician, format: :json)