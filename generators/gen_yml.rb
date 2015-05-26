#Output YAML file from IBLinkinfo output.
module YML
  #Generate Yaml output file, from the iblinkinfo data.
  # @param ib [IBLinkInfo] The data derived from an iblinkinfo command, and parsed by the IBLinkInfo class parser
  # @param file [String] The name of the output file.
  def self.gen(ib, file='iblinkinfo.yml')
    #Output Yaml file recording port status for a switch
    File.open(file, "w") do |fd|
      port_status = {}
      ib.switch_location.each do |k,loc|
        switch_ports = []
        v = ib.switches[k]
        if v != nil 
          (1..loc[4]).each do |i|
            row = []
            l = ib.location[v[i][9]] #Connected host / switch
            row[0] = v[i][9] #Remote host attached to port
            row[1] = v[i][7] #Remote Port Number
            if(l != nil && ib.switches[v[i][9]] != nil)
              row[2] = "" #Alternate name
              #fd.print "\t-"
            else
              row[2] = "#{l == nil ? v[i][9] : "#{l[2]}/P#{"%02d"%v[i][7]}"}" #Alternate name
            end
            switch_ports[i] = row
          end
          port_status[k] = switch_ports
        end
      end
      fd.write(port_status.to_yaml)
    end
  end
end

