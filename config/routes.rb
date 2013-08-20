Music::Application.routes.draw do
  mount Konacha::Engine => '/konacha' unless Rails.env.production?
  # mount MochaRails::Engine => 'mocha' unless Rails.env.production?
  # mount JasmineRails::Engine => "/jasmine" if defined?(JasmineRails)
  root 'application#index'
end
