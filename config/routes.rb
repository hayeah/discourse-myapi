MyApi::Engine.routes.draw do
  get "status" => "api#status"
  get "user" => "api#user"
end