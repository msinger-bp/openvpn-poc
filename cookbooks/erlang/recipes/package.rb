#
# Cookbook:: erlang
# Recipe:: package
# Author:: Joe Williams <joe@joetify.com>
# Author:: Matt Ray <matt@chef.io>
# Author:: Hector Castro <hector@basho.com>
#
# Copyright:: 2008-2019, Joe Williams
# Copyright:: 2011-2019, Chef Software Inc.
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

case node['platform_family']
when 'debian'
  package 'erlang-dev'

when 'rhel', 'suse', 'fedora'
  include_recipe 'yum-epel' if platform_family?('rhel') && node['erlang']['package']['install_epel_repository']

  package 'erlang' do
    version node['erlang']['package']['version'] if node['erlang']['package']['version']
  end
end
