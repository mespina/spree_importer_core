Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    scope 'importers/:importer_id' do
      resources :imports, only: [:index, :show, :new, :create] do
        collection do
          get :template
        end
      end
    end
  end
end
