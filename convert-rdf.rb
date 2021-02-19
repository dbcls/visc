require 'bio-vcf'
require 'bio-vcf/vcffile'
require 'erb'
require 'pp'

module BioVcf
  class VcfRecord
    attr_reader :fields
    attr_accessor :record_number
    attr_accessor :source
    
    def to_ttl
      #TogoVar::Util::Variation.vcf_to_refsnp_location(pos, ref, alt.first)
      VISC::Convert.to_ttl(self)
    end
       
  end

  class VcfRecordInfo
    module BugFix
      def [](key)
        split_fields unless @h
        super
      end
    end

    prepend BugFix
  end
end

module VISC
  class VCF
    def initialize(filename, **options)
      @filename = filename
      @source = options.delete(:source)
    end

    def each
      return enum_for(:each) unless block_given?

      io = if @filename.match?(/\.gz$/)
             MultiGZipReader.open(@filename)
           else
             File.open(@filename)
           end

      header = BioVcf::VcfHeader.new

      record_number = 0

      io.each_line do |line|
        line.chomp!

        if line =~ /^##fileformat=/
          header.add(line)
          next
        end
        if line =~ /^#/
          header.add(line)
          next
        end

        fields = BioVcf::VcfLine.parse(line)
        rec = BioVcf::VcfRecord.new(fields, header)
        rec.record_number = (record_number += 1)
        rec.source = @source

        yield rec
      end
    end
  end

  class Convert
    class << self

      def reference_uri(chrom)
          case chrom
          when /NC_/
            "http://identifiers.org/refseq:#{chrom}"
          else
            # TODO HCO hco:1:GRCh37
          end
      end

      def normalized_alt(ref_vcf, alt_vcf, pos_vcf)
          ref = ref_vcf
          alt = alt_vcf
          pos = pos_vcf

          ref_vcf.each_char do |chr|
              if ref.length > 0 and alt.length > 0 and alt.start_with?(chr)
                  ref = ref.to_s.delete_prefix(chr)
                  alt = alt.to_s.delete_prefix(chr)
                  pos = pos + 1
              else
                 break 
              end
          end
          puts "### #{ref.inspect}, #{alt.inspect}, #{pos.inspect} = normalized_alt( #{ref_vcf.inspect}, #{alt_vcf.inspect}, #{pos_vcf.inspect})"
          return ref, alt, pos
      end

      def to_ttl_prefix
'
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix obo: <http://purl.obolibrary.org/obo/> .
@prefix sio: <http://semanticscience.org/resource/> .
@prefix faldo: <http://biohackathon.org/resource/faldo#> .
@prefix hco: <http://identifiers.org/hco/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix gvo: <http://genome-variation.org/resource/> .


'
      end

      def to_ttl(obj)
        puts to_ttl_prefix
        faldo_ref = reference_uri(obj.chrom)
        @nref, @nalt, @npos =  normalized_alt(obj.ref, obj.alt.first, obj.pos)
        #pp @nref, @nalt, @npos

        @obj = obj
        #pp @obj
        case obj.info['VC']
        when 'DEL'

           ERB.new(del).run
        when 'SNV'
           ERB.new(snv).run
        when 'INS'
           ERB.new(ins).run
        when 'INDEL'
           ERB.new(delins).run 
        when 'MNV'
           ERB.new(mnv).run                                
        else
          #pp obj
        end
      end
      def mnv
"
# #{@obj.fields.inspect}

[ 
  rdf:type gvo:MNV ;
  faldo:location [
    a faldo:Region ;
    faldo:begin #{@obj.pos} ;
    faldo:end #{@obj.pos + @obj.ref.length - 1} ;
    faldo:reference <http://identifiers.org/refseq:NC_000001.10>
  ];

  rdfs:seeAlso \"#{@obj.id}\" ;
  gvo:ref \"#{@nref}\" ;
  gvo:alt  \"#{@nalt}\" ;
  gvo:qual \"#{@obj.qual}\" ;
  gvo:filter \"#{@obj.filter}\" ;
  gvo:info []
  ];

] .
"
  # http://purl.obolibrary.org/obo/SO_0002007
  # sequence_feature > sequence_comparison> sequence_alteration > substitution > MNV
  # rdf:type gvo:MNV ;                               # variant type
  # rdfs:subClassOf obo:SO_0002007 ;                 # obo:SO_0002007 (MNV) 
  # rdfs:subClassOf obo:SO_0000001 ;               # obo:SO_0000001 (region)

      end
      def delins
"
# #{@obj.fields.inspect}

[ 

  rdf:type gvo:INDEL ;
  faldo:location [
    a faldo:Region ;
    faldo:begin [
      a faldo:InBetweenPosition ;
      faldo:after #{@npos} ;
      faldo:before #{@npos + 1} ;
      faldo:reference <#{reference_uri(@obj.chrom)}>
    ] ;
    faldo:end [
      a faldo:InBetweenPosition ;
      faldo:after #{@npos + @nref.length} ;
      faldo:before #{@npos + 1 + @nref.length } ;
      faldo:reference <#{reference_uri(@obj.chrom)}>
    ] 
  ];
  rdfs:seeAlso \"#{@obj.id}\" ;
  gvo:ref \"#{@nref}\" ;
  gvo:alt \"#{@alt}\" ;
  gvo:ref_vcf \"#{@obj.ref}\" ;
  gvo:alt_vcf  \"#{@obj.alt.first}\" ;
  gvo:qual \"#{@obj.qual}\" ;
  gvo:filter \"#{@obj.filter}\" ;
  gvo:info []
].
"
# rdfs:subClassOf obo:SO_0000366 ;               # obo:SO_0000366 (insertion_site)
# rdfs:subClassOf obo:SO_0000159 ;               # obo:SO_0000687 (deletion_junction)
# http://purl.obolibrary.org/obo/SO_1000032
# sequence_feature > sequence_comparison> sequence_alteration > delins
# rdfs:subClassOf obo:SO_1000032 ;                 # obo:SO_1000032 (delins)  
      end
      def ins
"
# #{@obj.fields.inspect}

[ 
  rdf:type gvo:Insertion ;
  faldo:location [
    a faldo:InBetweenPosition ;
    faldo:after #{@npos} ;      # info.pos
    faldo:before #{@npos + 1} ; # info.pos + 1
    faldo:reference <#{reference_uri(@obj.chrom)}> 
  ];

  rdfs:seeAlso \"#{@obj.id}\" ;
  gvo:ref \"#{@nref}\" ;
  gvo:alt \"#{@nalt}\" ;
  gvo:ref_vcf \"#{@obj.ref}\" ;
  gvo:alt_vcf  \"#{@obj.alt.first}\" ;
  gvo:qual \"#{@obj.qual}\" ;
  gvo:filter \"#{@obj.filter}\" ;
  gvo:info []

].
"
  # http://purl.obolibrary.org/obo/SO_0000667
  # sequence_feature > sequence_comparison> sequence_alteration > insertion
  # rdfs:subClassOf obo:SO_0000366 ;               # obo:SO_0000366 (insertion_site)
  # rdfs:subClassOf obo:SO_0000667 ;               # obo:SO_0000667 (insertion)
      end
      def del
"
# #{@obj.fields.inspect}

[ 
  rdf:type gvo:Deletion ; # vcf.info['VC']  = DEL
  faldo:location [
    a faldo:Region ;
    faldo:begin [
      a faldo:InBetweenPosition ;
      faldo:after #{@npos} ;
      faldo:before #{@npos + 1} ;
      faldo:reference <#{reference_uri(@obj.chrom)}>
    ] ;
    faldo:end [
      a faldo:InBetweenPosition ;
      faldo:after #{@npos + @nref.length} ;
      faldo:before #{@npos + 1 + @nref.length } ;
      faldo:reference <#{reference_uri(@obj.chrom)}>
    ] 
  ];

  rdfs:seeAlso \"#{@obj.id}\" ;
  gvo:ref \"#{@nref}\" ;
  gvo:alt \"#{@nalt}\" ;
  gvo:ref_vcf \"#{@obj.ref}\" ;
  gvo:alt_vcf  \"#{@obj.alt.first}\" ;
  gvo:qual \"#{@obj.qual}\" ;
  gvo:filter \"#{@obj.filter}\" ;
  gvo:info []
].
"
  # http://purl.obolibrary.org/obo/SO_0000159
  # sequence_feature > sequence_comparison> sequence_alteration > deletion
  # obo:SO_0000687 (deletion_junction)            
      end
      def snv
"
# #{@obj.fields.inspect}

[
  # dbSNP: vcf.info['VC'], ...
  rdf:type gvo:SNV ;
  faldo:location [
    a faldo:ExactPosition ;
    faldo:position #{@npos} ;
    faldo:reference <#{reference_uri(@obj.chrom)}> 
    # TODO
    faldo:reference hco:1:GRCh37 ;
  ];

  # vcf.id 
  rdfs:seeAlso \"#{@obj.id}\" ;
  # vcf.ref.normalized
  gvo:ref \"#{@nref}\" ;
  # vcf.alt.normalized
  gvo:alt \"#{@nalt}\" ;
  # vcf.qual
  gvo:qual \"#{@obj.qual}\" ;
  # vcf.filter
  gvo:filter \"#{@obj.filter}\" ;
  # TODO
  gvo:info []

].
"
  # sequence_feature > sequence_comparison> sequence_alteration > substitution > SNV
  # http://purl.obolibrary.org/obo/SO_0001483
  # obo:SO_0001236 (base)
  # TODO gvo:info [ rdf:label \"VC\"; sio:SIO_000300 \"DEL\"]
        end
    end
  end
end

vcf = VISC::VCF.new(ARGV[0])
vcf.each do |v|
 puts v.to_ttl
end
