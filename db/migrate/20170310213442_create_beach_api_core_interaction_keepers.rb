class Interaction_20170310213442 < ActiveRecord::Base
  self.table_name = 'beach_api_core_interactions'

  belongs_to :keeper, polymorphic: true
end

class CreateBeachApiCoreInteractionKeepers < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_interaction_keepers do |t|
      t.references :interaction, foreign_key: { to_table: :beach_api_core_interactions }
      t.references :keeper, polymorphic: true,
                   index: { name: 'index_beach_api_core_interaction_keepers_on_k_type_and_k_id' }
      t.timestamps
    end

    Interaction_20170310213442.find_each do |interaction|
      inter = BeachApiCore::Interaction.find(interaction.id)
      inter.interaction_keepers.build(keeper: interaction.keeper)
      inter.save!
    end

    remove_reference :beach_api_core_interactions, :keeper, polymorphic: true, index: true
  end
end
