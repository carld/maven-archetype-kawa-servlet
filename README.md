# Maven Archetype for Kawa Servlet

To install this archetype locally,

    mvn install archetype:update-local-catalog
    mvn archetype:crawl

To use this archetype,

    mvn archetype:generate -DarchetypeCatalog=local -DarchetypeGroupId=com.github.carld -DarchetypeArtifactId=maven-archetype-kawa-servlet -DarchetypeVersion=0.0.2 -DgroupId=xyz -DartifactId=myapp -DinteractiveMode=false -Dversion=0.0.0



## Tomcat deployment

The tomcat9-maven-plugin requires configuration for tomcat user and password, in maven settings.xml:

    <?xml version="1.0" encoding="UTF-8"?>
    <settings >
        <servers>
            <server>
                <id>apache.snapshots.https</id>
                <username>admin</username>
                <password>password</password>
            </server>
        </servers>
    </settings>

