# for serverspec documentation: http://serverspec.org/
require_relative 'spec_helper'

pkgs = ['strongswan']
files = ['/etc/strongswan.d/charon/kernel-netlink.conf', '/etc/ipsec.conf']

pkgs.each do |pkg|
  describe package("#{pkg}") do
    it { should be_installed }
  end
end

files.each do |file|
  describe file("#{file}") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
  end
end

describe interface('vti0') do
  it { should exist }
end

describe service('strongswan') do
  it { should be_running }
  it { should be_enabled }
end
