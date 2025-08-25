# Schema Flattener

Taken from https://github.com/pkielgithub/SchemaLightener

This is an xslt v2 stylesheet (and it's dependencies) - hence, they need saxon to run the transformation.

## Background

This stylesheet is used to transform our `xsd/rcf_actvity.xsd` schema (and it's many, many separate parts), into a single xsd file which makes validation in libxmljs2 MUCH quicker.

The idea is that we will create a 'minified' verions of the schema which can be used in project build, CAPE, web services etc to make transformation quicker when required.

The viewer uses the compiled xmllint / libxml libraries and doesn't suffer from the same performance issues as the js libxmljs2 libraries.


## Running the transformation

### To run it from *java* it should be as simple as :

```
java -jar path/to/saxon9he.jar 
	-s:./path/to/rcf_activity.xsd 
	-xsl:./path/to/SchemaFlattener.xslt
	resultBasePath=xsd/concatenated
```

This will create a new version of the `rcf_activity.xsd` file in the `xsd/concatenated` folder which will have all the other schema files inserted inside.

The build process can either just include this file, or leave as is and the dependent projects can decide to use the concatenated files if they wish.


### Node Scripts

There is a now a node script to run the transformation -

```
node scripts/concatenateSchemas.js
```

This will create 
