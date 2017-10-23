require "spec_helper"

RSpec.describe User::Stream do
  it "has a version number" do
    expect(User::Stream::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
