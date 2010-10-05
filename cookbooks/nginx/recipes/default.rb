#
# Cookbook Name:: nginx
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

package "nginx" do
  action :install
end

directory node[:nginx][:web_root] do
  owner "root"
  group "http"
  mode "0775"
end

service "nginx" do
  enabled true
  running true
  supports :restart => true, :reload => true
  action [:enable, :start]
end
