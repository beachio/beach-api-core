class CreateBeachApiCoreInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_invoices do |t|
      t.string :keeper_type
      t.integer :keeper_id
      t.integer :subscription_id
      t.string :invoice_url_link
      t.string :invoice_pdf_link
      t.boolean :payment_successfull
      t.timestamps
    end
  end
end
