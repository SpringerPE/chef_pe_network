
module SPRpe # rubocop:disable Documentation

  # return stdout from calling a command.
  #
  # @param [String] command to run
  # @param [String] command options
  # @param [Hash] environment to use
  # @param [Hash] optional command argument/values pairs
  # @return [String] stdout or fail
  def command(cmd, options = '', env = {}, args = {})
    shellcmd = [cmd] << options
    args.each do |key, val|
      shellcmd << "--#{key}" << val.to_s
    end
    Chef::Log.debug("Running command: #{shellcmd} with environment: #{env}")
    result = shellout(shellcmd, env: env)
    fail "#{result.stderr} (#{result.exitstatus})" if result.exitstatus != 0
    result.stdout
  end

end


