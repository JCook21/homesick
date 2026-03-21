# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'pathname'

describe Homesick::RC::Context do
  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }
  let(:home) { tmpdir } # satisfies spec_helper's global ENV['HOME'] hook
  after { tmpdir.rmtree }

  # RC::Context does not emit say_status; suppress the global silence! hook.
  def silence!; end

  subject(:context) { described_class.new(tmpdir) }

  describe '#castle_path' do
    it 'returns a Pathname equal to the given castle path' do
      expect(context.castle_path).to eq(tmpdir)
    end

    it 'returns a Pathname instance' do
      expect(context.castle_path).to be_a(Pathname)
    end

    it 'accepts a string path and coerces it to Pathname' do
      ctx = described_class.new(tmpdir.to_s)
      expect(ctx.castle_path).to eq(tmpdir)
    end
  end

  describe '#run' do
    it 'executes the given shell command and returns true on success' do
      marker = tmpdir.join('ran')
      result = context.run("touch #{marker}")
      expect(result).to be(true)
      expect(marker).to exist
    end

    it 'returns false when the command fails' do
      result = context.run('false')
      expect(result).to be(false)
    end
  end

  describe 'instance_eval isolation' do
    it 'does not expose Homesick::CLI methods to the script' do
      # check_castle_existance is a CLI method; the context should not have it
      expect { context.instance_eval('check_castle_existance("x", "y")', __FILE__, __LINE__) }
        .to raise_error(NoMethodError)
    end

    it 'allows standard Ruby file operations' do
      marker = tmpdir.join('from_script')
      context.instance_eval { File.write(marker.to_s, 'ok') }
      expect(marker.read).to eq('ok')
    end
  end
end
