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

      def template2ttl(type)
        #root = Pathname.getwd #=> #<Pathname:/home/zzak/projects/ruby>
        template = File.read(File.expand_path("../template/#{type.downcase}.erb", __FILE__))
        #template = File.read("#{root}/template/#{type.downcase}.erb")
        #ttl = ERB.new(template).run
        ttl = ERB.new(template).result( binding )
        puts ttl
        
      end

      def to_ttl(obj)
        @obj = obj
        puts to_ttl_prefix unless @prefix
        @prefix = true

        puts "### " + @obj.fields.inspect

        obj.alt.each do |alt_mono|
          faldo_ref = reference_uri(obj.chrom)
          #@nref, @nalt, @npos =  normalized_alt(obj.ref, obj.alt.first, obj.pos)
          @nref, @nalt, @npos =  normalized_alt(obj.ref, alt_mono, obj.pos)

          #@obj = obj
          @alt_mono_vcf = alt_mono
          #@alt_mono = alt_mono
          case obj.info['VC']
          when 'DEL','SNV','INS','INDEL','MNV'
            template2ttl(obj.info['VC'])
          else
            case obj.info['SVTYPE']
              #CNV, BND
                pp obj
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
