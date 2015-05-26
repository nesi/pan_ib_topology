require 'pp'

#output a Slurm topology file, base on the IBLinkinfo output
module SLURM
  
  #Generate a slurm infiniband topology from the IBLinkinfo data.
  # @param ib [IBLinkInfo] The data derived from an iblinkinfo command, and parsed by the IBLinkInfo class parser
  # @param file [String] The name of the output file.
  def self.gen(ib, file='topology.conf')
    #Output Slurm topology.conf file
    File.open(file, "w") do |fd|
      ib.switch_location.each do |k,loc|
        v = ib.switches[k]
        if v != nil 
          cnodes = []
          switches = []
          (1..loc[4]).each do |i|
            l = ib.location[v[i][9]]
            if l != nil
              if l[1] == :cnode
                cnodes << l[3]
              elsif l[1] == :leaf && (ib.location[k][1] == :spine || ib.location[k][1] == :ex_spine) # || l[1] == :ex_spine || l[1] == :spine
                switches << l[3]
              end
            end
          end
          print(fd, ib.location[k][3], cnodes, switches)
        end
      end
    end
  end

  #compress, compresses sequences of nodes to make a more compact topology file
  #    takes a sequence a-1, a-2, a-3, ... a-n and converts it to a-[1-n]
  # @param cnodes [Array] List of compute nodes on this switch.
  # @return [Array] Compressed list of compute node
  def self.compress(cnodes)
    new_cnodes = []
    last_node = ['', -1] #[lead_in, sequence number]
    this_node = ['', -1]
    count = 0
    first_seq = 0
    cnodes.each do |c|
      chunks = c.split("-")
      this_node[0] = chunks[0..-2].join('-') #Put back together, except for digits at the end
      this_node[1] = chunks[-1].to_i #Convert digits at end to an integer.

      if this_node[0] == last_node[0] && this_node[1] == last_node[1] + 1 #Same basename, with sequence + 1
        first_seq = last_node[1] if count == 0 
        count = count + 1
        last_node[0] = this_node[0]
        last_node[1] = this_node[1]
      else #Either the basename has changed, or the sequence number isn't 1 more
        if count > 0 # We have had at least 1 sequence recorded.
          new_cnodes << "#{last_node[0]}-[#{"%03d"%first_seq}-#{"%03d"%(first_seq+count)}]"
        else #We haven't found a sequence, so we need to output the last node, if there was one.
          if last_node[1] != -1
            new_cnodes << "#{last_node[0]}-#{"%03d"%last_node[1]}"
          end 
        end
        last_node[0] = this_node[0]
        last_node[1] = this_node[1]
        count = 0
        first_seq = 0
      end
    end
    if count > 0 # We have had at least 1 sequence recorded.
      new_cnodes << "#{last_node[0]}-[#{"%03d"%first_seq}-#{"%03d"%(first_seq+count)}]"
    else #We haven't found a sequence, so we need to output the last node, if there was one.
      if last_node[1] != -1
        new_cnodes << "#{last_node[0]}-#{"%03d"%last_node[1]}"
      end 
    end
    return new_cnodes
  end
  
  #Output config line for this switches nodes and switches
  # @param fd [File] File descriptor for the output file
  # @param switch [String] the switches name
  # @param cnodes [Array] the compute nodes on this switch
  # @param switches [Hash] All switches we know of, so we can reference any we are linked to.
  def self.print(fd, switch, cnodes, switches)
    fd.print "SwitchName=#{switch}" #The switch
    if switches.length > 0 #Any switches connected to this switch
      switches.sort! #Makes it easier for humans to parse.
      fd.print " Switches=#{switches[0]}"
      (1...switches.length).each do |s|
        fd.print ",#{switches[s]}"
      end
    end
    if cnodes.length > 0 
      cnodes.sort! #Makes it easier for humans to parse. Also helps compressing runs
      new_cnodes = compress(cnodes) #takes a-1, a-2, a-3 and converts it to a-[1-3]
      fd.print " Nodes=#{new_cnodes[0]}" 
      (1...new_cnodes.length).each do |c|
        fd.print ",#{new_cnodes[c]}"
      end
    end
    fd.print "\n"
  end

end

