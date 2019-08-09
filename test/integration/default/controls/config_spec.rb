#override by OS
if os.family == 'debian'
  file_name = '/etc/bro/node.cfg'
elsif os.family == 'redhat'
  file_name = '/opt/bro/etc/node.cfg'
end

control 'bro configuration' do
  title 'should match desired lines'

  describe file(file_name) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'bro' }
    its('mode') { should cmp '0664' }
  end
end
