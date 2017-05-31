class AddUniqIndexToInteractionAttributes < ActiveRecord::Migration[5.1]
  def change
    BeachApiCore::InteractionAttribute.select('interaction_id,key').group('interaction_id,key')
                                      .having('count(interaction_id) > 1').each do |interaction_attribute|
      attrs = BeachApiCore::InteractionAttribute.where(interaction_id: interaction_attribute.interaction_id,
                                                       key: interaction_attribute.key).to_a
      attrs.pop
      attrs.each(&:destroy)
    end
    add_index :beach_api_core_interaction_attributes, %i(interaction_id key),
              unique: true,
              name: 'index_bac_interaction_attributes_on_interaction_id_and_key'
  end
end
