Rails.application.routes.draw do

  post '/account/set_arthist/create' => "arthist#create"
  post '/account/set_arthist/:id' => "arthist#update"
  get '/account/set_arthist/delete' => "arthist#delete"

  get '/result' => "home#result"
  get '/new_account' => "home#new_account"
  get '/start' => "home#start"
  get '/login' => "home#login"
  get '/account/set_arthist' => "home#set_arthist"
  get '/account/update_arthist' => "home#update_arthist"
  get '/account' => "home#account"

  post "/home/create" => "home#create"
  post "/home/login_check" => "home#login_check"
  post '/sign_out' => "home#sign_out"

  get '/show' => "arthist#show_db"

  get '/set_warning/:id' => "home#set_warning"

  get '/' => "home#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
