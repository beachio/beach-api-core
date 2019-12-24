module BeachApiCore
  class Invoice < ApplicationRecord
    belongs_to :user, class_name: "BeachApiCore::User"
    belongs_to :organisation, class_name: "BeachApiCore::Organisation"

    validates :invoice_url_link, :invoice_pdf_link, presence: true
  end
end
