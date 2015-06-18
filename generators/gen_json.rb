#Output JSON file from IBLinkinfo output.
require 'pp'

module JSON
  #Generate Json output file for consumption by web ib status page, using the iblinkinfo data.
  # @param ib [IBLinkInfo] The data derived from an iblinkinfo command, and parsed by the IBLinkInfo class parser
  # @param file [String] The name of the output file.
  def self.gen_host_status(ib, file='iblinkinfo.json')
    #Output Yaml file recording port status for a switch
    File.open(file, "w") do |fd|
      port_status = {}
      ib.switch_location.each do |k,loc| #Iterate over the defined switches
        switch_ports = []
        v = ib.switches[k]
        if v != nil 
          (1..loc[4]).each do |i|
            switch_ports[i] = [ v[i].host_basename, v[i].up? ? ( v[i].speed_40G? ? "'ok'" : "'degraded'") : "'fault'" ]
          end
          port_status[k] = switch_ports
        end
      end
      
      fd.puts "{\n  'datetime': '#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}',\n  'state': {"
      port_status.each do |k,v| 
        v.each { |v2| fd.puts "    '#{v2[0]}-ib': #{v2[1]}," if v2.class == Array && v2[0] != '' }
      end
      fd.puts "    'end': ''\n  }\n}"
    end
  end
end

