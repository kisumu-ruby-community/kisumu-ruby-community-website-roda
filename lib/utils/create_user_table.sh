DB.create_table? :users do
  primary_key :id
  String :name
  String :email, unique: true, null: false
  String :password_digest
  DateTime :created_at
end