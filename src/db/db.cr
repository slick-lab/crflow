require "sqlite3"

DB_File = ENV.fetch("DB_PATH", "/data/posts.db")

def db 
  @@db ||= DB.open "sqlite3://#{DB_FILE}"
end 

def create_tables
  db.exec <<-SQL
   CREATE TABLE IF NOT EXISTS posts (
     id INTEGER PRIMARY KEY,
     title TEXT NOT NULL,
     url TEXT NOT NULL,
     context TEXT NOT NULL,
     submitter_name TEXT NOT NULL,
     submitter_email TEXT NOT NULL,
     created_at TEXT NOT NULL
    )
  SQL
end 
  
