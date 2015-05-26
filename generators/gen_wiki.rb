#Generate Confluence Wiki table, from the IBLinkinfo data.
module WIKI
  #Generate an new html style format confluence wiki table.
  # @param ib [IBLinkInfo] The data derived from an iblinkinfo command, and parsed by the IBLinkInfo class parser
  # @param file [String] The name of the output file.
  def self.gen(ib, file="iblinkinfo_wiki.txt")
    #Output Wiki table syntax separated fields for current switch port to rack mappings
    #@switches.each do |k,v|
    File.open(file, "w") do |fd|
      ib.switch_location.each do |k,loc|
        if loc[1] == :leaf || loc[1] == :ex_spine
          fd.puts "<h3> #{k} </h3>"
          fd.puts "<table>\n  <tbody>"
          v = ib.switches[k]
          if v != nil 
            fd.puts "<tr>"
            (1..loc[4]).step(2) do |i|
              fd.puts "<th><p> </p></th>" if i == 19
              fd.puts "<th><p>#{i}</p></th>"
            end
            fd.puts "</tr>"
            fd.puts "<tr>"
            (1..loc[4]).step(2) do |i|
              l = ib.location[v[i][9]]
              fd.puts "<td><p> </p></td>" if i == 19
              fd.puts "<td><p>#{l == nil ? v[i][9] : "#{l[2]}/P#{"%02d"%v[i][7]}"}</p></td>"
            end
            fd.puts "</tr>"
            fd.puts "<tr>"
            (2..loc[4]).step(2) do |i|
              fd.puts "<th><p> </p></th>" if i == 20
              fd.puts "<th><p>#{i}</p></th>"
            end
            fd.puts "</tr>"
            fd.puts "<tr>"
            (2..loc[4]).step(2) do |i|
              l = ib.location[v[i][9]]
              fd.puts "<td><p> </p></td>" if i == 20
              fd.puts "<td><p>#{l == nil ? v[i][9] : "#{l[2]}/P#{"%02d"%v[i][7]}"}</p></td>"
            end
            fd.puts "</tr>"
          end
          fd.print "  </tbody>\n</table>"
        end
      end
    end
  end
end
