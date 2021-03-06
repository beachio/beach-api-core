module UploadsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/uploads', I18n.t('api.resource_description.descriptions.uploads.upload')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'attachment', String, desc: "Attachment via formdata"
  param 'attachment_url', String, desc: "Attachment via url"
  param 'attachment_base64', String, desc: "Attachment vie base64"
  def create; end

  api :POST, '/uploads/avatar', 'Upload and Set avatart'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'attachment', String, desc: "Attachment via formdata"
  param 'attachment_url', String, desc: "Attachment via url"
  param 'attachment_base64', String, desc: "Attachment vie base64"
  def avatar; end
end
