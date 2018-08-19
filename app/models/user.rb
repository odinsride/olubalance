class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :message => "Please enter your First Name"
  validates_presence_of :last_name, :message => "Please enter your Last Name"
  validates_presence_of :timezone, :message => "Please select a Time Zone"

  has_many :accounts, dependent: :destroy
end
