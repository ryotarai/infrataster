require 'integration/spec_helper'

describe server(:app) do
  describe mysql_query('SHOW STATUS') do
    it 'responds uptime' do
      row = results.find {|r| r['Variable_name'] == 'Uptime' }
      expect(row['Value'].to_i).to be > 0
    end
  end
end

