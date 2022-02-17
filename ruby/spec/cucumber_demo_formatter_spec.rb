require 'stringio'
require 'cucumber/messages'
require 'cucumber_demo_formatter'

describe CucumberDemoFormatter do
  it "prints a smiley for a passed step" do
    input = StringIO.new

    %w{UNKNOWN PASSED SKIPPED PENDING UNDEFINED AMBIGUOUS FAILED}.each do |status|
      input.write({
        testStepFinished: {
          testStepResult: {
            status: status
          }
        }
      }.to_json)
      input.write("\n")
    end

    input.rewind

    output = StringIO.new

    f = CucumberDemoFormatter.new
    message_enumerator = Cucumber::Messages::NdjsonToMessageEnumerator.new(input)
    f.process_messages(message_enumerator, output)

    output.rewind
    s = output.read
    expect(s).to eq('👽😃🥶⏰🤷🦄💣')
  end

  context "acceptance testing" do
    it "can format examples-tables.feature.ndjson from the CCK" do
      formatter = CucumberDemoFormatter.new
      output = StringIO.new

      ndjson_data = File.read('../testdata/examples-tables.feature.ndjson')
      message_enumerator = Cucumber::Messages::NdjsonToMessageEnumerator.new(ndjson_data)
      formatter.process_messages(message_enumerator, output)

      output.rewind
      s = output.read
      expect(s).to eq("😃😃😃😃😃😃😃😃💣😃😃💣😃🤷🥶😃😃🤷\n")
    end
  end
end
