#
# Cookbook Name:: git
# Recipe:: server
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

include_recipe "git"

directory node[:git][:repo_root] do
  owner "root"
  group "root"
  mode "0755"
end

service "git-daemon" do
  enabled true
  running true
  supports :restart => true
  action [:enable, :start]
end

search(:git_repos).each do |repo|
  repo_path = "/#{node[:git][:repo_root]}/#{repo[:id]}.git"

  directory repo_path do
    owner "root"
    group "git"
    mode "2775"
  end

  execute "initialize new shared git repo" do
    cwd repo_path
    command "git --bare init --shared"
    creates "#{repo_path}/HEAD"
  end

  template "#{repo_path}/config" do
    source "config"
    owner "root"
    group "git"
    mode "0664"
    variables(
      :repo_name => repo[:id]
    )
  end

  if repo[:description]
    file "#{repo_path}/description" do
      content "#{repo[:description]}\n"
    end
  end

  magic_file = "#{repo_path}/git-daemon-export-ok"
  if repo[:public]
    file magic_file do mode "0664" end
  else
    file magic_file do action :delete end
  end
end
