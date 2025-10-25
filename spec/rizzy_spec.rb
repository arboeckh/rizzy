# frozen_string_literal: true

RSpec.describe Rizzy do
  it "has a version number" do
    expect(Rizzy::VERSION).not_to be nil
  end

  describe ".parse" do
    it "loads a file to UTF-8" do
      fixture_path = File.join(__dir__, "fixtures", "asr.ris")
      content = File.read(fixture_path)
      expect(content.encoding).to be Encoding::US_ASCII
      ret = Rizzy.parse(content)
      expect(ret[0].encoding).to be Encoding::UTF_8
    end
  end
end
