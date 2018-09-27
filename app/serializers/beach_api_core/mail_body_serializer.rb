module BeachApiCore
  class MailBodySerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :application_id, :mail_type, :text_color, :button_color, :button_text, :body_text,
               :button_text_color, :greetings_text, :signature_text, :footer_text
  end
end
