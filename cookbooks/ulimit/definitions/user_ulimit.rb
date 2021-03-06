# Defines a user_ulimit modification
# Sample:
#
# depends 'ulimit'
#
# user_ulimit "tomcat" do
#  filehandle_limit 8192
#  process_limit 61504
# end

define :user_ulimit, :filehandle_limit => 4096, :process_limit => 61232 do
  template "/etc/security/limits.d/#{params[:name]}_limits.conf" do
    source "ulimit.erb"
    cookbook "ulimit"
    owner "root"
    group "root"
    mode 0644
    variables(
      :ulimit_user => params[:name],
      :filehandle_limit => params[:filehandle_limit],
      :process_limit => params[:process_limit]
    )
  end
end
