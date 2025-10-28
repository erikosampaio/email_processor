require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:product_code) }
    it { should validate_presence_of(:subject) }

    it 'validates email format' do
      customer = build(:customer, email: 'invalid-email')
      expect(customer).not_to be_valid
      expect(customer.errors[:email]).to include('is invalid')
    end

    it 'accepts valid email format' do
      customer = build(:customer, email: 'valid@example.com')
      expect(customer).to be_valid
    end
  end

  describe 'associations' do
    it 'has no direct associations' do
      # Customer model doesn't have explicit associations in this implementation
      expect(Customer.reflect_on_all_associations).to be_empty
    end
  end

  describe 'factory' do
    it 'creates valid customer' do
      customer = build(:customer)
      expect(customer).to be_valid
    end

    it 'creates customer with all required attributes' do
      customer = create(:customer)
      expect(customer.name).to be_present
      expect(customer.email).to match(/@/)
      expect(customer.phone).to be_present
      expect(customer.product_code).to be_present
      expect(customer.subject).to be_present
    end
  end
end
