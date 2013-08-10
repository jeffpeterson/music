Music::Application.routes.draw do
  mount JasmineRails::Engine => "/jasmine" if defined?(JasmineRails)
  root 'application#index'
end
