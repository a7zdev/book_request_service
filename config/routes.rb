Rails.application.routes.draw do
  post '/request' => 'requests#create'
  get '/request' => 'requests#all'
  get '/request/:id' => 'requests#find_by_book_id'
  delete '/request/:id' => 'requests#delete_by_book_id'
  get '/books' => 'books#all'
end
