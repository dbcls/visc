require 'bio-vcf'
require 'bio-vcf/vcffile'
require 'erb'
require "pathname"


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
            uri = "http://identifiers.org/refseq:#{chrom}"
          when "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y"
             #FIXME Add Assembly
             #TODO HCO hco:1:GRCh37
             uri= "http://identifiers.org/hco/#{chrom.to_s}"
          else
            # TODO HCO hco:1:GRCh37
            uri ='HOGE'
          end
          #pp uri
          uri
      end

      def normalized(ref_vcf, alt_vcf, pos_vcf, type_vcf)
          ref = ref_vcf
          alt = alt_vcf
          pos = pos_vcf
          type = type_vcf

          case alt 
          when /^(.+)\[(.+)\[$/
              t,p, where, coord,strand = $1, $2,'after', '+',''
          when /^(.+)\](.+)\]$/
              t, p, where, coord,strand = $1, $2,'after', '-','revcon'
          when /^\](.+)\](.+)$/  
              t, p, where, coord,strand = $2, $1,'before','-',''
          when /^\[(.+)\[(.+)$/
              t, p, where, coord,strand = $2, $1,'before', '+','revcon'
          end    
          chr2, pos2 = p.split(":")
          #pp [t, chr2, pos2, where, coord, strand]
          pos2 = pos2.to_i 

          @strand_type2 = strand == 'revcon' ? 'ReverseStrandPostion' : 'ForwardStrandPosition' 
          
# breakend
#REF ALT Meaning
#s t[p[ piece extending to the right of p is joined after t
#s t]p] reverse comp piece extending left of p is joined after t
#s ]p]t piece extending to the left of p is joined before t
#s [p[t reverse comp piece extending right of p is joined before t
          if where == 'before'
            ref_vcf.each_char do |chr|
              if ref.length > 0 and alt.length > 0 and alt.end_with?(chr)  
                  ref = ref.to_s.delete_prefix(chr)
                  alt = alt.to_s.delete_suffix(chr)
                  pos = pos + 1
                  #pos2 = strand == 'revcon' ? pos2 - 1 : pos2 + 1
              else
                  break
              end
            end
          else    
            ref_vcf.each_char do |chr|
              if ref.length > 0 and alt.length > 0 and alt.start_with?(chr)
                  ref = ref.to_s.delete_prefix(chr)
                  alt = alt.to_s.delete_prefix(chr)
                  pos = pos + 1
                  #pos2 = strand == 'revcon' ? pos2 - 1 : pos2 + 1
              else
                 break 
              end
            end
          end
          #pp [t, chr2, pos2, where, coord, strand]
          @chr2 = chr2
          @pos2 = pos2


          case alt
          when /^\d+$/, ""
            if ref.length == alt.length and ref.length == 1 
              type = "SNV"
            elsif ref.length == alt.length and ref.length > 1 
              type = "MNV"
            elsif ref.length > 0 and alt.length == 0 
              type = "DEL"
            elsif ref.length == 0 and alt.length > 0
              type = "INS"
            end
          else
          end

          puts "### #{ref.inspect}, #{alt.inspect}, #{pos.inspect}, #{type.inspect} = normalized( #{ref_vcf.inspect}, #{alt_vcf.inspect}, #{pos_vcf.inspect}, #{type_vcf.inspect})"
          return ref, alt, pos, type
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

      def template2ttl(type)
        template = File.read(File.expand_path("../template/#{type.downcase}.erb", __FILE__))
        ttl = ERB.new(template).result( binding )
        puts ttl
        
      end

      def to_ttl(obj)
        @obj = obj
        puts to_ttl_prefix unless @prefix
        @prefix = true

        puts "### " + @obj.fields.inspect

        obj.alt.each do |alt_mono|
          #faldo_ref = reference_uri(obj.chrom)
          #@nref, @nalt, @npos, @ntype =  normalized(obj.ref, alt_mono, obj.pos, obj.info['VC'])

          @alt_mono_vcf = alt_mono

          case obj.info['VC']
          when 'DEL','SNV','INS','INDEL','MNV'
            @nref, @nalt, @npos, @ntype =  normalized(obj.ref, alt_mono, obj.pos, obj.info['VC'])
            template2ttl(@ntype)
          else
            case obj.info['SVTYPE']
              when 'CNV', 'BND'
                @nref, @nalt, @npos, @ntype =  normalized(obj.ref, alt_mono, obj.pos, obj.info['SVTYPE'])
                template2ttl(@ntype)
                #pp obj
              else
            begin 
              raise # エラーを発生させます。
            rescue => e
              STDERR.puts "error: unknown type on VCF" 
              STDERR.pp obj
              exit
            end
          end
          #p obj
          end
        end
      end
    end
  end
end

vcf = VISC::VCF.new(ARGV[0])
vcf.each do |v|
 #puts v.to_ttl
 v.to_ttl
end

#convert SNP-RDF 
# for i in variant-rdf-spec/SNP/*/*.vcf; do f=${i%.*}; echo $f; ruby convert-rdf.rb $i > $i.ttl; done
