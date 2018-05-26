# require 'rest-client'
module API
  module V1
    class CatalogsAPI < Grape::API
      
      resource :catalogs, desc: '分类接口' do
        desc '获取分类'
        get do
          @catalogs = Catalog.where(opened: true).order('sort asc, id desc')
          render_json(@catalogs, API::V1::Entities::Catalog)
        end # end get /
      end # end resource

    end # end class
  end
end