(module-name hello)

(require guenchi.json)

(response-header "Content-Type" "application/json")

(json->string `(("key1" . "value2")("key2" . "value2")("key3" . "value3") ) )

;(cond-expand
; (in-servlet
;   (require 'servlets)
;   (format "[servlet-context: ~s]" (current-servlet-context)))
; (else
;   "[Not in a servlet]"))
;
;#<p>Hello,
;    <b>&(request-remote-host)</b>!
;   <h2>&(request-method)</h2>
;</p>


