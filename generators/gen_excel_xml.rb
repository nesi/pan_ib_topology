#Generate an Excel XML file from the IBLinkInfo data.
#Switches and their ports are shown.
module Excel_XML

  #Generate a XML formated Excel file from the IBLinkinfo data.
  # @param ib [IBLinkInfo] The data derived from an iblinkinfo command, and parsed by the IBLinkInfo class parser
  # @param file [String] The name of the output file.
  def self.gen(ib, file="iblinkinfo.xml")
    #Output Excel XML file
    File.open(file, "w") do |fd|
      excel_xml_header(fd, ib.switches.length)
      ib.switch_location.each do |k,loc|
        if loc[1] == :leaf || loc[1] == :ex_spine
          excel_xml_table_start(fd, k)     
          v = ib.switches[k]
          #puts v.class
          if v != nil 
            #excel_xml_table_1st_header(fd)
            if k =~ /Mellanox 4036E.*/
              excel_xml_table_header(fd, 18, 34, 1 )
              excel_xml_row(fd, 18, 34, v, ib.location, 1) 
              #excel_xml_table_2nd_header(fd)
              excel_xml_table_header(fd, 1, 17, 1 )
              excel_xml_row(fd, 1, 17, v, ib.location, 1)
            else
              excel_xml_table_header(fd, 1, 36, 2 )
              excel_xml_row(fd, 1, 36, v, ib.location, 2) 
              #excel_xml_table_2nd_header(fd)
              excel_xml_table_header(fd, 2, 36, 2 )
              excel_xml_row(fd, 2, 36, v, ib.location, 2)
            end
                    
            excel_xml_last_row(fd)
          else
            v_nil = [ #hack to make code simpler. 36 empty ports, so we don't have to special case this.
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ["","","","","","","","","",""],
              ]
            excel_xml_table_1st_header(fd)
            excel_xml_row(fd, 1, 19, v_nil, ib.location, loc)

            excel_xml_table_2nd_header(fd)        
            excel_xml_row(fd, 2, 20, v_nil, ib.location, loc)

            excel_xml_last_row(fd)
          end
        end
      end
      excel_xml_footer(fd)
    end
  end

  #Excel XML file lead in
  # @param fd [File] File descriptor for the output file
  # @param switch_count [Fixnum] The number of switches (hence the number of tables we need to generate, hence number of rows in total).
  def self.excel_xml_header(fd, switch_count)
    fd.puts <<-EOF
<?xml version="1.0"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
xmlns:html="http://www.w3.org/TR/REC-html40">
<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
<Author>rbur004</Author>
<LastAuthor>rbur004</LastAuthor>
<Created>2015-01-12T23:01:09Z</Created>
<LastSaved>2015-01-12T22:56:15Z</LastSaved>
<Company>UoA</Company>
<Version>14.0</Version>
</DocumentProperties>
<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
<AllowPNG/>
</OfficeDocumentSettings>
<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
<WindowHeight>23900</WindowHeight>
<WindowWidth>39720</WindowWidth>
<WindowTopX>4960</WindowTopX>
<WindowTopY>140</WindowTopY>
<ProtectStructure>False</ProtectStructure>
<ProtectWindows>False</ProtectWindows>
</ExcelWorkbook>
<Styles>
<Style ss:ID="Default" ss:Name="Normal">
 <Alignment ss:Vertical="Bottom"/>
 <Borders/>
 <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
 <Interior/>
 <NumberFormat/>
 <Protection/>
</Style>
<Style ss:ID="s63">
 <Borders>
  <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
  <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
  <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
<Style ss:ID="s64">
 <Borders>
  <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
  <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
  <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
<Style ss:ID="s65">
 <Borders>
  <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
  <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
 <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"
  ss:Bold="1"/>
</Style>
<Style ss:ID="s66">
 <Borders>
  <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
<Style ss:ID="s67">
 <Borders>
  <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
  <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
<Style ss:ID="s68">
 <Borders>
  <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
<Style ss:ID="s69">
 <Borders/>
 <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"
  ss:Bold="1"/>
</Style>
<Style ss:ID="s70">
 <Borders>
  <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
<Style ss:ID="s71">
 <Borders/>
</Style>
<Style ss:ID="s72">
 <Borders>
  <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
  <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
<Style ss:ID="s73">
 <Borders>
  <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
<Style ss:ID="s74">
 <Borders>
  <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
  <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
 </Borders>
</Style>
</Styles>
<Worksheet ss:Name="iblinkinfo_excel.txt">
<Table ss:ExpandedColumnCount="21" ss:ExpandedRowCount="#{switch_count*8}" x:FullColumns="1"
x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
<Column ss:AutoFitWidth="0" ss:Width="22"/>
<Column ss:AutoFitWidth="0" ss:Width="88" ss:Span="8"/>
<Column ss:Index="11" ss:AutoFitWidth="0" ss:Width="12"/>
<Column ss:AutoFitWidth="0" ss:Width="88" ss:Span="8"/>
<Column ss:Index="21" ss:AutoFitWidth="0" ss:Width="19"/>
EOF
  end

  #Generates the table header for a switch
  # @param fd [File] File descriptor for the output file
  # @param start [Fixnum] Table row start value (first port)
  # @param end [Fixnum] Table row end value (last port this row)
  # @param inc [Fixnum] Usually 1 for sequential port numbering, or 2 for port numbering top and bottom row.
  def self.excel_xml_table_header(fd, start, end_val, inc )
    fd.puts <<-EOF
     <Row ss:Height="16">
       <Cell ss:StyleID="s68"/>
EOF
    gap = start + 9 * inc
    (start..end_val).step(inc) do |i|
      fd.puts "       <Cell ss:StyleID=\"s69\"/>" if i == gap
      fd.puts "       <Cell ss:StyleID=\"s69\"><Data ss:Type=\"Number\">#{i}</Data></Cell>"
    end
    fd.puts <<-EOF
      <Cell ss:StyleID="s70"/>
    </Row>
EOF
  end

  #Generates the xml table's first row's XML formatting for the switch
  # @param fd [File] File descriptor for the output file
  # @param switch_name [String] For labelling the row
  def self.excel_xml_table_start(fd,switch_name)
    fd.puts <<-EOF
    <Row>
     <Cell ss:StyleID="s65"><Data ss:Type="String">#{switch_name}</Data></Cell>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s66"/>
     <Cell ss:StyleID="s67"/>
    </Row>
    EOF
  end
  
  #Generates the xml table's last row's formatting for the switch
  # @param fd [File] File descriptor for the output file
  def self.excel_xml_last_row(fd)
    fd.puts <<-EOF
    <Row ss:Height="16">
     <Cell ss:StyleID="s72"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s73"/>
     <Cell ss:StyleID="s74"/>
    </Row>
  EOF
  end

  #Generates the xml table's last row's formatting for the switch
  # @param fd [File] File descriptor for the output file
  # @param start [Fixnum] Table row start value (first port)
  # @param end [Fixnum] Table row end value (last port this row)
  # @param v [Array<Array>] Array of ports (which are an array).
  # @param location [String] The rack location of the node on this port.
  # @param inc [Fixnum] Usually 1 for sequential port numbering, or 2 for port numbering top and bottom row.
  def self.excel_xml_row(fd, start, end_val, v, location, inc )
          fd.puts <<-EOF
     <Row ss:Height="16">
      <Cell ss:StyleID="s68"/>
EOF
          gap = start + 9 * inc
          #Output the location
          (start..end_val).step(inc) do |i|
            l = location[v[i][9]]
            fd.print "    <Cell ss:StyleID=\"s71\"/>\n"  if i == gap
            fd.print "    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">"
            fd.print l == nil ? " " : "#{l[0]}/P#{"%02d"%v[i][7]}"
            fd.print "</Data></Cell>\n"
          end
          fd.print "    <Cell ss:StyleID=\"s70\"/>\n   </Row>\n"

          fd.puts <<-EOF
     <Row ss:Height="16">
      <Cell ss:StyleID="s68"/>
EOF
          #Output the name of the client node
          (start..end_val).step(inc) do |i|
            l = location[v[i][9]]
            fd.print "    <Cell ss:StyleID=\"s71\"/>\n"  if i == gap
            fd.print "    <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\">"
            fd.print "#{l == nil ? v[i][9] : "#{l[2]}/P#{"%02d"%v[i][7]}"}" # Don't have a location : do have a location
            fd.print "</Data></Cell>\n"
          end
          fd.print "    <Cell ss:StyleID=\"s70\"/>\n   </Row>\n"
  end

  #Generates closing XML
  # @param fd [File] File descriptor for the output file
  def self.excel_xml_footer(fd)
    fd.puts <<-EOF
    </Table>
    <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
     <PageLayoutZoom>0</PageLayoutZoom>
     <Selected/>
     <Panes>
      <Pane>
       <Number>3</Number>
       <ActiveRow>10</ActiveRow>
       <ActiveCol>11</ActiveCol>
      </Pane>
     </Panes>
     <ProtectObjects>False</ProtectObjects>
     <ProtectScenarios>False</ProtectScenarios>
    </WorksheetOptions>
   </Worksheet>
  </Workbook>
  EOF
  end

end


