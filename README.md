# Maven Archetype for Kawa Servlet

To install this archetype locally,

    mvn install archetype:update-local-catalog
    mvn archetype:crawl

To use this archetype,

    mvn archetype:generate -DarchetypeCatalog=local -DarchetypeGroupId=com.github.carld -DarchetypeArtifactId=maven-archetype-kawa-servlet -DarchetypeVersion=0.0.1 -DgroupId=pipedreams -DartifactId=journal-rest-api -DinteractiveMode=false -Dversion=0.0.0

