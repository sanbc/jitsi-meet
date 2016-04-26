NPM = npm
BROWSERIFY = ./node_modules/.bin/browserify
UGLIFYJS = ./node_modules/.bin/uglifyjs
EXORCIST = ./node_modules/.bin/exorcist
CLEANCSS = ./node_modules/.bin/cleancss
CSS_FILES = font.css toastr.css main.css videolayout_default.css font-awesome.css jquery-impromptu.css modaldialog.css notice.css popup_menu.css login_menu.css popover.css jitsi_popover.css contact_list.css chat.css welcome_page.css settingsmenu.css feedback.css
DEPLOY_DIR = libs
BROWSERIFY_FLAGS = -d
OUTPUT_DIR = .
LIBJITSIMEET_DIR = node_modules/lib-jitsi-meet/

all: update-deps compile deploy clean

update-deps:
	$(NPM) update

compile:
	$(BROWSERIFY) $(BROWSERIFY_FLAGS) -e app.js -s APP -o $(OUTPUT_DIR)/app.bundle.js

clean:
	rm -f $(OUTPUT_DIR)/app.bundle.*

deploy: deploy-init deploy-appbundle deploy-lib-jitsi-meet deploy-css deploy-local

deploy-init:
	mkdir -p $(DEPLOY_DIR)

deploy-appbundle:
	cp $(OUTPUT_DIR)/app.bundle.js \
	$(DEPLOY_DIR)

deploy-lib-jitsi-meet:
	cp $(LIBJITSIMEET_DIR)/lib-jitsi-meet.js \
	$(LIBJITSIMEET_DIR)/connection_optimization/external_connect.js \
	$(DEPLOY_DIR)
deploy-css:
	(cd css; cat $(CSS_FILES)) | $(CLEANCSS) > css/all.css

deploy-local:
	([ ! -x deploy-local.sh ] || ./deploy-local.sh)




source-package:
	mkdir -p source_package/jitsi-meet/css && \
	cp -r analytics.js external_api.js favicon.ico fonts images index.html interface_config.js libs plugin.*html sounds title.html unsupported_browser.html LICENSE config.js lang source_package/jitsi-meet && \
	cp css/all.css source_package/jitsi-meet/css && \
	cp css/unsupported_browser.css source_package/jitsi-meet/css && \
	(cd source_package ; tar cjf ../jitsi-meet.tar.bz2 jitsi-meet) && \
	rm -rf source_package
