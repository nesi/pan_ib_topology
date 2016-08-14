#!/usr/local/bin/ruby
require_relative 'rlib/configuration.rb'
require_relative 'rlib/iblinkinfo_parser.rb'
require_relative 'generators/gen_dot.rb'
require_relative 'generators/gen_excel_xml.rb'
require_relative 'generators/gen_tsv.rb'
require_relative 'generators/gen_wiki.rb'
require_relative 'generators/gen_wiki_old.rb'
require_relative 'generators/gen_yml.rb'
require_relative 'generators/gen_slurm.rb' #Slurm topology file

config_file = ARGV[0] == 'test' ? File.expand_path(File.dirname(__FILE__)) + '/conf/local_config.json' : File.expand_path(File.dirname(__FILE__)) + '/conf/config.json'
@config = Configuration.new config_file
#@auth = Configuration.new((@config.auth[0] == '/') ? @config.auth : File.expand_path(File.dirname(__FILE__)) + @config.auth)
begin
  Dir.chdir(@config.base_directory)

  #iblinkinfo = IBLinkInfo.new('iblinkinfo.txt') #Get iblinkinfo from a file
  iblinkinfo = IBLinkInfo.new(@config.iblinkinfo_cmd, true)  #Get iblinkinfo by executing the iblinkinfo command.

  #TSV::gen(iblinkinfo, 'iblinkinfo.tsv') #generate a tab separated file, we could load into excel
  #Excel_XML::gen(iblinkinfo, 'iblinkinfo.xml') #Generate an XML file, to be read by Excel (adds formating that we can't have in tsv)
  #DOT::gen(iblinkinfo, '/tmp/iblinkinfo.dot', @config.dot_cmd) #Generate a dot file for input into Grophviz 
  #WIKI::gen(iblinkinfo, 'iblinkinfo_wiki.txt') #Generate Confluence Wiki tables for the switches, then manually add.
  #WIKI_Old::gen(iblinkinfo', 'iblinkinfo_wiki_old.txt') #Old confluence wiki table format.
  #YML::gen(iblinkinfo, 'iblinkinfo.yml') #Generate a YML file from the IBlinkinfo output
  SLURM::gen(iblinkinfo, 'topology.conf') #Generate an Infiniband topology file for Slurm
rescue Exception=>error
  puts error
end


