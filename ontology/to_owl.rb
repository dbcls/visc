#!/usr/bin/env ruby

require 'rubygems'
require 'pp'
require 'date'
require "json"

module GVO
class Writer

  def initialize(core_ttl, json_file, version = nil)
    #@version =  version || Date.today.strftime("%Y%m%d")
    begin
      File.open(core_ttl) do |ttl|
          @ttl = ttl.read
      end
      File.open(json_file) do |json|
        @owl_class = JSON.load(json)
      end
      #pp @owl_class
    rescue SystemCallError => e
      puts %Q(class=[#{e.class}] message=[#{e.message}])
    rescue IOError => e
      puts %Q(class=[#{e.class}] message=[#{e.message}])
    rescue
      raise Errno::ENOENT
      []
    end
    puts @ttl
    puts write_class
  end

  def write_class
    text = <<~"EOS"
      gvo:Variation rdf:type owl:Class ;
        rdfs:label "variation"@en .

    EOS
#   {
#    "id": "single_nucleotide_variant",
#    "rdf_type": "gvo:SNV",
#    "rdfs_label": "Single nucleotide variant",
#    "rdfs_subClassOf": null,
#    "name": "single nucleotide variant",
#    "skos_altLable": "SNV",
#    "skos_match": null,
#    "SO": "http://purl.obolibrary.org/obo/SO_0001483",
#    "VariO": "http://purl.obolibrary.org/obo/VariO_0136",
#    "hgvs": "http://varnomen.hgvs.org/recommendations/DNA/variant/substitution/",
#    "dbSNP": "SNV",
#    "EVA": "SNV",
#    "dbVar_variant_call_type": null,
#    "dvVar_variant_region_type": null,
#    "gnomAD": null,
#    "check": "TRUE"
#  },
        
    @owl_class.each do |c|
#      class_name = c['id'].capitalize
#
#      text += <<~"EOS"
#        gvo:#{class_name} rdf:type owl:Class ;
#          #{write_line_synonym(c['synonyms'])}
#          rdfs:subClassOf gvo:Variation ;
#          rdfs:label "#{c['name']}" .
#          
#      EOS

      text += <<~"EOS"
        #{c['rdf_type']} rdf:type owl:Class ;
          #{write_line_synonym(c['skos_altLable'])}
          rdfs:subClassOf #{write_subclass(c)} ;
          rdfs:label "#{c['rdfs_label']}"@en .
          
      EOS
    end
    text
  end

  def write_subclass c
      c['rdfs_subClassOf'].nil? ? "gvo:Variation" : c['rdfs_subClassOf']
  end

  def write_line_synonym(synonym)
    synonym.nil? ? "" : "skos:altLabel \"#{synonym}\"@en ;"
  end
  
end
end

GVO::Writer.new(ARGV[0],ARGV[1])
