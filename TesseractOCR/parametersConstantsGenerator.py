#!/usr/bin/python
import subprocess
import os
import re
from time import gmtime, strftime

### Converter settings: ###

repo = "https://code.google.com/p/tesseract-ocr/"
repoTag = "3.03-rc1"

baseHeadersDir = "tesseract-ocr"
headers = [
    "ccmain/tesseractclass.h",
    "classify/classify.h",
    "dict/dict.h",
    "textord/textord.h",
    "textord/makerow.cpp",
    "wordrec/language_model.h",
    "wordrec/wordrec.h",
]
resultClassPath = "./"
resultClassName = "G8TesseractParameters"
varPrefix = "kG8Param"
varPattern = re.compile('(\w*)(_VAR_H|_VAR)\(([^,]*), ([^,]*|"[^"]*"),([^;]*)\);')

### Constants: ###

copyrights = '''//
//  %s
//  Tesseract OCR iOS
//  This code is auto-generated from Tesseract headers.
//
//  Created by Nikolay Volosatov on %s.
//  Copyright (c) %s Daniele Galiotto - www.g8production.com. 
//  All rights reserved.
//
''' % ("%s", strftime("%d/%m/%y", gmtime()), strftime("%Y", gmtime()))

headerTemplate = '''%s
#import <Foundation/Foundation.h>

#ifndef Tesseract_OCR_iOS_%s_h
#define Tesseract_OCR_iOS_%s_h
%s
#endif
''' % (copyrights % (resultClassName + '.h'), resultClassName, resultClassName, "%s")

codeTemplate = '''%s
#import "%s.h"

%s''' % (copyrights % (resultClassName + '.m'), resultClassName, "%s")

externVarTemplate = '''
///%s
///@param Type %s
///@param Default %s
extern NSString *const %s;
'''
depricatedExternVarTemplate = '''
///%s
///@param Type %s
///@param Default %s
extern NSString *const %s DEPRECATED_ATTRIBUTE;
'''
codeVarTemplate = 'NSString *const %s = @"%s";\n'

def bash(cmd, cwd=None):
    print(cmd)
    print(subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, cwd=cwd).stdout.read())

### Clone/pull repo ###

if not os.path.exists(baseHeadersDir):
    bash('git clone ' + repo + ' ' + baseHeadersDir)
    bash('cd ' + baseHeadersDir + ' && git checkout tags/' + repoTag + ' && cd ..')

### Read tesseractclass.h file ###

actualContent = ""
depricatedContent = ""
for header in headers:
    f = open(baseHeadersDir + "/" + header, "r")
    content = str(f.read())
    f.close()
    # Split actual and depricated parameters
    splited = content.split('BEGIN DEPRECATED PARAMETERS')
    if not len(splited) == 2:
        splited = (splited[0], "")
    (newActualContent, newDepricatedContent) = splited
    actualContent = actualContent + '\n' + newActualContent
    depricatedContent = depricatedContent + '\n' + newDepricatedContent

### Parse parameters from content ###

def parse(someContent):
    result = varPattern.finditer(someContent)

    variables = dict()
    for match in result:
        varType         = match.group(1)
        varName         = match.group(3)
        varDefault      = match.group(4)
        varDescription  = match.group(5)

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

### Format result content ###

for (objCVarName,(varType, varName, varDefault, varDescription)) in parse(actualContent):
    hContent = hContent + (externVarTemplate % (varDescription, varType, varDefault, objCVarName))
    mContent = mContent + (codeVarTemplate % (objCVarName, varName))
    print '%s %s = %s' % (varType, objCVarName, varName)

for (objCVarName,(varType, varName, varDefault, varDescription)) in parse(depricatedContent):
    hContent = hContent + (depricatedExternVarTemplate % (varDescription, varType, varDefault, objCVarName))
    mContent = mContent + (codeVarTemplate % (objCVarName, varName))
    print '%s %s = %s' % (varType, objCVarName, varName)

### Write .h and .m files ###

f = open(resultClassName + ".h", "w")
f.write(headerTemplate % hContent)
f.close()

f = open(resultClassName + ".m", "w")
f.write(codeTemplate % mContent)
f.close()
