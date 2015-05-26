#Deprecated, old confluence wiki table output from IBLinkinfo.
module WIKI_Old
  #Generate an old | separated format confluence wiki table.
  # @param ib [IBLinkInfo] The data derived from an iblinkinfo command, and parsed by the IBLinkInfo class parser
  # @param file [String] The name of the output file.
  def self.gen(ib, file='iblinkinfo_wiki_old.txt')
    #Output Wiki | separated fields for current switch port to rack mappings
    #@switches.each do |k,v|
    File.open(file, "w") do |fd|
      ib.switch_location.each do |k,loc|
        if loc[1] == :leaf || loc[1] == :ex_spine
          fd.puts "h3. #{k}"
          v = ib.switches[k]
          if v != nil 
            (1..loc[4]).step(2) do |i|
              fd.print " | " if i == 19
              fd.print "| " if i == 1
              fd.print " | #{i}"
            end
            fd.print " |\n"
            (1..loc[4]).step(2) do |i|
              l = ib.location[v[i][9]]
              fd.print " | " if i == 19
              fd.print "| " if i == 1
              if(l != nil && @switches[v[i][9]] != nil)
                fd.print " | #{l[0]}/P#{"%02d"%v[i][7]}"
              else
                fd.print " | #{l == nil ? v[i][9] : "#{l[2]}/P#{"%02d"%v[i][7]}"}"
              end
            end
            fd.print " |\n"
            (2..loc[4]).step(2) do |i|
              fd.print " | " if i == 20
              fd.print "| " if i == 2
              fd.print " | #{i}"
            end
            fd.print " |\n"
            (2..loc[4]).step(2) do |i|
              l = ib.location[v[i][9]]
              fd.print " | " if i == 20
              fd.print "| " if i == 2
              if(l != nil && @switches[v[i][9]] != nil)
                fd.print " | #{l[0]}/P#{"%02d"%v[i][7]}"
              else
                fd.print " | #{l == nil ? v[i][9] : "#{l[2]}/P#{"%02d"%v[i][7]}"}"
              end
            end
            fd.print " |\n"
          end
        end
      end
    end
  end
end

