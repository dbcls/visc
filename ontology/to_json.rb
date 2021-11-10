require "json"
require "csv"

hash_ary = []
# owl id  rdf:type  rdfs:label  rdfs:subClassOf name  skos:altLabel skos:match  SO  VariO Sequence Variant Nomenclature dbSNP EVA dbVar Variant Call Type dbVar Variant Region Type gnomAD SV                           
#File.open("gvo.json","w") do |json|
  CSV.foreach("gvo-class.tsv",col_sep: "\t", headers: true) do |row|
    next unless row[1]
    #h = { id: row[1], name: row[2]||"", synonyms: row[3], so: row[4], vario: row[5], hgvs: row[6], check: row[0]}
    h = { 
        id: row[1],
        rdf_type: row[2],
        rdfs_label: row[3],
        rdfs_subClassOf: row[4],
        name: row[5],
        skos_altLable: row[6],
        skos_match: row[7],
        SO: row[8],
        VariO: row[9],
        hgvs: row[10],
        dbSNP: row[11],
        EVA: row[12],
        dbVar_variant_call_type: row[13],
        dvVar_variant_region_type: row[14],
        gnomAD: row[15],
        check: row[0]
    }
    hash_ary << h
  end
  #JSON.dump(hash_ary,json) #to_jsonを使用
  puts JSON.pretty_generate(hash_ary)
#end
