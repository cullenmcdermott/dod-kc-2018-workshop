dns_endpoint = attribute('dns_endpoint', {})

control 'remote' do
  describe service 'nginx' do
    it { should be_running }
  end

  describe package 'nginx' do
    it { should be_installed }
  end

  describe host('test.aws.cullenmcdermott.com', port: 80, protocol: 'http') do
    it { should be_reachable }
    it { should be_resolvable }
  end
end

control 'local' do
  describe http("http://#{dns_endpoint}") do
    its('status') { should eq 301 }
  end

  describe http("https://#{dns_endpoint}") do
    its('status') { should eq 200 }
    its('body') { should match /Welcome to nginx!/ }
  end
end

control 'aws' do
  describe aws_ec2_instance(name: 'cullen-nginx') do
    it { should be_running }
  end

  describe aws_security_group(group_name: 'cullen-nginx') do
    it { should exist }
  end
end
