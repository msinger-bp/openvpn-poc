name 'dev'
description "acadience dev environment"

# You shouldn't need to change anything below this line

# to_vmash converts a deeply nested hash to chef attributes syntax
def to_vmash(h, name='node', r=[], list=[])
  h.each do |k,v|
    case v
    when Hash
      to_vmash(v, name, r, [list,k].flatten)
    when Numeric, Float, Array, Symbol, TrueClass, FalseClass
      r<<"#{name}" + [list,k].flatten.map{|i| "['#{i}']"}.join('') + " = #{v}"
    else # assume stringish
      s="#{name}" + [list,k].flatten.map{|i| "['#{i}']"}.join('') + " = "
      if v.to_s.lines.count < 2 #single line value
        s += "'#{v}'"
      else #multi-line value
        eof="EOF_#{k}"
        s += "<<#{eof}\n" + v + "#{eof}"
      end
      r<<s
    end
  end
  return r.join("\n")
end

#allow for "default" and "override" vMashes, like cookbook attribute files
default=Chef::Node::VividMash.new()
override=Chef::Node::VividMash.new()

# load all the environment chunks from the environment subdir
Dir.glob(File.join("#{Chef::Config.environment_path}/#{name}", "**", "*.{rb,json}")).sort.each do |i|
  if i.end_with?('.rb') then
    eval IO.read(i)
  elsif i.end_with?('.json') then
    JSON::parse(IO.read(i)).select {|i| ['default', 'override'].include? i}.each do |k,v|
      eval to_vmash(v, k)
    end
  else
    Chef::Log.error("Unknown file type: #{i}")
  end
end

# set attributes in the manner chef expects
default_attributes default.to_hash
override_attributes override.to_hash
