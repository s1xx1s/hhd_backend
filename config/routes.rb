Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # 富文本上传路由
  mount RedactorRails::Engine => '/redactor_rails'
  
  get 'app/download' => 'home#download'
  get 'app/install'  => 'home#install'
  
  # 网页文档
  resources :pages, path: :p, only: [:show]
  
  # 获取二维码图片
  # /qrcode?text=http://www.baidu.com
  get 'qrcode' => 'home#qrcode', as: :qrcode
  
  # /redpack?id=3848484
  get 'redpack' => 'home#redpack', as: :redpack
  get 'hb_test' => 'home#qrcode_test'
  
  # 队列后台管理
  require 'sidekiq/web'
  authenticate :admin_user do
    mount Sidekiq::Web => 'sidekiq'
  end
  
  # # API 文档
  mount GrapeSwaggerRails::Engine => '/apidoc'
  # #
  # # API 路由
  mount API::Dispatch => '/api'
  
  match '*path', to: 'home#error_404', via: :all
end
