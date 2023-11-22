# Kawa Servlet from Archetype

## Kawa plugin

This project will compile the Kawa scheme script in `src/main/scheme/main.scm`.

    mvn compile
    # or
    mvn kawa:compile

If additional scheme scripts are added, they can be required in main.scm, for example,

   (require another)

or, add as an additional file to be compiled in the pom.xml under the <configuration>
for the kawa-maven-plugin. For example,

        <plugin>
          <groupId>com.github.arvyy</groupId>
          <artifactId>kawa-maven-plugin</artifactId>
          <version>0.0.8</version>
          <configuration>
            <compileCommand>
                <str>java</str>
                <str>-Dkawa.import.path=@KAWAIMPORT@SEPARATOR@PROJECTROOT/src/main/scheme</str>
                <str>kawa.repl</str>
                <str>--target</str>
                <str>6</str>
                <str>--servlet</str>
                <str>-d</str>
                <str>@PROJECTROOT/src/main/webapp/WEB-INF/classes</str>
                <str>-C</str>
                <str>@PROJECTROOT/src/main/scheme/main.scm</str>
                <str>@PROJECTROOT/src/main/scheme/another.scm</str> <!-- additional file -->
                <!--
                   Kawa scheme files can be added for compilation here,
                   or otherwise compiled by being required in main.scm.
                -->
            </compileCommand>
          </configuration>
          <!-- ... elements follow ... -->
       </plugin>

## Tomcat deployment

The tomcat9-maven-plugin requires configuration for tomcat user and password, in maven settings.xml:

    <?xml version="1.0" encoding="UTF-8"?>
    <settings >
      <servers>
        <server>
          <id>apache.snapshots.https</id>
          <username>robot</username>
          <password>robot</password>
        </server>
      </servers>
    </settings>

The user will need to have been added to tomcat-users.xml, with the manager-script role:

    <user username="robot" password="robot" roles="manager-script"/>

Changes to this file may not be observed until tomcat is restarted:

    sudo systemctl restart tomcat9



