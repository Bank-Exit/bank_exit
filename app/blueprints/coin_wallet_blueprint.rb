class CoinWalletBlueprint < Blueprinter::Base
  field :coin, name: :name
  field :public_address
end
