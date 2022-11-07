# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Stores (#{Store.count})" do
          ul do
            Store.all.map do |store|
              li store.name
            end
          end
        end
      end

      column do
        panel "Shoe Models (#{ShoeModel.count})" do
          ul do
            ShoeModel.all.map do |shoe_model|
              li shoe_model.name
            end
          end
        end
      end

      column do
        panel 'Total Transactions' do
          para Transaction.count
        end
      end

      # select store, count(*) total from transactions group by store order by total desc ;
      column do
        panel 'Amount of transactions by store' do
          ul do
            Transaction.select('store, count(*) total').group(:store).order(total: :desc).each do |result|
              li "#{result['store']} - #{result['total']}"
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Model presence in amount of stores' do
          ul do
            Transaction.select('model, COUNT(DISTINCT(store)) amount_of_stores').group(:model).order(amount_of_stores: :desc).map do |shoe_model|
              li "#{shoe_model.model} is in #{shoe_model.amount_of_stores} stores"
            end
          end
        end
      end

      column do
        panel 'Shoe models transfer suggestion (based on the last 10 transactions)' do
          ul do
            ShoeModel.all.each do |shoe_model|
              sql = "SELECT * FROM (SELECT * FROM transactions WHERE model = '#{shoe_model.name}' ORDER BY created_at DESC LIMIT 10) last_10_transactions ORDER BY inventory DESC;"
              records = ActiveRecord::Base.connection.execute(sql).to_a
              p records
              a = records.first
              b = records.last

              li "#{a['store']} with #{a['inventory']} pairs of #{a['model']} could make a transfer to #{b['store']} with #{b['inventory']} pairs!"
            end
          end
        end
      end
    end
    # 
  end # content
end
