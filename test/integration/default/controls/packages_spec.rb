# Overide by OS
package_name = 'bro'
if os[:name] == 'centos' and os[:release].start_with?('6')
  package_name = 'bro'
end

control 'bro package' do
  title 'should be installed'

  describe package(package_name) do
    it { should be_installed }
  end
end
