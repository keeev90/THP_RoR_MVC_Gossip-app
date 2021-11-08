class CreatePrivateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :private_messages do |t|
      t.text :content
      t.references :sender, index: true #Comme la table senders n'existe pas, tu ne mets pas foreign_key: true, mais index: true > La table private_messages a donc une colonne sender_id
      t.references :recipient, index: true #Comme la table senders n'existe pas, tu ne mets pas foreign_key: true, mais index: true > La table private_messages a donc une colonne recipient_id

      t.timestamps
    end
  end
end
