#!/usr/bin/python
import re
from time import gmtime, strftime

# Converter settings:
tesseractclass = "include/tesseract/tesseractclass.h"
resultClassPath = "./"
resultClassName = "G8TesseractParameters"
varPrefix = "kG8"

# Constants:
#pattern = re.compile('(\w*)_VAR_H\((.*),(.*),(.*)\);')
pattern = re.compile('(\w*)_VAR_H\(([^,]*), ([^,]*|"[^"]*"),([^;]*)\);')

headerTemplate = '''//
//  %s.h
//  Tesseract OCR iOS
//  This code is auto-generated from %s.
//
//  Created by Nikolay Volosatov on %s.
//  Copyright (c) %s Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Tesseract_OCR_iOS_%s_h
#define Tesseract_OCR_iOS_%s_h
%s
#endif
''' % (resultClassName, tesseractclass, strftime("%d/%m/%y", gmtime()), 
	strftime("%Y", gmtime()), resultClassName, resultClassName, "%s")

codeTemplate = '''//
//  %s.m
//  Tesseract OCR iOS
//  This code is auto-generated from %s.
//
//  Created by Nikolay Volosatov on %s.
//  Copyright (c) %s Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "%s.h"

%s
''' % (resultClassName, tesseractclass, strftime("%d/%m/%y", gmtime()), 
	strftime("%Y", gmtime()), resultClassName, "%s")

externVarTemplate = '\n///%s\n///@param Type %s\n///@param Default %s\nextern NSString *const %s;\n'
depricatedExternVarTemplate = '\n///%s\n///@param Type %s\n///@param Default %s\nextern NSString *const %s DEPRECATED_ATTRIBUTE;\n'
codeVarTemplate = 'NSString *const %s = @"%s";\n'

# Read tesseractclass.h file
f = open(tesseractclass, "r")
content = str(f.read())
f.close()

# Split actual and depricated parameters
(actualContent, depricatedContent) = content.split('BEGIN DEPRECATED PARAMETERS')

# Parse parameters from content
def parse(someContent):
	result = pattern.finditer(someContent)

	variables = dict()
	for match in result:
		varType 		= match.group(1)
		varName 		= match.group(2)
		varDefault 		= match.group(3)
		varDescription 	= match.group(4)

		subnames = varName.split('_')
		subnames = map(lambda s: s.title(), subnames)
		objCVarName = varPrefix + ''.join(subnames);

		varDefault = varDefault.strip()
		varDescription = ''.join(varDescription.split('"')).strip()
		varDescription = ' '.join(map(lambda s: s.strip(), varDescription.split('\n'))).strip()

		variables[objCVarName] = (varType, varName, varDefault, varDescription)

	return variables.items()

hContent = ''
mContent = ''

# Format result content
for (objCVarName,(varType, varName, varDefault, varDescription)) in parse(actualContent):
	hContent = hContent + (externVarTemplate % (varDescription, varType, varDefault, objCVarName))
	mContent = mContent + (codeVarTemplate % (objCVarName, varName))
	print '%s %s = %s' % (varType, objCVarName, varName)

for (objCVarName,(varType, varName, varDefault, varDescription)) in parse(depricatedContent):
	hContent = hContent + (depricatedExternVarTemplate % (varDescription, varType, varDefault, objCVarName))
	mContent = mContent + (codeVarTemplate % (objCVarName, varName))
	print '%s %s = %s' % (varType, objCVarName, varName)

# Write .h and .m files
f = open(resultClassName + ".h", "w")
f.write(headerTemplate % hContent)
f.close()

f = open(resultClassName + ".m", "w")
f.write(codeTemplate % mContent)
f.close()
