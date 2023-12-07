(define-library (gateway servlet)

  (export servlet)

  (import (kawa base))
  (import (gateway wsgi))  ; provides the *app*
  (import (misc))
  (import (gateway urlencoding))

  (import (class javax.servlet.http HttpServlet))
  (import (class javax.servlet.http HttpServletRequest))
  (import (class javax.servlet.http HttpServletResponse))
  (import (class javax.servlet ServletException))
  (import (class java.io InputStreamReader))
  (import (class java.io BufferedReader))
  (import (class java.io IOException))
  (import (class gnu.mapping CallContext))

  (define-simple-class servlet (HttpServlet)

					; Kawa compiles top-level expressions into a `run` method.
					; Thus the top-level of the module can be executed
					; by calling run.
					;
					; When the serverlet container calls `init`,
					; init can call run to execute the top-level of the module.
					;
					; run is declared as an abstract method here as a
					; check that this servlet class has been subclassed by
					; a scheme module that has a top level.

    ((run context :: CallContext) :: void #!abstract)

					; The servlet container will call the init method on a servlet
					; when it is put into service.
    ((init) :: void
     (run (CallContext:getInstance)))

    #;((destroy) )

					; Description of this servlet for display purposes
    ((getServletInfo) :: String
     "Kawa Servlet Application")

					; The servlet container will call `service` when there is a request for this servlet to respond to.
					; Call the *app* handler to handle the request
    ((service req :: HttpServletRequest res :: HttpServletResponse) :: void
     throws: (java.io.IOException javax.servlet.ServletException)


					; Parse URL encoded PUT request parameters into a compatible association list
					; PUT parameters are not handled the same way as POST parameters by the HttpServlet
					; this treats them as  application/x-www-form-urlencoded and returns an
					; association list of key . value where the value is a Java string[]
					; like a POST parameter map.

     (define parameters (cond ((string-ci=? (req:getMethod) "PUT")
			       (let ((reader (BufferedReader (InputStreamReader (req:getInputStream)))))
				 (url-decode (reader:readLine))))
			      (else (java-map->alist (req:getParameterMap)))))

					; create the environment that will be passed to the WSGI procedure
     (define environ
       `(
					; taken from Lack, which probably came from PEP 333
	 (request-method . ,(req:getMethod))
	 (script-name . ,(req:getServletPath))
	 (path-info   . ,(req:getPathInfo))
	 (query-string . ,(req:getQueryString))
	 (url-scheme  . ,(req:getScheme))
	 (server-name . ,(req:getLocalName))
	 (server-port . ,(req:getLocalPort))
	 (server-protocol . ,(req:getProtocol))
	 (request-uri . ,(req:getRequestURI))
	 (raw-body . ,(req:getInputStream))
	 (remote-addr . ,(req:getRemoteHost))
	 (remote-port . ,(req:getRemotePort))
	 (content-type . ,(req:getContentType))
	 (content-length . ,(req:getContentLength))
	 (headers . ,(req:getHeaderNames)) ; req:getHeaders headerName TODO

					; additional - specific to this implementation
	 (parameters . ,parameters)))

					; invoke the WSGI procedure
     (define response ((*app*) environ))

					; destructure the result of the WSGI procedure
     (define-values (code headers body) (apply values response))

					; respond to the client
     (define (add-header header-name header-value)
       (res:addHeader (stringify header-name)
		      (stringify header-value)))
     (for-each add-header (map car headers) (map cdr headers))
     (res:setStatus code)
     (res:setContentLength (length body))
     (invoke (res:getWriter) 'print body))))
