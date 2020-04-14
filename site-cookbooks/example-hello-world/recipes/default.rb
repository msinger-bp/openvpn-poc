docker_installation 'default'

# needs to happen after docker is installed...
include_recipe 'example-hello-world::ecr_auth'

# all container should run as this user
user 'container' do
  uid     500
  comment "Container User"
  system  true
  action  :create
end

docker_image 'hello-world' do
  repo           '438308380087.dkr.ecr.us-east-1.amazonaws.com/example/hello-world'
  tag            'latest'
  action         :pull
  notifies       :redeploy, 'docker_container[hello-world]'
  ignore_failure true
end

docker_container 'hello-world' do
  repo           '438308380087.dkr.ecr.us-east-1.amazonaws.com/example/hello-world'
  tag            'latest'
  port           '8000:8000'
  user           '500:500'
  network_mode   'host'
  env            [ 'FOO=bar' ]
  volumes        [ '/srv/nexia/config:/config' ]
  ignore_failure true
end

