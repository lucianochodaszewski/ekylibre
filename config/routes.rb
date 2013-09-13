Ekylibre::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  # Checks and update locale filter
  filter :locale

  # No namespace because authentication is for all sides
  devise_for :users, :path => "authentication", :module => :authentication

  # Backend
  namespace :backend do

    resource :myself, :path => "me", :only => [:show]
    resource :settings, :only => [:edit, :update] do
      member do
        get :about
        get :backups
        post :backup
        post :restore
        match "import", :via => [:get, :post]
      end
    end

    # Permits to use dynamic dashboards
    # dashboards

    resource :dashboards, :only => [] do
      collection do
        for mod in [:relationship, :accountancy, :trade, :stocks, :production, :tools, :settings]
          get mod
        end
        get :list_my_future_events
        get :list_recent_events
        get :list_critic_stocks
        get :welcome
      end
    end

    resources :helps, :only => [:index, :show] do
      collection do
        post :toggle
      end
    end

    namespace :cells do
      resource :collected_taxes_cell, :only => :show
      resource :currents_stocks_by_product_nature_cell, :only => :show
      resource :cropping_plan_cell, :only => :show
      resource :cropping_plan_on_cultivable_land_parcels_cell, :only => :show
      resource :product_bar_cell, :only => :show
      resource :purchases_bar_cell, :only => :show
      resource :purchases_expense_bar_cell, :only => :show
      resource :placeholder_cell, :only => :show
      resource :production_cropping_plan_cell, :only => :show
      resource :revenus_by_product_nature_cell, :only => :show
      resource :rss_cell, :only => :show
      resource :last_entities_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :last_events_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :last_incoming_deliveries_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :last_outgoing_deliveries_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :last_procedures_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :bank_chart_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :expense_chart_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :last_milk_result_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :last_products_cell, :only => :show do
        get :list, :on => :collection
      end
      resource :calendar_cell, :only => :show do
        get :list, :on => :collection
      end
    end

    # resources :account_balances
    resources :accounts do
      collection do
        get :list
        get :list_journal_entry_items
        get :list_reconciliation
        get :list_entities
        get :reconciliation
        get :autocomplete_for_origin
        get :unroll
        match "load", :via => [:get, :post]
      end
      member do
        match "mark", :via => [:get, :post]
        post :unmark
      end
    end

    resources :activities do
      collection do
        get :list
        get :list_production
        get :unroll
      end
    end

    resources :aggregators, :only => [:index, :show]

    resources :analytic_repartitions do
      collection do
        get :list
        get :unroll
      end
    end
    resources :animal_groups do
      collection do
        get :list
        get :list_animals
        get :list_place
        get :unroll
      end
    end
    resources :animals do
      collection do
        get :list
        get :list_children
        get :list_place
        get :list_group
        get :list_incident
        get :list_indicator
        get :unroll
      end
      member do
        match "picture(/:style)", :via => :get, :action => :picture, :as => :picture
      end
    end
    resources :animal_medicines do
      collection do
        get :list
        get :unroll
      end
    end
    resources :affairs do
      collection do
        get :list
      end
      member do
        get :select
        post :attach
        delete :detach
      end
    end
    resources :areas do
      collection do
        get :list
        get :autocomplete_for_name
        get :unroll
      end
    end
    resources :assets, :path => "financial_assets" do
      collection do
        get :list
        get :unroll
      end
      member do
        get :cede
        get :sell
        post :depreciate
        get :list_depreciations
      end
    end
    # resources :asset_depreciations # , :except => [:index]
    resources :bank_statements do
      collection do
        get :list
        get :list_items
        get :unroll
      end
      member do
        match "point", :via => [:get, :post]
      end
    end

    resources :buildings do
      collection do
        get :list
        get :list_building_division
        get :unroll
      end
    end

    resources :building_divisions do
      collection do
        get :list
        get :list_content_product
        get :unroll
      end
    end

    resources :campaigns do
      collection do
        get :list
        get :unroll
      end
    end

    resources :cashes do
      collection do
        get :list
        get :list_deposits
        get :list_bank_statements
        get :unroll
      end
    end
    resources :cash_transfers do
      collection do
        get :list
        get :unroll
      end
    end


    resources :cultivable_land_parcels do
      collection do
        get :list
        get :list_content_products
        get :list_productions
        get :unroll
      end
    end

    # resources :cultivations
    # resources :currencies
    resources :custom_fields do
      collection do
        get :list
        get :list_choices
        get :unroll
      end
      member do
        post :up
        post :down
        post :sort
      end
    end
    resources :custom_field_choices do
      member do
        post :up
        post :down
      end
    end
    resources :teams do
      collection do
        get :list
        get :unroll
      end
    end
    resources :deposits do
      collection do
        get :list
        get :list_payments
        get :list_depositable_payments
        get :list_unvalidateds
        get :unroll
        match "unvalidateds", :via => [:get, :post]
      end
    end
    # resources :deposit_items
    resources :districts do
      collection do
        get :list
        get :unroll
      end
    end
    resources :document_archives
    resources :document_templates do
      collection do
        get :list
        post :load
        get :unroll
      end
    end
    resources :documents do
      member do
        get :list_archives
      end
      collection do
        get :list
        get :unroll
      end
    end
    resources :entities do
      collection do
        get :list
        get :list_observations
        get :list_subscriptions
        get :list_sales
        get :list_purchases
        get :list_outgoing_payments
        get :list_mandates
        get :list_incoming_payments
        get :list_meeting_participations
        get :list_addresses
        get :list_cashes
        get :list_links
        get :autocomplete_for_origin
        get :unroll
        match "import", :via => [:get, :post]
        match "export", :via => [:get, :post]
        match "merge", :via => [:get, :post]
      end
      member do
        match "picture(/:style)", :via => :get, :action => :picture, :as => :picture
      end
    end
    resources :entity_addresses, :except => [:index] do
      collection do
        get :unroll
      end
    end
    resources :entity_links, :except => [:index]
    # resources :entity_link_natures do
    #   collection do
    #     get :unroll
    #     get :list
    #   end
    # end
    # resources :entity_natures do
    #   collection do
    #     get :unroll
    #     get :list
    #   end
    # end
    resources :equipments do
      collection do
        get :list
        get :list_operations
        get :unroll
      end
    end
    resources :establishments do
      collection do
        get :list
        get :unroll
      end
    end
    resources :meetings do
      collection do
        get :list
        get :autocomplete_for_place
        get :change_minutes
        get :unroll
      end
    end
    resources :meeting_natures do
      collection do
        get :list
        get :unroll
      end
    end
    resources :financial_years do
      collection do
        get :list
        get :list_account_balances
        get :list_asset_depreciations
        get :unroll
      end
      member do
        match "close", :via => [:get, :post]
        match :generate_last_journal_entry, :via => [:get, :post]
        post :compute_balances
        get :synthesis
      end
    end
    resources :incidents do
      collection do
        get :list
        get :list_procedure
        get :unroll
      end
    end
    resources :incoming_deliveries do
      collection do
        get :list
        get :list_item
        get :unroll
      end
      member do
        match "confirm", :via => [:get, :post]
      end
    end
    resources :incoming_delivery_items, :only => [:new]
    resources :incoming_delivery_modes do
      collection do
        get :list
        get :unroll
      end
    end
    resources :incoming_payments do
      collection do
        get :list
        get :list_sales
        get :unroll
      end
    end
    resources :incoming_payment_modes do
      collection do
        get :list
        get :unroll
      end
      member do
        post :up
        post :down
        post :reflect
      end
    end
    resources :incoming_payment_uses
    resources :inventories do
      collection do
        get :list
        get :list_items
        get :list_items_create
        get :list_items_update
        get :unroll
      end
      member do
        match "reflect", :via => [:get, :post]
      end
    end
    # resources :inventory_items
    resources :journals do
      collection do
        match "draft", :via => [:get, :post]
        match "bookkeep", :via => [:get, :put, :post]
        match "import", :via => [:get, :post]
        get :reports
        get :balance
        get :general_ledger
        get :list
        get :list_draft_items
        get :list_mixed
        get :list_items
        get :list_entries
        get :list_general_ledger
        get :unroll
      end
      member do
        match "close", :via => [:get, :post]
        match "reopen", :via => [:get, :post]
      end
    end
    resources :journal_entries do
      collection do
        get :list_items
      end
    end
    resources :journal_entry_items, :only => [:new, :show] do
      collection do
        get :unroll
      end
    end
    resources :kujakus, :only => [] do
      member do
        post :toggle
      end
    end
    resources :land_parcel_clusters do
      collection do
        get :list
        get :unroll
      end
    end
    resources :land_parcel_groups do
      collection do
        get :list
        get :unroll
      end
    end
    resources :land_parcels do
      collection do
        get :list
        get :list_operations
        # post :merge
        get :unroll
      end
      # member do
      #   match "divide", :via => [:get, :post]
      # end
    end
    resources :legal_entities do
      member do
        match "picture(/:style)", :via => :get, :action => :picture, :as => :picture
      end
      collection do
        get :list
        get :unroll
      end
    end
    # resources :listing_node_items
    resources :listing_nodes
    resources :listings do
      collection do
        get :list
        get :unroll
      end
      member do
        get :extract
        post :duplicate
        match "mail", :via => [:get, :post]
      end
    end
    resources :logs do
      collection do
        get :list
        get :unroll
      end
    end
    resources :mandates do
      collection do
        get :list
        get :autocomplete_for_family
        get :autocomplete_for_organization
        get :autocomplete_for_title
        get :unroll
        match "configure", :via => [:get, :post]
      end
    end
    resources :matters do
      collection do
        get :list
        get :list_place
        get :list_group
        get :unroll
      end
      member do
        match "picture(/:style)", :via => :get, :action => :picture, :as => :picture
      end
    end
    resources :mineral_matters do
      collection do
        get :list
        get :unroll
      end
    end
    resources :observations
    resources :operations do
      collection do
        get :list
        get :list_items
        get :list_uses
        get :list_unvalidateds
        get :unroll
        match "unvalidateds", :via => [:get, :post]
      end
    end

    resources :organic_matters do
      collection do
        get :list
        get :unroll
      end
    end

    resources :operation_tasks do
      collection do
        get :list
        get :unroll
      end
    end

    resources :outgoing_deliveries do
      collection do
        get :list
        get :list_items
        get :unroll
      end
    end
    # resources :outgoing_delivery_items
    resources :outgoing_delivery_modes do
      collection do
        get :list
        get :unroll
      end
    end
    resources :outgoing_payments do
      collection do
        get :list
        get :list_purchases
        get :unroll
      end
    end
    resources :outgoing_payment_modes do
      collection do
        get :list
        get :unroll
      end
      member do
        post :up
        post :down
      end
    end
    resources :outgoing_payment_uses

    resources :people do
      member do
        match "picture(/:style)", :via => :get, :action => :picture, :as => :picture
      end
      collection do
        get :list
        get :unroll
      end
    end

    resources :plants do
      collection do
        get :list
        get :list_indicator
        get :list_incident
        get :list_place
        get :unroll
      end
    end
    resources :plant_medicines do
      collection do
        get :list
        get :unroll
      end
    end
    resources :preferences do
      collection do
        get :list
        get :unroll
      end
    end

    resources :prescriptions do
      collection do
        get :list
        get :unroll
      end
    end
    # resources :procedure_natures do
    #   collection do
    #     get :list
    #     get :unroll
    #   end
    # end

    resources :procedures do
      member do
        get :play
        post :play, :action => :jump, :as => :jump
      end
      collection do
        get :list
        get :list_variables
        get :list_operations
        get :unroll
      end
    end

    resources :products do
      collection do
        get :list
        get :list_content_product
        get :list_place
        get :list_group
        get :list_member
        get :list_indicator
        get :list_incident
        get :list_events
        get :list_children
        get :unroll
      end
    end

    resources :product_groups do
      collection do
        get :list
        get :list_content_product
        get :list_place
        get :list_group
        get :list_member
        get :list_indicator
        get :list_incident
        get :list_events
        get :list_children
        get :unroll
      end
    end

    # resources :product_indicator_choices do
    #   member do
    #     post :up
    #     post :down
    #   end
    # end

    resources :product_indicator_data do
      collection do
        get :list
        get :unroll
      end
    end

    resources :product_links do
      collection do
        get :list
        get :unroll
      end
    end

    resources :product_localizations do
      collection do
        get :list
        get :unroll
      end
    end

    resources :product_natures do
      collection do
        get :change_quantities
        get :list
        get :list_price_templates
        get :list_products
        get :list_product_moves
        get :unroll
      end
    end

    resources :product_nature_variants do
      collection do
        get :list
        get :list_products
        get :list_prices
        get :unroll
      end
    end

    resources :product_nature_variant_indicator_data do
      collection do
        get :list
        get :unroll
      end
    end

    resources :product_ownerships do
      collection do
        get :list
        unroll_all
      end
    end

    resources :catalogs do
      collection do
        get :unroll
        get :list
        get :list_prices
      end
    end

    resources :catalog_prices do
      collection do
        get :list
        get :unroll
      end
    end

    resources :product_processes do
      collection do
        get :list
        get :unroll
      end
    end

    resources :product_process_phases do
      collection do
        get :list
        get :unroll
      end
    end
    resources :productions do
      collection do
        get :list
        get :list_support
        get :list_procedure
        get :fertilization
        get :unroll
      end
    end

    resources :production_supports do
      collection do
        get :list
        get :unroll
      end
    end
    resources :professions do
      collection do
        get :list
        get :unroll
      end
    end
    resources :purchase_items, :except => [:index]
    resources :purchase_natures do
      collection do
        get :list
        get :unroll
      end
    end
    resources :purchases do
      collection do
        get :list
        get :list_items
        get :list_undelivered_items
        get :list_deliveries
        get :list_payment_uses
        get :unroll
      end
      member do
        post :correct
        post :propose
        post :invoice
        post :confirm
        post :abort
        post :refuse
      end
    end
    resources :roles do
      collection do
        get :list
        get :unroll
      end
    end
    resources :sale_items, :except => [:index] do
      collection do
        get :list
        get :detail
        get :unroll
      end
    end
    resources :sale_natures do
      collection do
        get :list
        get :unroll
      end
    end
    resources :sales do
      resources :items, :only => [:new, :create], :controller => :sale_items
      collection do
        get :list
        get :list_undelivered_items
        get :list_subscriptions
        get :list_payment_uses
        get :list_deliveries
        get :list_credits
        get :list_creditable_items
        get :statistics
        get :contacts
        get :unroll
      end
      member do
        get :list_items
        match "cancel", :via => [:get, :post]
        post :duplicate
        post :correct
        post :propose
        post :invoice
        post :confirm
        post :abort
        post :refuse
        post :propose_and_invoice
      end
    end
    resources :sequences do
      collection do
        get :list
        post :load
        get :unroll
      end
    end
    resources :services do
      collection do
        get :list
        get :unroll
      end
    end
    resources :settlements do
      collection do
        get :list
        get :unroll
      end
    end
    # resources :product_moves
    # resources :product_transfers do
    #   collection do
    #     get :list
    #     get :list_confirm
    #     get :unroll
    #     match "confirm_all", :via => [:get, :post]
    #   end
    #   member do
    #     match "confirm", :via => [:get, :post]
    #   end
    # end
    resources :snippets, :only => [] do
      member do
        post :toggle
      end
    end
    resources :subscription_natures do
      collection do
        get :list
        get :unroll
      end
      member do
        post :increment
        post :decrement
      end
    end
    resources :subscriptions do
      collection do
        get :list
        get :unroll
        get :coordinates
        get :message
      end
    end
    # resources :tax_declarations
    resources :taxes do
      collection do
        get :list
        get :unroll
      end
    end
    resources :trackings do
      collection do
        get :list_products
        get :list_sale_items
        get :list_purchase_items
        get :list_operation_items
        get :unroll
      end
    end
    # resources :tracking_states
    resources :transports do
      collection do
        get :list
        get :list_deliveries
        get :list_transportable_deliveries
        get :unroll
        # match "deliveries", :via => [:get, :post]
        # match "delivery_delete", :via => [:get, :post]
      end
    end
    # resources :transfers
    resources :users do
      collection do
        get :list
        get :unroll
      end
      member do
        post :lock
        post :unlock
      end
    end

    resources :workers do
      collection do
        get :list
        get :unroll
      end
    end

    get :search, :controller => :dashboards, :as => :search

    root :to => "dashboards#index"
  end

  root :to => "public#index"
end
