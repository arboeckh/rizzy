# frozen_string_literal: true

RSpec.describe Rizzy do
  it "has a version number" do
    expect(Rizzy::VERSION).not_to be nil
  end

  describe ".parse" do
    it "loads a file" do
      fixture_path = File.join(__dir__, "fixtures", "ris.ris")
      content = File.read(fixture_path)
      ret = Rizzy.parse(content)
      puts ret
      expect(ret).to be_a(String)
    end
  end
end
