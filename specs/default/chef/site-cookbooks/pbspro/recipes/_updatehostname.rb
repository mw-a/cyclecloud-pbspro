
#
# Cookbook Name:: gridengine
# Recipe:: _updatehostname
#

use_nodename_as_hostname = node[:pbspro][:use_nodename_as_hostname]
if use_nodename_as_hostname
  nodename = node[:cyclecloud][:node][:name]
  node_prefix = node[:pbspro][:node_prefix]
  if !node_prefix.empty?
    nodename = "#{node_prefix}#{nodename}"
  end

  # from https://github.com/chef-boneyard/chef_hostname/blob/c9838b625916d5e2ec1459b0eddc6c6405d87f37/resources/hostname.rb#L93C1-L96C12
  execute "hostnamectl set-hostname #{nodename}" do
    not_if { shell_out!("hostnamectl status", { :returns => [0, 1] }).stdout =~ /Static hostname:\s+#{nodename}/ }
  end
end

bash "update hostname via jetpack" do
    code <<-EOF
    #{node[:cyclecloud][:home]}/system/embedded/bin/python -c "import jetpack.converge as jc; jc._send_installation_status('warning')"
  EOF
end
