require "./db/db"

class Posts
   JSON.mapping(
    id : Int32?,
    title : String?,
    url : String?,
    context : String?,
    submitter_name : String?,
    submitter_email : String?,
    created_at : String?
  )
def initialize(
      @title : String,
      @url : String,
      @context : String,
      @submitter_name : String,
      @id : Int32,
      @submitter_email : String,
      @created_at : String
    )
  end 

  def save 
    result = db.exec(
      "INSERT INTO posts (title, url, context, submitter_name, submitter_email, created_at) VALUES (?, ?, ?, ?,  ?, datetime('now')), RETURNING id", title, url, context, submitter_name, submitter_email, created_at)
       @id = result.first
  end 

  def self.all
    rows = db.query_all "SELECT id, title, url, context, submitter_name, submitter_email, created_at FROM posts ORDER BY id DESC LIMIT 50"
    rows.map do |row|
      Posts.new(
        id: row[0].to_i,
        title: row[1].to_s,
        url: row[2].to_s,
        context: row[3].to_s,
        submitter_name: row[4].to_s,
        submitter_email: row[5].to_s,
        created_at: row[6].to_s
      )
    end 
  end 

  def self.find(id : Int32)
    row = db.query_one? "SELECT id, title, context, submitter_name, submitter_email, created_at FROM posts WHERE id = ?", id
    if row
     Posts.new(
        id: row[0].to_i,
        title: row[1].to_s,
        url: row[2].to_s,
        context: row[3].to_s,
        submitter_name: row[4].to_s,
        submitter_email: row[5].to_s,
        created_at: row[6].to_s
      )
   end
 end 

 def self.recent
  rows = db.query_all "SELECT id, title, url, context, submitter_name, created_at FROM posts ORDER BY id DESC LIMIT 50"
    rows.map do |row|
      {
        id: row[0].to_i,
        title: row[1].to_s,
        url: row[2].to_s,
        context: row[3].to_s,
        submitter_name: row[4].to_s,
        created_at: row[5].to_s
      }
    end 
 end 
end 
  


      
    
