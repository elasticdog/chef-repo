#
# Cookbook Name:: users
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

include_recipe "shells"

search(:users).each do |user|
  home_dir = user[:home] || "/home/#{user[:id]}"
  user user[:id] do
    comment user[:comment]
    uid user[:uid]
    gid user[:gid]
    home home_dir
    shell user[:shell] || "/bin/bash"
    supports :manage_home => false
    action [:create, :manage]
  end

  if user[:manage_files]
    directory "#{home_dir}" do
      owner user[:id]
      group user[:gid]
      mode "0700"
    end

    directory "#{home_dir}/.ssh" do
      owner user[:id]
      group user[:gid]
      mode "0700"
    end

    template "#{home_dir}/.ssh/authorized_keys" do
      source "authorized_keys.erb"
      owner user[:id]
      group user[:gid]
      mode "0600"
      variables :ssh_keys => user[:ssh_keys]
    end
  end
end

search(:groups).each do |group|
  group group[:id] do
    gid group[:gid]
    members group[:members]
    action [:create, :modify, :manage]
  end
end
