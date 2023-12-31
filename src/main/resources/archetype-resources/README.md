# Kawa Scheme Servlet

This boilerplate code has been generated by maven-archetype-kawa-servlet

Implement your endpoints in `src/main/scheme/main.scm`.

## Developer Notes

### Logging

Use of `(format #t "Debugging ~a" exp)` for example will go to the catalina.out file, typically found in `/var/logs/tomcat9`.

### Web Server Gateway Interface in the style of PEP 333

The gateway/servlet.scm extends javax.servlet.http.HttpServlet and implements a WSGI style interface for
handling HTTP requests:

    (lambda (env)
       `(200 ((content-type . "text/plain")) "Hello, World!"))

This may be wrapped in one or middleware functions. A middleware function takes an app web handler
like the above, and returns one, for example:

		(lambda (app)
			(lambda (env)
        (format #t "Logging middleware: ~a~%" env)
				(let ((response (app env)))
					response)))

### SQL/JDBC and SSQL (Scheme SQL)

A database configuration can be setup by tuning resources/database.properties for the relevant environment.

Queries can be performed using for example:

    (sql-query (sql-connect) (ssql->str `(SELECT * FROM table1)))


### Deployment

The tomcat9 plugin can be used to deploy to a local tomcat instance:

    mvn tomcat9:redeploy

Alternatively the war file can be built and installed on a compatible application server.

    mvn package

### JSON

JSON is represented in scheme as an association list.  Conversion between this and a string can be
achieved using the included json.scm:

    (json->string   `(("field" . "value")) )
    (string->json   "{\"field\" : \"value\"}" )

### Kawa Maven plugin

This project will compile the Kawa scheme script in `src/main/scheme/main.scm`.

    mvn kawa:compile   # compile the scheme main.scm

If additional scheme scripts are added, they can be imported in main.scm, for example,
a module relative to main.scm, ./another/module.scm can be imported with:

   (import (another module))

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
                <str>@PROJECTROOT/src/main/scheme/another/module.scm</str> <!-- additional file -->
                <!--
                   Kawa scheme files can be added for compilation here,
                   or otherwise compiled by being required in main.scm.
                -->
            </compileCommand>
          </configuration>
          <!-- ... elements follow ... -->
       </plugin>

### Tomcat deployment

The tomcat9-maven-plugin requires configuration for tomcat user and password, in maven `~/.m2./settings.xml`.

Ensure that the <id> value matches the <server> value in the tomcat9-maven-plugin <configuration>.

In the `~/.m2/settings.xml`

    <?xml version="1.0" encoding="UTF-8"?>
    <settings >
      <servers>
        <server>
          <id>tomcat-server</id>
          <username>...</username>
          <password>...</password>
        </server>
      </servers>
    </settings>

In the pom.xml

    <configuration>
      <server>tomcat-server</server>
      <url>http://localhost:8080/manager/text</url>
    </configuration>

The user will need to have been added to tomcat-users.xml

    <user username="..." password="..." roles="manager-script"/>

Changes to this file may not be observed until tomcat is restarted:

    sudo systemctl restart tomcat9


### Updating maven plugins

The plugins in the pom.xml may become out of date. Check for updates:

    mvn versions:display-plugin-updates

