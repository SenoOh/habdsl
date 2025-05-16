# frozen_string_literal: true

RSpec.describe "HABDSL" do
  it "has a version number" do
    require "habdsl"
    expect(Habdsl::VERSION).not_to be_nil
  end
end
