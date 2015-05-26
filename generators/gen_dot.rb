#Produce a Graphviz dot file of the IB network.
#Render with dot -Tsvg -o file.svg file
#Nb. Our network is a bit large for this :)
module DOT

  #Generate a dot formated  file from the IBLinkinfo data for use with graphviz.
  # @param ib [IBLinkInfo] The data derived from an iblinkinfo command, and parsed by the IBLinkInfo class parser
  # @param file [String] The name of the output file (produces the .dot file and a .png, if dot_cmd != nil)
  def self.gen(ib, file='iblinkinfo.dot', dot_cmd=nil)
    #Output dot graph of switches
    File.open(file, "w") do |fd|
      fd.puts <<-EOF
      digraph g {
      graph [
        rankdir = "TB"
        ratio = auto;
      ];
    EOF

      ib.switches.each do |k,v|
        fd.puts "\"#{k}\" [" #Node name
        fd.print "label=<<table><tr><td>\"#{v[1][9]}\"</td></tr>" #First port
        (2..36).each do |i|
          fd.print "<tr><td>#{v[i][9]}</td></tr>" #Other 35 ports
        end
        fd.print "</table>>\nshape = \"Mrecord\"\n"
        fd.puts "];"
      end

      @been_there = {}
      backbone = [ # These should be in a config file. Defined to make picture centered on the core.
        "MF0;ib0-is5200-a2-bip-m:IS5200/S01/U1",
        "MF0;ib0-is5200-a2-bip-m:IS5200/S02/U1",
        "MF0;ib0-is5200-a2-bip-m:IS5200/S03/U1",
        "MF0;ib0-is5200-a2-bip-m:IS5200/S04/U1",
        "MF0;ib0-is5200-a2-bip-m:IS5200/S05/U1",
        "MF0;ib0-is5200-a2-bip-m:IS5200/S06/U1",

        "MF0;ib0-is5300-c4-bip-m:IS5300/S01/U1",
        "MF0;ib0-is5300-c4-bip-m:IS5300/S02/U1",
        "MF0;ib0-is5300-c4-bip-m:IS5300/S03/U1",
        "MF0;ib0-is5300-c4-bip-m:IS5300/S04/U1",
        "MF0;ib0-is5300-c4-bip-m:IS5300/S05/U1",
        "MF0;ib0-is5300-c4-bip-m:IS5300/S06/U1",
        "MF0;ib0-is5300-c4-bip-m:IS5300/S07/U1",
        "MF0;ib0-is5300-c4-bip-m:IS5300/S08/U1",
        "MF0;ib0-is5300-c4-bip-m:IS5300/S09/U1",

        "MF0;ib-sx6036-a2-001-m:SX6036/U1",
        "MF0;ib-sx6036-a2-002-m:SX6036/U1",
        "MF0;ib-sx6036-a2-003-m:SX6036/U1",
        ]

      @sub_switches = backbone

      while @sub_switches != nil && @sub_switches.length > 0 do
        @next_layer = @sub_switches
        @sub_switches = []
        @next_layer.each do |l|
          process_switch(fd, l, ib.switches)
        end
      end

        fd.puts "}"
    end
    
    #system("#{dot_cmd} -Tpng -o #{file.gsub(/\..+$/,'')}.png -Tcmapx -o #{file.gsub(/\..+$/,'')}_map.html #{file}")  if dot_cmd != nil
    system("#{dot_cmd} -Tpng -o #{file.gsub(/\..+$/,'')}.png  #{file}")   if dot_cmd != nil
    
  end

  #Process a switch
  # @param fd [File] File descriptor for the output file
  # @param s [Array<Array>] This switches port array
  # @param switches [Hash] The other switches we know about, so we can reference information about them
  def self.process_switch(fd, s, switches)
    v = switches[s] #get port array
    if v == nil
      puts "***** switch #{s} not found"
      return
    end
    (1..36).each do |i| #Each switch is 36 ports
        target = v[i][9] #Potential target switch
        if switches[target] != nil && #It is a switch
          if  @been_there[s] == nil
            @been_there[s] = [target]
            go = true
          elsif  @been_there[s].member?(target) == false 
            @been_there[s] << target
            go = true
          end
          if  @been_there[target] == nil
            @been_there[target] = [s]
            go = true
          elsif  @been_there[target].member?(s) == false 
            @been_there[target] << s
            go = true
          end
          if go
            fd.puts "\"#{s}\" -> \"#{target}\"" #Dot link format, representing a physical linke between switches
            @sub_switches << target
          end
        end
    end
  end
end
