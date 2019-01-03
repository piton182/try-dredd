OBJECTS = dredd.yml api.raml src/users.js

dredd : $(OBJECTS) package.json node_modules/dredd app api.oas20.yaml
	./node_modules/dredd/bin/dredd

.gitignore :
	touch .gitignore

package.json :
	npm init --yes

node_modules/dredd :
	npm i dredd --save-dev

app : express src/users.js
	express --no-view app
	cd app && npm i
	cp src/users.js app/routes/users.js

express :
	npm i -g express-generator

api.oas20.yaml : ./node_modules/yamljs api.oas20.json
	./node_modules/yamljs/bin/json2yaml api.oas20.json > api.oas20.yaml

node_modules/yamljs : node_modules
	npm i yamljs --save-dev

api.oas20.json : api.raml node_modules/oas-raml-converter
	./node_modules/oas-raml-converter/lib/bin/converter.js --from RAML --to OAS20 ./api.raml > api.oas20.json

node_modules/oas-raml-converter : node_modules
	npm i oas-raml-converter --save-dev



.PHONY : clean

clean : clean-package.json clean-node_modules clean-app clean-api.oas20.yaml

clean-package.json :
	- rm package.json package-lock.json

clean-node_modules :
	- rm -rf node_modules

clean-app :
	- rm -rf app

clean-api.oas20.yaml : clean-api.oas20.json
	- rm api.oas20.yaml

clean-api.oas20.json :
	- rm api.oas20.json
