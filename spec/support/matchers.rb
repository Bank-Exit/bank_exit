RSpec::Matchers.define :be_available do
  match do |actual|
    actual.reload.available?
  end
end

RSpec::Matchers.define_negated_matcher :be_soft_deleted, :be_available
