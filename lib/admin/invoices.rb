ActiveAdmin.register BeachApiCore::Invoice, as: 'Invoice' do
  menu parent: 'Services'
  permit_params :keeper_type, :keeper_id, :subscription_id, :invoice_url_link, :invoice_pdf_link, :payment_successfull

  index do
    id_column
    column :keeper_type
    column :keeper_id
    column :subscription_id
    column :invoice_url_link
    column :invoice_pdf_link
    column :payment_successfull
    actions
  end

  filter :name

  form do |f|
    f.inputs label:"Invoice" do
      f.input :keeper_type, as: :select, collection: [["Organisation","BeachApiCore::Organisation"],["User","BeachApiCore::User"]]
      f.input :keeper_id, label: "ID keeper"
      f.input :subscription_id, label: "ID subscription"
      f.input :invoice_url_link, label: "Url"
      f.input :invoice_pdf_link, label: "Pdf"
      f.input :payment_successfull
    end
    f.actions
  end

  show do |_plan|
    attributes_table do
      row :keeper_type
      row :keeper_id
      row :subscription_id
      row :invoice_url_link
      row :invoice_pdf_link
      row :payment_successfull
    end
  end
end