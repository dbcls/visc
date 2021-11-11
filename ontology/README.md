# Genome variation ontology

All inclusive ontology for genomic variations.
GVO covers simple variants and structural variations.
Terms are aggregated and curated from dbSNP, dbVar, gnomAD, SO, VariO, and HGVS.

## Resources

* [Official site](http://genome-variation.org/)
* [BioPortal](https://bioportal.bioontology.org/ontologies/GVO)

## Authors

* Takatomo Fujisawa ([DDBJ](https://www.ddbj.nig.ac.jp/))
* Shuichi Kawashima ([DBCLS](http://dbcls.jp/))
* Toshiaki Katayama ([DBCLS](http://dbcls.jp/))
* [VISC](https://github.com/dbcls/visc)

## How to update GVO

Edit gvo.ttl directly (with an ontology editor etc.).

## Original procedure to generate the gvo.ttl file

```
curl -L "https://docs.google.com/spreadsheets/d/e/2PACX-1vQJj9pKSyq-3noeWEy8TMfCA0keidZ_4Q1HpyFFVZgck-uSZtGqws08l0RH9hPeXeG1CMbRS2WTjy7l/pub?gid=0&single=true&output=tsv" -o gvo-class.tsv
ruby to_json.rb > gvo-class.json
ruby to_owl.rb template.ttl gvo-class.json  > gvo_raw.ttl
rapper -g -o turtle gvo_raw.ttl  > gvo.ttl
```
