class PrivateMessage < ApplicationRecord
  belongs_to :sender, class_name: "User" #indique que PrivateMessage appartient à un sender, qui est en fait de la classe User
  belongs_to :recipient, class_name: "User" #indique que PrivateMessage appartient à un recipient, qui est en fait de la classe User
end
