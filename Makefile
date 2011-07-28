DIST_DIR = build
SRC_DIR = src
LIB_DIR = lib

COMPILER_DIR = ${LIB_DIR}/compiler

JAVA_BIN ?= `which java`
COMPILER_BIN = ${COMPILER_DIR}/compiler.jar
CLOSURE_SRC = http://closure-compiler.googlecode.com/files/compiler-latest.zip
COMPILE = java -jar ${COMPILER_BIN} --js ${DIST_DIR}/twilio.js --js_output_file ${DIST_DIR}/twilio.min.js --warning_level QUIET

TWILIO_LIBS = ${SRC_DIR}/TwilioCapability.js

all: clean core min
	@@echo "Build complete."

core:
	@@echo "Building jwt-js..."
	@@cd ${LIB_DIR}/jwt-js && make

	@@echo "Building Twilio..."
	@@mkdir -p ${DIST_DIR}
	@@cat ${LIB_DIR}/jwt-js/${DIST_DIR}/jwt.js ${TWILIO_LIBS} > ${DIST_DIR}/twilio.js

min:
	@@if test ! -z ${JAVA_BIN}; then \
		if [ -a ${COMPILER_BIN} ]; then \
			echo "Minifying..."; \
			${COMPILE}; \
		else \
			echo "Google Closure needed to minify."; \
			echo "Downloading Google Closure..."; \
			mkdir -p ${COMPILER_DIR}; \
			cd ${COMPILER_DIR} && curl ${CLOSURE_SRC} -O; \
			unzip -o compiler-latest.zip; \
			rm compiler-latest.zip; \
			cd ../../; \
			echo "Minifying..."; \
			${COMPILE}; \
		fi \
	else \
		echo "You must have Java to minify."; \
	fi

clean:
	@@rm -rf build
	@@rm -rf ${LIB_DIR}/jwt-js/build

cleanall: clean
	@@rm -rf ${COMPILER_DIR}