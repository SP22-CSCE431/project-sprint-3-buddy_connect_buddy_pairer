json.extract! post, :id, :postId, :posterId, :postDate, :title, :body, :created_at, :updated_at
json.url post_url(post, format: :json)