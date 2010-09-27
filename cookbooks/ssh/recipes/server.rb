#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2010, Aaron Bull Schaefer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "openssh" do
  action :upgrade
end

service "sshd" do
  enabled true
  running true
  supports :restart => true
  action [:enable, :start]
end

users = search(:users)

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :users => search(:users)
  )
  notifies :restart, resources(:service => "sshd")
end
