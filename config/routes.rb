Rails.application.routes.draw do
  get "home/index"
  root "home#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  devise_scope :user do
    post 'send_otp', to: 'users/sessions#send_otp', as: :send_otp
    get 'verify_otp', to: 'users/sessions#verify_otp_form', as: :otp_verify
    post 'verify_otp', to: 'users/sessions#verify_otp'
  end
end