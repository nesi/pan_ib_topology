#output TSV Excel file from IBLinkinfo as tab seperated file
module TSV
  #Generate a Tab separated (.tsv) formated file from the IBLinkinfo data.
  # @param ib [IBLinkInfo] The data derived from an iblinkinfo command, and parsed by the IBLinkInfo class parser
  # @param file [String] The name of the output file.
  def self.gen(ib, file='iblinkinfo.tsv')
    #Output Excel tab separated fields for current switch port to rack mappings
    #@switches.each do |k,v|
    File.open(file, "w") do |fd|
      ib.switch_location.each do |k,loc|
        if loc[1] == :leaf || loc[1] == :ex_spine
          fd.puts k
          v = ib.switches[k]
          #puts v.class
          if v != nil 
            (1..loc[4]).step(2) do |i|
              fd.print "\t" if i == 19 
              fd.print"\t#{i}"
            end
            fd.print "\n"
            (1..loc[4]).step(2) do |i|
              l = ib.location[v[i][9]]
              fd.print "\t" if i == 19 
              fd.print l == nil ? "\t " : "\t#{l[0]}/P#{"%02d"%v[i][7]}"
            end
            fd.print "\n"
            (1..loc[4]).step(2) do |i|
              l = ib.location[v[i][9]]
              fd.print "\t" if i == 19 
                fd.print "\t#{l == nil ? v[i][9] : "#{l[2]}/P#{"%02d"%v[i][7]}"}" # Don't have a location : do have a location
              #end
            end
            fd.print "\n"

            (2..loc[4]).step(2) do |i|
              fd.print "\t" if i == 20
              fd.print "\t#{i}" 
            end
            fd.print "\n"
            (2..loc[4]).step(2) do |i|
              l = ib.location[v[i][9]]
              fd.print "\t" if i == 20
              fd.print l == nil ? "\t " : "\t#{l[0]}/P#{"%02d"%v[i][7]}"
            end
            fd.print "\n"
            (2..loc[4]).step(2) do |i|
              l = ib.location[v[i][9]]
              fd.print "\t" if i == 20
              fd.print "\t#{l == nil ? v[i][9] : "#{l[2]}/P#{"%02d"%v[i][7]}"}"
            end
            fd.print "\n"
          end
        end
      end
    end
  end
end