require "kemal"
require "./db/db"
require "./posts"


create_tables


before_all do |env|
  env.response.headers["Access-Control-Allow-Origin"] = "*"
  env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
  env.response.headers["Access-Control-Allow-Headers"] = "Content-Type"
end

options "*" do |env|
  env.response.status_code = 200
  ""
end


get "/health" do
  {status: "ok"}.to_json
end

get "/post" do 
  post = Posts.recent
  post.to_json
end 

get "/posts/:id" do |env|
  id = env.params.url["id"].to_i
  post = Posts.find(id)
  if post
    post.to_json
 else 
  env.response.status_code = 404
  {
    error: "Post not found"
  }.to_json
 end 
end 

post "/posts" do |env|
 begin 
  data = JSON.parse(env.request.body.not_nil!.gets_to_end)
  title = data["title"]?.try(&.as_s) || "" 
  url = data["url"]?.try(&.as_s) || "" 
  context = data["context"]?.try(&.as_s) || ""
  submitter_name = data["submitter_name"]?.try(&.as_s) || "john"
  submitter_email = data["submitter_email"]?.try(&.as_s) || "john"
   if title.empty? || url.empty? || context.empty?
    env.response.status_code = 400
    return { error: "Title, url and context are required" }.to_json
  post = Posts.new(title, url, context, submitter_name, submitter_email) 
  post.save

  {
    status: "created",
    id: post.id
  }.to_json
 rescue e
  env.response.status_code = 400
  { error: "Invalid Json: #{e.message}" }.to_json
 end 
end 

Kemal.run
