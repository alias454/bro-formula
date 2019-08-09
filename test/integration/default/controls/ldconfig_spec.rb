if os.family == 'redhat'
  control 'bro library configuration' do
    title 'should match desired lines'

    describe file('/etc/ld.so.conf.d/bro-x86_64.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should cmp '0644' }
      its('content') { should include '/opt/bro/lib' }
      its('content') { should include '/opt/bro/lib64' }
    end
  end
end
