class CreateForwarders < ActiveRecord::Migration[5.1]
  def change
    create_table :forwarders do |t|
      t.belongs_to :user, foreign_key: true

      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name

      t.string :residence_country_code, null: false
      t.string :state, null: false
      t.string :city, null: false
      t.string :street_name, null: false
      t.string :zip_code, null: false
      t.string :phone_number, null: false
      t.string :email, null: false

      t.string :document_type, null: false
      t.string :document_number, null: false
      t.date :document_expiration_date, null: false

      t.attachment :document_front, null: false
      t.attachment :document_back

      t.string :proof_of_residence_type, null: false
      t.attachment :proof_of_residence_pic, null: false

      t.attachment :selfie, null: false
      t.string :selfie_verification, null: false

      t.string :status, default: 'unverified', null: false
      t.integer :level, default: 0, null: false

      t.timestamps
    end
  end
end
