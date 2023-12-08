# Maven Archetype for Kawa Servlet

The archetype generates a project containing boilerplate code for a Kawa Scheme web application.

To install this archetype locally,

    mvn install # archetype:update-local-catalog

To use this archetype to create a new project,

    mvn archetype:generate -DarchetypeCatalog=local -DarchetypeGroupId=com.github.carld -DarchetypeArtifactId=maven-archetype-kawa-servlet -DarchetypeVersion=0.0.5 -DgroupId=xyz -DartifactId=myapp -DinteractiveMode=false -Dversion=0.0.0

